//
// tinybootrom :  for minimal proof-of-life
//    for source, see tinybootrom.as

// using global clock and output enable uses no extra resources
// over a combinatorial ROM
//
module tinybootrom(address,dataout);
   input[4:0]   address;
   output[15:0]   dataout;

   // following the idiom in the xilinx guide
   reg  [15:0]  dataout_d;
   
   assign dataout  = dataout_d ;

   always @ (*)
     begin
       case ( address )
         5'b01110:  dataout_d = 16'h00a2; // LDX
         5'b01111:  dataout_d = 16'hffff;
         5'b10000:  dataout_d = 16'h009a; // TXS
         5'b10001:  dataout_d = 16'h0018; // CLC
         5'b10010:  dataout_d = 16'h00ad; // LDA
         5'b10011:  dataout_d = 16'hfff9;
         5'b10100:  dataout_d = 16'hfffe;
         5'b10101:  dataout_d = 16'h0049; // EOR
         5'b10110:  dataout_d = 16'h000F;
         5'b10111:  dataout_d = 16'h008d; // STA
         5'b11000:  dataout_d = 16'h0000;
         5'b11001:  dataout_d = 16'hfffd;
         5'b11010:  dataout_d = 16'h0090; // BCC
         5'b11011:  dataout_d = 16'hfff6;
         5'b11100:  dataout_d = 16'hfff0;
         5'b11101:  dataout_d = 16'hffff;

	 default:
	   begin
	     dataout_d = 16'hxxxx ; // should be don't care really
	   end
       endcase
     end
        
endmodule // tinybootrom
