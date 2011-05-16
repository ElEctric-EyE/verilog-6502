	;; for minimal proof-of-life with uart+led with 65Org16 in GOP24
	;;
	;;	PATH=$PATH:/opt/cc65-v2.12.0/bin
	;;	make -f ../../boot816/Makefile -B tinytestrom.bin BASE=0xFFEE
	;;	ca65 -l tinytestrom.as -D BASE=0xFFEE -D SRECORD_D=0
	;;	cl65 tinytestrom.o --target none --start-addr 0xFFF0 -o tinytestrom.bin
        ;;	xxd -c 1 tinytestrom.bin
	;;
	;; python3 ../../cpu65Org16/tools/asm65Org16.py tinytestrom.as

;; place the bootstrap so the reset vector lands at FFFFFFFC
bootstrap=0xFFFFFFEE

UartS1=0xFFFEFFF8
UartR1=0xFFFEFFF9
UserLeds=0xFFFD0000

bootstrap:
	LDX #0xFFFF
	TXS  ;; initialise stack pointer
	CLC

loop:
	LDA UartR1
	EOR #0xF
	STA UserLeds
	BCC loop

; this is arranged to be placed in the reset vector, by careful initial .Org
        DATA # LOW(bootstrap)  ;reset vector
	DATA # HIGH(bootstrap)
