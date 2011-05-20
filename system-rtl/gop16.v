//**************************************************************************
//    gop16.v - system-on-chip 65Org16 CPU experiment
//   
//    COPYRIGHT 2011 Richard Evans
//    COPYRIGHT 2011 Ed Spittles
// 
//    This file is part of verilog-6502 project
//   
//  This library is free software; you can redistribute it and/or
//  modify it under the terms of the GNU Lesser General Public
//  License version 2.1 as published by the Free Software Foundation.
//
//  This library is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
//  Lesser General Public License for more details.
//
//  You should have received a copy of the GNU Lesser General Public
//  License along with this library; if not, write to the Free Software
//  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
//
// ============================================================================
//
// 16-bit CPU on an OHO FPGA module
//    24-pin DIL module
//    6502-derived CPU
//
// I/O is limited to an i2c connection
// and some diagnostic LEDs
// also two push buttons are available
//
// presently in very early stages
// (no RAM)

module gop16 (
	input res,   // active low
	input phi0,
	inout SDA,
	input SCL,
	output [7:0] userled
   );

`define bytesize 16
//`define bytesize 8
`define datasize `bytesize
`define addresssize (2*`bytesize)
`define addresswidth `addresssize-1:0
`define datawidth `datasize-1:0

	wire [`addresswidth] addrbus_w;
	reg  [`datawidth]    databus_r;
	wire [`datawidth]    databus_cpu_w;
	wire [`datawidth]    databus_rom_w;
	wire [`datawidth]    databus_uart_w;

	wire reset = ! res;
	wire clk;
	wire write;
	wire rnw = ! write;

`ifdef SIMULATION
// 50MHz clock in from crystal is too fast for this core
DCM #(
   .CLKFX_MULTIPLY(3),    // Can be any integer from 2 to 32
   .CLKFX_DIVIDE(5),      // Can be any integer from 1 to 32
   .STARTUP_WAIT("TRUE"), // Delay configuration DONE until DCM LOCK, TRUE/FALSE
   .CLK_FEEDBACK("NONE")  // External closed loop?
) _divider (
   .CLKFX(clk),     // DCM CLK synthesis out (Mult/Div)
   .CLKIN(phi0)     // Clock input (from IBUFG, BUFG or DCM)
);
`else
assign clk=phi0;
`endif

// This core demands an external pipeline
reg  [`datawidth]    databus_rr;
always @(posedge clk)
  databus_rr <= databus_r;

cpu _cpu (
	.clk(clk),
	.reset(reset),
	.AB(addrbus_w),
	.DI(databus_rr),
	.DO(databus_cpu_w),
	.WE(write),
	.IRQ(1'b0),
	.NMI(1'b0),
	.RDY(1'b1)
  );

// uart function: bidirectional, bytewide, asynchronous, in this case over i2c
uart _uart(
	.SDA(SDA),
	.SCL(SCL),
	.address(addrbus_w[0]),
	.datain(databus_rr),
	.dataout(databus_uart_w)
	);

tinybootrom _rom1 (
	.address(addrbus_w[4:0]),
	.dataout(databus_rom_w)
  );

// diagnostic port - user LEDS
reg [7:0] userled_r;
always @(posedge clk)
  if (!rnw & led_select_w)
    userled_r <= databus_r;
assign userled = userled_r;

// user LEDs address decode (placed at 0xfd00 or 0xfffd0000)
wire led_select_w = (addrbus_w[`bytesize+7:`bytesize] == 8'hfd);

// ROM address decode
wire rom_select_w = (addrbus_w[`bytesize+7:`bytesize] == 8'hff);

// UART address decode
wire uart_select_w = (addrbus_w[`bytesize+7:`bytesize] == 8'hfe);

// fpga normal practice: an onchip bus is the output of a wide mux
//    although wired-OR might be more efficient
always @(*)
	begin
	  casex ( {write, uart_select_w} )
            2'b1x:    databus_r = databus_cpu_w;
            2'bx1:    databus_r = databus_uart_w;
            default:  databus_r = databus_rom_w;
          endcase
        end

endmodule
