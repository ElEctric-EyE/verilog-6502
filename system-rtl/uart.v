// uart function: bidirectional, bytewide, asynchronous
// perhaps with some notion of flow control
//
// this implementation will transport over i2c but should
// be swappable with something else

module uart(
	inout SDA,
	input SCL,
	input clk,
	input read,
	input write,
	input address,
	input  [`datawidth] datain,
	output [`datawidth] dataout
  );

// the local view is like a 6850: two addresses offering 4 registers
//   control (write)
//     write 0x03 to reset
//   status (read)
//     bit 0: serial inbound: 1 means data is available from host
//     bit 1: serial outbound: 1 means empty, data may be written for transmission to host
//   data (read/write)
//     Tx and Rx data
//
// the host-facing view is 2 i2c addresses
//               4D (read) status: non-zero means data is available
//   4E (write)  4F (read) data: to and from the SoC
//   
// as an enhancement we could allow a local FIFO and allow multi-byte i2c transfers,
//   at which point the status to the host would inform it of FIFO space in both directions.
//

// the i2cslave from fpga4fun has some shortcomings
//   - is not redistributable - so we distribute a patch
//      - original at http://www.fpga4fun.com/I2C.html
//      - specifically http://www.fpga4fun.com/files/I2Cslave1.zip
//      - see also freeware version http://www.fpga4fun.com/ExternalContributions/VHDL_i2cs_rx_CPLD.zip
//   - is an output port only (fixed!)
//   - can't signal that an outgoing byte has left the building
//   - can't signal that an inbound byte is ready for reception
//   - can't signal (upstream) that there's no room for an inbound byte

// while a 16-bit or 2-byte port might be neat, the least-effort solution
// is a pair of instances
// upstream towards the host:
//   gop2host_data
//   gop2host_status - for the host to determine if there's a byte to be fetched from gop
// downstream from the host:
//   host2gop_data
//   host2gop_status - not an i2c register, but gop needs to know if there's room to write a byte

reg [7:0] host_facing_status;

// resample the ack signals into chip-side clock domain
wire dataSent_w, dataReceived_w;
reg [3:0] dataSent, dataReceived;
always @(posedge clk)
  begin
    if(write & !address) // command register
      if (datain[1:0] == 2'b11) // reset command
        begin
          dataSent[3:0] <= 4'b0;
          dataReceived[3:0] <= 4'b0; 
        end
    dataSent[3] <= dataSent_w;
    dataSent[2:0] <= dataSent[3:1];
    dataReceived[3] <= dataReceived_w;
    dataReceived[2:0] <= dataReceived[3:1];
  end

// for illustration only we pick off the leading or trailing edge
wire dataSentOK = dataSent[1] & !dataSent[0]; // leading edge
wire dataReceivedOK = !dataReceived[1] & dataReceived[0];  // trailing edge

reg [7:0] status, txdata;
wire [7:0] rxdata;

always @(posedge clk)
  begin
    if(write & address)  // Tx data register
      txdata <= datain[7:0];

    if(write & !address) // command register
      if (datain[1:0] == 2'b11) // reset command
        begin
          status[7:0] <= 8'b00000010; // initially "Ready/Empty"
          host_facing_status <= 8'h00;
        end

    // maintain the status bit 0: "Data can be read"
    if (dataReceivedOK)
        status[0] <= 1'b1; // an ACK came in: we have an Rx'd byte
    if (read & address)
        status[0] <= 1'b0; // we read the Rx byte - don't read the same one twice

    // maintain the status bit 1: "Ready/Empty" and the similar host-facing bit
    if (dataSentOK)
      begin
        status[1] <= 1'b1; // an ACK is going out: we're clear to Tx another byte
        host_facing_status <= 8'h00;
      end
    if (write & address)
      begin
        status[1] <= 1'b0; // we write a Tx byte: no more until it is transmitted
        host_facing_status <= 8'h01;
      end
  end

assign dataout[15:8] = 8'b0;
assign dataout[7:0] = address ? rxdata : status;

i2cslave #(.I2C_ADR(7'h26)) _i2cstatus(
	.SDA(SDA),
	.SCL(SCL),
	.IOout(),
	.IOin(host_facing_status),
	.serialTxDataAck(),
	.serialRxDataAck()
	);

i2cslave #(.I2C_ADR(7'h27)) _i2cdata(
	.SDA(SDA),
	.SCL(SCL),
	.IOout(rxdata),
	.IOin(txdata),
	.serialTxDataAck(dataSent_w),
	.serialRxDataAck(dataReceived_w)
	);

endmodule
