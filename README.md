A Verilog HDL project for CPU cores related to the old MOS 6502 CPU.

This fork adds various features, see [this thread on the 6502.org forum](http://forum.6502.org/viewtopic.php?f=10&t=1842)

The 65Org16-master branch is for a CPU core with:
  - 32-bit address space
    - by using 16-bit bytes
  - with no specific support for 8-bit bytes
  - with BCD mode as unspecified behaviour
  - and otherwise all opcodes and addressing modes like NMOS 6502

Please use other branches and add a suffix to your core name for
CPU cores with other goals.

Please note:

- The core has had extensive testing on a video project by ElEctric_EyE on multiple threads in the Programmable Logic Section of http://forum.6502.org

- Some tools exist: see [this forum thread](http://forum.6502.org/viewtopic.php?f=1&t=1982)

- The upstream fork by BigEd also contains support files for a small system on
  FPGA, intended for xilinx spartan 3 as found on OHO GOP 24-pin module.
  The system has a uart module for communication to a host computer,
  which is implemented over i2c. The i2c module is not included for
  copyright reasons.  The system is absolutely minimal but is a work
  in progress,

- LGPL license v2.1 is used for compatibility with opencores.org and to
  encourage redistribution of any source code improvements.
  (The license can be changed by agreement of all the copyright holders)

Notes on the cpu core:

- clk is active on the positive edge (is a phi1 clock)
- reset, IRQ and NMI are active high
- WE replaces, and is inverse sense of, read not write.
- databus has separate DI and DO
- RDY is implemented
- external memory is assumed synchronous, so external pipelining is needed
- `define SIM for extra simulation instrumentation
- memory accesses may diverge from the original

Website for the original: http://ladybug.xs4all.nl/arlet/fpga/6502/

Note on licensing:

Relicensed to LGPL by kind permission of Arlet Ottens
"If you want to distribute it under the LGPL license that's fine with me"
16 May 2011 12:08
