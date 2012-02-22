/*
 * parameterisable ALU for 6502 and 65Org16
 *
 * verilog-6502 project: verilog model of 6502 and 65Org16 CPU core
 *
 * (C) 2011 Arlet Ottens, <arlet@c-scape.nl>
 * (C) 2011 Ed Spittles, <ed.spittles@gmail.com>
 * (C) 2012 Sam Gaskill, <sammy.gasket@gmail.com>
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

module ALU( clk, op, right, AI, BI, CI, CO, OUT, V, N, RDY );

	parameter dw = 16; // data width (8 for 6502, 16 for 65Org16)

	input clk;
	input right;
	input [3:0] op;		// operation
	input [dw-1:0] AI;
	input [dw-1:0] BI;
	input CI;
	output [dw-1:0] OUT;
	output CO;
	output V;
	output N;
	input RDY;

reg [dw-1:0] OUT;
reg CO;
reg V;
reg N;

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
	OUT <= temp[dw-1:0];
	CO  <= temp[dw];
	N   <= temp[dw-1];
	V   <= AI[dw-1] ^ BI[dw-1] ^ temp[dw-1] ^ temp[dw]; 
    end

endmodule
