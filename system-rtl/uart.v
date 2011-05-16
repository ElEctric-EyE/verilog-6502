// uart function: bidirectional, bytewide, asynchronous
// perhaps with some notion of flow control
//
// this implementation will transport over i2c but should
// be swappable with something else

module uart(
	inout SDA,
	input SCL,
	input address,
	input  [`datawidth] datain,
	output [`datawidth] dataout
  );

// because i2c is host-mastered, the host will need to poll for bytes from us
// we'll clearly need a status register - at least one bit

// the i2cslave from fpga4fun has some shortcomings
//   - is not redistributable - so we distribute a patch
//      - original at http://www.fpga4fun.com/I2C.html
//      - specifically http://www.fpga4fun.com/files/I2Cslave1.zip
//      - see also freeware version http://www.fpga4fun.com/ExternalContributions/VHDL_i2cs_rx_CPLD.zip
//   - is an output port only (fixed!)
//   - is exactly one byte - so we use a pair
//   - can't signal that an outgoing byte has left the building
//   - can't signal that an inbound byte is ready for reception
//   - can't signal (upstream) that there's no room for an inbound byte

// while a 16-bit or 2-byte port might be neat, the least-effort solution
// is a pair of instances, or 3, or maybe even four.
// upstream towards the host:
//   gop2host_data
//   gop2host_status - for the host to determine if there's a byte to be fetched from gop
// downstream from the host:
//   host2gop_data
//   host2gop_status - not an i2c register, but gop needs to know if there's room to write a byte

i2cslave #(.I2C_ADR(7'h27)) _i2cslave(
	.SDA(SDA),
	.SCL(SCL),
	.IOout(dataout[7:0]),
	.IOin(datain[7:0])
	);

assign dataout[15:8] = 8'b0;

endmodule
