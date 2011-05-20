
// usually we want this RAM module to be synthesised to a xilinx block ram
// so take care to match the block ram capabilities

module ram4k (
    input           Clk,
    input           We,
    input  [11:0]   Waddr,
    input  [11:0]   Raddr,
    input  [15:0]   Din,
    output [15:0]   Dout
);

    reg    [15:0]  mem[0:4095];
    reg    [11:0]  raddr_reg;

    // Data, and the read address, are captured on the rising edge of the clock
    always @ (posedge Clk)
      begin
         raddr_reg  <= Raddr;
         if (We) begin
           mem[Waddr]  <= Din;
         end
      end

    assign Dout = mem[raddr_reg];  // read (from registered address)

endmodule
