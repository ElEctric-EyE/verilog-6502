	;; for minimal proof-of-life with tube+T65 in GODIL40
	;;
	;;     PATH=$PATH:/home/ed/cc65/v2.13.2/bin make -f ../../boot816/Makefile -B tinybootrom.bin BASE=0xFFE0
	;;     ca65 -l tinybootrom.as -D BASE=0xFFE4 -D SRECORD_D=0
	;;     cl65 tinybootrom.o --target none --start-addr 0xFFE4 -o tinybootrom.bin
        ;;     xxd -c 1 tinybootrom.bin
	;;

        .ORG BASE ; place the bootstrap so the reset vector lands at FFFC

.DEFINE  TubeS1  $FEF8
.DEFINE  TubeR1  $FEF9

.DEFINE  offset  $FC ;; (256 - (writebyte - message))

bootstrap:
	LDX #offset
	TXS  ;; initialise stack pointer for bc6502v2
nextchar:
	LDA message-offset,X

writebyte: ;; inlined write byte subroutine - no RAM required
	STA TubeR1 ;; trying write-before-read, to get some sign of life
	BIT TubeS1
	NOP
	BVC writebyte

	INX
        BNE nextchar
done:
	BEQ done

message:
.byte   "T65",0

; this is arranged to be placed in the reset vector, by careful initial .Org
        .word bootstrap
