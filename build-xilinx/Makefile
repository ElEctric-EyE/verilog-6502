# derived from code in Peter Monta's FPGA-netlist-tools project

DEVICE=XC3S200-4VQ100

TOP=gop16

DESIGN=chip

all:
	echo "run -ifn ${DESIGN}.v -ifmt Verilog -top ${TOP} -ofn ${DESIGN} -p ${DEVICE}" | xst
	ngdbuild -p ${DEVICE} -uc ${DESIGN}.ucf ${DESIGN}
	map -w -timing -detail -ol high -p ${DEVICE} ${DESIGN}.ngd ${DESIGN}.pcf
	par -w -ol high ${DESIGN}.ncd ${DESIGN}.ncd ${DESIGN}.pcf
	trce -v 20 -u 20 ${DESIGN}.ncd ${DESIGN}.pcf
	bitgen -m -g StartupClk:CClk -g GTS_cycle:3 -g LCK_cycle:4 -g GWE_cycle:5 -g DONE_cycle:6 -w ${DESIGN}.ncd ${DESIGN}.bit ${DESIGN}.pcf
	promgen -w -spi -p mcs -s 4096 -u 0 ${DESIGN}.bit
	netgen -sim -w -ofmt verilog -sdf_anno true -ism -aka ${DESIGN}.ncd ${DESIGN}_annot.v

clean:
	rm -rf xst _xmsgs xlnx_auto_0_xdb
	rm -f *~
	rm -f *.bgn *.bld *.drc *.map *.mrp *.ncd *.ngc *.ngd *.ngm *.pad *.par *.pcf *.ptwx *.unroutes *.xpi
	rm -f *.cfi *.prm
	rm -f _impact.cmd _impact.log
	rm -f *_bitgen.xwbt *_ngdbuild.xrpt *_pad.csv *_pad.txt *_summary.xml *_usage.xml
	rm -f *_xst.xrpt *_map.xrpt *_par.xrpt
	rm -f _impactbatch.log netlist.lst usage_statistics_webtalk.html webtalk.log
	rm -f *.psr *.twr *.twx
	rm -f output.txt
