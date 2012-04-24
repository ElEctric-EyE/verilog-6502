/*FILE: /relocatable stack and zero page/cpu.v DATE:04/24/2012 -- remember to uncomment 4 'ifdef SIM' statements when not running simulation. --
 * verilog-6502 project: verilog model of 6502 and 65Org16.x CPU core
 *
 * (C) 2011 Arlet Ottens, <arlet@c-scape.nl>
 * (C) 2011 Ed Spittles, <ed.spittles@gmail.com>
 * (C) 2012 Sam Gaskill, <sammy.gasket@gmail.com> stripped BCD, removed SED,CLD opcodes, added full 16-bit IR decoding, added Arlet's updates from 5 months ago. Added B thru Q accumulators. Added full accumulator to accumulator transfer opcodes. Added BigEd's 16-bit barrel shifter logic to A thru D Acc's. Added WDC65C02 PHX,PHY,PLX,PLY opcodes. Added WDC65C02 INC[A], DEC[A] opcodes, also INC[B..Q], DEC[B..Q]. Added W index register with same addressing modes as Y. Added relocatable stack and zero pages. Added Transfer opcodes for stack and zero pages pointers. Added index transfer opcodes for W. That's it for .b CORE!
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

reg  [dw-1:0] QAWXYS[21:0]; 	// A thru Q, W, X, Y, Z and S register file

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

reg [4:0] regsel;			// Select A thru Q, W, X, Y, S, SPP, ZPP register
wire [dw-1:0] regfile = QAWXYS[regsel];	// Selected register output

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
	SEL_Q		= 5'd15,		//P = processor status
	SEL_X	   = 5'd16,
	SEL_Y    = 5'd17,
	SEL_W		= 5'd18,
	SEL_S    = 5'd19,
	SEL_ZPP	= 5'd20,
	SEL_SPP	= 5'd21;

initial
	begin
		QAWXYS[SEL_Q] = 0;
		QAWXYS[SEL_O] = 0;
		QAWXYS[SEL_N] = 0;
		QAWXYS[SEL_M] = 0;
		QAWXYS[SEL_L] = 0;
		QAWXYS[SEL_K] = 0;
		QAWXYS[SEL_J] = 0;
		QAWXYS[SEL_I] = 0;
		QAWXYS[SEL_H] = 0;
		QAWXYS[SEL_G] = 0;
		QAWXYS[SEL_F] = 0;
		QAWXYS[SEL_E] = 0;
		QAWXYS[SEL_D] = 0;
		QAWXYS[SEL_C] = 0;
		QAWXYS[SEL_B] = 0;
		QAWXYS[SEL_A] = 0;
		QAWXYS[SEL_X] = 0;
		QAWXYS[SEL_Y] = 0;
		QAWXYS[SEL_W] = 0;
		QAWXYS[SEL_S] = 0; //init stack
		QAWXYS[SEL_ZPP] = 0;
		QAWXYS[SEL_SPP] = 0; //init stack pointer to same as zero page, set to 16'h0001 for original 65Org16 address decoding
		zp_reg = 0;
		st_reg = 0; //shoud be same value as QAWXYS[SEL_SPP] for proper simulation
	end

/*
 * define some signals for watching in simulator output
 */


//`ifdef SIM
wire [dw-1:0]   Qacc = QAWXYS[SEL_Q];	// Accumulator
wire [dw-1:0]   Oacc = QAWXYS[SEL_O];	// Accumulator
wire [dw-1:0]   Nacc = QAWXYS[SEL_N];	// Accumulator
wire [dw-1:0]   Macc = QAWXYS[SEL_M];	// Accumulator
wire [dw-1:0]   Lacc = QAWXYS[SEL_L];	// Accumulator
wire [dw-1:0]   Kacc = QAWXYS[SEL_K];	// Accumulator
wire [dw-1:0]   Jacc = QAWXYS[SEL_J];	// Accumulator
wire [dw-1:0]   Iacc = QAWXYS[SEL_I];	// Accumulator
wire [dw-1:0]   Hacc = QAWXYS[SEL_H];	// Accumulator
wire [dw-1:0]   Gacc = QAWXYS[SEL_G];	// Accumulator
wire [dw-1:0]   Facc = QAWXYS[SEL_F];	// Accumulator
wire [dw-1:0]   Eacc = QAWXYS[SEL_E];	// Accumulator
wire [dw-1:0]   Dacc = QAWXYS[SEL_D];	// Accumulator
wire [dw-1:0]   Cacc = QAWXYS[SEL_C];	// Accumulator
wire [dw-1:0]   Bacc = QAWXYS[SEL_B];	// Accumulator
wire [dw-1:0]   Aacc = QAWXYS[SEL_A];	// Accumulator
wire [dw-1:0]   X = QAWXYS[SEL_X];	// X register
wire [dw-1:0]   Y = QAWXYS[SEL_Y];	// Y register
wire [dw-1:0]   W = QAWXYS[SEL_W];	// W register 
wire [dw-1:0]   S = QAWXYS[SEL_S];	// Stack pointer
wire [dw-1:0]	ZPP = QAWXYS[SEL_ZPP];	// Zero Page Pointer
wire [dw-1:0]	STP = QAWXYS[SEL_SPP];	// Stack Page Pointer
//`endif

wire [dw-1:0] P = { N, V, 3'b0, I, Z, C };

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
reg [dw-1:0] zp_reg;	// shadow ZPP write register
reg [dw-1:0] st_reg;	// shadow SPP write register
reg index_y;		// if set, then Y is index reg
reg index_w;		// if set, then W is index reg, otherwise X is index reg
reg load_reg;		// loading a register (A thru Q, W, X, Y, S) in this instruction
reg inc;		// increment
reg write_back;		// set if memory is read/modified/written 
reg load_only;		// LD[A..Q]/LDW/LDX/LDY instruction
reg store;		// doing store (ST[A..Q]/STW/STX/STY)
reg adc_sbc;		// doing ADC/SBC
reg compare;		// doing CMP/CPY/CPX/CPW
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
	BRK0:		AB = { st_reg, regfile };

	BRK1,
	JSR1,
	PULL1,
	RTS1,
	RTS2,
	RTI1,
	RTI2,
	RTI3,
	BRK2:		AB = { st_reg, ADD };

	INDY1,
	INDX1,
	ZPX1,
	INDX2:		AB = { zp_reg, ADD };

	ZP0,
	INDY0:		AB = { zp_reg, DIMUX };

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
 * register file, contains A thru Q, W, X, Y and S (stack pointer) registers. At each
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
 * write to a register. Usually this is the output of the
 * ALU, but in case of the JSR0 we use the S register to temporarily store
 * the PCL. This is possible, because the S register itself is stored in
 * the ALU during those cycles.
 */
always @(posedge clk)
    if( write_register & RDY )
	QAWXYS[regsel] <= (state == JSR0) ? DIMUX : ADD;
	
always @(posedge clk)
    if( write_register & RDY & (regsel == SEL_ZPP) )
       zp_reg <= ADD;

always @(posedge clk)
    if( write_register & RDY & (regsel == SEL_SPP) )
       st_reg <= ADD;



/*
 * register select logic. This determines which of the A thru Q, W, X, Y or
 * S registers will be accessed. 
 */

always @*  
    case( state )
	INDY1,
	INDX0,
	ZPX0,
    	ABSX0  : regsel = index_w ? SEL_W : index_y ? SEL_Y : SEL_X;

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
 * Update Z, N flags when writing A thru Q, W, X, Y, Memory, or when doing compare
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
		16'b0000_0000_0100_0000:	state <= RTI0;  // 
		16'b0000_0000_0100_1100:	state <= JMP0;
		16'b0000_0000_0110_0000:	state <= RTS0;
		16'b0000_0000_0110_1100:	state <= JMPI0;
		
		16'bxxxx_xxxx_xxx0_010x:	state <= ZP0;	 // even rows, columns 4,5
		16'bxxxx_xxxx_xxx0_0110:	state <= ZP0;	 // even rows, column 6
		16'bxxxx_xxxx_1xx0_0111:	state <= ZP0;	 // rows 8,A,C,E, column 7
		
		16'b0000_0000_xxx1_0000:	state <= BRA0;  // odd rows, column 0
		
		16'bxxxx_xxxx_xxx0_0001:	state <= INDX0; // even rows, column 1 --(zp,x)
		
		16'bxxxx_xxxx_xxx1_0001:	state <= INDY0; // odd rows, column 1 --(zp),y
		16'bxxxx_xxxx_xxx1_0010:	state <= INDY0; // odd rows, column 2 --(zp),w
				
		16'b0000_0000_x111_0100:	state <= ZPX0;  // STW zpx, LDW zpx
		16'b0000_0000_1xx1_0100:	state <= ZPX0;  // odd rows, column 4
		16'bxxxx_xxxx_xxx1_0101:	state <= ZPX0;  // odd rows, column 5
		16'bxxxx_xxxx_xxx1_0110:	state <= ZPX0;	 // odd rows, column 6
		16'b0000_0000_10x1_0111:	state <= ZPX0;	 // row 9,B, column 7
		
		16'bxxxx_xxxx_0010_1100:	state <= ABS0;  // BIT abs
		16'b0000_0000_1xx0_1100:	state <= ABS0;  // row 8,A,C,E, column C
		16'bxxxx_xxxx_xxx0_1101:	state <= ABS0;  // even rows, column D
		16'bxxxx_xxxx_xxx0_1110:	state <= ABS0;  // even rows, column E
		16'b0000_0000_1xx0_1111:	state <= ABS0;	 // rows 8,A,C,E, column F
		
		16'bxxxx_xxxx_xxx1_1xx1:	state <= ABSX0; // odd rows, column 9,B,D,F
		16'bxxxx_xxxx_xxx1_11x0:	state <= ABSX0; // odd rows, column C, E
		16'bxxxx_xxxx_xxx1_1101:	state <= ABSX0; // odd rows, column D
		16'b0000_0000_10x1_1111:	state <= ABSX0; // rows 9,B, column F
				
		16'bxx00_xx00_0x00_1000:	state <= PUSH0; // PH[A..Q], PHP
		16'b0000_0000_x101_1010:	state <= PUSH0; // PHX, PHY
		16'b0000_0000_0100_1011:	state <= PUSH0; // PHW
		
		16'b00xx_00xx_0x10_1000:	state <= PULL0; // PL[A..Q], PLP
		16'b0000_0000_x111_1010:	state <= PULL0; // PLY, PLX
		16'b0000_0000_0110_1011:	state <= PULL0; // PLW
		
		16'b0000_0000_1xx0_00x0:	state <= FETCH; // IMM, row 8,A,C,E, column 0,2
		16'bxxxx_xxxx_xxx0_1001:	state <= FETCH; // IMM, even rows, column 9
		
		16'bxxxx_xxxx_00xx_0111:	state <= REG;	 // T[A..Q]Z, T[A..Q]S, TZ[A..Q], TS[A..Q]
		16'b0000_0000_0xx1_1000:	state <= REG;   // CLC, SEC, CLI, SEI
		16'bxxxx_xxxx_1xxx_1000:	state <= REG;   // DEY, TY[A..Q], T[A..Q]Y, INY, INX, INW, DEW
		16'bxxxx_xxxx_0xx0_1010:	state <= REG;   // <shift/rotate> [A..Q], TX[A..Q]
		16'bxxxx_xxxx_10x0_1010:	state <= REG;
		16'bxxxx_xxxx_1100_1010:	state <= REG;
		16'bxxxx_xxxx_00x1_1010:	state <= REG;   // INC/DEC [A..Q]
		16'bxxxx_xxxx_10x1_1010:	state <= REG;   // TSX, TXS
		16'bxxxx_xxxx_1xx0_1011:	state <= REG;	 // T[A..Q][A..Q],TYX,TXY
		16'bxxxx_xxxx_0xxx_1111:	state <= REG;	 // TW[A..Q], T[A..Q]W, TWX, TWY, TXW, TYW
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
		16'bxxxx_0000_0xxx_x110,	// ASL, ROL, LSR, ROR (abs, absx, zpg, zpgx)
		16'bxxxx_xxxx_0xx0_1010:	// ASL[A..D]op[A..D], ROL[A..D]op[A..D], LSR[A..D]op[A..D], ROR[A..D]op[A..D] (acc)
					E_Reg <= IR[15:12]+1;	//note: no shift will occur when 'illegal' <shift, rotate> opcodes IR[15:12] = 1111. A +1 ensures compatibility with original NMOS6502 <shift,rotate> opcodes.

		default: E_Reg <= ADD;		
	endcase

always @(posedge clk)
     if( state == DECODE && RDY )
     	casex( IR[15:0] )
		16'b0000_0000_1010_0000,	// LDY
		16'bxxxx_xxxx_0xxx_0001,
		16'bxxxx_xxxx_1x1x_0001,	
		16'bxxxx_xxxx_0xx1_0010,
		16'bxxxx_xxxx_101x_0010,
		16'bxxxx_xxxx_1100_0010,	// LDW i
		16'bxxxx_xxxx_1111_0010,	// SBC[A..Q]op[A..Q] (zp)w
		16'bxxxx_xxxx_101x_0100,
		16'bxxxx_xxxx_11x1_0100,	
		16'bxxxx_xxxx_0xxx_0101,
		16'bxxxx_xxxx_1x1x_0101,
		16'bxxxx_0000_0xxx_0110,
		16'bxxxx_xxxx_1x1x_0110,
		16'bxxxx_xxxx_110x_0110,
		16'bxxxx_xxxx_00xx_0111,
		16'bxxxx_xxxx_101x_0111,	
				
		16'bxxxx_xxxx_xxx0_1000,   
		16'bxxxx_xxxx_1001_1000,	// TY[A..Q]
		16'bxxxx_xxxx_11x1_1000,
		16'bxxxx_xxxx_0xxx_1001,	
		16'bxxxx_xxxx_1x1x_1001,
		16'bxxxx_xxxx_0xxx_1010,
		16'bxxxx_xxxx_10xx_1010,
		16'bxxxx_xxxx_110x_1010,
		16'bxxxx_xxxx_1111_1010,
		16'bxxxx_xxxx_0xxx_1011,	 
		16'bxxxx_xxxx_1000_1011,	// T[A..Q][A..Q]
		16'bxxxx_xxxx_1x1x_1011,
		16'b0000_0000_1100_1011,	// TXY
		16'b0000_0000_101x_1100,	// LDY a, ax
		16'b0000_0000_1101_1100,	// LDW ax
		16'bxxxx_xxxx_0xxx_1101,
		16'bxxxx_xxxx_1x1x_1101,
		16'bxxxx_0000_0xxx_1110,
		16'bxxxx_xxxx_1x1x_1110,
		16'bxxxx_xxxx_110x_1110,
		16'bxxxx_xxxx_0xxx_1111,
		16'bxxxx_xxxx_101x_1111:
					load_reg <= 1;

		default:	load_reg <= 0;
	endcase

always @(posedge clk)
     if( state == DECODE && RDY )
     	casex( IR[15:0] )
		16'bxx00_xx00_0000_0111:	// T[A..Q]Z
				dst_reg <= SEL_ZPP;
				
		16'bxx00_xx00_0010_0111:	// T[A..Q]S
				dst_reg <= SEL_SPP;
				
		16'b0000_0000_1110_1000,	// INX
		16'b0000_0000_1100_1010,	// DEX
		16'bxx00_xx00_1010_xx10,	// LDX, T[A..Q]X
		16'b0000_0000_1011_x11x,	// LDX zpy/zpw, LDX ay,aw
		16'b0000_0000_1111_1010,	// PLX
		16'b0000_0000_1010_1011,	// TYX
		16'b0000_0000_0010_1111:	// TWX
				dst_reg <= SEL_X;

		16'bxx00_xx00_0100_1000,	// PH[A..Q]
		16'b0000_0000_0000_1000,	// PHP
		16'b0000_0000_x101_1010,	// PHX, PHY
		16'b0000_0000_0100_1011,	// PHW
		16'b0000_0000_1011_1010:	// TXS
				dst_reg <= SEL_S;

		16'b0000_0000_1x00_1000,	// DEY, INY
		16'b0000_0000_101x_x100,	// LDY a,ax, zp,zpx
		16'bxx00_xx00_1010_x000, 	// LDY #imm, T[A..Q]Y
		16'b0000_0000_0111_1010,	// PLY
		16'b0000_0000_1100_1011,	// TXY
		16'b0000_0000_0100_1111:	// TWY
				dst_reg <= SEL_Y;
				
		16'b0000_0000_11x1_1000,	// INW, DEW
		16'b0000_0000_1100_0010,	// LDW #
		16'b0000_0000_11x1_0100,	// LDW ax,zpx
		16'b0000_0000_1010_x111,	// LDW a,zp
		16'b0000_0000_0110_1011,	// PLW
		16'bxx00_xx00_0xx1_1111:	// T[A..Q]W, TXW, TYW
				dst_reg <= SEL_W;

		16'b0000_0000_00x1_0111,	// TZ[A], TS[A]
		16'bxx00_xx00_1000_1011,	// T[A..Q][A]
		16'b0000_0000_00x1_1010,	// INC[A], DEC[A]
		16'b0000_0000_0110_1000,	// PL[A]
		16'b0000_0000_1000_1010,	// TX[A]
		16'b0000_0000_1001_1000,	// TY[A]
		16'b0000_0000_0000_1111,	// TW[A]
		16'b0000_0000_101x_xx01,	// LD[A]i, (zpx), (zp)y, zp, zpx, zpy, ay, a, ax
		16'b0000_0000_1011_1011,	// LD[A]w
		16'b0000_0000_1011_0010,	// LD[A](zp)w
		16'bxx00_xx00_0xxx_xx01,	// ADC[A..Q]op[A], SBC[A..Q]op[A], AND[A..Q]op[A], ORA[A..Q]op[A], EOR[A..Q]op[A]
		16'bxx00_xx00_111x_xx01,	// SBC[A..Q]op[A]
		16'bxx00_xx00_0xx0_0010,	// ORA[A..Q]op[A] (zp)w, AND[A..Q]op[A] (zp)w, ADC[A..Q]op[A] (zp)w
		16'bxx00_xx00_0xx0_1011,	// ORA[A..Q]op[A] aw, AND[A..Q]op[A] aw, ADC[A..Q]op[A] aw
		16'bxx00_xx00_1111_0010,	// SBC[A..Q]op[A] (zp)y
		16'bxx00_xx00_1111_1011,	// SBC[A..Q]op[A] aw
		16'bxxxx_xx00_0xx0_1010,	// ASL[A..D]op[A], ROL[A..D]op[A], LSR[A..D]op[A], ROR[A..D]op[A] (acc)
		16'b0000_0000_0010_x100:	// BIT[A] zp, a
				dst_reg <= SEL_A; 
      
		16'b0000_0001_00x1_0111,	// TZ[B], TS[B]
		16'bxx00_xx01_1000_1011,	// T[A..Q][B]
		16'b0000_0101_00x1_1010,	// INC[B], DEC[B]
		16'b0000_0001_0110_1000,	// PL[B]
		16'b0000_0001_1000_1010,	// TX[B]
		16'b0000_0001_1001_1000, 	// TY[B]
		16'b0000_0001_0000_1111,	// TW[B]
		16'b0000_0001_101x_xx01,	// LD[B]i, (zpx), (zp)y, zp, zpx, zpy, ay, a, ax
		16'b0000_0001_1011_1011,	// LD[B]w
		16'b0000_0001_1011_0010,	// LD[B](zp)w
		16'bxx00_xx01_0xxx_xx01,	// ADC[A..Q]op[B], SBC[A..Q]op[B], AND[A..Q]op[B], ORA[A..Q]op[B], EOR[A..Q]op[B]
		16'bxx00_xx01_111x_xx01,	// SBC[A..Q]op[B]
		16'bxx00_xx01_0xx0_0010,	// ORA[A..Q]op[B] (zp)w, AND[A..Q]op[B] (zp)w, ADC[A..Q]op[B] (zp)w
		16'bxx00_xx01_0xx0_1011,	// ORA[A..Q]op[B] aw, AND[A..Q]op[B] aw, ADC[A..Q]op[B] aw
		16'bxx00_xx01_1111_0010,	// SBC[A..Q]op[B] (zp)y
		16'bxx00_xx01_1111_1011,	// SBC[A..Q]op[B] aw
		16'bxxxx_xx01_0xx0_1010,	// ASL[A..D]op[B], ROL[A..D]op[B], LSR[A..D]op[B], ROR[A..D]op[B] (acc)
		16'b0000_0101_0010_x100:	// BIT[B] zp, a
            dst_reg <= SEL_B; 
      
		16'b0000_0010_00x1_0111,	// TZ[C], TS[C]
		16'bxx00_xx10_1000_1011,	// T[A..Q][C]
		16'b0000_1010_00x1_1010,	// INC[C], DEC[C]
		16'b0000_0010_0110_1000,	// PL[C]
		16'b0000_0010_1000_1010,	// TX[C]
		16'b0000_0010_1001_1000, 	// TY[C]
		16'b0000_0010_0000_1111,	// TW[C]
		16'b0000_0010_101x_xx01,	// LD[C]i, (zpx), (zp)y, zp, zpx, zpy, ay, a, ax
		16'b0000_0010_1011_1011,	// LD[C]w
		16'b0000_0010_1011_0010,	// LD[C](zp)w
		16'bxx00_xx10_0xxx_xx01,	// ADC[A..Q]op[C], SBC[A..Q]op[C], AND[A..Q]op[C], ORA[A..Q]op[C], EOR[A..Q]op[C]
		16'bxx00_xx10_111x_xx01,	// SBC[A..Q]op[C]
		16'bxx00_xx10_0xx0_0010,	// ORA[A..Q]op[C] (zp)w, AND[A..Q]op[C] (zp)w, ADC[A..Q]op[C] (zp)w
		16'bxx00_xx10_0xx0_1011,	// ORA[A..Q]op[C] aw, AND[A..Q]op[C] aw, ADC[A..Q]op[C] aw
		16'bxx00_xx10_1111_0010,	// SBC[A..Q]op[C] (zp)y
		16'bxx00_xx10_1111_1011,	// SBC[A..Q]op[C] aw
		16'bxxxx_xx10_0xx0_1010,	// ASL[A..D]op[C], ROL[A..D]op[C], LSR[A..D]op[C], ROR[A..D]op[C] (acc)
		16'b0000_1010_0010_x100:	// BIT[C] zp, a
            dst_reg <= SEL_C; 
       
		16'b0000_0011_00x1_0111,	// TZ[D], TS[D]
		16'bxx00_xx11_1000_1011,	// T[A..Q][D]
		16'b0000_1111_00x1_1010,	// INC[D], DEC[D]
		16'b0000_0011_0110_1000,	// PL[D]
		16'b0000_0011_1000_1010,	// TX[D]
		16'b0000_0011_1001_1000, 	// TY[D]
		16'b0000_0011_0000_1111,	// TW[D]
		16'b0000_0011_101x_xx01,	// LD[D]i, (zpx), (zp)y, zp, zpx, zpy, ay, a, ax
		16'b0000_0011_1011_1011,	// LD[D]w
		16'b0000_0011_1011_0010,	// LD[D](zp)w
		16'bxx00_xx11_0xxx_xx01,	// ADC[A..Q]op[D], SBC[A..Q]op[D], AND[A..Q]op[D], ORA[A..Q]op[D], EOR[A..Q]op[D]
		16'bxx00_xx11_111x_xx01,	// SBC[A..Q]op[D]
		16'bxx00_xx11_0xx0_0010,	// ORA[A..Q]op[D] (zp)w, AND[A..Q]op[D] (zp)w, ADC[A..Q]op[D] (zp)w
		16'bxx00_xx11_0xx0_1011,	// ORA[A..Q]op[D] aw, AND[A..Q]op[D] aw, ADC[A..Q]op[D] aw
		16'bxx00_xx11_1111_0010,	// SBC[A..Q]op[D] (zp)y
		16'bxx00_xx11_1111_1011,	// SBC[A..Q]op[D] aw
		16'bxxxx_xx11_0xx0_1010,	// ASL[A..D]op[D], ROL[A..D]op[D], LSR[A..D]op[D], ROR[A..D]op[D] (acc)
		16'b0000_1111_0010_x100:	// BIT[D] zp, a
		      dst_reg <= SEL_D;

		16'b0001_0000_00x1_0111,	// TZ[E], TS[E]
		16'bxx01_xx00_1000_1011,	// T[A..Q][E]
		16'b0101_0000_00x1_1010,	// INC[E], DEC[E]
		16'b0001_0000_0110_1000,	// PL[E]
		16'b0001_0000_1000_1010,	// TX[E]
		16'b0001_0000_1001_1000,	// TY[E]
		16'b0001_0000_0000_1111,	// TW[E]
		16'b0001_0000_101x_xx01,	// LD[E]i, (zpx), (zp)y, zp, zpx, zpy, ay, a, ax
		16'b0001_0000_1011_1011,	// LD[E]w
		16'b0001_0000_1011_0010,	// LD[E](zp)w
		16'bxx01_xx00_0xxx_xx01,	// ADC[A..Q]op[E], SBC[A..Q]op[E], AND[A..Q]op[E], ORA[A..Q]op[E], EOR[A..Q]op[E]
		16'bxx01_xx00_111x_xx01,	// SBC[A..Q]op[E]
		16'bxx01_xx00_0xx0_0010,	// ORA[A..Q]op[E] (zp)w, AND[A..Q]op[E] (zp)w, ADC[A..Q]op[E] (zp)w
		16'bxx01_xx00_0xx0_1011,	// ORA[A..Q]op[E] aw, AND[A..Q]op[E] aw, ADC[A..Q]op[E] aw
		16'bxx01_xx00_1111_0010,	// SBC[A..Q]op[E] (zp)y
		16'bxx01_xx00_1111_1011,	// SBC[A..Q]op[E] aw
		16'b0101_0000_0010_x100:	// BIT[E] zp, a
		      dst_reg <= SEL_E;

		16'b0001_0001_00x1_0111,	// TZ[F], TS[F]
		16'bxx01_xx01_1000_1011,	// T[A..Q][F]
		16'b0101_0101_00x1_1010,	// INC[F], DEC[F]
		16'b0001_0001_0110_1000,	// PL[F]
		16'b0001_0001_1000_1010,	// TX[F]
		16'b0001_0001_1001_1000, 	// TY[F]
		16'b0001_0001_0000_1111,	// TW[F]
		16'b0001_0001_101x_xx01,	// LD[F]i, (zpx), (zp)y, zp, zpx, zpy, ay, a, ax
		16'b0001_0001_1011_1011,	// LD[F]w
		16'b0001_0001_1011_0010,	// LD[F](zp)w
		16'bxx01_xx01_0xxx_xx01,	// ADC[A..Q]op[F], SBC[A..Q]op[F], AND[A..Q]op[F], ORA[A..Q]op[F], EOR[A..Q]op[F]
		16'bxx01_xx01_111x_xx01,	// SBC[A..Q]op[F]
		16'bxx01_xx01_0xx0_0010,	// ORA[A..Q]op[F] (zp)w, AND[A..Q]op[F] (zp)w, ADC[A..Q]op[F] (zp)w
		16'bxx01_xx01_0xx0_1011,	// ORA[A..Q]op[F] aw, AND[A..Q]op[F] aw, ADC[A..Q]op[F] aw
		16'bxx01_xx01_1111_0010,	// SBC[A..Q]op[F] (zp)y
		16'bxx01_xx01_1111_1011,	// SBC[A..Q]op[F] aw
		16'b0101_0101_0010_x100:	// BIT[F] zp, a
		      dst_reg <= SEL_F;

		16'b0001_0010_00x1_0111,	// TZ[G], TS[G]
		16'bxx01_xx10_1000_1011,	// T[A..Q][G]
		16'b0101_1010_00x1_1010,	// INC[G], DEC[G]
		16'b0001_0010_0110_1000,	// PL[G]
		16'b0001_0010_1000_1010,	// TX[G]
		16'b0001_0010_1001_1000, 	// TY[G]
		16'b0001_0010_0000_1111,	// TW[G]
		16'b0001_0010_101x_xx01,	// LD[G]i, (zpx), (zp)y, zp, zpx, zpy, ay, a, ax
		16'b0001_0010_1011_1011,	// LD[G]w
		16'b0001_0010_1011_0010,	// LD[G](zp)w
		16'bxx01_xx10_0xxx_xx01,	// ADC[A..Q]op[G], SBC[A..Q]op[G], AND[A..Q]op[G], ORA[A..Q]op[G], EOR[A..Q]op[G]
		16'bxx01_xx10_111x_xx01,	// SBC[A..Q]op[G]
		16'bxx01_xx10_0xx0_0010,	// ORA[A..Q]op[G] (zp)w, AND[A..Q]op[G] (zp)w, ADC[A..Q]op[G] (zp)w
		16'bxx01_xx10_0xx0_1011,	// ORA[A..Q]op[G] aw, AND[A..Q]op[G] aw, ADC[A..Q]op[G] aw
		16'bxx01_xx10_1111_0010,	// SBC[A..Q]op[G] (zp)y
		16'bxx01_xx10_1111_1011,	// SBC[A..Q]op[G] aw
		16'b0101_1010_0010_x100:	// BIT[G] zp, a
		      dst_reg <= SEL_G;

		16'b0001_0011_00x1_0111,	// TZ[H], TS[H]
		16'bxx01_xx11_1000_1011,	// T[A..Q][H]
		16'b0101_1111_00x1_1010,	// INC[H], DEC[H]
		16'b0001_0011_0110_1000,	// PL[H]
		16'b0001_0011_1000_1010,	// TX[H]
		16'b0001_0011_1001_1000, 	// TY[H]
		16'b0001_0011_0000_1111,	// TW[H]
		16'b0001_0011_101x_xx01,	// LD[H]i, (zpx), (zp)y, zp, zpx, zpy, ay, a, ax
		16'b0001_0011_1011_1011,	// LD[H]w
		16'b0001_0011_1011_0010,	// LD[H](zp)w
		16'bxx01_xx11_0xxx_xx01,	// ADC[A..Q]op[H], SBC[A..Q]op[H], AND[A..Q]op[H], ORA[A..Q]op[H], EOR[A..Q]op[H]
		16'bxx01_xx11_111x_xx01,	// SBC[A..Q]op[H]
		16'bxx01_xx11_0xx0_0010,	// ORA[A..Q]op[H] (zp)w, AND[A..Q]op[H] (zp)w, ADC[A..Q]op[H] (zp)w
		16'bxx01_xx11_0xx0_1011,	// ORA[A..Q]op[H] aw, AND[A..Q]op[H] aw, ADC[A..Q]op[H] aw
		16'bxx01_xx11_1111_0010,	// SBC[A..Q]op[H] (zp)y
		16'bxx01_xx11_1111_1011,	// SBC[A..Q]op[H] aw
		16'b0101_1111_0010_x100:	// BIT[H] zp, a
		      dst_reg <= SEL_H;

		16'b0010_0000_00x1_0111,	// TZ[I], TS[I]
		16'bxx10_xx00_1000_1011,	// T[A..Q][I]
		16'b1010_0000_00x1_1010,	// INC[I], DEC[I]
		16'b0010_0000_0110_1000,	// PL[I]
		16'b0010_0000_1000_1010,	// TX[I]
		16'b0010_0000_1001_1000, 	// TY[I]
		16'b0010_0000_0000_1111,	// TW[I]
		16'b0010_0000_101x_xx01,	// LD[I]i, (zpx), (zp)y, zp, zpx, zpy, ay, a, ax
		16'b0010_0000_1011_1011,	// LD[I]w
		16'b0010_0000_1011_0010,	// LD[I](zp)w
		16'bxx10_xx00_0xxx_xx01,	// ADC[A..Q]op[I], SBC[A..Q]op[I], AND[A..Q]op[I], ORA[A..Q]op[I], EOR[A..Q]op[I]
		16'bxx10_xx00_111x_xx01,	// SBC[A..Q]op[I]
		16'bxx10_xx00_0xx0_0010,	// ORA[A..Q]op[I] (zp)w, AND[A..Q]op[I] (zp)w, ADC[A..Q]op[I] (zp)w
		16'bxx10_xx00_0xx0_1011,	// ORA[A..Q]op[I] aw, AND[A..Q]op[I] aw, ADC[A..Q]op[I] aw
		16'bxx10_xx00_1111_0010,	// SBC[A..Q]op[I] (zp)y
		16'bxx10_xx00_1111_1011,	// SBC[A..Q]op[I] aw
		16'b1010_0000_0010_x100:	// BIT[I] zp, a
		      dst_reg <= SEL_I;

		16'b0010_0001_00x1_0111,	// TZ[J], TS[J]
		16'bxx10_xx01_1000_1011,	// T[A..Q][J]
		16'b1010_0101_00x1_1010,	// INC[J], DEC[J]
		16'b0010_0001_0110_1000,	// PL[J]
		16'b0010_0001_1000_1010,	// TX[J]
		16'b0010_0001_1001_1000, 	// TY[J]
		16'b0010_0001_0000_1111,	// TW[J]
		16'b0010_0001_101x_xx01,	// LD[J]i, (zpx), (zp)y, zp, zpx, zpy, ay, a, ax
		16'b0010_0001_1011_1011,	// LD[J]w
		16'b0010_0001_1011_0010,	// LD[J](zp)w
		16'bxx10_xx01_0xxx_xx01,	// ADC[A..Q]op[J], SBC[A..Q]op[J], AND[A..Q]op[J], ORA[A..Q]op[J], EOR[A..Q]op[J]
		16'bxx10_xx01_111x_xx01,	// SBC[A..Q]op[J]
		16'bxx10_xx01_0xx0_0010,	// ORA[A..Q]op[J] (zp)w, AND[A..Q]op[J] (zp)w, ADC[A..Q]op[J] (zp)w
		16'bxx10_xx01_0xx0_1011,	// ORA[A..Q]op[J] aw, AND[A..Q]op[J] aw, ADC[A..Q]op[J] aw
		16'bxx10_xx01_1111_0010,	// SBC[A..Q]op[J] (zp)y
		16'bxx10_xx01_1111_1011,	// SBC[A..Q]op[J] aw
		16'b1010_0101_0010_x100:	// BIT[J] zp, a
		      dst_reg <= SEL_J;

		16'b0010_0010_00x1_0111,	// TZ[K], TS[K]
		16'bxx10_xx10_1000_1011,	// T[A..Q][K]
		16'b1010_1010_00x1_1010,	// INC[K], DEC[K]
		16'b0010_0010_0110_1000,	// PL[K]
		16'b0010_0010_1000_1010,	// TX[K]
		16'b0010_0010_1001_1000, 	// TY[K]
		16'b0010_0010_0000_1111,	// TW[K]
		16'b0010_0010_101x_xx01,	// LD[K]i, (zpx), (zp)y, zp, zpx, zpy, ay, a, ax
		16'b0010_0010_1011_1011,	// LD[K]w
		16'b0010_0010_1011_0010,	// LD[K](zp)w
		16'bxx10_xx10_0xxx_xx01,	// ADC[A..Q]op[K], SBC[A..Q]op[K], AND[A..Q]op[K], ORA[A..Q]op[K], EOR[A..Q]op[K]
		16'bxx10_xx10_111x_xx01,	// SBC[A..Q]op[K]
		16'bxx10_xx10_0xx0_0010,	// ORA[A..Q]op[K] (zp)w, AND[A..Q]op[K] (zp)w, ADC[A..Q]op[K] (zp)w
		16'bxx10_xx10_0xx0_1011,	// ORA[A..Q]op[K] aw, AND[A..Q]op[K] aw, ADC[A..Q]op[K] aw
		16'bxx10_xx10_1111_0010,	// SBC[A..Q]op[K] (zp)y
		16'bxx10_xx10_1111_1011,	// SBC[A..Q]op[K] aw
		16'b1010_1010_0010_x100:	// BIT[K] zp, a
		      dst_reg <= SEL_K;

		16'b0010_0011_00x1_0111,	// TZ[L], TS[L]
		16'bxx10_xx11_1000_1011,	// T[A..Q][L]
		16'b1010_1111_00x1_1010,	// INC[L], DEC[L]
		16'b0010_0011_0110_1000,	// PL[L]
		16'b0010_0011_1000_1010,	// TX[L]
		16'b0010_0011_1001_1000, 	// TY[L]
		16'b0010_0011_0000_1111,	// TW[L]
		16'b0010_0011_101x_xx01,	// LD[L]i, (zpx), (zp)y, zp, zpx, zpy, ay, a, ax
		16'b0010_0011_1011_1011,	// LD[L]w
		16'b0010_0011_1011_0010,	// LD[L](zp)w
		16'bxx10_xx11_0xxx_xx01,	// ADC[A..Q]op[L], SBC[A..Q]op[L], AND[A..Q]op[L], ORA[A..Q]op[L], EOR[A..Q]op[L]
		16'bxx10_xx11_111x_xx01,	// SBC[A..Q]op[L]
		16'bxx10_xx11_0xx0_0010,	// ORA[A..Q]op[L] (zp)w, AND[A..Q]op[L] (zp)w, ADC[A..Q]op[L] (zp)w
		16'bxx10_xx11_0xx0_1011,	// ORA[A..Q]op[L] aw, AND[A..Q]op[L] aw, ADC[A..Q]op[L] aw
		16'bxx10_xx11_1111_0010,	// SBC[A..Q]op[L] (zp)y
		16'bxx10_xx11_1111_1011,	// SBC[A..Q]op[L] aw
		16'b1010_1111_0010_x100:	// BIT[L] zp, a
		      dst_reg <= SEL_L;

		16'b0011_0000_00x1_0111,	// TZ[M], TS[M]
		16'bxx11_xx00_1000_1011,	// T[A..Q][M]
		16'b1111_0000_00x1_1010,	// INC[M], DEC[M]
		16'b0011_0000_0110_1000,	// PL[M]
		16'b0011_0000_1000_1010,	// TX[M]
		16'b0011_0000_1001_1000, 	// TY[M]
		16'b0011_0000_0000_1111,	// TW[M]
		16'b0011_0000_101x_xx01,	// LD[M]i, (zpx), (zp)y, zp, zpx, zpy, ay, a, ax
		16'b0011_0000_1011_1011,	// LD[M]w
		16'b0011_0000_1011_0010,	// LD[M](zp)w
		16'bxx11_xx00_0xxx_xx01,	// ADC[A..Q]op[M], SBC[A..Q]op[M], AND[A..Q]op[M], ORA[A..Q]op[M], EOR[A..Q]op[M]
		16'bxx11_xx00_111x_xx01,	// SBC[A..Q]op[M]
		16'bxx11_xx00_0xx0_0010,	// ORA[A..Q]op[M] (zp)w, AND[A..Q]op[M] (zp)w, ADC[A..Q]op[M] (zp)w
		16'bxx11_xx00_0xx0_1011,	// ORA[A..Q]op[M] aw, AND[A..Q]op[M] aw, ADC[A..Q]op[M] aw
		16'bxx11_xx00_1111_0010,	// SBC[A..Q]op[M] (zp)y
		16'bxx11_xx00_1111_1011,	// SBC[A..Q]op[M] aw
		16'b1111_0000_0010_x100:	// BIT[M] zp, a
		      dst_reg <= SEL_M;

		16'b0011_0001_00x1_0111,	// TZ[N], TS[N]
		16'bxx11_xx01_1000_1011,	// T[A..Q][N]
		16'b1111_0101_00x1_1010,	// INC[N], DEC[N]
		16'b0011_0001_0110_1000,	// PL[N]
		16'b0011_0001_1000_1010,	// TX[N]
		16'b0011_0001_1001_1000, 	// TY[N]
		16'b0011_0001_0000_1111,	// TW[N]
		16'b0011_0001_101x_xx01,	// LD[N]i, (zpx), (zp)y, zp, zpx, zpy, ay, a, ax
		16'b0011_0001_1011_1011,	// LD[N]w
		16'b0011_0001_1011_0010,	// LD[N](zp)w
		16'bxx11_xx01_0xxx_xx01,	// ADC[A..Q]op[N], SBC[A..Q]op[N], AND[A..Q]op[N], ORA[A..Q]op[N], EOR[A..Q]op[N]
		16'bxx11_xx01_111x_xx01,	// SBC[A..Q]op[N]
		16'bxx11_xx01_0xx0_0010,	// ORA[A..Q]op[N] (zp)w, AND[A..Q]op[N] (zp)w, ADC[A..Q]op[N] (zp)w
		16'bxx11_xx01_0xx0_1011,	// ORA[A..Q]op[N] aw, AND[A..Q]op[N] aw, ADC[A..Q]op[N] aw
		16'bxx11_xx01_1111_0010,	// SBC[A..Q]op[N] (zp)y
		16'bxx11_xx01_1111_1011,	// SBC[A..Q]op[N] aw
		16'b1111_0101_0010_x100:	// BIT[N] zp, a
		      dst_reg <= SEL_N;

		16'b0011_0010_00x1_0111,	// TZ[O], TS[O]
		16'bxx11_xx10_1000_1011,	// T[A..Q][O]
		16'b1111_1010_00x1_1010,	// INC[O], DEC[O]
		16'b0011_0010_0110_1000,	// PL[O]
		16'b0011_0010_1000_1010,	// TX[O]
		16'b0011_0010_1001_1000, 	// TY[O]
		16'b0011_0010_0000_1111,	// TW[O]
		16'b0011_0010_101x_xx01,	// LD[O]i, (zpx), (zp)y, zp, zpx, zpy, ay, a, ax
		16'b0011_0010_1011_1011,	// LD[O]w
		16'b0011_0010_1011_0010,	// LD[O](zp)w
		16'bxx11_xx10_0xxx_xx01,	// ADC[A..Q]op[O], SBC[A..Q]op[O], AND[A..Q]op[O], ORA[A..Q]op[O], EOR[A..Q]op[O]
		16'bxx11_xx10_111x_xx01,	// SBC[A..Q]op[O]
		16'bxx11_xx10_0xx0_0010,	// ORA[A..Q]op[O] (zp)w, AND[A..Q]op[O] (zp)w, ADC[A..Q]op[O] (zp)w
		16'bxx11_xx10_0xx0_1011,	// ORA[A..Q]op[O] aw, AND[A..Q]op[O] aw, ADC[A..Q]op[O] aw
		16'bxx11_xx10_1111_0010,	// SBC[A..Q]op[O] (zp)y
		16'bxx11_xx10_1111_1011,	// SBC[A..Q]op[O] aw
		16'b1111_1010_0010_x100:	// BIT[O] zp, a
		      dst_reg <= SEL_O;

		16'b0011_0011_00x1_0111,	// TZ[Q], TS[Q]
		16'bxx11_xx11_1000_1011,	// T[A..Q][Q]
		16'b1111_1111_00x1_1010,	// INC[Q], DEC[Q]
		16'b0011_0011_0110_1000,	// PL[Q]
		16'b0011_0011_1000_1010,	// TX[Q]
		16'b0011_0011_1001_1000, 	// TY[Q]
		16'b0011_0011_0000_1111,	// TW[Q]
		16'b0011_0011_101x_xx01,	// LD[Q]i, (zpx), (zp)y, zp, zpx, zpy, ay, a, ax
		16'b0011_0011_1011_1011,	// LD[Q]w
		16'b0011_0011_1011_0010,	// LD[Q](zp)w
		16'bxx11_xx11_0xxx_xx01,	// ADC[A..Q]op[Q], SBC[A..Q]op[Q], AND[A..Q]op[Q], ORA[A..Q]op[Q], EOR[A..Q]op[Q]
		16'bxx11_xx11_111x_xx01,	// SBC[A..Q]op[Q]
		16'bxx11_xx11_0xx0_0010,	// ORA[A..Q]op[Q] (zp)w, AND[A..Q]op[Q] (zp)w, ADC[A..Q]op[Q] (zp)w
		16'bxx11_xx11_0xx0_1011,	// ORA[A..Q]op[Q] aw, AND[A..Q]op[Q] aw, ADC[A..Q]op[Q] aw
		16'bxx11_xx11_1111_0010,	// SBC[A..Q]op[Q] (zp)y
		16'bxx11_xx11_1111_1011,	// SBC[A..Q]op[Q] aw
		16'b1111_1111_0010_x100:	// BIT[Q] zp, a
		      dst_reg <= SEL_Q;

	endcase

always @(posedge clk)
     if( state == DECODE && RDY )
     	casex( IR[15:0] )
		16'b00xx_00xx_0001_0111:	// TZ[A..Q]
				src_reg <= SEL_ZPP;
				
		16'b00xx_00xx_0011_0111:	// TS[A..Q]
				src_reg <= SEL_SPP;
		
		16'b00xx_00xx_0110_1000,	// PL[A..Q]
		16'b0000_0000_x111_1010,	// PLX, PLY
		16'b0000_0000_0110_1011,	// PLW
		16'b0000_0000_0010_1000,	// PLP
		16'b0000_0000_1011_1010:	// TSX 
				src_reg <= SEL_S; 

		16'b0000_0000_100x_x110,	// STX zp,zpy,a,ay
		16'b0000_0000_1001_x111,	// STX zpw,aw
		16'b00xx_00xx_100x_1010,	// TX[A..Q], TXS
		16'b0000_0000_1110_xx00,	// INX, CPX
		16'b0000_0000_1100_1010,	// DEX
		16'b0000_0000_1100_1011,	// TXY
		16'b0000_0000_1101_1010,	// PHX
		16'b0000_0000_0011_1111:	// TXW
				src_reg <= SEL_X; 

		16'b0000_0000_100x_x100,	// STY zp,zpx,a
		16'b00xx_00xx_1001_1000,	// TY[A..Q]
		16'b0000_0000_1100_0x00,	// CPY imm,zp
		16'b0000_0000_1100_1100,	// CPY a
		16'b0000_0000_1x00_1000,	// DEY, INY
		16'b0000_0000_1010_1011,	// TYX
		16'b0000_0000_0101_1010,	// PHY
		16'b0000_0000_0101_1111:	// TYW
				src_reg <= SEL_Y;
		
		16'b0000_0000_11x1_1000,	// INW, DEW
		16'b0000_0000_1110_0010,	// CPW imm
		16'b0000_0000_1100_x111,	// CPW zp,a
		16'b0000_0000_1000_x111,	//	STW zp,a
		16'b0000_0000_0111_0100,	// STW zpx
		16'b0000_0000_0100_1011,	// PHW
		16'b00xx_00xx_0xx0_1111:	// TW[A..Q], TWX, TWY
				src_reg <= SEL_W;

		16'b0000_0000_00x0_0111,	// T[A]Z, T[A]S
		16'b00xx_00xx_1000_1011,	// T[A][A..Q]
		16'b0000_0000_00x1_1010,	// INC[A], DEC[A]
		16'b0000_0000_0100_1000,	// PH[A]
		16'b0000_0000_1010_10x0,	// T[A]X, T[A]Y
		16'b0000_0000_0001_1111,	// T[A]W
		16'b0000_0000_100x_xx01,	// ST[A]i, (zpx), (zp)y, zp, zpx, zpy, ay, a, ax
		16'b0000_0000_1001_0010,	// ST[A] (zp)w
		16'b0000_0000_1001_1011,	// ST[A] aw
		16'b0000_0000_110x_xx01,	// CMP[A] i, (zpx), (zp)y, zp, zpx, ay, ax, a
		16'b0000_0000_1101_0010,	// CMP[A] (zp)w
		16'b0000_0000_1101_1011,	// CMP[A] aw
		16'b00xx_00xx_0xxx_xx01,	// ADC[A]op[A..Q], SBC[A]op[A..Q], AND[A]op[A..Q], ORA[A]op[A..Q], EOR[A]op[A..Q]
		16'b00xx_00xx_111x_xx01,	// SBC[A]op[A..Q]
		16'b00xx_00xx_0xx0_0010,	// ORA[A]op[A..Q] (zp)w, AND[A]op[A..Q] (zp)w, ADC[A]op[A..Q] (zp)w
		16'b00xx_00xx_0xx0_1011,	// ORA[A]op[A..Q] aw, AND[A]op[A..Q] aw, ADC[A]op[A..Q] aw
		16'b00xx_00xx_1111_0010,	// SBC[A]op[A..Q] (zp)y
		16'b00xx_00xx_1111_1011,	// SBC[A]op[A..Q] aw
		16'bxxxx_00xx_0xx0_1010,	// ASL[A]op[A..D], ROL[A]op[A..D], LSR[A]op[A..D], ROR[A]op[A..D] (acc)
		16'b0000_0000_0010_x100:	// BIT[A] zp, a
            src_reg <= SEL_A; 
      
		16'b0000_0100_00x0_0111,	// T[B]Z, T[B]S		
		16'b00xx_01xx_1000_1011,	// T[B][A..Q]
		16'b0000_0101_00x1_1010,	// INC[B], DEC[B]
		16'b0000_0100_0100_1000,	// PH[B]
		16'b0000_0100_1010_10x0,	// T[B]X, T[B]Y
		16'b0000_0100_0001_1111,	// T[B]W
		16'b0000_0100_100x_xx01,	// ST[B] (zpx),(zp)y, zp, zpx, ay, a, ax
		16'b0000_0100_1001_0010,	// ST[B] (zp)w
		16'b0000_0100_1001_1011,	// ST[B] aw
		16'b0000_0100_110x_xx01,	// CMP[B] i, (zpx), (zp)y, zp, zpx, ay, ax, a
		16'b0000_0100_1101_0010,	// CMP[B] (zp)w
		16'b0000_0100_1101_1011,	// CMP[B] aw
		16'b00xx_01xx_0xxx_xx01,	// ADC[B]op[A..Q], SBC[B]op[A..Q], AND[B]op[A..Q], ORA[B]op[A..Q], EOR[B]op[A..Q]
		16'b00xx_01xx_111x_xx01,	// SBC[B]op[A..Q]
		16'b00xx_01xx_0xx0_0010,	// ORA[B]op[A..Q] (zp)w, AND[B]op[A..Q] (zp)w, ADC[B]op[A..Q] (zp)w
		16'b00xx_01xx_0xx0_1011,	// ORA[B]op[A..Q] aw, AND[B]op[A..Q] aw, ADC[B]op[A..Q] aw
		16'b00xx_01xx_1111_0010,	// SBC[B]op[A..Q] (zp)y
		16'b00xx_01xx_1111_1011,	// SBC[B]op[A..Q] aw
		16'bxxxx_01xx_0xx0_1010,	// ASL[B]op[A..D], ROL[B]op[A..D], LSR[B]op[A..D], ROR[B]op[A..D] (acc)
		16'b0000_0101_0010_x100:	// BIT[B] zp, a
            src_reg <= SEL_B; 

		16'b0000_1000_00x0_0111,	// T[C]Z, T[C]S
		16'b00xx_10xx_1000_1011,	// T[C][A..Q]
		16'b0000_1010_00x1_1010,	// INC[C], DEC[C]
		16'b0000_1000_0100_1000,	// PH[C]
		16'b0000_1000_1010_10x0,	// T[C]X, T[C]Y
		16'b0000_1000_0001_1111,	// T[C]W
		16'b0000_1000_100x_xx01,	// ST[C] (zpx),(zp)y, zp, zpx, ay, a, ax
		16'b0000_1000_1001_0010,	// ST[C] (zp)w
		16'b0000_1000_1001_1011,	// ST[C] aw
		16'b0000_1000_110x_xx01,	// CMP[C] i, (zpx), (zp)y, zp, zpx, ay, ax, a
		16'b0000_1000_1101_0010,	// CMP[C] (zp)w
		16'b0000_1000_1101_1011,	// CMP[C] aw
		16'b00xx_10xx_0xxx_xx01,	// ADC[C]op[A..Q], SBC[C]op[A..Q], AND[C]op[A..Q], ORA[C]op[A..Q], EOR[C]op[A..Q]
		16'b00xx_10xx_111x_xx01,	// SBC[C]op[A..Q]
		16'b00xx_10xx_0xx0_0010,	// ORA[C]op[A..Q] (zp)w, AND[C]op[A..Q] (zp)w, ADC[C]op[A..Q] (zp)w
		16'b00xx_10xx_0xx0_1011,	// ORA[C]op[A..Q] aw, AND[C]op[A..Q] aw, ADC[C]op[A..Q] aw
		16'b00xx_10xx_1111_0010,	// SBC[C]op[A..Q] (zp)y
		16'b00xx_10xx_1111_1011,	// SBC[C]op[A..Q] aw
		16'bxxxx_10xx_0xx0_1010,	// ASL[C]op[A..D], ROL[C]op[A..D], LSR[C]op[A..D], ROR[C]op[A..D] (acc)
		16'b0000_1010_0010_x100:	// BIT[C] zp, a
            src_reg <= SEL_C; 
      
		16'b0000_1100_00x0_0111,	// T[D]Z, T[D]S
		16'b00xx_11xx_1000_1011,	// T[D][A..Q]
		16'b0000_1111_00x1_1010,	// INC[D], DEC[D]
		16'b0000_1100_0100_1000,	// PH[D]
		16'b0000_1100_1010_10x0,	// T[D]X, T[D]Y
		16'b0000_1100_0001_1111,	// T[D]W
		16'b0000_1100_100x_xx01,	// ST[D] (zpx),(zp)y, zp, zpx, ay, a, ax
		16'b0000_1100_1001_0010,	// ST[D] (zp)w
		16'b0000_1100_1001_1011,	// ST[D] aw
		16'b0000_1100_110x_xx01,	// CMP[D] i, (zpx), (zp)y, zp, zpx, ay, ax, a
		16'b0000_1100_1101_0010,	// CMP[D] (zp)w
		16'b0000_1100_1101_1011,	// CMP[D] aw
		16'b00xx_11xx_0xxx_xx01,	// ADC[D]op[A..Q], SBC[D]op[A..Q], AND[D]op[A..Q], ORA[D]op[A..Q], EOR[D]op[A..Q]
		16'b00xx_11xx_111x_xx01,	// SBC[D]op[A..Q]
		16'b00xx_11xx_0xx0_0010,	// ORA[D]op[A..Q] (zp)w, AND[A]op[A..Q] (zp)w, ADC[D]op[A..Q] (zp)w
		16'b00xx_11xx_0xx0_1011,	// ORA[D]op[A..Q] aw, AND[A]op[A..Q] aw, ADC[D]op[A..Q] aw
		16'b00xx_11xx_1111_0010,	// SBC[D]op[A..Q] (zp)y
		16'b00xx_11xx_1111_1011,	// SBC[D]op[A..Q] aw
		16'bxxxx_11xx_0xx0_1010,	// ASL[D]op[A..D], ROL[D]op[A..D], LSR[D]op[A..D], ROR[D]op[A..D] (acc)
		16'b0000_1111_0010_x100:	// BIT[D] zp, a
            src_reg <= SEL_D;

		16'b0100_0000_00x0_0111,	// T[E]Z, T[E]S
		16'b01xx_00xx_1000_1011,	// T[E][A..Q]
		16'b0101_0000_00x1_1010,	// INC[E], DEC[E]
		16'b0100_0000_0100_1000,	// PH[E]
		16'b0100_0000_1010_10x0,	// T[E]X, T[E]Y
		16'b0100_0000_0001_1111,	// T[E]W
		16'b0100_0000_100x_xx01,	// ST[E] (zpx),(zp)y, zp, zpx, ay, a, ax
		16'b0100_0000_1001_0010,	// ST[E] (zp)w
		16'b0100_0000_1001_1011,	// ST[E] aw
		16'b0100_0000_110x_xx01,	// CMP[E] i, (zpx), (zp)y, zp, zpx, ay, ax, a
		16'b0100_0000_1101_0010,	// CMP[E] (zp)w
		16'b0100_0000_1101_1011,	// CMP[E] aw
		16'b01xx_00xx_0xxx_xx01,	// ADC[E]op[A..Q], SBC[E]op[A..Q], AND[E]op[A..Q], ORA[E]op[A..Q], EOR[E]op[A..Q]
		16'b01xx_00xx_111x_xx01,	// SBC[E]op[A..Q]
		16'b01xx_00xx_0xx0_0010,	// ORA[E]op[A..Q] (zp)w, AND[E]op[A..Q] (zp)w, ADC[E]op[A..Q] (zp)w
		16'b01xx_00xx_0xx0_1011,	// ORA[E]op[A..Q] aw, AND[E]op[A..Q] aw, ADC[E]op[A..Q] aw
		16'b01xx_00xx_1111_0010,	// SBC[E]op[A..Q] (zp)y
		16'b01xx_00xx_1111_1011,	// SBC[E]op[A..Q] aw
		16'b0101_0000_0010_x100:	// BIT[E] zp, a
				src_reg <= SEL_E;

		16'b0100_0100_00x0_0111,	// T[F]Z, T[F]S
		16'b01xx_01xx_1000_1011,	// T[F][A..Q]
		16'b0101_0101_00x1_1010,	// INC[F], DEC[F]
		16'b0100_0100_0100_1000,	// PH[F]
		16'b0100_0100_1010_10x0,	// T[F]X, T[F]Y
		16'b0100_0100_0001_1111,	// T[F]W
		16'b0100_0100_100x_xx01,	// ST[F] (zpx),(zp)y, zp, zpx, ay, a, ax
		16'b0100_0100_1001_0010,	// ST[F] (zp)w
		16'b0100_0100_1001_1011,	// ST[F] aw
		16'b0100_0100_110x_xx01,	// CMP[F] i, (zpx), (zp)y, zp, zpx, ay, ax, a
		16'b0100_0100_1101_0010,	// CMP[F] (zp)w
		16'b0100_0100_1101_1011,	// CMP[F] aw
		16'b01xx_01xx_0xxx_xx01,	// ADC[F]op[A..Q], SBC[F]op[A..Q], AND[F]op[A..Q], ORA[F]op[A..Q], EOR[F]op[A..Q]
		16'b01xx_01xx_111x_xx01,	// SBC[F]op[A..Q]
		16'b01xx_01xx_0xx0_0010,	// ORA[F]op[A..Q] (zp)w, AND[F]op[A..Q] (zp)w, ADC[F]op[A..Q] (zp)w
		16'b01xx_01xx_0xx0_1011,	// ORA[F]op[A..Q] aw, AND[F]op[A..Q] aw, ADC[F]op[A..Q] aw
		16'b01xx_01xx_1111_0010,	// SBC[F]op[A..Q] (zp)y
		16'b01xx_01xx_1111_1011,	// SBC[F]op[A..Q] aw
		16'b0101_0101_0010_x100:	// BIT[F] zp, a
				src_reg <= SEL_F;

		16'b0100_1000_00x0_0111,	// T[G]Z, T[G]S
		16'b01xx_10xx_1000_1011,	// T[G][A..Q]
		16'b0101_1010_00x1_1010,	// INC[G], DEC[G]
		16'b0100_1000_0100_1000,	// PH[G]
		16'b0100_1000_1010_10x0,	// T[G]X, T[G]Y
		16'b0100_1000_0001_1111,	// T[G]W
		16'b0100_1000_100x_xx01,	// ST[G] (zpx),(zp)y, zp, zpx, ay, a, ax
		16'b0100_1000_1001_0010,	// ST[G] (zp)w
		16'b0100_1000_1001_1011,	// ST[G] aw
		16'b0100_1000_110x_xx01,	// CMP[G] i, (zpx), (zp)y, zp, zpx, ay, ax, a
		16'b0100_1000_1101_0010,	// CMP[G] (zp)w
		16'b0100_1000_1101_1011,	// CMP[G] aw
		16'b01xx_10xx_0xxx_xx01,	// ADC[G]op[A..Q], SBC[G]op[A..Q], AND[G]op[A..Q], ORA[G]op[A..Q], EOR[G]op[A..Q]
		16'b01xx_10xx_111x_xx01,	// SBC[G]op[A..Q]
		16'b01xx_10xx_0xx0_0010,	// ORA[G]op[A..Q] (zp)w, AND[G]op[A..Q] (zp)w, ADC[G]op[A..Q] (zp)w
		16'b01xx_10xx_0xx0_1011,	// ORA[G]op[A..Q] aw, AND[G]op[A..Q] aw, ADC[G]op[A..Q] aw
		16'b01xx_10xx_1111_0010,	// SBC[G]op[A..Q] (zp)y
		16'b01xx_10xx_1111_1011,	// SBC[G]op[A..Q] aw
		16'b0101_1010_0010_x100:	// BIT[G] zp, a
				src_reg <= SEL_G;

		16'b0100_1100_00x0_0111,	// T[H]Z, T[H]S
		16'b01xx_11xx_1000_1011,	// T[H][A..Q]
		16'b0101_1111_00x1_1010,	// INC[H], DEC[H]
		16'b0100_1100_0100_1000,	// PH[H]
		16'b0100_1100_1010_10x0,	// T[H]X, T[H]Y
		16'b0100_1100_0001_1111,	// T[H]W
		16'b0100_1100_100x_xx01,	// ST[H] (zpx),(zp)y, zp, zpx, ay, a, ax
		16'b0100_1100_1001_0010,	// ST[H] (zp)w
		16'b0100_1100_1001_1011,	// ST[H] aw
		16'b0100_1100_110x_xx01,	// CMP[H] i, (zpx), (zp)y, zp, zpx, ay, ax, a
		16'b0100_1100_1101_0010,	// CMP[H] (zp)w
		16'b0100_1100_1101_1011,	// CMP[H] aw
		16'b01xx_11xx_0xxx_xx01,	// ADC[H]op[A..Q], SBC[H]op[A..Q], AND[H]op[A..Q], ORA[H]op[A..Q], EOR[H]op[A..Q]
		16'b01xx_11xx_111x_xx01,	// SBC[H]op[A..Q]
		16'b01xx_11xx_0xx0_0010,	// ORA[H]op[A..Q] (zp)w, AND[H]op[A..Q] (zp)w, ADC[H]op[A..Q] (zp)w
		16'b01xx_11xx_0xx0_1011,	// ORA[H]op[A..Q] aw, AND[H]op[A..Q] aw, ADC[H]op[A..Q] aw
		16'b01xx_11xx_1111_0010,	// SBC[H]op[A..Q] (zp)y
		16'b01xx_11xx_1111_1011,	// SBC[H]op[A..Q] aw
		16'b0101_1111_0010_x100:	// BIT[H] zp, a
				src_reg <= SEL_H;

		16'b1000_0000_00x0_0111,	// T[I]Z, T[I]S
		16'b10xx_00xx_1000_1011,	// T[I][A..Q]
		16'b1010_0000_00x1_1010,	// INC[I], DEC[I]
		16'b1000_0000_0100_1000,	// PH[I]
		16'b1000_0000_1010_10x0,	// T[I]X, T[I]Y
		16'b1000_0000_0001_1111,	// T[I]W
		16'b1000_0000_100x_xx01,	// ST[I] (zpx),(zp)y, zp, zpx, ay, a, ax
		16'b1000_0000_1001_0010,	// ST[I] (zp)w
		16'b1000_0000_1001_1011,	// ST[I] aw
		16'b1000_0000_110x_xx01,	// CMP[I] i, (zpx), (zp)y, zp, zpx, ay, ax, a
		16'b1000_0000_1101_0010,	// CMP[I] (zp)w
		16'b1000_0000_1101_1011,	// CMP[I] aw
		16'b10xx_00xx_0xxx_xx01,	// ADC[I]op[A..Q], SBC[I]op[A..Q], AND[I]op[A..Q], ORA[I]op[A..Q], EOR[I]op[A..Q]
		16'b10xx_00xx_111x_xx01,	// SBC[I]op[A..Q]
		16'b10xx_00xx_0xx0_0010,	// ORA[I]op[A..Q] (zp)w, AND[I]op[A..Q] (zp)w, ADC[I]op[A..Q] (zp)w
		16'b10xx_00xx_0xx0_1011,	// ORA[I]op[A..Q] aw, AND[I]op[A..Q] aw, ADC[I]op[A..Q] aw
		16'b10xx_00xx_1111_0010,	// SBC[I]op[A..Q] (zp)y
		16'b10xx_00xx_1111_1011,	// SBC[I]op[A..Q] aw
		16'b1010_0000_0010_x100:	// BIT[I] zp, a
				src_reg <= SEL_I;

		16'b1000_0100_00x0_0111,	// T[J]Z, T[J]S
		16'b10xx_01xx_1000_1011,	// T[J][A..Q]
		16'b1010_0101_00x1_1010,	// INC[J], DEC[J]
		16'b1000_0100_0100_1000,	// PH[J]
		16'b1000_0100_1010_10x0,	// T[J]X, T[J]Y
		16'b1000_0100_0001_1111,	// T[J]W
		16'b1000_0100_100x_xx01,	// ST[J] (zpx),(zp)y, zp, zpx, ay, a, ax
		16'b1000_0100_1001_0010,	// ST[J] (zp)w
		16'b1000_0100_1001_1011,	// ST[J] aw
		16'b1000_0100_110x_xx01,	// CMP[J] i, (zpx), (zp)y, zp, zpx, ay, ax, a
		16'b1000_0100_1101_0010,	// CMP[J] (zp)w
		16'b1000_0100_1101_1011,	// CMP[J] aw
		16'b10xx_01xx_0xxx_xx01,	// ADC[J]op[A..Q], SBC[J]op[A..Q], AND[J]op[A..Q], ORA[J]op[A..Q], EOR[J]op[A..Q]
		16'b10xx_01xx_111x_xx01,	// SBC[J]op[A..Q]
		16'b10xx_01xx_0xx0_0010,	// ORA[J]op[A..Q] (zp)w, AND[J]op[A..Q] (zp)w, ADC[J]op[A..Q] (zp)w
		16'b10xx_01xx_0xx0_1011,	// ORA[J]op[A..Q] aw, AND[J]op[A..Q] aw, ADC[J]op[A..Q] aw
		16'b10xx_01xx_1111_0010,	// SBC[J]op[A..Q] (zp)y
		16'b10xx_01xx_1111_1011,	// SBC[J]op[A..Q] aw
		16'b1010_0101_0010_x100:	// BIT[J] zp, a
				src_reg <= SEL_J;

		16'b1000_1000_00x0_0111,	// T[K]Z, T[K]S
		16'b10xx_10xx_1000_1011,	// T[K][A..Q]
		16'b1010_1010_00x1_1010,	// INC[K], DEC[K]
		16'b1000_1000_0100_1000,	// PH[K]
		16'b1000_1000_1010_10x0,	// T[K]X, T[K]Y
		16'b1000_1000_0001_1111,	// T[K]W
		16'b1000_1000_100x_xx01,	// ST[K] (zpx),(zp)y, zp, zpx, ay, a, ax
		16'b1000_1000_1001_0010,	// ST[K] (zp)w
		16'b1000_1000_1001_1011,	// ST[K] aw
		16'b1000_1000_110x_xx01,	// CMP[K] i, (zpx), (zp)y, zp, zpx, ay, ax, a
		16'b1000_1000_1101_0010,	// CMP[K] (zp)w
		16'b1000_1000_1101_1011,	// CMP[K] aw
		16'b10xx_10xx_0xxx_xx01,	// ADC[K]op[A..Q], SBC[K]op[A..Q], AND[K]op[A..Q], ORA[K]op[A..Q], EOR[K]op[A..Q]
		16'b10xx_10xx_111x_xx01,	// SBC[K]op[A..Q]
		16'b10xx_10xx_0xx0_0010,	// ORA[K]op[A..Q] (zp)w, AND[K]op[A..Q] (zp)w, ADC[K]op[A..Q] (zp)w
		16'b10xx_10xx_0xx0_1011,	// ORA[K]op[A..Q] aw, AND[K]op[A..Q] aw, ADC[K]op[A..Q] aw
		16'b10xx_10xx_1111_0010,	// SBC[K]op[A..Q] (zp)y
		16'b10xx_10xx_1111_1011,	// SBC[K]op[A..Q] aw
		16'b1010_1010_0010_x100:	// BIT[K] zp, a
				src_reg <= SEL_K;

		16'b1000_1100_00x0_0111,	// T[L]Z, T[L]S
		16'b10xx_11xx_1000_1011,	// T[L][A..Q]
		16'b1010_1111_00x1_1010,	// INC[L], DEC[L]
		16'b1000_1100_0100_1000,	// PH[L]
		16'b1000_1100_1010_10x0,	// T[L]X, T[L]Y
		16'b1000_1100_0001_1111,	// T[L]W
		16'b1000_1100_100x_xx01,	// ST[L] (zpx),(zp)y, zp, zpx, ay, a, ax
		16'b1000_1100_1001_0010,	// ST[L] (zp)w
		16'b1000_1100_1001_1011,	// ST[L] aw
		16'b1000_1100_110x_xx01,	// CMP[L] i, (zpx), (zp)y, zp, zpx, ay, ax, a
		16'b1000_1100_1101_0010,	// CMP[L] (zp)w
		16'b1000_1100_1101_1011,	// CMP[L] aw
		16'b10xx_11xx_0xxx_xx01,	// ADC[L]op[A..Q], SBC[L]op[A..Q], AND[L]op[A..Q], ORA[L]op[A..Q], EOR[L]op[A..Q]
		16'b10xx_11xx_111x_xx01,	// SBC[L]op[A..Q]
		16'b10xx_11xx_0xx0_0010,	// ORA[L]op[A..Q] (zp)w, AND[L]op[A..Q] (zp)w, ADC[L]op[A..Q] (zp)w
		16'b10xx_11xx_0xx0_1011,	// ORA[L]op[A..Q] aw, AND[L]op[A..Q] aw, ADC[L]op[A..Q] aw
		16'b10xx_11xx_1111_0010,	// SBC[L]op[A..Q] (zp)y
		16'b10xx_11xx_1111_1011,	// SBC[L]op[A..Q] aw
		16'b1010_1111_0010_x100:	// BIT[L] zp, a
				src_reg <= SEL_L;

		16'b1100_0000_00x0_0111,	// T[M]Z, T[M]S
		16'b11xx_00xx_1000_1011,	// T[M][A..Q]
		16'b1111_0000_00x1_1010,	// INC[M], DEC[M]
		16'b1100_0000_0100_1000,	// PH[M]
		16'b1100_0000_1010_10x0,	// T[M]X, T[M]Y
		16'b1100_0000_0001_1111,	// T[M]W
		16'b1100_0000_100x_xx01,	// ST[M] (zpx),(zp)y, zp, zpx, ay, a, ax
		16'b1100_0000_1001_0010,	// ST[M] (zp)w
		16'b1100_0000_1001_1011,	// ST[M] aw
		16'b1100_0000_110x_xx01,	// CMP[M] i, (zpx), (zp)y, zp, zpx, ay, ax, a
		16'b1100_0000_1101_0010,	// CMP[M] (zp)w
		16'b1100_0000_1101_1011,	// CMP[M] aw
		16'b11xx_00xx_0xxx_xx01,	// ADC[M]op[A..Q], SBC[M]op[A..Q], AND[M]op[A..Q], ORA[M]op[A..Q], EOR[M]op[A..Q]
		16'b11xx_00xx_111x_xx01,	// SBC[M]op[A..Q]
		16'b11xx_00xx_0xx0_0010,	// ORA[M]op[A..Q] (zp)w, AND[M]op[A..Q] (zp)w, ADC[M]op[A..Q] (zp)w
		16'b11xx_00xx_0xx0_1011,	// ORA[M]op[A..Q] aw, AND[M]op[A..Q] aw, ADC[M]op[A..Q] aw
		16'b11xx_00xx_1111_0010,	// SBC[M]op[A..Q] (zp)y
		16'b11xx_00xx_1111_1011,	// SBC[M]op[A..Q] aw
		16'b1111_0000_0010_x100:	// BIT[M] zp, a
				src_reg <= SEL_M;

		16'b1100_0100_00x0_0111,	// T[N]Z, T[N]S
		16'b11xx_01xx_1000_1011,	// T[N][A..Q]
		16'b1111_0101_00x1_1010,	// INC[N], DEC[N]
		16'b1100_0100_0100_1000,	// PH[N]
		16'b1100_0100_1010_10x0,	// T[N]X, T[N]Y
		16'b1100_0100_0001_1111,	// T[N]W
		16'b1100_0100_100x_xx01,	// ST[N] (zpx),(zp)y, zp, zpx, ay, a, ax
		16'b1100_0100_1001_0010,	// ST[N] (zp)w
		16'b1100_0100_1001_1011,	// ST[N] aw
		16'b1100_0100_110x_xx01,	// CMP[N] i, (zpx), (zp)y, zp, zpx, ay, ax, a
		16'b1100_0100_1101_0010,	// CMP[N] (zp)w
		16'b1100_0100_1101_1011,	// CMP[N] aw
		16'b11xx_01xx_0xxx_xx01,	// ADC[N]op[A..Q], SBC[N]op[A..Q], AND[N]op[A..Q], ORA[N]op[A..Q], EOR[N]op[A..Q]
		16'b11xx_01xx_111x_xx01,	// SBC[N]op[A..Q]
		16'b11xx_01xx_0xx0_0010,	// ORA[N]op[A..Q] (zp)w, AND[N]op[A..Q] (zp)w, ADC[N]op[A..Q] (zp)w
		16'b11xx_01xx_0xx0_1011,	// ORA[N]op[A..Q] aw, AND[N]op[A..Q] aw, ADC[N]op[A..Q] aw
		16'b11xx_01xx_1111_0010,	// SBC[N]op[A..Q] (zp)y
		16'b11xx_01xx_1111_1011,	// SBC[N]op[A..Q] aw
		16'b1111_0101_0010_x100:	// BIT[N] zp, a
				src_reg <= SEL_N;

		16'b1100_1000_00x0_0111,	// T[O]Z, T[O]S
		16'b11xx_10xx_1000_1011,	// T[O][A..Q]
		16'b1111_1010_00x1_1010,	// INC[O], DEC[O]
		16'b1100_1000_0100_1000,	// PH[O]
		16'b1100_1000_1010_10x0,	// T[O]X, T[O]Y
		16'b1100_1000_0001_1111,	// T[O]W
		16'b1100_1000_100x_xx01,	// ST[O] (zpx),(zp)y, zp, zpx, ay, a, ax
		16'b1100_1000_1001_0010,	// ST[O] (zp)w
		16'b1100_1000_1001_1011,	// ST[O] aw
		16'b1100_1000_110x_xx01,	// CMP[O] i, (zpx), (zp)y, zp, zpx, ay, ax, a
		16'b1100_1000_1101_0010,	// CMP[O] (zp)w
		16'b1100_1000_1101_1011,	// CMP[O] aw
		16'b11xx_10xx_0xxx_xx01,	// ADC[O]op[A..Q], SBC[O]op[A..Q], AND[O]op[A..Q], ORA[O]op[A..Q], EOR[O]op[A..Q]
		16'b11xx_10xx_111x_xx01,	// SBC[O]op[A..Q]
		16'b11xx_10xx_0xx0_0010,	// ORA[O]op[A..Q] (zp)w, AND[O]op[A..Q] (zp)w, ADC[O]op[A..Q] (zp)w
		16'b11xx_10xx_0xx0_1011,	// ORA[O]op[A..Q] aw, AND[O]op[A..Q] aw, ADC[O]op[A..Q] aw
		16'b11xx_10xx_1111_0010,	// SBC[O]op[A..Q] (zp)y
		16'b11xx_10xx_1111_1011,	// SBC[O]op[A..Q] aw
		16'b1111_1010_0010_x100:	// BIT[O] zp, a
				src_reg <= SEL_O;

		16'b1100_1100_00x0_0111,	// T[Q]Z, T[Q]S
		16'b11xx_11xx_1000_1011,	// T[Q][A..Q]
		16'b1111_1111_00x1_1010,	// INC[Q], DEC[Q]
		16'b1100_1100_0100_1000,	// PH[Q]
		16'b1100_1100_1010_10x0,	// T[Q]X, T[Q]Y
		16'b1100_1100_0001_1111,	// T[Q]W
		16'b1100_1100_100x_xx01,	// ST[Q] (zpx),(zp)y, zp, zpx, ay, a, ax
		16'b1100_1100_1001_0010,	// ST[Q] (zp)w
		16'b1100_1100_1001_1011,	// ST[Q] aw
		16'b1100_1100_110x_xx01,	// CMP[Q] i, (zpx), (zp)y, zp, zpx, ay, ax, a
		16'b1100_1100_1101_0010,	// CMP[Q] (zp)w
		16'b1100_1100_1101_1011,	// CMP[Q] aw
		16'b11xx_11xx_0xxx_xx01,	// ADC[Q]op[A..Q], SBC[Q]op[A..Q], AND[Q]op[A..Q], ORA[Q]op[A..Q], EOR[Q]op[A..Q]
		16'b11xx_11xx_111x_xx01,	// SBC[Q]op[A..Q]
		16'b11xx_11xx_0xx0_0010,	// ORA[Q]op[A..Q] (zp)w, AND[Q]op[A..Q] (zp)w, ADC[Q]op[A..Q] (zp)w
		16'b11xx_11xx_0xx0_1011,	// ORA[Q]op[A..Q] aw, AND[Q]op[A..Q] aw, ADC[Q]op[A..Q] aw
		16'b11xx_11xx_1111_0010,	// SBC[Q]op[A..Q] (zp)y
		16'b11xx_11xx_1111_1011,	// SBC[Q]op[A..Q] aw
		16'b1111_1111_0010_x100:	// BIT[Q] zp, a
				src_reg <= SEL_Q;
	
	endcase

always @(posedge clk) 
     if( state == DECODE && RDY )
     	casex( IR[15:0] )  			
		16'bxxxx_xxxx_xxx1_0001,	// INDY
		16'b0000_0000_10x1_x110, 	// LDX/STX zpy, ay
		16'bxxxx_xxxx_xxx1_1001:	// abs, Y
				index_y <= 1;

		default:	index_y <= 0;
	endcase

always @(posedge clk) 
     if( state == DECODE && RDY )
     	casex( IR[15:0] )  			
		16'bxxxx_xxxx_xxx1_0010,	// INDW
		16'b0000_0000_10x1_x111, 	// LDX/STX zpw, aw
		16'bxxxx_xxxx_xxx1_1011:	// abs, W
				index_w <= 1;

		default:	index_w <= 0;
	endcase

always @(posedge clk)
     if( state == DECODE && RDY )
     	casex( IR[15:0] )
		16'b0000_0000_0111_0100,	// STW zpx
		16'bxx00_xx00_1000_01xx,	// STY zp, ST[A..Q] zp, STX zp, STW zp
		16'bxx00_xx00_1001_x001,	// ST[A..Q] (zp)y, ay
		16'bxx00_xx00_1001_0010,	// ST[A..Q] (zp)w
		16'bxx00_xx00_1001_1011,	// ST[A..Q] aw
		16'bxx00_xx00_1001_01xx,	// STY zpx, ST[A..Q] zpx, STX zpy, STX zpw
		16'bxx00_xx00_100x_11xx,	// ST[A..Q] ax, STX ay, STX aw, STX a, STY a, ST[A..Q] a, STW a		
		16'bxx00_xx00_1001_1011:	// ST[A..Q] aw
				store <= 1;

		default:	store <= 0;

	endcase

always @(posedge clk )
     if( state == DECODE && RDY )
     	casex( IR[15:0] )  			
		16'bxxxx_0000_0xxx_x110,	// ASL, ROL, LSR, ROR (abs, absx, zpg, zpgx)
		16'b0000_0000_11xx_x110:	// DEC zp, zpx, a, ax, INC zp, zpx, a, ax
				write_back <= 1;

		default:	write_back <= 0;
	endcase


always @(posedge clk )
     if( state == DECODE && RDY )
     	casex( IR[15:0] )  			
		16'b00xx_00xx_1010_0xxx,	// LD[A..Q] zpx, zp, LDX #, zp, LDY #, zp
		16'b00xx_00xx_1010_1001,	// LD[A..Q] #
		16'b00xx_00xx_1010_11xx,	// LDY a, LD[A..Q] a, LDX a, LDW a
		16'b00xx_00xx_1011_xxx1,	// LD[A..Q] (zp)y, zpx, ay, aw, ax, LDX zpw, aw
		16'b0000_0000_1011_01x0,	// LDY zpx, LDX zpy
		16'b0000_0000_1011_11x0,	// LDY ax, LDX ay
		16'b00xx_00xx_1011_0010,	// LD[A..Q] zpw
		16'b0000_0000_1100_0010:	// LDW #
				load_only <= 1;
		default:	load_only <= 0;
	endcase

always @(posedge clk )
     if( state == DECODE && RDY )
     	casex( IR[15:0] )  			
		16'b0000_0000_111x_x110,	// INC zp, zpx, a, ax
		16'b0000_0000_11x0_1000, 	// INX, INY
		16'b0000_0000_1101_1000,	// INW
		16'bxxxx_xxxx_0001_1010:	// INC[A..Q]
				inc <= 1;

		default:	inc <= 0;
	endcase

always @(posedge clk )
     if( (state == DECODE || state == BRK0) && RDY )
     	casex( IR[15:0] ) 	   	
		16'bxxxx_xxxx_011x_xx01,	// ADC[A..Q]i, (zpx), (zp)y, zp, zpx, ay, ax, a op[A..Q]
		16'bxxxx_xxxx_0111_0010,	// ADC[A..Q](zp)w op[A..Q]
		16'bxxxx_xxxx_0111_1011:	// ADC[A..Q] aw op[A..Q]
					adc_sbc <= 1;

		default:	adc_sbc <= 0;
	endcase

always @(posedge clk )
     if( state == DECODE && RDY )
     	casex( IR[15:0] )  			
		16'bxxxx_0000_0xxx_x110,	// ASL, ROL, LSR, ROR a, ax, zp, zpx
		16'bxxxx_xxxx_0xx0_1010:	// ASL[A..D]op[A..D], ROL[A..D]op[A..D], LSR[A..D]op[A..D], ROR[A..D]op[A..D] acc
				shift <= 1;

		default:	shift <= 0;
	endcase

always @(posedge clk )
     if( state == DECODE && RDY )
     	casex( IR[15:0] )  			
		16'b0000_0000_11x0_0x00,	// CPX, CPY (imm/zp)
		16'b0000_0000_11x0_1100,	// CPX, CPY (abs)
		16'b0000_0000_1110_0010,	// CPW #
		16'b0000_0000_1100_x111,	// CPW zp,a
		16'bxx00_xx00_110x_xx01,	// CMP[A..Q] i, (zpx), (zp)y, zp, zpx, ay, ax, a
		16'bxx00_xx00_1101_0010,	// CMP[A..Q] (zp)w
		16'bxx00_xx00_1101_1011:	// CMP[A..Q] aw	
				compare <= 1;

		default:	compare <= 0;
	endcase

always @(posedge clk )
     if( state == DECODE && RDY )
     	casex( IR[15:0] )  			
		16'bxxxx_0000_01xx_x110,	// ROR, LSR a, ax, zp, zpx
		16'bxxxx_xxxx_01x0_1010:	// LSR[A..D]op[A..D], ROR[A..D]op[A..D] acc
				shift_right <= 1;

		default:	shift_right <= 0; 
	endcase

always @(posedge clk )
     if( state == DECODE && RDY )
     	casex( IR[15:0] )  			
		16'bxxxx_xxxx_0x10_1010,	// ROL[A..D]op[A..D], ROR[A..D]op[A..D] acc
		16'bxxxx_0000_0x1x_x110:	// ROR, ROL a, ax, zp, zpx
				rotate <= 1;

		default:	rotate <= 0; 
	endcase

always @(posedge clk )
     if( state == DECODE && RDY )
     	casex( IR[15:0] ) 			
		16'bxxxx_0000_00xx_x110,	// ROL, ASL a, ax, zp, zpx
		16'bxxxx_xxxx_00x0_1010:	// ASL[A..D]op[A..D], ROL[A..D]op[A..D] acc
				op <= OP_ROL;

		16'bxxxx_xxxx_0010_x100:   // BIT[A..Q] zp, a
				op <= OP_AND;

		16'bxxxx_0000_01xx_x110,	// ROR, LSR a, ax, zp, zpx
		16'bxxxx_xxxx_01x0_1010:	// LSR[A..D]op[A..D], ROR[A..D]op[A..D] acc
				op <= OP_A;

		16'b0000_0000_1111_1000,	// DEW
		16'b0000_0000_1000_1000,	// DEY
		16'b0000_0000_1100_1010, 	// DEX
		16'bxxxx_xxxx_0011_1010,	// DEC[A..Q]
		16'b0000_0000_110x_x110,	// DEC zp, zpx, a, ax
		16'bxxxx_xxxx_11xx_xx01,	// CMP[A..Q]i, (zpx), (zp)y, zp, zpx, ay, a, ax, SBC[A..Q]i, (zpx), (zp)y, zp, zpx, ay, a, ax op[A..Q]
		16'bxxxx_xxxx_11x1_0010,	// CMP[A..Q](zp)w, SBC[A..Q](zp)w op[A..Q]
		16'bxxxx_xxxx_11x1_1011,	// CMP[A..Q]aw, SBC[A..Q]aw op[A..Q]
		16'b0000_0000_11x0_0x00,	// CPX, CPY (imm, zpg)
		16'b0000_0000_11x0_1100,	// CPX, CPY abs
		16'b0000_0000_1110_0010,	// CPW i
		16'b0000_0000_1100_x111:	// CPW zp,a
				op <= OP_SUB;

		16'bxxxx_xxxx_010x_xx01,	// EOR[A..Q]op[A..Q]
		16'bxxxx_xxxx_0101_0010,	// EOR[A..Q](zp)w op[A..Q]
		16'bxxxx_xxxx_00xx_xx01,	// ORA[A..Q]i, (zpx), (zp)y, zp, zpx, ay, ax,a op[A..Q], AND[A..Q]i, (zpx), (zp)y, zp, zpx, ay, ax,a op[A..Q]
		16'bxxxx_xxxx_00x1_0010:	// ORA[A..Q](zp)w op[A..Q], AND[A..Q](zp)w op[A..Q]
		op <= { 2'b11, IR[6:5] };

		default: 	op <= OP_ADD; 
	endcase

always @(posedge clk )
     if( state == DECODE && RDY )
     	casex( IR[15:0] ) 			
		16'bxxxx_xxxx_0010_x100:   // BIT[A..Q]op[A..Q] zp, a
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