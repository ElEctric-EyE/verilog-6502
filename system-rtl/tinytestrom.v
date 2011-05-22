//
// tinybootrom :  for minimal proof-of-life
//    for source, see tinybootrom.as

// using global clock and output enable uses no extra resources
// over a combinatorial ROM
//
module tinybootrom(address,dataout);
   input[7:0]   address;
   output[15:0]   dataout;

   // following the idiom in the xilinx guide
   reg  [15:0]  dataout_d;
   
   assign dataout  = dataout_d ;

   always @ (*)
     begin
       case ( address )
         8'hba: dataout_d = 16'h00a2;
         8'hbb: dataout_d = 16'hffff;
         8'hbc: dataout_d = 16'h009a;
         8'hbd: dataout_d = 16'h0018;
         8'hbe: dataout_d = 16'h00a9;
         8'hbf: dataout_d = 16'ha5c3;
         8'hc0: dataout_d = 16'h008d;
         8'hc1: dataout_d = 16'h0111;
         8'hc2: dataout_d = 16'h0000;
         8'hc3: dataout_d = 16'h008a;
         8'hc4: dataout_d = 16'h008d;
         8'hc5: dataout_d = 16'h0222;
         8'hc6: dataout_d = 16'h0000;
         8'hc7: dataout_d = 16'h00ad;
         8'hc8: dataout_d = 16'h0111;
         8'hc9: dataout_d = 16'h0000;
         8'hca: dataout_d = 16'h00c9;
         8'hcb: dataout_d = 16'ha5c3;
         8'hcc: dataout_d = 16'h00d0;
         8'hcd: dataout_d = 16'h0007;
         8'hce: dataout_d = 16'h00ad;
         8'hcf: dataout_d = 16'h0222;
         8'hd0: dataout_d = 16'h0000;
         8'hd1: dataout_d = 16'h00c9;
         8'hd2: dataout_d = 16'hffff;
         8'hd3: dataout_d = 16'h00f0;
         8'hd4: dataout_d = 16'h0007;
         8'hd5: dataout_d = 16'h00a9;
         8'hd6: dataout_d = 16'h007e;
         8'hd7: dataout_d = 16'h008d;
         8'hd8: dataout_d = 16'h0000;
         8'hd9: dataout_d = 16'hfffd;
         8'hda: dataout_d = 16'h00d0;
         8'hdb: dataout_d = 16'hfff9;
         8'hdc: dataout_d = 16'h00a9;
         8'hdd: dataout_d = 16'h0003;
         8'hde: dataout_d = 16'h008d;
         8'hdf: dataout_d = 16'hfff8;
         8'he0: dataout_d = 16'hfffe;
         8'he1: dataout_d = 16'h00ad;
         8'he2: dataout_d = 16'hfff8;
         8'he3: dataout_d = 16'hfffe;
         8'he4: dataout_d = 16'h004a;
         8'he5: dataout_d = 16'h00b0;
         8'he6: dataout_d = 16'h000b;
         8'he7: dataout_d = 16'h004a;
         8'he8: dataout_d = 16'h0090;
         8'he9: dataout_d = 16'hfff7;
         8'hea: dataout_d = 16'h00e8;
         8'heb: dataout_d = 16'h008a;
         8'hec: dataout_d = 16'h008d;
         8'hed: dataout_d = 16'hfff9;
         8'hee: dataout_d = 16'hfffe;
         8'hef: dataout_d = 16'h004c;
         8'hf0: dataout_d = 16'hffe1;
         8'hf1: dataout_d = 16'hffff;
         8'hf2: dataout_d = 16'h00ad;
         8'hf3: dataout_d = 16'hfff9;
         8'hf4: dataout_d = 16'hfffe;
         8'hf5: dataout_d = 16'h008d;
         8'hf6: dataout_d = 16'h0000;
         8'hf7: dataout_d = 16'hfffd;
         8'hf8: dataout_d = 16'h00e8;
         8'hf9: dataout_d = 16'h004c;
         8'hfa: dataout_d = 16'hffe1;
         8'hfb: dataout_d = 16'hffff;
         8'hfc: dataout_d = 16'hffba;
         8'hfd: dataout_d = 16'hffff;

	 default:
	   begin
	     dataout_d = 16'hxxxx ; // should be don't care really
	   end
       endcase
     end
        
endmodule // tinybootrom
