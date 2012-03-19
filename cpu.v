/*
 * verilog-6502 project: verilog model of 6502 and 65Org16 CPU core
 *
 * (C) 2011 Arlet Ottens, <arlet@c-scape.nl>
 * (C) 2011 Ed Spittles, <ed.spittles@gmail.com>
 * (C) 2012 Sam Gaskill, <sammy.gasket@gmail.com> stripped BCD, removed SED,CLD opcodes, added full 16-bit IR decoding, added Arlet's updates from 5 months ago. Added B,C,D accumulators. Added full accumulator to accumulator transfer opcodes. Added BigEd's 16-bit barrel shifter logic.
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public
 *  License version 2.1 as published by the Free Software Foundation.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *
 *  
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 *
 *
 * Note that not all 6502 interface signals are supported (yet).  The goal
 * is to create an Acorn Atom model, and the Atom didn't use all signals on
 * the main board.
 *
 * The data bus is implemented as separate read/write buses. Combine them
 * on the output pads if external memory is required.
 */

module cpu( clk, reset, AB, DI, DO, WE, IRQ, NMI, RDY );

parameter dw = 16; // data width (8 for 6502, 16 for 65Org16)
parameter aw = 32; // address width (16 for 6502, 32 for 65Org16)

input clk;		// CPU clock 
input reset;		// reset signal
output reg [aw-1:0] AB;	// address bus
input [dw-1:0] DI;	// data in, read bus
output [dw-1:0] DO; 	// data out, write bus
output WE;		// write enable
input IRQ;		// interrupt request
input NMI;		// non-maskable interrupt request
input RDY;		// Ready signal. Pauses CPU when RDY=0 

/*
 * internal signals
 */
 
reg  [aw-1:0] PC;	// Program Counter 
reg  [dw-1:0] ABL;	// Address Bus Register LSB
reg  [dw-1:0] ABH;	// Address Bus Register MSB
wire [dw-1:0] ADD;	// Adder Hold Register (registered in ALU)

reg  [dw-1:0] DIHOLD;	// Hold for Data In
reg  DIHOLD_valid; 	//
wire [dw-1:0] DIMUX;	//

reg  [dw-1:0] IRHOLD;	// Hold for Instruction register 
reg  IRHOLD_valid;	// Valid instruction in IRHOLD

reg  [dw-1:0] PAXYS[18:0]; 	// A thru P, X, Y and S register file

reg  C = 0;		// carry flag (init at zero to avoid X's in ALU sim)
reg  Z = 0;		// zero flag
reg  I = 0;		// interrupt flag
reg  V = 0;		// overflow flag
reg  N = 0;		// negative flag
wire AZ;		// ALU Zero flag
wire AV;		// ALU overflow flag
wire AN;		// ALU negative flag

reg  [dw-1:0] AI;	// ALU Input A
reg  [dw-1:0] BI;  	// ALU Input B
reg  [3:0] E_Reg; // Shift Distance Register
wire [dw-1:0] DI;	// Data In
wire [dw-1:0] IR;	// Instruction register
reg  [dw-1:0] DO;	// Data Out 
reg  WE;		// Write Enable
reg  CI;		// Carry In
wire CO;		// Carry Out 
wire [dw-1:0] PCH = PC[aw-1:dw];
wire [dw-1:0] PCL = PC[dw-1:0];

reg NMI_edge = 0;	// captured NMI edge

reg [4:0] regsel;			// Select A thru P, X, Y or S register
wire [dw-1:0] regfile = PAXYS[regsel];	// Selected register output

parameter 
	SEL_A    = 5'd0,
	SEL_B		= 5'd1,
	SEL_C		= 5'd2,
	SEL_D		= 5'd3,
	SEL_E		= 5'd4,
	SEL_F		= 5'd5,
	SEL_G		= 5'd6,
	SEL_H		= 5'd7,
	SEL_I		= 5'd8,
	SEL_J		= 5'd9,
	SEL_K		= 5'd10,
	SEL_L		= 5'd11,
	SEL_M		= 5'd12,
	SEL_N		= 5'd13,
	SEL_O		= 5'd14,
	SEL_P		= 5'd15,
	SEL_X	   = 5'd16,
	SEL_Y    = 5'd17,
	SEL_S    = 5'd18;
	
initial
	begin
		PAXYS[SEL_P] = 0;
		PAXYS[SEL_O] = 0;
		PAXYS[SEL_N] = 0;
		PAXYS[SEL_M] = 0;
		PAXYS[SEL_L] = 0;
		PAXYS[SEL_K] = 0;
		PAXYS[SEL_J] = 0;
		PAXYS[SEL_I] = 0;
		PAXYS[SEL_H] = 0;
		PAXYS[SEL_G] = 0;
		PAXYS[SEL_F] = 0;
		PAXYS[SEL_E] = 0;
		PAXYS[SEL_D] = 0;
		PAXYS[SEL_C] = 0;
		PAXYS[SEL_B] = 0;
		PAXYS[SEL_A] = 0;
		PAXYS[SEL_X] = 0;
		PAXYS[SEL_Y] = 0;
		PAXYS[SEL_S] = 16'hffff; //init stack
	end

/*
 * define some signals for watching in simulator output
 */


//`ifdef SIM
wire [dw-1:0]   Pacc = PAXYS[SEL_P];	// Accumulator
wire [dw-1:0]   Oacc = PAXYS[SEL_O];	// Accumulator
wire [dw-1:0]   Nacc = PAXYS[SEL_N];	// Accumulator
wire [dw-1:0]   Macc = PAXYS[SEL_M];	// Accumulator
wire [dw-1:0]   Lacc = PAXYS[SEL_L];	// Accumulator
wire [dw-1:0]   Kacc = PAXYS[SEL_K];	// Accumulator
wire [dw-1:0]   Jacc = PAXYS[SEL_J];	// Accumulator
wire [dw-1:0]   Iacc = PAXYS[SEL_I];	// Accumulator
wire [dw-1:0]   Hacc = PAXYS[SEL_H];	// Accumulator
wire [dw-1:0]   Gacc = PAXYS[SEL_G];	// Accumulator
wire [dw-1:0]   Facc = PAXYS[SEL_F];	// Accumulator
wire [dw-1:0]   Eacc = PAXYS[SEL_E];	// Accumulator
wire [dw-1:0]   Dacc = PAXYS[SEL_D];	// Accumulator
wire [dw-1:0]   Cacc = PAXYS[SEL_C];	// Accumulator
wire [dw-1:0]   Bacc = PAXYS[SEL_B];	// Accumulator
wire [dw-1:0]   Aacc = PAXYS[SEL_A];	// Accumulator
wire [dw-1:0]   X = PAXYS[SEL_X];	// X register
wire [dw-1:0]   Y = PAXYS[SEL_Y];	// Y register 
wire [dw-1:0]   S = PAXYS[SEL_S];	// Stack pointer
//`endif

wire [dw-1:0] P = { N, V, 2'b0, I, Z, C };

/*
 * instruction decoder/sequencer
 */

reg [5:0] state;

/*
 * control signals
 */

reg PC_inc;		// Increment PC
reg [aw-1:0] PC_temp; 	// intermediate value of PC 

reg [4:0] src_reg;	// source register index
reg [4:0] dst_reg;	// destination register index

reg index_y;		// if set, then Y is index reg rather than X 
reg load_reg;		// loading a register (A, B, C, D, X, Y, S) in this instruction
reg inc;		// increment
reg write_back;		// set if memory is read/modified/written 
reg load_only;		// LDA/LDX/LDY instruction
reg store;		// doing store (STA/STX/STY)
reg adc_sbc;		// doing ADC/SBC
reg compare;		// doing CMP/CPY/CPX
reg shift;		// doing shift/rotate instruction
reg rotate;		// doing rotate (no shift)
reg backwards;		// backwards branch
reg cond_true;		// branch condition is true
reg [2:0] cond_code;	// condition code bits from instruction
reg shift_right;	// Instruction ALU shift/rotate right 
reg alu_shift_right;	// Current cycle shift right enable
reg [3:0] op;		// Main ALU operation for instruction
reg [3:0] alu_op;	// Current cycle ALU operation 

/* 
 * some flip flops to remember we're doing special instructions. These
 * get loaded at the DECODE state, and used later
 */
 
reg bit;		// doing BIT instruction
reg plp;		// doing PLP instruction
reg php;		// doing PHP instruction 
reg clc;		// clear carry
reg sec;		// set carry
reg cli;		// clear interrupt
reg sei;		// set interrupt
reg clv;		// clear overflow 
reg brk;		// doing BRK

reg res;		// in reset

/*
 * ALU operations
 */

parameter
	OP_OR  = 4'b1100,
	OP_AND = 4'b1101,
	OP_EOR = 4'b1110,
	OP_ADD = 4'b0011,
	OP_SUB = 4'b0111,
	OP_ROL = 4'b1011,
	OP_A   = 4'b1111;

/*
 * Microcode state machine. Basically, every addressing mode has its own
 * path through the state machine. Additional information, such as the
 * operation, source and destination registers are decoded in parallel, and
 * kept in separate flops. 
 */

parameter 
    ABS0   = 6'd0,  // ABS     - fetch LSB	
    ABS1   = 6'd1,  // ABS     - fetch MSB
    ABSX0  = 6'd2,  // ABS, X  - fetch LSB and send to ALU (+X)
    ABSX1  = 6'd3,  // ABS, X  - fetch MSB and send to ALU (+Carry)
    ABSX2  = 6'd4,  // ABS, X  - Wait for ALU (only if needed)
    BRA0   = 6'd5,  // Branch  - fetch offset and send to ALU (+PC[dw-1:0])
    BRA1   = 6'd6,  // Branch  - fetch opcode, and send PC[aw-1:dw] to ALU 
    BRA2   = 6'd7,  // Branch  - fetch opcode (if page boundary crossed)
    BRK0   = 6'd8,  // BRK/IRQ - push PCH, send S to ALU (-1)
    BRK1   = 6'd9,  // BRK/IRQ - push PCL, send S to ALU (-1)
    BRK2   = 6'd10, // BRK/IRQ - push P, send S to ALU (-1)
    BRK3   = 6'd11, // BRK/IRQ - write S, and fetch @ fffe
    DECODE = 6'd12, // IR is valid, decode instruction, and write prev reg
    FETCH  = 6'd13, // fetch next opcode, and perform prev ALU op
    INDX0  = 6'd14, // (ZP,X)  - fetch ZP address, and send to ALU (+X)
    INDX1  = 6'd15, // (ZP,X)  - fetch LSB at ZP+X, calculate ZP+X+1
    INDX2  = 6'd16, // (ZP,X)  - fetch MSB at ZP+X+1
    INDX3  = 6'd17, // (ZP,X)  - fetch data 
    INDY0  = 6'd18, // (ZP),Y  - fetch ZP address, and send ZP to ALU (+1)
    INDY1  = 6'd19, // (ZP),Y  - fetch at ZP+1, and send LSB to ALU (+Y) 
    INDY2  = 6'd20, // (ZP),Y  - fetch data, and send MSB to ALU (+Carry)
    INDY3  = 6'd21, // (ZP),Y) - fetch data (if page boundary crossed)
    JMP0   = 6'd22, // JMP     - fetch PCL and hold
    JMP1   = 6'd23, // JMP     - fetch PCH
    JMPI0  = 6'd24, // JMP IND - fetch LSB and send to ALU for delay (+0)
    JMPI1  = 6'd25, // JMP IND - fetch MSB, proceed with JMP0 state
    JSR0   = 6'd26, // JSR     - push PCH, save LSB, send S to ALU (-1)
    JSR1   = 6'd27, // JSR     - push PCL, send S to ALU (-1)
    JSR2   = 6'd28, // JSR     - write S
    JSR3   = 6'd29, // JSR     - fetch MSB
    PULL0  = 6'd30, // PLP/PLA - save next op in IRHOLD, send S to ALU (+1)
    PULL1  = 6'd31, // PLP/PLA - fetch data from stack, write S
    PULL2  = 6'd32, // PLP/PLA - prefetch op, but don't increment PC
    PUSH0  = 6'd33, // PHP/PHA - send A to ALU (+0)
    PUSH1  = 6'd34, // PHP/PHA - write A/P, send S to ALU (-1)
    READ   = 6'd35, // Read memory for read/modify/write (INC, DEC, shift)
    REG    = 6'd36, // Read register for reg-reg transfers
    RTI0   = 6'd37, // RTI     - send S to ALU (+1)
    RTI1   = 6'd38, // RTI     - read P from stack 
    RTI2   = 6'd39, // RTI     - read PCL from stack
    RTI3   = 6'd40, // RTI     - read PCH from stack
    RTI4   = 6'd41, // RTI     - read PCH from stack
    RTS0   = 6'd42, // RTS     - send S to ALU (+1)
    RTS1   = 6'd43, // RTS     - read PCL from stack 
    RTS2   = 6'd44, // RTS     - write PCL to ALU, read PCH 
    RTS3   = 6'd45, // RTS     - load PC and increment
    WRITE  = 6'd46, // Write memory for read/modify/write 
    ZP0    = 6'd47, // Z-page  - fetch ZP address
    ZPX0   = 6'd48, // ZP, X   - fetch ZP, and send to ALU (+X)
    ZPX1   = 6'd49; // ZP, X   - load from memory

//`ifdef SIM

/*
 * easy to read names in simulator output
 */
reg [8*6-1:0] statename;

always @*
    case( state )
	    DECODE: statename = "DECODE";
	    REG:    statename = "REG";
	    ZP0:    statename = "ZP0";
	    ZPX0:   statename = "ZPX0";
	    ZPX1:   statename = "ZPX1";
	    ABS0:   statename = "ABS0";
	    ABS1:   statename = "ABS1";
	    ABSX0:  statename = "ABSX0";
	    ABSX1:  statename = "ABSX1";
	    ABSX2:  statename = "ABSX2";
	    INDX0:  statename = "INDX0";
	    INDX1:  statename = "INDX1";
	    INDX2:  statename = "INDX2";
	    INDX3:  statename = "INDX3";
	    INDY0:  statename = "INDY0";
	    INDY1:  statename = "INDY1";
	    INDY2:  statename = "INDY2";
	    INDY3:  statename = "INDY3";
	     READ:  statename = "READ";
	    WRITE:  statename = "WRITE";
	    FETCH:  statename = "FETCH";
	    PUSH0:  statename = "PUSH0";
	    PUSH1:  statename = "PUSH1";
	    PULL0:  statename = "PULL0";
	    PULL1:  statename = "PULL1";
	    PULL2:  statename = "PULL2";
	    JSR0:   statename = "JSR0";
	    JSR1:   statename = "JSR1";
	    JSR2:   statename = "JSR2";
	    JSR3:   statename = "JSR3";
	    RTI0:   statename = "RTI0";
	    RTI1:   statename = "RTI1";
	    RTI2:   statename = "RTI2";
	    RTI3:   statename = "RTI3";
	    RTI4:   statename = "RTI4";
	    RTS0:   statename = "RTS0";
	    RTS1:   statename = "RTS1";
	    RTS2:   statename = "RTS2";
	    RTS3:   statename = "RTS3";
	    BRK0:   statename = "BRK0";
	    BRK1:   statename = "BRK1";
	    BRK2:   statename = "BRK2";
	    BRK3:   statename = "BRK3";
	    BRA0:   statename = "BRA0";
	    BRA1:   statename = "BRA1";
	    BRA2:   statename = "BRA2";
	    JMP0:   statename = "JMP0";
	    JMP1:   statename = "JMP1";
	    JMPI0:  statename = "JMPI0";
	    JMPI1:  statename = "JMPI1";
    endcase

//always @( PC )
	//$display( "%t, PC:%04x A:%02x X:%02x Y:%02x S:%02x C:%d Z:%d V:%d N:%d", $time, PC, A, X, Y, S, C, Z, V, N );

//`endif



/*
 * Program Counter Increment/Load. First calculate the base value in
 * PC_temp.
 */
always @*
    case( state )
	DECODE:		if( (~I & IRQ) | NMI_edge )
			    PC_temp = { ABH, ABL };
			else
			    PC_temp = PC;


	JMP1,
	JMPI1,
	JSR3,
	RTS3,	 	
	RTI4:		PC_temp = { DIMUX, ADD };

	BRA1:		PC_temp = { ABH, ADD };

	BRA2:		PC_temp = { ADD, PCL };

	BRK2: 		PC_temp =      res ? 32'hffff_fffc : 
				  NMI_edge ? 32'hffff_fffa : 32'hffff_fffe; // width should be parameterised

	default:	PC_temp = PC;
    endcase

/*
 * Determine wether we need PC_temp, or PC_temp + 1
 */
always @*
    case( state )
	DECODE:	 	if( (~I & IRQ) | NMI_edge )
			    PC_inc = 0;
			else
			    PC_inc = 1;

	ABS0,
	ABSX0,
	FETCH,
	BRA0,
	BRA2,
	BRK3,
	JMPI1,
	JMP1,
	RTI4,
	RTS3:		PC_inc = 1;

	BRA1:		PC_inc = CO ^~ backwards;

	default: 	PC_inc = 0;
    endcase

/* 
 * Set new PC
 */
always @(posedge clk) 
    if( RDY )
	PC <= PC_temp + PC_inc;

/*
 * Address Generator 
 */

parameter
	ZEROPAGE  = 16'h0000, 
	STACKPAGE = 16'h0001; 
	
always @*
    case( state )
	ABSX1,
	INDX3,
	INDY2,
	JMP1,
	JMPI1,
	RTI4,
	ABS1:		AB = { DIMUX, ADD };

	BRA2,
	INDY3,
	ABSX2:		AB = { ADD, ABL };

	BRA1:		AB = { ABH, ADD };

	JSR0,
	PUSH1,
	RTS0,
	RTI0,
	BRK0:		AB = { STACKPAGE, regfile };

	BRK1,
	JSR1,
	PULL1,
	RTS1,
	RTS2,
	RTI1,
	RTI2,
	RTI3,
	BRK2:		AB = { STACKPAGE, ADD };

	INDY1,
	INDX1,
	ZPX1,
	INDX2:		AB = { ZEROPAGE, ADD };

	ZP0,
	INDY0:		AB = { ZEROPAGE, DIMUX };

	REG,
	READ,
	WRITE:		AB = { ABH, ABL };

	default:	AB = PC;
    endcase

/*
 * ABH/ABL pair is used for registering previous address bus state.
 * This can be used to keep the current address, freeing up the original
 * source of the address, such as the ALU or DI.
 */
always @(posedge clk) begin
    ABL <= AB[dw-1:0];
    ABH <= AB[aw-1:dw];
end

/*
 * Data Out MUX 
 */
always @*
    case( state )
	WRITE:	 DO = ADD;

	JSR0,
	BRK0:	 DO = PCH;

	JSR1,
	BRK1:	 DO = PCL;

	PUSH1:	 DO = php ? P : ADD;

	BRK2:	 DO = (IRQ | NMI_edge) ? P : P | 16'b0000_0000_0001_0000; // B bit should be parameterised

	default: DO = regfile;
    endcase

/*
 * Write Enable Generator
 */

always @*
    case( state )
	BRK0,	// writing to stack or memory
	BRK1,
	BRK2,
	JSR0,
	JSR1,
	PUSH1,
	WRITE: 	 WE = 1;

	INDX3,	// only if doing a STA, STX or STY
	INDY3,
	ABSX2,
	ABS1,
	ZPX1,
        ZP0:	 WE = store;

	default: WE = 0;
    endcase

/*
 * register file, contains A, X, Y and S (stack pointer) registers. At each
 * cycle only 1 of those registers needs to be accessed, so they combined
 * in a small memory, saving resources.
 */

reg write_register;		// set when register file is written
	 
always @*
    case( state )
	DECODE: write_register = load_reg & ~plp;

	PULL1, 
	 RTS2, 
	 RTI3,
	 BRK3,
	 JSR0,
	 JSR2 : write_register = 1;

       default: write_register = 0;
    endcase

/*
 * write to a register. Usually this is the (BCD corrected) output of the
 * ALU, but in case of the JSR0 we use the S register to temporarily store
 * the PCL. This is possible, because the S register itself is stored in
 * the ALU during those cycles.
 */
always @(posedge clk)
    if( write_register & RDY )
	PAXYS[regsel] <= (state == JSR0) ? DIMUX : ADD;

/*
 * register select logic. This determines which of the A, B, C, D, X, Y or
 * S registers will be accessed. 
 */

always @*  
    case( state )
	INDY1,
	INDX0,
	ZPX0,
    	ABSX0  : regsel = index_y ? SEL_Y : SEL_X;


	DECODE : regsel = dst_reg; 

	BRK0,
	BRK3,
	JSR0,
	JSR2,
	PULL0,
	PULL1,
	PUSH1,
	RTI0,
	RTI3,
	RTS0,
	RTS2   : regsel = SEL_S;

        default: regsel = src_reg; 
    endcase

/*
 * ALU
 */

ALU #(.dw(dw)) _ALU(
	 .clk(clk),
	 .op(alu_op),
	 .right(alu_shift_right),
	 .rotate(rotate),
	 .AI(AI),
	 .BI(BI),
	 .CI(CI),
	 .EI(E_Reg),
	 .CO(CO),
	 .OUT(ADD),
	 .V(AV),
	 .Z(AZ),
	 .N(AN),
	 .RDY(RDY) );
	 
/*
 * Select current ALU operation
 */

always @*
    case( state )
	READ:	alu_op = op;

	BRA1:  	alu_op = backwards ? OP_SUB : OP_ADD; 

	FETCH,
	REG : 	alu_op = op; 

	DECODE,
	ABS1: 	alu_op = 1'bx;

	PUSH1,
	BRK0,
	BRK1,
	BRK2,
	JSR0,
	JSR1:	alu_op = OP_SUB;

     default:   alu_op = OP_ADD;
    endcase

/*
 * Determine shift right signal to ALU
 */

always @*
    if( state == FETCH || state == REG || state == READ )
	alu_shift_right = shift_right;
    else
	alu_shift_right = 0;

/*
 * Sign extend branch offset.  
 */

always @(posedge clk)
    if( RDY )
	backwards <= DIMUX[dw-1];

/* 
 * ALU A Input MUX 
 */

always @*
    case( state )
	JSR1,
	RTS1,
	RTI1,
	RTI2,
	BRK1,
	BRK2,
	INDX1: 	AI = ADD;

	REG,
	ZPX0,
	INDX0,
	ABSX0,
	RTI0,
	RTS0,
	JSR0,
	JSR2,
	BRK0,
	PULL0,
	INDY1,
	PUSH0,
	PUSH1:	AI = regfile;

	BRA0,
	READ:	AI = DIMUX;

	BRA1: 	AI = ABH;	// don't use PCH in case we're 

	FETCH:	AI = load_only ? 0 : regfile;

	DECODE,
	ABS1:	AI = {dw{1'bx}};	// don't care

	default: 	AI = 0;
    endcase


/*
 * ALU B Input mux
 */

always @*
    case( state )
	 BRA1,
	 JSR1,
	 RTS1,
	 RTI0,
	 RTI1,
	 RTI2,
	 INDX1,
	 READ,
	 REG,
	 JSR0,
	 JSR2,
	 BRK0,
	 BRK1,
	 BRK2,
	 PUSH0,	
	 PUSH1,
	 PULL0,
	 RTS0:	BI = {dw{1'b0}};

	 BRA0:	BI = PCL;

	 DECODE,
	 ABS1:  BI = {dw{1'bx}};	// don't care

	 default:	BI = DIMUX;
    endcase

/*
 * ALU CI (carry in) mux
 */

always @*
    case( state )
	INDY2,
	BRA1,
	ABSX1:	CI = CO;

	DECODE,
 	ABS1:	CI = 1'bx;

	READ,
	REG:	CI = rotate ? C :
		     shift ? 0 : inc;

	FETCH:	CI = rotate  ? C : 
		     compare ? 1 : 
		     (shift | load_only) ? 0 : C;

	PULL0,
	RTI0,
	RTI1,
	RTI2,
	RTS0,
	RTS1,
	INDY0,
	INDX1:	CI = 1; 

	default:	CI = 0;
    endcase

/*
 * Processor Status Register update
 *
 */

/*
 * Update C flag when doing ADC/SBC, shift/rotate, compare
 */
always @(posedge clk )
    if( shift && state == WRITE ) 
	C <= CO;
    else if( state == RTI2 )
    	C <= DIMUX[0];
    else if( ~write_back && state == DECODE ) begin
	if( adc_sbc | shift | compare )
	    C <= CO;
	else if( plp )
	    C <= ADD[0];
	else begin
	    if( sec ) C <= 1;
	    if( clc ) C <= 0;
	end
    end

/*
 * Update Z, N flags when writing A, X, Y, Memory, or when doing compare
 */

always @(posedge clk) 
    if( state == WRITE ) 
	Z <= AZ;
    else if( state == RTI2 )
    	Z <= DIMUX[1];
    else if( state == DECODE ) begin
	if( plp )
	    Z <= ADD[1];
	else if( (load_reg & (regsel != SEL_S)) | compare | bit )
	    Z <= AZ;
    end

always @(posedge clk)
    if( state == WRITE )
	N <= AN;
    else if( state == RTI2 )
    	N <= DIMUX[dw-1];
    else if( state == DECODE ) begin
	if( plp )
	    N <= ADD[dw-1];
	else if( (load_reg & (regsel != SEL_S)) | compare )
	    N <= AN;
    end else if( state == FETCH && bit ) 
	N <= DIMUX[dw-1];

/*
 * Update I flag
 */

always @(posedge clk)
    if( state == BRK3 )
	I <= 1;
    else if( state == RTI2 )
    	I <= DIMUX[2];
    else if( state == DECODE ) begin
	if( sei ) I <= 1;
	if( cli ) I <= 0;
	if( plp ) I <= ADD[2];
    end

/*
 * Update V flag (next to top bit)
 */
always @(posedge clk )
    if( state == RTI2 ) 
	V <= DIMUX[dw-2];
    else if( state == DECODE ) begin
	if( adc_sbc ) V <= AV;
	if( clv )     V <= 0;
	if( plp )     V <= ADD[dw-2];
    end else if( state == FETCH && bit ) 
	V <= DIMUX[dw-2];

/*
 * Instruction decoder
 */

/*
 * IR register/mux. Hold previous DI value in IRHOLD in PULL0 and PUSH0
 * states. In these states, the IR has been prefetched, and there is no
 * time to read the IR again before the next decode.
 */

reg RDY1 = 1;

always @(posedge clk )
    RDY1 <= RDY;

always @(posedge clk )
    if( ~RDY && RDY1 )
        DIHOLD <= DI;

always @(posedge clk )
    if( reset )
        IRHOLD_valid <= 0;
    else if( RDY ) begin
	if( state == PULL0 || state == PUSH0 ) begin
	    IRHOLD <= DIMUX;
	    IRHOLD_valid <= 1;
	end else if( state == DECODE )
	    IRHOLD_valid <= 0;
    end

assign IR = (IRQ & ~I) | NMI_edge ? {dw{1'b0}} :
                     IRHOLD_valid ? IRHOLD : DIMUX;

assign DIMUX = ~RDY1 ? DIHOLD : DI;

/*
 * Microcode state machine
 */
always @(posedge clk or posedge reset)
    if( reset )
        state <= BRK0;
    else if( RDY ) case( state )
	DECODE  : 
	    casex ( IR[15:0] )  							 // decode all 16 bits: IR[15:12]: used for reg [3:0] E_Reg (Shift Distance Register) on all <shift,rotate> opcodes only.
																 //							IR[15:8]: 0000_0000 is NMOS 6502 compatible opcode.
																 //							IR[15:14,11:10]: src_reg.
																 //							IR[13:12,9:8]: dst_reg.
		16'b0000_0000_0000_0000:	state <= BRK0;
		16'b0000_0000_0010_0000:	state <= JSR0;
		16'bxxxx_xxxx_0010_1100:	state <= ABS0;  // BIT abs
		16'b0000_0000_0100_0000:	state <= RTI0;  // 
		16'b0000_0000_0100_1100:	state <= JMP0;
		16'b0000_0000_0110_0000:	state <= RTS0;
		16'b0000_0000_0110_1100:	state <= JMPI0;
		16'b00xx_00xx_0x00_1000:	state <= PUSH0; // PHA[A..P], PHP
		16'b00xx_00xx_0x10_1000:	state <= PULL0; // PLA[A..P], PLP
		16'b0000_0000_0xx1_1000:	state <= REG;   // CLC, SEC, CLI, SEI
		16'b0000_0000_1xx0_00x0:	state <= FETCH; // IMM
		16'b0000_0000_1xx0_1100:	state <= ABS0;  // X/Y abs
		16'b00xx_00xx_1xxx_1000:	state <= REG;   // DEY, TYA, TAY, INY, INX
		16'bxxxx_xxxx_xxx0_0001:	state <= INDX0; // even 1 column (zp,x)
		16'bxxxx_xxxx_xxx0_01xx:	state <= ZP0;
		16'bxxxx_xxxx_xxx0_1001:	state <= FETCH; // IMM, even 9 column
		16'bxxxx_xxxx_xxx0_1101:	state <= ABS0;  // even D column
		16'bxxxx_xxxx_xxx0_1110:	state <= ABS0;  // even E column
		16'b0000_0000_xxx1_0000:	state <= BRA0;  // odd 0 column
		16'bxxxx_xxxx_xxx1_0001:	state <= INDY0; // odd 1 column
		16'bxxxx_xxxx_xxx1_01xx:	state <= ZPX0;  // odd 4,5,6,7 columns
		16'bxxxx_xxxx_xxx1_1001:	state <= ABSX0; // odd 9 column
		16'bxxxx_xxxx_xxx1_11xx:	state <= ABSX0; // odd C, D, E, F columns
		16'bxxxx_xxxx_xxxx_1010:	state <= REG;   // <shift> A, TXA[A..P], ...  NOP
		16'bxxxx_xxxx_10xx_1011:	state <= REG;	 // TA[A..P][A..P],TXY,TYX
		
	   16'bxxxx_xxxx_0xxx_x110:	state <= REG;	 // ASLA[A..D]opD, ROLA[A..D]opD, LSRA[A..D]opD, RORA[A..D]opD (abs, absx, zpg, zpgx)
		16'bxxxx_xxxx_0xxx_1010:	state <= REG;	 // ASLA[A..D]opD, ROLA[A..D]opD, LSRA[A..D]opD, RORA[A..D]opD (acc)
		endcase

        ZP0	: state <= write_back ? READ : FETCH;

	ZPX0	: state <= ZPX1;
	ZPX1	: state <= write_back ? READ : FETCH;

	ABS0	: state <= ABS1;
	ABS1	: state <= write_back ? READ : FETCH;

	ABSX0	: state <= ABSX1;
	ABSX1	: state <= (CO | store | write_back) ? ABSX2 : FETCH;
	ABSX2	: state <= write_back ? READ : FETCH;

	INDX0 	: state <= INDX1;
	INDX1 	: state <= INDX2;
	INDX2 	: state <= INDX3;
	INDX3 	: state <= FETCH;

	INDY0 	: state <= INDY1;
	INDY1 	: state <= INDY2;
	INDY2 	: state <= (CO | store) ? INDY3 : FETCH;
	INDY3 	: state <= FETCH;

	READ    : state <= WRITE;
	WRITE   : state <= FETCH;
	FETCH   : state <= DECODE;

	REG 	: state <= DECODE;

	PUSH0   : state <= PUSH1;
	PUSH1	: state <= DECODE;

	PULL0   : state <= PULL1;
	PULL1   : state <= PULL2; 
	PULL2   : state <= DECODE;

	JSR0	: state <= JSR1;
	JSR1	: state <= JSR2;
	JSR2	: state <= JSR3;
	JSR3	: state <= FETCH; 

	RTI0	: state <= RTI1;
	RTI1	: state <= RTI2;
	RTI2	: state <= RTI3;
	RTI3	: state <= RTI4;
	RTI4	: state <= DECODE;

	RTS0	: state <= RTS1;
	RTS1	: state <= RTS2;
	RTS2	: state <= RTS3;
	RTS3	: state <= FETCH;

	BRA0	: state <= cond_true ? BRA1 : DECODE;
	BRA1	: state <= (CO ^ backwards) ? BRA2 : DECODE;
	BRA2	: state <= DECODE;

	JMP0    : state <= JMP1;
	JMP1    : state <= DECODE; 

	JMPI0	: state <= JMPI1;
	JMPI1   : state <= JMP0;

	BRK0	: state <= BRK1;
	BRK1	: state <= BRK2;
	BRK2	: state <= BRK3;
	BRK3	: state <= JMP0;

    endcase

/*
 * Additional control signals
 */

always @(posedge clk)
     if( reset )
         res <= 1;
     else if( state == DECODE )
         res <= 0;

always @(posedge clk)
	  if( state == DECODE && RDY )
	   casex( IR[15:0] )				
		16'bxxxx_xxxx_0xxx_x110,	// ASL[A..D]op[A..D], ROL[A..D]op[A..D], LSR[A..D]op[A..D], ROR[A..D]op[A..D] (abs, absx, zpg, zpgx)
		16'bxxxx_xxxx_0xxx_1010:	// ASL[A..D]op[A..D], ROL[A..D]op[A..D], LSR[A..D]op[A..D], ROR[A..D]op[A..D] (acc)
					E_Reg <= IR[15:12]+1;	//note: no shift will occur when 'illegal' <shift, rotate> opcodes IR[15:12] = 1111. A +1 ensures compatibility with original NMOS6502 <shift,rotate> opcodes.
				
		default: E_Reg <=ADD;		
	endcase
	
always @(posedge clk)
     if( state == DECODE && RDY )
     	casex( IR[15:0] )  			
		16'bxxxx_xxxx_0xxx_xx01,	// ORA[A..D], AND[A..D], EOR[A..D], ADC[A..D]
	 	16'bxxxx_xxxx_111x_xx01,	// SBC[A..D]
		16'b00xx_00xx_101x_xxx1,	// LDA[A..D]
		16'bxxxx_xxxx_xxxx_1010,	// ASL[A..D], ROL[A..D], LSR[A..D], ROR[A..D], TX[A..P], T[XS][SX], DEX, NOP,
		16'b00xx_00xx_xxx0_1000,	// PHP, PLP, PH[A..D], PL[A..D], DEY, T[A..D]Y, INY, INX
		16'b00xx_00xx_1001_1000,	// TY[A..D]
		16'b0000_0000_1011_x1x0,	// LDX/LDY
		16'bxxxx_xxxx_1010_xxx0,	// ASL[A..D], ROL[A..D]...
		16'bxxxx_xxxx_10xx_1011:	// TA[A..D], TB[A..D], TC[A..D], TD[A..D], TXY, TYX
					load_reg <= 1;

		default:	load_reg <= 0;
	endcase

always @(posedge clk)
     if( state == DECODE && RDY )
     	casex( IR[15:0] )  			
		16'b0000_0000_1110_1000,	// INX
		16'b0000_0000_1100_1010,	// DEX
		16'b00xx_00xx_101x_xx10,	// LDX, T[A..P]X, TSX
		16'b0000_0000_1010_1011:	// TYX
				dst_reg <= SEL_X;

		16'b00xx_00xx_0x00_1000,	// PHP, PH[A..P]
		16'b0000_0000_1001_1010:	// TXS
				dst_reg <= SEL_S;

		16'b0000_0000_1x00_1000,	// DEY, DEX
		16'b0000_0000_101x_x100,	// LDY
		16'b00xx_00xx_1010_x000, 	// LDY #imm, T[A..P]Y
		16'b0000_0000_1011_1011:	// TXY
				dst_reg <= SEL_Y;
		
		16'bxx00_xx00_1000_1011,	// TA[A..D]
		16'bxx00_xx00_1010_10x0,	// TAX, TAY
		16'b0000_0000_101x_xxx1,	// LDA[A]
		16'bxx00_xx00_0xxx_xx01,	// ADCAop[A..D], SBCAop[A..D], ANDAop[A..D], ORAAop[A..D], EORAop[A..D] store result in [A..D]
		16'bxx00_xx00_111x_xx01,	// SBCAop[A..D]
		16'bxxxx_xx00_0xxx_x110,	// ASLAop[A..D], ROLAop[A..D], LSRAop[A..D], RORAop[A..D] (abs, absx, zpg, zpgx)
		16'bxxxx_xx00_0xxx_1010,	// ASLAop[A..D], ROLAop[A..D], LSRAop[A..D], RORAop[A..D] (acc)
		16'bxx00_xx00_0010_x100:	// BITAop[A..D]zp
				dst_reg <= SEL_A; 
      
		16'bxx00_xx01_1000_1011,	// TB[A..D]
		16'bxx00_xx01_1010_10x0,	// TBX, TBY	
		16'b0000_0001_101x_xxx1,	// LDA[B]
		16'bxx00_xx01_0xxx_xx01,	// ADCBop[A..D], SBCBop[A..D], ANDBop[A..D], ORABop[A..D], EORBop[A..D] store result in [A..D]
		16'bxx00_xx01_111x_xx01,	// SBCBop[A..D]
		16'bxxxx_xx01_0xxx_x110,	// ASLBop[A..D], ROLBop[A..D], LSRBop[A..D], RORBop[A..D] (abs, absx, zpg, zpgx)
		16'bxxxx_xx01_0xxx_1010,	// ASLBop[A..D], ROLBop[A..D], LSRBop[A..D], RORBop[A..D] (acc)
		16'bxx00_xx01_0010_x100:	// BITDop[A..D]zp
            dst_reg <= SEL_B; 
             
		16'bxx00_xx10_1000_1011,	// TC[A..D]
		16'bxx00_xx10_1010_10x0,	// TCX, TCY
		16'b0000_0010_101x_xxx1,	// LDA[C]
		16'bxx00_xx10_0xxx_xx01,	// ADCCop[A..D], SBCCop[A..D], ANDCop[A..D], ORACop[A..D], EORCop[A..D] store result in [A..D]
		16'bxx00_xx10_111x_xx01,	// SBCCop[A..D]
		16'bxxxx_xx10_0xxx_x110,	// ASLCop[A..D], ROLCop[A..D], LSRCop[A..D], RORCop[A..D] (abs, absx, zpg, zpgx)
		16'bxxxx_xx10_0xxx_1010,	// ASLCop[A..D], ROLCop[A..D], LSRCop[A..D], RORCop[A..D] (acc)
		16'bxx00_xx10_0010_x100:	// BITCop[A..D]zp
            dst_reg <= SEL_C; 
             
		16'bxx00_xx11_1000_1011,	// TD[A..D]
		16'bxx00_xx11_1010_10x0,	// TDX, TDY
		16'b0000_0011_101x_xxx1,	// LDA[D]
		16'bxx00_xx11_0xxx_xx01,	// ADCDop[A..D], SBCDop[A..D], ANDDop[A..D], ORADop[A..D], EORDop[A..D] store result in [A..D]
		16'bxx00_xx11_111x_xx01,	// SBCDop[A..D]
		16'bxxxx_xx11_0xxx_x110,	// ASLDop[A..D], ROLDop[A..D], LSRDop[A..D], RORDop[A..D] (abs, absx, zpg, zpgx)
		16'bxxxx_xx11_0xxx_1010,	// ASLDop[A..D], ROLDop[A..D], LSRDop[A..D], RORDop[A..D] (acc)
		16'bxx00_xx11_0010_x100:	// BITDop[A..D]zp
		      dst_reg <= SEL_D;
				
		16'bxx01_xx00_1000_1011,	// TE[A..P]
		16'bxx01_xx00_1010_10x0,	// TEX, TEY
		16'b0001_0000_101x_xxx1,	// LDA[E]
		16'bxx01_xx00_0xxx_xx01,	// ADCEop[A..P], SBCEop[A..P], ANDEop[A..P], ORAEop[A..P], EOREop[A..P] store result in [A..P]
		16'bxx01_xx00_111x_xx01,	// SBCEop[A..P]
		16'bxx01_xx00_0010_x100:	// BITEop[A..P]zp
		      dst_reg <= SEL_E;
		
		16'bxx01_xx01_1000_1011,	// TF[A..P]
		16'bxx01_xx01_1010_10x0,	// TFX, TFY
		16'b0001_0001_101x_xxx1,	// LDA[F]
		16'bxx01_xx01_0xxx_xx01,	// ADCFop[A..P], SBCFop[A..P], ANDFop[A..P], ORAFop[A..P], EORFop[A..P] store result in [A..P]
		16'bxx01_xx01_111x_xx01,	// SBCFop[A..P]
		16'bxx01_xx01_0010_x100:	// BITFop[A..P]zp
		      dst_reg <= SEL_F;
				
		16'bxx01_xx10_1000_1011,	// TG[A..P]
		16'bxx01_xx10_1010_10x0,	// TGX, TGY
		16'b0001_0010_101x_xxx1,	// LDA[G]
		16'bxx01_xx10_0xxx_xx01,	// ADCGop[A..P], SBCGop[A..P], ANDGop[A..P], ORAGop[A..P], EORGop[A..P] store result in [A..P]
		16'bxx01_xx10_111x_xx01,	// SBCGop[A..P]
		16'bxx01_xx10_0010_x100:	// BITGop[A..P]zp
		      dst_reg <= SEL_G;
				
		16'bxx01_xx11_1000_1011,	// TH[A..P]
		16'bxx01_xx11_1010_10x0,	// THX, THY
		16'b0001_0011_101x_xxx1,	// LDA[H]
		16'bxx01_xx11_0xxx_xx01,	// ADCHop[A..P], SBCHop[A..P], ANDHop[A..P], ORAHop[A..P], EORHop[A..P] store result in [A..P]
		16'bxx01_xx11_111x_xx01,	// SBCHop[A..P]
		16'bxx01_xx11_0010_x100:	// BITHop[A..P]zp
		      dst_reg <= SEL_H;
				
		16'bxx10_xx00_1000_1011,	// TI[A..P]
		16'bxx10_xx00_1010_10x0,	// TIX, TIY
		16'b0010_0000_101x_xxx1,	// LDA[I]
		16'bxx10_xx00_0xxx_xx01,	// ADCIop[A..P], SBCIop[A..P], ANDIop[A..P], ORAIop[A..P], EORIop[A..P] store result in [A..P]
		16'bxx10_xx00_111x_xx01,	// SBCIop[A..P]
		16'bxx10_xx00_0010_x100:	// BITIop[A..P]zp
		      dst_reg <= SEL_I;
				
		16'bxx10_xx01_1000_1011,	// TJ[A..P]
		16'bxx10_xx01_1010_10x0,	// TJX, TJY
		16'b0010_0001_101x_xxx1,	// LDA[J]
		16'bxx10_xx01_0xxx_xx01,	// ADCJop[A..P], SBCJop[A..P], ANDJop[A..P], ORAJop[A..P], EORJop[A..P] store result in [A..P]
		16'bxx10_xx01_111x_xx01,	// SBCJop[A..P]
		16'bxx10_xx01_0010_x100:	// BITJop[A..P]zp
		      dst_reg <= SEL_J;
				
		16'bxx10_xx10_1000_1011,	// TK[A..P]
		16'bxx10_xx10_1010_10x0,	// TKX, TKY
		16'b0010_0010_101x_xxx1,	// LDA[K]
		16'bxx10_xx10_0xxx_xx01,	// ADCKop[A..P], SBCKop[A..P], ANDKop[A..P], ORAKop[A..P], EORKop[A..P] store result in [A..P]
		16'bxx10_xx10_111x_xx01,	// SBCKop[A..P]
		16'bxx10_xx10_0010_x100:	// BITKop[A..P]zp
		      dst_reg <= SEL_K;
				
		16'bxx10_xx11_1000_1011,	// TL[A..P]
		16'bxx10_xx11_1010_10x0,	// TLX, TLY
		16'b0010_0011_101x_xxx1,	// LDA[L]
		16'bxx10_xx11_0xxx_xx01,	// ADCLop[A..P], SBCLop[A..P], ANDLop[A..P], ORALop[A..P], EORLop[A..P] store result in [A..P]
		16'bxx10_xx11_111x_xx01,	// SBCLop[A..P]
		16'bxx10_xx11_0010_x100:	// BITLop[A..P]zp
		      dst_reg <= SEL_L;
				
		16'bxx11_xx00_1000_1011,	// TM[A..P]
		16'bxx11_xx00_1010_10x0,	// TMX, TMY
		16'b0011_0000_101x_xxx1,	// LDA[M]
		16'bxx11_xx00_0xxx_xx01,	// ADCMop[A..P], SBCMop[A..P], ANDMop[A..P], ORAMop[A..P], EORMop[A..P] store result in [A..P]
		16'bxx11_xx00_111x_xx01,	// SBCMop[A..P]
		16'bxx11_xx00_0010_x100:	// BITMop[A..P]zp
		      dst_reg <= SEL_M;
				
		16'bxx11_xx01_1000_1011,	// TN[A..P]
		16'bxx11_xx01_1010_10x0,	// TNX, TNY
		16'b0011_0001_101x_xxx1,	// LDA[N]
		16'bxx11_xx01_0xxx_xx01,	// ADCNop[A..P], SBCNop[A..P], ANDNop[A..P], ORANop[A..P], EORNop[A..P] store result in [A..P]
		16'bxx11_xx01_111x_xx01,	// SBCNop[A..P]
		16'bxx11_xx01_0010_x100:	// BITNop[A..P]zp
		      dst_reg <= SEL_N;
				
		16'bxx11_xx10_1000_1011,	// T[A..P]O
		16'b0011_0010_100x_10x0,	// TXO, TYO
		16'b0011_0010_101x_xxx1,	// LDA[O]
		16'bxx11_xx10_0xxx_xx01,	// ADC[A..P]opO, SBC[A..P]opO, AND[A..P]opO, ORA[A..P]opO, EOR[A..P]opO store result in [A..P]
		16'bxx11_xx10_111x_xx01,	// SBC[A..P]opO
		16'bxx11_xx10_0010_x100:	// BIT[A..P]opO zp
				dst_reg <= SEL_O;
				
		16'bxx11_xx11_1000_1011,	// T[A..P]P
		16'b0011_0011_100x_10x0,	// TXP, TYP
		16'b0011_0011_101x_xxx1,	// LDA[P]
		16'bxx11_xx11_0xxx_xx01,	// ADC[A..P]opP, SBC[A..P]opP, AND[A..P]opP, ORA[A..P]opP, EOR[A..P]opP store result in [A..P]
		16'bxx11_xx11_111x_xx01,	// SBC[A..P]opP
		16'bxx11_xx11_0010_x100:	// BIT[A..P]opP zp
				dst_reg <= SEL_P;        
	endcase

always @(posedge clk)
     if( state == DECODE && RDY )
     	casex( IR[15:0] ) 		  	
		16'b0000_0000_1011_1010:	// TSX 
				src_reg <= SEL_S; 

		16'b0000_0000_100x_x110,	// STX
		16'b00xx_00xx_100x_1x10,	// TX[A..P], TXS
		16'b0000_0000_1110_xx00,	// INX, CPX
		16'b0000_0000_1100_1010,	// DEX
		16'b0000_0000_1011_1011:	// TXY
				src_reg <= SEL_X; 

		16'b0000_0000_100x_x100,	// STY
		16'b00xx_00xx_1001_1000,	// TY[A..P]
		16'b0000_0000_1100_xx00,	// CPY
		16'b0000_0000_1x00_1000,	// DEY, INY
		16'b0000_0000_1010_1011:	// TYX
				src_reg <= SEL_Y;
		
		16'bxx00_xx00_1000_1011,	// T[A..D]A
		16'b0000_0000_100x_10x0,	// TXA, TYA
		16'b0000_0000_100x_xx01,	// STA[A]
		16'b0000_0000_110x_xx01,	// CMP[A]
		16'bxx00_xx00_0xxx_xx01,	// ADC[A..D]opA, SBC[A..D]opA, AND[A..D]opA, ORA[A..D]opA, EOR[A..D]opA store result in [A..D]
		16'bxx00_xx00_111x_xx01,	// SBC[A..D]opA
		16'bxxxx_xx00_0xxx_x110,	// ASL[A..D]opA, ROL[A..D]opA, LSR[A..D]opA, ROR[A..D]opA (abs, absx, zpg, zpgx)
		16'bxxxx_xx00_0xxx_1010,	// ASL[A..D]opA, ROL[A..D]opA, LSR[A..D]opA, ROR[A..D]opA (acc)
		16'bxx00_xx00_0010_x100:	// BIT[A..D]opA zp
            src_reg <= SEL_A; 
             
		16'b00xx_01xx_1000_1011,	// T[A..D]B
		16'b0000_0100_100x_10x0,	// TXB, TYB
		16'b0000_0100_100x_xx01,	// STA[B]
		16'b0000_0100_110x_xx01,	// CMP[B]
		16'b00xx_01xx_0xxx_xx01,	// ADC[A..D]opB, SBC[A..D]opB, AND[A..D]opB, ORA[A..D]opB, EOR[A..D]opB store result in [A..D]
		16'b00xx_01xx_111x_xx01,	// SBC[A..D]opB
		16'bxxxx_01xx_0xxx_x110,	// ASL[A..D]opB, ROL[A..D]opB, LSR[A..D]opB, ROR[A..D]opB (abs, absx, zpg, zpgx)
		16'bxxxx_01xx_0xxx_1010,	// ASL[A..D]opB, ROL[A..D]opB, LSR[A..D]opB, ROR[A..D]opB (acc)
		16'b00xx_01xx_0010_x100:	// BIT[A..D]opB zp
            src_reg <= SEL_B; 

		16'b00xx_10xx_1000_1011,	// T[A..D]C
		16'b0000_1000_100x_10x0,	// TXC, TYC
		16'b0000_1000_100x_xx01,	// STA[C]
		16'b0000_1000_110x_xx01,	// CMP[C]
		16'b00xx_10xx_0xxx_xx01,	// ADC[A..D]opC, SBC[A..D]opC, AND[A..D]opC, ORA[A..D]opC, EOR[A..D]opC store result in [A..D]
		16'b00xx_10xx_111x_xx01,	// SBC[A..D]opC
		16'bxxxx_10xx_0xxx_x110,	// ASL[A..D]opC, ROL[A..D]opC, LSR[A..D]opC, ROR[A..D]opC (abs, absx, zpg, zpgx)
		16'bxxxx_10xx_0xxx_1010,	// ASL[A..D]opC, ROL[A..D]opC, LSR[A..D]opC, ROR[A..D]opC (acc)
		16'b00xx_10xx_0010_x100:	// BIT[A..D]opC zp
            src_reg <= SEL_C; 
             
		16'b00xx_11xx_1000_1011,	// T[A..D]D
		16'b0000_1100_100x_10x0,	// TXD, TYD
		16'b0000_1100_100x_xx01,	// STA[D]
		16'b0000_1100_110x_xx01,	// CMP[D]
		16'b00xx_11xx_0xxx_xx01,	// ADC[A..D]opD, SBC[A..D]opD, AND[A..D]opD, ORA[A..D]opD, EOR[A..D]opD store result in [A..D]
		16'b00xx_11xx_111x_xx01,	// SBC[A..D]opD
		16'bxxxx_11xx_0xxx_x110,	// ASL[A..D]opD, ROL[A..D]opD, LSR[A..D]opD, ROR[A..D]opD (abs, absx, zpg, zpgx)
		16'bxxxx_11xx_0xxx_1010,	// ASL[A..D]opD, ROL[A..D]opD, LSR[A..D]opD, ROR[A..D]opD (acc)
		16'b00xx_11xx_0010_x100:	// BIT[A..D]opD zp
            src_reg <= SEL_D;
		
		16'b01xx_00xx_1000_1011,	// T[A..P]E
		16'b0100_0000_100x_10x0,	// TXE, TYE
		16'b0100_0000_100x_xx01,	// STA[E]
		16'b0100_0000_110x_xx01,	// CMP[E]
		16'b01xx_00xx_0xxx_xx01,	// ADC[A..P]opE, SBC[A..P]opE, AND[A..P]opE, ORA[A..P]opE, EOR[A..P]opE store result in [A..P]
		16'b01xx_00xx_111x_xx01,	// SBC[A..P]opE
		16'b01xx_00xx_0010_x100:	// BIT[A..P]opE zp
				src_reg <= SEL_E;
		
		16'b01xx_01xx_1000_1011,	// T[A..P]F
		16'b0100_0100_100x_10x0,	// TXF, TYF
		16'b0100_0100_100x_xx01,	// STA[F]
		16'b0100_0100_110x_xx01,	// CMP[F]
		16'b01xx_01xx_0xxx_xx01,	// ADC[A..P]opF, SBC[A..P]opF, AND[A..P]opF, ORA[A..P]opF, EOR[A..P]opF store result in [A..P]
		16'b01xx_01xx_111x_xx01,	// SBC[A..P]opF
		16'b01xx_01xx_0010_x100:	// BIT[A..P]opF zp
				src_reg <= SEL_F;
				
		16'b01xx_10xx_1000_1011,	// T[A..P]G
		16'b0100_1000_100x_10x0,	// TXG, TYG
		16'b0100_1000_100x_xx01,	// STA[G]
		16'b0100_1000_110x_xx01,	// CMP[G]
		16'b01xx_10xx_0xxx_xx01,	// ADC[A..P]opG, SBC[A..P]opG, AND[A..P]opG, ORA[A..P]opG, EOR[A..P]opG store result in [A..P]
		16'b01xx_10xx_111x_xx01,	// SBC[A..P]opG
		16'b01xx_10xx_0010_x100:	// BIT[A..P]opG zp
				src_reg <= SEL_G;
			
		16'b01xx_11xx_1000_1011,	// T[A..P]H
		16'b0100_1100_100x_10x0,	// TXH, TYH
		16'b0100_1100_100x_xx01,	// STA[H]
		16'b0100_1100_110x_xx01,	// CMP[H]
		16'b01xx_11xx_0xxx_xx01,	// ADC[A..P]opH, SBC[A..P]opH, AND[A..P]opH, ORA[A..P]opH, EOR[A..P]opH store result in [A..P]
		16'b01xx_11xx_111x_xx01,	// SBC[A..P]opH
		16'b01xx_11xx_0010_x100:	// BIT[A..P]opH zp
				src_reg <= SEL_H;
				
		16'b10xx_00xx_1000_1011,	// T[A..P]I
		16'b1000_0000_100x_10x0,	// TXI, TYI
		16'b1000_0000_100x_xx01,	// STA[I]
		16'b1000_0000_110x_xx01,	// CMP[I]
		16'b10xx_00xx_0xxx_xx01,	// ADC[A..P]opI, SBC[A..P]opI, AND[A..P]opI, ORA[A..P]opI, EOR[A..P]opI store result in [A..P]
		16'b10xx_00xx_111x_xx01,	// SBC[A..P]opI
		16'b10xx_00xx_0010_x100:	// BIT[A..P]opI zp
				src_reg <= SEL_I;
				
		16'b10xx_01xx_1000_1011,	// T[A..P]J
		16'b1000_0100_100x_10x0,	// TXJ, TYJ
		16'b1000_0100_100x_xx01,	// STA[J]
		16'b1000_0100_110x_xx01,	// CMP[J]
		16'b10xx_01xx_0xxx_xx01,	// ADC[A..P]opJ, SBC[A..P]opJ, AND[A..P]opJ, ORA[A..P]opJ, EOR[A..P]opJ store result in [A..P]
		16'b10xx_01xx_111x_xx01,	// SBC[A..P]opJ
		16'b10xx_01xx_0010_x100:	// BIT[A..P]opJ zp
				src_reg <= SEL_J;
				
		16'b10xx_10xx_1000_1011,	// T[A..P]K
		16'b1000_1000_100x_10x0,	// TXK, TYK
		16'b1000_1000_100x_xx01,	// STA[K]
		16'b1000_1000_110x_xx01,	// CMP[K]
		16'b10xx_10xx_0xxx_xx01,	// ADC[A..P]opK, SBC[A..P]opK, AND[A..P]opK, ORA[A..P]opK, EOR[A..P]opK store result in [A..P]
		16'b10xx_10xx_111x_xx01,	// SBC[A..P]opK
		16'b10xx_10xx_0010_x100:	// BIT[A..P]opK zp
				src_reg <= SEL_K;
				
		16'b10xx_11xx_1000_1011,	// T[A..P]L
		16'b1000_1100_100x_10x0,	// TXL, TYL
		16'b1000_1100_100x_xx01,	// STA[L]
		16'b1000_1100_110x_xx01,	// CMP[L]
		16'b10xx_11xx_0xxx_xx01,	// ADC[A..P]opL, SBC[A..P]opL, AND[A..P]opL, ORA[A..P]opL, EOR[A..P]opL store result in [A..P]
		16'b10xx_11xx_111x_xx01,	// SBC[A..P]opL
		16'b10xx_11xx_0010_x100:	// BIT[A..P]opL zp
				src_reg <= SEL_L;
				
		16'b11xx_00xx_1000_1011,	// T[A..P]M
		16'b1100_0000_100x_10x0,	// TXM, TYM
		16'b1100_0000_100x_xx01,	// STA[M]
		16'b1100_0000_110x_xx01,	// CMP[M]
		16'b11xx_00xx_0xxx_xx01,	// ADC[A..P]opM, SBC[A..P]opM, AND[A..P]opM, ORA[A..P]opM, EOR[A..P]opM store result in [A..P]
		16'b11xx_00xx_111x_xx01,	// SBC[A..P]opM
		16'b11xx_00xx_0010_x100:	// BIT[A..P]opM zp
				src_reg <= SEL_M;
				
		16'b11xx_01xx_1000_1011,	// T[A..P]N
		16'b1100_0100_100x_10x0,	// TXN, TYN
		16'b1100_0100_100x_xx01,	// STA[N]
		16'b1100_0100_110x_xx01,	// CMP[N]
		16'b11xx_01xx_0xxx_xx01,	// ADC[A..P]opN, SBC[A..P]opN, AND[A..P]opN, ORA[A..P]opN, EOR[A..P]opN store result in [A..P]
		16'b11xx_01xx_111x_xx01,	// SBC[A..P]opN
		16'b11xx_01xx_0010_x100:	// BIT[A..P]opN zp
				src_reg <= SEL_N;
				
		16'b11xx_10xx_1000_1011,	// TO[A..P]
		16'b11xx_10xx_1010_10x0,	// TOX, TOY
		16'b1100_1000_100x_xx01,	// STA[O]
		16'b1100_1000_110x_xx01,	// CMP[O]
		16'b11xx_10xx_0xxx_xx01,	// ADCOop[A..P], SBCOop[A..P], ANDOop[A..P], ORAOop[A..P], EOROop[A..P] store result in [A..P]
		16'b11xx_10xx_111x_xx01,	// SBCOop[A..P]
		16'b11xx_10xx_0010_x100:	// BITOop[A..P]zp
		      src_reg <= SEL_O;
				
		16'b11xx_11xx_1000_1011,	// TP[A..P]
		16'b11xx_11xx_1010_10x0,	// TPX, TPY
		16'b1100_1100_100x_xx01,	// STA[P]
		16'b1100_1100_110x_xx01,	// CMP[P]
		16'b11xx_11xx_0xxx_xx01,	// ADCPop[A..P], SBCPop[A..P], ANDPop[A..P], ORAPop[A..P], EORPop[A..P] store result in [A..P]
		16'b11xx_11xx_111x_xx01,	// SBCPop[A..P]
		16'b11xx_11xx_0010_x100:	// BITPop[A..P]zp
		      src_reg <= SEL_P;
	endcase

always @(posedge clk) 
     if( state == DECODE && RDY )
     	casex( IR[15:0] )  			
		16'b0000_0000_xxx1_0001,	// INDY
		16'b0000_0000_10x1_x110, 	// LDX/STX zpg/abs, Y
		16'b0000_0000_xxxx_1001:	// abs, Y
				index_y <= 1;

		default:	index_y <= 0;
	endcase


always @(posedge clk)
     if( state == DECODE && RDY )
     	casex( IR[15:0] )  			
		16'bxx00_xx00_100x_x1x0,	// STX, STY
		16'bxx00_xx00_100x_xx01:	// STA[A..P]
				store <= 1;

		default:	store <= 0;

	endcase

always @(posedge clk )
     if( state == DECODE && RDY )
     	casex( IR[15:0] )  			
		16'bxxxx_xxxx_0xxx_x110,	// ASL[A..D]op[A..D], ROL[A..D]op[A..D], LSR[A..D]op[A..D], ROR[A..D]op[A..D]
		16'b0000_0000_11xx_x110:	// DEC, INC
				write_back <= 1;

		default:	write_back <= 0;
	endcase


always @(posedge clk )
     if( state == DECODE && RDY )
     	casex( IR[15:0] )  			
		16'b00xx_00xx_101x_xxxx:	// LDA[A..D], LDX, LDY
				load_only <= 1;
		default:	load_only <= 0;
	endcase

always @(posedge clk )
     if( state == DECODE && RDY )
     	casex( IR[15:0] )  			
		16'b0000_0000_111x_x110,	// INC
		16'b0000_0000_11x0_1000: 	// INX, INY
				inc <= 1;

		default:	inc <= 0;
	endcase

always @(posedge clk )
     if( (state == DECODE || state == BRK0) && RDY )
     	casex( IR[15:0] ) 	   	
		16'bxxxx_xxxx_011x_xx01:	// ADC[A..D]op[A..D]
				adc_sbc <= 1;

		default:	adc_sbc <= 0;
	endcase

always @(posedge clk )
     if( state == DECODE && RDY )
     	casex( IR[15:0] )  			
		16'bxxxx_xxxx_0xxx_x110,	// ASL[A..D]op[A..D], ROL[A..D]op[A..D], LSR[A..D]op[A..D], ROR[A..D]op[A..D] (abs, absx, zpg, zpgx)
		16'bxxxx_xxxx_0xxx_1010:	// ASL[A..D]op[A..D], ROL[A..D]op[A..D], LSR[A..D]op[A..D], ROR[A..D]op[A..D] (acc)
				shift <= 1;

		default:	shift <= 0;
	endcase

always @(posedge clk )
     if( state == DECODE && RDY )
     	casex( IR[15:0] )  			
		16'b0000_0000_11x0_0x00,	// CPX, CPY (imm/zp)
		16'b0000_0000_11x0_1100,	// CPX, CPY (abs)
		16'bxxxx_xxxx_110x_xx01:	// CMP[A..D]
				compare <= 1;

		default:	compare <= 0;
	endcase

always @(posedge clk )
     if( state == DECODE && RDY )
     	casex( IR[15:0] )  			
		16'bxxxx_xxxx_01xx_xx10:	// ROR[A..D]op[A..D], LSR[A..D]op[A..D]
				shift_right <= 1;

		default:	shift_right <= 0; 
	endcase

always @(posedge clk )
     if( state == DECODE && RDY )
     	casex( IR[15:0] )  			
		16'bxxxx_xxxx_0x1x_1010,	// ROL[A..D], ROR[A..D]
		16'bxxxx_xxxx_0x1x_x110:	// ROR[A..D], ROL[A..D]
				rotate <= 1;

		default:	rotate <= 0; 
	endcase

always @(posedge clk )
     if( state == DECODE && RDY )
     	casex( IR[15:0] ) 			
		16'bxxxx_xxxx_00xx_xx10:	// ROL[A..D], ASL[A..D]
				op <= OP_ROL;

		16'bxxxx_xxxx_0010_x100:   // BIT[A..D] zp/abs
				op <= OP_AND;

		16'bxxxx_xxxx_01xx_xx10:	// ROR[A..D], LSR[A..D]
				op <= OP_A;

		16'b0000_0000_1000_1000,	// DEY
		16'b0000_0000_1100_1010, 	// DEX 
		16'b0000_0000_110x_x110,	// DEC
		16'bxxxx_xxxx_11xx_xx01,	// CMP[A..D], SBC[A..D]
		16'b0000_0000_11x0_0x00,	// CPX, CPY (imm, zpg)
		16'b0000_0000_11x0_1100:	// CPX, CPY abs
				op <= OP_SUB;

		16'bxxxx_xxxx_010x_xx01,	// EOR[A..D]
		16'bxxxx_xxxx_00xx_xx01:	// ORA[A..D], AND[A..D]
				op <= { 2'b11, IR[6:5] };

		default: 	op <= OP_ADD; 
	endcase

always @(posedge clk )
     if( state == DECODE && RDY )
     	casex( IR[15:0] ) 			
		16'bxxxx_xxxx_0010_x100:   // BIT[A..D] zp/abs
				bit <= 1;

		default:	bit <= 0; 
	endcase

/*
 * special instructions
 */
always @(posedge clk )
     if( state == DECODE && RDY ) begin
	php <= (IR[15:0] == 16'h0008);
	clc <= (IR[15:0] == 16'h0018);
	plp <= (IR[15:0] == 16'h0028);
	sec <= (IR[15:0] == 16'h0038);
	cli <= (IR[15:0] == 16'h0058);
	sei <= (IR[15:0] == 16'h0078);
	clv <= (IR[15:0] == 16'h00b8);
	brk <= (IR[15:0] == 16'h0000);
     end

always @(posedge clk)
    if( RDY )
	cond_code <= IR[7:5];

always @*
    case( cond_code )
	    3'b000: cond_true <= ~N;
	    3'b001: cond_true <= N;
	    3'b010: cond_true <= ~V;
	    3'b011: cond_true <= V;
	    3'b100: cond_true <= ~C;
	    3'b101: cond_true <= C;
	    3'b110: cond_true <= ~Z;
	    3'b111: cond_true <= Z;
    endcase


reg NMI_1 = 0;		// delayed NMI signal

always @(posedge clk)
    NMI_1 <= NMI;

always @(posedge clk )
    if( NMI_edge && state == BRK3 )
     	NMI_edge <= 0;
    else if( NMI & ~NMI_1 )
        NMI_edge <= 1;

endmodule