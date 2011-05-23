;
; original downloaded from http://www.6502.org/source/monitors/intelhex/intelhex.htm
; 2011-05-23 18:57:40 UTC
; copyright Ross Archer dedicated as follows
; This program is freeware.  Use it, modify it, ridicule it in public,
; or whatever, so long as authorship credit (blame?) is given somewhere to
; me for the base program.
;
; Ross seems uncontactable at the mail address given, also at ross@6502.org
;

<HTML><HEAD><TITLE>www.6502.org: Source: Intel HEX File Downloader</TITLE>
<META name="description" content="Serial port downloader for your 6502
system.">
</HEAD>
<BODY
BACKGROUND="../../../graph.gif" BGCOLOR="white" TEXT="black" LINK="#0000EE"
VLINK="#0000EE">
<A HREF="../../index.html"><IMG SRC="../../../mainlink.jpg" align=right
border=0 alt="[Return to Main Page]"></A>
<P><FONT SIZE=+1>Intel HEX File Downloader</FONT>&nbsp;<FONT
SIZE=-1>by Ross Archer</FONT>
<BR clear=all><A HREF="../../source.htm">[Up to Source Code
Repository]</A>
<BR clear=all><P>
<HR>
<P><B>Intel HEX File Downloader</B>
<BR><FONT SIZE=-1>Ross Archer, 9 February 2001</FONT>

<P>This program is freeware.  Use it, modify it, ridicule it in public,
or whatever, so long as authorship credit (blame?) is given somewhere to
me for the base program. 

<P>Although this program has worked on two different 65C02-based boards,
with TASM output files, I make no warranty of fitness or anything
else.  It's free -- so no matter what, happens you get your money's worth.

<P>
Feel free to write me at <A
HREF="mailto:dogbert@mindless.com">dogbert@mindless.com</A> if you are
having difficulties or have suggestions for improvement.  This is still
a work in progress.

<P>
<B><U>To customize for your 6551-equipped 6502 SBC</B></U>
<BR>[UK users have dispensation to customise it instead.]

<OL>
<LI>Set ACIA_BASE to the location of your 6551 ACIA (UART).

<LI>Change ENTRY_POINT as needed, if you prefer to jump somewhere other
than to $0200 after downloading code to RAM.  

<LI>Change .org location to locate START wherever you like. I put it in the
top 2K of memory since my hardware write-protects the EEPROM there but allows
me to write to the lower 30K at will, making this the only 100% safe place for
monitor code in EE.  YMMV

<LI>When burning EPROMs, remember to account for the File offset with your
programmer.  For example, if burning a 32K E(E)PROM, the offset is 
$8000.  If using a 16K E(E)PROM, the offset is $C000, etc. Best to see
that your start vectors are in the top six locations in your E(E)PROM as a
sanity check before blasting away.

<LI>ALL RAM-ified programs you download MUST have an entry point at
ENTRY_POINT, if only as a jump instruction to somewhere else.
  
<LI>If the user program uses NMI or IRQs, it is responsible for writing the
RAM "shadow" vectors at RUN-TIME prior to enabling interrupts.  This is
because the hex monitor initializes them to a "sane" values pointing into
the ROM monitor on every reset, so recovery from user program crashes is always possible. 

<LI>A lot of nice things are missing.  For example, no timeouts are provided
since that would require support of additional timer hardware.  It seems
that if a download halts, pressing the big red RESET button is the right
thing to do anyways. :)  This is minimal bootstrap.  It does the job
needed and little more.
</OL>

<PRE>
; ($7FFB, $7FFA):	NMI RAM vector
; ($7FFF, $7FFE):       IRQ RAM vector
; (User program may not set a new RESET vector, or we could load
; an unrecoverable program into SRAM if battery backed, which would
; kill the system until the RAM was removed!)
;
;
; Macros for converting 16-bit values to high and low bytes
#define hi(x)  (x >> 8)
#define lo(x)  (x & $FF)
;
; 6551 ACIA equates for serial I/O
;
#define ACIA_BASE $F000	        ; This is where the 6551 ACIA starts
#define SDR  	ACIA_BASE       ; RX'ed bytes read, TX bytes written, here
#define SSR     ACIA_BASE+1     ; Serial data status register. A write here
                                ; causes a programmed reset.
#define SCMD    ACIA_BASE+2     ; Serial command reg. ()
#define SCTL    ACIA_BASE+3     ; Serial control reg. ()
; Quick n'dirty assignments instead of proper definitions of each parameter
; "ORed" together to build the desired flexible configuration.  We're going
; to run 19200 baud, no parity, 8 data bits, 1 stop bit.  Period.  For now.
;
#define SCTL_V  00011111b       ; 1 stop, 8 bits, 19200 baud
#define SCMD_V  00001011b       ; No parity, no echo, no tx or rx IRQ, DTR*
#define TX_RDY  00010000b       ; AND mask for transmitter ready 
#define RX_RDY  00001000b       ; AND mask for receiver buffer full
;
; Zero-page storage
#define DPL             $00     ; data pointer (two bytes)
#define DPH             $01     ; high of data pointer
#define RECLEN          $02     ; record length in bytes
#define START_LO        $03
#define START_HI        $04
#define RECTYPE         $05
#define CHKSUM          $06     ; record checksum accumulator
#define DLFAIL          $07     ; flag for download failure
#define TEMP            $08     ; save hex value

; "Shadow" RAM vectors (note each is $8000 below the actual ROM vector)
#define	NMIVEC		$7FFA	; write actual NMI vector here
#define IRQVEC          $7FFE   ; write IRQ vector here

#define	ENTRY_POINT	$0200	; where the RAM program MUST have its first instruction

org $F800
;
START   sei                     ; disable interrupts
        cld                     ; binary mode arithmetic
        ldx     #$FF            ; Set up the stack pointer
        txs                     ;       "
        lda     #hi(START)      ; Initialiaze the interrupt vectors
        sta     NMIVEC+1        ; User program at ENTRY_POINT may change 
        sta     IRQVEC+1	; these vectors.  Just do change before enabling
        lda     #lo(START)	; the interrupts, or you'll end up back in the d/l monitor.
        sta     NMIVEC
        sta     IRQVEC
        jsr     INITSER         ; Set up baud rate, parity, etc.
        ; Download Intel hex.  The program you download MUST have its entry
        ; instruction (even if only a jump to somewhere else) at ENTRY_POINT.
HEXDNLD lda     #0
        sta     DLFAIL          ;Start by assuming no D/L failure
        jsr     PUTSTRI
        .byte   13,10,13,10
        .byte   "Send 6502 code in"
        .byte   " Intel Hex format"
        .byte  " at 19200,n,8,1 ->"
        .byte   13,10
	.byte	0		; Null-terminate unless you prefer to crash.
HDWRECS jsr     GETSER          ; Wait for start of record mark ':'
        cmp     #':'
        bne     HDWRECS         ; not found yet
        ; Start of record marker has been found
        jsr     GETHEX          ; Get the record length
        sta     RECLEN          ; save it
        sta     CHKSUM          ; and save first byte of checksum
        jsr     GETHEX          ; Get the high part of start address
        sta     START_HI
        clc
        adc     CHKSUM          ; Add in the checksum       
        sta     CHKSUM          ; 
        jsr     GETHEX          ; Get the low part of the start address
        sta     START_LO
        clc
        adc     CHKSUM
        sta     CHKSUM  
        jsr     GETHEX          ; Get the record type
        sta     RECTYPE         ; & save it
        clc
        adc     CHKSUM
        sta     CHKSUM   
        lda     RECTYPE
        bne     HDER1           ; end-of-record
        ldx     RECLEN          ; number of data bytes to write to memory
        ldy     #0              ; start offset at 0
HDLP1   jsr     GETHEX          ; Get the first/next/last data byte
        sta     (START_LO),y    ; Save it to RAM
        clc
        adc     CHKSUM
        sta     CHKSUM          ; 
        iny                     ; update data pointer
        dex                     ; decrement count
        bne     HDLP1
        jsr     GETHEX          ; get the checksum
        clc
        adc     CHKSUM
        bne     HDDLF1          ; If failed, report it
        ; Another successful record has been processed
        lda     #'#'            ; Character indicating record OK = '#'
        sta     SDR             ; write it out but don't wait for output 
        jmp     HDWRECS         ; get next record     
HDDLF1  lda     #'F'            ; Character indicating record failure = 'F'
        sta     DLFAIL          ; download failed if non-zero
        sta     SDR             ; write it to transmit buffer register
        jmp     HDWRECS         ; wait for next record start
HDER1   cmp     #1              ; Check for end-of-record type
        beq     HDER2
        jsr     PUTSTRI         ; Warn user of unknown record type
        .byte   13,10,13,10
        .byte   "Unknown record type $",
	.byte	0		; null-terminate unless you prefer to crash!
        lda     RECTYPE         ; Get it
	sta	DLFAIL		; non-zero --> download has failed
        jsr     PUTHEX          ; print it
	lda     #13		; but we'll let it finish so as not to 
        jsr     PUTSER		; falsely start a new d/l from existing 
        lda     #10		; file that may still be coming in for 
        jsr     PUTSER		; quite some time yet.
	jmp	HDWRECS
	; We've reached the end-of-record record
HDER2   jsr     GETHEX          ; get the checksum 
        clc
        adc     CHKSUM          ; Add previous checksum accumulator value
        beq     HDER3           ; checksum = 0 means we're OK!
        jsr     PUTSTRI         ; Warn user of bad checksum
        .byte   13,10,13,10
        .byte   "Bad record checksum!",13,10
        .byte   0		; Null-terminate or 6502 go bye-bye
        jmp     START
HDER3   lda     DLFAIL
        beq     HDEROK
        ;A download failure has occurred
        jsr     PUTSTRI
        .byte   13,10,13,10
        .byte   "Download Failed",13,10
        .byte   "Aborting!",13,10
	.byte	0		; null-terminate every string yada yada.
        jmp     START
HDEROK  jsr     PUTSTRI
        .byte   13,10,13,10
        .byte   "Download Successful!",13,10
        .byte   "Jumping to location $"
	.byte	0			; by now, I figure you know what this is for. :)
        lda	#hi(ENTRY_POINT)	; Print the entry point in hex
        jsr	PUTHEX
        lda	#lo(ENTRY_POINT)
	jsr	PUTHEX
        jsr	PUTSTRI
        .byte   13,10
        .byte   0		; stop lemming-like march of the program ctr. thru data
        jmp     ENTRY_POINT	; jump to canonical entry point

;
; Set up baud rate, parity, stop bits, interrupt control, etc. for
; the serial port.
INITSER lda     #SCTL_V 	; Set baud rate 'n stuff
        sta     SCTL
        lda     #SCMD_V 	; set parity, interrupt disable, n'stuff
        sta     SCMD
        rts 

;                             
;
; SerRdy : Return  
SERRDY  lda     SSR     	; look at serial status
        and     #RX_RDY 	; strip off "character waiting" bit
        rts             	; if zero, nothing waiting.
; Warning: this routine busy-waits until a character is ready.
; If you don't want to wait, call SERRDY first, and then only
; call GETSER once a character is waiting.
GETSER  lda     SSR    		; look at serial status
        and     #RX_RDY 	; see if anything is ready
        beq     GETSER  	; busy-wait until character comes in!
        lda     SDR     	; get the character
        rts
; Busy wait

GETHEX  jsr     GETSER
        jsr     MKNIBL  	; Convert to 0..F numeric
        asl     a
        asl     a
        asl     a
        asl     a       	; This is the upper nibble
        and     #$F0
        sta     TEMP
        jsr     GETSER
        jsr     MKNIBL
        ora     TEMP
        rts             	; return with the nibble received

; Convert the ASCII nibble to numeric value from 0-F:
MKNIBL  cmp     #'9'+1  	; See if it's 0-9 or 'A'..'F' (no lowercase yet)
        bcc     MKNNH   	; If we borrowed, we lost the carry so 0..9
        sbc     #7+1    	; Subtract off extra 7 (sbc subtracts off one less)
        ; If we fall through, carry is set unlike direct entry at MKNNH
MKNNH   sbc     #'0'-1  	; subtract off '0' (if carry clear coming in)
        and     #$0F    	; no upper nibble no matter what
        rts             	; and return the nibble

; Put byte in A as hexydecascii
PUTHEX  pha             	;
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
; Write the character in A as ASCII:
PUTSER  sta     SDR     	; write to transmit register
WRS1    lda     SSR     	; get status
        and     #TX_RDY 	; see if transmitter is busy
        beq     WRS1    	; if it is, wait
        rts
;Put the string following in-line until a NULL out to the console
PUTSTRI pla			; Get the low part of "return" address (data start address)
        sta     DPL     
        pla 
        sta     DPH             ; Get the high part of "return" address
                                ; (data start address)
        ; Note: actually we're pointing one short
PSINB   ldy     #1
        lda     (DPL),y         ; Get the next string character
        inc     DPL             ; update the pointer
        bne     PSICHO          ; if not, we're pointing to next character
        inc     DPH             ; account for page crossing
PSICHO  ora     #0              ; Set flags according to contents of Accumulator
        beq     PSIX1           ; don't print the final NULL 
        jsr     PUTSER          ; write it out
        jmp     PSINB           ; back around
PSIX1   inc     DPL             ; 
        bne     PSIX2           ;
        inc     DPH             ; account for page crossing
PSIX2   jmp     (DPL)           ; return to byte following final NULL
;
; User "shadow" vectors:
GOIRQ	jmp	(IRQVEC)
GONMI	jmp	(NMIVEC)
GORST	jmp	START		; Allowing user program to change this is a mistake
               
.org $FFFA
;  start at $FFFA
NMIENT  .word     GONMI
RSTENT  .word     GORST
IRQENT  .word     GOIRQ
.end				; finally.  das Ende.
</PRE>

<P><FONT SIZE=-1>Last page update: March 22, 2001.</FONT>
</BODY></HTML>
