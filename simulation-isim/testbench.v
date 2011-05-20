//**************************************************************************
//    testbench.v - top level module testbench for the GOP-based 65Org16 CPU
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
`timescale 1ns / 1ns

module testbench ();

   // this is a testbench sitting above the GOP design
   // so it only needs to act as the clock and the host
   // and perhaps the buttons and LEDs

   reg  res_r, phi0_r;
   wire res_w = res_r;
   wire phi0_w = phi0_r;
   wire [7:0] userled;

   gop16 dut (
	.res(res_w),
	.phi0(phi0_w),
	.SDA(SDA),
	.SCL(SCL),
	.userled(userled)
     );

   initial
   begin
      res_r = 1'b0;
      phi0_r = 1'b0;
      @ ( negedge phi0_w );
      @ ( negedge phi0_w )
        res_r <= 1'b1;
      #100000 $display("Simulation time out");
      $finish;
   end // initial begin

   always
     begin
        #252 phi0_r <= 1'b1;
        #252 phi0_r <= 1'b0;
     end

endmodule
