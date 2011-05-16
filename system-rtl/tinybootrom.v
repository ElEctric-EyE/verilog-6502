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
         5'b00000:  dataout_d = 16'h00xx ;
         5'b00001:  dataout_d = 16'h00xx ;
         5'b00010:  dataout_d = 16'h00xx ;
         5'b00011:  dataout_d = 16'h00xx ;
         5'b00100:  dataout_d = 16'h00a2 ; // LDX #offset
         5'b00101:  dataout_d = 16'hfffc ;
         5'b00110:  dataout_d = 16'h009a ; // TXS
         5'b00111:  dataout_d = 16'h00bd ; // LDA message-offset,X
         5'b01000:  dataout_d = 16'hfffc ;  
         5'b01001:  dataout_d = 16'hfffe ;
         5'b01010:  dataout_d = 16'h008d ; // STA TubeR1
         5'b01011:  dataout_d = 16'hfff9 ; 
         5'b01100:  dataout_d = 16'hfffe ;
         5'b01101:  dataout_d = 16'h002c ; // BIT TubeS1
         5'b01110:  dataout_d = 16'hfff8 ;
         5'b01111:  dataout_d = 16'hfffe ;
         5'b10000:  dataout_d = 16'h00ea ; // NOP
         5'b10001:  dataout_d = 16'h0050 ; // BVC writebyte
         5'b10010:  dataout_d = 16'hfff7 ;
         5'b10011:  dataout_d = 16'h00e8 ; // INX
         5'b10100:  dataout_d = 16'h00d0 ; // BNE nextchar
         5'b10101:  dataout_d = 16'hfff1 ;
         5'b10110:  dataout_d = 16'h00f0 ; // BEQ done
         5'b10111:  dataout_d = 16'hfffe ;
         5'b11000:  dataout_d = 16'h0054 ; // 'T'  address fffffff8
         5'b11001:  dataout_d = 16'h0036 ; // '6'
         5'b11010:  dataout_d = 16'h0035 ; // '5'
         5'b11011:  dataout_d = 16'h0000 ;
         5'b11100:  dataout_d = 16'hffe4 ;
         5'b11101:  dataout_d = 16'hffff ;

	 default:
	   begin
	     dataout_d = 16'h0000 ; // should be don't care really
	   end
       endcase
     end
        
endmodule // tinybootrom
