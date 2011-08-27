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
; converted to format acceptable to asm65Org16.py
;
; ($7FFB, $7FFA):	NMI RAM vector
; ($7FFF, $7FFE):       IRQ RAM vector
; (User program may not set a new RESET vector, or we could load
; an unrecoverable program into SRAM if battery backed, which would
; kill the system until the RAM was removed!)
;
;
; 6551 ACIA equates for serial I/O
;
ACIA_BASE = 0xF000        ; This is where the 6551 ACIA Starts
SDR  =   ACIA_BASE        ; RX'ed bytes read, TX bytes written, here
SSR  =   ACIA_BASE+1      ; Serial data status register. A write here
                          ; causes a programmed reset.
SCMD =   ACIA_BASE+2      ; Serial command reg. ()
SCTL =   ACIA_BASE+3      ; Serial control reg. ()
; Quick n'dirty assignments instead of proper definitions of each parameter
; "ORed" together to build the desired flexible configuration.  We're going
; to run 19200 baud, no parity, 8 data bits, 1 stop bit.  Period.  For now.
;
 SCTL_V = 0b00011111       ; 1 stop, 8 bits, 19200 baud
 SCMD_V = 0b00001011       ; No parity, no echo, no tx or rx IRQ, DTR*
 TX_RDY = 0b00010000       ; AND mask for transmitter ready
 RX_RDY = 0b00001000       ; AND mask for receiver buffer full
;
; Zero-page storage
 DPL            = 0x00     ; data pointer (two bytes)
 DPH            = 0x01     ; high of data pointer
 RECLEN         = 0x02     ; record length in bytes
 START_LO       = 0x03
 START_HI       = 0x04
 RECTYPE        = 0x05
 CHKSUM         = 0x06     ; record checksum accumulator
 DLFAIL         = 0x07     ; flag for download failure
 TEMP           = 0x08     ; save hex value

; "Shadow" RAM vectors (note each is 0x8000 below the actual ROM vector)
NMIVEC=		0x7FFA	 ; write actual NMI vector here
IRQVEC=         0x7FFE   ; write IRQ vector here

ENTRY_POINT	=0x0200	 ; where the RAM program MUST have its first instruction

START= 0xF800
;
START:  SEI                     ; disable interrupts
        CLD                     ; binary mode arithmetic
        LDX     #0xFF           ; Set up the stack pointer
        TXS                     ;       "
        LDA     #HIGH(START)    ; Initialiaze the interrupt vectors
        STA     NMIVEC+1        ; User program at ENTRY_POINT may change
        STA     IRQVEC+1	; these vectors.  Just do change before enabling
        LDA     #LOW(START)	; the interrupts, or you'll end up back in the d/l monitor.
        STA     NMIVEC
        STA     IRQVEC
        JSR     INITSER         ; Set up baud rate, parity, etc.
        ; Download Intel hex.  The program you download MUST have its entry
        ; instruction (even if only a jump to somewhere else) at ENTRY_POINT.
HEXDNLD:
	LDA     #0
        STA     DLFAIL          ;Start by assuming no D/L failure
        JSR     PUTSTRI
	DATA    #13
	DATA    #10
	DATA    #ord('>')
	DATA    #0

      ; DATA    13,10,13,10
      ; DATA    "Send 6502 code in"
      ; DATA    " Intel Hex format"
      ; DATA    " at 19200,n,8,1 ->"
      ; DATA    13,10
      ; DATA	0		; Null-terminate unless you prefer to crash.
HDWRECS:
	JSR     GETSER          ; Wait for start of record mark ':'
        CMP     #0x3a           ; ord(":")
        BNE     HDWRECS         ; not found yet
        ; Start of record marker has been found
        JSR     GETHEX          ; Get the record length
        STA     RECLEN          ; save it
        STA     CHKSUM          ; and save first byte of checksum
        JSR     GETHEX          ; Get the high part of start address
        STA     START_HI
        CLC
        ADC     CHKSUM          ; Add in the checksum
        STA     CHKSUM          ;
        JSR     GETHEX          ; Get the low part of the start address
        STA     START_LO
        CLC
        ADC     CHKSUM
        STA     CHKSUM
        JSR     GETHEX          ; Get the record type
        STA     RECTYPE         ; & save it
        CLC
        ADC     CHKSUM
        STA     CHKSUM
        LDA     RECTYPE
        BNE     HDER1           ; end-of-record
        LDX     RECLEN          ; number of data bytes to write to memory
        LDY     #0              ; Start offset at 0
HDLP1:  JSR     GETHEX          ; Get the first/next/last data byte
        STA     [START_LO],Y    ; Save it to RAM
        CLC
        ADC     CHKSUM
        STA     CHKSUM          ;
        INY                     ; update data pointer
        DEX                     ; decrement count
        BNE     HDLP1
        JSR     GETHEX          ; get the checksum
        CLC
        ADC     CHKSUM
        BNE     HDDLF1          ; If failed, report it
        ; Another successful record has been processed
        LDA     #'#'            ; Character indicating record OK = '#'
        STA     SDR             ; write it out but don't wait for output
        JMP     HDWRECS         ; get next record
HDDLF1:
	LDA     #'F'            ; Character indicating record failure = 'F'
        STA     DLFAIL          ; download failed if non-zero
        STA     SDR             ; write it to transmit buffer register
        JMP     HDWRECS         ; wait for next record start
HDER1:
	CMP     #1              ; Check for end-of-record type
        BEQ     HDER2
        JSR     PUTSTRI         ; Warn user of unknown record type
	DATA    #13
	DATA    #10
	DATA    #ord('?')
	DATA    #0
      ; DATA    13,10,13,10
      ; DATA    "Unknown record type 0x"
      ; DATA	0		; null-terminate unless you prefer to crash!
        LDA     RECTYPE         ; Get it
	STA	DLFAIL		; non-zero --> download has failed
        JSR     PUTHEX          ; print it
	LDA     #13		; but we'll let it finish so as not to
        JSR     PUTSER		; falsely start a new d/l from existing
        LDA     #10		; file that may still be coming in for
        JSR     PUTSER		; quite some time yet.
	JMP	HDWRECS
	; We've reached the end-of-record record
HDER2:	JSR     GETHEX          ; get the checksum
        CLC
        ADC     CHKSUM          ; Add previous checksum accumulator value
        BEQ     HDER3           ; checksum = 0 means we're OK!
        JSR     PUTSTRI         ; Warn user of bad checksum
	DATA    #13
	DATA    #10
	DATA    #ord('!')
	DATA    #0
      ; DATA   13,10,13,10
      ; DATA   "Bad record checksum!",13,10
      ; DATA   0		; Null-terminate or 6502 go bye-bye
        JMP     START
HDER3:  LDA     DLFAIL
        BEQ     HDEROK
        ;A download failure has occurred
        JSR     PUTSTRI
	DATA    #13
	DATA    #10
	DATA    #ord('~')
	DATA    #0
      ; DATA    13,10,13,10
      ; DATA   "Download Failed",13,10
      ; DATA   "Aborting!",13,10
      ; DATA	0		; null-terminate every string yada yada.
        JMP     START
HDEROK: JSR     PUTSTRI
	DATA    #13
	DATA    #10
	DATA    #ord('^')
	DATA    #0
      ; DATA    13,10,13,10
      ; DATA    "Download Successful!",13,10
      ; DATA    "Jumping to location 0x";
      ; DATA	0			; by now, I figure you know what this is for. :)
        LDA	#HIGH(ENTRY_POINT)	; Print the entry point in hex
        JSR	PUTHEX
        LDA	#LOW(ENTRY_POINT)
	JSR	PUTHEX
        JSR	PUTSTRI
	DATA    #13
	DATA    #10
	DATA    #0
        JMP     ENTRY_POINT	; jump to canonical entry point

;
; Set up baud rate, parity, stop bits, interrupt control, etc. for
; the serial port.
INITSER:
	LDA     #SCTL_V 	; Set baud rate 'n stuff
        STA     SCTL
        LDA     #SCMD_V 	; set parity, interrupt disable, n'stuff
        STA     SCMD
        RTS

;
;
; SerRdy : Return
SERRDY: LDA     SSR     	; look at serial status
        AND     #RX_RDY 	; strip off "character waiting" bit
        RTS             	; if zero, nothing waiting.
; Warning: this routine busy-waits until a character is ready.
; If you don't want to wait, call SERRDY first, AND then only
; call GETSER once a character is waiting.
GETSER: LDA     SSR    		; look at serial status
        AND     #RX_RDY 	; see if anything is ready
        BEQ     GETSER  	; busy-wait until character comes in!
        LDA     SDR     	; get the character
        RTS
; Busy wait

GETHEX: JSR     GETSER
        JSR     MKNIBL  	; Convert to 0..F numeric
        ASL
        ASL
        ASL
        ASL            	; This is the upper nibble
        AND     #0xF0
        STA     TEMP
        JSR     GETSER
        JSR     MKNIBL
        ORA     TEMP
        RTS             	; return with the nibble received

; Convert the ASCII nibble to numeric value from 0-F:
MKNIBL: CMP     #ord('9')+1  	; See if it's 0-9 or 'A'..'F' (no lowercase yet)
        BCC     MKNNH   	; If we borrowed, we lost the carry so 0..9
        SBC     #7+1    	; Subtract off extra 7 (SBC subtracts off one less)
        ; If we fall through, carry is set unlike direct entry at MKNNH
MKNNH:  SBC     #ord('0')-1  	; subtract off '0' (if carry clear coming in)
        AND     #0x0F    	; no upper nibble no matter what
        RTS             	; AND return the nibble

; Put byte in A as hexydecascii
PUTHEX: PHA
        LSR
        LSR
        LSR
        LSR
        JSR     PRNIBL
        PLA
PRNIBL: AND     #0x0F    	; strip off the low nibble
        CMP     #0x0A
        BCC     NOTHEX  	; if it's 0-9, add '0' else also add 7
        ADC     #6      	; Add 7 (6+carry=1), result will be carry clear
NOTHEX: ADC     #'0'    	; If carry clear, we're 0-9
; Write the character in A as ASCII:
PUTSER: STA     SDR     	; write to transmit register
WRS1:   LDA     SSR     	; get status
        AND     #TX_RDY 	; see if transmitter is busy
        BEQ     WRS1    	; if it is, wait
        RTS
;Put the string following in-line until a NULL out to the console
PUTSTRI:
	PLA			; Get the low part of "return" address (data start address)
        STA     DPL
        PLA
        STA     DPH             ; Get the high part of "return" address
                                ; (data Start address)
        ; Note: actually we're pointing one short
PSINB:  LDY     #1
        LDA     [DPL],Y         ; Get the next string character
        INC     DPL             ; update the pointer
        BNE     PSICHO          ; if not, we're pointing to next character
        INC     DPH             ; account for page crossing
PSICHO: ORA     #0              ; Set flags according to contents of Accumulator
        BEQ     PSIX1           ; don't print the final NULL
        JSR     PUTSER          ; write it out
        JMP     PSINB           ; back around
PSIX1:  INC     DPL             ;
        BNE     PSIX2           ;
        INC     DPH             ; account for page crossing
PSIX2:  JMP     (DPL)           ; return to byte following final NULL
;
; User "shadow" vectors:
GOIRQ:	JMP	(IRQVEC)
GONMI:	JMP	(NMIVEC)
GORST:	JMP	START		; Allowing user program to change this is a mistake

; vectors=0xFFFA
vectors:
NMIENT:  DATA     #LOW(GONMI)
	 DATA     #HIGH(GONMI)
RSTENT:  DATA     #LOW(GORST)
	 DATA     #HIGH(GORST)
IRQENT:  DATA     #LOW(GOIRQ)
	 DATA     #HIGH(GOIRQ)
; 				; finally.  das Ende.
