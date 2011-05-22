	;; for minimal proof-of-life with uart+led with 65Org16 in GOP24
	;;
	;;	PATH=$PATH:/opt/cc65-v2.12.0/bin
	;;	make -f ../../boot816/Makefile -B tinytestrom.bin BASE=0xFFEE
	;;	ca65 -l tinytestrom.as -D BASE=0xFFEE -D SRECORD_D=0
	;;	cl65 tinytestrom.o --target none --start-addr 0xFFF0 -o tinytestrom.bin
        ;;	xxd -c 1 tinytestrom.bin
	;;
	;; python3 ../tools/asm65Org16.py tinytestrom.as

;; place the bootstrap so the reset vector lands at FFFFFFFC
bootstrap=0xFFFFFFBA

UartS1=0xFFFEFFF8
UartR1=0xFFFEFFF9
UserLeds=0xFFFD0000

bootstrap:
	LDX #0xFFFF
	TXS  ;; initialise stack pointer
	CLC

testram:
	LDA #0xA5C3
	STA 0x0111
	TXA
	STA 0x0222
	LDA 0x0111
	CMP #0xA5C3
	BNE fail
	LDA 0x0222
	CMP #0xFFFF
	BEQ uartinit

fail:
	LDA #0x007E
	STA UserLeds
	BNE fail

uartinit:
	LDA #3
	STA UartS1

uartloop:
;	LDY #1
;	STY UserLeds
	LDA UartS1
        LSR
        BCS dealWithIncoming
;	LDY #0xF0
;	STY UserLeds
	LSR         ; any room for transmission?
	BCC uartloop
okToSend:
;	LDY #3
;	STY UserLeds
	INX         ; outgoing data is a simple counter
                    ; outgoing data is rate-limited at the receiver
                    ; so we just send as fast as we can
	TXA
	STA UartR1
	JMP uartloop

dealWithIncoming:
;	LDY #6
;	STY UserLeds
	LDA UartR1  ; incoming data is shown on LEDs
	STA UserLeds
	
	INX         ; also increment the outgoing counter
                    ; to demonstrate we're not duplicating incoming bytes
	JMP uartloop

resetvector:
; this is arranged to be placed in the reset vector, by careful initial .Org
        DATA # LOW(bootstrap)  ;reset vector
	DATA # HIGH(bootstrap)
