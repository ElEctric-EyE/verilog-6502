
;;**************************************************************************
;;
;;    hexloader.as - boot ROM and support routines for system-on-chip 65Org16 CPU experiment
;;    for use with i2c uart connected to 65Org16 in OHO GOP24
;;
;;    load and run (variant) intel hex format as output by HXA assembler
;;        see http://home.earthlink.net/~hxa/docs/hxa_demo.htm#l12
;;
;;    COPYRIGHT 2001 Ross Archer (parts derived from http://www.6502.org/source/monitors/intelhex/intelhex.htm)
;;    COPYRIGHT 2011 Ed Spittles
;;
;;    This file is part of verilog-6502 project on github
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

 .LIST

;; build instructions:
;;
;; use Andrew Jacobs' experimental assembler http://www.obelisk.demon.co.uk/files/65016.zip
;;    see http://forum.6502.org/viewtopic.php?p=15144#15144
;;
;; java -cp ./65016.jar org.x6502.x65016.As65016  hexloader.as
;; java -cp ./65016.jar org.x6502.x65016.Lk65016 -bss \$00010000-\$EFFFFFFF -code \$fffffd80-\$ffffFFFF -bin -output hexloader.bin hexloader.obj
;;

ROMSTART = $fffffd80

; hardware interface
;
UartS1=$FFFEFFF8
UartR1=$FFFEFFF9
UserLeds=$FFFD0000

; application binary interface
;
OSRDCH = $FFFFFFE0
OSWRCH = $FFFFFFEE

; memory allocations

; where the RAM program MUST have its first instruction
ENTRY_POINT  =  $0200

; allocate all the storage in zero page, which is large so we can even place buffers there
;     but note that the hexloader will place the application at $0200

 .ORG 0

kBufferMask = $3f
InputBuffer        .SPACE kBufferMask+1
InputPointer       .SPACE 1
OutputBuffer       .SPACE kBufferMask+1
OutputHeadPointer  .SPACE 1
OutputTailPointer  .SPACE 1

kDPL    .SPACE 1 ; kernel temporary data pointer low
kDPH    .SPACE 1
ktempx  .SPACE 1 ; kernel temporary
ktempy  .SPACE 1 ; kernel temporary

;
; Note that Hex format for 65Org16 uses ';' not ':' as the start of record mark
; also note that some fields are now composed of 16-bit elements:
; previously:
;  length offset type   data     checksum
;     :/08/E008/00/08090A0B0C0D0E0F/xx
; now
;     ;/10/E008/00/00080009000A000B000C000D000E000F/xx

RECLEN    .SPACE 1   ; record length in bytes
START_LO  .SPACE 1
START_HI  .SPACE 1
RECTYPE   .SPACE 1
CHKSUM    .SPACE 1   ; record checksum accumulator
DLFAIL    .SPACE 1   ; flag for download failure
TEMP      .SPACE 1   ; save hex value
TMPHEX    .SPACE 1   ; save another hex value

; hexloader rom entry point - cold reset vector

 .ORG ROMSTART

        sei                     ; disable interrupts
        cld                     ; binary mode arithmetic
        ldx     #$1FF           ; Set up the stack pointer
        txs                     ;   (beware! aliased physical RAM!)

        LDA #0
        STA InputPointer
        STA OutputHeadPointer
        STA OutputTailPointer

uartinit:
        LDA #3
        STA UartS1

        sta UserLeds

        ; Download Intel hex.  The program you download MUST have its entry
        ; instruction (even if only a jump to somewhere else) at ENTRY_POINT.
HEXDNLD lda     #0
        sta     START_HI        ; store all programs in bank 0 (page 0) for now
        sta     DLFAIL          ; Start by assuming no D/L failure
        jsr     kputstring
        .byte   13,10,13,10
        .byte   "Send 65Org16 code in"
        .byte   " variant Intel Hex format"
        .byte  " at 19200,n,8,1 ->"
        .byte   13,10
	.byte	0		; Null-terminate unless you prefer to crash.
HDWRECS jsr     kgetc           ; Wait for start of record mark ';'
        cmp     #';'
        bne     HDWRECS         ; not found yet
        ; Start of record marker has been found
        lda     #0
        sta     CHKSUM
        jsr     GETHEX          ; Get the record length
        sta     RECLEN          ; save it
        jsr     GET4HX          ; Get the 16-bit offset
        sta     START_LO
        jsr     GETHEX          ; Get the record type
        sta     RECTYPE         ; & save it
        bne     HDER1           ; end-of-record
        ldx     RECLEN          ; number of data bytes to write to memory
        ldy     #0              ; start offset at 0
HDLP1   jsr     GET4HX          ; Get the first/next/last data word
        sta     (START_LO),y    ; Save it to RAM
        iny                     ; update data pointer
        dex                     ; decrement character count
        dex                     ; ... twice
        bne     HDLP1
        jsr     GETHEX          ; get the checksum
        lda     CHKSUM
        bne     HDDLF1          ; If failed, report it
        ; Another successful record has been processed
        lda     #'#'            ; Character indicating record OK = '#'

;       jsr     kputc           ; write it out
        sta     UartR1          ; jam it out (fire and forget)

        jmp     HDWRECS         ; get next record
HDDLF1  lda     #'F'            ; Character indicating record failure = 'F'
        sta     DLFAIL          ; download failed if non-zero
        jsr     kputc           ; write it out
        jmp     HDWRECS         ; wait for next record start
HDER1   cmp     #1              ; Check for end-of-record type
        beq     HDER2
        jsr     kputstring      ; Warn user of unknown record type
        .byte   13,10,13,10
        .byte   "Unknown record type $"
	.byte	0		; null-terminate unless you prefer to crash!
        lda     RECTYPE         ; Get it
	sta	DLFAIL		; non-zero --> download has failed
        jsr     kputhex         ; print it
	lda     #13		; but we'll let it finish so as not to
        jsr     kputc		; falsely start a new d/l from existing
        lda     #10		; file that may still be coming in for
        jsr     kputc		; quite some time yet.
	jmp	HDWRECS
	; We've reached the end-of-record record
HDER2   jsr     GETHEX          ; get the checksum
        lda     CHKSUM          ; Add previous checksum accumulator value
        beq     HDER3           ; checksum = 0 means we're OK!
        jsr     kputstring      ; Warn user of bad checksum
        .byte   13,10,13,10
        .byte   "Bad record checksum!",13,10
        .byte   0		; Null-terminate or 6502 go bye-bye
        jmp     HEXDNLD
HDER3   lda     DLFAIL
        beq     HDEROK
        ;A download failure has occurred
        jsr     kputstring
        .byte   13,10,13,10
        .byte   "Download Failed",13,10
        .byte   "Aborting!",13,10
	.byte	0		; null-terminate every string yada yada.
        jmp     HEXDNLD
HDEROK  jsr     kputstring
        .byte   13,10,13,10
        .byte   "Download Successful!",13,10
        .byte   "Jumping to location $"
	.byte	0			; by now, I figure you know what this is for. :)
        lda	#HI(ENTRY_POINT)	; Print the entry point in hex
        jsr	kputhex
        lda	#LO(ENTRY_POINT)
	jsr	kputhex
        jsr	kputstring
        .byte   13,10
        .byte   0		; stop lemming-like march of the program ctr. thru data
        jmp     ENTRY_POINT	; jump to canonical entry point

; get four ascii chars, adding both octets into the checksum
GET4HX  jsr     GETHEX
        asl a
        asl a
        asl a
        asl a
        asl a
        asl a
        asl a
        asl a
        sta     TMPHEX
        jsr     GETHEX
        ora     TMPHEX
        rts

; get two ascii chars, add into the checksum
GETHEX  jsr     kgetc
        jsr     MKNIBL  	; Convert to 0..F numeric
        asl     a
        asl     a
        asl     a
        asl     a       	; This is the upper nibble
        and     #$F0
        sta     TEMP
        jsr     kgetc
        jsr     MKNIBL
        ora     TEMP
        sta     TEMP
        clc
        adc     CHKSUM          ; Add in the checksum
        and     #$ff
        sta     CHKSUM          ;
        lda     TEMP
        rts             	; return with the nibble received

; Convert the ASCII nibble to numeric value from 0-F:
MKNIBL  cmp     #'9'+1  	; See if it's 0-9 or 'A'..'F' (no lowercase yet)
        bcc     MKNNH   	; If we borrowed, we lost the carry so 0..9
        sbc     #7+1    	; Subtract off extra 7 (sbc subtracts off one less)
        ; If we fall through, carry is set unlike direct entry at MKNNH
MKNNH   sbc     #'0'-1  	; subtract off '0' (if carry clear coming in)
        and     #$0F    	; no upper nibble no matter what
        rts             	; and return the nibble

;; kernel routines

; main loop for I/O handling
; we have no interrupts or operating system
; so all I/O is performed when the application is ready for input
; at which point it may opportunistically also send output

; deal with input as highest priority
;   because we don't want to drop any incoming on the floor
;   and we can afford to let outgoing traffic buffer up
;   (we assume no flow control and no interrupts)

kgetc:
        txa ; preserve X
        pha

uartloop:
	LDA UartS1
        LSR A
        BCS dealWithIncoming
	LSR A        ; any room for transmission?
	BCC uartloop

        ;; handle any pending buffered output
okToSend:
	LDX OutputTailPointer
	CPX OutputHeadPointer
	BEQ uartloop
	LDA OutputBuffer,X
	STA UartR1
	INX
	TXA
	AND #kBufferMask
	STA OutputTailPointer
	JMP uartloop

dealWithIncoming:
        pla           ; restore X - this is the only exit path from kgetc
        tax

	LDA UartR1
	STA UserLeds  ; incoming data is shown on LEDs for debug

        RTS                     ; the incoming character is returned to the application

;Put the string following in-line until a NULL out to the console
kputstring:

        sty ktempy              ; preserve Y

        pla			; Get the low part of "return" address (data start address)
        sta     kDPL
        pla
        sta     kDPH            ; Get the high part of "return" address
                                ; (data start address)
        ; Note: actually we're pointing one short
PSINB   ldy     #1
        lda     (kDPL),y        ; Get the next string character
        inc     kDPL            ; update the pointer
        bne     PSICHO          ; if not, we're pointing to next character
        inc     kDPH            ; account for page crossing
PSICHO  ora     #0              ; Set flags according to contents of Accumulator
        beq     PSIX1           ; don't print the final NULL
        jsr     kputc          ; write it out
        jmp     PSINB           ; back around
PSIX1   inc     kDPL            ;
        bne     PSIX2           ;
        inc     kDPH            ; account for page crossing
PSIX2:
        ldy ktempy              ; restore Y

        jmp     (kDPL)          ; return to byte following final NULL

; Put byte in A to stdout as 2 hex chars
kputhex:
        pha             	;
        lsr a
        lsr a
        lsr a
        lsr a
        jsr     PRNIBL
        pla
PRNIBL  and     #$0F    	; strip off the low nibble
        cmp     #$0A
        bcc     NOTHEX  	; if it's 0-9, add '0' else also add 7
        adc     #6      	; Add 7 (6+carry=1), result will be carry clear
NOTHEX  adc     #'0'    	; If carry clear, we're 0-9

;; falling through

; kernel write to stdout, single 8-bit character
kputc:
        pha
kputcblocked:
        LDA UartS1
        LSR A
        LSR A        ; any room for transmission?
        BCC kputcblocked
        pla
        sta UartR1
        rts

kputcbuffered:
;    for use with slow output peripherals
;    writes to a circular buffer
;    no overflow check
;    buffer is consumed elsewhere

        stx ktempx    ; preserve X

	LDX OutputHeadPointer
	STA OutputBuffer,X
;	STA UserLeds  ; too fast to see, but good for simulation
	INX
	TXA
	AND #kBufferMask
	STA OutputHeadPointer

        ldx ktempx    ; restore X
	RTS

; we're not ready for interrupts yet
NMIHANDLE
IRQHANDLE
        RTI

 .ORG OSRDCH
        jmp     kgetc

 .ORG OSWRCH
        jmp     kputc

 .ORG $FFFFFFFA
NMIENT  .word     NMIHANDLE
RSTENT  .word     ROMSTART
IRQENT  .word     IRQHANDLE
.end				; finally.  das Ende.
