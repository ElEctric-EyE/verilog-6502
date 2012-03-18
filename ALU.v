/*
 * parameterisable ALU for 6502 and 65Org16
 *
 * verilog-6502 project: verilog model of 6502 and 65Org16 CPU core
 *
 * (C) 2011 Arlet Ottens, <arlet@c-scape.nl>
 * (C) 2011 Ed Spittles, <ed.spittles@gmail.com>
 * (C) 2011 Sam Gaskill, <sammy.gasket@gmail.com>   Added BigEd's barrel shifter logic on port EI
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public
 *  License version 2.1 as published by the Free Software Foundation.
 *
 * AI and BI are 8 bit inputs. Result in OUT.
 * CI is Carry In.
 * CO is Carry Out.
 *
 * op[3:0] is defined as follows:
 *
 * 0011   AI + BI
 * 0111   AI - BI
 * 1011   AI + AI
 * 1100   AI | BI
 * 1101   AI & BI
 * 1110   AI ^ BI
 * 1111   AI
 */

module ALU( clk, op, right, rotate, AI, BI, CI, EI, CO, OUT, V, Z, N, RDY );

	parameter dw = 16; // data width (8 for 6502, 16 for 65Org16)

	input clk;
	input right;
	input rotate;
	input [3:0] op;		// operation
	input [dw-1:0] AI;
	input [dw-1:0] BI;
	input [3:0] EI;		// variable shift in
	input CI;
	output [dw-1:0] OUT;
	output CO;
	output V;
	output Z;
	output N;
	input RDY;

reg [dw-1:0] OUT;
reg CO;
wire V;
wire Z;
reg N;

reg AI7;
reg BI7;
reg [dw:0] logical;
reg [dw-1:0] temp_BI;
reg [dw:0] temp;
wire adder_CI = (right | (op[3:2] == 2'b11)) ? 0 : CI;

// calculate the logic operations. The 'case' can be done in 1 LUT per
// bit. The 'right' shift is a simple mux that can be implemented by
// F5MUX.
always @*  begin
	case( op[1:0] )
	    2'b00: logical = AI | BI;
	    2'b01: logical = AI & BI;
	    2'b10: logical = AI ^ BI;
	    2'b11: logical = AI;
	endcase

	if( right )
	    logical = { AI[0], CI, AI[dw-1:1] };
end

// perform a long-distance shift
wire [dw:0]tempshifted = right ? ({CI, AI, CI, AI} << (~EI)) >> (dw-1) :
                                 ({CI, AI, CI, AI} << EI) >> (dw+1);
											
// need to mask off incoming bits in the case of a shift rather than a rotate
wire [dw-1:0]highmask = ~((1 << EI)-1);
wire [dw-1:0]lowmask = (2 << (~EI))-1;

// rotate is easy, and left is just a masking.  Sign extension is a bit more work.
wire [dw:0]tempmasked = rotate ? tempshifted
                               : right ? (tempshifted & lowmask) | ({dw{AI[dw-1]}} & ~lowmask)
				       : tempshifted & highmask;

// bypass the 6502-style ALU if we're doing OP_ROL or OP_A
wire shiftrotate = op[3] == 1'b1 & op[1:0] == 2'b11;

// Add logic result to BI input. This only makes sense when logic = AI.
// This stage can be done in 1 LUT per bit, using carry chain logic.
always @* begin
	case( op[3:2] )
	    2'b00: temp_BI = BI;	// A+B
	    2'b01: temp_BI = ~BI;	// A-B
	    2'b10: temp_BI = logical;	// A+A
	    2'b11: temp_BI = 0;		// A+0
	endcase	
end

// perform the addition as 2 separate nibble, so we get
// access to the half carry flag
always @(logical or temp_BI or adder_CI)
	temp = logical + temp_BI + adder_CI;

//end

// calculate the flags 
always @(posedge clk)
    if( RDY ) begin
	OUT <= shiftrotate ? tempmasked[dw-1:0] : temp[dw-1:0];
	CO  <= (shiftrotate ? tempshifted[dw] : temp[dw]);
	N   <= temp[dw-1];
    end

assign V = AI7 ^ BI7 ^ CO ^ N;
assign Z = ~|OUT;

endmodule
