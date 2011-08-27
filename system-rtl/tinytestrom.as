
;;**************************************************************************
;;
;;    tinytestrom.as - support software for system-on-chip 65Org16 CPU experiment
;;    for use i2c uart+led with 65Org16 in GOP24
;;
;;    minimal ram test, prompt, read line of input into buffer and output back
;;
;;    COPYRIGHT 2001 Ross Archer (parts derived from http://www.6502.org/source/monitors/intelhex/intelhex.htm)
;;    COPYRIGHT 2011 Ed Spittles
;;
;;    This file is part of verilog-6502 project
;;
;;  This library is free software; you can redistribute it and/or
;;  modify it under the terms of the GNU Lesser General Public
;;  License version 2.1 as published by the Free Software Foundation.
;;
;;  This library is distributed in the hope that it will be useful,
;;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;;  Lesser General Public License for more details.
;;
;;  You should have received a copy of the GNU Lesser General Public
;;  License along with this library; if not, write to the Free Software
;;  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
;;
;; ============================================================================

        ;; assemble with patched version of David Beazley's http://www.dabeaz.com/superboard/asm6502.py
	;;
	;; python3 ../tools/asm65Org16.py tinytestrom.as |\
        ;;      sed 's/32.hffffff/         8'\''h/;s/ :/: dataout_d =/'
        ;;
        ;;      and patch into tinytestrom.v - alternatively we could initialise a block ram

;; place the origin so the reset vector lands at FFFFFFFC
origin=0xFFFFFF0A
UartS1=0xFFFEFFF8
UartR1=0xFFFEFFF9
UserLeds=0xFFFD0000

; zero page is large so we can place buffers there
InputBuffer=0x0400
InputPointer=0x0
OutputBuffer=0x0500
OutputHeadPointer=0x1
OutputTailPointer=0x2

DPL=0x3 ; temporary data pointer low
DPH=0x4

origin:

; kernel write to stdout
;    writes to a circular buffer
;    256 bytes
;    no overflow check
;    uses X
;    buffer is consumed elsewhere
kwrite:
	LDX %OutputHeadPointer
	STA %OutputBuffer,X
	STA UserLeds  ; too fast to see, but good for simulation
	INX
	TXA
	AND #0xFF
	STA %OutputHeadPointer
	RTS

;Put the string following in-line until a NULL out to the console
putstring:
	PLA			; Get the low part of "return" address (data start address)
        STA     DPL
        PLA
        STA     DPH             ; Get the high part of "return" address
                                ; (data start address)
        ; Note: actually we're pointing one short
PSINB:	LDY     #1
        LDA     [DPL],Y         ; Get the next string character
        INC     DPL             ; update the pointer
        BNE     PSICHO          ; if not, we're pointing to next character
        INC     DPH             ; account for page crossing
PSICHO:	ORA     #0              ; Set flags according to contents of Accumulator
        BEQ     PSIX1           ; don't print the final NULL
        JSR     kwrite          ; write it out
        JMP     PSINB           ; back around
PSIX1:	INC     DPL             ;
        BNE     PSIX2           ;
        INC     DPH             ; account for page crossing
PSIX2:	JMP     [DPL]           ; return to byte following final NULL

testram:
	LDA #0xA5C3
	LDX %0x0111
	STA %0x0111
	LDA #0x03FF
	LDY %0x0222
	STA %0x0222
	LDA %0x0111
	CMP #0xA5C3
	BNE fail
	LDA %0x0222
	CMP #0x03FF
	BEQ ramOK

fail:
	LDA #0x007E
	STA UserLeds
	BNE fail

ramOK:
	LDA #0x0081  ; signal success
	STA UserLeds
	STX %0x0111  ; restore the data we overwrote in the ram test
	STY %0x0222
        RTS

lsr8:
	LSR
	LSR
	LSR
	LSR
	LSR
	LSR
	LSR
	LSR
	RTS

writeprompt:
	JSR putstring
	DATA #ord('O')
	DATA #ord('K')
	DATA #ord('>')
	DATA #ord('\n')
	DATA #ord('\r')
	BRK
        RTS

coldboot:
	LDX #0x03FF
	TXS  ;; initialise stack pointer
	CLC

	LDA %0x0
	STA %0x8
        JSR testram

init:
        LDA #0
        STA %InputPointer
        STA %OutputHeadPointer
        STA %OutputTailPointer

        JSR writeprompt

        ;; binary debug: output content of 16-bit locations 8 and 9
	LDA %0x8
	JSR kwrite
	LDA %0x8
	JSR lsr8
	JSR kwrite
	LDA %0x9
	JSR kwrite
	LDA %0x9
	JSR lsr8
	JSR kwrite

uartinit:
	LDA #3
	STA UartS1

; main loop for I/O handling
; deal with input as highest priority
uartloop:
	LDA UartS1
        LSR
        BCS dealWithIncoming
	LSR         ; any room for transmission?
	BCC uartloop
okToSend:
	LDX %OutputTailPointer
	CPX %OutputHeadPointer
	BEQ uartloop
	LDA %OutputBuffer,X
	STA UartR1
	INX
	TXA
	AND #0xFF
	STA %OutputTailPointer
	JMP uartloop

dealWithIncoming:
	LDA UartR1  ; incoming data is shown on LEDs
	PHA
	STA UserLeds
	LDX %InputPointer
	STA %InputBuffer,X
        INX
        STX %InputPointer
	PLA
	CMP #0x0d  ; newline
        BNE uartloop

processLineOfInput:
	LDX #0
nextInputChar:
	CPX %InputPointer
	BEQ clearInputBuffer
	TXA
	TAY
	LDA %InputBuffer,X
	JSR kwrite
	TYA
	TAX
	INX
	BNE nextInputChar

clearInputBuffer:
	LDX #0
	STX %InputPointer
	BEQ uartloop  ; we're finished

nmivector:
	DATA # 0xFFFA  ; as a reminder of location
	DATA # 0xFFFF
resetvector:
        DATA # LOW(coldboot)
	DATA # HIGH(coldboot)
irqbrkvector:
	DATA # 0xFFFE  ; as a reminder of location
	DATA # 0xFFFF
