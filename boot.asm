	.CODE
  	.ORG	$FFFFC000
	
;zero-page variables
XPOS		=$00
YPOS        	=$01
ATTBUT      	=$02
KEYBUFF     	=$03              
COUNTER     	=$04
FONT        	=$05

ADRESS      	=$06
NUMBER      	=$08
STBUF       	=$10
AREG        	=$22
PREG        	=$23
SREG        	=$24
XREG        	=$25
YREG        	=$26


I2Caddr     	=$0A
addr        	=$0B
val         	=$0C
data        	=$0D
              
BxL	    	=$1A
BxH         	=$1B
BxL2		=$1C
BxH2		=$1D
ByL		=$1E
ByH		=$1F
ByL2		=$20
ByH2		=$21

CHRBASE     	=$E1
CHR		=$E2
SENTINEL	=$E3
PATROW		=$E9
PIXROW		=$EA
CHRXLEN     	=$E5
CHRYLEN		=$E6
XWIDTH		=$E7
YWIDTH		=$E8
CHRYLENFIN  	=$E9

TMPCOL1		=$F7
TMPCOL2		=$F8
TMPCOL3		=$F9
PXLCOL1		=$FA
PXLCOL2		=$FB
PXLCOL3		=$FC
SCRCOL1		=$FD
SCRCOL2		=$FE
SCRCOL3		=$FF

;I/O Registers

I2CREG		=$FFFF0000	      
KBDAT		=$FFFF0008        ;8-bit Keyboard data
KBSTAT  	=$FFFF0009        ;8-bit Keyboard status register
SPI1		=$FFFF000A
SPI2		=$FFFF000B
SPI3		=$FFFF000C
SPI4		=$FFFF000D
UARTDREG	=$FFFF000E
UARTSREG	=$FFFF000F
DCOM		=$FFFF0010	      ;display command
DDAT		=$FFFF0011	      ;display data
RNG         	=$FFFF0017

;internal memory
HEXDIGIT  	=$FFFFC8F0        ;0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F in ascii 	
KEYTABLE	=$FFFFC900        ;keyboard lookup table		         		
COLTABLE	=$FFFFC980        ;4-bit color table					
CHARPIX     	=$FFFF0000

; NEW 65O16 OPCODES!   5/31/2012
;LDA #$xxxx             $00A9
LDBi              .MACRO param    	;LDB #$xxxx
                  .BYTE $01A9,  param
                  .ENDM
LDCi              .MACRO param    	;LDC #$xxxx
                  .BYTE $02A9,  param
                  .ENDM
LDDi              .MACRO param          ;LDD #$xxxx
                  .BYTE $03A9,  param
                  .ENDM
LDEi              .MACRO param          ;LDE #$xxxx
                  .BYTE $10A9,  param
                  .ENDM
LDFi              .MACRO param          ;LDF #$xxxx
                  .BYTE $11A9,  param
                  .ENDM
LDGi              .MACRO param          ;LDG #$xxxx
                  .BYTE $12A9,  param
                  .ENDM
LDHi              .MACRO param          ;LDH #$xxxx
                  .BYTE $13A9,  param
                  .ENDM
LDIi              .MACRO param          ;LDI #$xxxx
                  .BYTE $20A9,  param
                  .ENDM
LDJi              .MACRO param          ;LDJ #$xxxx
                  .BYTE $21A9,  param
                  .ENDM
LDKi              .MACRO param          ;LDK #$xxxx
                  .BYTE $22A9,  param
                  .ENDM
LDLi              .MACRO param          ;LDL #$xxxx
                  .BYTE $23A9,  param
                  .ENDM
LDMi              .MACRO param          ;LDM #$xxxx
                  .BYTE $30A9,  param
                  .ENDM
LDNi              .MACRO param          ;LDN #$xxxx
                  .BYTE $31A9,  param
                  .ENDM
LDOi              .MACRO param          ;LDO #$xxxx
                  .BYTE $32A9,  param
                  .ENDM
LDQi              .MACRO param          ;LDQ #$xxxx
                  .BYTE $33A9,  param
                  .ENDM
LDWi              .MACRO param
                  .BYTE $00C2,  param
                  .ENDM

;LDA $xxxx              $00A5
LDBzp             .MACRO param          ;LDB $xxxx
                  .BYTE $01A5,  param
                  .ENDM
LDCzp             .MACRO param          ;LDC $xxxx
                  .BYTE $02A5,  param
                  .ENDM
LDDzp             .MACRO param          ;LDD $xxxx
                  .BYTE $03A5,  param
                  .ENDM
LDEzp             .MACRO param          ;LDE $xxxx
                  .BYTE $10A5,  param
                  .ENDM
LDFzp             .MACRO param          ;LDF $xxxx
                  .BYTE $11A5,  param
                  .ENDM
LDGzp             .MACRO param          ;LDG $xxxx
                  .BYTE $12A5,  param
                  .ENDM
LDHzp             .MACRO param          ;LDH $xxxx
                  .BYTE $13A5,  param
                  .ENDM
LDIzp             .MACRO param          ;LDI $xxxx
                  .BYTE $20A5,  param
                  .ENDM
LDJzp             .MACRO param          ;LDJ $xxxx
                  .BYTE $21A5,  param
                  .ENDM
LDKzp             .MACRO param          ;LDK $xxxx
                  .BYTE $22A5,  param
                  .ENDM
LDLzp             .MACRO param          ;LDL $xxxx
                  .BYTE $23A5,  param
                  .ENDM
LDMzp             .MACRO param          ;LDM $xxxx
                  .BYTE $30A5,  param
                  .ENDM
LDNzp             .MACRO param          ;LDN $xxxx
                  .BYTE $31A5,  param
                  .ENDM
LDOzp             .MACRO param          ;LDO $xxxx
                  .BYTE $32A5,  param
                  .ENDM
LDQzp             .MACRO param          ;LDQ $xxxx
                  .BYTE $33A5,  param
                  .ENDM
LDWzp             .MACRO param
                  .BYTE $00A7
                  .ENDM
                  
;LDA $xxxxxxxx          $00AD
LDBa              .MACRO param          ;LDB $xxxxxxxx
                  .BYTE $01AD
		  .WORD  param
                  .ENDM
LDCa              .MACRO param          ;LDC $xxxxxxxx
                  .BYTE $02AD
		  .WORD  param
                  .ENDM
LDDa              .MACRO param          ;LDD $xxxxxxxx
                  .BYTE $03AD
		  .WORD  param
                  .ENDM
LDEa              .MACRO param          ;LDE $xxxxxxxx
                  .BYTE $10AD
		  .WORD  param
                  .ENDM
LDFa              .MACRO param          ;LDF $xxxxxxxx
                  .BYTE $11AD
		  .WORD  param
                  .ENDM
LDGa              .MACRO param          ;LDG $xxxxxxxx
                  .BYTE $12AD
		  .WORD  param
                  .ENDM
LDHa              .MACRO param          ;LDH $xxxxxxxx
                  .BYTE $13AD
		  .WORD  param
                  .ENDM
LDIa              .MACRO param          ;LDI $xxxxxxxx
                  .BYTE $20AD
		  .WORD  param
                  .ENDM
LDJa              .MACRO param          ;LDJ $xxxxxxxx
                  .BYTE $21AD
		  .WORD  param
                  .ENDM
LDKa              .MACRO param          ;LDK $xxxxxxxx
                  .BYTE $22AD
		  .WORD  param
                  .ENDM
LDLa              .MACRO param          ;LDL $xxxxxxxx
                  .BYTE $23AD
		  .WORD  param
                  .ENDM
LDMa              .MACRO param          ;LDM $xxxxxxxx
                  .BYTE $30AD
		  .WORD  param
                  .ENDM
LDNa              .MACRO param          ;LDN $xxxxxxxx
                  .BYTE $31AD
		  .WORD  param
                  .ENDM
LDOa              .MACRO param          ;LDO $xxxxxxxx
                  .BYTE $32AD
		  .WORD  param
                  .ENDM
LDQa              .MACRO param          ;LDQ $xxxxxxxx
                  .BYTE $33AD
		  .WORD  param
                  .ENDM
LDWa              .MACRO param
                  .BYTE $00AF
		  .WORD  param
                  .ENDM
                  
;LDA $xxxx,x            $00B5
LDBzpx            .MACRO param          
                  .BYTE $01B5,  param
                  .ENDM
LDCzpx            .MACRO param          
                  .BYTE $02B5,  param
                  .ENDM
LDDzpx            .MACRO param          
                  .BYTE $03B5,  param
                  .ENDM
LDEzpx            .MACRO param          
                  .BYTE $10B5,  param
                  .ENDM
LDFzpx            .MACRO param          
                  .BYTE $11B5,  param
                  .ENDM
LDGzpx            .MACRO param          
                  .BYTE $12B5,  param
                  .ENDM
LDHzpx            .MACRO param          
                  .BYTE $13B5,  param
                  .ENDM
LDIzpx            .MACRO param          
                  .BYTE $20B5,  param
                  .ENDM
LDJzpx            .MACRO param          
                  .BYTE $21B5,  param
                  .ENDM
LDKzpx            .MACRO param          
                  .BYTE $22B5,  param
                  .ENDM
LDLzpx            .MACRO param          
                  .BYTE $23B5,  param
                  .ENDM
LDMzpx            .MACRO param          
                  .BYTE $30B5,  param
                  .ENDM
LDNzpx            .MACRO param          
                  .BYTE $31B5,  param
                  .ENDM
LDOzpx            .MACRO param          
                  .BYTE $32B5,  param
                  .ENDM
LDQzpx            .MACRO param          
                  .BYTE $33B5,  param
                  .ENDM
LDWzpx            .MACRO param
                  .BYTE $00F4,  param
                  .ENDM
                  
;LDA $xxxxxxxx,x        $00BD
LDBax             .MACRO param         
                  .BYTE $01BD
		  .WORD  param
                  .ENDM
LDCax             .MACRO param         
                  .BYTE $02BD
		  .WORD  param
                  .ENDM
LDDax             .MACRO param          
                  .BYTE $03BD
		  .WORD  param
                  .ENDM
LDEax             .MACRO param          
                  .BYTE $10BD
		  .WORD  param
                  .ENDM
LDFax             .MACRO param          
                  .BYTE $11BD
		  .WORD  param
                  .ENDM
LDGax             .MACRO param          
                  .BYTE $12BD
		  .WORD  param
                  .ENDM
LDHax             .MACRO param          
                  .BYTE $13BD
		  .WORD  param
                  .ENDM
LDIax             .MACRO param          
                  .BYTE $20BD
		  .WORD  param
                  .ENDM
LDJax             .MACRO param          
                  .BYTE $21BD
		  .WORD  param
                  .ENDM
LDKax             .MACRO param          
                  .BYTE $22BD
		  .WORD  param
                  .ENDM
LDLax             .MACRO param          
                  .BYTE $23BD
		  .WORD  param
                  .ENDM
LDMax             .MACRO param          
                  .BYTE $30BD
		  .WORD  param
                  .ENDM
LDNax             .MACRO param          
                  .BYTE $31BD
		  .WORD  param
                  .ENDM
LDOax             .MACRO param          
                  .BYTE $32BD
		  .WORD  param
                  .ENDM
LDQax             .MACRO param          
                  .BYTE $33BD
		  .WORD  param
                  .ENDM
                  
;LDA $xxxxxxxx,y        $00B9
LDBay             .MACRO param          
                  .BYTE $01B9
		  .WORD  param
                  .ENDM
LDCay             .MACRO param          
                  .BYTE $02B9
		  .WORD  param
                  .ENDM
LDDay             .MACRO param          
                  .BYTE $03B9
		  .WORD  param
                  .ENDM
LDEay             .MACRO param          
                  .BYTE $10B9
		  .WORD  param
                  .ENDM
LDFay             .MACRO param          
                  .BYTE $11B9
		  .WORD  param
                  .ENDM
LDGay             .MACRO param          
                  .BYTE $12B9
		  .WORD  param
                  .ENDM
LDHay             .MACRO param          
                  .BYTE $13B9
		  .WORD  param
                  .ENDM
LDIay             .MACRO param          
                  .BYTE $20B9
		  .WORD  param
                  .ENDM
LDJay             .MACRO param          
                  .BYTE $21B9
		  .WORD  param
                  .ENDM
LDKay             .MACRO param          
                  .BYTE $22B9
		  .WORD  param
                  .ENDM
LDLay             .MACRO param          
                  .BYTE $23B9
		  .WORD  param
                  .ENDM
LDMay             .MACRO param          
                  .BYTE $30B9
		  .WORD  param
                  .ENDM
LDNay             .MACRO param          
                  .BYTE $31B9
		  .WORD  param
                  .ENDM
LDOay             .MACRO param          
                  .BYTE $32B9
		  .WORD  param
                  .ENDM
LDQay             .MACRO param          
                  .BYTE $33B9
		  .WORD  param
                  .ENDM

LDAaw             .MACRO param        ;LDA $xxxxxxxx,w
                  .BYTE $00BB
		  .WORD  param
                  .ENDM
LDBaw             .MACRO param          
                  .BYTE $01BB
		  .WORD  param
                  .ENDM
LDCaw             .MACRO param          
                  .BYTE $02BB
		  .WORD  param
                  .ENDM
LDDaw             .MACRO param          
                  .BYTE $03BB
		  .WORD  param
                  .ENDM
LDEaw             .MACRO param          
                  .BYTE $10BB
		  .WORD  param
                  .ENDM
LDFaw             .MACRO param          
                  .BYTE $11BB
		  .WORD  param
                  .ENDM
LDGaw             .MACRO param          
                  .BYTE $12BB
		  .WORD  param
                  .ENDM
LDHaw             .MACRO param          
                  .BYTE $13BB
		  .WORD  param
                  .ENDM
LDIaw             .MACRO param          
                  .BYTE $20BB
		  .WORD  param
                  .ENDM
LDJaw             .MACRO param          
                  .BYTE $21BB
		  .WORD  param
                  .ENDM
LDKaw             .MACRO param          
                  .BYTE $22BB
		  .WORD  param
                  .ENDM
LDLaw             .MACRO param          
                  .BYTE $23BB
		  .WORD  param
                  .ENDM
LDMaw             .MACRO param          
                  .BYTE $30BB
		  .WORD  param
                  .ENDM
LDNaw             .MACRO param          
                  .BYTE $31BB
		  .WORD  param
                  .ENDM
LDOaw             .MACRO param          
                  .BYTE $32BB
		  .WORD  param
                  .ENDM
LDQaw             .MACRO param          
                  .BYTE $33BB
		  .WORD  param
                  .ENDM
;LDA ($xxxx),y		$00B1
LDBindy            .MACRO param          
                  .BYTE $01B1,  param
                  .ENDM
LDCindy            .MACRO param          
                  .BYTE $02B1,  param
                  .ENDM
LDDindy            .MACRO param          
                  .BYTE $03B1,  param
                  .ENDM
LDEindy            .MACRO param          
                  .BYTE $10B1,  param
                  .ENDM
LDFindy            .MACRO param          
                  .BYTE $11B1,  param
                  .ENDM
LDGindy            .MACRO param          
                  .BYTE $12B1,  param
                  .ENDM
LDHindy            .MACRO param          
                  .BYTE $13B1,  param
                  .ENDM
LDIindy            .MACRO param          
                  .BYTE $20B1,  param
                  .ENDM
LDJindy            .MACRO param          
                  .BYTE $21B1,  param
                  .ENDM
LDKindy            .MACRO param          
                  .BYTE $22B1,  param
                  .ENDM
LDLindy            .MACRO param          
                  .BYTE $23B1,  param
                  .ENDM
LDMindy            .MACRO param          
                  .BYTE $30B1,  param
                  .ENDM
LDNindy            .MACRO param          
                  .BYTE $31B1,  param
                  .ENDM
LDOindy            .MACRO param          
                  .BYTE $32B1,  param
                  .ENDM
LDQindy            .MACRO param          
                  .BYTE $33B1,  param
                  .ENDM
LDWindy            .MACRO param
                  .BYTE $00F4,  param
                  .ENDM

LDAindw		  .MACRO param		;LDA ($xxxx),w
		  .BYTE $00B2, param
		  .ENDM
LDBindw            .MACRO param          
                  .BYTE $01B2,  param
                  .ENDM
LDCindw            .MACRO param          
                  .BYTE $02B2,  param
                  .ENDM
LDDindw            .MACRO param          
                  .BYTE $03B2,  param
                  .ENDM
LDEindw            .MACRO param          
                  .BYTE $10B2,  param
                  .ENDM
LDFindw            .MACRO param          
                  .BYTE $11B2,  param
                  .ENDM
LDGindw            .MACRO param          
                  .BYTE $12B2,  param
                  .ENDM
LDHindw            .MACRO param          
                  .BYTE $13B2,  param
                  .ENDM
LDIindw            .MACRO param          
                  .BYTE $20B2,  param
                  .ENDM
LDJindw            .MACRO param          
                  .BYTE $21B2,  param
                  .ENDM
LDKindw            .MACRO param          
                  .BYTE $22B2,  param
                  .ENDM
LDLindw            .MACRO param          
                  .BYTE $23B2,  param
                  .ENDM
LDMindw            .MACRO param          
                  .BYTE $30B2,  param
                  .ENDM
LDNindw            .MACRO param          
                  .BYTE $31B2,  param
                  .ENDM
LDOindw            .MACRO param          
                  .BYTE $32B2,  param
                  .ENDM
LDQindw            .MACRO param          
                  .BYTE $33B2,  param
                  .ENDM
                  
;STA $xxxx              $0085
STBzp             .MACRO param          ;STB $xxxx
                  .BYTE $0485,  param
                  .ENDM
STCzp             .MACRO param          ;STC $xxxx
                  .BYTE $0885,  param
                  .ENDM
STDzp             .MACRO param          ;STD $xxxx
                  .BYTE $0C85,  param
                  .ENDM
STEzp             .MACRO param          ;STE $xxxx
                  .BYTE $4085,  param
                  .ENDM
STFzp             .MACRO param          ;STF $xxxx
                  .BYTE $4485,  param
                  .ENDM
STGzp             .MACRO param          ;STG $xxxx
                  .BYTE $4885,  param
                  .ENDM
STHzp             .MACRO param          ;STH $xxxx
                  .BYTE $4C85,  param
                  .ENDM
STIzp             .MACRO param          ;STI $xxxx
                  .BYTE $8085,  param
                  .ENDM
STJzp             .MACRO param          ;STJ $xxxx
                  .BYTE $8485,  param
                  .ENDM
STKzp             .MACRO param          ;STK $xxxx
                  .BYTE $8885,  param
                  .ENDM
STLzp             .MACRO param          ;STL $xxxx
                  .BYTE $8C85,  param
                  .ENDM
STMzp             .MACRO param          ;STM $xxxx
                  .BYTE $C085,  param
                  .ENDM
STNzp             .MACRO param          ;STN $xxxx
                  .BYTE $C485,  param
                  .ENDM
STOzp             .MACRO param          ;STO $xxxx
                  .BYTE $C885,  param
                  .ENDM
STQzp             .MACRO param          ;STQ $xxxx
                  .BYTE $CC85,  param
                  .ENDM
STWzp             .MACRO param
                  .BYTE $0087,  param
                  .ENDM

;STA $xxxxxxxx          $008D                  
STBa              .MACRO param          ;STB $xxxxxxxx
                  .BYTE $048D
		  .WORD  param
                  .ENDM
STCa              .MACRO param          ;STC $xxxxxxxx
                  .BYTE $088D
		  .WORD  param
                  .ENDM
STDa              .MACRO param          ;STD $xxxxxxxx
                  .BYTE $0C8D
		  .WORD  param
                  .ENDM
STEa              .MACRO param          ;STE $xxxxxxxx
                  .BYTE $408D
		  .WORD  param
                  .ENDM
STFa              .MACRO param          ;STF $xxxxxxxx
                  .BYTE $448D
		  .WORD  param
                  .ENDM
STGa              .MACRO param          ;STG $xxxxxxxx
                  .BYTE $488D
		  .WORD  param
                  .ENDM
STHa              .MACRO param          ;STH $xxxxxxxx
                  .BYTE $4C8D
		  .WORD  param
                  .ENDM
STIa              .MACRO param          ;STI $xxxxxxxx
                  .BYTE $808D
		  .WORD  param
                  .ENDM
STJa              .MACRO param          ;STJ $xxxxxxxx
                  .BYTE $848D
		  .WORD  param
                  .ENDM
STKa              .MACRO param          ;STK $xxxxxxxx
                  .BYTE $888D
		  .WORD  param
                  .ENDM
STLa              .MACRO param          ;STL $xxxxxxxx
                  .BYTE $8C8D
		  .WORD  param
                  .ENDM
STMa              .MACRO param          ;STM $xxxxxxxx
                  .BYTE $C08D
		  .WORD  param
                  .ENDM
STNa              .MACRO param          ;STN $xxxxxxxx
                  .BYTE $C48D
		  .WORD  param
                  .ENDM
STOa              .MACRO param          ;STO $xxxxxxxx
                  .BYTE $C88D
		  .WORD  param
                  .ENDM
STQa              .MACRO param          ;STQ $xxxxxxxx
                  .BYTE $CC8D
		  .WORD  param
                  .ENDM
STWa              .MACRO param
                  .BYTE $008F
		  .WORD  param
                  .ENDM
                  
;STA $xxxx,x            $0095
STBzpx            .MACRO param          ;STB $xxxx,x
                  .BYTE $0495,  param
                  .ENDM
STCzpx            .MACRO param          ;STC $xxxx,x
                  .BYTE $0895,  param
                  .ENDM
STDzpx            .MACRO param          ;STD $xxxx,x
                  .BYTE $0C95,  param
                  .ENDM
STEzpx            .MACRO param          ;STE $xxxx,x
                  .BYTE $4095,  param
                  .ENDM
STFzpx            .MACRO param          ;STF $xxxx,x
                  .BYTE $4495,  param
                  .ENDM
STGzpx            .MACRO param          ;STG $xxxx,x
                  .BYTE $4895,  param
                  .ENDM
STHzpx            .MACRO param          ;STH $xxxx,x
                  .BYTE $4C95,  param
                  .ENDM
STIzpx            .MACRO param          ;STI $xxxx,x
                  .BYTE $8095,  param
                  .ENDM
STJzpx            .MACRO param          ;STJ $xxxx,x
                  .BYTE $8495,  param
                  .ENDM
STKzpx            .MACRO param          ;STK $xxxx,x
                  .BYTE $8895,  param
                  .ENDM
STLzpx            .MACRO param          ;STL $xxxx,x
                  .BYTE $8C95,  param
                  .ENDM
STMzpx            .MACRO param          ;STM $xxxx,x
                  .BYTE $C095,  param
                  .ENDM
STNzpx            .MACRO param          ;STN $xxxx,x
                  .BYTE $C495,  param
                  .ENDM
STOzpx            .MACRO param          ;STO $xxxx,x
                  .BYTE $C895,  param
                  .ENDM
STQzpx            .MACRO param          ;STQ $xxxx,x
                  .BYTE $CC95,  param
                  .ENDM
STWzpx            .MACRO param
                  .BYTE $0074,  param
                  .ENDM
                  
;STA $xxxxxxxx,x        $009D
STBax             .MACRO param          ;STB $xxxxxxxx,x
                  .BYTE $049D
		  .WORD  param
                  .ENDM
STCax             .MACRO param          ;STC $xxxxxxxx,x
                  .BYTE $089D
		  .WORD  param
                  .ENDM
STDax             .MACRO param          ;STD $xxxxxxxx,x
                  .BYTE $0C9D
		  .WORD  param
                  .ENDM
STEax             .MACRO param          ;STE $xxxxxxxx,x
                  .BYTE $409D
		  .WORD  param
                  .ENDM
STFax             .MACRO param          ;STF $xxxxxxxx,x
                  .BYTE $449D
		  .WORD  param
                  .ENDM
STGax             .MACRO param          ;STG $xxxxxxxx,x
                  .BYTE $489D
		  .WORD  param
                  .ENDM
STHax             .MACRO param          ;STH $xxxxxxxx,x
                  .BYTE $4C9D
		  .WORD  param
                  .ENDM
STIax             .MACRO param          ;STI $xxxxxxxx,x
                  .BYTE $809D
		  .WORD  param
                  .ENDM
STJax             .MACRO param          ;STJ $xxxxxxxx,x
                  .BYTE $849D
		  .WORD  param
                  .ENDM
STKax             .MACRO param          ;STK $xxxxxxxx,x
                  .BYTE $889D
		  .WORD  param
                  .ENDM
STLax             .MACRO param          ;STL $xxxxxxxx,x
                  .BYTE $8C9D
		  .WORD  param
                  .ENDM
STMax             .MACRO param          ;STM $xxxxxxxx,x
                  .BYTE $C09D
		  .WORD  param
                  .ENDM
STNax             .MACRO param          ;STN $xxxxxxxx,x
                  .BYTE $C49D
		  .WORD  param
                  .ENDM
STOax             .MACRO param          ;STO $xxxxxxxx,x
                  .BYTE $C89D
		  .WORD  param
                  .ENDM
STQax             .MACRO param          ;STQ $xxxxxxxx,x
                  .BYTE $CC9D
		  .WORD  param
                  .ENDM
STWax             .MACRO param
                  .BYTE $0087
		  .WORD  param
                  .ENDM

;STA $xxxxxxxx,y        $0099
STBay             .MACRO param          ;STB $xxxxxxxx,y
                  .BYTE $0499
		  .WORD  param
                  .ENDM
STCay             .MACRO param          ;STC $xxxxxxxx,y
                  .BYTE $0899
		  .WORD  param
                  .ENDM
STDay             .MACRO param          ;STD $xxxxxxxx,y
                  .BYTE $0C99
		  .WORD  param
                  .ENDM
STEay             .MACRO param          ;STE $xxxxxxxx,y
                  .BYTE $4099
		  .WORD  param
                  .ENDM
STFay             .MACRO param          ;STF $xxxxxxxx,y
                  .BYTE $4499
		  .WORD  param
                  .ENDM
STGay             .MACRO param          ;STG $xxxxxxxx,y
                  .BYTE $4899
		  .WORD  param
                  .ENDM
STHay             .MACRO param          ;STH $xxxxxxxx,y
                  .BYTE $4C99
		  .WORD  param
                  .ENDM
STIay             .MACRO param          ;STI $xxxxxxxx,y
                  .BYTE $8099
		  .WORD  param
                  .ENDM
STJay             .MACRO param          ;STJ $xxxxxxxx,y
                  .BYTE $8499
		  .WORD  param
                  .ENDM
STKay             .MACRO param          ;STK $xxxxxxxx,y
                  .BYTE $8899
		  .WORD  param
                  .ENDM
STLay             .MACRO param          ;STL $xxxxxxxx,y
                  .BYTE $8C99
		  .WORD  param
                  .ENDM
STMay             .MACRO param          ;STM $xxxxxxxx,y
                  .BYTE $C099
		  .WORD  param
                  .ENDM
STNay             .MACRO param          ;STN $xxxxxxxx,y
                  .BYTE $C499
		  .WORD  param
                  .ENDM
STOay             .MACRO param          ;STO $xxxxxxxx,y
                  .BYTE $C899
		  .WORD  param
                  .ENDM
STQay             .MACRO param          ;STQ $xxxxxxxx,y
                  .BYTE $CC99
		  .WORD  param
                  .ENDM

STAaw             .MACRO param          ;STA $xxxxxxxx,w
                  .BYTE $009B
		  .WORD  param
                  .ENDM
STBaw             .MACRO param          ;STB $xxxxxxxx,w
                  .BYTE $049B
		  .WORD  param
                  .ENDM
STCaw             .MACRO param          ;STC $xxxxxxxx,w
                  .BYTE $089B
		  .WORD  param
                  .ENDM
STDaw             .MACRO param          ;STD $xxxxxxxx,w
                  .BYTE $0C9B
		  .WORD  param
                  .ENDM
STEaw             .MACRO param          ;STE $xxxxxxxx,w
                  .BYTE $409B
		  .WORD  param
                  .ENDM
STFaw             .MACRO param          ;STF $xxxxxxxx,w
                  .BYTE $449B
		  .WORD  param
                  .ENDM
STGaw             .MACRO param          ;STG $xxxxxxxx,w
                  .BYTE $489B
		  .WORD  param
                  .ENDM
STHaw             .MACRO param          ;STH $xxxxxxxx,w
                  .BYTE $4C9B
		  .WORD  param
                  .ENDM
STIaw             .MACRO param          ;STI $xxxxxxxx,w
                  .BYTE $809B
		  .WORD  param
                  .ENDM
STJaw             .MACRO param          ;STJ $xxxxxxxx,w
                  .BYTE $849B
		  .WORD  param
                  .ENDM
STKaw             .MACRO param          ;STK $xxxxxxxx,w
                  .BYTE $889B
		  .WORD  param
                  .ENDM
STLaw             .MACRO param          ;STL $xxxxxxxx,w
                  .BYTE $8C9B
		  .WORD  param
                  .ENDM
STMaw             .MACRO param          ;STM $xxxxxxxx,w
                  .BYTE $C09B
		  .WORD  param
                  .ENDM
STNaw             .MACRO param          ;STN $xxxxxxxx,w
                  .BYTE $C49B
		  .WORD  param
                  .ENDM
STOaw             .MACRO param          ;STO $xxxxxxxx,w
                  .BYTE $C89B
		  .WORD  param
                  .ENDM
STQaw             .MACRO param          ;STQ $xxxxxxxx,w
                  .BYTE $CC9B
		  .WORD  param	
                  .ENDM

;CMPAi                  $00C9                  
CMPBi             .MACRO param          ;CMPB #$xxxx
                  .BYTE $04C9,  param
                  .ENDM
CMPCi             .MACRO param          ;CMPC #$xxxx
                  .BYTE $08C9,  param
                  .ENDM
CMPDi             .MACRO param          ;CMPD #$xxxx
                  .BYTE $0CC9,  param
                  .ENDM
CMPEi             .MACRO param          ;CMPE #$xxxx
                  .BYTE $40C9,  param
                  .ENDM
CMPFi             .MACRO param          ;CMPF #$xxxx
                  .BYTE $44C9,  param
                  .ENDM
CMPGi             .MACRO param          ;CMPG #$xxxx
                  .BYTE $48C9,  param
                  .ENDM
CMPHi             .MACRO param          ;CMPH #$xxxx
                  .BYTE $4CC9,  param
                  .ENDM
CMPIi             .MACRO param          ;CMPI #$xxxx
                  .BYTE $80C9,  param
                  .ENDM
CMPJi             .MACRO param          ;CMPJ #$xxxx
                  .BYTE $84C9,  param
                  .ENDM
CMPKi             .MACRO param          ;CMPK #$xxxx
                  .BYTE $88C9,  param
                  .ENDM
CMPLi             .MACRO param          ;CMPL #$xxxx
                  .BYTE $8CC9,  param
                  .ENDM
CMPMi             .MACRO param          ;CMPM #$xxxx
                  .BYTE $C0C9,  param
                  .ENDM
CMPNi             .MACRO param          ;CMPN #$xxxx
                  .BYTE $C4C9,  param
                  .ENDM
CMPOi             .MACRO param          ;CMPO #$xxxx
                  .BYTE $C8C9,  param
                  .ENDM
CMPQi             .MACRO param          ;CMPQ #$xxxx
                  .BYTE $CCC9,  param
                  .ENDM
CMPWi             .MACRO param
                  .BYTE $00E2,  param
                  .ENDM

;PHY               .MACRO
;                  .BYTE $005A
;                  .ENDM
;PHX               .MACRO
;                  .BYTE $00DA
;                  .ENDM
;PLY               .MACRO
;                  .BYTE $007A
;                  .ENDM
;PLX               .MACRO
;                  .BYTE $00FA
;                  .ENDM

;PHA                    $0048
PHB               .MACRO
                  .BYTE $0448
                  .ENDM
PHC               .MACRO
                  .BYTE $0848
                  .ENDM
PHD               .MACRO
                  .BYTE $0C48
                  .ENDM
PHE               .MACRO
                  .BYTE $4048
                  .ENDM
PHF               .MACRO
                  .BYTE $4448
                  .ENDM
PHG               .MACRO
                  .BYTE $4848
                  .ENDM
PHH               .MACRO
                  .BYTE $4C48
                  .ENDM
PHI               .MACRO
                  .BYTE $8048
                  .ENDM
PHJ               .MACRO
                  .BYTE $8448
                  .ENDM
PHK               .MACRO
                  .BYTE $8848
                  .ENDM
PHL               .MACRO
                  .BYTE $8C48
                  .ENDM
PHM               .MACRO
                  .BYTE $C048
                  .ENDM
PHN               .MACRO
                  .BYTE $C448
                  .ENDM
PHO               .MACRO
                  .BYTE $C848
                  .ENDM
PHQ               .MACRO
                  .BYTE $CC48
                  .ENDM
                  
PHW               .MACRO
                  .BYTE $004B
                  .ENDM

;PLA                    $0068
PLB               .MACRO
                  .BYTE $0168
                  .ENDM
PLC               .MACRO
                  .BYTE $0268
                  .ENDM
PLD               .MACRO
                  .BYTE $0368
                  .ENDM
PLE               .MACRO
                  .BYTE $1068
                  .ENDM
PLF               .MACRO
                  .BYTE $1168
                  .ENDM
PLG               .MACRO
                  .BYTE $1268
                  .ENDM
PLH               .MACRO
                  .BYTE $1368
                  .ENDM
PLI               .MACRO
                  .BYTE $2068
                  .ENDM
PLJ               .MACRO
                  .BYTE $2168
                  .ENDM
PLK               .MACRO
                  .BYTE $2268
                  .ENDM
PLL               .MACRO
                  .BYTE $2368
                  .ENDM
PLM               .MACRO
                  .BYTE $3068
                  .ENDM
PLN               .MACRO
                  .BYTE $3168
                  .ENDM
PLO               .MACRO
                  .BYTE $3268
                  .ENDM
PLQ               .MACRO
                  .BYTE $3368
                  .ENDM
                  
PLW               .MACRO
                  .BYTE $006B
                  .ENDM
                                                       
TYX               .MACRO
                  .BYTE $00AB
                  .ENDM
TXY               .MACRO
                  .BYTE $00CB
                  .ENDM
TYW               .MACRO
                  .BYTE $005F
                  .ENDM
TXW               .MACRO
                  .BYTE $003F
                  .ENDM
TWX               .MACRO
                  .BYTE $002F
                  .ENDM
TWY               .MACRO
                  .BYTE $004F
                  .ENDM
                                    
;TAY                    $00A8
TBY               .MACRO          ;Yreg <= Breg
                  .BYTE $04A8
                  .ENDM
TCY               .MACRO          ;Yreg <= Creg
                  .BYTE $08A8
                  .ENDM
TDY               .MACRO          ;Yreg <= Dreg
                  .BYTE $0CA8
                  .ENDM
TEY               .MACRO
                  .BYTE $40A8
                  .ENDM
TFY               .MACRO
                  .BYTE $44A8
                  .ENDM
TGY               .MACRO
                  .BYTE $48A8
                  .ENDM
THY               .MACRO
                  .BYTE $4CA8
                  .ENDM
TIY               .MACRO
                  .BYTE $80A8
                  .ENDM
TJY               .MACRO
                  .BYTE $84A8
                  .ENDM
TKY               .MACRO
                  .BYTE $88A8
                  .ENDM
TLY               .MACRO
                  .BYTE $8CA8
                  .ENDM
TMY               .MACRO
                  .BYTE $C0A8
                  .ENDM
TNY               .MACRO
                  .BYTE $C4A8
                  .ENDM
TOY               .MACRO
                  .BYTE $C8A8
                  .ENDM
TQY               .MACRO
                  .BYTE $CCA8
                  .ENDM
                  
;TYA                    $0098                
TYB               .MACRO          ;Breg <= Yreg
                  .BYTE $0198
                  .ENDM
TYC               .MACRO          ;Creg <= Yreg
                  .BYTE $0298
                  .ENDM
TYD               .MACRO          ;Dreg <= Yreg
                  .BYTE $0398
                  .ENDM
TYE               .MACRO
                  .BYTE $1098
                  .ENDM
TYF               .MACRO
                  .BYTE $1198
                  .ENDM
TYG               .MACRO
                  .BYTE $1298
                  .ENDM
TYH               .MACRO
                  .BYTE $1398
                  .ENDM
TYI               .MACRO
                  .BYTE $2098
                  .ENDM
TYJ               .MACRO
                  .BYTE $2198
                  .ENDM
TYK               .MACRO
                  .BYTE $2298
                  .ENDM
TYL               .MACRO
                  .BYTE $2398
                  .ENDM
TYM               .MACRO
                  .BYTE $3098
                  .ENDM
TYN               .MACRO
                  .BYTE $3198
                  .ENDM
TYO               .MACRO
                  .BYTE $3298
                  .ENDM
TYQ               .MACRO
                  .BYTE $3398
                  .ENDM
                  
;TAX                    $00AA                 
TBX               .MACRO
                  .BYTE $04AA
                  .ENDM
TCX               .MACRO
                  .BYTE $08AA
                  .ENDM
TDX               .MACRO
                  .BYTE $0CAA
                  .ENDM
TEX               .MACRO
                  .BYTE $40AA
                  .ENDM
TFX               .MACRO
                  .BYTE $44AA
                  .ENDM
TGX               .MACRO
                  .BYTE $48AA
                  .ENDM
THX               .MACRO
                  .BYTE $4CAA
                  .ENDM
TIX               .MACRO
                  .BYTE $80AA
                  .ENDM
TJX               .MACRO
                  .BYTE $84AA
                  .ENDM
TKX               .MACRO
                  .BYTE $88AA
                  .ENDM
TLX               .MACRO
                  .BYTE $8CAA
                  .ENDM
TMX               .MACRO
                  .BYTE $C0AA
                  .ENDM
TNX               .MACRO
                  .BYTE $C4AA
                  .ENDM
TOX               .MACRO
                  .BYTE $C8AA
                  .ENDM
TQX               .MACRO
                  .BYTE $CCAA
                  .ENDM

;TXA                    $008A
TXB               .MACRO
                  .BYTE $018A
                  .ENDM
TXC               .MACRO
                  .BYTE $028A
                  .ENDM
TXD               .MACRO
                  .BYTE $038A
                  .ENDM
TXE               .MACRO 
                  .BYTE $108A
                  .ENDM
TXF               .MACRO
                  .BYTE $118A
                  .ENDM
TXG               .MACRO
                  .BYTE $128A
                  .ENDM
TXH               .MACRO
                  .BYTE $138A
                  .ENDM
TXI               .MACRO
                  .BYTE $208A
                  .ENDM
TXJ               .MACRO
                  .BYTE $218A
                  .ENDM
TXK               .MACRO
                  .BYTE $228A
                  .ENDM
TXL               .MACRO
                  .BYTE $238A
                  .ENDM
TXM               .MACRO
                  .BYTE $308A
                  .ENDM
TXN               .MACRO
                  .BYTE $318A
                  .ENDM
TXO               .MACRO
                  .BYTE $328A
                  .ENDM
TXQ               .MACRO
                  .BYTE $338A
                  .ENDM
                  
TAW               .MACRO
                  .BYTE $001F
                  .ENDM
TBW               .MACRO
                  .BYTE $041F
                  .ENDM
TCW               .MACRO
                  .BYTE $081F
                  .ENDM
TDW               .MACRO
                  .BYTE $0C1F
                  .ENDM
TEW               .MACRO
                  .BYTE $401F
                  .ENDM
TFW               .MACRO
                  .BYTE $441F
                  .ENDM
TGW               .MACRO
                  .BYTE $481F
                  .ENDM
THW               .MACRO
                  .BYTE $4C1F
                  .ENDM
TIW               .MACRO
                  .BYTE $801F
                  .ENDM
TJW               .MACRO
                  .BYTE $841F
                  .ENDM
TKW               .MACRO
                  .BYTE $881F
                  .ENDM
TLW               .MACRO
                  .BYTE $8C1F
                  .ENDM
TMW               .MACRO
                  .BYTE $C01F
                  .ENDM
TNW               .MACRO
                  .BYTE $C41F
                  .ENDM
TOW               .MACRO
                  .BYTE $C81F
                  .ENDM
TQW               .MACRO
                  .BYTE $CC1F
                  .ENDM
                  
TWA               .MACRO
                  .BYTE $000F
                  .ENDM
TWB               .MACRO
                  .BYTE $010F
                  .ENDM
TWC               .MACRO
                  .BYTE $020F
                  .ENDM
TWD               .MACRO
                  .BYTE $030F
                  .ENDM
TWE               .MACRO
                  .BYTE $100F
                  .ENDM
TWF               .MACRO
                  .BYTE $110F
                  .ENDM
TWG               .MACRO
                  .BYTE $120F
                  .ENDM
TWH               .MACRO
                  .BYTE $130F
                  .ENDM
TWI               .MACRO
                  .BYTE $200F
                  .ENDM
TWJ               .MACRO
                  .BYTE $210F
                  .ENDM
TWK               .MACRO
                  .BYTE $220F
                  .ENDM
TWL               .MACRO
                  .BYTE $230F
                  .ENDM
TWM               .MACRO
                  .BYTE $300F
                  .ENDM
TWN               .MACRO
                  .BYTE $310F
                  .ENDM
TWO               .MACRO
                  .BYTE $320F
                  .ENDM
TWQ               .MACRO
                  .BYTE $330F
                  .ENDM                  
                  
                  
TAA               .MACRO
                  .BYTE $008B
                  .ENDM  
TAB               .MACRO          ;B Reg <= A Reg
                  .BYTE $018B
                  .ENDM
TAC               .MACRO          ;C Reg <= A Reg
                  .BYTE $028B
                  .ENDM
TAD               .MACRO          ;D Reg <= A Reg
                  .BYTE $038B
                  .ENDM
TAE               .MACRO
                  .BYTE $108B
                  .ENDM
TAF               .MACRO
                  .BYTE $118B
                  .ENDM
TAG               .MACRO
                  .BYTE $128B
                  .ENDM
TAH               .MACRO
                  .BYTE $138B
                  .ENDM
TAI               .MACRO
                  .BYTE $208B
                  .ENDM
TAJ               .MACRO
                  .BYTE $218B
                  .ENDM
TAK               .MACRO
                  .BYTE $228B
                  .ENDM
TAL               .MACRO
                  .BYTE $238B
                  .ENDM
TAM               .MACRO
                  .BYTE $308B
                  .ENDM
TAN               .MACRO
                  .BYTE $318B
                  .ENDM
TAO               .MACRO
                  .BYTE $328B
                  .ENDM
TAQ               .MACRO
                  .BYTE $338B
                  .ENDM

TBA               .MACRO
                  .BYTE $048B
                  .ENDM  
TBB               .MACRO          ;B Reg <= A Reg
                  .BYTE $058B
                  .ENDM
TBC               .MACRO          ;C Reg <= A Reg
                  .BYTE $068B
                  .ENDM
TBD               .MACRO          ;D Reg <= A Reg
                  .BYTE $078B
                  .ENDM
TBE               .MACRO
                  .BYTE $148B
                  .ENDM
TBF               .MACRO
                  .BYTE $158B
                  .ENDM
TBG               .MACRO
                  .BYTE $168B
                  .ENDM
TBH               .MACRO
                  .BYTE $178B
                  .ENDM
TBI               .MACRO
                  .BYTE $248B
                  .ENDM
TBJ               .MACRO
                  .BYTE $258B
                  .ENDM
TBK               .MACRO
                  .BYTE $268B
                  .ENDM
TBL               .MACRO
                  .BYTE $278B
                  .ENDM
TBM               .MACRO
                  .BYTE $348B
                  .ENDM
TBN               .MACRO
                  .BYTE $358B
                  .ENDM
TBO               .MACRO
                  .BYTE $368B
                  .ENDM
TBQ               .MACRO
                  .BYTE $378B
                  .ENDM
                  
TCA               .MACRO
                  .BYTE $088B
                  .ENDM  
TCB               .MACRO          ;B Reg <= A Reg
                  .BYTE $098B
                  .ENDM
TCC               .MACRO          ;C Reg <= A Reg
                  .BYTE $0A8B
                  .ENDM
TCD               .MACRO          ;D Reg <= A Reg
                  .BYTE $0B8B
                  .ENDM
TCE               .MACRO
                  .BYTE $188B
                  .ENDM
TCF               .MACRO
                  .BYTE $198B
                  .ENDM
TCG               .MACRO
                  .BYTE $1A8B
                  .ENDM
TCH               .MACRO
                  .BYTE $1B8B
                  .ENDM
TCI               .MACRO
                  .BYTE $288B
                  .ENDM
TCJ               .MACRO
                  .BYTE $298B
                  .ENDM
TCK               .MACRO
                  .BYTE $2A8B
                  .ENDM
TCL               .MACRO
                  .BYTE $2B8B
                  .ENDM
TCM               .MACRO
                  .BYTE $388B
                  .ENDM
TCN               .MACRO
                  .BYTE $398B
                  .ENDM
TCO               .MACRO
                  .BYTE $3A8B
                  .ENDM
TCQ               .MACRO
                  .BYTE $3B8B
                  .ENDM
                  
TDA               .MACRO
                  .BYTE $0C8B
                  .ENDM  
TDB               .MACRO          ;B Reg <= A Reg
                  .BYTE $0D8B
                  .ENDM
TDC               .MACRO          ;C Reg <= A Reg
                  .BYTE $0E8B
                  .ENDM
TDD               .MACRO          ;D Reg <= A Reg
                  .BYTE $0F8B
                  .ENDM
TDE               .MACRO
                  .BYTE $1C8B
                  .ENDM
TDF               .MACRO
                  .BYTE $1D8B
                  .ENDM
TDG               .MACRO
                  .BYTE $1E8B
                  .ENDM
TDH               .MACRO
                  .BYTE $1F8B
                  .ENDM
TDI               .MACRO
                  .BYTE $2C8B
                  .ENDM
TDJ               .MACRO
                  .BYTE $2D8B
                  .ENDM
TDK               .MACRO
                  .BYTE $2E8B
                  .ENDM
TDL               .MACRO
                  .BYTE $2F8B
                  .ENDM
TDM               .MACRO
                  .BYTE $3C8B
                  .ENDM
TDN               .MACRO
                  .BYTE $3D8B
                  .ENDM
TDO               .MACRO
                  .BYTE $3E8B
                  .ENDM
TDQ               .MACRO
                  .BYTE $3F8B
                  .ENDM
                  
TEA               .MACRO
                  .BYTE $408B
                  .ENDM  
TEB               .MACRO          ;B Reg <= A Reg
                  .BYTE $418B
                  .ENDM
TEC               .MACRO          ;C Reg <= A Reg
                  .BYTE $428B
                  .ENDM
TED               .MACRO          ;D Reg <= A Reg
                  .BYTE $438B
                  .ENDM
TEE               .MACRO
                  .BYTE $508B
                  .ENDM
TEF               .MACRO
                  .BYTE $518B
                  .ENDM
TEG               .MACRO
                  .BYTE $528B
                  .ENDM
TEH               .MACRO
                  .BYTE $538B
                  .ENDM
TEI               .MACRO
                  .BYTE $608B
                  .ENDM
TEJ               .MACRO
                  .BYTE $618B
                  .ENDM
TEK               .MACRO
                  .BYTE $628B
                  .ENDM
TEL               .MACRO
                  .BYTE $628B
                  .ENDM
TEM               .MACRO
                  .BYTE $708B
                  .ENDM
TEN               .MACRO
                  .BYTE $718B
                  .ENDM
TEO               .MACRO
                  .BYTE $728B
                  .ENDM
TEQ               .MACRO
                  .BYTE $738B
                  .ENDM
                  
TFA               .MACRO
                  .BYTE $448B
                  .ENDM  
TFB               .MACRO          ;B Reg <= A Reg
                  .BYTE $458B
                  .ENDM
TFC               .MACRO          ;C Reg <= A Reg
                  .BYTE $468B
                  .ENDM
TFD               .MACRO          ;D Reg <= A Reg
                  .BYTE $478B
                  .ENDM
TFE               .MACRO
                  .BYTE $548B
                  .ENDM
TFF               .MACRO
                  .BYTE $558B
                  .ENDM
TFG               .MACRO
                  .BYTE $568B
                  .ENDM
TFH               .MACRO
                  .BYTE $578B
                  .ENDM
TFI               .MACRO
                  .BYTE $648B
                  .ENDM
TFJ               .MACRO
                  .BYTE $658B
                  .ENDM
TFK               .MACRO
                  .BYTE $668B
                  .ENDM
TFL               .MACRO
                  .BYTE $678B
                  .ENDM
TFM               .MACRO
                  .BYTE $748B
                  .ENDM
TFN               .MACRO
                  .BYTE $758B
                  .ENDM
TFO               .MACRO
                  .BYTE $768B
                  .ENDM
TFQ               .MACRO
                  .BYTE $778B
                  .ENDM
                  
TGA               .MACRO
                  .BYTE $488B
                  .ENDM  
TGB               .MACRO          ;B Reg <= A Reg
                  .BYTE $498B
                  .ENDM
TGC               .MACRO          ;C Reg <= A Reg
                  .BYTE $4A8B
                  .ENDM
TGD               .MACRO          ;D Reg <= A Reg
                  .BYTE $4B8B
                  .ENDM
TGE               .MACRO
                  .BYTE $588B
                  .ENDM
TGF               .MACRO
                  .BYTE $598B
                  .ENDM
TGG               .MACRO
                  .BYTE $5A8B
                  .ENDM
TGH               .MACRO
                  .BYTE $5B8B
                  .ENDM
TGI               .MACRO
                  .BYTE $688B
                  .ENDM
TGJ               .MACRO
                  .BYTE $698B
                  .ENDM
TGK               .MACRO
                  .BYTE $6A8B
                  .ENDM
TGL               .MACRO
                  .BYTE $6B8B
                  .ENDM
TGM               .MACRO
                  .BYTE $788B
                  .ENDM
TGN               .MACRO
                  .BYTE $798B
                  .ENDM
TGO               .MACRO
                  .BYTE $7A8B
                  .ENDM
TGQ               .MACRO
                  .BYTE $7B8B
                  .ENDM
                  
THA               .MACRO
                  .BYTE $4C8B
                  .ENDM  
THB               .MACRO          ;B Reg <= A Reg
                  .BYTE $4D8B
                  .ENDM
THC               .MACRO          ;C Reg <= A Reg
                  .BYTE $4E8B
                  .ENDM
THD               .MACRO          ;D Reg <= A Reg
                  .BYTE $4F8B
                  .ENDM
THE               .MACRO
                  .BYTE $5C8B
                  .ENDM
THF               .MACRO
                  .BYTE $5D8B
                  .ENDM
THG               .MACRO
                  .BYTE $5E8B
                  .ENDM
THH               .MACRO
                  .BYTE $5F8B
                  .ENDM
THI               .MACRO
                  .BYTE $6C8B
                  .ENDM
THJ               .MACRO
                  .BYTE $6D8B
                  .ENDM
THK               .MACRO
                  .BYTE $6E8B
                  .ENDM
THL               .MACRO
                  .BYTE $6F8B
                  .ENDM
THM               .MACRO
                  .BYTE $7C8B
                  .ENDM
THN               .MACRO
                  .BYTE $7D8B
                  .ENDM
THO               .MACRO
                  .BYTE $7E8B
                  .ENDM
THQ               .MACRO
                  .BYTE $7BF8B
                  .ENDM
                  
TIA               .MACRO
                  .BYTE $808B
                  .ENDM  
TIB               .MACRO          ;B Reg <= A Reg
                  .BYTE $818B
                  .ENDM
TIC               .MACRO          ;C Reg <= A Reg
                  .BYTE $828B
                  .ENDM
TID               .MACRO          ;D Reg <= A Reg
                  .BYTE $838B
                  .ENDM
TIE               .MACRO
                  .BYTE $908B
                  .ENDM
TIF               .MACRO
                  .BYTE $918B
                  .ENDM
TIG               .MACRO
                  .BYTE $928B
                  .ENDM
TIH               .MACRO
                  .BYTE $938B
                  .ENDM
TII               .MACRO
                  .BYTE $A08B
                  .ENDM
TIJ               .MACRO
                  .BYTE $A18B
                  .ENDM
TIK               .MACRO
                  .BYTE $A28B
                  .ENDM
TIL               .MACRO
                  .BYTE $A38B
                  .ENDM
TIM               .MACRO
                  .BYTE $B08B
                  .ENDM
TIN               .MACRO
                  .BYTE $B18B
                  .ENDM
TIO               .MACRO
                  .BYTE $B28B
                  .ENDM
TIQ               .MACRO
                  .BYTE $B38B
                  .ENDM
                  
TJA               .MACRO
                  .BYTE $848B
                  .ENDM  
TJB               .MACRO          ;B Reg <= A Reg
                  .BYTE $858B
                  .ENDM
TJC               .MACRO          ;C Reg <= A Reg
                  .BYTE $868B
                  .ENDM
TJD               .MACRO          ;D Reg <= A Reg
                  .BYTE $878B
                  .ENDM
TJE               .MACRO
                  .BYTE $948B
                  .ENDM
TJF               .MACRO
                  .BYTE $958B
                  .ENDM
TJG               .MACRO
                  .BYTE $968B
                  .ENDM
TJH               .MACRO
                  .BYTE $978B
                  .ENDM
TJI               .MACRO
                  .BYTE $A48B
                  .ENDM
TJJ               .MACRO
                  .BYTE $A58B
                  .ENDM
TJK               .MACRO
                  .BYTE $A68B
                  .ENDM
TJL               .MACRO
                  .BYTE $A78B
                  .ENDM
TJM               .MACRO
                  .BYTE $B48B
                  .ENDM
TJN               .MACRO
                  .BYTE $B58B
                  .ENDM
TJO               .MACRO
                  .BYTE $B68B
                  .ENDM
TJQ               .MACRO
                  .BYTE $B78B
                  .ENDM
                  
TKA               .MACRO
                  .BYTE $888B
                  .ENDM  
TKB               .MACRO          ;B Reg <= A Reg
                  .BYTE $898B
                  .ENDM
TKC               .MACRO          ;C Reg <= A Reg
                  .BYTE $8A8B
                  .ENDM
TKD               .MACRO          ;D Reg <= A Reg
                  .BYTE $8B8B
                  .ENDM
TKE               .MACRO
                  .BYTE $988B
                  .ENDM
TKF               .MACRO
                  .BYTE $998B
                  .ENDM
TKG               .MACRO
                  .BYTE $9A8B
                  .ENDM
TKH               .MACRO
                  .BYTE $9B8B
                  .ENDM
TKI               .MACRO
                  .BYTE $A88B
                  .ENDM
TKJ               .MACRO
                  .BYTE $A98B
                  .ENDM
TKK               .MACRO
                  .BYTE $AA8B
                  .ENDM
TKL               .MACRO
                  .BYTE $AB8B
                  .ENDM
TKM               .MACRO
                  .BYTE $B88B
                  .ENDM
TKN               .MACRO
                  .BYTE $B98B
                  .ENDM
TKO               .MACRO
                  .BYTE $BA8B
                  .ENDM
TKQ               .MACRO
                  .BYTE $BB8B
                  .ENDM
                  
TLA               .MACRO
                  .BYTE $8C8B
                  .ENDM  
TLB               .MACRO          ;B Reg <= A Reg
                  .BYTE $8D8B
                  .ENDM
TLC               .MACRO          ;C Reg <= A Reg
                  .BYTE $8E8B
                  .ENDM
TLD               .MACRO          ;D Reg <= A Reg
                  .BYTE $8F8B
                  .ENDM
TLE               .MACRO
                  .BYTE $9C8B
                  .ENDM
TLF               .MACRO
                  .BYTE $9D8B
                  .ENDM
TLG               .MACRO
                  .BYTE $9E8B
                  .ENDM
TLH               .MACRO
                  .BYTE $9F8B
                  .ENDM
TLI               .MACRO
                  .BYTE $AC8B
                  .ENDM
TLJ               .MACRO
                  .BYTE $AD8B
                  .ENDM
TLK               .MACRO
                  .BYTE $AE8B
                  .ENDM
TLL               .MACRO
                  .BYTE $AF8B
                  .ENDM
TLM               .MACRO
                  .BYTE $BC8B
                  .ENDM
TLN               .MACRO
                  .BYTE $BD8B
                  .ENDM
TLO               .MACRO
                  .BYTE $BE8B
                  .ENDM
TLQ               .MACRO
                  .BYTE $BF8B
                  .ENDM
                  
TMA               .MACRO
                  .BYTE $C08B
                  .ENDM  
TMB               .MACRO          ;B Reg <= A Reg
                  .BYTE $C18B
                  .ENDM
TMC               .MACRO          ;C Reg <= A Reg
                  .BYTE $C28B
                  .ENDM
TMD               .MACRO          ;D Reg <= A Reg
                  .BYTE $C38B
                  .ENDM
TME               .MACRO
                  .BYTE $D08B
                  .ENDM
TMF               .MACRO
                  .BYTE $D18B
                  .ENDM
TMG               .MACRO
                  .BYTE $D28B
                  .ENDM
TMH               .MACRO
                  .BYTE $D38B
                  .ENDM
TMI               .MACRO
                  .BYTE $E08B
                  .ENDM
TMJ               .MACRO
                  .BYTE $E18B
                  .ENDM
TMK               .MACRO
                  .BYTE $E28B
                  .ENDM
TML               .MACRO
                  .BYTE $E38B
                  .ENDM
TMM               .MACRO
                  .BYTE $F08B
                  .ENDM
TMN               .MACRO
                  .BYTE $F18B
                  .ENDM
TMO               .MACRO
                  .BYTE $F28B
                  .ENDM
TMQ               .MACRO
                  .BYTE $F38B
                  .ENDM
                  
TNA               .MACRO
                  .BYTE $C48B
                  .ENDM  
TNB               .MACRO          ;B Reg <= A Reg
                  .BYTE $C58B
                  .ENDM
TNC               .MACRO          ;C Reg <= A Reg
                  .BYTE $C68B
                  .ENDM
TND               .MACRO          ;D Reg <= A Reg
                  .BYTE $C78B
                  .ENDM
TNE               .MACRO
                  .BYTE $D48B
                  .ENDM
TNF               .MACRO
                  .BYTE $D58B
                  .ENDM
TNG               .MACRO
                  .BYTE $D68B
                  .ENDM
TNH               .MACRO
                  .BYTE $D78B
                  .ENDM
TNI               .MACRO
                  .BYTE $E48B
                  .ENDM
TNJ               .MACRO
                  .BYTE $E58B
                  .ENDM
TNK               .MACRO
                  .BYTE $E68B
                  .ENDM
TNL               .MACRO
                  .BYTE $E78B
                  .ENDM
TNM               .MACRO
                  .BYTE $F48B
                  .ENDM
TNN               .MACRO
                  .BYTE $F58B
                  .ENDM
TNO               .MACRO
                  .BYTE $F68B
                  .ENDM
TNQ               .MACRO
                  .BYTE $F78B
                  .ENDM
                  
TOA               .MACRO
                  .BYTE $C88B
                  .ENDM  
TOB               .MACRO          ;B Reg <= A Reg
                  .BYTE $C98B
                  .ENDM
TOC               .MACRO          ;C Reg <= A Reg
                  .BYTE $CA8B
                  .ENDM
TOD               .MACRO          ;D Reg <= A Reg
                  .BYTE $CB8B
                  .ENDM
TOE               .MACRO
                  .BYTE $D88B
                  .ENDM
TOF               .MACRO
                  .BYTE $D98B
                  .ENDM
TOG               .MACRO
                  .BYTE $DA8B
                  .ENDM
TOH               .MACRO
                  .BYTE $DB8B
                  .ENDM
TOI               .MACRO
                  .BYTE $E88B
                  .ENDM
TOJ               .MACRO
                  .BYTE $E98B
                  .ENDM
TOK               .MACRO
                  .BYTE $EA8B
                  .ENDM
TOL               .MACRO
                  .BYTE $EB8B
                  .ENDM
TOM               .MACRO
                  .BYTE $F88B
                  .ENDM
TON               .MACRO
                  .BYTE $F98B
                  .ENDM
TOO               .MACRO
                  .BYTE $FA8B
                  .ENDM
TOQ               .MACRO
                  .BYTE $FB8B
                  .ENDM
                  
TQA               .MACRO
                  .BYTE $CC8B
                  .ENDM  
TQB               .MACRO          ;B Reg <= A Reg
                  .BYTE $CD8B
                  .ENDM
TQC               .MACRO          ;C Reg <= A Reg
                  .BYTE $CE8B
                  .ENDM
TQD               .MACRO          ;D Reg <= A Reg
                  .BYTE $CF8B
                  .ENDM
TQE               .MACRO
                  .BYTE $DC8B
                  .ENDM
TQF               .MACRO
                  .BYTE $DD8B
                  .ENDM
TQG               .MACRO
                  .BYTE $DE8B
                  .ENDM
TQH               .MACRO
                  .BYTE $DF8B
                  .ENDM
TQI               .MACRO
                  .BYTE $EC8B
                  .ENDM
TQJ               .MACRO
                  .BYTE $ED8B
                  .ENDM
TQK               .MACRO
                  .BYTE $EE8B
                  .ENDM
TQL               .MACRO
                  .BYTE $EF8B
                  .ENDM
TQM               .MACRO
                  .BYTE $FC8B
                  .ENDM
TQN               .MACRO
                  .BYTE $FD8B
                  .ENDM
TQO               .MACRO
                  .BYTE $FE8B
                  .ENDM
TQQ               .MACRO
                  .BYTE $FF8B
                  .ENDM                                                                                                                                                                                                      
                  
;ADC #$xxxx             $0069
ADCAopBi          .MACRO param          
                  .BYTE $0169,  param
                  .ENDM
ADCAopCi          .MACRO param
                  .BYTE $0269,  param
                  .ENDM
ADCAopDi          .MACRO param
                  .BYTE $0369,  param
                  .ENDM
ADCAopEi          .MACRO param          
                  .BYTE $1069,  param
                  .ENDM
ADCAopFi          .MACRO param
                  .BYTE $1169,  param
                  .ENDM
ADCAopGi          .MACRO param
                  .BYTE $1269,  param
                  .ENDM                  
ADCAopHi          .MACRO param          
                  .BYTE $1369,  param
                  .ENDM
ADCAopIi          .MACRO param
                  .BYTE $2069,  param
                  .ENDM
ADCAopJi          .MACRO param
                  .BYTE $2169,  param
                  .ENDM
ADCAopKi          .MACRO param          
                  .BYTE $2269,  param
                  .ENDM
ADCAopLi          .MACRO param
                  .BYTE $2369,  param
                  .ENDM
ADCAopMi          .MACRO param
                  .BYTE $3069,  param
                  .ENDM                  
ADCAopNi          .MACRO param          
                  .BYTE $3169,  param
                  .ENDM
ADCAopOi          .MACRO param
                  .BYTE $3269,  param
                  .ENDM
ADCAopQi          .MACRO param
                  .BYTE $3369,  param
                  .ENDM
                                    
ADCBopAi          .MACRO param
                  .BYTE $0469,  param
                  .ENDM                
ADCBopBi          .MACRO param          
                  .BYTE $0569,  param
                  .ENDM
ADCBopCi          .MACRO param
                  .BYTE $0669,  param
                  .ENDM
ADCBopDi          .MACRO param
                  .BYTE $0769,  param
                  .ENDM
ADCBopEi          .MACRO param          
                  .BYTE $1469,  param
                  .ENDM
ADCBopFi          .MACRO param
                  .BYTE $1569,  param
                  .ENDM
ADCBopGi          .MACRO param
                  .BYTE $1669,  param
                  .ENDM                  
ADCBopHi          .MACRO param          
                  .BYTE $1769,  param
                  .ENDM
ADCBopIi          .MACRO param
                  .BYTE $2469,  param
                  .ENDM
ADCBopJi          .MACRO param
                  .BYTE $2569,  param
                  .ENDM
ADCBopKi          .MACRO param          
                  .BYTE $2669,  param
                  .ENDM
ADCBopLi          .MACRO param
                  .BYTE $2769,  param
                  .ENDM
ADCBopMi          .MACRO param
                  .BYTE $3069,  param
                  .ENDM                  
ADCBopNi          .MACRO param          
                  .BYTE $3169,  param
                  .ENDM
ADCBopOi          .MACRO param
                  .BYTE $3269,  param
                  .ENDM
ADCBopQi          .MACRO param
                  .BYTE $3369,  param
                  .ENDM
                                    
ADCCopAi          .MACRO param
                  .BYTE $0869,  param
                  .ENDM                
ADCCopBi          .MACRO param          
                  .BYTE $0969,  param
                  .ENDM
ADCCopCi          .MACRO param
                  .BYTE $0A69,  param
                  .ENDM
ADCCopDi          .MACRO param
                  .BYTE $0B69,  param
                  .ENDM
ADCCopEi          .MACRO param          
                  .BYTE $1869,  param
                  .ENDM
ADCCopFi          .MACRO param
                  .BYTE $1969,  param
                  .ENDM
ADCCopGi          .MACRO param
                  .BYTE $1A69,  param
                  .ENDM                  
ADCCopHi          .MACRO param          
                  .BYTE $1B69,  param
                  .ENDM
ADCCopIi          .MACRO param
                  .BYTE $2869,  param
                  .ENDM
ADCCopJi          .MACRO param
                  .BYTE $2969,  param
                  .ENDM
ADCCopKi          .MACRO param          
                  .BYTE $2A69,  param
                  .ENDM
ADCCopLi          .MACRO param
                  .BYTE $2B69,  param
                  .ENDM
ADCCopMi          .MACRO param
                  .BYTE $3869,  param
                  .ENDM                  
ADCCopNi          .MACRO param          
                  .BYTE $3969,  param
                  .ENDM
ADCCopOi          .MACRO param
                  .BYTE $3A69,  param
                  .ENDM
ADCCopQi          .MACRO param
                  .BYTE $3B69,  param
                  .ENDM

ADCDopAi          .MACRO param
                  .BYTE $0C69,  param
                  .ENDM                
ADCDopBi          .MACRO param          
                  .BYTE $0D69,  param
                  .ENDM
ADCDopCi          .MACRO param
                  .BYTE $0E69,  param
                  .ENDM
ADCDopDi          .MACRO param
                  .BYTE $0F69,  param
                  .ENDM
ADCDopEi          .MACRO param          
                  .BYTE $1C69,  param
                  .ENDM
ADCDopFi          .MACRO param
                  .BYTE $1D69,  param
                  .ENDM
ADCDopGi          .MACRO param
                  .BYTE $1E69,  param
                  .ENDM                  
ADCDopHi          .MACRO param          
                  .BYTE $1F69,  param
                  .ENDM
ADCDopIi          .MACRO param
                  .BYTE $2C69,  param
                  .ENDM
ADCDopJi          .MACRO param
                  .BYTE $2D69,  param
                  .ENDM
ADCDopKi          .MACRO param          
                  .BYTE $2E69,  param
                  .ENDM
ADCDopLi          .MACRO param
                  .BYTE $2F69,  param
                  .ENDM
ADCDopMi          .MACRO param
                  .BYTE $3C69,  param
                  .ENDM                  
ADCDopNi          .MACRO param          
                  .BYTE $3D69,  param
                  .ENDM
ADCDopOi          .MACRO param
                  .BYTE $3E69,  param
                  .ENDM
ADCDopQi          .MACRO param
                  .BYTE $3F69,  param
                  .ENDM                  

ADCEopAi          .MACRO param
                  .BYTE $4069,  param
                  .ENDM                
ADCEopBi          .MACRO param          
                  .BYTE $4169,  param
                  .ENDM
ADCEopCi          .MACRO param
                  .BYTE $4269,  param
                  .ENDM
ADCEopDi          .MACRO param
                  .BYTE $4369,  param
                  .ENDM
ADCEopEi          .MACRO param          
                  .BYTE $5069,  param
                  .ENDM
ADCEopFi          .MACRO param
                  .BYTE $5169,  param
                  .ENDM
ADCEopGi          .MACRO param
                  .BYTE $5269,  param
                  .ENDM                  
ADCEopHi          .MACRO param          
                  .BYTE $5369,  param
                  .ENDM
ADCEopIi          .MACRO param
                  .BYTE $6069,  param
                  .ENDM
ADCEopJi          .MACRO param
                  .BYTE $6169,  param
                  .ENDM
ADCEopKi          .MACRO param          
                  .BYTE $6269,  param
                  .ENDM
ADCEopLi          .MACRO param
                  .BYTE $6369,  param
                  .ENDM
ADCEopMi          .MACRO param
                  .BYTE $7069,  param
                  .ENDM                  
ADCEopNi          .MACRO param          
                  .BYTE $7169,  param
                  .ENDM
ADCEopOi          .MACRO param
                  .BYTE $7269,  param
                  .ENDM
ADCEopQi          .MACRO param
                  .BYTE $7369,  param
                  .ENDM
                  
ADCFopAi          .MACRO param
                  .BYTE $4469,  param
                  .ENDM                
ADCFopBi          .MACRO param          
                  .BYTE $4569,  param
                  .ENDM
ADCFopCi          .MACRO param
                  .BYTE $4669,  param
                  .ENDM
ADCFopDi          .MACRO param
                  .BYTE $4769,  param
                  .ENDM
ADCFopEi          .MACRO param          
                  .BYTE $5469,  param
                  .ENDM
ADCFopFi          .MACRO param
                  .BYTE $5569,  param
                  .ENDM
ADCFopGi          .MACRO param
                  .BYTE $5669,  param
                  .ENDM                  
ADCFopHi          .MACRO param          
                  .BYTE $5769,  param
                  .ENDM
ADCFopIi          .MACRO param
                  .BYTE $6469,  param
                  .ENDM
ADCFopJi          .MACRO param
                  .BYTE $6569,  param
                  .ENDM
ADCFopKi          .MACRO param          
                  .BYTE $6669,  param
                  .ENDM
ADCFopLi          .MACRO param
                  .BYTE $6769,  param
                  .ENDM
ADCFopMi          .MACRO param
                  .BYTE $7469,  param
                  .ENDM                  
ADCFopNi          .MACRO param          
                  .BYTE $7569,  param
                  .ENDM
ADCFopOi          .MACRO param
                  .BYTE $7669,  param
                  .ENDM
ADCFopQi          .MACRO param
                  .BYTE $7769,  param
                  .ENDM                  
                           
ADCGopAi          .MACRO param
                  .BYTE $4869,  param
                  .ENDM                
ADCGopBi          .MACRO param          
                  .BYTE $4969,  param
                  .ENDM
ADCGopCi          .MACRO param
                  .BYTE $4A69,  param
                  .ENDM
ADCGopDi          .MACRO param
                  .BYTE $4B69,  param
                  .ENDM
ADCGopEi          .MACRO param          
                  .BYTE $5869,  param
                  .ENDM
ADCGopFi          .MACRO param
                  .BYTE $5969,  param
                  .ENDM
ADCGopGi          .MACRO param
                  .BYTE $5A69,  param
                  .ENDM                  
ADCGopHi          .MACRO param          
                  .BYTE $5B69,  param
                  .ENDM
ADCGopIi          .MACRO param
                  .BYTE $6869,  param
                  .ENDM
ADCGopJi          .MACRO param
                  .BYTE $6969,  param
                  .ENDM
ADCGopKi          .MACRO param          
                  .BYTE $6A69,  param
                  .ENDM
ADCGopLi          .MACRO param
                  .BYTE $6B69,  param
                  .ENDM
ADCGopMi          .MACRO param
                  .BYTE $7869,  param
                  .ENDM                  
ADCGopNi          .MACRO param          
                  .BYTE $7969,  param
                  .ENDM
ADCGopOi          .MACRO param
                  .BYTE $7A69,  param
                  .ENDM
ADCGopQi          .MACRO param
                  .BYTE $7B69,  param
                  .ENDM
                  
ADCHopAi          .MACRO param
                  .BYTE $4C69,  param
                  .ENDM                
ADCHopBi          .MACRO param          
                  .BYTE $4D69,  param
                  .ENDM
ADCHopCi          .MACRO param
                  .BYTE $4E69,  param
                  .ENDM
ADCHopDi          .MACRO param
                  .BYTE $4F69,  param
                  .ENDM
ADCHopEi          .MACRO param          
                  .BYTE $5C69,  param
                  .ENDM
ADCHopFi          .MACRO param
                  .BYTE $5D69,  param
                  .ENDM
ADCHopGi          .MACRO param
                  .BYTE $5E69,  param
                  .ENDM                  
ADCHopHi          .MACRO param          
                  .BYTE $5F69,  param
                  .ENDM
ADCHopIi          .MACRO param
                  .BYTE $6C69,  param
                  .ENDM
ADCHopJi          .MACRO param
                  .BYTE $6D69,  param
                  .ENDM
ADCHopKi          .MACRO param          
                  .BYTE $6E69,  param
                  .ENDM
ADCHopLi          .MACRO param
                  .BYTE $6F69,  param
                  .ENDM
ADCHopMi          .MACRO param
                  .BYTE $7C69,  param
                  .ENDM                  
ADCHopNi          .MACRO param          
                  .BYTE $7D69,  param
                  .ENDM
ADCHopOi          .MACRO param
                  .BYTE $7E69,  param
                  .ENDM
ADCHopQi          .MACRO param
                  .BYTE $7F69,  param
                  .ENDM
                  
ADCIopAi          .MACRO param
                  .BYTE $8069,  param
                  .ENDM                
ADCIopBi          .MACRO param          
                  .BYTE $8169,  param
                  .ENDM
ADCIopCi          .MACRO param
                  .BYTE $8269,  param
                  .ENDM
ADCIopDi          .MACRO param
                  .BYTE $8369,  param
                  .ENDM
ADCIopEi          .MACRO param          
                  .BYTE $9069,  param
                  .ENDM
ADCIopFi          .MACRO param
                  .BYTE $9169,  param
                  .ENDM
ADCIopGi          .MACRO param
                  .BYTE $9269,  param
                  .ENDM                  
ADCIopHi          .MACRO param          
                  .BYTE $9369,  param
                  .ENDM
ADCIopIi          .MACRO param
                  .BYTE $A069,  param
                  .ENDM
ADCIopJi          .MACRO param
                  .BYTE $A169,  param
                  .ENDM
ADCIopKi          .MACRO param          
                  .BYTE $A269,  param
                  .ENDM
ADCIopLi          .MACRO param
                  .BYTE $A369,  param
                  .ENDM
ADCIopMi          .MACRO param
                  .BYTE $B069,  param
                  .ENDM                  
ADCIopNi          .MACRO param          
                  .BYTE $B169,  param
                  .ENDM
ADCIopOi          .MACRO param
                  .BYTE $B269,  param
                  .ENDM
ADCIopQi          .MACRO param
                  .BYTE $B369,  param
                  .ENDM
                  
ADCJopAi          .MACRO param
                  .BYTE $8469,  param
                  .ENDM                
ADCJopBi          .MACRO param          
                  .BYTE $8569,  param
                  .ENDM
ADCJopCi          .MACRO param
                  .BYTE $8669,  param
                  .ENDM
ADCJopDi          .MACRO param
                  .BYTE $8769,  param
                  .ENDM
ADCJopEi          .MACRO param          
                  .BYTE $9469,  param
                  .ENDM
ADCJopFi          .MACRO param
                  .BYTE $9569,  param
                  .ENDM
ADCJopGi          .MACRO param
                  .BYTE $9669,  param
                  .ENDM                  
ADCJopHi          .MACRO param          
                  .BYTE $9769,  param
                  .ENDM
ADCJopIi          .MACRO param
                  .BYTE $A469,  param
                  .ENDM
ADCJopJi          .MACRO param
                  .BYTE $A569,  param
                  .ENDM
ADCJopKi          .MACRO param          
                  .BYTE $A669,  param
                  .ENDM
ADCJopLi          .MACRO param
                  .BYTE $A769,  param
                  .ENDM
ADCJopMi          .MACRO param
                  .BYTE $B469,  param
                  .ENDM                  
ADCJopNi          .MACRO param          
                  .BYTE $B569,  param
                  .ENDM
ADCJopOi          .MACRO param
                  .BYTE $B669,  param
                  .ENDM
ADCJopQi          .MACRO param
                  .BYTE $B769,  param
                  .ENDM
                  
ADCKopAi          .MACRO param
                  .BYTE $8869,  param
                  .ENDM                
ADCKopBi          .MACRO param          
                  .BYTE $8969,  param
                  .ENDM
ADCKopCi          .MACRO param
                  .BYTE $8A69,  param
                  .ENDM
ADCKopDi          .MACRO param
                  .BYTE $8B69,  param
                  .ENDM
ADCKopEi          .MACRO param          
                  .BYTE $9869,  param
                  .ENDM
ADCKopFi          .MACRO param
                  .BYTE $9969,  param
                  .ENDM
ADCKopGi          .MACRO param
                  .BYTE $9A69,  param
                  .ENDM                  
ADCKopHi          .MACRO param          
                  .BYTE $9B69,  param
                  .ENDM
ADCKopIi          .MACRO param
                  .BYTE $A869,  param
                  .ENDM
ADCKopJi          .MACRO param
                  .BYTE $A969,  param
                  .ENDM
ADCKopKi          .MACRO param          
                  .BYTE $AA69,  param
                  .ENDM
ADCKopLi          .MACRO param
                  .BYTE $AB69,  param
                  .ENDM
ADCKopMi          .MACRO param
                  .BYTE $B869,  param
                  .ENDM                  
ADCKopNi          .MACRO param          
                  .BYTE $B969,  param
                  .ENDM
ADCKopOi          .MACRO param
                  .BYTE $BA69,  param
                  .ENDM
ADCKopQi          .MACRO param
                  .BYTE $BB69,  param
                  .ENDM
                  
ADCLopAi          .MACRO param
                  .BYTE $8C69,  param
                  .ENDM                
ADCLopBi          .MACRO param          
                  .BYTE $8D69,  param
                  .ENDM
ADCLopCi          .MACRO param
                  .BYTE $8E69,  param
                  .ENDM
ADCLopDi          .MACRO param
                  .BYTE $8F69,  param
                  .ENDM
ADCLopEi          .MACRO param          
                  .BYTE $9C69,  param
                  .ENDM
ADCLopFi          .MACRO param
                  .BYTE $9D69,  param
                  .ENDM
ADCLopGi          .MACRO param
                  .BYTE $9E69,  param
                  .ENDM                  
ADCLopHi          .MACRO param          
                  .BYTE $9F69,  param
                  .ENDM
ADCLopIi          .MACRO param
                  .BYTE $AC69,  param
                  .ENDM
ADCLopJi          .MACRO param
                  .BYTE $AD69,  param
                  .ENDM
ADCLopKi          .MACRO param          
                  .BYTE $AE69,  param
                  .ENDM
ADCLopLi          .MACRO param
                  .BYTE $AF69,  param
                  .ENDM
ADCLopMi          .MACRO param
                  .BYTE $BC69,  param
                  .ENDM                  
ADCLopNi          .MACRO param          
                  .BYTE $BD69,  param
                  .ENDM
ADCLopOi          .MACRO param
                  .BYTE $BE69,  param
                  .ENDM
ADCLopQi          .MACRO param
                  .BYTE $BF69,  param
                  .ENDM
                  
ADCMopAi          .MACRO param
                  .BYTE $C069,  param
                  .ENDM                
ADCMopBi          .MACRO param          
                  .BYTE $C169,  param
                  .ENDM
ADCMopCi          .MACRO param
                  .BYTE $C269,  param
                  .ENDM
ADCMopDi          .MACRO param
                  .BYTE $C369,  param
                  .ENDM
ADCMopEi          .MACRO param          
                  .BYTE $D069,  param
                  .ENDM
ADCMopFi          .MACRO param
                  .BYTE $D169,  param
                  .ENDM
ADCMopGi          .MACRO param
                  .BYTE $D269,  param
                  .ENDM                  
ADCMopHi          .MACRO param          
                  .BYTE $D369,  param
                  .ENDM
ADCMopIi          .MACRO param
                  .BYTE $E069,  param
                  .ENDM
ADCMopJi          .MACRO param
                  .BYTE $E169,  param
                  .ENDM
ADCMopKi          .MACRO param          
                  .BYTE $E269,  param
                  .ENDM
ADCMopLi          .MACRO param
                  .BYTE $E369,  param
                  .ENDM
ADCMopMi          .MACRO param
                  .BYTE $F069,  param
                  .ENDM                  
ADCMopNi          .MACRO param          
                  .BYTE $F169,  param
                  .ENDM
ADCMopOi          .MACRO param
                  .BYTE $F269,  param
                  .ENDM
ADCMopQi          .MACRO param
                  .BYTE $F369,  param
                  .ENDM
                  
ADCNopAi          .MACRO param
                  .BYTE $C469,  param
                  .ENDM                
ADCNopBi          .MACRO param          
                  .BYTE $C569,  param
                  .ENDM
ADCNopCi          .MACRO param
                  .BYTE $C669,  param
                  .ENDM
ADCNopDi          .MACRO param
                  .BYTE $C769,  param
                  .ENDM
ADCNopEi          .MACRO param          
                  .BYTE $D469,  param
                  .ENDM
ADCNopFi          .MACRO param
                  .BYTE $D569,  param
                  .ENDM
ADCNopGi          .MACRO param
                  .BYTE $D669,  param
                  .ENDM                  
ADCNopHi          .MACRO param          
                  .BYTE $D769,  param
                  .ENDM
ADCNopIi          .MACRO param
                  .BYTE $E469,  param
                  .ENDM
ADCNopJi          .MACRO param
                  .BYTE $E569,  param
                  .ENDM
ADCNopKi          .MACRO param          
                  .BYTE $E669,  param
                  .ENDM
ADCNopLi          .MACRO param
                  .BYTE $E769,  param
                  .ENDM
ADCNopMi          .MACRO param
                  .BYTE $F469,  param
                  .ENDM                  
ADCNopNi          .MACRO param          
                  .BYTE $F569,  param
                  .ENDM
ADCNopOi          .MACRO param
                  .BYTE $F669,  param
                  .ENDM
ADCNopQi          .MACRO param
                  .BYTE $F769,  param
                  .ENDM
            
ADCOopAi          .MACRO param
                  .BYTE $C869,  param
                  .ENDM                
ADCOopBi          .MACRO param          
                  .BYTE $C969,  param
                  .ENDM
ADCOopCi          .MACRO param
                  .BYTE $CA69,  param
                  .ENDM
ADCOopDi          .MACRO param
                  .BYTE $CB69,  param
                  .ENDM
ADCOopEi          .MACRO param          
                  .BYTE $D869,  param
                  .ENDM
ADCOopFi          .MACRO param
                  .BYTE $D969,  param
                  .ENDM
ADCOopGi          .MACRO param
                  .BYTE $DA69,  param
                  .ENDM                  
ADCOopHi          .MACRO param          
                  .BYTE $DB69,  param
                  .ENDM
ADCOopIi          .MACRO param
                  .BYTE $E869,  param
                  .ENDM
ADCOopJi          .MACRO param
                  .BYTE $E969,  param
                  .ENDM
ADCOopKi          .MACRO param          
                  .BYTE $EA69,  param
                  .ENDM
ADCOopLi          .MACRO param
                  .BYTE $EB69,  param
                  .ENDM
ADCOopMi          .MACRO param
                  .BYTE $F869,  param
                  .ENDM                  
ADCOopNi          .MACRO param          
                  .BYTE $F969,  param
                  .ENDM
ADCOopOi          .MACRO param
                  .BYTE $FA69,  param
                  .ENDM
ADCOopQi          .MACRO param
                  .BYTE $FB69,  param
                  .ENDM
                  
ADCQopAi          .MACRO param
                  .BYTE $CC69,  param
                  .ENDM                
ADCQopBi          .MACRO param          
                  .BYTE $CD69,  param
                  .ENDM
ADCQopCi          .MACRO param
                  .BYTE $CE69,  param
                  .ENDM
ADCQopDi          .MACRO param
                  .BYTE $CF69,  param
                  .ENDM
ADCQopEi          .MACRO param          
                  .BYTE $DC69,  param
                  .ENDM
ADCQopFi          .MACRO param
                  .BYTE $DD69,  param
                  .ENDM
ADCQopGi          .MACRO param
                  .BYTE $DE69,  param
                  .ENDM                  
ADCQopHi          .MACRO param          
                  .BYTE $DF69,  param
                  .ENDM
ADCQopIi          .MACRO param
                  .BYTE $EC69,  param
                  .ENDM
ADCQopJi          .MACRO param
                  .BYTE $ED69,  param
                  .ENDM
ADCQopKi          .MACRO param          
                  .BYTE $EE69,  param
                  .ENDM
ADCQopLi          .MACRO param
                  .BYTE $EF69,  param
                  .ENDM
ADCQopMi          .MACRO param
                  .BYTE $FC69,  param
                  .ENDM                  
ADCQopNi          .MACRO param          
                  .BYTE $FD69,  param
                  .ENDM
ADCQopOi          .MACRO param
                  .BYTE $FE69,  param
                  .ENDM
ADCQopQi          .MACRO param
                  .BYTE $FF69,  param
                  .ENDM

;SBC #$xxxx             $00E9
SBCAopBi          .MACRO param          
                  .BYTE $01E9,  param
                  .ENDM
SBCAopCi          .MACRO param
                  .BYTE $02E9,  param
                  .ENDM
SBCAopDi          .MACRO param
                  .BYTE $03E9,  param
                  .ENDM
SBCAopEi          .MACRO param          
                  .BYTE $10E9,  param
                  .ENDM
SBCAopFi          .MACRO param
                  .BYTE $11E9,  param
                  .ENDM
SBCAopGi          .MACRO param
                  .BYTE $12E9,  param
                  .ENDM                  
SBCAopHi          .MACRO param          
                  .BYTE $13E9,  param
                  .ENDM
SBCAopIi          .MACRO param
                  .BYTE $20E9,  param
                  .ENDM
SBCAopJi          .MACRO param
                  .BYTE $21E9,  param
                  .ENDM
SBCAopKi          .MACRO param          
                  .BYTE $22E9,  param
                  .ENDM
SBCAopLi          .MACRO param
                  .BYTE $23E9,  param
                  .ENDM
SBCAopMi          .MACRO param
                  .BYTE $30E9,  param
                  .ENDM                  
SBCAopNi          .MACRO param          
                  .BYTE $31E9,  param
                  .ENDM
SBCAopOi          .MACRO param
                  .BYTE $32E9,  param
                  .ENDM
SBCAopQi          .MACRO param
                  .BYTE $33E9,  param
                  .ENDM
                                    
SBCBopAi          .MACRO param
                  .BYTE $04E9,  param
                  .ENDM                
SBCBopBi          .MACRO param          
                  .BYTE $05E9,  param
                  .ENDM
SBCBopCi          .MACRO param
                  .BYTE $06E9,  param
                  .ENDM
SBCBopDi          .MACRO param
                  .BYTE $07E9,  param
                  .ENDM
SBCBopEi          .MACRO param          
                  .BYTE $14E9,  param
                  .ENDM
SBCBopFi          .MACRO param
                  .BYTE $15E9,  param
                  .ENDM
SBCBopGi          .MACRO param
                  .BYTE $16E9,  param
                  .ENDM                  
SBCBopHi          .MACRO param          
                  .BYTE $17E9,  param
                  .ENDM
SBCBopIi          .MACRO param
                  .BYTE $24E9,  param
                  .ENDM
SBCBopJi          .MACRO param
                  .BYTE $25E9,  param
                  .ENDM
SBCBopKi          .MACRO param          
                  .BYTE $26E9,  param
                  .ENDM
SBCBopLi          .MACRO param
                  .BYTE $27E9,  param
                  .ENDM
SBCBopMi          .MACRO param
                  .BYTE $30E9,  param
                  .ENDM                  
SBCBopNi          .MACRO param          
                  .BYTE $31E9,  param
                  .ENDM
SBCBopOi          .MACRO param
                  .BYTE $32E9,  param
                  .ENDM
SBCBopQi          .MACRO param
                  .BYTE $33E9,  param
                  .ENDM
                                    
SBCCopAi          .MACRO param
                  .BYTE $08E9,  param
                  .ENDM                
SBCCopBi          .MACRO param          
                  .BYTE $09E9,  param
                  .ENDM
SBCCopCi          .MACRO param
                  .BYTE $0AE9,  param
                  .ENDM
SBCCopDi          .MACRO param
                  .BYTE $0BE9,  param
                  .ENDM
SBCCopEi          .MACRO param          
                  .BYTE $18E9,  param
                  .ENDM
SBCCopFi          .MACRO param
                  .BYTE $19E9,  param
                  .ENDM
SBCCopGi          .MACRO param
                  .BYTE $1AE9,  param
                  .ENDM                  
SBCCopHi          .MACRO param          
                  .BYTE $1BE9,  param
                  .ENDM
SBCCopIi          .MACRO param
                  .BYTE $28E9,  param
                  .ENDM
SBCCopJi          .MACRO param
                  .BYTE $29E9,  param
                  .ENDM
SBCCopKi          .MACRO param          
                  .BYTE $2AE9,  param
                  .ENDM
SBCCopLi          .MACRO param
                  .BYTE $2BE9,  param
                  .ENDM
SBCCopMi          .MACRO param
                  .BYTE $38E9,  param
                  .ENDM                  
SBCCopNi          .MACRO param          
                  .BYTE $39E9,  param
                  .ENDM
SBCCopOi          .MACRO param
                  .BYTE $3AE9,  param
                  .ENDM
SBCCopQi          .MACRO param
                  .BYTE $3BE9,  param
                  .ENDM

SBCDopAi          .MACRO param
                  .BYTE $0CE9,  param
                  .ENDM                
SBCDopBi          .MACRO param          
                  .BYTE $0DE9,  param
                  .ENDM
SBCDopCi          .MACRO param
                  .BYTE $0EE9,  param
                  .ENDM
SBCDopDi          .MACRO param
                  .BYTE $0FE9,  param
                  .ENDM
SBCDopEi          .MACRO param          
                  .BYTE $1CE9,  param
                  .ENDM
SBCDopFi          .MACRO param
                  .BYTE $1DE9,  param
                  .ENDM
SBCDopGi          .MACRO param
                  .BYTE $1EE9,  param
                  .ENDM                  
SBCDopHi          .MACRO param          
                  .BYTE $1FE9,  param
                  .ENDM
SBCDopIi          .MACRO param
                  .BYTE $2CE9,  param
                  .ENDM
SBCDopJi          .MACRO param
                  .BYTE $2DE9,  param
                  .ENDM
SBCDopKi          .MACRO param          
                  .BYTE $2EE9,  param
                  .ENDM
SBCDopLi          .MACRO param
                  .BYTE $2FE9,  param
                  .ENDM
SBCDopMi          .MACRO param
                  .BYTE $3CE9,  param
                  .ENDM                  
SBCDopNi          .MACRO param          
                  .BYTE $3DE9,  param
                  .ENDM
SBCDopOi          .MACRO param
                  .BYTE $3EE9,  param
                  .ENDM
SBCDopQi          .MACRO param
                  .BYTE $3FE9,  param
                  .ENDM                  

SBCEopAi          .MACRO param
                  .BYTE $40E9,  param
                  .ENDM                
SBCEopBi          .MACRO param          
                  .BYTE $41E9,  param
                  .ENDM
SBCEopCi          .MACRO param
                  .BYTE $42E9,  param
                  .ENDM
SBCEopDi          .MACRO param
                  .BYTE $43E9,  param
                  .ENDM
SBCEopEi          .MACRO param          
                  .BYTE $50E9,  param
                  .ENDM
SBCEopFi          .MACRO param
                  .BYTE $51E9,  param
                  .ENDM
SBCEopGi          .MACRO param
                  .BYTE $52E9,  param
                  .ENDM                  
SBCEopHi          .MACRO param          
                  .BYTE $53E9,  param
                  .ENDM
SBCEopIi          .MACRO param
                  .BYTE $60E9,  param
                  .ENDM
SBCEopJi          .MACRO param
                  .BYTE $61E9,  param
                  .ENDM
SBCEopKi          .MACRO param          
                  .BYTE $62E9,  param
                  .ENDM
SBCEopLi          .MACRO param
                  .BYTE $63E9,  param
                  .ENDM
SBCEopMi          .MACRO param
                  .BYTE $70E9,  param
                  .ENDM                  
SBCEopNi          .MACRO param          
                  .BYTE $71E9,  param
                  .ENDM
SBCEopOi          .MACRO param
                  .BYTE $72E9,  param
                  .ENDM
SBCEopQi          .MACRO param
                  .BYTE $73E9,  param
                  .ENDM
                  
SBCFopAi          .MACRO param
                  .BYTE $44E9,  param
                  .ENDM                
SBCFopBi          .MACRO param          
                  .BYTE $45E9,  param
                  .ENDM
SBCFopCi          .MACRO param
                  .BYTE $46E9,  param
                  .ENDM
SBCFopDi          .MACRO param
                  .BYTE $47E9,  param
                  .ENDM
SBCFopEi          .MACRO param          
                  .BYTE $54E9,  param
                  .ENDM
SBCFopFi          .MACRO param
                  .BYTE $55E9,  param
                  .ENDM
SBCFopGi          .MACRO param
                  .BYTE $56E9,  param
                  .ENDM                  
SBCFopHi          .MACRO param          
                  .BYTE $57E9,  param
                  .ENDM
SBCFopIi          .MACRO param
                  .BYTE $64E9,  param
                  .ENDM
SBCFopJi          .MACRO param
                  .BYTE $65E9,  param
                  .ENDM
SBCFopKi          .MACRO param          
                  .BYTE $66E9,  param
                  .ENDM
SBCFopLi          .MACRO param
                  .BYTE $67E9,  param
                  .ENDM
SBCFopMi          .MACRO param
                  .BYTE $74E9,  param
                  .ENDM                  
SBCFopNi          .MACRO param          
                  .BYTE $75E9,  param
                  .ENDM
SBCFopOi          .MACRO param
                  .BYTE $76E9,  param
                  .ENDM
SBCFopQi          .MACRO param
                  .BYTE $77E9,  param
                  .ENDM                  
                           
SBCGopAi          .MACRO param
                  .BYTE $48E9,  param
                  .ENDM                
SBCGopBi          .MACRO param          
                  .BYTE $49E9,  param
                  .ENDM
SBCGopCi          .MACRO param
                  .BYTE $4AE9,  param
                  .ENDM
SBCGopDi          .MACRO param
                  .BYTE $4BE9,  param
                  .ENDM
SBCGopEi          .MACRO param          
                  .BYTE $58E9,  param
                  .ENDM
SBCGopFi          .MACRO param
                  .BYTE $59E9,  param
                  .ENDM
SBCGopGi          .MACRO param
                  .BYTE $5AE9,  param
                  .ENDM                  
SBCGopHi          .MACRO param          
                  .BYTE $5BE9,  param
                  .ENDM
SBCGopIi          .MACRO param
                  .BYTE $68E9,  param
                  .ENDM
SBCGopJi          .MACRO param
                  .BYTE $69E9,  param
                  .ENDM
SBCGopKi          .MACRO param          
                  .BYTE $6AE9,  param
                  .ENDM
SBCGopLi          .MACRO param
                  .BYTE $6BE9,  param
                  .ENDM
SBCGopMi          .MACRO param
                  .BYTE $78E9,  param
                  .ENDM                  
SBCGopNi          .MACRO param          
                  .BYTE $79E9,  param
                  .ENDM
SBCGopOi          .MACRO param
                  .BYTE $7AE9,  param
                  .ENDM
SBCGopQi          .MACRO param
                  .BYTE $7BE9,  param
                  .ENDM
                  
SBCHopAi          .MACRO param
                  .BYTE $4CE9,  param
                  .ENDM                
SBCHopBi          .MACRO param          
                  .BYTE $4DE9,  param
                  .ENDM
SBCHopCi          .MACRO param
                  .BYTE $4EE9,  param
                  .ENDM
SBCHopDi          .MACRO param
                  .BYTE $4FE9,  param
                  .ENDM
SBCHopEi          .MACRO param          
                  .BYTE $5CE9,  param
                  .ENDM
SBCHopFi          .MACRO param
                  .BYTE $5DE9,  param
                  .ENDM
SBCHopGi          .MACRO param
                  .BYTE $5EE9,  param
                  .ENDM                  
SBCHopHi          .MACRO param          
                  .BYTE $5FE9,  param
                  .ENDM
SBCHopIi          .MACRO param
                  .BYTE $6CE9,  param
                  .ENDM
SBCHopJi          .MACRO param
                  .BYTE $6DE9,  param
                  .ENDM
SBCHopKi          .MACRO param          
                  .BYTE $6EE9,  param
                  .ENDM
SBCHopLi          .MACRO param
                  .BYTE $6FE9,  param
                  .ENDM
SBCHopMi          .MACRO param
                  .BYTE $7CE9,  param
                  .ENDM                  
SBCHopNi          .MACRO param          
                  .BYTE $7DE9,  param
                  .ENDM
SBCHopOi          .MACRO param
                  .BYTE $7EE9,  param
                  .ENDM
SBCHopQi          .MACRO param
                  .BYTE $7FE9,  param
                  .ENDM
                  
SBCIopAi          .MACRO param
                  .BYTE $80E9,  param
                  .ENDM                
SBCIopBi          .MACRO param          
                  .BYTE $81E9,  param
                  .ENDM
SBCIopCi          .MACRO param
                  .BYTE $82E9,  param
                  .ENDM
SBCIopDi          .MACRO param
                  .BYTE $83E9,  param
                  .ENDM
SBCIopEi          .MACRO param          
                  .BYTE $90E9,  param
                  .ENDM
SBCIopFi          .MACRO param
                  .BYTE $91E9,  param
                  .ENDM
SBCIopGi          .MACRO param
                  .BYTE $92E9,  param
                  .ENDM                  
SBCIopHi          .MACRO param          
                  .BYTE $93E9,  param
                  .ENDM
SBCIopIi          .MACRO param
                  .BYTE $A0E9,  param
                  .ENDM
SBCIopJi          .MACRO param
                  .BYTE $A1E9,  param
                  .ENDM
SBCIopKi          .MACRO param          
                  .BYTE $A2E9,  param
                  .ENDM
SBCIopLi          .MACRO param
                  .BYTE $A3E9,  param
                  .ENDM
SBCIopMi          .MACRO param
                  .BYTE $B0E9,  param
                  .ENDM                  
SBCIopNi          .MACRO param          
                  .BYTE $B1E9,  param
                  .ENDM
SBCIopOi          .MACRO param
                  .BYTE $B2E9,  param
                  .ENDM
SBCIopQi          .MACRO param
                  .BYTE $B3E9,  param
                  .ENDM
                  
SBCJopAi          .MACRO param
                  .BYTE $84E9,  param
                  .ENDM                
SBCJopBi          .MACRO param          
                  .BYTE $85E9,  param
                  .ENDM
SBCJopCi          .MACRO param
                  .BYTE $86E9,  param
                  .ENDM
SBCJopDi          .MACRO param
                  .BYTE $87E9,  param
                  .ENDM
SBCJopEi          .MACRO param          
                  .BYTE $94E9,  param
                  .ENDM
SBCJopFi          .MACRO param
                  .BYTE $95E9,  param
                  .ENDM
SBCJopGi          .MACRO param
                  .BYTE $96E9,  param
                  .ENDM                  
SBCJopHi          .MACRO param          
                  .BYTE $97E9,  param
                  .ENDM
SBCJopIi          .MACRO param
                  .BYTE $A4E9,  param
                  .ENDM
SBCJopJi          .MACRO param
                  .BYTE $A5E9,  param
                  .ENDM
SBCJopKi          .MACRO param          
                  .BYTE $A6E9,  param
                  .ENDM
SBCJopLi          .MACRO param
                  .BYTE $A7E9,  param
                  .ENDM
SBCJopMi          .MACRO param
                  .BYTE $B4E9,  param
                  .ENDM                  
SBCJopNi          .MACRO param          
                  .BYTE $B5E9,  param
                  .ENDM
SBCJopOi          .MACRO param
                  .BYTE $B6E9,  param
                  .ENDM
SBCJopQi          .MACRO param
                  .BYTE $B7E9,  param
                  .ENDM
                  
SBCKopAi          .MACRO param
                  .BYTE $88E9,  param
                  .ENDM                
SBCKopBi          .MACRO param          
                  .BYTE $89E9,  param
                  .ENDM
SBCKopCi          .MACRO param
                  .BYTE $8AE9,  param
                  .ENDM
SBCKopDi          .MACRO param
                  .BYTE $8BE9,  param
                  .ENDM
SBCKopEi          .MACRO param          
                  .BYTE $98E9,  param
                  .ENDM
SBCKopFi          .MACRO param
                  .BYTE $99E9,  param
                  .ENDM
SBCKopGi          .MACRO param
                  .BYTE $9AE9,  param
                  .ENDM                  
SBCKopHi          .MACRO param          
                  .BYTE $9BE9,  param
                  .ENDM
SBCKopIi          .MACRO param
                  .BYTE $A8E9,  param
                  .ENDM
SBCKopJi          .MACRO param
                  .BYTE $A9E9,  param
                  .ENDM
SBCKopKi          .MACRO param          
                  .BYTE $AAE9,  param
                  .ENDM
SBCKopLi          .MACRO param
                  .BYTE $ABE9,  param
                  .ENDM
SBCKopMi          .MACRO param
                  .BYTE $B8E9,  param
                  .ENDM                  
SBCKopNi          .MACRO param          
                  .BYTE $B9E9,  param
                  .ENDM
SBCKopOi          .MACRO param
                  .BYTE $BAE9,  param
                  .ENDM
SBCKopQi          .MACRO param
                  .BYTE $BBE9,  param
                  .ENDM
                  
SBCLopAi          .MACRO param
                  .BYTE $8CE9,  param
                  .ENDM                
SBCLopBi          .MACRO param          
                  .BYTE $8DE9,  param
                  .ENDM
SBCLopCi          .MACRO param
                  .BYTE $8EE9,  param
                  .ENDM
SBCLopDi          .MACRO param
                  .BYTE $8FE9,  param
                  .ENDM
SBCLopEi          .MACRO param          
                  .BYTE $9CE9,  param
                  .ENDM
SBCLopFi          .MACRO param
                  .BYTE $9DE9,  param
                  .ENDM
SBCLopGi          .MACRO param
                  .BYTE $9EE9,  param
                  .ENDM                  
SBCLopHi          .MACRO param          
                  .BYTE $9FE9,  param
                  .ENDM
SBCLopIi          .MACRO param
                  .BYTE $ACE9,  param
                  .ENDM
SBCLopJi          .MACRO param
                  .BYTE $ADE9,  param
                  .ENDM
SBCLopKi          .MACRO param          
                  .BYTE $AEE9,  param
                  .ENDM
SBCLopLi          .MACRO param
                  .BYTE $AFE9,  param
                  .ENDM
SBCLopMi          .MACRO param
                  .BYTE $BCE9,  param
                  .ENDM                  
SBCLopNi          .MACRO param          
                  .BYTE $BDE9,  param
                  .ENDM
SBCLopOi          .MACRO param
                  .BYTE $BEE9,  param
                  .ENDM
SBCLopQi          .MACRO param
                  .BYTE $BFE9,  param
                  .ENDM
                  
SBCMopAi          .MACRO param
                  .BYTE $C0E9,  param
                  .ENDM                
SBCMopBi          .MACRO param          
                  .BYTE $C1E9,  param
                  .ENDM
SBCMopCi          .MACRO param
                  .BYTE $C2E9,  param
                  .ENDM
SBCMopDi          .MACRO param
                  .BYTE $C3E9,  param
                  .ENDM
SBCMopEi          .MACRO param          
                  .BYTE $D0E9,  param
                  .ENDM
SBCMopFi          .MACRO param
                  .BYTE $D1E9,  param
                  .ENDM
SBCMopGi          .MACRO param
                  .BYTE $D2E9,  param
                  .ENDM                  
SBCMopHi          .MACRO param          
                  .BYTE $D3E9,  param
                  .ENDM
SBCMopIi          .MACRO param
                  .BYTE $E0E9,  param
                  .ENDM
SBCMopJi          .MACRO param
                  .BYTE $E1E9,  param
                  .ENDM
SBCMopKi          .MACRO param          
                  .BYTE $E2E9,  param
                  .ENDM
SBCMopLi          .MACRO param
                  .BYTE $E3E9,  param
                  .ENDM
SBCMopMi          .MACRO param
                  .BYTE $F0E9,  param
                  .ENDM                  
SBCMopNi          .MACRO param          
                  .BYTE $F1E9,  param
                  .ENDM
SBCMopOi          .MACRO param
                  .BYTE $F2E9,  param
                  .ENDM
SBCMopQi          .MACRO param
                  .BYTE $F3E9,  param
                  .ENDM
                  
SBCNopAi          .MACRO param
                  .BYTE $C4E9,  param
                  .ENDM                
SBCNopBi          .MACRO param          
                  .BYTE $C5E9,  param
                  .ENDM
SBCNopCi          .MACRO param
                  .BYTE $C6E9,  param
                  .ENDM
SBCNopDi          .MACRO param
                  .BYTE $C7E9,  param
                  .ENDM
SBCNopEi          .MACRO param          
                  .BYTE $D4E9,  param
                  .ENDM
SBCNopFi          .MACRO param
                  .BYTE $D5E9,  param
                  .ENDM
SBCNopGi          .MACRO param
                  .BYTE $D6E9,  param
                  .ENDM                  
SBCNopHi          .MACRO param          
                  .BYTE $D7E9,  param
                  .ENDM
SBCNopIi          .MACRO param
                  .BYTE $E4E9,  param
                  .ENDM
SBCNopJi          .MACRO param
                  .BYTE $E5E9,  param
                  .ENDM
SBCNopKi          .MACRO param          
                  .BYTE $E6E9,  param
                  .ENDM
SBCNopLi          .MACRO param
                  .BYTE $E7E9,  param
                  .ENDM
SBCNopMi          .MACRO param
                  .BYTE $F4E9,  param
                  .ENDM                  
SBCNopNi          .MACRO param          
                  .BYTE $F5E9,  param
                  .ENDM
SBCNopOi          .MACRO param
                  .BYTE $F6E9,  param
                  .ENDM
SBCNopQi          .MACRO param
                  .BYTE $F7E9,  param
                  .ENDM
            
SBCOopAi          .MACRO param
                  .BYTE $C8E9,  param
                  .ENDM                
SBCOopBi          .MACRO param          
                  .BYTE $C9E9,  param
                  .ENDM
SBCOopCi          .MACRO param
                  .BYTE $CAE9,  param
                  .ENDM
SBCOopDi          .MACRO param
                  .BYTE $CBE9,  param
                  .ENDM
SBCOopEi          .MACRO param          
                  .BYTE $D8E9,  param
                  .ENDM
SBCOopFi          .MACRO param
                  .BYTE $D9E9,  param
                  .ENDM
SBCOopGi          .MACRO param
                  .BYTE $DAE9,  param
                  .ENDM                  
SBCOopHi          .MACRO param          
                  .BYTE $DBE9,  param
                  .ENDM
SBCOopIi          .MACRO param
                  .BYTE $E8E9,  param
                  .ENDM
SBCOopJi          .MACRO param
                  .BYTE $E9E9,  param
                  .ENDM
SBCOopKi          .MACRO param          
                  .BYTE $EAE9,  param
                  .ENDM
SBCOopLi          .MACRO param
                  .BYTE $EBE9,  param
                  .ENDM
SBCOopMi          .MACRO param
                  .BYTE $F8E9,  param
                  .ENDM                  
SBCOopNi          .MACRO param          
                  .BYTE $F9E9,  param
                  .ENDM
SBCOopOi          .MACRO param
                  .BYTE $FAE9,  param
                  .ENDM
SBCOopQi          .MACRO param
                  .BYTE $FBE9,  param
                  .ENDM
                  
SBCQopAi          .MACRO param
                  .BYTE $CCE9,  param
                  .ENDM                
SBCQopBi          .MACRO param          
                  .BYTE $CDE9,  param
                  .ENDM
SBCQopCi          .MACRO param
                  .BYTE $CEE9,  param
                  .ENDM
SBCQopDi          .MACRO param
                  .BYTE $CFE9,  param
                  .ENDM
SBCQopEi          .MACRO param          
                  .BYTE $DCE9,  param
                  .ENDM
SBCQopFi          .MACRO param
                  .BYTE $DDE9,  param
                  .ENDM
SBCQopGi          .MACRO param
                  .BYTE $DEE9,  param
                  .ENDM                  
SBCQopHi          .MACRO param          
                  .BYTE $DFE9,  param
                  .ENDM
SBCQopIi          .MACRO param
                  .BYTE $ECE9,  param
                  .ENDM
SBCQopJi          .MACRO param
                  .BYTE $EDE9,  param
                  .ENDM
SBCQopKi          .MACRO param          
                  .BYTE $EEE9,  param
                  .ENDM
SBCQopLi          .MACRO param
                  .BYTE $EFE9,  param
                  .ENDM
SBCQopMi          .MACRO param
                  .BYTE $FCE9,  param
                  .ENDM                  
SBCQopNi          .MACRO param          
                  .BYTE $FDE9,  param
                  .ENDM
SBCQopOi          .MACRO param
                  .BYTE $FEE9,  param
                  .ENDM
SBCQopQi          .MACRO param
                  .BYTE $FFE9,  param
                  .ENDM
                  
;ORA #$xxxx             $0009
ORAAopBi          .MACRO param          
                  .BYTE $0109,  param
                  .ENDM
ORAAopCi          .MACRO param
                  .BYTE $0209,  param
                  .ENDM
ORAAopDi          .MACRO param
                  .BYTE $0309,  param
                  .ENDM
ORAAopEi          .MACRO param          
                  .BYTE $1009,  param
                  .ENDM
ORAAopFi          .MACRO param
                  .BYTE $1109,  param
                  .ENDM
ORAAopGi          .MACRO param
                  .BYTE $1209,  param
                  .ENDM                  
ORAAopHi          .MACRO param          
                  .BYTE $1309,  param
                  .ENDM
ORAAopIi          .MACRO param
                  .BYTE $2009,  param
                  .ENDM
ORAAopJi          .MACRO param
                  .BYTE $2109,  param
                  .ENDM
ORAAopKi          .MACRO param          
                  .BYTE $2209,  param
                  .ENDM
ORAAopLi          .MACRO param
                  .BYTE $2309,  param
                  .ENDM
ORAAopMi          .MACRO param
                  .BYTE $3009,  param
                  .ENDM                  
ORAAopNi          .MACRO param          
                  .BYTE $3109,  param
                  .ENDM
ORAAopOi          .MACRO param
                  .BYTE $3209,  param
                  .ENDM
ORAAopQi          .MACRO param
                  .BYTE $3309,  param
                  .ENDM
                                    
ORABopAi          .MACRO param
                  .BYTE $0409,  param
                  .ENDM                
ORABopBi          .MACRO param          
                  .BYTE $0509,  param
                  .ENDM
ORABopCi          .MACRO param
                  .BYTE $0609,  param
                  .ENDM
ORABopDi          .MACRO param
                  .BYTE $0709,  param
                  .ENDM
ORABopEi          .MACRO param          
                  .BYTE $1409,  param
                  .ENDM
ORABopFi          .MACRO param
                  .BYTE $1509,  param
                  .ENDM
ORABopGi          .MACRO param
                  .BYTE $1609,  param
                  .ENDM                  
ORABopHi          .MACRO param          
                  .BYTE $1709,  param
                  .ENDM
ORABopIi          .MACRO param
                  .BYTE $2409,  param
                  .ENDM
ORABopJi          .MACRO param
                  .BYTE $2509,  param
                  .ENDM
ORABopKi          .MACRO param          
                  .BYTE $2609,  param
                  .ENDM
ORABopLi          .MACRO param
                  .BYTE $2709,  param
                  .ENDM
ORABopMi          .MACRO param
                  .BYTE $3009,  param
                  .ENDM                  
ORABopNi          .MACRO param          
                  .BYTE $3109,  param
                  .ENDM
ORABopOi          .MACRO param
                  .BYTE $3209,  param
                  .ENDM
ORABopQi          .MACRO param
                  .BYTE $3309,  param
                  .ENDM
                                    
ORACopAi          .MACRO param
                  .BYTE $0809,  param
                  .ENDM                
ORACopBi          .MACRO param          
                  .BYTE $0909,  param
                  .ENDM
ORACopCi          .MACRO param
                  .BYTE $0A09,  param
                  .ENDM
ORACopDi          .MACRO param
                  .BYTE $0B09,  param
                  .ENDM
ORACopEi          .MACRO param          
                  .BYTE $1809,  param
                  .ENDM
ORACopFi          .MACRO param
                  .BYTE $1909,  param
                  .ENDM
ORACopGi          .MACRO param
                  .BYTE $1A09,  param
                  .ENDM                  
ORACopHi          .MACRO param          
                  .BYTE $1B09,  param
                  .ENDM
ORACopIi          .MACRO param
                  .BYTE $2809,  param
                  .ENDM
ORACopJi          .MACRO param
                  .BYTE $2909,  param
                  .ENDM
ORACopKi          .MACRO param          
                  .BYTE $2A09,  param
                  .ENDM
ORACopLi          .MACRO param
                  .BYTE $2B09,  param
                  .ENDM
ORACopMi          .MACRO param
                  .BYTE $3809,  param
                  .ENDM                  
ORACopNi          .MACRO param          
                  .BYTE $3909,  param
                  .ENDM
ORACopOi          .MACRO param
                  .BYTE $3A09,  param
                  .ENDM
ORACopQi          .MACRO param
                  .BYTE $3B09,  param
                  .ENDM

ORADopAi          .MACRO param
                  .BYTE $0C09,  param
                  .ENDM                
ORADopBi          .MACRO param          
                  .BYTE $0D09,  param
                  .ENDM
ORADopCi          .MACRO param
                  .BYTE $0E09,  param
                  .ENDM
ORADopDi          .MACRO param
                  .BYTE $0F09,  param
                  .ENDM
ORADopEi          .MACRO param          
                  .BYTE $1C09,  param
                  .ENDM
ORADopFi          .MACRO param
                  .BYTE $1D09,  param
                  .ENDM
ORADopGi          .MACRO param
                  .BYTE $1E09,  param
                  .ENDM                  
ORADopHi          .MACRO param          
                  .BYTE $1F09,  param
                  .ENDM
ORADopIi          .MACRO param
                  .BYTE $2C09,  param
                  .ENDM
ORADopJi          .MACRO param
                  .BYTE $2D09,  param
                  .ENDM
ORADopKi          .MACRO param          
                  .BYTE $2E09,  param
                  .ENDM
ORADopLi          .MACRO param
                  .BYTE $2F09,  param
                  .ENDM
ORADopMi          .MACRO param
                  .BYTE $3C09,  param
                  .ENDM                  
ORADopNi          .MACRO param          
                  .BYTE $3D09,  param
                  .ENDM
ORADopOi          .MACRO param
                  .BYTE $3E09,  param
                  .ENDM
ORADopQi          .MACRO param
                  .BYTE $3F09,  param
                  .ENDM                  

ORAEopAi          .MACRO param
                  .BYTE $4009,  param
                  .ENDM                
ORAEopBi          .MACRO param          
                  .BYTE $4109,  param
                  .ENDM
ORAEopCi          .MACRO param
                  .BYTE $4209,  param
                  .ENDM
ORAEopDi          .MACRO param
                  .BYTE $4309,  param
                  .ENDM
ORAEopEi          .MACRO param          
                  .BYTE $5009,  param
                  .ENDM
ORAEopFi          .MACRO param
                  .BYTE $5109,  param
                  .ENDM
ORAEopGi          .MACRO param
                  .BYTE $5209,  param
                  .ENDM                  
ORAEopHi          .MACRO param          
                  .BYTE $5309,  param
                  .ENDM
ORAEopIi          .MACRO param
                  .BYTE $6009,  param
                  .ENDM
ORAEopJi          .MACRO param
                  .BYTE $6109,  param
                  .ENDM
ORAEopKi          .MACRO param          
                  .BYTE $6209,  param
                  .ENDM
ORAEopLi          .MACRO param
                  .BYTE $6309,  param
                  .ENDM
ORAEopMi          .MACRO param
                  .BYTE $7009,  param
                  .ENDM                  
ORAEopNi          .MACRO param          
                  .BYTE $7109,  param
                  .ENDM
ORAEopOi          .MACRO param
                  .BYTE $7209,  param
                  .ENDM
ORAEopQi          .MACRO param
                  .BYTE $7309,  param
                  .ENDM
                  
ORAFopAi          .MACRO param
                  .BYTE $4409,  param
                  .ENDM                
ORAFopBi          .MACRO param          
                  .BYTE $4509,  param
                  .ENDM
ORAFopCi          .MACRO param
                  .BYTE $4609,  param
                  .ENDM
ORAFopDi          .MACRO param
                  .BYTE $4709,  param
                  .ENDM
ORAFopEi          .MACRO param          
                  .BYTE $5409,  param
                  .ENDM
ORAFopFi          .MACRO param
                  .BYTE $5509,  param
                  .ENDM
ORAFopGi          .MACRO param
                  .BYTE $5609,  param
                  .ENDM                  
ORAFopHi          .MACRO param          
                  .BYTE $5709,  param
                  .ENDM
ORAFopIi          .MACRO param
                  .BYTE $6409,  param
                  .ENDM
ORAFopJi          .MACRO param
                  .BYTE $6509,  param
                  .ENDM
ORAFopKi          .MACRO param          
                  .BYTE $6609,  param
                  .ENDM
ORAFopLi          .MACRO param
                  .BYTE $6709,  param
                  .ENDM
ORAFopMi          .MACRO param
                  .BYTE $7409,  param
                  .ENDM                  
ORAFopNi          .MACRO param          
                  .BYTE $7509,  param
                  .ENDM
ORAFopOi          .MACRO param
                  .BYTE $7609,  param
                  .ENDM
ORAFopQi          .MACRO param
                  .BYTE $7709,  param
                  .ENDM                  
                           
ORAGopAi          .MACRO param
                  .BYTE $4809,  param
                  .ENDM                
ORAGopBi          .MACRO param          
                  .BYTE $4909,  param
                  .ENDM
ORAGopCi          .MACRO param
                  .BYTE $4A09,  param
                  .ENDM
ORAGopDi          .MACRO param
                  .BYTE $4B09,  param
                  .ENDM
ORAGopEi          .MACRO param          
                  .BYTE $5809,  param
                  .ENDM
ORAGopFi          .MACRO param
                  .BYTE $5909,  param
                  .ENDM
ORAGopGi          .MACRO param
                  .BYTE $5A09,  param
                  .ENDM                  
ORAGopHi          .MACRO param          
                  .BYTE $5B09,  param
                  .ENDM
ORAGopIi          .MACRO param
                  .BYTE $6809,  param
                  .ENDM
ORAGopJi          .MACRO param
                  .BYTE $6909,  param
                  .ENDM
ORAGopKi          .MACRO param          
                  .BYTE $6A09,  param
                  .ENDM
ORAGopLi          .MACRO param
                  .BYTE $6B09,  param
                  .ENDM
ORAGopMi          .MACRO param
                  .BYTE $7809,  param
                  .ENDM                  
ORAGopNi          .MACRO param          
                  .BYTE $7909,  param
                  .ENDM
ORAGopOi          .MACRO param
                  .BYTE $7A09,  param
                  .ENDM
ORAGopQi          .MACRO param
                  .BYTE $7B09,  param
                  .ENDM
                  
ORAHopAi          .MACRO param
                  .BYTE $4C09,  param
                  .ENDM                
ORAHopBi          .MACRO param          
                  .BYTE $4D09,  param
                  .ENDM
ORAHopCi          .MACRO param
                  .BYTE $4E09,  param
                  .ENDM
ORAHopDi          .MACRO param
                  .BYTE $4F09,  param
                  .ENDM
ORAHopEi          .MACRO param          
                  .BYTE $5C09,  param
                  .ENDM
ORAHopFi          .MACRO param
                  .BYTE $5D09,  param
                  .ENDM
ORAHopGi          .MACRO param
                  .BYTE $5E09,  param
                  .ENDM                  
ORAHopHi          .MACRO param          
                  .BYTE $5F09,  param
                  .ENDM
ORAHopIi          .MACRO param
                  .BYTE $6C09,  param
                  .ENDM
ORAHopJi          .MACRO param
                  .BYTE $6D09,  param
                  .ENDM
ORAHopKi          .MACRO param          
                  .BYTE $6E09,  param
                  .ENDM
ORAHopLi          .MACRO param
                  .BYTE $6F09,  param
                  .ENDM
ORAHopMi          .MACRO param
                  .BYTE $7C09,  param
                  .ENDM                  
ORAHopNi          .MACRO param          
                  .BYTE $7D09,  param
                  .ENDM
ORAHopOi          .MACRO param
                  .BYTE $7E09,  param
                  .ENDM
ORAHopQi          .MACRO param
                  .BYTE $7F09,  param
                  .ENDM
                  
ORAIopAi          .MACRO param
                  .BYTE $8009,  param
                  .ENDM                
ORAIopBi          .MACRO param          
                  .BYTE $8109,  param
                  .ENDM
ORAIopCi          .MACRO param
                  .BYTE $8209,  param
                  .ENDM
ORAIopDi          .MACRO param
                  .BYTE $8309,  param
                  .ENDM
ORAIopEi          .MACRO param          
                  .BYTE $9009,  param
                  .ENDM
ORAIopFi          .MACRO param
                  .BYTE $9109,  param
                  .ENDM
ORAIopGi          .MACRO param
                  .BYTE $9209,  param
                  .ENDM                  
ORAIopHi          .MACRO param          
                  .BYTE $9309,  param
                  .ENDM
ORAIopIi          .MACRO param
                  .BYTE $A009,  param
                  .ENDM
ORAIopJi          .MACRO param
                  .BYTE $A109,  param
                  .ENDM
ORAIopKi          .MACRO param          
                  .BYTE $A209,  param
                  .ENDM
ORAIopLi          .MACRO param
                  .BYTE $A309,  param
                  .ENDM
ORAIopMi          .MACRO param
                  .BYTE $B009,  param
                  .ENDM                  
ORAIopNi          .MACRO param          
                  .BYTE $B109,  param
                  .ENDM
ORAIopOi          .MACRO param
                  .BYTE $B209,  param
                  .ENDM
ORAIopQi          .MACRO param
                  .BYTE $B309,  param
                  .ENDM
                  
ORAJopAi          .MACRO param
                  .BYTE $8409,  param
                  .ENDM                
ORAJopBi          .MACRO param          
                  .BYTE $8509,  param
                  .ENDM
ORAJopCi          .MACRO param
                  .BYTE $8609,  param
                  .ENDM
ORAJopDi          .MACRO param
                  .BYTE $8709,  param
                  .ENDM
ORAJopEi          .MACRO param          
                  .BYTE $9409,  param
                  .ENDM
ORAJopFi          .MACRO param
                  .BYTE $9509,  param
                  .ENDM
ORAJopGi          .MACRO param
                  .BYTE $9609,  param
                  .ENDM                  
ORAJopHi          .MACRO param          
                  .BYTE $9709,  param
                  .ENDM
ORAJopIi          .MACRO param
                  .BYTE $A409,  param
                  .ENDM
ORAJopJi          .MACRO param
                  .BYTE $A509,  param
                  .ENDM
ORAJopKi          .MACRO param          
                  .BYTE $A609,  param
                  .ENDM
ORAJopLi          .MACRO param
                  .BYTE $A709,  param
                  .ENDM
ORAJopMi          .MACRO param
                  .BYTE $B409,  param
                  .ENDM                  
ORAJopNi          .MACRO param          
                  .BYTE $B509,  param
                  .ENDM
ORAJopOi          .MACRO param
                  .BYTE $B609,  param
                  .ENDM
ORAJopQi          .MACRO param
                  .BYTE $B709,  param
                  .ENDM
                  
ORAKopAi          .MACRO param
                  .BYTE $8809,  param
                  .ENDM                
ORAKopBi          .MACRO param          
                  .BYTE $8909,  param
                  .ENDM
ORAKopCi          .MACRO param
                  .BYTE $8A09,  param
                  .ENDM
ORAKopDi          .MACRO param
                  .BYTE $8B09,  param
                  .ENDM
ORAKopEi          .MACRO param          
                  .BYTE $9809,  param
                  .ENDM
ORAKopFi          .MACRO param
                  .BYTE $9909,  param
                  .ENDM
ORAKopGi          .MACRO param
                  .BYTE $9A09,  param
                  .ENDM                  
ORAKopHi          .MACRO param          
                  .BYTE $9B09,  param
                  .ENDM
ORAKopIi          .MACRO param
                  .BYTE $A809,  param
                  .ENDM
ORAKopJi          .MACRO param
                  .BYTE $A909,  param
                  .ENDM
ORAKopKi          .MACRO param          
                  .BYTE $AA09,  param
                  .ENDM
ORAKopLi          .MACRO param
                  .BYTE $AB09,  param
                  .ENDM
ORAKopMi          .MACRO param
                  .BYTE $B809,  param
                  .ENDM                  
ORAKopNi          .MACRO param          
                  .BYTE $B909,  param
                  .ENDM
ORAKopOi          .MACRO param
                  .BYTE $BA09,  param
                  .ENDM
ORAKopQi          .MACRO param
                  .BYTE $BB09,  param
                  .ENDM
                  
ORALopAi          .MACRO param
                  .BYTE $8C09,  param
                  .ENDM                
ORALopBi          .MACRO param          
                  .BYTE $8D09,  param
                  .ENDM
ORALopCi          .MACRO param
                  .BYTE $8E09,  param
                  .ENDM
ORALopDi          .MACRO param
                  .BYTE $8F09,  param
                  .ENDM
ORALopEi          .MACRO param          
                  .BYTE $9C09,  param
                  .ENDM
ORALopFi          .MACRO param
                  .BYTE $9D09,  param
                  .ENDM
ORALopGi          .MACRO param
                  .BYTE $9E09,  param
                  .ENDM                  
ORALopHi          .MACRO param          
                  .BYTE $9F09,  param
                  .ENDM
ORALopIi          .MACRO param
                  .BYTE $AC09,  param
                  .ENDM
ORALopJi          .MACRO param
                  .BYTE $AD09,  param
                  .ENDM
ORALopKi          .MACRO param          
                  .BYTE $AE09,  param
                  .ENDM
ORALopLi          .MACRO param
                  .BYTE $AF09,  param
                  .ENDM
ORALopMi          .MACRO param
                  .BYTE $BC09,  param
                  .ENDM                  
ORALopNi          .MACRO param          
                  .BYTE $BD09,  param
                  .ENDM
ORALopOi          .MACRO param
                  .BYTE $BE09,  param
                  .ENDM
ORALopQi          .MACRO param
                  .BYTE $BF09,  param
                  .ENDM
                  
ORAMopAi          .MACRO param
                  .BYTE $C009,  param
                  .ENDM                
ORAMopBi          .MACRO param          
                  .BYTE $C109,  param
                  .ENDM
ORAMopCi          .MACRO param
                  .BYTE $C209,  param
                  .ENDM
ORAMopDi          .MACRO param
                  .BYTE $C309,  param
                  .ENDM
ORAMopEi          .MACRO param          
                  .BYTE $D009,  param
                  .ENDM
ORAMopFi          .MACRO param
                  .BYTE $D109,  param
                  .ENDM
ORAMopGi          .MACRO param
                  .BYTE $D209,  param
                  .ENDM                  
ORAMopHi          .MACRO param          
                  .BYTE $D309,  param
                  .ENDM
ORAMopIi          .MACRO param
                  .BYTE $E009,  param
                  .ENDM
ORAMopJi          .MACRO param
                  .BYTE $E109,  param
                  .ENDM
ORAMopKi          .MACRO param          
                  .BYTE $E209,  param
                  .ENDM
ORAMopLi          .MACRO param
                  .BYTE $E309,  param
                  .ENDM
ORAMopMi          .MACRO param
                  .BYTE $F009,  param
                  .ENDM                  
ORAMopNi          .MACRO param          
                  .BYTE $F109,  param
                  .ENDM
ORAMopOi          .MACRO param
                  .BYTE $F209,  param
                  .ENDM
ORAMopQi          .MACRO param
                  .BYTE $F309,  param
                  .ENDM
                  
ORANopAi          .MACRO param
                  .BYTE $C409,  param
                  .ENDM                
ORANopBi          .MACRO param          
                  .BYTE $C509,  param
                  .ENDM
ORANopCi          .MACRO param
                  .BYTE $C609,  param
                  .ENDM
ORANopDi          .MACRO param
                  .BYTE $C709,  param
                  .ENDM
ORANopEi          .MACRO param          
                  .BYTE $D409,  param
                  .ENDM
ORANopFi          .MACRO param
                  .BYTE $D509,  param
                  .ENDM
ORANopGi          .MACRO param
                  .BYTE $D609,  param
                  .ENDM                  
ORANopHi          .MACRO param          
                  .BYTE $D709,  param
                  .ENDM
ORANopIi          .MACRO param
                  .BYTE $E409,  param
                  .ENDM
ORANopJi          .MACRO param
                  .BYTE $E509,  param
                  .ENDM
ORANopKi          .MACRO param          
                  .BYTE $E609,  param
                  .ENDM
ORANopLi          .MACRO param
                  .BYTE $E709,  param
                  .ENDM
ORANopMi          .MACRO param
                  .BYTE $F409,  param
                  .ENDM                  
ORANopNi          .MACRO param          
                  .BYTE $F509,  param
                  .ENDM
ORANopOi          .MACRO param
                  .BYTE $F609,  param
                  .ENDM
ORANopQi          .MACRO param
                  .BYTE $F709,  param
                  .ENDM
            
ORAOopAi          .MACRO param
                  .BYTE $C809,  param
                  .ENDM                
ORAOopBi          .MACRO param          
                  .BYTE $C909,  param
                  .ENDM
ORAOopCi          .MACRO param
                  .BYTE $CA09,  param
                  .ENDM
ORAOopDi          .MACRO param
                  .BYTE $CB09,  param
                  .ENDM
ORAOopEi          .MACRO param          
                  .BYTE $D809,  param
                  .ENDM
ORAOopFi          .MACRO param
                  .BYTE $D909,  param
                  .ENDM
ORAOopGi          .MACRO param
                  .BYTE $DA09,  param
                  .ENDM                  
ORAOopHi          .MACRO param          
                  .BYTE $DB09,  param
                  .ENDM
ORAOopIi          .MACRO param
                  .BYTE $E809,  param
                  .ENDM
ORAOopJi          .MACRO param
                  .BYTE $E909,  param
                  .ENDM
ORAOopKi          .MACRO param          
                  .BYTE $EA09,  param
                  .ENDM
ORAOopLi          .MACRO param
                  .BYTE $EB09,  param
                  .ENDM
ORAOopMi          .MACRO param
                  .BYTE $F809,  param
                  .ENDM                  
ORAOopNi          .MACRO param          
                  .BYTE $F909,  param
                  .ENDM
ORAOopOi          .MACRO param
                  .BYTE $FA09,  param
                  .ENDM
ORAOopQi          .MACRO param
                  .BYTE $FB09,  param
                  .ENDM
                  
ORAQopAi          .MACRO param
                  .BYTE $CC09,  param
                  .ENDM                
ORAQopBi          .MACRO param          
                  .BYTE $CD09,  param
                  .ENDM
ORAQopCi          .MACRO param
                  .BYTE $CE09,  param
                  .ENDM
ORAQopDi          .MACRO param
                  .BYTE $CF09,  param
                  .ENDM
ORAQopEi          .MACRO param          
                  .BYTE $DC09,  param
                  .ENDM
ORAQopFi          .MACRO param
                  .BYTE $DD09,  param
                  .ENDM
ORAQopGi          .MACRO param
                  .BYTE $DE09,  param
                  .ENDM                  
ORAQopHi          .MACRO param          
                  .BYTE $DF09,  param
                  .ENDM
ORAQopIi          .MACRO param
                  .BYTE $EC09,  param
                  .ENDM
ORAQopJi          .MACRO param
                  .BYTE $ED09,  param
                  .ENDM
ORAQopKi          .MACRO param          
                  .BYTE $EE09,  param
                  .ENDM
ORAQopLi          .MACRO param
                  .BYTE $EF09,  param
                  .ENDM
ORAQopMi          .MACRO param
                  .BYTE $FC09,  param
                  .ENDM                  
ORAQopNi          .MACRO param          
                  .BYTE $FD09,  param
                  .ENDM
ORAQopOi          .MACRO param
                  .BYTE $FE09,  param
                  .ENDM
ORAQopQi          .MACRO param
                  .BYTE $FF09,  param
                  .ENDM
                  
;AND #$xxxx             $0029
ANDAopBi          .MACRO param          
                  .BYTE $0129,  param
                  .ENDM
ANDAopCi          .MACRO param
                  .BYTE $0229,  param
                  .ENDM
ANDAopDi          .MACRO param
                  .BYTE $0329,  param
                  .ENDM
ANDAopEi          .MACRO param          
                  .BYTE $1029,  param
                  .ENDM
ANDAopFi          .MACRO param
                  .BYTE $1129,  param
                  .ENDM
ANDAopGi          .MACRO param
                  .BYTE $1229,  param
                  .ENDM                  
ANDAopHi          .MACRO param          
                  .BYTE $1329,  param
                  .ENDM
ANDAopIi          .MACRO param
                  .BYTE $2029,  param
                  .ENDM
ANDAopJi          .MACRO param
                  .BYTE $2129,  param
                  .ENDM
ANDAopKi          .MACRO param          
                  .BYTE $2229,  param
                  .ENDM
ANDAopLi          .MACRO param
                  .BYTE $2329,  param
                  .ENDM
ANDAopMi          .MACRO param
                  .BYTE $3029,  param
                  .ENDM                  
ANDAopNi          .MACRO param          
                  .BYTE $3129,  param
                  .ENDM
ANDAopOi          .MACRO param
                  .BYTE $3229,  param
                  .ENDM
ANDAopQi          .MACRO param
                  .BYTE $3329,  param
                  .ENDM
                                    
ANDBopAi          .MACRO param
                  .BYTE $0429,  param
                  .ENDM                
ANDBopBi          .MACRO param          
                  .BYTE $0529,  param
                  .ENDM
ANDBopCi          .MACRO param
                  .BYTE $0629,  param
                  .ENDM
ANDBopDi          .MACRO param
                  .BYTE $0729,  param
                  .ENDM
ANDBopEi          .MACRO param          
                  .BYTE $1429,  param
                  .ENDM
ANDBopFi          .MACRO param
                  .BYTE $1529,  param
                  .ENDM
ANDBopGi          .MACRO param
                  .BYTE $1629,  param
                  .ENDM                  
ANDBopHi          .MACRO param          
                  .BYTE $1729,  param
                  .ENDM
ANDBopIi          .MACRO param
                  .BYTE $2429,  param
                  .ENDM
ANDBopJi          .MACRO param
                  .BYTE $2529,  param
                  .ENDM
ANDBopKi          .MACRO param          
                  .BYTE $2629,  param
                  .ENDM
ANDBopLi          .MACRO param
                  .BYTE $2729,  param
                  .ENDM
ANDBopMi          .MACRO param
                  .BYTE $3029,  param
                  .ENDM                  
ANDBopNi          .MACRO param          
                  .BYTE $3129,  param
                  .ENDM
ANDBopOi          .MACRO param
                  .BYTE $3229,  param
                  .ENDM
ANDBopQi          .MACRO param
                  .BYTE $3329,  param
                  .ENDM
                                    
ANDCopAi          .MACRO param
                  .BYTE $0829,  param
                  .ENDM                
ANDCopBi          .MACRO param          
                  .BYTE $0929,  param
                  .ENDM
ANDCopCi          .MACRO param
                  .BYTE $0A29,  param
                  .ENDM
ANDCopDi          .MACRO param
                  .BYTE $0B29,  param
                  .ENDM
ANDCopEi          .MACRO param          
                  .BYTE $1829,  param
                  .ENDM
ANDCopFi          .MACRO param
                  .BYTE $1929,  param
                  .ENDM
ANDCopGi          .MACRO param
                  .BYTE $1A29,  param
                  .ENDM                  
ANDCopHi          .MACRO param          
                  .BYTE $1B29,  param
                  .ENDM
ANDCopIi          .MACRO param
                  .BYTE $2829,  param
                  .ENDM
ANDCopJi          .MACRO param
                  .BYTE $2929,  param
                  .ENDM
ANDCopKi          .MACRO param          
                  .BYTE $2A29,  param
                  .ENDM
ANDCopLi          .MACRO param
                  .BYTE $2B29,  param
                  .ENDM
ANDCopMi          .MACRO param
                  .BYTE $3829,  param
                  .ENDM                  
ANDCopNi          .MACRO param          
                  .BYTE $3929,  param
                  .ENDM
ANDCopOi          .MACRO param
                  .BYTE $3A29,  param
                  .ENDM
ANDCopQi          .MACRO param
                  .BYTE $3B29,  param
                  .ENDM

ANDDopAi          .MACRO param
                  .BYTE $0C29,  param
                  .ENDM                
ANDDopBi          .MACRO param          
                  .BYTE $0D29,  param
                  .ENDM
ANDDopCi          .MACRO param
                  .BYTE $0E29,  param
                  .ENDM
ANDDopDi          .MACRO param
                  .BYTE $0F29,  param
                  .ENDM
ANDDopEi          .MACRO param          
                  .BYTE $1C29,  param
                  .ENDM
ANDDopFi          .MACRO param
                  .BYTE $1D29,  param
                  .ENDM
ANDDopGi          .MACRO param
                  .BYTE $1E29,  param
                  .ENDM                  
ANDDopHi          .MACRO param          
                  .BYTE $1F29,  param
                  .ENDM
ANDDopIi          .MACRO param
                  .BYTE $2C29,  param
                  .ENDM
ANDDopJi          .MACRO param
                  .BYTE $2D29,  param
                  .ENDM
ANDDopKi          .MACRO param          
                  .BYTE $2E29,  param
                  .ENDM
ANDDopLi          .MACRO param
                  .BYTE $2F29,  param
                  .ENDM
ANDDopMi          .MACRO param
                  .BYTE $3C29,  param
                  .ENDM                  
ANDDopNi          .MACRO param          
                  .BYTE $3D29,  param
                  .ENDM
ANDDopOi          .MACRO param
                  .BYTE $3E29,  param
                  .ENDM
ANDDopQi          .MACRO param
                  .BYTE $3F29,  param
                  .ENDM                  

ANDEopAi          .MACRO param
                  .BYTE $4029,  param
                  .ENDM                
ANDEopBi          .MACRO param          
                  .BYTE $4129,  param
                  .ENDM
ANDEopCi          .MACRO param
                  .BYTE $4229,  param
                  .ENDM
ANDEopDi          .MACRO param
                  .BYTE $4329,  param
                  .ENDM
ANDEopEi          .MACRO param          
                  .BYTE $5029,  param
                  .ENDM
ANDEopFi          .MACRO param
                  .BYTE $5129,  param
                  .ENDM
ANDEopGi          .MACRO param
                  .BYTE $5229,  param
                  .ENDM                  
ANDEopHi          .MACRO param          
                  .BYTE $5329,  param
                  .ENDM
ANDEopIi          .MACRO param
                  .BYTE $6029,  param
                  .ENDM
ANDEopJi          .MACRO param
                  .BYTE $6129,  param
                  .ENDM
ANDEopKi          .MACRO param          
                  .BYTE $6229,  param
                  .ENDM
ANDEopLi          .MACRO param
                  .BYTE $6329,  param
                  .ENDM
ANDEopMi          .MACRO param
                  .BYTE $7029,  param
                  .ENDM                  
ANDEopNi          .MACRO param          
                  .BYTE $7129,  param
                  .ENDM
ANDEopOi          .MACRO param
                  .BYTE $7229,  param
                  .ENDM
ANDEopQi          .MACRO param
                  .BYTE $7329,  param
                  .ENDM
                  
ANDFopAi          .MACRO param
                  .BYTE $4429,  param
                  .ENDM                
ANDFopBi          .MACRO param          
                  .BYTE $4529,  param
                  .ENDM
ANDFopCi          .MACRO param
                  .BYTE $4629,  param
                  .ENDM
ANDFopDi          .MACRO param
                  .BYTE $4729,  param
                  .ENDM
ANDFopEi          .MACRO param          
                  .BYTE $5429,  param
                  .ENDM
ANDFopFi          .MACRO param
                  .BYTE $5529,  param
                  .ENDM
ANDFopGi          .MACRO param
                  .BYTE $5629,  param
                  .ENDM                  
ANDFopHi          .MACRO param          
                  .BYTE $5729,  param
                  .ENDM
ANDFopIi          .MACRO param
                  .BYTE $6429,  param
                  .ENDM
ANDFopJi          .MACRO param
                  .BYTE $6529,  param
                  .ENDM
ANDFopKi          .MACRO param          
                  .BYTE $6629,  param
                  .ENDM
ANDFopLi          .MACRO param
                  .BYTE $6729,  param
                  .ENDM
ANDFopMi          .MACRO param
                  .BYTE $7429,  param
                  .ENDM                  
ANDFopNi          .MACRO param          
                  .BYTE $7529,  param
                  .ENDM
ANDFopOi          .MACRO param
                  .BYTE $7629,  param
                  .ENDM
ANDFopQi          .MACRO param
                  .BYTE $7729,  param
                  .ENDM                  
                           
ANDGopAi          .MACRO param
                  .BYTE $4829,  param
                  .ENDM                
ANDGopBi          .MACRO param          
                  .BYTE $4929,  param
                  .ENDM
ANDGopCi          .MACRO param
                  .BYTE $4A29,  param
                  .ENDM
ANDGopDi          .MACRO param
                  .BYTE $4B29,  param
                  .ENDM
ANDGopEi          .MACRO param          
                  .BYTE $5829,  param
                  .ENDM
ANDGopFi          .MACRO param
                  .BYTE $5929,  param
                  .ENDM
ANDGopGi          .MACRO param
                  .BYTE $5A29,  param
                  .ENDM                  
ANDGopHi          .MACRO param          
                  .BYTE $5B29,  param
                  .ENDM
ANDGopIi          .MACRO param
                  .BYTE $6829,  param
                  .ENDM
ANDGopJi          .MACRO param
                  .BYTE $6929,  param
                  .ENDM
ANDGopKi          .MACRO param          
                  .BYTE $6A29,  param
                  .ENDM
ANDGopLi          .MACRO param
                  .BYTE $6B29,  param
                  .ENDM
ANDGopMi          .MACRO param
                  .BYTE $7829,  param
                  .ENDM                  
ANDGopNi          .MACRO param          
                  .BYTE $7929,  param
                  .ENDM
ANDGopOi          .MACRO param
                  .BYTE $7A29,  param
                  .ENDM
ANDGopQi          .MACRO param
                  .BYTE $7B29,  param
                  .ENDM
                  
ANDHopAi          .MACRO param
                  .BYTE $4C29,  param
                  .ENDM                
ANDHopBi          .MACRO param          
                  .BYTE $4D29,  param
                  .ENDM
ANDHopCi          .MACRO param
                  .BYTE $4E29,  param
                  .ENDM
ANDHopDi          .MACRO param
                  .BYTE $4F29,  param
                  .ENDM
ANDHopEi          .MACRO param          
                  .BYTE $5C29,  param
                  .ENDM
ANDHopFi          .MACRO param
                  .BYTE $5D29,  param
                  .ENDM
ANDHopGi          .MACRO param
                  .BYTE $5E29,  param
                  .ENDM                  
ANDHopHi          .MACRO param          
                  .BYTE $5F29,  param
                  .ENDM
ANDHopIi          .MACRO param
                  .BYTE $6C29,  param
                  .ENDM
ANDHopJi          .MACRO param
                  .BYTE $6D29,  param
                  .ENDM
ANDHopKi          .MACRO param          
                  .BYTE $6E29,  param
                  .ENDM
ANDHopLi          .MACRO param
                  .BYTE $6F29,  param
                  .ENDM
ANDHopMi          .MACRO param
                  .BYTE $7C29,  param
                  .ENDM                  
ANDHopNi          .MACRO param          
                  .BYTE $7D29,  param
                  .ENDM
ANDHopOi          .MACRO param
                  .BYTE $7E29,  param
                  .ENDM
ANDHopQi          .MACRO param
                  .BYTE $7F29,  param
                  .ENDM
                  
ANDIopAi          .MACRO param
                  .BYTE $8029,  param
                  .ENDM                
ANDIopBi          .MACRO param          
                  .BYTE $8129,  param
                  .ENDM
ANDIopCi          .MACRO param
                  .BYTE $8229,  param
                  .ENDM
ANDIopDi          .MACRO param
                  .BYTE $8329,  param
                  .ENDM
ANDIopEi          .MACRO param          
                  .BYTE $9029,  param
                  .ENDM
ANDIopFi          .MACRO param
                  .BYTE $9129,  param
                  .ENDM
ANDIopGi          .MACRO param
                  .BYTE $9229,  param
                  .ENDM                  
ANDIopHi          .MACRO param          
                  .BYTE $9329,  param
                  .ENDM
ANDIopIi          .MACRO param
                  .BYTE $A029,  param
                  .ENDM
ANDIopJi          .MACRO param
                  .BYTE $A129,  param
                  .ENDM
ANDIopKi          .MACRO param          
                  .BYTE $A229,  param
                  .ENDM
ANDIopLi          .MACRO param
                  .BYTE $A329,  param
                  .ENDM
ANDIopMi          .MACRO param
                  .BYTE $B029,  param
                  .ENDM                  
ANDIopNi          .MACRO param          
                  .BYTE $B129,  param
                  .ENDM
ANDIopOi          .MACRO param
                  .BYTE $B229,  param
                  .ENDM
ANDIopQi          .MACRO param
                  .BYTE $B329,  param
                  .ENDM
                  
ANDJopAi          .MACRO param
                  .BYTE $8429,  param
                  .ENDM                
ANDJopBi          .MACRO param          
                  .BYTE $8529,  param
                  .ENDM
ANDJopCi          .MACRO param
                  .BYTE $8629,  param
                  .ENDM
ANDJopDi          .MACRO param
                  .BYTE $8729,  param
                  .ENDM
ANDJopEi          .MACRO param          
                  .BYTE $9429,  param
                  .ENDM
ANDJopFi          .MACRO param
                  .BYTE $9529,  param
                  .ENDM
ANDJopGi          .MACRO param
                  .BYTE $9629,  param
                  .ENDM                  
ANDJopHi          .MACRO param          
                  .BYTE $9729,  param
                  .ENDM
ANDJopIi          .MACRO param
                  .BYTE $A429,  param
                  .ENDM
ANDJopJi          .MACRO param
                  .BYTE $A529,  param
                  .ENDM
ANDJopKi          .MACRO param          
                  .BYTE $A629,  param
                  .ENDM
ANDJopLi          .MACRO param
                  .BYTE $A729,  param
                  .ENDM
ANDJopMi          .MACRO param
                  .BYTE $B429,  param
                  .ENDM                  
ANDJopNi          .MACRO param          
                  .BYTE $B529,  param
                  .ENDM
ANDJopOi          .MACRO param
                  .BYTE $B629,  param
                  .ENDM
ANDJopQi          .MACRO param
                  .BYTE $B729,  param
                  .ENDM
                  
ANDKopAi          .MACRO param
                  .BYTE $8829,  param
                  .ENDM                
ANDKopBi          .MACRO param          
                  .BYTE $8929,  param
                  .ENDM
ANDKopCi          .MACRO param
                  .BYTE $8A29,  param
                  .ENDM
ANDKopDi          .MACRO param
                  .BYTE $8B29,  param
                  .ENDM
ANDKopEi          .MACRO param          
                  .BYTE $9829,  param
                  .ENDM
ANDKopFi          .MACRO param
                  .BYTE $9929,  param
                  .ENDM
ANDKopGi          .MACRO param
                  .BYTE $9A29,  param
                  .ENDM                  
ANDKopHi          .MACRO param          
                  .BYTE $9B29,  param
                  .ENDM
ANDKopIi          .MACRO param
                  .BYTE $A829,  param
                  .ENDM
ANDKopJi          .MACRO param
                  .BYTE $A929,  param
                  .ENDM
ANDKopKi          .MACRO param          
                  .BYTE $AA29,  param
                  .ENDM
ANDKopLi          .MACRO param
                  .BYTE $AB29,  param
                  .ENDM
ANDKopMi          .MACRO param
                  .BYTE $B829,  param
                  .ENDM                  
ANDKopNi          .MACRO param          
                  .BYTE $B929,  param
                  .ENDM
ANDKopOi          .MACRO param
                  .BYTE $BA29,  param
                  .ENDM
ANDKopQi          .MACRO param
                  .BYTE $BB29,  param
                  .ENDM
                  
ANDLopAi          .MACRO param
                  .BYTE $8C29,  param
                  .ENDM                
ANDLopBi          .MACRO param          
                  .BYTE $8D29,  param
                  .ENDM
ANDLopCi          .MACRO param
                  .BYTE $8E29,  param
                  .ENDM
ANDLopDi          .MACRO param
                  .BYTE $8F29,  param
                  .ENDM
ANDLopEi          .MACRO param          
                  .BYTE $9C29,  param
                  .ENDM
ANDLopFi          .MACRO param
                  .BYTE $9D29,  param
                  .ENDM
ANDLopGi          .MACRO param
                  .BYTE $9E29,  param
                  .ENDM                  
ANDLopHi          .MACRO param          
                  .BYTE $9F29,  param
                  .ENDM
ANDLopIi          .MACRO param
                  .BYTE $AC29,  param
                  .ENDM
ANDLopJi          .MACRO param
                  .BYTE $AD29,  param
                  .ENDM
ANDLopKi          .MACRO param          
                  .BYTE $AE29,  param
                  .ENDM
ANDLopLi          .MACRO param
                  .BYTE $AF29,  param
                  .ENDM
ANDLopMi          .MACRO param
                  .BYTE $BC29,  param
                  .ENDM                  
ANDLopNi          .MACRO param          
                  .BYTE $BD29,  param
                  .ENDM
ANDLopOi          .MACRO param
                  .BYTE $BE29,  param
                  .ENDM
ANDLopQi          .MACRO param
                  .BYTE $BF29,  param
                  .ENDM
                  
ANDMopAi          .MACRO param
                  .BYTE $C029,  param
                  .ENDM                
ANDMopBi          .MACRO param          
                  .BYTE $C129,  param
                  .ENDM
ANDMopCi          .MACRO param
                  .BYTE $C229,  param
                  .ENDM
ANDMopDi          .MACRO param
                  .BYTE $C329,  param
                  .ENDM
ANDMopEi          .MACRO param          
                  .BYTE $D029,  param
                  .ENDM
ANDMopFi          .MACRO param
                  .BYTE $D129,  param
                  .ENDM
ANDMopGi          .MACRO param
                  .BYTE $D229,  param
                  .ENDM                  
ANDMopHi          .MACRO param          
                  .BYTE $D329,  param
                  .ENDM
ANDMopIi          .MACRO param
                  .BYTE $E029,  param
                  .ENDM
ANDMopJi          .MACRO param
                  .BYTE $E129,  param
                  .ENDM
ANDMopKi          .MACRO param          
                  .BYTE $E229,  param
                  .ENDM
ANDMopLi          .MACRO param
                  .BYTE $E329,  param
                  .ENDM
ANDMopMi          .MACRO param
                  .BYTE $F029,  param
                  .ENDM                  
ANDMopNi          .MACRO param          
                  .BYTE $F129,  param
                  .ENDM
ANDMopOi          .MACRO param
                  .BYTE $F229,  param
                  .ENDM
ANDMopQi          .MACRO param
                  .BYTE $F329,  param
                  .ENDM
                  
ANDNopAi          .MACRO param
                  .BYTE $C429,  param
                  .ENDM                
ANDNopBi          .MACRO param          
                  .BYTE $C529,  param
                  .ENDM
ANDNopCi          .MACRO param
                  .BYTE $C629,  param
                  .ENDM
ANDNopDi          .MACRO param
                  .BYTE $C729,  param
                  .ENDM
ANDNopEi          .MACRO param          
                  .BYTE $D429,  param
                  .ENDM
ANDNopFi          .MACRO param
                  .BYTE $D529,  param
                  .ENDM
ANDNopGi          .MACRO param
                  .BYTE $D629,  param
                  .ENDM                  
ANDNopHi          .MACRO param          
                  .BYTE $D729,  param
                  .ENDM
ANDNopIi          .MACRO param
                  .BYTE $E429,  param
                  .ENDM
ANDNopJi          .MACRO param
                  .BYTE $E529,  param
                  .ENDM
ANDNopKi          .MACRO param          
                  .BYTE $E629,  param
                  .ENDM
ANDNopLi          .MACRO param
                  .BYTE $E729,  param
                  .ENDM
ANDNopMi          .MACRO param
                  .BYTE $F429,  param
                  .ENDM                  
ANDNopNi          .MACRO param          
                  .BYTE $F529,  param
                  .ENDM
ANDNopOi          .MACRO param
                  .BYTE $F629,  param
                  .ENDM
ANDNopQi          .MACRO param
                  .BYTE $F729,  param
                  .ENDM
            
ANDOopAi          .MACRO param
                  .BYTE $C829,  param
                  .ENDM                
ANDOopBi          .MACRO param          
                  .BYTE $C929,  param
                  .ENDM
ANDOopCi          .MACRO param
                  .BYTE $CA29,  param
                  .ENDM
ANDOopDi          .MACRO param
                  .BYTE $CB29,  param
                  .ENDM
ANDOopEi          .MACRO param          
                  .BYTE $D829,  param
                  .ENDM
ANDOopFi          .MACRO param
                  .BYTE $D929,  param
                  .ENDM
ANDOopGi          .MACRO param
                  .BYTE $DA29,  param
                  .ENDM                  
ANDOopHi          .MACRO param          
                  .BYTE $DB29,  param
                  .ENDM
ANDOopIi          .MACRO param
                  .BYTE $E829,  param
                  .ENDM
ANDOopJi          .MACRO param
                  .BYTE $E929,  param
                  .ENDM
ANDOopKi          .MACRO param          
                  .BYTE $EA29,  param
                  .ENDM
ANDOopLi          .MACRO param
                  .BYTE $EB29,  param
                  .ENDM
ANDOopMi          .MACRO param
                  .BYTE $F829,  param
                  .ENDM                  
ANDOopNi          .MACRO param          
                  .BYTE $F929,  param
                  .ENDM
ANDOopOi          .MACRO param
                  .BYTE $FA29,  param
                  .ENDM
ANDOopQi          .MACRO param
                  .BYTE $FB29,  param
                  .ENDM
                  
ANDQopAi          .MACRO param
                  .BYTE $CC29,  param
                  .ENDM                
ANDQopBi          .MACRO param          
                  .BYTE $CD29,  param
                  .ENDM
ANDQopCi          .MACRO param
                  .BYTE $CE29,  param
                  .ENDM
ANDQopDi          .MACRO param
                  .BYTE $CF29,  param
                  .ENDM
ANDQopEi          .MACRO param          
                  .BYTE $DC29,  param
                  .ENDM
ANDQopFi          .MACRO param
                  .BYTE $DD29,  param
                  .ENDM
ANDQopGi          .MACRO param
                  .BYTE $DE29,  param
                  .ENDM                  
ANDQopHi          .MACRO param          
                  .BYTE $DF29,  param
                  .ENDM
ANDQopIi          .MACRO param
                  .BYTE $EC29,  param
                  .ENDM
ANDQopJi          .MACRO param
                  .BYTE $ED29,  param
                  .ENDM
ANDQopKi          .MACRO param          
                  .BYTE $EE29,  param
                  .ENDM
ANDQopLi          .MACRO param
                  .BYTE $EF29,  param
                  .ENDM
ANDQopMi          .MACRO param
                  .BYTE $FC29,  param
                  .ENDM                  
ANDQopNi          .MACRO param          
                  .BYTE $FD29,  param
                  .ENDM
ANDQopOi          .MACRO param
                  .BYTE $FE29,  param
                  .ENDM
ANDQopQi          .MACRO param
                  .BYTE $FF29,  param
                  .ENDM
                  
;EOR #$xxxx             $0049
EORAopBi          .MACRO param          
                  .BYTE $0149,  param
                  .ENDM
EORAopCi          .MACRO param
                  .BYTE $0249,  param
                  .ENDM
EORAopDi          .MACRO param
                  .BYTE $0349,  param
                  .ENDM
EORAopEi          .MACRO param          
                  .BYTE $1049,  param
                  .ENDM
EORAopFi          .MACRO param
                  .BYTE $1149,  param
                  .ENDM
EORAopGi          .MACRO param
                  .BYTE $1249,  param
                  .ENDM                  
EORAopHi          .MACRO param          
                  .BYTE $1349,  param
                  .ENDM
EORAopIi          .MACRO param
                  .BYTE $2049,  param
                  .ENDM
EORAopJi          .MACRO param
                  .BYTE $2149,  param
                  .ENDM
EORAopKi          .MACRO param          
                  .BYTE $2249,  param
                  .ENDM
EORAopLi          .MACRO param
                  .BYTE $2349,  param
                  .ENDM
EORAopMi          .MACRO param
                  .BYTE $3049,  param
                  .ENDM                  
EORAopNi          .MACRO param          
                  .BYTE $3149,  param
                  .ENDM
EORAopOi          .MACRO param
                  .BYTE $3249,  param
                  .ENDM
EORAopQi          .MACRO param
                  .BYTE $3349,  param
                  .ENDM
                                    
EORBopAi          .MACRO param
                  .BYTE $0449,  param
                  .ENDM                
EORBopBi          .MACRO param          
                  .BYTE $0549,  param
                  .ENDM
EORBopCi          .MACRO param
                  .BYTE $0649,  param
                  .ENDM
EORBopDi          .MACRO param
                  .BYTE $0749,  param
                  .ENDM
EORBopEi          .MACRO param          
                  .BYTE $1449,  param
                  .ENDM
EORBopFi          .MACRO param
                  .BYTE $1549,  param
                  .ENDM
EORBopGi          .MACRO param
                  .BYTE $1649,  param
                  .ENDM                  
EORBopHi          .MACRO param          
                  .BYTE $1749,  param
                  .ENDM
EORBopIi          .MACRO param
                  .BYTE $2449,  param
                  .ENDM
EORBopJi          .MACRO param
                  .BYTE $2549,  param
                  .ENDM
EORBopKi          .MACRO param          
                  .BYTE $2649,  param
                  .ENDM
EORBopLi          .MACRO param
                  .BYTE $2749,  param
                  .ENDM
EORBopMi          .MACRO param
                  .BYTE $3049,  param
                  .ENDM                  
EORBopNi          .MACRO param          
                  .BYTE $3149,  param
                  .ENDM
EORBopOi          .MACRO param
                  .BYTE $3249,  param
                  .ENDM
EORBopQi          .MACRO param
                  .BYTE $3349,  param
                  .ENDM
                                    
EORCopAi          .MACRO param
                  .BYTE $0849,  param
                  .ENDM                
EORCopBi          .MACRO param          
                  .BYTE $0949,  param
                  .ENDM
EORCopCi          .MACRO param
                  .BYTE $0A49,  param
                  .ENDM
EORCopDi          .MACRO param
                  .BYTE $0B49,  param
                  .ENDM
EORCopEi          .MACRO param          
                  .BYTE $1849,  param
                  .ENDM
EORCopFi          .MACRO param
                  .BYTE $1949,  param
                  .ENDM
EORCopGi          .MACRO param
                  .BYTE $1A49,  param
                  .ENDM                  
EORCopHi          .MACRO param          
                  .BYTE $1B49,  param
                  .ENDM
EORCopIi          .MACRO param
                  .BYTE $2849,  param
                  .ENDM
EORCopJi          .MACRO param
                  .BYTE $2949,  param
                  .ENDM
EORCopKi          .MACRO param          
                  .BYTE $2A49,  param
                  .ENDM
EORCopLi          .MACRO param
                  .BYTE $2B49,  param
                  .ENDM
EORCopMi          .MACRO param
                  .BYTE $3849,  param
                  .ENDM                  
EORCopNi          .MACRO param          
                  .BYTE $3949,  param
                  .ENDM
EORCopOi          .MACRO param
                  .BYTE $3A49,  param
                  .ENDM
EORCopQi          .MACRO param
                  .BYTE $3B49,  param
                  .ENDM

EORDopAi          .MACRO param
                  .BYTE $0C49,  param
                  .ENDM                
EORDopBi          .MACRO param          
                  .BYTE $0D49,  param
                  .ENDM
EORDopCi          .MACRO param
                  .BYTE $0E49,  param
                  .ENDM
EORDopDi          .MACRO param
                  .BYTE $0F49,  param
                  .ENDM
EORDopEi          .MACRO param          
                  .BYTE $1C49,  param
                  .ENDM
EORDopFi          .MACRO param
                  .BYTE $1D49,  param
                  .ENDM
EORDopGi          .MACRO param
                  .BYTE $1E49,  param
                  .ENDM                  
EORDopHi          .MACRO param          
                  .BYTE $1F49,  param
                  .ENDM
EORDopIi          .MACRO param
                  .BYTE $2C49,  param
                  .ENDM
EORDopJi          .MACRO param
                  .BYTE $2D49,  param
                  .ENDM
EORDopKi          .MACRO param          
                  .BYTE $2E49,  param
                  .ENDM
EORDopLi          .MACRO param
                  .BYTE $2F49,  param
                  .ENDM
EORDopMi          .MACRO param
                  .BYTE $3C49,  param
                  .ENDM                  
EORDopNi          .MACRO param          
                  .BYTE $3D49,  param
                  .ENDM
EORDopOi          .MACRO param
                  .BYTE $3E49,  param
                  .ENDM
EORDopQi          .MACRO param
                  .BYTE $3F49,  param
                  .ENDM                  

EOREopAi          .MACRO param
                  .BYTE $4049,  param
                  .ENDM                
EOREopBi          .MACRO param          
                  .BYTE $4149,  param
                  .ENDM
EOREopCi          .MACRO param
                  .BYTE $4249,  param
                  .ENDM
EOREopDi          .MACRO param
                  .BYTE $4349,  param
                  .ENDM
EOREopEi          .MACRO param          
                  .BYTE $5049,  param
                  .ENDM
EOREopFi          .MACRO param
                  .BYTE $5149,  param
                  .ENDM
EOREopGi          .MACRO param
                  .BYTE $5249,  param
                  .ENDM                  
EOREopHi          .MACRO param          
                  .BYTE $5349,  param
                  .ENDM
EOREopIi          .MACRO param
                  .BYTE $6049,  param
                  .ENDM
EOREopJi          .MACRO param
                  .BYTE $6149,  param
                  .ENDM
EOREopKi          .MACRO param          
                  .BYTE $6249,  param
                  .ENDM
EOREopLi          .MACRO param
                  .BYTE $6349,  param
                  .ENDM
EOREopMi          .MACRO param
                  .BYTE $7049,  param
                  .ENDM                  
EOREopNi          .MACRO param          
                  .BYTE $7149,  param
                  .ENDM
EOREopOi          .MACRO param
                  .BYTE $7249,  param
                  .ENDM
EOREopQi          .MACRO param
                  .BYTE $7349,  param
                  .ENDM
                  
EORFopAi          .MACRO param
                  .BYTE $4449,  param
                  .ENDM                
EORFopBi          .MACRO param          
                  .BYTE $4549,  param
                  .ENDM
EORFopCi          .MACRO param
                  .BYTE $4649,  param
                  .ENDM
EORFopDi          .MACRO param
                  .BYTE $4749,  param
                  .ENDM
EORFopEi          .MACRO param          
                  .BYTE $5449,  param
                  .ENDM
EORFopFi          .MACRO param
                  .BYTE $5549,  param
                  .ENDM
EORFopGi          .MACRO param
                  .BYTE $5649,  param
                  .ENDM                  
EORFopHi          .MACRO param          
                  .BYTE $5749,  param
                  .ENDM
EORFopIi          .MACRO param
                  .BYTE $6449,  param
                  .ENDM
EORFopJi          .MACRO param
                  .BYTE $6549,  param
                  .ENDM
EORFopKi          .MACRO param          
                  .BYTE $6649,  param
                  .ENDM
EORFopLi          .MACRO param
                  .BYTE $6749,  param
                  .ENDM
EORFopMi          .MACRO param
                  .BYTE $7449,  param
                  .ENDM                  
EORFopNi          .MACRO param          
                  .BYTE $7549,  param
                  .ENDM
EORFopOi          .MACRO param
                  .BYTE $7649,  param
                  .ENDM
EORFopQi          .MACRO param
                  .BYTE $7749,  param
                  .ENDM                  
                           
EORGopAi          .MACRO param
                  .BYTE $4849,  param
                  .ENDM                
EORGopBi          .MACRO param          
                  .BYTE $4949,  param
                  .ENDM
EORGopCi          .MACRO param
                  .BYTE $4A49,  param
                  .ENDM
EORGopDi          .MACRO param
                  .BYTE $4B49,  param
                  .ENDM
EORGopEi          .MACRO param          
                  .BYTE $5849,  param
                  .ENDM
EORGopFi          .MACRO param
                  .BYTE $5949,  param
                  .ENDM
EORGopGi          .MACRO param
                  .BYTE $5A49,  param
                  .ENDM                  
EORGopHi          .MACRO param          
                  .BYTE $5B49,  param
                  .ENDM
EORGopIi          .MACRO param
                  .BYTE $6849,  param
                  .ENDM
EORGopJi          .MACRO param
                  .BYTE $6949,  param
                  .ENDM
EORGopKi          .MACRO param          
                  .BYTE $6A49,  param
                  .ENDM
EORGopLi          .MACRO param
                  .BYTE $6B49,  param
                  .ENDM
EORGopMi          .MACRO param
                  .BYTE $7849,  param
                  .ENDM                  
EORGopNi          .MACRO param          
                  .BYTE $7949,  param
                  .ENDM
EORGopOi          .MACRO param
                  .BYTE $7A49,  param
                  .ENDM
EORGopQi          .MACRO param
                  .BYTE $7B49,  param
                  .ENDM
                  
EORHopAi          .MACRO param
                  .BYTE $4C49,  param
                  .ENDM                
EORHopBi          .MACRO param          
                  .BYTE $4D49,  param
                  .ENDM
EORHopCi          .MACRO param
                  .BYTE $4E49,  param
                  .ENDM
EORHopDi          .MACRO param
                  .BYTE $4F49,  param
                  .ENDM
EORHopEi          .MACRO param          
                  .BYTE $5C49,  param
                  .ENDM
EORHopFi          .MACRO param
                  .BYTE $5D49,  param
                  .ENDM
EORHopGi          .MACRO param
                  .BYTE $5E49,  param
                  .ENDM                  
EORHopHi          .MACRO param          
                  .BYTE $5F49,  param
                  .ENDM
EORHopIi          .MACRO param
                  .BYTE $6C49,  param
                  .ENDM
EORHopJi          .MACRO param
                  .BYTE $6D49,  param
                  .ENDM
EORHopKi          .MACRO param          
                  .BYTE $6E49,  param
                  .ENDM
EORHopLi          .MACRO param
                  .BYTE $6F49,  param
                  .ENDM
EORHopMi          .MACRO param
                  .BYTE $7C49,  param
                  .ENDM                  
EORHopNi          .MACRO param          
                  .BYTE $7D49,  param
                  .ENDM
EORHopOi          .MACRO param
                  .BYTE $7E49,  param
                  .ENDM
EORHopQi          .MACRO param
                  .BYTE $7F49,  param
                  .ENDM
                  
EORIopAi          .MACRO param
                  .BYTE $8049,  param
                  .ENDM                
EORIopBi          .MACRO param          
                  .BYTE $8149,  param
                  .ENDM
EORIopCi          .MACRO param
                  .BYTE $8249,  param
                  .ENDM
EORIopDi          .MACRO param
                  .BYTE $8349,  param
                  .ENDM
EORIopEi          .MACRO param          
                  .BYTE $9049,  param
                  .ENDM
EORIopFi          .MACRO param
                  .BYTE $9149,  param
                  .ENDM
EORIopGi          .MACRO param
                  .BYTE $9249,  param
                  .ENDM                  
EORIopHi          .MACRO param          
                  .BYTE $9349,  param
                  .ENDM
EORIopIi          .MACRO param
                  .BYTE $A049,  param
                  .ENDM
EORIopJi          .MACRO param
                  .BYTE $A149,  param
                  .ENDM
EORIopKi          .MACRO param          
                  .BYTE $A249,  param
                  .ENDM
EORIopLi          .MACRO param
                  .BYTE $A349,  param
                  .ENDM
EORIopMi          .MACRO param
                  .BYTE $B049,  param
                  .ENDM                  
EORIopNi          .MACRO param          
                  .BYTE $B149,  param
                  .ENDM
EORIopOi          .MACRO param
                  .BYTE $B249,  param
                  .ENDM
EORIopQi          .MACRO param
                  .BYTE $B349,  param
                  .ENDM
                  
EORJopAi          .MACRO param
                  .BYTE $8449,  param
                  .ENDM                
EORJopBi          .MACRO param          
                  .BYTE $8549,  param
                  .ENDM
EORJopCi          .MACRO param
                  .BYTE $8649,  param
                  .ENDM
EORJopDi          .MACRO param
                  .BYTE $8749,  param
                  .ENDM
EORJopEi          .MACRO param          
                  .BYTE $9449,  param
                  .ENDM
EORJopFi          .MACRO param
                  .BYTE $9549,  param
                  .ENDM
EORJopGi          .MACRO param
                  .BYTE $9649,  param
                  .ENDM                  
EORJopHi          .MACRO param          
                  .BYTE $9749,  param
                  .ENDM
EORJopIi          .MACRO param
                  .BYTE $A449,  param
                  .ENDM
EORJopJi          .MACRO param
                  .BYTE $A549,  param
                  .ENDM
EORJopKi          .MACRO param          
                  .BYTE $A649,  param
                  .ENDM
EORJopLi          .MACRO param
                  .BYTE $A749,  param
                  .ENDM
EORJopMi          .MACRO param
                  .BYTE $B449,  param
                  .ENDM                  
EORJopNi          .MACRO param          
                  .BYTE $B549,  param
                  .ENDM
EORJopOi          .MACRO param
                  .BYTE $B649,  param
                  .ENDM
EORJopQi          .MACRO param
                  .BYTE $B749,  param
                  .ENDM
                  
EORKopAi          .MACRO param
                  .BYTE $8849,  param
                  .ENDM                
EORKopBi          .MACRO param          
                  .BYTE $8949,  param
                  .ENDM
EORKopCi          .MACRO param
                  .BYTE $8A49,  param
                  .ENDM
EORKopDi          .MACRO param
                  .BYTE $8B49,  param
                  .ENDM
EORKopEi          .MACRO param          
                  .BYTE $9849,  param
                  .ENDM
EORKopFi          .MACRO param
                  .BYTE $9949,  param
                  .ENDM
EORKopGi          .MACRO param
                  .BYTE $9A49,  param
                  .ENDM                  
EORKopHi          .MACRO param          
                  .BYTE $9B49,  param
                  .ENDM
EORKopIi          .MACRO param
                  .BYTE $A849,  param
                  .ENDM
EORKopJi          .MACRO param
                  .BYTE $A949,  param
                  .ENDM
EORKopKi          .MACRO param          
                  .BYTE $AA49,  param
                  .ENDM
EORKopLi          .MACRO param
                  .BYTE $AB49,  param
                  .ENDM
EORKopMi          .MACRO param
                  .BYTE $B849,  param
                  .ENDM                  
EORKopNi          .MACRO param          
                  .BYTE $B949,  param
                  .ENDM
EORKopOi          .MACRO param
                  .BYTE $BA49,  param
                  .ENDM
EORKopQi          .MACRO param
                  .BYTE $BB49,  param
                  .ENDM
                  
EORLopAi          .MACRO param
                  .BYTE $8C49,  param
                  .ENDM                
EORLopBi          .MACRO param          
                  .BYTE $8D49,  param
                  .ENDM
EORLopCi          .MACRO param
                  .BYTE $8E49,  param
                  .ENDM
EORLopDi          .MACRO param
                  .BYTE $8F49,  param
                  .ENDM
EORLopEi          .MACRO param          
                  .BYTE $9C49,  param
                  .ENDM
EORLopFi          .MACRO param
                  .BYTE $9D49,  param
                  .ENDM
EORLopGi          .MACRO param
                  .BYTE $9E49,  param
                  .ENDM                  
EORLopHi          .MACRO param          
                  .BYTE $9F49,  param
                  .ENDM
EORLopIi          .MACRO param
                  .BYTE $AC49,  param
                  .ENDM
EORLopJi          .MACRO param
                  .BYTE $AD49,  param
                  .ENDM
EORLopKi          .MACRO param          
                  .BYTE $AE49,  param
                  .ENDM
EORLopLi          .MACRO param
                  .BYTE $AF49,  param
                  .ENDM
EORLopMi          .MACRO param
                  .BYTE $BC49,  param
                  .ENDM                  
EORLopNi          .MACRO param          
                  .BYTE $BD49,  param
                  .ENDM
EORLopOi          .MACRO param
                  .BYTE $BE49,  param
                  .ENDM
EORLopQi          .MACRO param
                  .BYTE $BF49,  param
                  .ENDM
                  
EORMopAi          .MACRO param
                  .BYTE $C049,  param
                  .ENDM                
EORMopBi          .MACRO param          
                  .BYTE $C149,  param
                  .ENDM
EORMopCi          .MACRO param
                  .BYTE $C249,  param
                  .ENDM
EORMopDi          .MACRO param
                  .BYTE $C349,  param
                  .ENDM
EORMopEi          .MACRO param          
                  .BYTE $D049,  param
                  .ENDM
EORMopFi          .MACRO param
                  .BYTE $D149,  param
                  .ENDM
EORMopGi          .MACRO param
                  .BYTE $D249,  param
                  .ENDM                  
EORMopHi          .MACRO param          
                  .BYTE $D349,  param
                  .ENDM
EORMopIi          .MACRO param
                  .BYTE $E049,  param
                  .ENDM
EORMopJi          .MACRO param
                  .BYTE $E149,  param
                  .ENDM
EORMopKi          .MACRO param          
                  .BYTE $E249,  param
                  .ENDM
EORMopLi          .MACRO param
                  .BYTE $E349,  param
                  .ENDM
EORMopMi          .MACRO param
                  .BYTE $F049,  param
                  .ENDM                  
EORMopNi          .MACRO param          
                  .BYTE $F149,  param
                  .ENDM
EORMopOi          .MACRO param
                  .BYTE $F249,  param
                  .ENDM
EORMopQi          .MACRO param
                  .BYTE $F349,  param
                  .ENDM
                  
EORNopAi          .MACRO param
                  .BYTE $C449,  param
                  .ENDM                
EORNopBi          .MACRO param          
                  .BYTE $C549,  param
                  .ENDM
EORNopCi          .MACRO param
                  .BYTE $C649,  param
                  .ENDM
EORNopDi          .MACRO param
                  .BYTE $C749,  param
                  .ENDM
EORNopEi          .MACRO param          
                  .BYTE $D449,  param
                  .ENDM
EORNopFi          .MACRO param
                  .BYTE $D549,  param
                  .ENDM
EORNopGi          .MACRO param
                  .BYTE $D649,  param
                  .ENDM                  
EORNopHi          .MACRO param          
                  .BYTE $D749,  param
                  .ENDM
EORNopIi          .MACRO param
                  .BYTE $E449,  param
                  .ENDM
EORNopJi          .MACRO param
                  .BYTE $E549,  param
                  .ENDM
EORNopKi          .MACRO param          
                  .BYTE $E649,  param
                  .ENDM
EORNopLi          .MACRO param
                  .BYTE $E749,  param
                  .ENDM
EORNopMi          .MACRO param
                  .BYTE $F449,  param
                  .ENDM                  
EORNopNi          .MACRO param          
                  .BYTE $F549,  param
                  .ENDM
EORNopOi          .MACRO param
                  .BYTE $F649,  param
                  .ENDM
EORNopQi          .MACRO param
                  .BYTE $F749,  param
                  .ENDM
            
EOROopAi          .MACRO param
                  .BYTE $C849,  param
                  .ENDM                
EOROopBi          .MACRO param          
                  .BYTE $C949,  param
                  .ENDM
EOROopCi          .MACRO param
                  .BYTE $CA49,  param
                  .ENDM
EOROopDi          .MACRO param
                  .BYTE $CB49,  param
                  .ENDM
EOROopEi          .MACRO param          
                  .BYTE $D849,  param
                  .ENDM
EOROopFi          .MACRO param
                  .BYTE $D949,  param
                  .ENDM
EOROopGi          .MACRO param
                  .BYTE $DA49,  param
                  .ENDM                  
EOROopHi          .MACRO param          
                  .BYTE $DB49,  param
                  .ENDM
EOROopIi          .MACRO param
                  .BYTE $E849,  param
                  .ENDM
EOROopJi          .MACRO param
                  .BYTE $E949,  param
                  .ENDM
EOROopKi          .MACRO param          
                  .BYTE $EA49,  param
                  .ENDM
EOROopLi          .MACRO param
                  .BYTE $EB49,  param
                  .ENDM
EOROopMi          .MACRO param
                  .BYTE $F849,  param
                  .ENDM                  
EOROopNi          .MACRO param          
                  .BYTE $F949,  param
                  .ENDM
EOROopOi          .MACRO param
                  .BYTE $FA49,  param
                  .ENDM
EOROopQi          .MACRO param
                  .BYTE $FB49,  param
                  .ENDM
                  
EORQopAi          .MACRO param
                  .BYTE $CC49,  param
                  .ENDM                
EORQopBi          .MACRO param          
                  .BYTE $CD49,  param
                  .ENDM
EORQopCi          .MACRO param
                  .BYTE $CE49,  param
                  .ENDM
EORQopDi          .MACRO param
                  .BYTE $CF49,  param
                  .ENDM
EORQopEi          .MACRO param          
                  .BYTE $DC49,  param
                  .ENDM
EORQopFi          .MACRO param
                  .BYTE $DD49,  param
                  .ENDM
EORQopGi          .MACRO param
                  .BYTE $DE49,  param
                  .ENDM                  
EORQopHi          .MACRO param          
                  .BYTE $DF49,  param
                  .ENDM
EORQopIi          .MACRO param
                  .BYTE $EC49,  param
                  .ENDM
EORQopJi          .MACRO param
                  .BYTE $ED49,  param
                  .ENDM
EORQopKi          .MACRO param          
                  .BYTE $EE49,  param
                  .ENDM
EORQopLi          .MACRO param
                  .BYTE $EF49,  param
                  .ENDM
EORQopMi          .MACRO param
                  .BYTE $FC49,  param
                  .ENDM                  
EORQopNi          .MACRO param          
                  .BYTE $FD49,  param
                  .ENDM
EORQopOi          .MACRO param
                  .BYTE $FE49,  param
                  .ENDM
EORQopQi          .MACRO param
                  .BYTE $FF49,  param
                  .ENDM

;ADC $xxxx              $0065
ADCAopBzp          .MACRO param          
                  .BYTE $0165,  param
                  .ENDM
ADCAopCzp          .MACRO param
                  .BYTE $0265,  param
                  .ENDM
ADCAopDzp          .MACRO param
                  .BYTE $0365,  param
                  .ENDM
ADCAopEzp          .MACRO param          
                  .BYTE $1065,  param
                  .ENDM
ADCAopFzp          .MACRO param
                  .BYTE $1165,  param
                  .ENDM
ADCAopGzp          .MACRO param
                  .BYTE $1265,  param
                  .ENDM                  
ADCAopHzp          .MACRO param          
                  .BYTE $1365,  param
                  .ENDM
ADCAopIzp          .MACRO param
                  .BYTE $2065,  param
                  .ENDM
ADCAopJzp          .MACRO param
                  .BYTE $2165,  param
                  .ENDM
ADCAopKzp          .MACRO param          
                  .BYTE $2265,  param
                  .ENDM
ADCAopLzp          .MACRO param
                  .BYTE $2365,  param
                  .ENDM
ADCAopMzp          .MACRO param
                  .BYTE $3065,  param
                  .ENDM                  
ADCAopNzp          .MACRO param          
                  .BYTE $3165,  param
                  .ENDM
ADCAopOzp          .MACRO param
                  .BYTE $3265,  param
                  .ENDM
ADCAopQzp          .MACRO param
                  .BYTE $3365,  param
                  .ENDM
                                    
ADCBopAzp          .MACRO param
                  .BYTE $0465,  param
                  .ENDM                
ADCBopBzp          .MACRO param          
                  .BYTE $0565,  param
                  .ENDM
ADCBopCzp          .MACRO param
                  .BYTE $0665,  param
                  .ENDM
ADCBopDzp          .MACRO param
                  .BYTE $0765,  param
                  .ENDM
ADCBopEzp          .MACRO param          
                  .BYTE $1465,  param
                  .ENDM
ADCBopFzp          .MACRO param
                  .BYTE $1565,  param
                  .ENDM
ADCBopGzp          .MACRO param
                  .BYTE $1665,  param
                  .ENDM                  
ADCBopHzp          .MACRO param          
                  .BYTE $1765,  param
                  .ENDM
ADCBopIzp          .MACRO param
                  .BYTE $2465,  param
                  .ENDM
ADCBopJzp          .MACRO param
                  .BYTE $2565,  param
                  .ENDM
ADCBopKzp          .MACRO param          
                  .BYTE $2665,  param
                  .ENDM
ADCBopLzp          .MACRO param
                  .BYTE $2765,  param
                  .ENDM
ADCBopMzp          .MACRO param
                  .BYTE $3065,  param
                  .ENDM                  
ADCBopNzp          .MACRO param          
                  .BYTE $3165,  param
                  .ENDM
ADCBopOzp          .MACRO param
                  .BYTE $3265,  param
                  .ENDM
ADCBopQzp          .MACRO param
                  .BYTE $3365,  param
                  .ENDM
                                    
ADCCopAzp          .MACRO param
                  .BYTE $0865,  param
                  .ENDM                
ADCCopBzp          .MACRO param          
                  .BYTE $0965,  param
                  .ENDM
ADCCopCzp          .MACRO param
                  .BYTE $0A65,  param
                  .ENDM
ADCCopDzp          .MACRO param
                  .BYTE $0B65,  param
                  .ENDM
ADCCopEzp          .MACRO param          
                  .BYTE $1865,  param
                  .ENDM
ADCCopFzp          .MACRO param
                  .BYTE $1965,  param
                  .ENDM
ADCCopGzp          .MACRO param
                  .BYTE $1A65,  param
                  .ENDM                  
ADCCopHzp          .MACRO param          
                  .BYTE $1B65,  param
                  .ENDM
ADCCopIzp          .MACRO param
                  .BYTE $2865,  param
                  .ENDM
ADCCopJzp          .MACRO param
                  .BYTE $2965,  param
                  .ENDM
ADCCopKzp          .MACRO param          
                  .BYTE $2A65,  param
                  .ENDM
ADCCopLzp          .MACRO param
                  .BYTE $2B65,  param
                  .ENDM
ADCCopMzp          .MACRO param
                  .BYTE $3865,  param
                  .ENDM                  
ADCCopNzp          .MACRO param          
                  .BYTE $3965,  param
                  .ENDM
ADCCopOzp          .MACRO param
                  .BYTE $3A65,  param
                  .ENDM
ADCCopQzp          .MACRO param
                  .BYTE $3B65,  param
                  .ENDM

ADCDopAzp          .MACRO param
                  .BYTE $0C65,  param
                  .ENDM                
ADCDopBzp          .MACRO param          
                  .BYTE $0D65,  param
                  .ENDM
ADCDopCzp          .MACRO param
                  .BYTE $0E65,  param
                  .ENDM
ADCDopDzp          .MACRO param
                  .BYTE $0F65,  param
                  .ENDM
ADCDopEzp          .MACRO param          
                  .BYTE $1C65,  param
                  .ENDM
ADCDopFzp          .MACRO param
                  .BYTE $1D65,  param
                  .ENDM
ADCDopGzp          .MACRO param
                  .BYTE $1E65,  param
                  .ENDM                  
ADCDopHzp          .MACRO param          
                  .BYTE $1F65,  param
                  .ENDM
ADCDopIzp          .MACRO param
                  .BYTE $2C65,  param
                  .ENDM
ADCDopJzp          .MACRO param
                  .BYTE $2D65,  param
                  .ENDM
ADCDopKzp          .MACRO param          
                  .BYTE $2E65,  param
                  .ENDM
ADCDopLzp          .MACRO param
                  .BYTE $2F65,  param
                  .ENDM
ADCDopMzp          .MACRO param
                  .BYTE $3C65,  param
                  .ENDM                  
ADCDopNzp          .MACRO param          
                  .BYTE $3D65,  param
                  .ENDM
ADCDopOzp          .MACRO param
                  .BYTE $3E65,  param
                  .ENDM
ADCDopQzp          .MACRO param
                  .BYTE $3F65,  param
                  .ENDM                  

ADCEopAzp          .MACRO param
                  .BYTE $4065,  param
                  .ENDM                
ADCEopBzp          .MACRO param          
                  .BYTE $4165,  param
                  .ENDM
ADCEopCzp          .MACRO param
                  .BYTE $4265,  param
                  .ENDM
ADCEopDzp          .MACRO param
                  .BYTE $4365,  param
                  .ENDM
ADCEopEzp          .MACRO param          
                  .BYTE $5065,  param
                  .ENDM
ADCEopFzp          .MACRO param
                  .BYTE $5165,  param
                  .ENDM
ADCEopGzp          .MACRO param
                  .BYTE $5265,  param
                  .ENDM                  
ADCEopHzp          .MACRO param          
                  .BYTE $5365,  param
                  .ENDM
ADCEopIzp          .MACRO param
                  .BYTE $6065,  param
                  .ENDM
ADCEopJzp          .MACRO param
                  .BYTE $6165,  param
                  .ENDM
ADCEopKzp          .MACRO param          
                  .BYTE $6265,  param
                  .ENDM
ADCEopLzp          .MACRO param
                  .BYTE $6365,  param
                  .ENDM
ADCEopMzp          .MACRO param
                  .BYTE $7065,  param
                  .ENDM                  
ADCEopNzp          .MACRO param          
                  .BYTE $7165,  param
                  .ENDM
ADCEopOzp          .MACRO param
                  .BYTE $7265,  param
                  .ENDM
ADCEopQzp          .MACRO param
                  .BYTE $7365,  param
                  .ENDM
                  
ADCFopAzp          .MACRO param
                  .BYTE $4465,  param
                  .ENDM                
ADCFopBzp          .MACRO param          
                  .BYTE $4565,  param
                  .ENDM
ADCFopCzp          .MACRO param
                  .BYTE $4665,  param
                  .ENDM
ADCFopDzp          .MACRO param
                  .BYTE $4765,  param
                  .ENDM
ADCFopEzp          .MACRO param          
                  .BYTE $5465,  param
                  .ENDM
ADCFopFzp          .MACRO param
                  .BYTE $5565,  param
                  .ENDM
ADCFopGzp          .MACRO param
                  .BYTE $5665,  param
                  .ENDM                  
ADCFopHzp          .MACRO param          
                  .BYTE $5765,  param
                  .ENDM
ADCFopIzp          .MACRO param
                  .BYTE $6465,  param
                  .ENDM
ADCFopJzp          .MACRO param
                  .BYTE $6565,  param
                  .ENDM
ADCFopKzp          .MACRO param          
                  .BYTE $6665,  param
                  .ENDM
ADCFopLzp          .MACRO param
                  .BYTE $6765,  param
                  .ENDM
ADCFopMzp          .MACRO param
                  .BYTE $7465,  param
                  .ENDM                  
ADCFopNzp          .MACRO param          
                  .BYTE $7565,  param
                  .ENDM
ADCFopOzp          .MACRO param
                  .BYTE $7665,  param
                  .ENDM
ADCFopQzp          .MACRO param
                  .BYTE $7765,  param
                  .ENDM                  
                           
ADCGopAzp          .MACRO param
                  .BYTE $4865,  param
                  .ENDM                
ADCGopBzp          .MACRO param          
                  .BYTE $4965,  param
                  .ENDM
ADCGopCzp          .MACRO param
                  .BYTE $4A65,  param
                  .ENDM
ADCGopDzp          .MACRO param
                  .BYTE $4B65,  param
                  .ENDM
ADCGopEzp          .MACRO param          
                  .BYTE $5865,  param
                  .ENDM
ADCGopFzp          .MACRO param
                  .BYTE $5965,  param
                  .ENDM
ADCGopGzp          .MACRO param
                  .BYTE $5A65,  param
                  .ENDM                  
ADCGopHzp          .MACRO param          
                  .BYTE $5B65,  param
                  .ENDM
ADCGopIzp          .MACRO param
                  .BYTE $6865,  param
                  .ENDM
ADCGopJzp          .MACRO param
                  .BYTE $6965,  param
                  .ENDM
ADCGopKzp          .MACRO param          
                  .BYTE $6A65,  param
                  .ENDM
ADCGopLzp          .MACRO param
                  .BYTE $6B65,  param
                  .ENDM
ADCGopMzp          .MACRO param
                  .BYTE $7865,  param
                  .ENDM                  
ADCGopNzp          .MACRO param          
                  .BYTE $7965,  param
                  .ENDM
ADCGopOzp          .MACRO param
                  .BYTE $7A65,  param
                  .ENDM
ADCGopQzp          .MACRO param
                  .BYTE $7B65,  param
                  .ENDM
                  
ADCHopAzp          .MACRO param
                  .BYTE $4C65,  param
                  .ENDM                
ADCHopBzp          .MACRO param          
                  .BYTE $4D65,  param
                  .ENDM
ADCHopCzp          .MACRO param
                  .BYTE $4E65,  param
                  .ENDM
ADCHopDzp          .MACRO param
                  .BYTE $4F65,  param
                  .ENDM
ADCHopEzp          .MACRO param          
                  .BYTE $5C65,  param
                  .ENDM
ADCHopFzp          .MACRO param
                  .BYTE $5D65,  param
                  .ENDM
ADCHopGzp          .MACRO param
                  .BYTE $5E65,  param
                  .ENDM                  
ADCHopHzp          .MACRO param          
                  .BYTE $5F65,  param
                  .ENDM
ADCHopIzp          .MACRO param
                  .BYTE $6C65,  param
                  .ENDM
ADCHopJzp          .MACRO param
                  .BYTE $6D65,  param
                  .ENDM
ADCHopKzp          .MACRO param          
                  .BYTE $6E65,  param
                  .ENDM
ADCHopLzp          .MACRO param
                  .BYTE $6F65,  param
                  .ENDM
ADCHopMzp          .MACRO param
                  .BYTE $7C65,  param
                  .ENDM                  
ADCHopNzp          .MACRO param          
                  .BYTE $7D65,  param
                  .ENDM
ADCHopOzp          .MACRO param
                  .BYTE $7E65,  param
                  .ENDM
ADCHopQzp          .MACRO param
                  .BYTE $7F65,  param
                  .ENDM
                  
ADCIopAzp          .MACRO param
                  .BYTE $8065,  param
                  .ENDM                
ADCIopBzp          .MACRO param          
                  .BYTE $8165,  param
                  .ENDM
ADCIopCzp          .MACRO param
                  .BYTE $8265,  param
                  .ENDM
ADCIopDzp          .MACRO param
                  .BYTE $8365,  param
                  .ENDM
ADCIopEzp          .MACRO param          
                  .BYTE $9065,  param
                  .ENDM
ADCIopFzp          .MACRO param
                  .BYTE $9165,  param
                  .ENDM
ADCIopGzp          .MACRO param
                  .BYTE $9265,  param
                  .ENDM                  
ADCIopHzp          .MACRO param          
                  .BYTE $9365,  param
                  .ENDM
ADCIopIzp          .MACRO param
                  .BYTE $A065,  param
                  .ENDM
ADCIopJzp          .MACRO param
                  .BYTE $A165,  param
                  .ENDM
ADCIopKzp          .MACRO param          
                  .BYTE $A265,  param
                  .ENDM
ADCIopLzp          .MACRO param
                  .BYTE $A365,  param
                  .ENDM
ADCIopMzp          .MACRO param
                  .BYTE $B065,  param
                  .ENDM                  
ADCIopNzp          .MACRO param          
                  .BYTE $B165,  param
                  .ENDM
ADCIopOzp          .MACRO param
                  .BYTE $B265,  param
                  .ENDM
ADCIopQzp          .MACRO param
                  .BYTE $B365,  param
                  .ENDM
                  
ADCJopAzp          .MACRO param
                  .BYTE $8465,  param
                  .ENDM                
ADCJopBzp          .MACRO param          
                  .BYTE $8565,  param
                  .ENDM
ADCJopCzp          .MACRO param
                  .BYTE $8665,  param
                  .ENDM
ADCJopDzp          .MACRO param
                  .BYTE $8765,  param
                  .ENDM
ADCJopEzp          .MACRO param          
                  .BYTE $9465,  param
                  .ENDM
ADCJopFzp          .MACRO param
                  .BYTE $9565,  param
                  .ENDM
ADCJopGzp          .MACRO param
                  .BYTE $9665,  param
                  .ENDM                  
ADCJopHzp          .MACRO param          
                  .BYTE $9765,  param
                  .ENDM
ADCJopIzp          .MACRO param
                  .BYTE $A465,  param
                  .ENDM
ADCJopJzp          .MACRO param
                  .BYTE $A565,  param
                  .ENDM
ADCJopKzp          .MACRO param          
                  .BYTE $A665,  param
                  .ENDM
ADCJopLzp          .MACRO param
                  .BYTE $A765,  param
                  .ENDM
ADCJopMzp          .MACRO param
                  .BYTE $B465,  param
                  .ENDM                  
ADCJopNzp          .MACRO param          
                  .BYTE $B565,  param
                  .ENDM
ADCJopOzp          .MACRO param
                  .BYTE $B665,  param
                  .ENDM
ADCJopQzp          .MACRO param
                  .BYTE $B765,  param
                  .ENDM
                  
ADCKopAzp          .MACRO param
                  .BYTE $8865,  param
                  .ENDM                
ADCKopBzp          .MACRO param          
                  .BYTE $8965,  param
                  .ENDM
ADCKopCzp          .MACRO param
                  .BYTE $8A65,  param
                  .ENDM
ADCKopDzp          .MACRO param
                  .BYTE $8B65,  param
                  .ENDM
ADCKopEzp          .MACRO param          
                  .BYTE $9865,  param
                  .ENDM
ADCKopFzp          .MACRO param
                  .BYTE $9965,  param
                  .ENDM
ADCKopGzp          .MACRO param
                  .BYTE $9A65,  param
                  .ENDM                  
ADCKopHzp          .MACRO param          
                  .BYTE $9B65,  param
                  .ENDM
ADCKopIzp          .MACRO param
                  .BYTE $A865,  param
                  .ENDM
ADCKopJzp          .MACRO param
                  .BYTE $A965,  param
                  .ENDM
ADCKopKzp          .MACRO param          
                  .BYTE $AA65,  param
                  .ENDM
ADCKopLzp          .MACRO param
                  .BYTE $AB65,  param
                  .ENDM
ADCKopMzp          .MACRO param
                  .BYTE $B865,  param
                  .ENDM                  
ADCKopNzp          .MACRO param          
                  .BYTE $B965,  param
                  .ENDM
ADCKopOzp          .MACRO param
                  .BYTE $BA65,  param
                  .ENDM
ADCKopQzp          .MACRO param
                  .BYTE $BB65,  param
                  .ENDM
                  
ADCLopAzp          .MACRO param
                  .BYTE $8C65,  param
                  .ENDM                
ADCLopBzp          .MACRO param          
                  .BYTE $8D65,  param
                  .ENDM
ADCLopCzp          .MACRO param
                  .BYTE $8E65,  param
                  .ENDM
ADCLopDzp          .MACRO param
                  .BYTE $8F65,  param
                  .ENDM
ADCLopEzp          .MACRO param          
                  .BYTE $9C65,  param
                  .ENDM
ADCLopFzp          .MACRO param
                  .BYTE $9D65,  param
                  .ENDM
ADCLopGzp          .MACRO param
                  .BYTE $9E65,  param
                  .ENDM                  
ADCLopHzp          .MACRO param          
                  .BYTE $9F65,  param
                  .ENDM
ADCLopIzp          .MACRO param
                  .BYTE $AC65,  param
                  .ENDM
ADCLopJzp          .MACRO param
                  .BYTE $AD65,  param
                  .ENDM
ADCLopKzp          .MACRO param          
                  .BYTE $AE65,  param
                  .ENDM
ADCLopLzp          .MACRO param
                  .BYTE $AF65,  param
                  .ENDM
ADCLopMzp          .MACRO param
                  .BYTE $BC65,  param
                  .ENDM                  
ADCLopNzp          .MACRO param          
                  .BYTE $BD65,  param
                  .ENDM
ADCLopOzp          .MACRO param
                  .BYTE $BE65,  param
                  .ENDM
ADCLopQzp          .MACRO param
                  .BYTE $BF65,  param
                  .ENDM
                  
ADCMopAzp          .MACRO param
                  .BYTE $C065,  param
                  .ENDM                
ADCMopBzp          .MACRO param          
                  .BYTE $C165,  param
                  .ENDM
ADCMopCzp          .MACRO param
                  .BYTE $C265,  param
                  .ENDM
ADCMopDzp          .MACRO param
                  .BYTE $C365,  param
                  .ENDM
ADCMopEzp          .MACRO param          
                  .BYTE $D065,  param
                  .ENDM
ADCMopFzp          .MACRO param
                  .BYTE $D165,  param
                  .ENDM
ADCMopGzp          .MACRO param
                  .BYTE $D265,  param
                  .ENDM                  
ADCMopHzp          .MACRO param          
                  .BYTE $D365,  param
                  .ENDM
ADCMopIzp          .MACRO param
                  .BYTE $E065,  param
                  .ENDM
ADCMopJzp          .MACRO param
                  .BYTE $E165,  param
                  .ENDM
ADCMopKzp          .MACRO param          
                  .BYTE $E265,  param
                  .ENDM
ADCMopLzp          .MACRO param
                  .BYTE $E365,  param
                  .ENDM
ADCMopMzp          .MACRO param
                  .BYTE $F065,  param
                  .ENDM                  
ADCMopNzp          .MACRO param          
                  .BYTE $F165,  param
                  .ENDM
ADCMopOzp          .MACRO param
                  .BYTE $F265,  param
                  .ENDM
ADCMopQzp          .MACRO param
                  .BYTE $F365,  param
                  .ENDM
                  
ADCNopAzp          .MACRO param
                  .BYTE $C465,  param
                  .ENDM                
ADCNopBzp          .MACRO param          
                  .BYTE $C565,  param
                  .ENDM
ADCNopCzp          .MACRO param
                  .BYTE $C665,  param
                  .ENDM
ADCNopDzp          .MACRO param
                  .BYTE $C765,  param
                  .ENDM
ADCNopEzp          .MACRO param          
                  .BYTE $D465,  param
                  .ENDM
ADCNopFzp          .MACRO param
                  .BYTE $D565,  param
                  .ENDM
ADCNopGzp          .MACRO param
                  .BYTE $D665,  param
                  .ENDM                  
ADCNopHzp          .MACRO param          
                  .BYTE $D765,  param
                  .ENDM
ADCNopIzp          .MACRO param
                  .BYTE $E465,  param
                  .ENDM
ADCNopJzp          .MACRO param
                  .BYTE $E565,  param
                  .ENDM
ADCNopKzp          .MACRO param          
                  .BYTE $E665,  param
                  .ENDM
ADCNopLzp          .MACRO param
                  .BYTE $E765,  param
                  .ENDM
ADCNopMzp          .MACRO param
                  .BYTE $F465,  param
                  .ENDM                  
ADCNopNzp          .MACRO param          
                  .BYTE $F565,  param
                  .ENDM
ADCNopOzp          .MACRO param
                  .BYTE $F665,  param
                  .ENDM
ADCNopQzp          .MACRO param
                  .BYTE $F765,  param
                  .ENDM
            
ADCOopAzp          .MACRO param
                  .BYTE $C865,  param
                  .ENDM                
ADCOopBzp          .MACRO param          
                  .BYTE $C965,  param
                  .ENDM
ADCOopCzp          .MACRO param
                  .BYTE $CA65,  param
                  .ENDM
ADCOopDzp          .MACRO param
                  .BYTE $CB65,  param
                  .ENDM
ADCOopEzp          .MACRO param          
                  .BYTE $D865,  param
                  .ENDM
ADCOopFzp          .MACRO param
                  .BYTE $D965,  param
                  .ENDM
ADCOopGzp          .MACRO param
                  .BYTE $DA65,  param
                  .ENDM                  
ADCOopHzp          .MACRO param          
                  .BYTE $DB65,  param
                  .ENDM
ADCOopIzp          .MACRO param
                  .BYTE $E865,  param
                  .ENDM
ADCOopJzp          .MACRO param
                  .BYTE $E965,  param
                  .ENDM
ADCOopKzp          .MACRO param          
                  .BYTE $EA65,  param
                  .ENDM
ADCOopLzp          .MACRO param
                  .BYTE $EB65,  param
                  .ENDM
ADCOopMzp          .MACRO param
                  .BYTE $F865,  param
                  .ENDM                  
ADCOopNzp          .MACRO param          
                  .BYTE $F965,  param
                  .ENDM
ADCOopOzp          .MACRO param
                  .BYTE $FA65,  param
                  .ENDM
ADCOopQzp          .MACRO param
                  .BYTE $FB65,  param
                  .ENDM
                  
ADCQopAzp          .MACRO param
                  .BYTE $CC65,  param
                  .ENDM                
ADCQopBzp          .MACRO param          
                  .BYTE $CD65,  param
                  .ENDM
ADCQopCzp          .MACRO param
                  .BYTE $CE65,  param
                  .ENDM
ADCQopDzp          .MACRO param
                  .BYTE $CF65,  param
                  .ENDM
ADCQopEzp          .MACRO param          
                  .BYTE $DC65,  param
                  .ENDM
ADCQopFzp          .MACRO param
                  .BYTE $DD65,  param
                  .ENDM
ADCQopGzp          .MACRO param
                  .BYTE $DE65,  param
                  .ENDM                  
ADCQopHzp          .MACRO param          
                  .BYTE $DF65,  param
                  .ENDM
ADCQopIzp          .MACRO param
                  .BYTE $EC65,  param
                  .ENDM
ADCQopJzp          .MACRO param
                  .BYTE $ED65,  param
                  .ENDM
ADCQopKzp          .MACRO param          
                  .BYTE $EE65,  param
                  .ENDM
ADCQopLzp          .MACRO param
                  .BYTE $EF65,  param
                  .ENDM
ADCQopMzp          .MACRO param
                  .BYTE $FC65,  param
                  .ENDM                  
ADCQopNzp          .MACRO param          
                  .BYTE $FD65,  param
                  .ENDM
ADCQopOzp          .MACRO param
                  .BYTE $FE65,  param
                  .ENDM
ADCQopQzp          .MACRO param
                  .BYTE $FF65,  param
                  .ENDM

;SBC $xxxx              $00E5
SBCAopBzp          .MACRO param          
                  .BYTE $01E5,  param
                  .ENDM
SBCAopCzp          .MACRO param
                  .BYTE $02E5,  param
                  .ENDM
SBCAopDzp          .MACRO param
                  .BYTE $03E5,  param
                  .ENDM
SBCAopEzp          .MACRO param          
                  .BYTE $10E5,  param
                  .ENDM
SBCAopFzp          .MACRO param
                  .BYTE $11E5,  param
                  .ENDM
SBCAopGzp          .MACRO param
                  .BYTE $12E5,  param
                  .ENDM                  
SBCAopHzp          .MACRO param          
                  .BYTE $13E5,  param
                  .ENDM
SBCAopIzp          .MACRO param
                  .BYTE $20E5,  param
                  .ENDM
SBCAopJzp          .MACRO param
                  .BYTE $21E5,  param
                  .ENDM
SBCAopKzp          .MACRO param          
                  .BYTE $22E5,  param
                  .ENDM
SBCAopLzp          .MACRO param
                  .BYTE $23E5,  param
                  .ENDM
SBCAopMzp          .MACRO param
                  .BYTE $30E5,  param
                  .ENDM                  
SBCAopNzp          .MACRO param          
                  .BYTE $31E5,  param
                  .ENDM
SBCAopOzp          .MACRO param
                  .BYTE $32E5,  param
                  .ENDM
SBCAopQzp          .MACRO param
                  .BYTE $33E5,  param
                  .ENDM
                                    
SBCBopAzp          .MACRO param
                  .BYTE $04E5,  param
                  .ENDM                
SBCBopBzp          .MACRO param          
                  .BYTE $05E5,  param
                  .ENDM
SBCBopCzp          .MACRO param
                  .BYTE $06E5,  param
                  .ENDM
SBCBopDzp          .MACRO param
                  .BYTE $07E5,  param
                  .ENDM
SBCBopEzp          .MACRO param          
                  .BYTE $14E5,  param
                  .ENDM
SBCBopFzp          .MACRO param
                  .BYTE $15E5,  param
                  .ENDM
SBCBopGzp          .MACRO param
                  .BYTE $16E5,  param
                  .ENDM                  
SBCBopHzp          .MACRO param          
                  .BYTE $17E5,  param
                  .ENDM
SBCBopIzp          .MACRO param
                  .BYTE $24E5,  param
                  .ENDM
SBCBopJzp          .MACRO param
                  .BYTE $25E5,  param
                  .ENDM
SBCBopKzp          .MACRO param          
                  .BYTE $26E5,  param
                  .ENDM
SBCBopLzp          .MACRO param
                  .BYTE $27E5,  param
                  .ENDM
SBCBopMzp          .MACRO param
                  .BYTE $30E5,  param
                  .ENDM                  
SBCBopNzp          .MACRO param          
                  .BYTE $31E5,  param
                  .ENDM
SBCBopOzp          .MACRO param
                  .BYTE $32E5,  param
                  .ENDM
SBCBopQzp          .MACRO param
                  .BYTE $33E5,  param
                  .ENDM
                                    
SBCCopAzp          .MACRO param
                  .BYTE $08E5,  param
                  .ENDM                
SBCCopBzp          .MACRO param          
                  .BYTE $09E5,  param
                  .ENDM
SBCCopCzp          .MACRO param
                  .BYTE $0AE5,  param
                  .ENDM
SBCCopDzp          .MACRO param
                  .BYTE $0BE5,  param
                  .ENDM
SBCCopEzp          .MACRO param          
                  .BYTE $18E5,  param
                  .ENDM
SBCCopFzp          .MACRO param
                  .BYTE $19E5,  param
                  .ENDM
SBCCopGzp          .MACRO param
                  .BYTE $1AE5,  param
                  .ENDM                  
SBCCopHzp          .MACRO param          
                  .BYTE $1BE5,  param
                  .ENDM
SBCCopIzp          .MACRO param
                  .BYTE $28E5,  param
                  .ENDM
SBCCopJzp          .MACRO param
                  .BYTE $29E5,  param
                  .ENDM
SBCCopKzp          .MACRO param          
                  .BYTE $2AE5,  param
                  .ENDM
SBCCopLzp          .MACRO param
                  .BYTE $2BE5,  param
                  .ENDM
SBCCopMzp          .MACRO param
                  .BYTE $38E5,  param
                  .ENDM                  
SBCCopNzp          .MACRO param          
                  .BYTE $39E5,  param
                  .ENDM
SBCCopOzp          .MACRO param
                  .BYTE $3AE5,  param
                  .ENDM
SBCCopQzp          .MACRO param
                  .BYTE $3BE5,  param
                  .ENDM

SBCDopAzp          .MACRO param
                  .BYTE $0CE5,  param
                  .ENDM                
SBCDopBzp          .MACRO param          
                  .BYTE $0DE5,  param
                  .ENDM
SBCDopCzp          .MACRO param
                  .BYTE $0EE5,  param
                  .ENDM
SBCDopDzp          .MACRO param
                  .BYTE $0FE5,  param
                  .ENDM
SBCDopEzp          .MACRO param          
                  .BYTE $1CE5,  param
                  .ENDM
SBCDopFzp          .MACRO param
                  .BYTE $1DE5,  param
                  .ENDM
SBCDopGzp          .MACRO param
                  .BYTE $1EE5,  param
                  .ENDM                  
SBCDopHzp          .MACRO param          
                  .BYTE $1FE5,  param
                  .ENDM
SBCDopIzp          .MACRO param
                  .BYTE $2CE5,  param
                  .ENDM
SBCDopJzp          .MACRO param
                  .BYTE $2DE5,  param
                  .ENDM
SBCDopKzp          .MACRO param          
                  .BYTE $2EE5,  param
                  .ENDM
SBCDopLzp          .MACRO param
                  .BYTE $2FE5,  param
                  .ENDM
SBCDopMzp          .MACRO param
                  .BYTE $3CE5,  param
                  .ENDM                  
SBCDopNzp          .MACRO param          
                  .BYTE $3DE5,  param
                  .ENDM
SBCDopOzp          .MACRO param
                  .BYTE $3EE5,  param
                  .ENDM
SBCDopQzp          .MACRO param
                  .BYTE $3FE5,  param
                  .ENDM                  

SBCEopAzp          .MACRO param
                  .BYTE $40E5,  param
                  .ENDM                
SBCEopBzp          .MACRO param          
                  .BYTE $41E5,  param
                  .ENDM
SBCEopCzp          .MACRO param
                  .BYTE $42E5,  param
                  .ENDM
SBCEopDzp          .MACRO param
                  .BYTE $43E5,  param
                  .ENDM
SBCEopEzp          .MACRO param          
                  .BYTE $50E5,  param
                  .ENDM
SBCEopFzp          .MACRO param
                  .BYTE $51E5,  param
                  .ENDM
SBCEopGzp          .MACRO param
                  .BYTE $52E5,  param
                  .ENDM                  
SBCEopHzp          .MACRO param          
                  .BYTE $53E5,  param
                  .ENDM
SBCEopIzp          .MACRO param
                  .BYTE $60E5,  param
                  .ENDM
SBCEopJzp          .MACRO param
                  .BYTE $61E5,  param
                  .ENDM
SBCEopKzp          .MACRO param          
                  .BYTE $62E5,  param
                  .ENDM
SBCEopLzp          .MACRO param
                  .BYTE $63E5,  param
                  .ENDM
SBCEopMzp          .MACRO param
                  .BYTE $70E5,  param
                  .ENDM                  
SBCEopNzp          .MACRO param          
                  .BYTE $71E5,  param
                  .ENDM
SBCEopOzp          .MACRO param
                  .BYTE $72E5,  param
                  .ENDM
SBCEopQzp          .MACRO param
                  .BYTE $73E5,  param
                  .ENDM
                  
SBCFopAzp          .MACRO param
                  .BYTE $44E5,  param
                  .ENDM                
SBCFopBzp          .MACRO param          
                  .BYTE $45E5,  param
                  .ENDM
SBCFopCzp          .MACRO param
                  .BYTE $46E5,  param
                  .ENDM
SBCFopDzp          .MACRO param
                  .BYTE $47E5,  param
                  .ENDM
SBCFopEzp          .MACRO param          
                  .BYTE $54E5,  param
                  .ENDM
SBCFopFzp          .MACRO param
                  .BYTE $55E5,  param
                  .ENDM
SBCFopGzp          .MACRO param
                  .BYTE $56E5,  param
                  .ENDM                  
SBCFopHzp          .MACRO param          
                  .BYTE $57E5,  param
                  .ENDM
SBCFopIzp          .MACRO param
                  .BYTE $64E5,  param
                  .ENDM
SBCFopJzp          .MACRO param
                  .BYTE $65E5,  param
                  .ENDM
SBCFopKzp          .MACRO param          
                  .BYTE $66E5,  param
                  .ENDM
SBCFopLzp          .MACRO param
                  .BYTE $67E5,  param
                  .ENDM
SBCFopMzp          .MACRO param
                  .BYTE $74E5,  param
                  .ENDM                  
SBCFopNzp          .MACRO param          
                  .BYTE $75E5,  param
                  .ENDM
SBCFopOzp          .MACRO param
                  .BYTE $76E5,  param
                  .ENDM
SBCFopQzp          .MACRO param
                  .BYTE $77E5,  param
                  .ENDM                  
                           
SBCGopAzp          .MACRO param
                  .BYTE $48E5,  param
                  .ENDM                
SBCGopBzp          .MACRO param          
                  .BYTE $49E5,  param
                  .ENDM
SBCGopCzp          .MACRO param
                  .BYTE $4AE5,  param
                  .ENDM
SBCGopDzp          .MACRO param
                  .BYTE $4BE5,  param
                  .ENDM
SBCGopEzp          .MACRO param          
                  .BYTE $58E5,  param
                  .ENDM
SBCGopFzp          .MACRO param
                  .BYTE $59E5,  param
                  .ENDM
SBCGopGzp          .MACRO param
                  .BYTE $5AE5,  param
                  .ENDM                  
SBCGopHzp          .MACRO param          
                  .BYTE $5BE5,  param
                  .ENDM
SBCGopIzp          .MACRO param
                  .BYTE $68E5,  param
                  .ENDM
SBCGopJzp          .MACRO param
                  .BYTE $69E5,  param
                  .ENDM
SBCGopKzp          .MACRO param          
                  .BYTE $6AE5,  param
                  .ENDM
SBCGopLzp          .MACRO param
                  .BYTE $6BE5,  param
                  .ENDM
SBCGopMzp          .MACRO param
                  .BYTE $78E5,  param
                  .ENDM                  
SBCGopNzp          .MACRO param          
                  .BYTE $79E5,  param
                  .ENDM
SBCGopOzp          .MACRO param
                  .BYTE $7AE5,  param
                  .ENDM
SBCGopQzp          .MACRO param
                  .BYTE $7BE5,  param
                  .ENDM
                  
SBCHopAzp          .MACRO param
                  .BYTE $4CE5,  param
                  .ENDM                
SBCHopBzp          .MACRO param          
                  .BYTE $4DE5,  param
                  .ENDM
SBCHopCzp          .MACRO param
                  .BYTE $4EE5,  param
                  .ENDM
SBCHopDzp          .MACRO param
                  .BYTE $4FE5,  param
                  .ENDM
SBCHopEzp          .MACRO param          
                  .BYTE $5CE5,  param
                  .ENDM
SBCHopFzp          .MACRO param
                  .BYTE $5DE5,  param
                  .ENDM
SBCHopGzp          .MACRO param
                  .BYTE $5EE5,  param
                  .ENDM                  
SBCHopHzp          .MACRO param          
                  .BYTE $5FE5,  param
                  .ENDM
SBCHopIzp          .MACRO param
                  .BYTE $6CE5,  param
                  .ENDM
SBCHopJzp          .MACRO param
                  .BYTE $6DE5,  param
                  .ENDM
SBCHopKzp          .MACRO param          
                  .BYTE $6EE5,  param
                  .ENDM
SBCHopLzp          .MACRO param
                  .BYTE $6FE5,  param
                  .ENDM
SBCHopMzp          .MACRO param
                  .BYTE $7CE5,  param
                  .ENDM                  
SBCHopNzp          .MACRO param          
                  .BYTE $7DE5,  param
                  .ENDM
SBCHopOzp          .MACRO param
                  .BYTE $7EE5,  param
                  .ENDM
SBCHopQzp          .MACRO param
                  .BYTE $7FE5,  param
                  .ENDM
                  
SBCIopAzp          .MACRO param
                  .BYTE $80E5,  param
                  .ENDM                
SBCIopBzp          .MACRO param          
                  .BYTE $81E5,  param
                  .ENDM
SBCIopCzp          .MACRO param
                  .BYTE $82E5,  param
                  .ENDM
SBCIopDzp          .MACRO param
                  .BYTE $83E5,  param
                  .ENDM
SBCIopEzp          .MACRO param          
                  .BYTE $90E5,  param
                  .ENDM
SBCIopFzp          .MACRO param
                  .BYTE $91E5,  param
                  .ENDM
SBCIopGzp          .MACRO param
                  .BYTE $92E5,  param
                  .ENDM                  
SBCIopHzp          .MACRO param          
                  .BYTE $93E5,  param
                  .ENDM
SBCIopIzp          .MACRO param
                  .BYTE $A0E5,  param
                  .ENDM
SBCIopJzp          .MACRO param
                  .BYTE $A1E5,  param
                  .ENDM
SBCIopKzp          .MACRO param          
                  .BYTE $A2E5,  param
                  .ENDM
SBCIopLzp          .MACRO param
                  .BYTE $A3E5,  param
                  .ENDM
SBCIopMzp          .MACRO param
                  .BYTE $B0E5,  param
                  .ENDM                  
SBCIopNzp          .MACRO param          
                  .BYTE $B1E5,  param
                  .ENDM
SBCIopOzp          .MACRO param
                  .BYTE $B2E5,  param
                  .ENDM
SBCIopQzp          .MACRO param
                  .BYTE $B3E5,  param
                  .ENDM
                  
SBCJopAzp          .MACRO param
                  .BYTE $84E5,  param
                  .ENDM                
SBCJopBzp          .MACRO param          
                  .BYTE $85E5,  param
                  .ENDM
SBCJopCzp          .MACRO param
                  .BYTE $86E5,  param
                  .ENDM
SBCJopDzp          .MACRO param
                  .BYTE $87E5,  param
                  .ENDM
SBCJopEzp          .MACRO param          
                  .BYTE $94E5,  param
                  .ENDM
SBCJopFzp          .MACRO param
                  .BYTE $95E5,  param
                  .ENDM
SBCJopGzp          .MACRO param
                  .BYTE $96E5,  param
                  .ENDM                  
SBCJopHzp          .MACRO param          
                  .BYTE $97E5,  param
                  .ENDM
SBCJopIzp          .MACRO param
                  .BYTE $A4E5,  param
                  .ENDM
SBCJopJzp          .MACRO param
                  .BYTE $A5E5,  param
                  .ENDM
SBCJopKzp          .MACRO param          
                  .BYTE $A6E5,  param
                  .ENDM
SBCJopLzp          .MACRO param
                  .BYTE $A7E5,  param
                  .ENDM
SBCJopMzp          .MACRO param
                  .BYTE $B4E5,  param
                  .ENDM                  
SBCJopNzp          .MACRO param          
                  .BYTE $B5E5,  param
                  .ENDM
SBCJopOzp          .MACRO param
                  .BYTE $B6E5,  param
                  .ENDM
SBCJopQzp          .MACRO param
                  .BYTE $B7E5,  param
                  .ENDM
                  
SBCKopAzp          .MACRO param
                  .BYTE $88E5,  param
                  .ENDM                
SBCKopBzp          .MACRO param          
                  .BYTE $89E5,  param
                  .ENDM
SBCKopCzp          .MACRO param
                  .BYTE $8AE5,  param
                  .ENDM
SBCKopDzp          .MACRO param
                  .BYTE $8BE5,  param
                  .ENDM
SBCKopEzp          .MACRO param          
                  .BYTE $98E5,  param
                  .ENDM
SBCKopFzp          .MACRO param
                  .BYTE $99E5,  param
                  .ENDM
SBCKopGzp          .MACRO param
                  .BYTE $9AE5,  param
                  .ENDM                  
SBCKopHzp          .MACRO param          
                  .BYTE $9BE5,  param
                  .ENDM
SBCKopIzp          .MACRO param
                  .BYTE $A8E5,  param
                  .ENDM
SBCKopJzp          .MACRO param
                  .BYTE $A9E5,  param
                  .ENDM
SBCKopKzp          .MACRO param          
                  .BYTE $AAE5,  param
                  .ENDM
SBCKopLzp          .MACRO param
                  .BYTE $ABE5,  param
                  .ENDM
SBCKopMzp          .MACRO param
                  .BYTE $B8E5,  param
                  .ENDM                  
SBCKopNzp          .MACRO param          
                  .BYTE $B9E5,  param
                  .ENDM
SBCKopOzp          .MACRO param
                  .BYTE $BAE5,  param
                  .ENDM
SBCKopQzp          .MACRO param
                  .BYTE $BBE5,  param
                  .ENDM
                  
SBCLopAzp          .MACRO param
                  .BYTE $8CE5,  param
                  .ENDM                
SBCLopBzp          .MACRO param          
                  .BYTE $8DE5,  param
                  .ENDM
SBCLopCzp          .MACRO param
                  .BYTE $8EE5,  param
                  .ENDM
SBCLopDzp          .MACRO param
                  .BYTE $8FE5,  param
                  .ENDM
SBCLopEzp          .MACRO param          
                  .BYTE $9CE5,  param
                  .ENDM
SBCLopFzp          .MACRO param
                  .BYTE $9DE5,  param
                  .ENDM
SBCLopGzp          .MACRO param
                  .BYTE $9EE5,  param
                  .ENDM                  
SBCLopHzp          .MACRO param          
                  .BYTE $9FE5,  param
                  .ENDM
SBCLopIzp          .MACRO param
                  .BYTE $ACE5,  param
                  .ENDM
SBCLopJzp          .MACRO param
                  .BYTE $ADE5,  param
                  .ENDM
SBCLopKzp          .MACRO param          
                  .BYTE $AEE5,  param
                  .ENDM
SBCLopLzp          .MACRO param
                  .BYTE $AFE5,  param
                  .ENDM
SBCLopMzp          .MACRO param
                  .BYTE $BCE5,  param
                  .ENDM                  
SBCLopNzp          .MACRO param          
                  .BYTE $BDE5,  param
                  .ENDM
SBCLopOzp          .MACRO param
                  .BYTE $BEE5,  param
                  .ENDM
SBCLopQzp          .MACRO param
                  .BYTE $BFE5,  param
                  .ENDM
                  
SBCMopAzp          .MACRO param
                  .BYTE $C0E5,  param
                  .ENDM                
SBCMopBzp          .MACRO param          
                  .BYTE $C1E5,  param
                  .ENDM
SBCMopCzp          .MACRO param
                  .BYTE $C2E5,  param
                  .ENDM
SBCMopDzp          .MACRO param
                  .BYTE $C3E5,  param
                  .ENDM
SBCMopEzp          .MACRO param          
                  .BYTE $D0E5,  param
                  .ENDM
SBCMopFzp          .MACRO param
                  .BYTE $D1E5,  param
                  .ENDM
SBCMopGzp          .MACRO param
                  .BYTE $D2E5,  param
                  .ENDM                  
SBCMopHzp          .MACRO param          
                  .BYTE $D3E5,  param
                  .ENDM
SBCMopIzp          .MACRO param
                  .BYTE $E0E5,  param
                  .ENDM
SBCMopJzp          .MACRO param
                  .BYTE $E1E5,  param
                  .ENDM
SBCMopKzp          .MACRO param          
                  .BYTE $E2E5,  param
                  .ENDM
SBCMopLzp          .MACRO param
                  .BYTE $E3E5,  param
                  .ENDM
SBCMopMzp          .MACRO param
                  .BYTE $F0E5,  param
                  .ENDM                  
SBCMopNzp          .MACRO param          
                  .BYTE $F1E5,  param
                  .ENDM
SBCMopOzp          .MACRO param
                  .BYTE $F2E5,  param
                  .ENDM
SBCMopQzp          .MACRO param
                  .BYTE $F3E5,  param
                  .ENDM
                  
SBCNopAzp          .MACRO param
                  .BYTE $C4E5,  param
                  .ENDM                
SBCNopBzp          .MACRO param          
                  .BYTE $C5E5,  param
                  .ENDM
SBCNopCzp          .MACRO param
                  .BYTE $C6E5,  param
                  .ENDM
SBCNopDzp          .MACRO param
                  .BYTE $C7E5,  param
                  .ENDM
SBCNopEzp          .MACRO param          
                  .BYTE $D4E5,  param
                  .ENDM
SBCNopFzp          .MACRO param
                  .BYTE $D5E5,  param
                  .ENDM
SBCNopGzp          .MACRO param
                  .BYTE $D6E5,  param
                  .ENDM                  
SBCNopHzp          .MACRO param          
                  .BYTE $D7E5,  param
                  .ENDM
SBCNopIzp          .MACRO param
                  .BYTE $E4E5,  param
                  .ENDM
SBCNopJzp          .MACRO param
                  .BYTE $E5E5,  param
                  .ENDM
SBCNopKzp          .MACRO param          
                  .BYTE $E6E5,  param
                  .ENDM
SBCNopLzp          .MACRO param
                  .BYTE $E7E5,  param
                  .ENDM
SBCNopMzp          .MACRO param
                  .BYTE $F4E5,  param
                  .ENDM                  
SBCNopNzp          .MACRO param          
                  .BYTE $F5E5,  param
                  .ENDM
SBCNopOzp          .MACRO param
                  .BYTE $F6E5,  param
                  .ENDM
SBCNopQzp          .MACRO param
                  .BYTE $F7E5,  param
                  .ENDM
            
SBCOopAzp          .MACRO param
                  .BYTE $C8E5,  param
                  .ENDM                
SBCOopBzp          .MACRO param          
                  .BYTE $C9E5,  param
                  .ENDM
SBCOopCzp          .MACRO param
                  .BYTE $CAE5,  param
                  .ENDM
SBCOopDzp          .MACRO param
                  .BYTE $CBE5,  param
                  .ENDM
SBCOopEzp          .MACRO param          
                  .BYTE $D8E5,  param
                  .ENDM
SBCOopFzp          .MACRO param
                  .BYTE $D9E5,  param
                  .ENDM
SBCOopGzp          .MACRO param
                  .BYTE $DAE5,  param
                  .ENDM                  
SBCOopHzp          .MACRO param          
                  .BYTE $DBE5,  param
                  .ENDM
SBCOopIzp          .MACRO param
                  .BYTE $E8E5,  param
                  .ENDM
SBCOopJzp          .MACRO param
                  .BYTE $E9E5,  param
                  .ENDM
SBCOopKzp          .MACRO param          
                  .BYTE $EAE5,  param
                  .ENDM
SBCOopLzp          .MACRO param
                  .BYTE $EBE5,  param
                  .ENDM
SBCOopMzp          .MACRO param
                  .BYTE $F8E5,  param
                  .ENDM                  
SBCOopNzp          .MACRO param          
                  .BYTE $F9E5,  param
                  .ENDM
SBCOopOzp          .MACRO param
                  .BYTE $FAE5,  param
                  .ENDM
SBCOopQzp          .MACRO param
                  .BYTE $FBE5,  param
                  .ENDM
                  
SBCQopAzp          .MACRO param
                  .BYTE $CCE5,  param
                  .ENDM                
SBCQopBzp          .MACRO param          
                  .BYTE $CDE5,  param
                  .ENDM
SBCQopCzp          .MACRO param
                  .BYTE $CEE5,  param
                  .ENDM
SBCQopDzp          .MACRO param
                  .BYTE $CFE5,  param
                  .ENDM
SBCQopEzp          .MACRO param          
                  .BYTE $DCE5,  param
                  .ENDM
SBCQopFzp          .MACRO param
                  .BYTE $DDE5,  param
                  .ENDM
SBCQopGzp          .MACRO param
                  .BYTE $DEE5,  param
                  .ENDM                  
SBCQopHzp          .MACRO param          
                  .BYTE $DFE5,  param
                  .ENDM
SBCQopIzp          .MACRO param
                  .BYTE $ECE5,  param
                  .ENDM
SBCQopJzp          .MACRO param
                  .BYTE $EDE5,  param
                  .ENDM
SBCQopKzp          .MACRO param          
                  .BYTE $EEE5,  param
                  .ENDM
SBCQopLzp          .MACRO param
                  .BYTE $EFE5,  param
                  .ENDM
SBCQopMzp          .MACRO param
                  .BYTE $FCE5,  param
                  .ENDM                  
SBCQopNzp          .MACRO param          
                  .BYTE $FDE5,  param
                  .ENDM
SBCQopOzp          .MACRO param
                  .BYTE $FEE5,  param
                  .ENDM
SBCQopQzp          .MACRO param
                  .BYTE $FFE5,  param
                  .ENDM
                  
;ORA $xxxx              $0005
ORAAopBzp          .MACRO param          
                  .BYTE $0105,  param
                  .ENDM
ORAAopCzp          .MACRO param
                  .BYTE $0205,  param
                  .ENDM
ORAAopDzp          .MACRO param
                  .BYTE $0305,  param
                  .ENDM
ORAAopEzp          .MACRO param          
                  .BYTE $1005,  param
                  .ENDM
ORAAopFzp          .MACRO param
                  .BYTE $1105,  param
                  .ENDM
ORAAopGzp          .MACRO param
                  .BYTE $1205,  param
                  .ENDM                  
ORAAopHzp          .MACRO param          
                  .BYTE $1305,  param
                  .ENDM
ORAAopIzp          .MACRO param
                  .BYTE $2005,  param
                  .ENDM
ORAAopJzp          .MACRO param
                  .BYTE $2105,  param
                  .ENDM
ORAAopKzp          .MACRO param          
                  .BYTE $2205,  param
                  .ENDM
ORAAopLzp          .MACRO param
                  .BYTE $2305,  param
                  .ENDM
ORAAopMzp          .MACRO param
                  .BYTE $3005,  param
                  .ENDM                  
ORAAopNzp          .MACRO param          
                  .BYTE $3105,  param
                  .ENDM
ORAAopOzp          .MACRO param
                  .BYTE $3205,  param
                  .ENDM
ORAAopQzp          .MACRO param
                  .BYTE $3305,  param
                  .ENDM
                                    
ORABopAzp          .MACRO param
                  .BYTE $0405,  param
                  .ENDM                
ORABopBzp          .MACRO param          
                  .BYTE $0505,  param
                  .ENDM
ORABopCzp          .MACRO param
                  .BYTE $0605,  param
                  .ENDM
ORABopDzp          .MACRO param
                  .BYTE $0705,  param
                  .ENDM
ORABopEzp          .MACRO param          
                  .BYTE $1405,  param
                  .ENDM
ORABopFzp          .MACRO param
                  .BYTE $1505,  param
                  .ENDM
ORABopGzp          .MACRO param
                  .BYTE $1605,  param
                  .ENDM                  
ORABopHzp          .MACRO param          
                  .BYTE $1705,  param
                  .ENDM
ORABopIzp          .MACRO param
                  .BYTE $2405,  param
                  .ENDM
ORABopJzp          .MACRO param
                  .BYTE $2505,  param
                  .ENDM
ORABopKzp          .MACRO param          
                  .BYTE $2605,  param
                  .ENDM
ORABopLzp          .MACRO param
                  .BYTE $2705,  param
                  .ENDM
ORABopMzp          .MACRO param
                  .BYTE $3005,  param
                  .ENDM                  
ORABopNzp          .MACRO param          
                  .BYTE $3105,  param
                  .ENDM
ORABopOzp          .MACRO param
                  .BYTE $3205,  param
                  .ENDM
ORABopQzp          .MACRO param
                  .BYTE $3305,  param
                  .ENDM
                                    
ORACopAzp          .MACRO param
                  .BYTE $0805,  param
                  .ENDM                
ORACopBzp          .MACRO param          
                  .BYTE $0905,  param
                  .ENDM
ORACopCzp          .MACRO param
                  .BYTE $0A05,  param
                  .ENDM
ORACopDzp          .MACRO param
                  .BYTE $0B05,  param
                  .ENDM
ORACopEzp          .MACRO param          
                  .BYTE $1805,  param
                  .ENDM
ORACopFzp          .MACRO param
                  .BYTE $1905,  param
                  .ENDM
ORACopGzp          .MACRO param
                  .BYTE $1A05,  param
                  .ENDM                  
ORACopHzp          .MACRO param          
                  .BYTE $1B05,  param
                  .ENDM
ORACopIzp          .MACRO param
                  .BYTE $2805,  param
                  .ENDM
ORACopJzp          .MACRO param
                  .BYTE $2905,  param
                  .ENDM
ORACopKzp          .MACRO param          
                  .BYTE $2A05,  param
                  .ENDM
ORACopLzp          .MACRO param
                  .BYTE $2B05,  param
                  .ENDM
ORACopMzp          .MACRO param
                  .BYTE $3805,  param
                  .ENDM                  
ORACopNzp          .MACRO param          
                  .BYTE $3905,  param
                  .ENDM
ORACopOzp          .MACRO param
                  .BYTE $3A05,  param
                  .ENDM
ORACopQzp          .MACRO param
                  .BYTE $3B05,  param
                  .ENDM

ORADopAzp          .MACRO param
                  .BYTE $0C05,  param
                  .ENDM                
ORADopBzp          .MACRO param          
                  .BYTE $0D05,  param
                  .ENDM
ORADopCzp          .MACRO param
                  .BYTE $0E05,  param
                  .ENDM
ORADopDzp          .MACRO param
                  .BYTE $0F05,  param
                  .ENDM
ORADopEzp          .MACRO param          
                  .BYTE $1C05,  param
                  .ENDM
ORADopFzp          .MACRO param
                  .BYTE $1D05,  param
                  .ENDM
ORADopGzp          .MACRO param
                  .BYTE $1E05,  param
                  .ENDM                  
ORADopHzp          .MACRO param          
                  .BYTE $1F05,  param
                  .ENDM
ORADopIzp          .MACRO param
                  .BYTE $2C05,  param
                  .ENDM
ORADopJzp          .MACRO param
                  .BYTE $2D05,  param
                  .ENDM
ORADopKzp          .MACRO param          
                  .BYTE $2E05,  param
                  .ENDM
ORADopLzp          .MACRO param
                  .BYTE $2F05,  param
                  .ENDM
ORADopMzp          .MACRO param
                  .BYTE $3C05,  param
                  .ENDM                  
ORADopNzp          .MACRO param          
                  .BYTE $3D05,  param
                  .ENDM
ORADopOzp          .MACRO param
                  .BYTE $3E05,  param
                  .ENDM
ORADopQzp          .MACRO param
                  .BYTE $3F05,  param
                  .ENDM                  

ORAEopAzp          .MACRO param
                  .BYTE $4005,  param
                  .ENDM                
ORAEopBzp          .MACRO param          
                  .BYTE $4105,  param
                  .ENDM
ORAEopCzp          .MACRO param
                  .BYTE $4205,  param
                  .ENDM
ORAEopDzp          .MACRO param
                  .BYTE $4305,  param
                  .ENDM
ORAEopEzp          .MACRO param          
                  .BYTE $5005,  param
                  .ENDM
ORAEopFzp          .MACRO param
                  .BYTE $5105,  param
                  .ENDM
ORAEopGzp          .MACRO param
                  .BYTE $5205,  param
                  .ENDM                  
ORAEopHzp          .MACRO param          
                  .BYTE $5305,  param
                  .ENDM
ORAEopIzp          .MACRO param
                  .BYTE $6005,  param
                  .ENDM
ORAEopJzp          .MACRO param
                  .BYTE $6105,  param
                  .ENDM
ORAEopKzp          .MACRO param          
                  .BYTE $6205,  param
                  .ENDM
ORAEopLzp          .MACRO param
                  .BYTE $6305,  param
                  .ENDM
ORAEopMzp          .MACRO param
                  .BYTE $7005,  param
                  .ENDM                  
ORAEopNzp          .MACRO param          
                  .BYTE $7105,  param
                  .ENDM
ORAEopOzp          .MACRO param
                  .BYTE $7205,  param
                  .ENDM
ORAEopQzp          .MACRO param
                  .BYTE $7305,  param
                  .ENDM
                  
ORAFopAzp          .MACRO param
                  .BYTE $4405,  param
                  .ENDM                
ORAFopBzp          .MACRO param          
                  .BYTE $4505,  param
                  .ENDM
ORAFopCzp          .MACRO param
                  .BYTE $4605,  param
                  .ENDM
ORAFopDzp          .MACRO param
                  .BYTE $4705,  param
                  .ENDM
ORAFopEzp          .MACRO param          
                  .BYTE $5405,  param
                  .ENDM
ORAFopFzp          .MACRO param
                  .BYTE $5505,  param
                  .ENDM
ORAFopGzp          .MACRO param
                  .BYTE $5605,  param
                  .ENDM                  
ORAFopHzp          .MACRO param          
                  .BYTE $5705,  param
                  .ENDM
ORAFopIzp          .MACRO param
                  .BYTE $6405,  param
                  .ENDM
ORAFopJzp          .MACRO param
                  .BYTE $6505,  param
                  .ENDM
ORAFopKzp          .MACRO param          
                  .BYTE $6605,  param
                  .ENDM
ORAFopLzp          .MACRO param
                  .BYTE $6705,  param
                  .ENDM
ORAFopMzp          .MACRO param
                  .BYTE $7405,  param
                  .ENDM                  
ORAFopNzp          .MACRO param          
                  .BYTE $7505,  param
                  .ENDM
ORAFopOzp          .MACRO param
                  .BYTE $7605,  param
                  .ENDM
ORAFopQzp          .MACRO param
                  .BYTE $7705,  param
                  .ENDM                  
                           
ORAGopAzp          .MACRO param
                  .BYTE $4805,  param
                  .ENDM                
ORAGopBzp          .MACRO param          
                  .BYTE $4905,  param
                  .ENDM
ORAGopCzp          .MACRO param
                  .BYTE $4A05,  param
                  .ENDM
ORAGopDzp          .MACRO param
                  .BYTE $4B05,  param
                  .ENDM
ORAGopEzp          .MACRO param          
                  .BYTE $5805,  param
                  .ENDM
ORAGopFzp          .MACRO param
                  .BYTE $5905,  param
                  .ENDM
ORAGopGzp          .MACRO param
                  .BYTE $5A05,  param
                  .ENDM                  
ORAGopHzp          .MACRO param          
                  .BYTE $5B05,  param
                  .ENDM
ORAGopIzp          .MACRO param
                  .BYTE $6805,  param
                  .ENDM
ORAGopJzp          .MACRO param
                  .BYTE $6905,  param
                  .ENDM
ORAGopKzp          .MACRO param          
                  .BYTE $6A05,  param
                  .ENDM
ORAGopLzp          .MACRO param
                  .BYTE $6B05,  param
                  .ENDM
ORAGopMzp          .MACRO param
                  .BYTE $7805,  param
                  .ENDM                  
ORAGopNzp          .MACRO param          
                  .BYTE $7905,  param
                  .ENDM
ORAGopOzp          .MACRO param
                  .BYTE $7A05,  param
                  .ENDM
ORAGopQzp          .MACRO param
                  .BYTE $7B05,  param
                  .ENDM
                  
ORAHopAzp          .MACRO param
                  .BYTE $4C05,  param
                  .ENDM                
ORAHopBzp          .MACRO param          
                  .BYTE $4D05,  param
                  .ENDM
ORAHopCzp          .MACRO param
                  .BYTE $4E05,  param
                  .ENDM
ORAHopDzp          .MACRO param
                  .BYTE $4F05,  param
                  .ENDM
ORAHopEzp          .MACRO param          
                  .BYTE $5C05,  param
                  .ENDM
ORAHopFzp          .MACRO param
                  .BYTE $5D05,  param
                  .ENDM
ORAHopGzp          .MACRO param
                  .BYTE $5E05,  param
                  .ENDM                  
ORAHopHzp          .MACRO param          
                  .BYTE $5F05,  param
                  .ENDM
ORAHopIzp          .MACRO param
                  .BYTE $6C05,  param
                  .ENDM
ORAHopJzp          .MACRO param
                  .BYTE $6D05,  param
                  .ENDM
ORAHopKzp          .MACRO param          
                  .BYTE $6E05,  param
                  .ENDM
ORAHopLzp          .MACRO param
                  .BYTE $6F05,  param
                  .ENDM
ORAHopMzp          .MACRO param
                  .BYTE $7C05,  param
                  .ENDM                  
ORAHopNzp          .MACRO param          
                  .BYTE $7D05,  param
                  .ENDM
ORAHopOzp          .MACRO param
                  .BYTE $7E05,  param
                  .ENDM
ORAHopQzp          .MACRO param
                  .BYTE $7F05,  param
                  .ENDM
                  
ORAIopAzp          .MACRO param
                  .BYTE $8005,  param
                  .ENDM                
ORAIopBzp          .MACRO param          
                  .BYTE $8105,  param
                  .ENDM
ORAIopCzp          .MACRO param
                  .BYTE $8205,  param
                  .ENDM
ORAIopDzp          .MACRO param
                  .BYTE $8305,  param
                  .ENDM
ORAIopEzp          .MACRO param          
                  .BYTE $9005,  param
                  .ENDM
ORAIopFzp          .MACRO param
                  .BYTE $9105,  param
                  .ENDM
ORAIopGzp          .MACRO param
                  .BYTE $9205,  param
                  .ENDM                  
ORAIopHzp          .MACRO param          
                  .BYTE $9305,  param
                  .ENDM
ORAIopIzp          .MACRO param
                  .BYTE $A005,  param
                  .ENDM
ORAIopJzp          .MACRO param
                  .BYTE $A105,  param
                  .ENDM
ORAIopKzp          .MACRO param          
                  .BYTE $A205,  param
                  .ENDM
ORAIopLzp          .MACRO param
                  .BYTE $A305,  param
                  .ENDM
ORAIopMzp          .MACRO param
                  .BYTE $B005,  param
                  .ENDM                  
ORAIopNzp          .MACRO param          
                  .BYTE $B105,  param
                  .ENDM
ORAIopOzp          .MACRO param
                  .BYTE $B205,  param
                  .ENDM
ORAIopQzp          .MACRO param
                  .BYTE $B305,  param
                  .ENDM
                  
ORAJopAzp          .MACRO param
                  .BYTE $8405,  param
                  .ENDM                
ORAJopBzp          .MACRO param          
                  .BYTE $8505,  param
                  .ENDM
ORAJopCzp          .MACRO param
                  .BYTE $8605,  param
                  .ENDM
ORAJopDzp          .MACRO param
                  .BYTE $8705,  param
                  .ENDM
ORAJopEzp          .MACRO param          
                  .BYTE $9405,  param
                  .ENDM
ORAJopFzp          .MACRO param
                  .BYTE $9505,  param
                  .ENDM
ORAJopGzp          .MACRO param
                  .BYTE $9605,  param
                  .ENDM                  
ORAJopHzp          .MACRO param          
                  .BYTE $9705,  param
                  .ENDM
ORAJopIzp          .MACRO param
                  .BYTE $A405,  param
                  .ENDM
ORAJopJzp          .MACRO param
                  .BYTE $A505,  param
                  .ENDM
ORAJopKzp          .MACRO param          
                  .BYTE $A605,  param
                  .ENDM
ORAJopLzp          .MACRO param
                  .BYTE $A705,  param
                  .ENDM
ORAJopMzp          .MACRO param
                  .BYTE $B405,  param
                  .ENDM                  
ORAJopNzp          .MACRO param          
                  .BYTE $B505,  param
                  .ENDM
ORAJopOzp          .MACRO param
                  .BYTE $B605,  param
                  .ENDM
ORAJopQzp          .MACRO param
                  .BYTE $B705,  param
                  .ENDM
                  
ORAKopAzp          .MACRO param
                  .BYTE $8805,  param
                  .ENDM                
ORAKopBzp          .MACRO param          
                  .BYTE $8905,  param
                  .ENDM
ORAKopCzp          .MACRO param
                  .BYTE $8A05,  param
                  .ENDM
ORAKopDzp          .MACRO param
                  .BYTE $8B05,  param
                  .ENDM
ORAKopEzp          .MACRO param          
                  .BYTE $9805,  param
                  .ENDM
ORAKopFzp          .MACRO param
                  .BYTE $9905,  param
                  .ENDM
ORAKopGzp          .MACRO param
                  .BYTE $9A05,  param
                  .ENDM                  
ORAKopHzp          .MACRO param          
                  .BYTE $9B05,  param
                  .ENDM
ORAKopIzp          .MACRO param
                  .BYTE $A805,  param
                  .ENDM
ORAKopJzp          .MACRO param
                  .BYTE $A905,  param
                  .ENDM
ORAKopKzp          .MACRO param          
                  .BYTE $AA05,  param
                  .ENDM
ORAKopLzp          .MACRO param
                  .BYTE $AB05,  param
                  .ENDM
ORAKopMzp          .MACRO param
                  .BYTE $B805,  param
                  .ENDM                  
ORAKopNzp          .MACRO param          
                  .BYTE $B905,  param
                  .ENDM
ORAKopOzp          .MACRO param
                  .BYTE $BA05,  param
                  .ENDM
ORAKopQzp          .MACRO param
                  .BYTE $BB05,  param
                  .ENDM
                  
ORALopAzp          .MACRO param
                  .BYTE $8C05,  param
                  .ENDM                
ORALopBzp          .MACRO param          
                  .BYTE $8D05,  param
                  .ENDM
ORALopCzp          .MACRO param
                  .BYTE $8E05,  param
                  .ENDM
ORALopDzp          .MACRO param
                  .BYTE $8F05,  param
                  .ENDM
ORALopEzp          .MACRO param          
                  .BYTE $9C05,  param
                  .ENDM
ORALopFzp          .MACRO param
                  .BYTE $9D05,  param
                  .ENDM
ORALopGzp          .MACRO param
                  .BYTE $9E05,  param
                  .ENDM                  
ORALopHzp          .MACRO param          
                  .BYTE $9F05,  param
                  .ENDM
ORALopIzp          .MACRO param
                  .BYTE $AC05,  param
                  .ENDM
ORALopJzp          .MACRO param
                  .BYTE $AD05,  param
                  .ENDM
ORALopKzp          .MACRO param          
                  .BYTE $AE05,  param
                  .ENDM
ORALopLzp          .MACRO param
                  .BYTE $AF05,  param
                  .ENDM
ORALopMzp          .MACRO param
                  .BYTE $BC05,  param
                  .ENDM                  
ORALopNzp          .MACRO param          
                  .BYTE $BD05,  param
                  .ENDM
ORALopOzp          .MACRO param
                  .BYTE $BE05,  param
                  .ENDM
ORALopQzp          .MACRO param
                  .BYTE $BF05,  param
                  .ENDM
                  
ORAMopAzp          .MACRO param
                  .BYTE $C005,  param
                  .ENDM                
ORAMopBzp          .MACRO param          
                  .BYTE $C105,  param
                  .ENDM
ORAMopCzp          .MACRO param
                  .BYTE $C205,  param
                  .ENDM
ORAMopDzp          .MACRO param
                  .BYTE $C305,  param
                  .ENDM
ORAMopEzp          .MACRO param          
                  .BYTE $D005,  param
                  .ENDM
ORAMopFzp          .MACRO param
                  .BYTE $D105,  param
                  .ENDM
ORAMopGzp          .MACRO param
                  .BYTE $D205,  param
                  .ENDM                  
ORAMopHzp          .MACRO param          
                  .BYTE $D305,  param
                  .ENDM
ORAMopIzp          .MACRO param
                  .BYTE $E005,  param
                  .ENDM
ORAMopJzp          .MACRO param
                  .BYTE $E105,  param
                  .ENDM
ORAMopKzp          .MACRO param          
                  .BYTE $E205,  param
                  .ENDM
ORAMopLzp          .MACRO param
                  .BYTE $E305,  param
                  .ENDM
ORAMopMzp          .MACRO param
                  .BYTE $F005,  param
                  .ENDM                  
ORAMopNzp          .MACRO param          
                  .BYTE $F105,  param
                  .ENDM
ORAMopOzp          .MACRO param
                  .BYTE $F205,  param
                  .ENDM
ORAMopQzp          .MACRO param
                  .BYTE $F305,  param
                  .ENDM
                  
ORANopAzp          .MACRO param
                  .BYTE $C405,  param
                  .ENDM                
ORANopBzp          .MACRO param          
                  .BYTE $C505,  param
                  .ENDM
ORANopCzp          .MACRO param
                  .BYTE $C605,  param
                  .ENDM
ORANopDzp          .MACRO param
                  .BYTE $C705,  param
                  .ENDM
ORANopEzp          .MACRO param          
                  .BYTE $D405,  param
                  .ENDM
ORANopFzp          .MACRO param
                  .BYTE $D505,  param
                  .ENDM
ORANopGzp          .MACRO param
                  .BYTE $D605,  param
                  .ENDM                  
ORANopHzp          .MACRO param          
                  .BYTE $D705,  param
                  .ENDM
ORANopIzp          .MACRO param
                  .BYTE $E405,  param
                  .ENDM
ORANopJzp          .MACRO param
                  .BYTE $E505,  param
                  .ENDM
ORANopKzp          .MACRO param          
                  .BYTE $E605,  param
                  .ENDM
ORANopLzp          .MACRO param
                  .BYTE $E705,  param
                  .ENDM
ORANopMzp          .MACRO param
                  .BYTE $F405,  param
                  .ENDM                  
ORANopNzp          .MACRO param          
                  .BYTE $F505,  param
                  .ENDM
ORANopOzp          .MACRO param
                  .BYTE $F605,  param
                  .ENDM
ORANopQzp          .MACRO param
                  .BYTE $F705,  param
                  .ENDM
            
ORAOopAzp          .MACRO param
                  .BYTE $C805,  param
                  .ENDM                
ORAOopBzp          .MACRO param          
                  .BYTE $C905,  param
                  .ENDM
ORAOopCzp          .MACRO param
                  .BYTE $CA05,  param
                  .ENDM
ORAOopDzp          .MACRO param
                  .BYTE $CB05,  param
                  .ENDM
ORAOopEzp          .MACRO param          
                  .BYTE $D805,  param
                  .ENDM
ORAOopFzp          .MACRO param
                  .BYTE $D905,  param
                  .ENDM
ORAOopGzp          .MACRO param
                  .BYTE $DA05,  param
                  .ENDM                  
ORAOopHzp          .MACRO param          
                  .BYTE $DB05,  param
                  .ENDM
ORAOopIzp          .MACRO param
                  .BYTE $E805,  param
                  .ENDM
ORAOopJzp          .MACRO param
                  .BYTE $E905,  param
                  .ENDM
ORAOopKzp          .MACRO param          
                  .BYTE $EA05,  param
                  .ENDM
ORAOopLzp          .MACRO param
                  .BYTE $EB05,  param
                  .ENDM
ORAOopMzp          .MACRO param
                  .BYTE $F805,  param
                  .ENDM                  
ORAOopNzp          .MACRO param          
                  .BYTE $F905,  param
                  .ENDM
ORAOopOzp          .MACRO param
                  .BYTE $FA05,  param
                  .ENDM
ORAOopQzp          .MACRO param
                  .BYTE $FB05,  param
                  .ENDM
                  
ORAQopAzp          .MACRO param
                  .BYTE $CC05,  param
                  .ENDM                
ORAQopBzp          .MACRO param          
                  .BYTE $CD05,  param
                  .ENDM
ORAQopCzp          .MACRO param
                  .BYTE $CE05,  param
                  .ENDM
ORAQopDzp          .MACRO param
                  .BYTE $CF05,  param
                  .ENDM
ORAQopEzp          .MACRO param          
                  .BYTE $DC05,  param
                  .ENDM
ORAQopFzp          .MACRO param
                  .BYTE $DD05,  param
                  .ENDM
ORAQopGzp          .MACRO param
                  .BYTE $DE05,  param
                  .ENDM                  
ORAQopHzp          .MACRO param          
                  .BYTE $DF05,  param
                  .ENDM
ORAQopIzp          .MACRO param
                  .BYTE $EC05,  param
                  .ENDM
ORAQopJzp          .MACRO param
                  .BYTE $ED05,  param
                  .ENDM
ORAQopKzp          .MACRO param          
                  .BYTE $EE05,  param
                  .ENDM
ORAQopLzp          .MACRO param
                  .BYTE $EF05,  param
                  .ENDM
ORAQopMzp          .MACRO param
                  .BYTE $FC05,  param
                  .ENDM                  
ORAQopNzp          .MACRO param          
                  .BYTE $FD05,  param
                  .ENDM
ORAQopOzp          .MACRO param
                  .BYTE $FE05,  param
                  .ENDM
ORAQopQzp          .MACRO param
                  .BYTE $FF05,  param
                  .ENDM
                  
;AND $xxxx              $0025
ANDAopBzp          .MACRO param          
                  .BYTE $0125,  param
                  .ENDM
ANDAopCzp          .MACRO param
                  .BYTE $0225,  param
                  .ENDM
ANDAopDzp          .MACRO param
                  .BYTE $0325,  param
                  .ENDM
ANDAopEzp          .MACRO param          
                  .BYTE $1025,  param
                  .ENDM
ANDAopFzp          .MACRO param
                  .BYTE $1125,  param
                  .ENDM
ANDAopGzp          .MACRO param
                  .BYTE $1225,  param
                  .ENDM                  
ANDAopHzp          .MACRO param          
                  .BYTE $1325,  param
                  .ENDM
ANDAopIzp          .MACRO param
                  .BYTE $2025,  param
                  .ENDM
ANDAopJzp          .MACRO param
                  .BYTE $2125,  param
                  .ENDM
ANDAopKzp          .MACRO param          
                  .BYTE $2225,  param
                  .ENDM
ANDAopLzp          .MACRO param
                  .BYTE $2325,  param
                  .ENDM
ANDAopMzp          .MACRO param
                  .BYTE $3025,  param
                  .ENDM                  
ANDAopNzp          .MACRO param          
                  .BYTE $3125,  param
                  .ENDM
ANDAopOzp          .MACRO param
                  .BYTE $3225,  param
                  .ENDM
ANDAopQzp          .MACRO param
                  .BYTE $3325,  param
                  .ENDM
                                    
ANDBopAzp          .MACRO param
                  .BYTE $0425,  param
                  .ENDM                
ANDBopBzp          .MACRO param          
                  .BYTE $0525,  param
                  .ENDM
ANDBopCzp          .MACRO param
                  .BYTE $0625,  param
                  .ENDM
ANDBopDzp          .MACRO param
                  .BYTE $0725,  param
                  .ENDM
ANDBopEzp          .MACRO param          
                  .BYTE $1425,  param
                  .ENDM
ANDBopFzp          .MACRO param
                  .BYTE $1525,  param
                  .ENDM
ANDBopGzp          .MACRO param
                  .BYTE $1625,  param
                  .ENDM                  
ANDBopHzp          .MACRO param          
                  .BYTE $1725,  param
                  .ENDM
ANDBopIzp          .MACRO param
                  .BYTE $2425,  param
                  .ENDM
ANDBopJzp          .MACRO param
                  .BYTE $2525,  param
                  .ENDM
ANDBopKzp          .MACRO param          
                  .BYTE $2625,  param
                  .ENDM
ANDBopLzp          .MACRO param
                  .BYTE $2725,  param
                  .ENDM
ANDBopMzp          .MACRO param
                  .BYTE $3025,  param
                  .ENDM                  
ANDBopNzp          .MACRO param          
                  .BYTE $3125,  param
                  .ENDM
ANDBopOzp          .MACRO param
                  .BYTE $3225,  param
                  .ENDM
ANDBopQzp          .MACRO param
                  .BYTE $3325,  param
                  .ENDM
                                    
ANDCopAzp          .MACRO param
                  .BYTE $0825,  param
                  .ENDM                
ANDCopBzp          .MACRO param          
                  .BYTE $0925,  param
                  .ENDM
ANDCopCzp          .MACRO param
                  .BYTE $0A25,  param
                  .ENDM
ANDCopDzp          .MACRO param
                  .BYTE $0B25,  param
                  .ENDM
ANDCopEzp          .MACRO param          
                  .BYTE $1825,  param
                  .ENDM
ANDCopFzp          .MACRO param
                  .BYTE $1925,  param
                  .ENDM
ANDCopGzp          .MACRO param
                  .BYTE $1A25,  param
                  .ENDM                  
ANDCopHzp          .MACRO param          
                  .BYTE $1B25,  param
                  .ENDM
ANDCopIzp          .MACRO param
                  .BYTE $2825,  param
                  .ENDM
ANDCopJzp          .MACRO param
                  .BYTE $2925,  param
                  .ENDM
ANDCopKzp          .MACRO param          
                  .BYTE $2A25,  param
                  .ENDM
ANDCopLzp          .MACRO param
                  .BYTE $2B25,  param
                  .ENDM
ANDCopMzp          .MACRO param
                  .BYTE $3825,  param
                  .ENDM                  
ANDCopNzp          .MACRO param          
                  .BYTE $3925,  param
                  .ENDM
ANDCopOzp          .MACRO param
                  .BYTE $3A25,  param
                  .ENDM
ANDCopQzp          .MACRO param
                  .BYTE $3B25,  param
                  .ENDM

ANDDopAzp          .MACRO param
                  .BYTE $0C25,  param
                  .ENDM                
ANDDopBzp          .MACRO param          
                  .BYTE $0D25,  param
                  .ENDM
ANDDopCzp          .MACRO param
                  .BYTE $0E25,  param
                  .ENDM
ANDDopDzp          .MACRO param
                  .BYTE $0F25,  param
                  .ENDM
ANDDopEzp          .MACRO param          
                  .BYTE $1C25,  param
                  .ENDM
ANDDopFzp          .MACRO param
                  .BYTE $1D25,  param
                  .ENDM
ANDDopGzp          .MACRO param
                  .BYTE $1E25,  param
                  .ENDM                  
ANDDopHzp          .MACRO param          
                  .BYTE $1F25,  param
                  .ENDM
ANDDopIzp          .MACRO param
                  .BYTE $2C25,  param
                  .ENDM
ANDDopJzp          .MACRO param
                  .BYTE $2D25,  param
                  .ENDM
ANDDopKzp          .MACRO param          
                  .BYTE $2E25,  param
                  .ENDM
ANDDopLzp          .MACRO param
                  .BYTE $2F25,  param
                  .ENDM
ANDDopMzp          .MACRO param
                  .BYTE $3C25,  param
                  .ENDM                  
ANDDopNzp          .MACRO param          
                  .BYTE $3D25,  param
                  .ENDM
ANDDopOzp          .MACRO param
                  .BYTE $3E25,  param
                  .ENDM
ANDDopQzp          .MACRO param
                  .BYTE $3F25,  param
                  .ENDM                  

ANDEopAzp          .MACRO param
                  .BYTE $4025,  param
                  .ENDM                
ANDEopBzp          .MACRO param          
                  .BYTE $4125,  param
                  .ENDM
ANDEopCzp          .MACRO param
                  .BYTE $4225,  param
                  .ENDM
ANDEopDzp          .MACRO param
                  .BYTE $4325,  param
                  .ENDM
ANDEopEzp          .MACRO param          
                  .BYTE $5025,  param
                  .ENDM
ANDEopFzp          .MACRO param
                  .BYTE $5125,  param
                  .ENDM
ANDEopGzp          .MACRO param
                  .BYTE $5225,  param
                  .ENDM                  
ANDEopHzp          .MACRO param          
                  .BYTE $5325,  param
                  .ENDM
ANDEopIzp          .MACRO param
                  .BYTE $6025,  param
                  .ENDM
ANDEopJzp          .MACRO param
                  .BYTE $6125,  param
                  .ENDM
ANDEopKzp          .MACRO param          
                  .BYTE $6225,  param
                  .ENDM
ANDEopLzp          .MACRO param
                  .BYTE $6325,  param
                  .ENDM
ANDEopMzp          .MACRO param
                  .BYTE $7025,  param
                  .ENDM                  
ANDEopNzp          .MACRO param          
                  .BYTE $7125,  param
                  .ENDM
ANDEopOzp          .MACRO param
                  .BYTE $7225,  param
                  .ENDM
ANDEopQzp          .MACRO param
                  .BYTE $7325,  param
                  .ENDM
                  
ANDFopAzp          .MACRO param
                  .BYTE $4425,  param
                  .ENDM                
ANDFopBzp          .MACRO param          
                  .BYTE $4525,  param
                  .ENDM
ANDFopCzp          .MACRO param
                  .BYTE $4625,  param
                  .ENDM
ANDFopDzp          .MACRO param
                  .BYTE $4725,  param
                  .ENDM
ANDFopEzp          .MACRO param          
                  .BYTE $5425,  param
                  .ENDM
ANDFopFzp          .MACRO param
                  .BYTE $5525,  param
                  .ENDM
ANDFopGzp          .MACRO param
                  .BYTE $5625,  param
                  .ENDM                  
ANDFopHzp          .MACRO param          
                  .BYTE $5725,  param
                  .ENDM
ANDFopIzp          .MACRO param
                  .BYTE $6425,  param
                  .ENDM
ANDFopJzp          .MACRO param
                  .BYTE $6525,  param
                  .ENDM
ANDFopKzp          .MACRO param          
                  .BYTE $6625,  param
                  .ENDM
ANDFopLzp          .MACRO param
                  .BYTE $6725,  param
                  .ENDM
ANDFopMzp          .MACRO param
                  .BYTE $7425,  param
                  .ENDM                  
ANDFopNzp          .MACRO param          
                  .BYTE $7525,  param
                  .ENDM
ANDFopOzp          .MACRO param
                  .BYTE $7625,  param
                  .ENDM
ANDFopQzp          .MACRO param
                  .BYTE $7725,  param
                  .ENDM                  
                           
ANDGopAzp          .MACRO param
                  .BYTE $4825,  param
                  .ENDM                
ANDGopBzp          .MACRO param          
                  .BYTE $4925,  param
                  .ENDM
ANDGopCzp          .MACRO param
                  .BYTE $4A25,  param
                  .ENDM
ANDGopDzp          .MACRO param
                  .BYTE $4B25,  param
                  .ENDM
ANDGopEzp          .MACRO param          
                  .BYTE $5825,  param
                  .ENDM
ANDGopFzp          .MACRO param
                  .BYTE $5925,  param
                  .ENDM
ANDGopGzp          .MACRO param
                  .BYTE $5A25,  param
                  .ENDM                  
ANDGopHzp          .MACRO param          
                  .BYTE $5B25,  param
                  .ENDM
ANDGopIzp          .MACRO param
                  .BYTE $6825,  param
                  .ENDM
ANDGopJzp          .MACRO param
                  .BYTE $6925,  param
                  .ENDM
ANDGopKzp          .MACRO param          
                  .BYTE $6A25,  param
                  .ENDM
ANDGopLzp          .MACRO param
                  .BYTE $6B25,  param
                  .ENDM
ANDGopMzp          .MACRO param
                  .BYTE $7825,  param
                  .ENDM                  
ANDGopNzp          .MACRO param          
                  .BYTE $7925,  param
                  .ENDM
ANDGopOzp          .MACRO param
                  .BYTE $7A25,  param
                  .ENDM
ANDGopQzp          .MACRO param
                  .BYTE $7B25,  param
                  .ENDM
                  
ANDHopAzp          .MACRO param
                  .BYTE $4C25,  param
                  .ENDM                
ANDHopBzp          .MACRO param          
                  .BYTE $4D25,  param
                  .ENDM
ANDHopCzp          .MACRO param
                  .BYTE $4E25,  param
                  .ENDM
ANDHopDzp          .MACRO param
                  .BYTE $4F25,  param
                  .ENDM
ANDHopEzp          .MACRO param          
                  .BYTE $5C25,  param
                  .ENDM
ANDHopFzp          .MACRO param
                  .BYTE $5D25,  param
                  .ENDM
ANDHopGzp          .MACRO param
                  .BYTE $5E25,  param
                  .ENDM                  
ANDHopHzp          .MACRO param          
                  .BYTE $5F25,  param
                  .ENDM
ANDHopIzp          .MACRO param
                  .BYTE $6C25,  param
                  .ENDM
ANDHopJzp          .MACRO param
                  .BYTE $6D25,  param
                  .ENDM
ANDHopKzp          .MACRO param          
                  .BYTE $6E25,  param
                  .ENDM
ANDHopLzp          .MACRO param
                  .BYTE $6F25,  param
                  .ENDM
ANDHopMzp          .MACRO param
                  .BYTE $7C25,  param
                  .ENDM                  
ANDHopNzp          .MACRO param          
                  .BYTE $7D25,  param
                  .ENDM
ANDHopOzp          .MACRO param
                  .BYTE $7E25,  param
                  .ENDM
ANDHopQzp          .MACRO param
                  .BYTE $7F25,  param
                  .ENDM
                  
ANDIopAzp          .MACRO param
                  .BYTE $8025,  param
                  .ENDM                
ANDIopBzp          .MACRO param          
                  .BYTE $8125,  param
                  .ENDM
ANDIopCzp          .MACRO param
                  .BYTE $8225,  param
                  .ENDM
ANDIopDzp          .MACRO param
                  .BYTE $8325,  param
                  .ENDM
ANDIopEzp          .MACRO param          
                  .BYTE $9025,  param
                  .ENDM
ANDIopFzp          .MACRO param
                  .BYTE $9125,  param
                  .ENDM
ANDIopGzp          .MACRO param
                  .BYTE $9225,  param
                  .ENDM                  
ANDIopHzp          .MACRO param          
                  .BYTE $9325,  param
                  .ENDM
ANDIopIzp          .MACRO param
                  .BYTE $A025,  param
                  .ENDM
ANDIopJzp          .MACRO param
                  .BYTE $A125,  param
                  .ENDM
ANDIopKzp          .MACRO param          
                  .BYTE $A225,  param
                  .ENDM
ANDIopLzp          .MACRO param
                  .BYTE $A325,  param
                  .ENDM
ANDIopMzp          .MACRO param
                  .BYTE $B025,  param
                  .ENDM                  
ANDIopNzp          .MACRO param          
                  .BYTE $B125,  param
                  .ENDM
ANDIopOzp          .MACRO param
                  .BYTE $B225,  param
                  .ENDM
ANDIopQzp          .MACRO param
                  .BYTE $B325,  param
                  .ENDM
                  
ANDJopAzp          .MACRO param
                  .BYTE $8425,  param
                  .ENDM                
ANDJopBzp          .MACRO param          
                  .BYTE $8525,  param
                  .ENDM
ANDJopCzp          .MACRO param
                  .BYTE $8625,  param
                  .ENDM
ANDJopDzp          .MACRO param
                  .BYTE $8725,  param
                  .ENDM
ANDJopEzp          .MACRO param          
                  .BYTE $9425,  param
                  .ENDM
ANDJopFzp          .MACRO param
                  .BYTE $9525,  param
                  .ENDM
ANDJopGzp          .MACRO param
                  .BYTE $9625,  param
                  .ENDM                  
ANDJopHzp          .MACRO param          
                  .BYTE $9725,  param
                  .ENDM
ANDJopIzp          .MACRO param
                  .BYTE $A425,  param
                  .ENDM
ANDJopJzp          .MACRO param
                  .BYTE $A525,  param
                  .ENDM
ANDJopKzp          .MACRO param          
                  .BYTE $A625,  param
                  .ENDM
ANDJopLzp          .MACRO param
                  .BYTE $A725,  param
                  .ENDM
ANDJopMzp          .MACRO param
                  .BYTE $B425,  param
                  .ENDM                  
ANDJopNzp          .MACRO param          
                  .BYTE $B525,  param
                  .ENDM
ANDJopOzp          .MACRO param
                  .BYTE $B625,  param
                  .ENDM
ANDJopQzp          .MACRO param
                  .BYTE $B725,  param
                  .ENDM
                  
ANDKopAzp          .MACRO param
                  .BYTE $8825,  param
                  .ENDM                
ANDKopBzp          .MACRO param          
                  .BYTE $8925,  param
                  .ENDM
ANDKopCzp          .MACRO param
                  .BYTE $8A25,  param
                  .ENDM
ANDKopDzp          .MACRO param
                  .BYTE $8B25,  param
                  .ENDM
ANDKopEzp          .MACRO param          
                  .BYTE $9825,  param
                  .ENDM
ANDKopFzp          .MACRO param
                  .BYTE $9925,  param
                  .ENDM
ANDKopGzp          .MACRO param
                  .BYTE $9A25,  param
                  .ENDM                  
ANDKopHzp          .MACRO param          
                  .BYTE $9B25,  param
                  .ENDM
ANDKopIzp          .MACRO param
                  .BYTE $A825,  param
                  .ENDM
ANDKopJzp          .MACRO param
                  .BYTE $A925,  param
                  .ENDM
ANDKopKzp          .MACRO param          
                  .BYTE $AA25,  param
                  .ENDM
ANDKopLzp          .MACRO param
                  .BYTE $AB25,  param
                  .ENDM
ANDKopMzp          .MACRO param
                  .BYTE $B825,  param
                  .ENDM                  
ANDKopNzp          .MACRO param          
                  .BYTE $B925,  param
                  .ENDM
ANDKopOzp          .MACRO param
                  .BYTE $BA25,  param
                  .ENDM
ANDKopQzp          .MACRO param
                  .BYTE $BB25,  param
                  .ENDM
                  
ANDLopAzp          .MACRO param
                  .BYTE $8C25,  param
                  .ENDM                
ANDLopBzp          .MACRO param          
                  .BYTE $8D25,  param
                  .ENDM
ANDLopCzp          .MACRO param
                  .BYTE $8E25,  param
                  .ENDM
ANDLopDzp          .MACRO param
                  .BYTE $8F25,  param
                  .ENDM
ANDLopEzp          .MACRO param          
                  .BYTE $9C25,  param
                  .ENDM
ANDLopFzp          .MACRO param
                  .BYTE $9D25,  param
                  .ENDM
ANDLopGzp          .MACRO param
                  .BYTE $9E25,  param
                  .ENDM                  
ANDLopHzp          .MACRO param          
                  .BYTE $9F25,  param
                  .ENDM
ANDLopIzp          .MACRO param
                  .BYTE $AC25,  param
                  .ENDM
ANDLopJzp          .MACRO param
                  .BYTE $AD25,  param
                  .ENDM
ANDLopKzp          .MACRO param          
                  .BYTE $AE25,  param
                  .ENDM
ANDLopLzp          .MACRO param
                  .BYTE $AF25,  param
                  .ENDM
ANDLopMzp          .MACRO param
                  .BYTE $BC25,  param
                  .ENDM                  
ANDLopNzp          .MACRO param          
                  .BYTE $BD25,  param
                  .ENDM
ANDLopOzp          .MACRO param
                  .BYTE $BE25,  param
                  .ENDM
ANDLopQzp          .MACRO param
                  .BYTE $BF25,  param
                  .ENDM
                  
ANDMopAzp          .MACRO param
                  .BYTE $C025,  param
                  .ENDM                
ANDMopBzp          .MACRO param          
                  .BYTE $C125,  param
                  .ENDM
ANDMopCzp          .MACRO param
                  .BYTE $C225,  param
                  .ENDM
ANDMopDzp          .MACRO param
                  .BYTE $C325,  param
                  .ENDM
ANDMopEzp          .MACRO param          
                  .BYTE $D025,  param
                  .ENDM
ANDMopFzp          .MACRO param
                  .BYTE $D125,  param
                  .ENDM
ANDMopGzp          .MACRO param
                  .BYTE $D225,  param
                  .ENDM                  
ANDMopHzp          .MACRO param          
                  .BYTE $D325,  param
                  .ENDM
ANDMopIzp          .MACRO param
                  .BYTE $E025,  param
                  .ENDM
ANDMopJzp          .MACRO param
                  .BYTE $E125,  param
                  .ENDM
ANDMopKzp          .MACRO param          
                  .BYTE $E225,  param
                  .ENDM
ANDMopLzp          .MACRO param
                  .BYTE $E325,  param
                  .ENDM
ANDMopMzp          .MACRO param
                  .BYTE $F025,  param
                  .ENDM                  
ANDMopNzp          .MACRO param          
                  .BYTE $F125,  param
                  .ENDM
ANDMopOzp          .MACRO param
                  .BYTE $F225,  param
                  .ENDM
ANDMopQzp          .MACRO param
                  .BYTE $F325,  param
                  .ENDM
                  
ANDNopAzp          .MACRO param
                  .BYTE $C425,  param
                  .ENDM                
ANDNopBzp          .MACRO param          
                  .BYTE $C525,  param
                  .ENDM
ANDNopCzp          .MACRO param
                  .BYTE $C625,  param
                  .ENDM
ANDNopDzp          .MACRO param
                  .BYTE $C725,  param
                  .ENDM
ANDNopEzp          .MACRO param          
                  .BYTE $D425,  param
                  .ENDM
ANDNopFzp          .MACRO param
                  .BYTE $D525,  param
                  .ENDM
ANDNopGzp          .MACRO param
                  .BYTE $D625,  param
                  .ENDM                  
ANDNopHzp          .MACRO param          
                  .BYTE $D725,  param
                  .ENDM
ANDNopIzp          .MACRO param
                  .BYTE $E425,  param
                  .ENDM
ANDNopJzp          .MACRO param
                  .BYTE $E525,  param
                  .ENDM
ANDNopKzp          .MACRO param          
                  .BYTE $E625,  param
                  .ENDM
ANDNopLzp          .MACRO param
                  .BYTE $E725,  param
                  .ENDM
ANDNopMzp          .MACRO param
                  .BYTE $F425,  param
                  .ENDM                  
ANDNopNzp          .MACRO param          
                  .BYTE $F525,  param
                  .ENDM
ANDNopOzp          .MACRO param
                  .BYTE $F625,  param
                  .ENDM
ANDNopQzp          .MACRO param
                  .BYTE $F725,  param
                  .ENDM
            
ANDOopAzp          .MACRO param
                  .BYTE $C825,  param
                  .ENDM                
ANDOopBzp          .MACRO param          
                  .BYTE $C925,  param
                  .ENDM
ANDOopCzp          .MACRO param
                  .BYTE $CA25,  param
                  .ENDM
ANDOopDzp          .MACRO param
                  .BYTE $CB25,  param
                  .ENDM
ANDOopEzp          .MACRO param          
                  .BYTE $D825,  param
                  .ENDM
ANDOopFzp          .MACRO param
                  .BYTE $D925,  param
                  .ENDM
ANDOopGzp          .MACRO param
                  .BYTE $DA25,  param
                  .ENDM                  
ANDOopHzp          .MACRO param          
                  .BYTE $DB25,  param
                  .ENDM
ANDOopIzp          .MACRO param
                  .BYTE $E825,  param
                  .ENDM
ANDOopJzp          .MACRO param
                  .BYTE $E925,  param
                  .ENDM
ANDOopKzp          .MACRO param          
                  .BYTE $EA25,  param
                  .ENDM
ANDOopLzp          .MACRO param
                  .BYTE $EB25,  param
                  .ENDM
ANDOopMzp          .MACRO param
                  .BYTE $F825,  param
                  .ENDM                  
ANDOopNzp          .MACRO param          
                  .BYTE $F925,  param
                  .ENDM
ANDOopOzp          .MACRO param
                  .BYTE $FA25,  param
                  .ENDM
ANDOopQzp          .MACRO param
                  .BYTE $FB25,  param
                  .ENDM
                  
ANDQopAzp          .MACRO param
                  .BYTE $CC25,  param
                  .ENDM                
ANDQopBzp          .MACRO param          
                  .BYTE $CD25,  param
                  .ENDM
ANDQopCzp          .MACRO param
                  .BYTE $CE25,  param
                  .ENDM
ANDQopDzp          .MACRO param
                  .BYTE $CF25,  param
                  .ENDM
ANDQopEzp          .MACRO param          
                  .BYTE $DC25,  param
                  .ENDM
ANDQopFzp          .MACRO param
                  .BYTE $DD25,  param
                  .ENDM
ANDQopGzp          .MACRO param
                  .BYTE $DE25,  param
                  .ENDM                  
ANDQopHzp          .MACRO param          
                  .BYTE $DF25,  param
                  .ENDM
ANDQopIzp          .MACRO param
                  .BYTE $EC25,  param
                  .ENDM
ANDQopJzp          .MACRO param
                  .BYTE $ED25,  param
                  .ENDM
ANDQopKzp          .MACRO param          
                  .BYTE $EE25,  param
                  .ENDM
ANDQopLzp          .MACRO param
                  .BYTE $EF25,  param
                  .ENDM
ANDQopMzp          .MACRO param
                  .BYTE $FC25,  param
                  .ENDM                  
ANDQopNzp          .MACRO param          
                  .BYTE $FD25,  param
                  .ENDM
ANDQopOzp          .MACRO param
                  .BYTE $FE25,  param
                  .ENDM
ANDQopQzp          .MACRO param
                  .BYTE $FF25,  param
                  .ENDM
                  
;EOR $xxxx              $0045
EORAopBzp          .MACRO param          
                  .BYTE $0145,  param
                  .ENDM
EORAopCzp          .MACRO param
                  .BYTE $0245,  param
                  .ENDM
EORAopDzp          .MACRO param
                  .BYTE $0345,  param
                  .ENDM
EORAopEzp          .MACRO param          
                  .BYTE $1045,  param
                  .ENDM
EORAopFzp          .MACRO param
                  .BYTE $1145,  param
                  .ENDM
EORAopGzp          .MACRO param
                  .BYTE $1245,  param
                  .ENDM                  
EORAopHzp          .MACRO param          
                  .BYTE $1345,  param
                  .ENDM
EORAopIzp          .MACRO param
                  .BYTE $2045,  param
                  .ENDM
EORAopJzp          .MACRO param
                  .BYTE $2145,  param
                  .ENDM
EORAopKzp          .MACRO param          
                  .BYTE $2245,  param
                  .ENDM
EORAopLzp          .MACRO param
                  .BYTE $2345,  param
                  .ENDM
EORAopMzp          .MACRO param
                  .BYTE $3045,  param
                  .ENDM                  
EORAopNzp          .MACRO param          
                  .BYTE $3145,  param
                  .ENDM
EORAopOzp          .MACRO param
                  .BYTE $3245,  param
                  .ENDM
EORAopQzp          .MACRO param
                  .BYTE $3345,  param
                  .ENDM
                                    
EORBopAzp          .MACRO param
                  .BYTE $0445,  param
                  .ENDM                
EORBopBzp          .MACRO param          
                  .BYTE $0545,  param
                  .ENDM
EORBopCzp          .MACRO param
                  .BYTE $0645,  param
                  .ENDM
EORBopDzp          .MACRO param
                  .BYTE $0745,  param
                  .ENDM
EORBopEzp          .MACRO param          
                  .BYTE $1445,  param
                  .ENDM
EORBopFzp          .MACRO param
                  .BYTE $1545,  param
                  .ENDM
EORBopGzp          .MACRO param
                  .BYTE $1645,  param
                  .ENDM                  
EORBopHzp          .MACRO param          
                  .BYTE $1745,  param
                  .ENDM
EORBopIzp          .MACRO param
                  .BYTE $2445,  param
                  .ENDM
EORBopJzp          .MACRO param
                  .BYTE $2545,  param
                  .ENDM
EORBopKzp          .MACRO param          
                  .BYTE $2645,  param
                  .ENDM
EORBopLzp          .MACRO param
                  .BYTE $2745,  param
                  .ENDM
EORBopMzp          .MACRO param
                  .BYTE $3045,  param
                  .ENDM                  
EORBopNzp          .MACRO param          
                  .BYTE $3145,  param
                  .ENDM
EORBopOzp          .MACRO param
                  .BYTE $3245,  param
                  .ENDM
EORBopQzp          .MACRO param
                  .BYTE $3345,  param
                  .ENDM
                                    
EORCopAzp          .MACRO param
                  .BYTE $0845,  param
                  .ENDM                
EORCopBzp          .MACRO param          
                  .BYTE $0945,  param
                  .ENDM
EORCopCzp          .MACRO param
                  .BYTE $0A45,  param
                  .ENDM
EORCopDzp          .MACRO param
                  .BYTE $0B45,  param
                  .ENDM
EORCopEzp          .MACRO param          
                  .BYTE $1845,  param
                  .ENDM
EORCopFzp          .MACRO param
                  .BYTE $1945,  param
                  .ENDM
EORCopGzp          .MACRO param
                  .BYTE $1A45,  param
                  .ENDM                  
EORCopHzp          .MACRO param          
                  .BYTE $1B45,  param
                  .ENDM
EORCopIzp          .MACRO param
                  .BYTE $2845,  param
                  .ENDM
EORCopJzp          .MACRO param
                  .BYTE $2945,  param
                  .ENDM
EORCopKzp          .MACRO param          
                  .BYTE $2A45,  param
                  .ENDM
EORCopLzp          .MACRO param
                  .BYTE $2B45,  param
                  .ENDM
EORCopMzp          .MACRO param
                  .BYTE $3845,  param
                  .ENDM                  
EORCopNzp          .MACRO param          
                  .BYTE $3945,  param
                  .ENDM
EORCopOzp          .MACRO param
                  .BYTE $3A45,  param
                  .ENDM
EORCopQzp          .MACRO param
                  .BYTE $3B45,  param
                  .ENDM

EORDopAzp          .MACRO param
                  .BYTE $0C45,  param
                  .ENDM                
EORDopBzp          .MACRO param          
                  .BYTE $0D45,  param
                  .ENDM
EORDopCzp          .MACRO param
                  .BYTE $0E45,  param
                  .ENDM
EORDopDzp          .MACRO param
                  .BYTE $0F45,  param
                  .ENDM
EORDopEzp          .MACRO param          
                  .BYTE $1C45,  param
                  .ENDM
EORDopFzp          .MACRO param
                  .BYTE $1D45,  param
                  .ENDM
EORDopGzp          .MACRO param
                  .BYTE $1E45,  param
                  .ENDM                  
EORDopHzp          .MACRO param          
                  .BYTE $1F45,  param
                  .ENDM
EORDopIzp          .MACRO param
                  .BYTE $2C45,  param
                  .ENDM
EORDopJzp          .MACRO param
                  .BYTE $2D45,  param
                  .ENDM
EORDopKzp          .MACRO param          
                  .BYTE $2E45,  param
                  .ENDM
EORDopLzp          .MACRO param
                  .BYTE $2F45,  param
                  .ENDM
EORDopMzp          .MACRO param
                  .BYTE $3C45,  param
                  .ENDM                  
EORDopNzp          .MACRO param          
                  .BYTE $3D45,  param
                  .ENDM
EORDopOzp          .MACRO param
                  .BYTE $3E45,  param
                  .ENDM
EORDopQzp          .MACRO param
                  .BYTE $3F45,  param
                  .ENDM                  

EOREopAzp          .MACRO param
                  .BYTE $4045,  param
                  .ENDM                
EOREopBzp          .MACRO param          
                  .BYTE $4145,  param
                  .ENDM
EOREopCzp          .MACRO param
                  .BYTE $4245,  param
                  .ENDM
EOREopDzp          .MACRO param
                  .BYTE $4345,  param
                  .ENDM
EOREopEzp          .MACRO param          
                  .BYTE $5045,  param
                  .ENDM
EOREopFzp          .MACRO param
                  .BYTE $5145,  param
                  .ENDM
EOREopGzp          .MACRO param
                  .BYTE $5245,  param
                  .ENDM                  
EOREopHzp          .MACRO param          
                  .BYTE $5345,  param
                  .ENDM
EOREopIzp          .MACRO param
                  .BYTE $6045,  param
                  .ENDM
EOREopJzp          .MACRO param
                  .BYTE $6145,  param
                  .ENDM
EOREopKzp          .MACRO param          
                  .BYTE $6245,  param
                  .ENDM
EOREopLzp          .MACRO param
                  .BYTE $6345,  param
                  .ENDM
EOREopMzp          .MACRO param
                  .BYTE $7045,  param
                  .ENDM                  
EOREopNzp          .MACRO param          
                  .BYTE $7145,  param
                  .ENDM
EOREopOzp          .MACRO param
                  .BYTE $7245,  param
                  .ENDM
EOREopQzp          .MACRO param
                  .BYTE $7345,  param
                  .ENDM
                  
EORFopAzp          .MACRO param
                  .BYTE $4445,  param
                  .ENDM                
EORFopBzp          .MACRO param          
                  .BYTE $4545,  param
                  .ENDM
EORFopCzp          .MACRO param
                  .BYTE $4645,  param
                  .ENDM
EORFopDzp          .MACRO param
                  .BYTE $4745,  param
                  .ENDM
EORFopEzp          .MACRO param          
                  .BYTE $5445,  param
                  .ENDM
EORFopFzp          .MACRO param
                  .BYTE $5545,  param
                  .ENDM
EORFopGzp          .MACRO param
                  .BYTE $5645,  param
                  .ENDM                  
EORFopHzp          .MACRO param          
                  .BYTE $5745,  param
                  .ENDM
EORFopIzp          .MACRO param
                  .BYTE $6445,  param
                  .ENDM
EORFopJzp          .MACRO param
                  .BYTE $6545,  param
                  .ENDM
EORFopKzp          .MACRO param          
                  .BYTE $6645,  param
                  .ENDM
EORFopLzp          .MACRO param
                  .BYTE $6745,  param
                  .ENDM
EORFopMzp          .MACRO param
                  .BYTE $7445,  param
                  .ENDM                  
EORFopNzp          .MACRO param          
                  .BYTE $7545,  param
                  .ENDM
EORFopOzp          .MACRO param
                  .BYTE $7645,  param
                  .ENDM
EORFopQzp          .MACRO param
                  .BYTE $7745,  param
                  .ENDM                  
                           
EORGopAzp          .MACRO param
                  .BYTE $4845,  param
                  .ENDM                
EORGopBzp          .MACRO param          
                  .BYTE $4945,  param
                  .ENDM
EORGopCzp          .MACRO param
                  .BYTE $4A45,  param
                  .ENDM
EORGopDzp          .MACRO param
                  .BYTE $4B45,  param
                  .ENDM
EORGopEzp          .MACRO param          
                  .BYTE $5845,  param
                  .ENDM
EORGopFzp          .MACRO param
                  .BYTE $5945,  param
                  .ENDM
EORGopGzp          .MACRO param
                  .BYTE $5A45,  param
                  .ENDM                  
EORGopHzp          .MACRO param          
                  .BYTE $5B45,  param
                  .ENDM
EORGopIzp          .MACRO param
                  .BYTE $6845,  param
                  .ENDM
EORGopJzp          .MACRO param
                  .BYTE $6945,  param
                  .ENDM
EORGopKzp          .MACRO param          
                  .BYTE $6A45,  param
                  .ENDM
EORGopLzp          .MACRO param
                  .BYTE $6B45,  param
                  .ENDM
EORGopMzp          .MACRO param
                  .BYTE $7845,  param
                  .ENDM                  
EORGopNzp          .MACRO param          
                  .BYTE $7945,  param
                  .ENDM
EORGopOzp          .MACRO param
                  .BYTE $7A45,  param
                  .ENDM
EORGopQzp          .MACRO param
                  .BYTE $7B45,  param
                  .ENDM
                  
EORHopAzp          .MACRO param
                  .BYTE $4C45,  param
                  .ENDM                
EORHopBzp          .MACRO param          
                  .BYTE $4D45,  param
                  .ENDM
EORHopCzp          .MACRO param
                  .BYTE $4E45,  param
                  .ENDM
EORHopDzp          .MACRO param
                  .BYTE $4F45,  param
                  .ENDM
EORHopEzp          .MACRO param          
                  .BYTE $5C45,  param
                  .ENDM
EORHopFzp          .MACRO param
                  .BYTE $5D45,  param
                  .ENDM
EORHopGzp          .MACRO param
                  .BYTE $5E45,  param
                  .ENDM                  
EORHopHzp          .MACRO param          
                  .BYTE $5F45,  param
                  .ENDM
EORHopIzp          .MACRO param
                  .BYTE $6C45,  param
                  .ENDM
EORHopJzp          .MACRO param
                  .BYTE $6D45,  param
                  .ENDM
EORHopKzp          .MACRO param          
                  .BYTE $6E45,  param
                  .ENDM
EORHopLzp          .MACRO param
                  .BYTE $6F45,  param
                  .ENDM
EORHopMzp          .MACRO param
                  .BYTE $7C45,  param
                  .ENDM                  
EORHopNzp          .MACRO param          
                  .BYTE $7D45,  param
                  .ENDM
EORHopOzp          .MACRO param
                  .BYTE $7E45,  param
                  .ENDM
EORHopQzp          .MACRO param
                  .BYTE $7F45,  param
                  .ENDM
                  
EORIopAzp          .MACRO param
                  .BYTE $8045,  param
                  .ENDM                
EORIopBzp          .MACRO param          
                  .BYTE $8145,  param
                  .ENDM
EORIopCzp          .MACRO param
                  .BYTE $8245,  param
                  .ENDM
EORIopDzp          .MACRO param
                  .BYTE $8345,  param
                  .ENDM
EORIopEzp          .MACRO param          
                  .BYTE $9045,  param
                  .ENDM
EORIopFzp          .MACRO param
                  .BYTE $9145,  param
                  .ENDM
EORIopGzp          .MACRO param
                  .BYTE $9245,  param
                  .ENDM                  
EORIopHzp          .MACRO param          
                  .BYTE $9345,  param
                  .ENDM
EORIopIzp          .MACRO param
                  .BYTE $A045,  param
                  .ENDM
EORIopJzp          .MACRO param
                  .BYTE $A145,  param
                  .ENDM
EORIopKzp          .MACRO param          
                  .BYTE $A245,  param
                  .ENDM
EORIopLzp          .MACRO param
                  .BYTE $A345,  param
                  .ENDM
EORIopMzp          .MACRO param
                  .BYTE $B045,  param
                  .ENDM                  
EORIopNzp          .MACRO param          
                  .BYTE $B145,  param
                  .ENDM
EORIopOzp          .MACRO param
                  .BYTE $B245,  param
                  .ENDM
EORIopQzp          .MACRO param
                  .BYTE $B345,  param
                  .ENDM
                  
EORJopAzp          .MACRO param
                  .BYTE $8445,  param
                  .ENDM                
EORJopBzp          .MACRO param          
                  .BYTE $8545,  param
                  .ENDM
EORJopCzp          .MACRO param
                  .BYTE $8645,  param
                  .ENDM
EORJopDzp          .MACRO param
                  .BYTE $8745,  param
                  .ENDM
EORJopEzp          .MACRO param          
                  .BYTE $9445,  param
                  .ENDM
EORJopFzp          .MACRO param
                  .BYTE $9545,  param
                  .ENDM
EORJopGzp          .MACRO param
                  .BYTE $9645,  param
                  .ENDM                  
EORJopHzp          .MACRO param          
                  .BYTE $9745,  param
                  .ENDM
EORJopIzp          .MACRO param
                  .BYTE $A445,  param
                  .ENDM
EORJopJzp          .MACRO param
                  .BYTE $A545,  param
                  .ENDM
EORJopKzp          .MACRO param          
                  .BYTE $A645,  param
                  .ENDM
EORJopLzp          .MACRO param
                  .BYTE $A745,  param
                  .ENDM
EORJopMzp          .MACRO param
                  .BYTE $B445,  param
                  .ENDM                  
EORJopNzp          .MACRO param          
                  .BYTE $B545,  param
                  .ENDM
EORJopOzp          .MACRO param
                  .BYTE $B645,  param
                  .ENDM
EORJopQzp          .MACRO param
                  .BYTE $B745,  param
                  .ENDM
                  
EORKopAzp          .MACRO param
                  .BYTE $8845,  param
                  .ENDM                
EORKopBzp          .MACRO param          
                  .BYTE $8945,  param
                  .ENDM
EORKopCzp          .MACRO param
                  .BYTE $8A45,  param
                  .ENDM
EORKopDzp          .MACRO param
                  .BYTE $8B45,  param
                  .ENDM
EORKopEzp          .MACRO param          
                  .BYTE $9845,  param
                  .ENDM
EORKopFzp          .MACRO param
                  .BYTE $9945,  param
                  .ENDM
EORKopGzp          .MACRO param
                  .BYTE $9A45,  param
                  .ENDM                  
EORKopHzp          .MACRO param          
                  .BYTE $9B45,  param
                  .ENDM
EORKopIzp          .MACRO param
                  .BYTE $A845,  param
                  .ENDM
EORKopJzp          .MACRO param
                  .BYTE $A945,  param
                  .ENDM
EORKopKzp          .MACRO param          
                  .BYTE $AA45,  param
                  .ENDM
EORKopLzp          .MACRO param
                  .BYTE $AB45,  param
                  .ENDM
EORKopMzp          .MACRO param
                  .BYTE $B845,  param
                  .ENDM                  
EORKopNzp          .MACRO param          
                  .BYTE $B945,  param
                  .ENDM
EORKopOzp          .MACRO param
                  .BYTE $BA45,  param
                  .ENDM
EORKopQzp          .MACRO param
                  .BYTE $BB45,  param
                  .ENDM
                  
EORLopAzp          .MACRO param
                  .BYTE $8C45,  param
                  .ENDM                
EORLopBzp          .MACRO param          
                  .BYTE $8D45,  param
                  .ENDM
EORLopCzp          .MACRO param
                  .BYTE $8E45,  param
                  .ENDM
EORLopDzp          .MACRO param
                  .BYTE $8F45,  param
                  .ENDM
EORLopEzp          .MACRO param          
                  .BYTE $9C45,  param
                  .ENDM
EORLopFzp          .MACRO param
                  .BYTE $9D45,  param
                  .ENDM
EORLopGzp          .MACRO param
                  .BYTE $9E45,  param
                  .ENDM                  
EORLopHzp          .MACRO param          
                  .BYTE $9F45,  param
                  .ENDM
EORLopIzp          .MACRO param
                  .BYTE $AC45,  param
                  .ENDM
EORLopJzp          .MACRO param
                  .BYTE $AD45,  param
                  .ENDM
EORLopKzp          .MACRO param          
                  .BYTE $AE45,  param
                  .ENDM
EORLopLzp          .MACRO param
                  .BYTE $AF45,  param
                  .ENDM
EORLopMzp          .MACRO param
                  .BYTE $BC45,  param
                  .ENDM                  
EORLopNzp          .MACRO param          
                  .BYTE $BD45,  param
                  .ENDM
EORLopOzp          .MACRO param
                  .BYTE $BE45,  param
                  .ENDM
EORLopQzp          .MACRO param
                  .BYTE $BF45,  param
                  .ENDM
                  
EORMopAzp          .MACRO param
                  .BYTE $C045,  param
                  .ENDM                
EORMopBzp          .MACRO param          
                  .BYTE $C145,  param
                  .ENDM
EORMopCzp          .MACRO param
                  .BYTE $C245,  param
                  .ENDM
EORMopDzp          .MACRO param
                  .BYTE $C345,  param
                  .ENDM
EORMopEzp          .MACRO param          
                  .BYTE $D045,  param
                  .ENDM
EORMopFzp          .MACRO param
                  .BYTE $D145,  param
                  .ENDM
EORMopGzp          .MACRO param
                  .BYTE $D245,  param
                  .ENDM                  
EORMopHzp          .MACRO param          
                  .BYTE $D345,  param
                  .ENDM
EORMopIzp          .MACRO param
                  .BYTE $E045,  param
                  .ENDM
EORMopJzp          .MACRO param
                  .BYTE $E145,  param
                  .ENDM
EORMopKzp          .MACRO param          
                  .BYTE $E245,  param
                  .ENDM
EORMopLzp          .MACRO param
                  .BYTE $E345,  param
                  .ENDM
EORMopMzp          .MACRO param
                  .BYTE $F045,  param
                  .ENDM                  
EORMopNzp          .MACRO param          
                  .BYTE $F145,  param
                  .ENDM
EORMopOzp          .MACRO param
                  .BYTE $F245,  param
                  .ENDM
EORMopQzp          .MACRO param
                  .BYTE $F345,  param
                  .ENDM
                  
EORNopAzp          .MACRO param
                  .BYTE $C445,  param
                  .ENDM                
EORNopBzp          .MACRO param          
                  .BYTE $C545,  param
                  .ENDM
EORNopCzp          .MACRO param
                  .BYTE $C645,  param
                  .ENDM
EORNopDzp          .MACRO param
                  .BYTE $C745,  param
                  .ENDM
EORNopEzp          .MACRO param          
                  .BYTE $D445,  param
                  .ENDM
EORNopFzp          .MACRO param
                  .BYTE $D545,  param
                  .ENDM
EORNopGzp          .MACRO param
                  .BYTE $D645,  param
                  .ENDM                  
EORNopHzp          .MACRO param          
                  .BYTE $D745,  param
                  .ENDM
EORNopIzp          .MACRO param
                  .BYTE $E445,  param
                  .ENDM
EORNopJzp          .MACRO param
                  .BYTE $E545,  param
                  .ENDM
EORNopKzp          .MACRO param          
                  .BYTE $E645,  param
                  .ENDM
EORNopLzp          .MACRO param
                  .BYTE $E745,  param
                  .ENDM
EORNopMzp          .MACRO param
                  .BYTE $F445,  param
                  .ENDM                  
EORNopNzp          .MACRO param          
                  .BYTE $F545,  param
                  .ENDM
EORNopOzp          .MACRO param
                  .BYTE $F645,  param
                  .ENDM
EORNopQzp          .MACRO param
                  .BYTE $F745,  param
                  .ENDM
            
EOROopAzp          .MACRO param
                  .BYTE $C845,  param
                  .ENDM                
EOROopBzp          .MACRO param          
                  .BYTE $C945,  param
                  .ENDM
EOROopCzp          .MACRO param
                  .BYTE $CA45,  param
                  .ENDM
EOROopDzp          .MACRO param
                  .BYTE $CB45,  param
                  .ENDM
EOROopEzp          .MACRO param          
                  .BYTE $D845,  param
                  .ENDM
EOROopFzp          .MACRO param
                  .BYTE $D945,  param
                  .ENDM
EOROopGzp          .MACRO param
                  .BYTE $DA45,  param
                  .ENDM                  
EOROopHzp          .MACRO param          
                  .BYTE $DB45,  param
                  .ENDM
EOROopIzp          .MACRO param
                  .BYTE $E845,  param
                  .ENDM
EOROopJzp          .MACRO param
                  .BYTE $E945,  param
                  .ENDM
EOROopKzp          .MACRO param          
                  .BYTE $EA45,  param
                  .ENDM
EOROopLzp          .MACRO param
                  .BYTE $EB45,  param
                  .ENDM
EOROopMzp          .MACRO param
                  .BYTE $F845,  param
                  .ENDM                  
EOROopNzp          .MACRO param          
                  .BYTE $F945,  param
                  .ENDM
EOROopOzp          .MACRO param
                  .BYTE $FA45,  param
                  .ENDM
EOROopQzp          .MACRO param
                  .BYTE $FB45,  param
                  .ENDM
                  
EORQopAzp          .MACRO param
                  .BYTE $CC45,  param
                  .ENDM                
EORQopBzp          .MACRO param          
                  .BYTE $CD45,  param
                  .ENDM
EORQopCzp          .MACRO param
                  .BYTE $CE45,  param
                  .ENDM
EORQopDzp          .MACRO param
                  .BYTE $CF45,  param
                  .ENDM
EORQopEzp          .MACRO param          
                  .BYTE $DC45,  param
                  .ENDM
EORQopFzp          .MACRO param
                  .BYTE $DD45,  param
                  .ENDM
EORQopGzp          .MACRO param
                  .BYTE $DE45,  param
                  .ENDM                  
EORQopHzp          .MACRO param          
                  .BYTE $DF45,  param
                  .ENDM
EORQopIzp          .MACRO param
                  .BYTE $EC45,  param
                  .ENDM
EORQopJzp          .MACRO param
                  .BYTE $ED45,  param
                  .ENDM
EORQopKzp          .MACRO param          
                  .BYTE $EE45,  param
                  .ENDM
EORQopLzp          .MACRO param
                  .BYTE $EF45,  param
                  .ENDM
EORQopMzp          .MACRO param
                  .BYTE $FC45,  param
                  .ENDM                  
EORQopNzp          .MACRO param          
                  .BYTE $FD45,  param
                  .ENDM
EORQopOzp          .MACRO param
                  .BYTE $FE45,  param
                  .ENDM
EORQopQzp          .MACRO param
                  .BYTE $FF45,  param
                  .ENDM
                  
;ADC $xxxx,x            $0075
ADCAopBzpx          .MACRO param          
                  .BYTE $0175,  param
                  .ENDM
ADCAopCzpx          .MACRO param
                  .BYTE $0275,  param
                  .ENDM
ADCAopDzpx          .MACRO param
                  .BYTE $0375,  param
                  .ENDM
ADCAopEzpx          .MACRO param          
                  .BYTE $1075,  param
                  .ENDM
ADCAopFzpx          .MACRO param
                  .BYTE $1175,  param
                  .ENDM
ADCAopGzpx          .MACRO param
                  .BYTE $1275,  param
                  .ENDM                  
ADCAopHzpx          .MACRO param          
                  .BYTE $1375,  param
                  .ENDM
ADCAopIzpx          .MACRO param
                  .BYTE $2075,  param
                  .ENDM
ADCAopJzpx          .MACRO param
                  .BYTE $2175,  param
                  .ENDM
ADCAopKzpx          .MACRO param          
                  .BYTE $2275,  param
                  .ENDM
ADCAopLzpx          .MACRO param
                  .BYTE $2375,  param
                  .ENDM
ADCAopMzpx          .MACRO param
                  .BYTE $3075,  param
                  .ENDM                  
ADCAopNzpx          .MACRO param          
                  .BYTE $3175,  param
                  .ENDM
ADCAopOzpx          .MACRO param
                  .BYTE $3275,  param
                  .ENDM
ADCAopQzpx          .MACRO param
                  .BYTE $3375,  param
                  .ENDM
                                    
ADCBopAzpx          .MACRO param
                  .BYTE $0475,  param
                  .ENDM                
ADCBopBzpx          .MACRO param          
                  .BYTE $0575,  param
                  .ENDM
ADCBopCzpx          .MACRO param
                  .BYTE $0675,  param
                  .ENDM
ADCBopDzpx          .MACRO param
                  .BYTE $0775,  param
                  .ENDM
ADCBopEzpx          .MACRO param          
                  .BYTE $1475,  param
                  .ENDM
ADCBopFzpx          .MACRO param
                  .BYTE $1575,  param
                  .ENDM
ADCBopGzpx          .MACRO param
                  .BYTE $1675,  param
                  .ENDM                  
ADCBopHzpx          .MACRO param          
                  .BYTE $1775,  param
                  .ENDM
ADCBopIzpx          .MACRO param
                  .BYTE $2475,  param
                  .ENDM
ADCBopJzpx          .MACRO param
                  .BYTE $2575,  param
                  .ENDM
ADCBopKzpx          .MACRO param          
                  .BYTE $2675,  param
                  .ENDM
ADCBopLzpx          .MACRO param
                  .BYTE $2775,  param
                  .ENDM
ADCBopMzpx          .MACRO param
                  .BYTE $3075,  param
                  .ENDM                  
ADCBopNzpx          .MACRO param          
                  .BYTE $3175,  param
                  .ENDM
ADCBopOzpx          .MACRO param
                  .BYTE $3275,  param
                  .ENDM
ADCBopQzpx          .MACRO param
                  .BYTE $3375,  param
                  .ENDM
                                    
ADCCopAzpx          .MACRO param
                  .BYTE $0875,  param
                  .ENDM                
ADCCopBzpx          .MACRO param          
                  .BYTE $0975,  param
                  .ENDM
ADCCopCzpx          .MACRO param
                  .BYTE $0A75,  param
                  .ENDM
ADCCopDzpx          .MACRO param
                  .BYTE $0B75,  param
                  .ENDM
ADCCopEzpx          .MACRO param          
                  .BYTE $1875,  param
                  .ENDM
ADCCopFzpx          .MACRO param
                  .BYTE $1975,  param
                  .ENDM
ADCCopGzpx          .MACRO param
                  .BYTE $1A75,  param
                  .ENDM                  
ADCCopHzpx          .MACRO param          
                  .BYTE $1B75,  param
                  .ENDM
ADCCopIzpx          .MACRO param
                  .BYTE $2875,  param
                  .ENDM
ADCCopJzpx          .MACRO param
                  .BYTE $2975,  param
                  .ENDM
ADCCopKzpx          .MACRO param          
                  .BYTE $2A75,  param
                  .ENDM
ADCCopLzpx          .MACRO param
                  .BYTE $2B75,  param
                  .ENDM
ADCCopMzpx          .MACRO param
                  .BYTE $3875,  param
                  .ENDM                  
ADCCopNzpx          .MACRO param          
                  .BYTE $3975,  param
                  .ENDM
ADCCopOzpx          .MACRO param
                  .BYTE $3A75,  param
                  .ENDM
ADCCopQzpx          .MACRO param
                  .BYTE $3B75,  param
                  .ENDM

ADCDopAzpx          .MACRO param
                  .BYTE $0C75,  param
                  .ENDM                
ADCDopBzpx          .MACRO param          
                  .BYTE $0D75,  param
                  .ENDM
ADCDopCzpx          .MACRO param
                  .BYTE $0E75,  param
                  .ENDM
ADCDopDzpx          .MACRO param
                  .BYTE $0F75,  param
                  .ENDM
ADCDopEzpx          .MACRO param          
                  .BYTE $1C75,  param
                  .ENDM
ADCDopFzpx          .MACRO param
                  .BYTE $1D75,  param
                  .ENDM
ADCDopGzpx          .MACRO param
                  .BYTE $1E75,  param
                  .ENDM                  
ADCDopHzpx          .MACRO param          
                  .BYTE $1F75,  param
                  .ENDM
ADCDopIzpx          .MACRO param
                  .BYTE $2C75,  param
                  .ENDM
ADCDopJzpx          .MACRO param
                  .BYTE $2D75,  param
                  .ENDM
ADCDopKzpx          .MACRO param          
                  .BYTE $2E75,  param
                  .ENDM
ADCDopLzpx          .MACRO param
                  .BYTE $2F75,  param
                  .ENDM
ADCDopMzpx          .MACRO param
                  .BYTE $3C75,  param
                  .ENDM                  
ADCDopNzpx          .MACRO param          
                  .BYTE $3D75,  param
                  .ENDM
ADCDopOzpx          .MACRO param
                  .BYTE $3E75,  param
                  .ENDM
ADCDopQzpx          .MACRO param
                  .BYTE $3F75,  param
                  .ENDM                  

ADCEopAzpx          .MACRO param
                  .BYTE $4075,  param
                  .ENDM                
ADCEopBzpx          .MACRO param          
                  .BYTE $4175,  param
                  .ENDM
ADCEopCzpx          .MACRO param
                  .BYTE $4275,  param
                  .ENDM
ADCEopDzpx          .MACRO param
                  .BYTE $4375,  param
                  .ENDM
ADCEopEzpx          .MACRO param          
                  .BYTE $5075,  param
                  .ENDM
ADCEopFzpx          .MACRO param
                  .BYTE $5175,  param
                  .ENDM
ADCEopGzpx          .MACRO param
                  .BYTE $5275,  param
                  .ENDM                  
ADCEopHzpx          .MACRO param          
                  .BYTE $5375,  param
                  .ENDM
ADCEopIzpx          .MACRO param
                  .BYTE $6075,  param
                  .ENDM
ADCEopJzpx          .MACRO param
                  .BYTE $6175,  param
                  .ENDM
ADCEopKzpx          .MACRO param          
                  .BYTE $6275,  param
                  .ENDM
ADCEopLzpx          .MACRO param
                  .BYTE $6375,  param
                  .ENDM
ADCEopMzpx          .MACRO param
                  .BYTE $7075,  param
                  .ENDM                  
ADCEopNzpx          .MACRO param          
                  .BYTE $7175,  param
                  .ENDM
ADCEopOzpx          .MACRO param
                  .BYTE $7275,  param
                  .ENDM
ADCEopQzpx          .MACRO param
                  .BYTE $7375,  param
                  .ENDM
                  
ADCFopAzpx          .MACRO param
                  .BYTE $4475,  param
                  .ENDM                
ADCFopBzpx          .MACRO param          
                  .BYTE $4575,  param
                  .ENDM
ADCFopCzpx          .MACRO param
                  .BYTE $4675,  param
                  .ENDM
ADCFopDzpx          .MACRO param
                  .BYTE $4775,  param
                  .ENDM
ADCFopEzpx          .MACRO param          
                  .BYTE $5475,  param
                  .ENDM
ADCFopFzpx          .MACRO param
                  .BYTE $5575,  param
                  .ENDM
ADCFopGzpx          .MACRO param
                  .BYTE $5675,  param
                  .ENDM                  
ADCFopHzpx          .MACRO param          
                  .BYTE $5775,  param
                  .ENDM
ADCFopIzpx          .MACRO param
                  .BYTE $6475,  param
                  .ENDM
ADCFopJzpx          .MACRO param
                  .BYTE $6575,  param
                  .ENDM
ADCFopKzpx          .MACRO param          
                  .BYTE $6675,  param
                  .ENDM
ADCFopLzpx          .MACRO param
                  .BYTE $6775,  param
                  .ENDM
ADCFopMzpx          .MACRO param
                  .BYTE $7475,  param
                  .ENDM                  
ADCFopNzpx          .MACRO param          
                  .BYTE $7575,  param
                  .ENDM
ADCFopOzpx          .MACRO param
                  .BYTE $7675,  param
                  .ENDM
ADCFopQzpx          .MACRO param
                  .BYTE $7775,  param
                  .ENDM                  
                           
ADCGopAzpx          .MACRO param
                  .BYTE $4875,  param
                  .ENDM                
ADCGopBzpx          .MACRO param          
                  .BYTE $4975,  param
                  .ENDM
ADCGopCzpx          .MACRO param
                  .BYTE $4A75,  param
                  .ENDM
ADCGopDzpx          .MACRO param
                  .BYTE $4B75,  param
                  .ENDM
ADCGopEzpx          .MACRO param          
                  .BYTE $5875,  param
                  .ENDM
ADCGopFzpx          .MACRO param
                  .BYTE $5975,  param
                  .ENDM
ADCGopGzpx          .MACRO param
                  .BYTE $5A75,  param
                  .ENDM                  
ADCGopHzpx          .MACRO param          
                  .BYTE $5B75,  param
                  .ENDM
ADCGopIzpx          .MACRO param
                  .BYTE $6875,  param
                  .ENDM
ADCGopJzpx          .MACRO param
                  .BYTE $6975,  param
                  .ENDM
ADCGopKzpx          .MACRO param          
                  .BYTE $6A75,  param
                  .ENDM
ADCGopLzpx          .MACRO param
                  .BYTE $6B75,  param
                  .ENDM
ADCGopMzpx          .MACRO param
                  .BYTE $7875,  param
                  .ENDM                  
ADCGopNzpx          .MACRO param          
                  .BYTE $7975,  param
                  .ENDM
ADCGopOzpx          .MACRO param
                  .BYTE $7A75,  param
                  .ENDM
ADCGopQzpx          .MACRO param
                  .BYTE $7B75,  param
                  .ENDM
                  
ADCHopAzpx          .MACRO param
                  .BYTE $4C75,  param
                  .ENDM                
ADCHopBzpx          .MACRO param          
                  .BYTE $4D75,  param
                  .ENDM
ADCHopCzpx          .MACRO param
                  .BYTE $4E75,  param
                  .ENDM
ADCHopDzpx          .MACRO param
                  .BYTE $4F75,  param
                  .ENDM
ADCHopEzpx          .MACRO param          
                  .BYTE $5C75,  param
                  .ENDM
ADCHopFzpx          .MACRO param
                  .BYTE $5D75,  param
                  .ENDM
ADCHopGzpx          .MACRO param
                  .BYTE $5E75,  param
                  .ENDM                  
ADCHopHzpx          .MACRO param          
                  .BYTE $5F75,  param
                  .ENDM
ADCHopIzpx          .MACRO param
                  .BYTE $6C75,  param
                  .ENDM
ADCHopJzpx          .MACRO param
                  .BYTE $6D75,  param
                  .ENDM
ADCHopKzpx          .MACRO param          
                  .BYTE $6E75,  param
                  .ENDM
ADCHopLzpx          .MACRO param
                  .BYTE $6F75,  param
                  .ENDM
ADCHopMzpx          .MACRO param
                  .BYTE $7C75,  param
                  .ENDM                  
ADCHopNzpx          .MACRO param          
                  .BYTE $7D75,  param
                  .ENDM
ADCHopOzpx          .MACRO param
                  .BYTE $7E75,  param
                  .ENDM
ADCHopQzpx          .MACRO param
                  .BYTE $7F75,  param
                  .ENDM
                  
ADCIopAzpx          .MACRO param
                  .BYTE $8075,  param
                  .ENDM                
ADCIopBzpx          .MACRO param          
                  .BYTE $8175,  param
                  .ENDM
ADCIopCzpx          .MACRO param
                  .BYTE $8275,  param
                  .ENDM
ADCIopDzpx          .MACRO param
                  .BYTE $8375,  param
                  .ENDM
ADCIopEzpx          .MACRO param          
                  .BYTE $9075,  param
                  .ENDM
ADCIopFzpx          .MACRO param
                  .BYTE $9175,  param
                  .ENDM
ADCIopGzpx          .MACRO param
                  .BYTE $9275,  param
                  .ENDM                  
ADCIopHzpx          .MACRO param          
                  .BYTE $9375,  param
                  .ENDM
ADCIopIzpx          .MACRO param
                  .BYTE $A075,  param
                  .ENDM
ADCIopJzpx          .MACRO param
                  .BYTE $A175,  param
                  .ENDM
ADCIopKzpx          .MACRO param          
                  .BYTE $A275,  param
                  .ENDM
ADCIopLzpx          .MACRO param
                  .BYTE $A375,  param
                  .ENDM
ADCIopMzpx          .MACRO param
                  .BYTE $B075,  param
                  .ENDM                  
ADCIopNzpx          .MACRO param          
                  .BYTE $B175,  param
                  .ENDM
ADCIopOzpx          .MACRO param
                  .BYTE $B275,  param
                  .ENDM
ADCIopQzpx          .MACRO param
                  .BYTE $B375,  param
                  .ENDM
                  
ADCJopAzpx          .MACRO param
                  .BYTE $8475,  param
                  .ENDM                
ADCJopBzpx          .MACRO param          
                  .BYTE $8575,  param
                  .ENDM
ADCJopCzpx          .MACRO param
                  .BYTE $8675,  param
                  .ENDM
ADCJopDzpx          .MACRO param
                  .BYTE $8775,  param
                  .ENDM
ADCJopEzpx          .MACRO param          
                  .BYTE $9475,  param
                  .ENDM
ADCJopFzpx          .MACRO param
                  .BYTE $9575,  param
                  .ENDM
ADCJopGzpx          .MACRO param
                  .BYTE $9675,  param
                  .ENDM                  
ADCJopHzpx          .MACRO param          
                  .BYTE $9775,  param
                  .ENDM
ADCJopIzpx          .MACRO param
                  .BYTE $A475,  param
                  .ENDM
ADCJopJzpx          .MACRO param
                  .BYTE $A575,  param
                  .ENDM
ADCJopKzpx          .MACRO param          
                  .BYTE $A675,  param
                  .ENDM
ADCJopLzpx          .MACRO param
                  .BYTE $A775,  param
                  .ENDM
ADCJopMzpx          .MACRO param
                  .BYTE $B475,  param
                  .ENDM                  
ADCJopNzpx          .MACRO param          
                  .BYTE $B575,  param
                  .ENDM
ADCJopOzpx          .MACRO param
                  .BYTE $B675,  param
                  .ENDM
ADCJopQzpx          .MACRO param
                  .BYTE $B775,  param
                  .ENDM
                  
ADCKopAzpx          .MACRO param
                  .BYTE $8875,  param
                  .ENDM                
ADCKopBzpx          .MACRO param          
                  .BYTE $8975,  param
                  .ENDM
ADCKopCzpx          .MACRO param
                  .BYTE $8A75,  param
                  .ENDM
ADCKopDzpx          .MACRO param
                  .BYTE $8B75,  param
                  .ENDM
ADCKopEzpx          .MACRO param          
                  .BYTE $9875,  param
                  .ENDM
ADCKopFzpx          .MACRO param
                  .BYTE $9975,  param
                  .ENDM
ADCKopGzpx          .MACRO param
                  .BYTE $9A75,  param
                  .ENDM                  
ADCKopHzpx          .MACRO param          
                  .BYTE $9B75,  param
                  .ENDM
ADCKopIzpx          .MACRO param
                  .BYTE $A875,  param
                  .ENDM
ADCKopJzpx          .MACRO param
                  .BYTE $A975,  param
                  .ENDM
ADCKopKzpx          .MACRO param          
                  .BYTE $AA75,  param
                  .ENDM
ADCKopLzpx          .MACRO param
                  .BYTE $AB75,  param
                  .ENDM
ADCKopMzpx          .MACRO param
                  .BYTE $B875,  param
                  .ENDM                  
ADCKopNzpx          .MACRO param          
                  .BYTE $B975,  param
                  .ENDM
ADCKopOzpx          .MACRO param
                  .BYTE $BA75,  param
                  .ENDM
ADCKopQzpx          .MACRO param
                  .BYTE $BB75,  param
                  .ENDM
                  
ADCLopAzpx          .MACRO param
                  .BYTE $8C75,  param
                  .ENDM                
ADCLopBzpx          .MACRO param          
                  .BYTE $8D75,  param
                  .ENDM
ADCLopCzpx          .MACRO param
                  .BYTE $8E75,  param
                  .ENDM
ADCLopDzpx          .MACRO param
                  .BYTE $8F75,  param
                  .ENDM
ADCLopEzpx          .MACRO param          
                  .BYTE $9C75,  param
                  .ENDM
ADCLopFzpx          .MACRO param
                  .BYTE $9D75,  param
                  .ENDM
ADCLopGzpx          .MACRO param
                  .BYTE $9E75,  param
                  .ENDM                  
ADCLopHzpx          .MACRO param          
                  .BYTE $9F75,  param
                  .ENDM
ADCLopIzpx          .MACRO param
                  .BYTE $AC75,  param
                  .ENDM
ADCLopJzpx          .MACRO param
                  .BYTE $AD75,  param
                  .ENDM
ADCLopKzpx          .MACRO param          
                  .BYTE $AE75,  param
                  .ENDM
ADCLopLzpx          .MACRO param
                  .BYTE $AF75,  param
                  .ENDM
ADCLopMzpx          .MACRO param
                  .BYTE $BC75,  param
                  .ENDM                  
ADCLopNzpx          .MACRO param          
                  .BYTE $BD75,  param
                  .ENDM
ADCLopOzpx          .MACRO param
                  .BYTE $BE75,  param
                  .ENDM
ADCLopQzpx          .MACRO param
                  .BYTE $BF75,  param
                  .ENDM
                  
ADCMopAzpx          .MACRO param
                  .BYTE $C075,  param
                  .ENDM                
ADCMopBzpx          .MACRO param          
                  .BYTE $C175,  param
                  .ENDM
ADCMopCzpx          .MACRO param
                  .BYTE $C275,  param
                  .ENDM
ADCMopDzpx          .MACRO param
                  .BYTE $C375,  param
                  .ENDM
ADCMopEzpx          .MACRO param          
                  .BYTE $D075,  param
                  .ENDM
ADCMopFzpx          .MACRO param
                  .BYTE $D175,  param
                  .ENDM
ADCMopGzpx          .MACRO param
                  .BYTE $D275,  param
                  .ENDM                  
ADCMopHzpx          .MACRO param          
                  .BYTE $D375,  param
                  .ENDM
ADCMopIzpx          .MACRO param
                  .BYTE $E075,  param
                  .ENDM
ADCMopJzpx          .MACRO param
                  .BYTE $E175,  param
                  .ENDM
ADCMopKzpx          .MACRO param          
                  .BYTE $E275,  param
                  .ENDM
ADCMopLzpx          .MACRO param
                  .BYTE $E375,  param
                  .ENDM
ADCMopMzpx          .MACRO param
                  .BYTE $F075,  param
                  .ENDM                  
ADCMopNzpx          .MACRO param          
                  .BYTE $F175,  param
                  .ENDM
ADCMopOzpx          .MACRO param
                  .BYTE $F275,  param
                  .ENDM
ADCMopQzpx          .MACRO param
                  .BYTE $F375,  param
                  .ENDM
                  
ADCNopAzpx          .MACRO param
                  .BYTE $C475,  param
                  .ENDM                
ADCNopBzpx          .MACRO param          
                  .BYTE $C575,  param
                  .ENDM
ADCNopCzpx          .MACRO param
                  .BYTE $C675,  param
                  .ENDM
ADCNopDzpx          .MACRO param
                  .BYTE $C775,  param
                  .ENDM
ADCNopEzpx          .MACRO param          
                  .BYTE $D475,  param
                  .ENDM
ADCNopFzpx          .MACRO param
                  .BYTE $D575,  param
                  .ENDM
ADCNopGzpx          .MACRO param
                  .BYTE $D675,  param
                  .ENDM                  
ADCNopHzpx          .MACRO param          
                  .BYTE $D775,  param
                  .ENDM
ADCNopIzpx          .MACRO param
                  .BYTE $E475,  param
                  .ENDM
ADCNopJzpx          .MACRO param
                  .BYTE $E575,  param
                  .ENDM
ADCNopKzpx          .MACRO param          
                  .BYTE $E675,  param
                  .ENDM
ADCNopLzpx          .MACRO param
                  .BYTE $E775,  param
                  .ENDM
ADCNopMzpx          .MACRO param
                  .BYTE $F475,  param
                  .ENDM                  
ADCNopNzpx          .MACRO param          
                  .BYTE $F575,  param
                  .ENDM
ADCNopOzpx          .MACRO param
                  .BYTE $F675,  param
                  .ENDM
ADCNopQzpx          .MACRO param
                  .BYTE $F775,  param
                  .ENDM
            
ADCOopAzpx          .MACRO param
                  .BYTE $C875,  param
                  .ENDM                
ADCOopBzpx          .MACRO param          
                  .BYTE $C975,  param
                  .ENDM
ADCOopCzpx          .MACRO param
                  .BYTE $CA75,  param
                  .ENDM
ADCOopDzpx          .MACRO param
                  .BYTE $CB75,  param
                  .ENDM
ADCOopEzpx          .MACRO param          
                  .BYTE $D875,  param
                  .ENDM
ADCOopFzpx          .MACRO param
                  .BYTE $D975,  param
                  .ENDM
ADCOopGzpx          .MACRO param
                  .BYTE $DA75,  param
                  .ENDM                  
ADCOopHzpx          .MACRO param          
                  .BYTE $DB75,  param
                  .ENDM
ADCOopIzpx          .MACRO param
                  .BYTE $E875,  param
                  .ENDM
ADCOopJzpx          .MACRO param
                  .BYTE $E975,  param
                  .ENDM
ADCOopKzpx          .MACRO param          
                  .BYTE $EA75,  param
                  .ENDM
ADCOopLzpx          .MACRO param
                  .BYTE $EB75,  param
                  .ENDM
ADCOopMzpx          .MACRO param
                  .BYTE $F875,  param
                  .ENDM                  
ADCOopNzpx          .MACRO param          
                  .BYTE $F975,  param
                  .ENDM
ADCOopOzpx          .MACRO param
                  .BYTE $FA75,  param
                  .ENDM
ADCOopQzpx          .MACRO param
                  .BYTE $FB75,  param
                  .ENDM
                  
ADCQopAzpx          .MACRO param
                  .BYTE $CC75,  param
                  .ENDM                
ADCQopBzpx          .MACRO param          
                  .BYTE $CD75,  param
                  .ENDM
ADCQopCzpx          .MACRO param
                  .BYTE $CE75,  param
                  .ENDM
ADCQopDzpx          .MACRO param
                  .BYTE $CF75,  param
                  .ENDM
ADCQopEzpx          .MACRO param          
                  .BYTE $DC75,  param
                  .ENDM
ADCQopFzpx          .MACRO param
                  .BYTE $DD75,  param
                  .ENDM
ADCQopGzpx          .MACRO param
                  .BYTE $DE75,  param
                  .ENDM                  
ADCQopHzpx          .MACRO param          
                  .BYTE $DF75,  param
                  .ENDM
ADCQopIzpx          .MACRO param
                  .BYTE $EC75,  param
                  .ENDM
ADCQopJzpx          .MACRO param
                  .BYTE $ED75,  param
                  .ENDM
ADCQopKzpx          .MACRO param          
                  .BYTE $EE75,  param
                  .ENDM
ADCQopLzpx          .MACRO param
                  .BYTE $EF75,  param
                  .ENDM
ADCQopMzpx          .MACRO param
                  .BYTE $FC75,  param
                  .ENDM                  
ADCQopNzpx          .MACRO param          
                  .BYTE $FD75,  param
                  .ENDM
ADCQopOzpx          .MACRO param
                  .BYTE $FE75,  param
                  .ENDM
ADCQopQzpx          .MACRO param
                  .BYTE $FF75,  param
                  .ENDM

;SBC $xxxx              $00F5
SBCAopBzpx          .MACRO param          
                  .BYTE $01F5,  param
                  .ENDM
SBCAopCzpx          .MACRO param
                  .BYTE $02F5,  param
                  .ENDM
SBCAopDzpx          .MACRO param
                  .BYTE $03F5,  param
                  .ENDM
SBCAopEzpx          .MACRO param          
                  .BYTE $10F5,  param
                  .ENDM
SBCAopFzpx          .MACRO param
                  .BYTE $11F5,  param
                  .ENDM
SBCAopGzpx          .MACRO param
                  .BYTE $12F5,  param
                  .ENDM                  
SBCAopHzpx          .MACRO param          
                  .BYTE $13F5,  param
                  .ENDM
SBCAopIzpx          .MACRO param
                  .BYTE $20F5,  param
                  .ENDM
SBCAopJzpx          .MACRO param
                  .BYTE $21F5,  param
                  .ENDM
SBCAopKzpx          .MACRO param          
                  .BYTE $22F5,  param
                  .ENDM
SBCAopLzpx          .MACRO param
                  .BYTE $23F5,  param
                  .ENDM
SBCAopMzpx          .MACRO param
                  .BYTE $30F5,  param
                  .ENDM                  
SBCAopNzpx          .MACRO param          
                  .BYTE $31F5,  param
                  .ENDM
SBCAopOzpx          .MACRO param
                  .BYTE $32F5,  param
                  .ENDM
SBCAopQzpx          .MACRO param
                  .BYTE $33F5,  param
                  .ENDM
                                    
SBCBopAzpx          .MACRO param
                  .BYTE $04F5,  param
                  .ENDM                
SBCBopBzpx          .MACRO param          
                  .BYTE $05F5,  param
                  .ENDM
SBCBopCzpx          .MACRO param
                  .BYTE $06F5,  param
                  .ENDM
SBCBopDzpx          .MACRO param
                  .BYTE $07F5,  param
                  .ENDM
SBCBopEzpx          .MACRO param          
                  .BYTE $14F5,  param
                  .ENDM
SBCBopFzpx          .MACRO param
                  .BYTE $15F5,  param
                  .ENDM
SBCBopGzpx          .MACRO param
                  .BYTE $16F5,  param
                  .ENDM                  
SBCBopHzpx          .MACRO param          
                  .BYTE $17F5,  param
                  .ENDM
SBCBopIzpx          .MACRO param
                  .BYTE $24F5,  param
                  .ENDM
SBCBopJzpx          .MACRO param
                  .BYTE $25F5,  param
                  .ENDM
SBCBopKzpx          .MACRO param          
                  .BYTE $26F5,  param
                  .ENDM
SBCBopLzpx          .MACRO param
                  .BYTE $27F5,  param
                  .ENDM
SBCBopMzpx          .MACRO param
                  .BYTE $30F5,  param
                  .ENDM                  
SBCBopNzpx          .MACRO param          
                  .BYTE $31F5,  param
                  .ENDM
SBCBopOzpx          .MACRO param
                  .BYTE $32F5,  param
                  .ENDM
SBCBopQzpx          .MACRO param
                  .BYTE $33F5,  param
                  .ENDM
                                    
SBCCopAzpx          .MACRO param
                  .BYTE $08F5,  param
                  .ENDM                
SBCCopBzpx          .MACRO param          
                  .BYTE $09F5,  param
                  .ENDM
SBCCopCzpx          .MACRO param
                  .BYTE $0AF5,  param
                  .ENDM
SBCCopDzpx          .MACRO param
                  .BYTE $0BF5,  param
                  .ENDM
SBCCopEzpx          .MACRO param          
                  .BYTE $18F5,  param
                  .ENDM
SBCCopFzpx          .MACRO param
                  .BYTE $19F5,  param
                  .ENDM
SBCCopGzpx          .MACRO param
                  .BYTE $1AF5,  param
                  .ENDM                  
SBCCopHzpx          .MACRO param          
                  .BYTE $1BF5,  param
                  .ENDM
SBCCopIzpx          .MACRO param
                  .BYTE $28F5,  param
                  .ENDM
SBCCopJzpx          .MACRO param
                  .BYTE $29F5,  param
                  .ENDM
SBCCopKzpx          .MACRO param          
                  .BYTE $2AF5,  param
                  .ENDM
SBCCopLzpx          .MACRO param
                  .BYTE $2BF5,  param
                  .ENDM
SBCCopMzpx          .MACRO param
                  .BYTE $38F5,  param
                  .ENDM                  
SBCCopNzpx          .MACRO param          
                  .BYTE $39F5,  param
                  .ENDM
SBCCopOzpx          .MACRO param
                  .BYTE $3AF5,  param
                  .ENDM
SBCCopQzpx          .MACRO param
                  .BYTE $3BF5,  param
                  .ENDM

SBCDopAzpx          .MACRO param
                  .BYTE $0CF5,  param
                  .ENDM                
SBCDopBzpx          .MACRO param          
                  .BYTE $0DF5,  param
                  .ENDM
SBCDopCzpx          .MACRO param
                  .BYTE $0EF5,  param
                  .ENDM
SBCDopDzpx          .MACRO param
                  .BYTE $0FF5,  param
                  .ENDM
SBCDopEzpx          .MACRO param          
                  .BYTE $1CF5,  param
                  .ENDM
SBCDopFzpx          .MACRO param
                  .BYTE $1DF5,  param
                  .ENDM
SBCDopGzpx          .MACRO param
                  .BYTE $1EF5,  param
                  .ENDM                  
SBCDopHzpx          .MACRO param          
                  .BYTE $1FF5,  param
                  .ENDM
SBCDopIzpx          .MACRO param
                  .BYTE $2CF5,  param
                  .ENDM
SBCDopJzpx          .MACRO param
                  .BYTE $2DF5,  param
                  .ENDM
SBCDopKzpx          .MACRO param          
                  .BYTE $2EF5,  param
                  .ENDM
SBCDopLzpx          .MACRO param
                  .BYTE $2FF5,  param
                  .ENDM
SBCDopMzpx          .MACRO param
                  .BYTE $3CF5,  param
                  .ENDM                  
SBCDopNzpx          .MACRO param          
                  .BYTE $3DF5,  param
                  .ENDM
SBCDopOzpx          .MACRO param
                  .BYTE $3EF5,  param
                  .ENDM
SBCDopQzpx          .MACRO param
                  .BYTE $3FF5,  param
                  .ENDM                  

SBCEopAzpx          .MACRO param
                  .BYTE $40F5,  param
                  .ENDM                
SBCEopBzpx          .MACRO param          
                  .BYTE $41F5,  param
                  .ENDM
SBCEopCzpx          .MACRO param
                  .BYTE $42F5,  param
                  .ENDM
SBCEopDzpx          .MACRO param
                  .BYTE $43F5,  param
                  .ENDM
SBCEopEzpx          .MACRO param          
                  .BYTE $50F5,  param
                  .ENDM
SBCEopFzpx          .MACRO param
                  .BYTE $51F5,  param
                  .ENDM
SBCEopGzpx          .MACRO param
                  .BYTE $52F5,  param
                  .ENDM                  
SBCEopHzpx          .MACRO param          
                  .BYTE $53F5,  param
                  .ENDM
SBCEopIzpx          .MACRO param
                  .BYTE $60F5,  param
                  .ENDM
SBCEopJzpx          .MACRO param
                  .BYTE $61F5,  param
                  .ENDM
SBCEopKzpx          .MACRO param          
                  .BYTE $62F5,  param
                  .ENDM
SBCEopLzpx          .MACRO param
                  .BYTE $63F5,  param
                  .ENDM
SBCEopMzpx          .MACRO param
                  .BYTE $70F5,  param
                  .ENDM                  
SBCEopNzpx          .MACRO param          
                  .BYTE $71F5,  param
                  .ENDM
SBCEopOzpx          .MACRO param
                  .BYTE $72F5,  param
                  .ENDM
SBCEopQzpx          .MACRO param
                  .BYTE $73F5,  param
                  .ENDM
                  
SBCFopAzpx          .MACRO param
                  .BYTE $44F5,  param
                  .ENDM                
SBCFopBzpx          .MACRO param          
                  .BYTE $45F5,  param
                  .ENDM
SBCFopCzpx          .MACRO param
                  .BYTE $46F5,  param
                  .ENDM
SBCFopDzpx          .MACRO param
                  .BYTE $47F5,  param
                  .ENDM
SBCFopEzpx          .MACRO param          
                  .BYTE $54F5,  param
                  .ENDM
SBCFopFzpx          .MACRO param
                  .BYTE $55F5,  param
                  .ENDM
SBCFopGzpx          .MACRO param
                  .BYTE $56F5,  param
                  .ENDM                  
SBCFopHzpx          .MACRO param          
                  .BYTE $57F5,  param
                  .ENDM
SBCFopIzpx          .MACRO param
                  .BYTE $64F5,  param
                  .ENDM
SBCFopJzpx          .MACRO param
                  .BYTE $65F5,  param
                  .ENDM
SBCFopKzpx          .MACRO param          
                  .BYTE $66F5,  param
                  .ENDM
SBCFopLzpx          .MACRO param
                  .BYTE $67F5,  param
                  .ENDM
SBCFopMzpx          .MACRO param
                  .BYTE $74F5,  param
                  .ENDM                  
SBCFopNzpx          .MACRO param          
                  .BYTE $75F5,  param
                  .ENDM
SBCFopOzpx          .MACRO param
                  .BYTE $76F5,  param
                  .ENDM
SBCFopQzpx          .MACRO param
                  .BYTE $77F5,  param
                  .ENDM                  
                           
SBCGopAzpx          .MACRO param
                  .BYTE $48F5,  param
                  .ENDM                
SBCGopBzpx          .MACRO param          
                  .BYTE $49F5,  param
                  .ENDM
SBCGopCzpx          .MACRO param
                  .BYTE $4AF5,  param
                  .ENDM
SBCGopDzpx          .MACRO param
                  .BYTE $4BF5,  param
                  .ENDM
SBCGopEzpx          .MACRO param          
                  .BYTE $58F5,  param
                  .ENDM
SBCGopFzpx          .MACRO param
                  .BYTE $59F5,  param
                  .ENDM
SBCGopGzpx          .MACRO param
                  .BYTE $5AF5,  param
                  .ENDM                  
SBCGopHzpx          .MACRO param          
                  .BYTE $5BF5,  param
                  .ENDM
SBCGopIzpx          .MACRO param
                  .BYTE $68F5,  param
                  .ENDM
SBCGopJzpx          .MACRO param
                  .BYTE $69F5,  param
                  .ENDM
SBCGopKzpx          .MACRO param          
                  .BYTE $6AF5,  param
                  .ENDM
SBCGopLzpx          .MACRO param
                  .BYTE $6BF5,  param
                  .ENDM
SBCGopMzpx          .MACRO param
                  .BYTE $78F5,  param
                  .ENDM                  
SBCGopNzpx          .MACRO param          
                  .BYTE $79F5,  param
                  .ENDM
SBCGopOzpx          .MACRO param
                  .BYTE $7AF5,  param
                  .ENDM
SBCGopQzpx          .MACRO param
                  .BYTE $7BF5,  param
                  .ENDM
                  
SBCHopAzpx          .MACRO param
                  .BYTE $4CF5,  param
                  .ENDM                
SBCHopBzpx          .MACRO param          
                  .BYTE $4DF5,  param
                  .ENDM
SBCHopCzpx          .MACRO param
                  .BYTE $4EF5,  param
                  .ENDM
SBCHopDzpx          .MACRO param
                  .BYTE $4FF5,  param
                  .ENDM
SBCHopEzpx          .MACRO param          
                  .BYTE $5CF5,  param
                  .ENDM
SBCHopFzpx          .MACRO param
                  .BYTE $5DF5,  param
                  .ENDM
SBCHopGzpx          .MACRO param
                  .BYTE $5EF5,  param
                  .ENDM                  
SBCHopHzpx          .MACRO param          
                  .BYTE $5FF5,  param
                  .ENDM
SBCHopIzpx          .MACRO param
                  .BYTE $6CF5,  param
                  .ENDM
SBCHopJzpx          .MACRO param
                  .BYTE $6DF5,  param
                  .ENDM
SBCHopKzpx          .MACRO param          
                  .BYTE $6EF5,  param
                  .ENDM
SBCHopLzpx          .MACRO param
                  .BYTE $6FF5,  param
                  .ENDM
SBCHopMzpx          .MACRO param
                  .BYTE $7CF5,  param
                  .ENDM                  
SBCHopNzpx          .MACRO param          
                  .BYTE $7DF5,  param
                  .ENDM
SBCHopOzpx          .MACRO param
                  .BYTE $7EF5,  param
                  .ENDM
SBCHopQzpx          .MACRO param
                  .BYTE $7FF5,  param
                  .ENDM
                  
SBCIopAzpx          .MACRO param
                  .BYTE $80F5,  param
                  .ENDM                
SBCIopBzpx          .MACRO param          
                  .BYTE $81F5,  param
                  .ENDM
SBCIopCzpx          .MACRO param
                  .BYTE $82F5,  param
                  .ENDM
SBCIopDzpx          .MACRO param
                  .BYTE $83F5,  param
                  .ENDM
SBCIopEzpx          .MACRO param          
                  .BYTE $90F5,  param
                  .ENDM
SBCIopFzpx          .MACRO param
                  .BYTE $91F5,  param
                  .ENDM
SBCIopGzpx          .MACRO param
                  .BYTE $92F5,  param
                  .ENDM                  
SBCIopHzpx          .MACRO param          
                  .BYTE $93F5,  param
                  .ENDM
SBCIopIzpx          .MACRO param
                  .BYTE $A0F5,  param
                  .ENDM
SBCIopJzpx          .MACRO param
                  .BYTE $A1F5,  param
                  .ENDM
SBCIopKzpx          .MACRO param          
                  .BYTE $A2F5,  param
                  .ENDM
SBCIopLzpx          .MACRO param
                  .BYTE $A3F5,  param
                  .ENDM
SBCIopMzpx          .MACRO param
                  .BYTE $B0F5,  param
                  .ENDM                  
SBCIopNzpx          .MACRO param          
                  .BYTE $B1F5,  param
                  .ENDM
SBCIopOzpx          .MACRO param
                  .BYTE $B2F5,  param
                  .ENDM
SBCIopQzpx          .MACRO param
                  .BYTE $B3F5,  param
                  .ENDM
                  
SBCJopAzpx          .MACRO param
                  .BYTE $84F5,  param
                  .ENDM                
SBCJopBzpx          .MACRO param          
                  .BYTE $85F5,  param
                  .ENDM
SBCJopCzpx          .MACRO param
                  .BYTE $86F5,  param
                  .ENDM
SBCJopDzpx          .MACRO param
                  .BYTE $87F5,  param
                  .ENDM
SBCJopEzpx          .MACRO param          
                  .BYTE $94F5,  param
                  .ENDM
SBCJopFzpx          .MACRO param
                  .BYTE $95F5,  param
                  .ENDM
SBCJopGzpx          .MACRO param
                  .BYTE $96F5,  param
                  .ENDM                  
SBCJopHzpx          .MACRO param          
                  .BYTE $97F5,  param
                  .ENDM
SBCJopIzpx          .MACRO param
                  .BYTE $A4F5,  param
                  .ENDM
SBCJopJzpx          .MACRO param
                  .BYTE $A5F5,  param
                  .ENDM
SBCJopKzpx          .MACRO param          
                  .BYTE $A6F5,  param
                  .ENDM
SBCJopLzpx          .MACRO param
                  .BYTE $A7F5,  param
                  .ENDM
SBCJopMzpx          .MACRO param
                  .BYTE $B4F5,  param
                  .ENDM                  
SBCJopNzpx          .MACRO param          
                  .BYTE $B5F5,  param
                  .ENDM
SBCJopOzpx          .MACRO param
                  .BYTE $B6F5,  param
                  .ENDM
SBCJopQzpx          .MACRO param
                  .BYTE $B7F5,  param
                  .ENDM
                  
SBCKopAzpx          .MACRO param
                  .BYTE $88F5,  param
                  .ENDM                
SBCKopBzpx          .MACRO param          
                  .BYTE $89F5,  param
                  .ENDM
SBCKopCzpx          .MACRO param
                  .BYTE $8AF5,  param
                  .ENDM
SBCKopDzpx          .MACRO param
                  .BYTE $8BF5,  param
                  .ENDM
SBCKopEzpx          .MACRO param          
                  .BYTE $98F5,  param
                  .ENDM
SBCKopFzpx          .MACRO param
                  .BYTE $99F5,  param
                  .ENDM
SBCKopGzpx          .MACRO param
                  .BYTE $9AF5,  param
                  .ENDM                  
SBCKopHzpx          .MACRO param          
                  .BYTE $9BF5,  param
                  .ENDM
SBCKopIzpx          .MACRO param
                  .BYTE $A8F5,  param
                  .ENDM
SBCKopJzpx          .MACRO param
                  .BYTE $A9F5,  param
                  .ENDM
SBCKopKzpx          .MACRO param          
                  .BYTE $AAF5,  param
                  .ENDM
SBCKopLzpx          .MACRO param
                  .BYTE $ABF5,  param
                  .ENDM
SBCKopMzpx          .MACRO param
                  .BYTE $B8F5,  param
                  .ENDM                  
SBCKopNzpx          .MACRO param          
                  .BYTE $B9F5,  param
                  .ENDM
SBCKopOzpx          .MACRO param
                  .BYTE $BAF5,  param
                  .ENDM
SBCKopQzpx          .MACRO param
                  .BYTE $BBF5,  param
                  .ENDM
                  
SBCLopAzpx          .MACRO param
                  .BYTE $8CF5,  param
                  .ENDM                
SBCLopBzpx          .MACRO param          
                  .BYTE $8DF5,  param
                  .ENDM
SBCLopCzpx          .MACRO param
                  .BYTE $8EF5,  param
                  .ENDM
SBCLopDzpx          .MACRO param
                  .BYTE $8FF5,  param
                  .ENDM
SBCLopEzpx          .MACRO param          
                  .BYTE $9CF5,  param
                  .ENDM
SBCLopFzpx          .MACRO param
                  .BYTE $9DF5,  param
                  .ENDM
SBCLopGzpx          .MACRO param
                  .BYTE $9EF5,  param
                  .ENDM                  
SBCLopHzpx          .MACRO param          
                  .BYTE $9FF5,  param
                  .ENDM
SBCLopIzpx          .MACRO param
                  .BYTE $ACF5,  param
                  .ENDM
SBCLopJzpx          .MACRO param
                  .BYTE $ADF5,  param
                  .ENDM
SBCLopKzpx          .MACRO param          
                  .BYTE $AEF5,  param
                  .ENDM
SBCLopLzpx          .MACRO param
                  .BYTE $AFF5,  param
                  .ENDM
SBCLopMzpx          .MACRO param
                  .BYTE $BCF5,  param
                  .ENDM                  
SBCLopNzpx          .MACRO param          
                  .BYTE $BDF5,  param
                  .ENDM
SBCLopOzpx          .MACRO param
                  .BYTE $BEF5,  param
                  .ENDM
SBCLopQzpx          .MACRO param
                  .BYTE $BFF5,  param
                  .ENDM
                  
SBCMopAzpx          .MACRO param
                  .BYTE $C0F5,  param
                  .ENDM                
SBCMopBzpx          .MACRO param          
                  .BYTE $C1F5,  param
                  .ENDM
SBCMopCzpx          .MACRO param
                  .BYTE $C2F5,  param
                  .ENDM
SBCMopDzpx          .MACRO param
                  .BYTE $C3F5,  param
                  .ENDM
SBCMopEzpx          .MACRO param          
                  .BYTE $D0F5,  param
                  .ENDM
SBCMopFzpx          .MACRO param
                  .BYTE $D1F5,  param
                  .ENDM
SBCMopGzpx          .MACRO param
                  .BYTE $D2F5,  param
                  .ENDM                  
SBCMopHzpx          .MACRO param          
                  .BYTE $D3F5,  param
                  .ENDM
SBCMopIzpx          .MACRO param
                  .BYTE $E0F5,  param
                  .ENDM
SBCMopJzpx          .MACRO param
                  .BYTE $E1F5,  param
                  .ENDM
SBCMopKzpx          .MACRO param          
                  .BYTE $E2F5,  param
                  .ENDM
SBCMopLzpx          .MACRO param
                  .BYTE $E3F5,  param
                  .ENDM
SBCMopMzpx          .MACRO param
                  .BYTE $F0F5,  param
                  .ENDM                  
SBCMopNzpx          .MACRO param          
                  .BYTE $F1F5,  param
                  .ENDM
SBCMopOzpx          .MACRO param
                  .BYTE $F2F5,  param
                  .ENDM
SBCMopQzpx          .MACRO param
                  .BYTE $F3F5,  param
                  .ENDM
                  
SBCNopAzpx          .MACRO param
                  .BYTE $C4F5,  param
                  .ENDM                
SBCNopBzpx          .MACRO param          
                  .BYTE $C5F5,  param
                  .ENDM
SBCNopCzpx          .MACRO param
                  .BYTE $C6F5,  param
                  .ENDM
SBCNopDzpx          .MACRO param
                  .BYTE $C7F5,  param
                  .ENDM
SBCNopEzpx          .MACRO param          
                  .BYTE $D4F5,  param
                  .ENDM
SBCNopFzpx          .MACRO param
                  .BYTE $D5F5,  param
                  .ENDM
SBCNopGzpx          .MACRO param
                  .BYTE $D6F5,  param
                  .ENDM                  
SBCNopHzpx          .MACRO param          
                  .BYTE $D7F5,  param
                  .ENDM
SBCNopIzpx          .MACRO param
                  .BYTE $E4F5,  param
                  .ENDM
SBCNopJzpx          .MACRO param
                  .BYTE $E5F5,  param
                  .ENDM
SBCNopKzpx          .MACRO param          
                  .BYTE $E6F5,  param
                  .ENDM
SBCNopLzpx          .MACRO param
                  .BYTE $E7F5,  param
                  .ENDM
SBCNopMzpx          .MACRO param
                  .BYTE $F4F5,  param
                  .ENDM                  
SBCNopNzpx          .MACRO param          
                  .BYTE $F5F5,  param
                  .ENDM
SBCNopOzpx          .MACRO param
                  .BYTE $F6F5,  param
                  .ENDM
SBCNopQzpx          .MACRO param
                  .BYTE $F7F5,  param
                  .ENDM
            
SBCOopAzpx          .MACRO param
                  .BYTE $C8F5,  param
                  .ENDM                
SBCOopBzpx          .MACRO param          
                  .BYTE $C9F5,  param
                  .ENDM
SBCOopCzpx          .MACRO param
                  .BYTE $CAF5,  param
                  .ENDM
SBCOopDzpx          .MACRO param
                  .BYTE $CBF5,  param
                  .ENDM
SBCOopEzpx          .MACRO param          
                  .BYTE $D8F5,  param
                  .ENDM
SBCOopFzpx          .MACRO param
                  .BYTE $D9F5,  param
                  .ENDM
SBCOopGzpx          .MACRO param
                  .BYTE $DAF5,  param
                  .ENDM                  
SBCOopHzpx          .MACRO param          
                  .BYTE $DBF5,  param
                  .ENDM
SBCOopIzpx          .MACRO param
                  .BYTE $E8F5,  param
                  .ENDM
SBCOopJzpx          .MACRO param
                  .BYTE $E9F5,  param
                  .ENDM
SBCOopKzpx          .MACRO param          
                  .BYTE $EAF5,  param
                  .ENDM
SBCOopLzpx          .MACRO param
                  .BYTE $EBF5,  param
                  .ENDM
SBCOopMzpx          .MACRO param
                  .BYTE $F8F5,  param
                  .ENDM                  
SBCOopNzpx          .MACRO param          
                  .BYTE $F9F5,  param
                  .ENDM
SBCOopOzpx          .MACRO param
                  .BYTE $FAF5,  param
                  .ENDM
SBCOopQzpx          .MACRO param
                  .BYTE $FBF5,  param
                  .ENDM
                  
SBCQopAzpx          .MACRO param
                  .BYTE $CCF5,  param
                  .ENDM                
SBCQopBzpx          .MACRO param          
                  .BYTE $CDF5,  param
                  .ENDM
SBCQopCzpx          .MACRO param
                  .BYTE $CEF5,  param
                  .ENDM
SBCQopDzpx          .MACRO param
                  .BYTE $CFF5,  param
                  .ENDM
SBCQopEzpx          .MACRO param          
                  .BYTE $DCF5,  param
                  .ENDM
SBCQopFzpx          .MACRO param
                  .BYTE $DDF5,  param
                  .ENDM
SBCQopGzpx          .MACRO param
                  .BYTE $DEF5,  param
                  .ENDM                  
SBCQopHzpx          .MACRO param          
                  .BYTE $DFF5,  param
                  .ENDM
SBCQopIzpx          .MACRO param
                  .BYTE $ECF5,  param
                  .ENDM
SBCQopJzpx          .MACRO param
                  .BYTE $EDF5,  param
                  .ENDM
SBCQopKzpx          .MACRO param          
                  .BYTE $EEF5,  param
                  .ENDM
SBCQopLzpx          .MACRO param
                  .BYTE $EFF5,  param
                  .ENDM
SBCQopMzpx          .MACRO param
                  .BYTE $FCF5,  param
                  .ENDM                  
SBCQopNzpx          .MACRO param          
                  .BYTE $FDF5,  param
                  .ENDM
SBCQopOzpx          .MACRO param
                  .BYTE $FEF5,  param
                  .ENDM
SBCQopQzpx          .MACRO param
                  .BYTE $FFF5,  param
                  .ENDM
                  
;ORA $xxxx              $0015
ORAAopBzpx          .MACRO param          
                  .BYTE $0115,  param
                  .ENDM
ORAAopCzpx          .MACRO param
                  .BYTE $0215,  param
                  .ENDM
ORAAopDzpx          .MACRO param
                  .BYTE $0315,  param
                  .ENDM
ORAAopEzpx          .MACRO param          
                  .BYTE $1015,  param
                  .ENDM
ORAAopFzpx          .MACRO param
                  .BYTE $1115,  param
                  .ENDM
ORAAopGzpx          .MACRO param
                  .BYTE $1215,  param
                  .ENDM                  
ORAAopHzpx          .MACRO param          
                  .BYTE $1315,  param
                  .ENDM
ORAAopIzpx          .MACRO param
                  .BYTE $2015,  param
                  .ENDM
ORAAopJzpx          .MACRO param
                  .BYTE $2115,  param
                  .ENDM
ORAAopKzpx          .MACRO param          
                  .BYTE $2215,  param
                  .ENDM
ORAAopLzpx          .MACRO param
                  .BYTE $2315,  param
                  .ENDM
ORAAopMzpx          .MACRO param
                  .BYTE $3015,  param
                  .ENDM                  
ORAAopNzpx          .MACRO param          
                  .BYTE $3115,  param
                  .ENDM
ORAAopOzpx          .MACRO param
                  .BYTE $3215,  param
                  .ENDM
ORAAopQzpx          .MACRO param
                  .BYTE $3315,  param
                  .ENDM
                                    
ORABopAzpx          .MACRO param
                  .BYTE $0415,  param
                  .ENDM                
ORABopBzpx          .MACRO param          
                  .BYTE $0515,  param
                  .ENDM
ORABopCzpx          .MACRO param
                  .BYTE $0615,  param
                  .ENDM
ORABopDzpx          .MACRO param
                  .BYTE $0715,  param
                  .ENDM
ORABopEzpx          .MACRO param          
                  .BYTE $1415,  param
                  .ENDM
ORABopFzpx          .MACRO param
                  .BYTE $1515,  param
                  .ENDM
ORABopGzpx          .MACRO param
                  .BYTE $1615,  param
                  .ENDM                  
ORABopHzpx          .MACRO param          
                  .BYTE $1715,  param
                  .ENDM
ORABopIzpx          .MACRO param
                  .BYTE $2415,  param
                  .ENDM
ORABopJzpx          .MACRO param
                  .BYTE $2515,  param
                  .ENDM
ORABopKzpx          .MACRO param          
                  .BYTE $2615,  param
                  .ENDM
ORABopLzpx          .MACRO param
                  .BYTE $2715,  param
                  .ENDM
ORABopMzpx          .MACRO param
                  .BYTE $3015,  param
                  .ENDM                  
ORABopNzpx          .MACRO param          
                  .BYTE $3115,  param
                  .ENDM
ORABopOzpx          .MACRO param
                  .BYTE $3215,  param
                  .ENDM
ORABopQzpx          .MACRO param
                  .BYTE $3315,  param
                  .ENDM
                                    
ORACopAzpx          .MACRO param
                  .BYTE $0815,  param
                  .ENDM                
ORACopBzpx          .MACRO param          
                  .BYTE $0915,  param
                  .ENDM
ORACopCzpx          .MACRO param
                  .BYTE $0A15,  param
                  .ENDM
ORACopDzpx          .MACRO param
                  .BYTE $0B15,  param
                  .ENDM
ORACopEzpx          .MACRO param          
                  .BYTE $1815,  param
                  .ENDM
ORACopFzpx          .MACRO param
                  .BYTE $1915,  param
                  .ENDM
ORACopGzpx          .MACRO param
                  .BYTE $1A15,  param
                  .ENDM                  
ORACopHzpx          .MACRO param          
                  .BYTE $1B15,  param
                  .ENDM
ORACopIzpx          .MACRO param
                  .BYTE $2815,  param
                  .ENDM
ORACopJzpx          .MACRO param
                  .BYTE $2915,  param
                  .ENDM
ORACopKzpx          .MACRO param          
                  .BYTE $2A15,  param
                  .ENDM
ORACopLzpx          .MACRO param
                  .BYTE $2B15,  param
                  .ENDM
ORACopMzpx          .MACRO param
                  .BYTE $3815,  param
                  .ENDM                  
ORACopNzpx          .MACRO param          
                  .BYTE $3915,  param
                  .ENDM
ORACopOzpx          .MACRO param
                  .BYTE $3A15,  param
                  .ENDM
ORACopQzpx          .MACRO param
                  .BYTE $3B15,  param
                  .ENDM

ORADopAzpx          .MACRO param
                  .BYTE $0C15,  param
                  .ENDM                
ORADopBzpx          .MACRO param          
                  .BYTE $0D15,  param
                  .ENDM
ORADopCzpx          .MACRO param
                  .BYTE $0E15,  param
                  .ENDM
ORADopDzpx          .MACRO param
                  .BYTE $0F15,  param
                  .ENDM
ORADopEzpx          .MACRO param          
                  .BYTE $1C15,  param
                  .ENDM
ORADopFzpx          .MACRO param
                  .BYTE $1D15,  param
                  .ENDM
ORADopGzpx          .MACRO param
                  .BYTE $1E15,  param
                  .ENDM                  
ORADopHzpx          .MACRO param          
                  .BYTE $1F15,  param
                  .ENDM
ORADopIzpx          .MACRO param
                  .BYTE $2C15,  param
                  .ENDM
ORADopJzpx          .MACRO param
                  .BYTE $2D15,  param
                  .ENDM
ORADopKzpx          .MACRO param          
                  .BYTE $2E15,  param
                  .ENDM
ORADopLzpx          .MACRO param
                  .BYTE $2F15,  param
                  .ENDM
ORADopMzpx          .MACRO param
                  .BYTE $3C15,  param
                  .ENDM                  
ORADopNzpx          .MACRO param          
                  .BYTE $3D15,  param
                  .ENDM
ORADopOzpx          .MACRO param
                  .BYTE $3E15,  param
                  .ENDM
ORADopQzpx          .MACRO param
                  .BYTE $3F15,  param
                  .ENDM                  

ORAEopAzpx          .MACRO param
                  .BYTE $4015,  param
                  .ENDM                
ORAEopBzpx          .MACRO param          
                  .BYTE $4115,  param
                  .ENDM
ORAEopCzpx          .MACRO param
                  .BYTE $4215,  param
                  .ENDM
ORAEopDzpx          .MACRO param
                  .BYTE $4315,  param
                  .ENDM
ORAEopEzpx          .MACRO param          
                  .BYTE $5015,  param
                  .ENDM
ORAEopFzpx          .MACRO param
                  .BYTE $5115,  param
                  .ENDM
ORAEopGzpx          .MACRO param
                  .BYTE $5215,  param
                  .ENDM                  
ORAEopHzpx          .MACRO param          
                  .BYTE $5315,  param
                  .ENDM
ORAEopIzpx          .MACRO param
                  .BYTE $6015,  param
                  .ENDM
ORAEopJzpx          .MACRO param
                  .BYTE $6115,  param
                  .ENDM
ORAEopKzpx          .MACRO param          
                  .BYTE $6215,  param
                  .ENDM
ORAEopLzpx          .MACRO param
                  .BYTE $6315,  param
                  .ENDM
ORAEopMzpx          .MACRO param
                  .BYTE $7015,  param
                  .ENDM                  
ORAEopNzpx          .MACRO param          
                  .BYTE $7115,  param
                  .ENDM
ORAEopOzpx          .MACRO param
                  .BYTE $7215,  param
                  .ENDM
ORAEopQzpx          .MACRO param
                  .BYTE $7315,  param
                  .ENDM
                  
ORAFopAzpx          .MACRO param
                  .BYTE $4415,  param
                  .ENDM                
ORAFopBzpx          .MACRO param          
                  .BYTE $4515,  param
                  .ENDM
ORAFopCzpx          .MACRO param
                  .BYTE $4615,  param
                  .ENDM
ORAFopDzpx          .MACRO param
                  .BYTE $4715,  param
                  .ENDM
ORAFopEzpx          .MACRO param          
                  .BYTE $5415,  param
                  .ENDM
ORAFopFzpx          .MACRO param
                  .BYTE $5515,  param
                  .ENDM
ORAFopGzpx          .MACRO param
                  .BYTE $5615,  param
                  .ENDM                  
ORAFopHzpx          .MACRO param          
                  .BYTE $5715,  param
                  .ENDM
ORAFopIzpx          .MACRO param
                  .BYTE $6415,  param
                  .ENDM
ORAFopJzpx          .MACRO param
                  .BYTE $6515,  param
                  .ENDM
ORAFopKzpx          .MACRO param          
                  .BYTE $6615,  param
                  .ENDM
ORAFopLzpx          .MACRO param
                  .BYTE $6715,  param
                  .ENDM
ORAFopMzpx          .MACRO param
                  .BYTE $7415,  param
                  .ENDM                  
ORAFopNzpx          .MACRO param          
                  .BYTE $7515,  param
                  .ENDM
ORAFopOzpx          .MACRO param
                  .BYTE $7615,  param
                  .ENDM
ORAFopQzpx          .MACRO param
                  .BYTE $7715,  param
                  .ENDM                  
                           
ORAGopAzpx          .MACRO param
                  .BYTE $4815,  param
                  .ENDM                
ORAGopBzpx          .MACRO param          
                  .BYTE $4915,  param
                  .ENDM
ORAGopCzpx          .MACRO param
                  .BYTE $4A15,  param
                  .ENDM
ORAGopDzpx          .MACRO param
                  .BYTE $4B15,  param
                  .ENDM
ORAGopEzpx          .MACRO param          
                  .BYTE $5815,  param
                  .ENDM
ORAGopFzpx          .MACRO param
                  .BYTE $5915,  param
                  .ENDM
ORAGopGzpx          .MACRO param
                  .BYTE $5A15,  param
                  .ENDM                  
ORAGopHzpx          .MACRO param          
                  .BYTE $5B15,  param
                  .ENDM
ORAGopIzpx          .MACRO param
                  .BYTE $6815,  param
                  .ENDM
ORAGopJzpx          .MACRO param
                  .BYTE $6915,  param
                  .ENDM
ORAGopKzpx          .MACRO param          
                  .BYTE $6A15,  param
                  .ENDM
ORAGopLzpx          .MACRO param
                  .BYTE $6B15,  param
                  .ENDM
ORAGopMzpx          .MACRO param
                  .BYTE $7815,  param
                  .ENDM                  
ORAGopNzpx          .MACRO param          
                  .BYTE $7915,  param
                  .ENDM
ORAGopOzpx          .MACRO param
                  .BYTE $7A15,  param
                  .ENDM
ORAGopQzpx          .MACRO param
                  .BYTE $7B15,  param
                  .ENDM
                  
ORAHopAzpx          .MACRO param
                  .BYTE $4C15,  param
                  .ENDM                
ORAHopBzpx          .MACRO param          
                  .BYTE $4D15,  param
                  .ENDM
ORAHopCzpx          .MACRO param
                  .BYTE $4E15,  param
                  .ENDM
ORAHopDzpx          .MACRO param
                  .BYTE $4F15,  param
                  .ENDM
ORAHopEzpx          .MACRO param          
                  .BYTE $5C15,  param
                  .ENDM
ORAHopFzpx          .MACRO param
                  .BYTE $5D15,  param
                  .ENDM
ORAHopGzpx          .MACRO param
                  .BYTE $5E15,  param
                  .ENDM                  
ORAHopHzpx          .MACRO param          
                  .BYTE $5F15,  param
                  .ENDM
ORAHopIzpx          .MACRO param
                  .BYTE $6C15,  param
                  .ENDM
ORAHopJzpx          .MACRO param
                  .BYTE $6D15,  param
                  .ENDM
ORAHopKzpx          .MACRO param          
                  .BYTE $6E15,  param
                  .ENDM
ORAHopLzpx          .MACRO param
                  .BYTE $6F15,  param
                  .ENDM
ORAHopMzpx          .MACRO param
                  .BYTE $7C15,  param
                  .ENDM                  
ORAHopNzpx          .MACRO param          
                  .BYTE $7D15,  param
                  .ENDM
ORAHopOzpx          .MACRO param
                  .BYTE $7E15,  param
                  .ENDM
ORAHopQzpx          .MACRO param
                  .BYTE $7F15,  param
                  .ENDM
                  
ORAIopAzpx          .MACRO param
                  .BYTE $8015,  param
                  .ENDM                
ORAIopBzpx          .MACRO param          
                  .BYTE $8115,  param
                  .ENDM
ORAIopCzpx          .MACRO param
                  .BYTE $8215,  param
                  .ENDM
ORAIopDzpx          .MACRO param
                  .BYTE $8315,  param
                  .ENDM
ORAIopEzpx          .MACRO param          
                  .BYTE $9015,  param
                  .ENDM
ORAIopFzpx          .MACRO param
                  .BYTE $9115,  param
                  .ENDM
ORAIopGzpx          .MACRO param
                  .BYTE $9215,  param
                  .ENDM                  
ORAIopHzpx          .MACRO param          
                  .BYTE $9315,  param
                  .ENDM
ORAIopIzpx          .MACRO param
                  .BYTE $A015,  param
                  .ENDM
ORAIopJzpx          .MACRO param
                  .BYTE $A115,  param
                  .ENDM
ORAIopKzpx          .MACRO param          
                  .BYTE $A215,  param
                  .ENDM
ORAIopLzpx          .MACRO param
                  .BYTE $A315,  param
                  .ENDM
ORAIopMzpx          .MACRO param
                  .BYTE $B015,  param
                  .ENDM                  
ORAIopNzpx          .MACRO param          
                  .BYTE $B115,  param
                  .ENDM
ORAIopOzpx          .MACRO param
                  .BYTE $B215,  param
                  .ENDM
ORAIopQzpx          .MACRO param
                  .BYTE $B315,  param
                  .ENDM
                  
ORAJopAzpx          .MACRO param
                  .BYTE $8415,  param
                  .ENDM                
ORAJopBzpx          .MACRO param          
                  .BYTE $8515,  param
                  .ENDM
ORAJopCzpx          .MACRO param
                  .BYTE $8615,  param
                  .ENDM
ORAJopDzpx          .MACRO param
                  .BYTE $8715,  param
                  .ENDM
ORAJopEzpx          .MACRO param          
                  .BYTE $9415,  param
                  .ENDM
ORAJopFzpx          .MACRO param
                  .BYTE $9515,  param
                  .ENDM
ORAJopGzpx          .MACRO param
                  .BYTE $9615,  param
                  .ENDM                  
ORAJopHzpx          .MACRO param          
                  .BYTE $9715,  param
                  .ENDM
ORAJopIzpx          .MACRO param
                  .BYTE $A415,  param
                  .ENDM
ORAJopJzpx          .MACRO param
                  .BYTE $A515,  param
                  .ENDM
ORAJopKzpx          .MACRO param          
                  .BYTE $A615,  param
                  .ENDM
ORAJopLzpx          .MACRO param
                  .BYTE $A715,  param
                  .ENDM
ORAJopMzpx          .MACRO param
                  .BYTE $B415,  param
                  .ENDM                  
ORAJopNzpx          .MACRO param          
                  .BYTE $B515,  param
                  .ENDM
ORAJopOzpx          .MACRO param
                  .BYTE $B615,  param
                  .ENDM
ORAJopQzpx          .MACRO param
                  .BYTE $B715,  param
                  .ENDM
                  
ORAKopAzpx          .MACRO param
                  .BYTE $8815,  param
                  .ENDM                
ORAKopBzpx          .MACRO param          
                  .BYTE $8915,  param
                  .ENDM
ORAKopCzpx          .MACRO param
                  .BYTE $8A15,  param
                  .ENDM
ORAKopDzpx          .MACRO param
                  .BYTE $8B15,  param
                  .ENDM
ORAKopEzpx          .MACRO param          
                  .BYTE $9815,  param
                  .ENDM
ORAKopFzpx          .MACRO param
                  .BYTE $9915,  param
                  .ENDM
ORAKopGzpx          .MACRO param
                  .BYTE $9A15,  param
                  .ENDM                  
ORAKopHzpx          .MACRO param          
                  .BYTE $9B15,  param
                  .ENDM
ORAKopIzpx          .MACRO param
                  .BYTE $A815,  param
                  .ENDM
ORAKopJzpx          .MACRO param
                  .BYTE $A915,  param
                  .ENDM
ORAKopKzpx          .MACRO param          
                  .BYTE $AA15,  param
                  .ENDM
ORAKopLzpx          .MACRO param
                  .BYTE $AB15,  param
                  .ENDM
ORAKopMzpx          .MACRO param
                  .BYTE $B815,  param
                  .ENDM                  
ORAKopNzpx          .MACRO param          
                  .BYTE $B915,  param
                  .ENDM
ORAKopOzpx          .MACRO param
                  .BYTE $BA15,  param
                  .ENDM
ORAKopQzpx          .MACRO param
                  .BYTE $BB15,  param
                  .ENDM
                  
ORALopAzpx          .MACRO param
                  .BYTE $8C15,  param
                  .ENDM                
ORALopBzpx          .MACRO param          
                  .BYTE $8D15,  param
                  .ENDM
ORALopCzpx          .MACRO param
                  .BYTE $8E15,  param
                  .ENDM
ORALopDzpx          .MACRO param
                  .BYTE $8F15,  param
                  .ENDM
ORALopEzpx          .MACRO param          
                  .BYTE $9C15,  param
                  .ENDM
ORALopFzpx          .MACRO param
                  .BYTE $9D15,  param
                  .ENDM
ORALopGzpx          .MACRO param
                  .BYTE $9E15,  param
                  .ENDM                  
ORALopHzpx          .MACRO param          
                  .BYTE $9F15,  param
                  .ENDM
ORALopIzpx          .MACRO param
                  .BYTE $AC15,  param
                  .ENDM
ORALopJzpx          .MACRO param
                  .BYTE $AD15,  param
                  .ENDM
ORALopKzpx          .MACRO param          
                  .BYTE $AE15,  param
                  .ENDM
ORALopLzpx          .MACRO param
                  .BYTE $AF15,  param
                  .ENDM
ORALopMzpx          .MACRO param
                  .BYTE $BC15,  param
                  .ENDM                  
ORALopNzpx          .MACRO param          
                  .BYTE $BD15,  param
                  .ENDM
ORALopOzpx          .MACRO param
                  .BYTE $BE15,  param
                  .ENDM
ORALopQzpx          .MACRO param
                  .BYTE $BF15,  param
                  .ENDM
                  
ORAMopAzpx          .MACRO param
                  .BYTE $C015,  param
                  .ENDM                
ORAMopBzpx          .MACRO param          
                  .BYTE $C115,  param
                  .ENDM
ORAMopCzpx          .MACRO param
                  .BYTE $C215,  param
                  .ENDM
ORAMopDzpx          .MACRO param
                  .BYTE $C315,  param
                  .ENDM
ORAMopEzpx          .MACRO param          
                  .BYTE $D015,  param
                  .ENDM
ORAMopFzpx          .MACRO param
                  .BYTE $D115,  param
                  .ENDM
ORAMopGzpx          .MACRO param
                  .BYTE $D215,  param
                  .ENDM                  
ORAMopHzpx          .MACRO param          
                  .BYTE $D315,  param
                  .ENDM
ORAMopIzpx          .MACRO param
                  .BYTE $E015,  param
                  .ENDM
ORAMopJzpx          .MACRO param
                  .BYTE $E115,  param
                  .ENDM
ORAMopKzpx          .MACRO param          
                  .BYTE $E215,  param
                  .ENDM
ORAMopLzpx          .MACRO param
                  .BYTE $E315,  param
                  .ENDM
ORAMopMzpx          .MACRO param
                  .BYTE $F015,  param
                  .ENDM                  
ORAMopNzpx          .MACRO param          
                  .BYTE $F115,  param
                  .ENDM
ORAMopOzpx          .MACRO param
                  .BYTE $F215,  param
                  .ENDM
ORAMopQzpx          .MACRO param
                  .BYTE $F315,  param
                  .ENDM
                  
ORANopAzpx          .MACRO param
                  .BYTE $C415,  param
                  .ENDM                
ORANopBzpx          .MACRO param          
                  .BYTE $C515,  param
                  .ENDM
ORANopCzpx          .MACRO param
                  .BYTE $C615,  param
                  .ENDM
ORANopDzpx          .MACRO param
                  .BYTE $C715,  param
                  .ENDM
ORANopEzpx          .MACRO param          
                  .BYTE $D415,  param
                  .ENDM
ORANopFzpx          .MACRO param
                  .BYTE $D515,  param
                  .ENDM
ORANopGzpx          .MACRO param
                  .BYTE $D615,  param
                  .ENDM                  
ORANopHzpx          .MACRO param          
                  .BYTE $D715,  param
                  .ENDM
ORANopIzpx          .MACRO param
                  .BYTE $E415,  param
                  .ENDM
ORANopJzpx          .MACRO param
                  .BYTE $E515,  param
                  .ENDM
ORANopKzpx          .MACRO param          
                  .BYTE $E615,  param
                  .ENDM
ORANopLzpx          .MACRO param
                  .BYTE $E715,  param
                  .ENDM
ORANopMzpx          .MACRO param
                  .BYTE $F415,  param
                  .ENDM                  
ORANopNzpx          .MACRO param          
                  .BYTE $F515,  param
                  .ENDM
ORANopOzpx          .MACRO param
                  .BYTE $F615,  param
                  .ENDM
ORANopQzpx          .MACRO param
                  .BYTE $F715,  param
                  .ENDM
            
ORAOopAzpx          .MACRO param
                  .BYTE $C815,  param
                  .ENDM                
ORAOopBzpx          .MACRO param          
                  .BYTE $C915,  param
                  .ENDM
ORAOopCzpx          .MACRO param
                  .BYTE $CA15,  param
                  .ENDM
ORAOopDzpx          .MACRO param
                  .BYTE $CB15,  param
                  .ENDM
ORAOopEzpx          .MACRO param          
                  .BYTE $D815,  param
                  .ENDM
ORAOopFzpx          .MACRO param
                  .BYTE $D915,  param
                  .ENDM
ORAOopGzpx          .MACRO param
                  .BYTE $DA15,  param
                  .ENDM                  
ORAOopHzpx          .MACRO param          
                  .BYTE $DB15,  param
                  .ENDM
ORAOopIzpx          .MACRO param
                  .BYTE $E815,  param
                  .ENDM
ORAOopJzpx          .MACRO param
                  .BYTE $E915,  param
                  .ENDM
ORAOopKzpx          .MACRO param          
                  .BYTE $EA15,  param
                  .ENDM
ORAOopLzpx          .MACRO param
                  .BYTE $EB15,  param
                  .ENDM
ORAOopMzpx          .MACRO param
                  .BYTE $F815,  param
                  .ENDM                  
ORAOopNzpx          .MACRO param          
                  .BYTE $F915,  param
                  .ENDM
ORAOopOzpx          .MACRO param
                  .BYTE $FA15,  param
                  .ENDM
ORAOopQzpx          .MACRO param
                  .BYTE $FB15,  param
                  .ENDM
                  
ORAQopAzpx          .MACRO param
                  .BYTE $CC15,  param
                  .ENDM                
ORAQopBzpx          .MACRO param          
                  .BYTE $CD15,  param
                  .ENDM
ORAQopCzpx          .MACRO param
                  .BYTE $CE15,  param
                  .ENDM
ORAQopDzpx          .MACRO param
                  .BYTE $CF15,  param
                  .ENDM
ORAQopEzpx          .MACRO param          
                  .BYTE $DC15,  param
                  .ENDM
ORAQopFzpx          .MACRO param
                  .BYTE $DD15,  param
                  .ENDM
ORAQopGzpx          .MACRO param
                  .BYTE $DE15,  param
                  .ENDM                  
ORAQopHzpx          .MACRO param          
                  .BYTE $DF15,  param
                  .ENDM
ORAQopIzpx          .MACRO param
                  .BYTE $EC15,  param
                  .ENDM
ORAQopJzpx          .MACRO param
                  .BYTE $ED15,  param
                  .ENDM
ORAQopKzpx          .MACRO param          
                  .BYTE $EE15,  param
                  .ENDM
ORAQopLzpx          .MACRO param
                  .BYTE $EF15,  param
                  .ENDM
ORAQopMzpx          .MACRO param
                  .BYTE $FC15,  param
                  .ENDM                  
ORAQopNzpx          .MACRO param          
                  .BYTE $FD15,  param
                  .ENDM
ORAQopOzpx          .MACRO param
                  .BYTE $FE15,  param
                  .ENDM
ORAQopQzpx          .MACRO param
                  .BYTE $FF15,  param
                  .ENDM
                  
;AND $xxxx              $0035
ANDAopBzpx          .MACRO param          
                  .BYTE $0135,  param
                  .ENDM
ANDAopCzpx          .MACRO param
                  .BYTE $0235,  param
                  .ENDM
ANDAopDzpx          .MACRO param
                  .BYTE $0335,  param
                  .ENDM
ANDAopEzpx          .MACRO param          
                  .BYTE $1035,  param
                  .ENDM
ANDAopFzpx          .MACRO param
                  .BYTE $1135,  param
                  .ENDM
ANDAopGzpx          .MACRO param
                  .BYTE $1235,  param
                  .ENDM                  
ANDAopHzpx          .MACRO param          
                  .BYTE $1335,  param
                  .ENDM
ANDAopIzpx          .MACRO param
                  .BYTE $2035,  param
                  .ENDM
ANDAopJzpx          .MACRO param
                  .BYTE $2135,  param
                  .ENDM
ANDAopKzpx          .MACRO param          
                  .BYTE $2235,  param
                  .ENDM
ANDAopLzpx          .MACRO param
                  .BYTE $2335,  param
                  .ENDM
ANDAopMzpx          .MACRO param
                  .BYTE $3035,  param
                  .ENDM                  
ANDAopNzpx          .MACRO param          
                  .BYTE $3135,  param
                  .ENDM
ANDAopOzpx          .MACRO param
                  .BYTE $3235,  param
                  .ENDM
ANDAopQzpx          .MACRO param
                  .BYTE $3335,  param
                  .ENDM
                                    
ANDBopAzpx          .MACRO param
                  .BYTE $0435,  param
                  .ENDM                
ANDBopBzpx          .MACRO param          
                  .BYTE $0535,  param
                  .ENDM
ANDBopCzpx          .MACRO param
                  .BYTE $0635,  param
                  .ENDM
ANDBopDzpx          .MACRO param
                  .BYTE $0735,  param
                  .ENDM
ANDBopEzpx          .MACRO param          
                  .BYTE $1435,  param
                  .ENDM
ANDBopFzpx          .MACRO param
                  .BYTE $1535,  param
                  .ENDM
ANDBopGzpx          .MACRO param
                  .BYTE $1635,  param
                  .ENDM                  
ANDBopHzpx          .MACRO param          
                  .BYTE $1735,  param
                  .ENDM
ANDBopIzpx          .MACRO param
                  .BYTE $2435,  param
                  .ENDM
ANDBopJzpx          .MACRO param
                  .BYTE $2535,  param
                  .ENDM
ANDBopKzpx          .MACRO param          
                  .BYTE $2635,  param
                  .ENDM
ANDBopLzpx          .MACRO param
                  .BYTE $2735,  param
                  .ENDM
ANDBopMzpx          .MACRO param
                  .BYTE $3035,  param
                  .ENDM                  
ANDBopNzpx          .MACRO param          
                  .BYTE $3135,  param
                  .ENDM
ANDBopOzpx          .MACRO param
                  .BYTE $3235,  param
                  .ENDM
ANDBopQzpx          .MACRO param
                  .BYTE $3335,  param
                  .ENDM
                                    
ANDCopAzpx          .MACRO param
                  .BYTE $0835,  param
                  .ENDM                
ANDCopBzpx          .MACRO param          
                  .BYTE $0935,  param
                  .ENDM
ANDCopCzpx          .MACRO param
                  .BYTE $0A35,  param
                  .ENDM
ANDCopDzpx          .MACRO param
                  .BYTE $0B35,  param
                  .ENDM
ANDCopEzpx          .MACRO param          
                  .BYTE $1835,  param
                  .ENDM
ANDCopFzpx          .MACRO param
                  .BYTE $1935,  param
                  .ENDM
ANDCopGzpx          .MACRO param
                  .BYTE $1A35,  param
                  .ENDM                  
ANDCopHzpx          .MACRO param          
                  .BYTE $1B35,  param
                  .ENDM
ANDCopIzpx          .MACRO param
                  .BYTE $2835,  param
                  .ENDM
ANDCopJzpx          .MACRO param
                  .BYTE $2935,  param
                  .ENDM
ANDCopKzpx          .MACRO param          
                  .BYTE $2A35,  param
                  .ENDM
ANDCopLzpx          .MACRO param
                  .BYTE $2B35,  param
                  .ENDM
ANDCopMzpx          .MACRO param
                  .BYTE $3835,  param
                  .ENDM                  
ANDCopNzpx          .MACRO param          
                  .BYTE $3935,  param
                  .ENDM
ANDCopOzpx          .MACRO param
                  .BYTE $3A35,  param
                  .ENDM
ANDCopQzpx          .MACRO param
                  .BYTE $3B35,  param
                  .ENDM

ANDDopAzpx          .MACRO param
                  .BYTE $0C35,  param
                  .ENDM                
ANDDopBzpx          .MACRO param          
                  .BYTE $0D35,  param
                  .ENDM
ANDDopCzpx          .MACRO param
                  .BYTE $0E35,  param
                  .ENDM
ANDDopDzpx          .MACRO param
                  .BYTE $0F35,  param
                  .ENDM
ANDDopEzpx          .MACRO param          
                  .BYTE $1C35,  param
                  .ENDM
ANDDopFzpx          .MACRO param
                  .BYTE $1D35,  param
                  .ENDM
ANDDopGzpx          .MACRO param
                  .BYTE $1E35,  param
                  .ENDM                  
ANDDopHzpx          .MACRO param          
                  .BYTE $1F35,  param
                  .ENDM
ANDDopIzpx          .MACRO param
                  .BYTE $2C35,  param
                  .ENDM
ANDDopJzpx          .MACRO param
                  .BYTE $2D35,  param
                  .ENDM
ANDDopKzpx          .MACRO param          
                  .BYTE $2E35,  param
                  .ENDM
ANDDopLzpx          .MACRO param
                  .BYTE $2F35,  param
                  .ENDM
ANDDopMzpx          .MACRO param
                  .BYTE $3C35,  param
                  .ENDM                  
ANDDopNzpx          .MACRO param          
                  .BYTE $3D35,  param
                  .ENDM
ANDDopOzpx          .MACRO param
                  .BYTE $3E35,  param
                  .ENDM
ANDDopQzpx          .MACRO param
                  .BYTE $3F35,  param
                  .ENDM                  

ANDEopAzpx          .MACRO param
                  .BYTE $4035,  param
                  .ENDM                
ANDEopBzpx          .MACRO param          
                  .BYTE $4135,  param
                  .ENDM
ANDEopCzpx          .MACRO param
                  .BYTE $4235,  param
                  .ENDM
ANDEopDzpx          .MACRO param
                  .BYTE $4335,  param
                  .ENDM
ANDEopEzpx          .MACRO param          
                  .BYTE $5035,  param
                  .ENDM
ANDEopFzpx          .MACRO param
                  .BYTE $5135,  param
                  .ENDM
ANDEopGzpx          .MACRO param
                  .BYTE $5235,  param
                  .ENDM                  
ANDEopHzpx          .MACRO param          
                  .BYTE $5335,  param
                  .ENDM
ANDEopIzpx          .MACRO param
                  .BYTE $6035,  param
                  .ENDM
ANDEopJzpx          .MACRO param
                  .BYTE $6135,  param
                  .ENDM
ANDEopKzpx          .MACRO param          
                  .BYTE $6235,  param
                  .ENDM
ANDEopLzpx          .MACRO param
                  .BYTE $6335,  param
                  .ENDM
ANDEopMzpx          .MACRO param
                  .BYTE $7035,  param
                  .ENDM                  
ANDEopNzpx          .MACRO param          
                  .BYTE $7135,  param
                  .ENDM
ANDEopOzpx          .MACRO param
                  .BYTE $7235,  param
                  .ENDM
ANDEopQzpx          .MACRO param
                  .BYTE $7335,  param
                  .ENDM
                  
ANDFopAzpx          .MACRO param
                  .BYTE $4435,  param
                  .ENDM                
ANDFopBzpx          .MACRO param          
                  .BYTE $4535,  param
                  .ENDM
ANDFopCzpx          .MACRO param
                  .BYTE $4635,  param
                  .ENDM
ANDFopDzpx          .MACRO param
                  .BYTE $4735,  param
                  .ENDM
ANDFopEzpx          .MACRO param          
                  .BYTE $5435,  param
                  .ENDM
ANDFopFzpx          .MACRO param
                  .BYTE $5535,  param
                  .ENDM
ANDFopGzpx          .MACRO param
                  .BYTE $5635,  param
                  .ENDM                  
ANDFopHzpx          .MACRO param          
                  .BYTE $5735,  param
                  .ENDM
ANDFopIzpx          .MACRO param
                  .BYTE $6435,  param
                  .ENDM
ANDFopJzpx          .MACRO param
                  .BYTE $6535,  param
                  .ENDM
ANDFopKzpx          .MACRO param          
                  .BYTE $6635,  param
                  .ENDM
ANDFopLzpx          .MACRO param
                  .BYTE $6735,  param
                  .ENDM
ANDFopMzpx          .MACRO param
                  .BYTE $7435,  param
                  .ENDM                  
ANDFopNzpx          .MACRO param          
                  .BYTE $7535,  param
                  .ENDM
ANDFopOzpx          .MACRO param
                  .BYTE $7635,  param
                  .ENDM
ANDFopQzpx          .MACRO param
                  .BYTE $7735,  param
                  .ENDM                  
                           
ANDGopAzpx          .MACRO param
                  .BYTE $4835,  param
                  .ENDM                
ANDGopBzpx          .MACRO param          
                  .BYTE $4935,  param
                  .ENDM
ANDGopCzpx          .MACRO param
                  .BYTE $4A35,  param
                  .ENDM
ANDGopDzpx          .MACRO param
                  .BYTE $4B35,  param
                  .ENDM
ANDGopEzpx          .MACRO param          
                  .BYTE $5835,  param
                  .ENDM
ANDGopFzpx          .MACRO param
                  .BYTE $5935,  param
                  .ENDM
ANDGopGzpx          .MACRO param
                  .BYTE $5A35,  param
                  .ENDM                  
ANDGopHzpx          .MACRO param          
                  .BYTE $5B35,  param
                  .ENDM
ANDGopIzpx          .MACRO param
                  .BYTE $6835,  param
                  .ENDM
ANDGopJzpx          .MACRO param
                  .BYTE $6935,  param
                  .ENDM
ANDGopKzpx          .MACRO param          
                  .BYTE $6A35,  param
                  .ENDM
ANDGopLzpx          .MACRO param
                  .BYTE $6B35,  param
                  .ENDM
ANDGopMzpx          .MACRO param
                  .BYTE $7835,  param
                  .ENDM                  
ANDGopNzpx          .MACRO param          
                  .BYTE $7935,  param
                  .ENDM
ANDGopOzpx          .MACRO param
                  .BYTE $7A35,  param
                  .ENDM
ANDGopQzpx          .MACRO param
                  .BYTE $7B35,  param
                  .ENDM
                  
ANDHopAzpx          .MACRO param
                  .BYTE $4C35,  param
                  .ENDM                
ANDHopBzpx          .MACRO param          
                  .BYTE $4D35,  param
                  .ENDM
ANDHopCzpx          .MACRO param
                  .BYTE $4E35,  param
                  .ENDM
ANDHopDzpx          .MACRO param
                  .BYTE $4F35,  param
                  .ENDM
ANDHopEzpx          .MACRO param          
                  .BYTE $5C35,  param
                  .ENDM
ANDHopFzpx          .MACRO param
                  .BYTE $5D35,  param
                  .ENDM
ANDHopGzpx          .MACRO param
                  .BYTE $5E35,  param
                  .ENDM                  
ANDHopHzpx          .MACRO param          
                  .BYTE $5F35,  param
                  .ENDM
ANDHopIzpx          .MACRO param
                  .BYTE $6C35,  param
                  .ENDM
ANDHopJzpx          .MACRO param
                  .BYTE $6D35,  param
                  .ENDM
ANDHopKzpx          .MACRO param          
                  .BYTE $6E35,  param
                  .ENDM
ANDHopLzpx          .MACRO param
                  .BYTE $6F35,  param
                  .ENDM
ANDHopMzpx          .MACRO param
                  .BYTE $7C35,  param
                  .ENDM                  
ANDHopNzpx          .MACRO param          
                  .BYTE $7D35,  param
                  .ENDM
ANDHopOzpx          .MACRO param
                  .BYTE $7E35,  param
                  .ENDM
ANDHopQzpx          .MACRO param
                  .BYTE $7F35,  param
                  .ENDM
                  
ANDIopAzpx          .MACRO param
                  .BYTE $8035,  param
                  .ENDM                
ANDIopBzpx          .MACRO param          
                  .BYTE $8135,  param
                  .ENDM
ANDIopCzpx          .MACRO param
                  .BYTE $8235,  param
                  .ENDM
ANDIopDzpx          .MACRO param
                  .BYTE $8335,  param
                  .ENDM
ANDIopEzpx          .MACRO param          
                  .BYTE $9035,  param
                  .ENDM
ANDIopFzpx          .MACRO param
                  .BYTE $9135,  param
                  .ENDM
ANDIopGzpx          .MACRO param
                  .BYTE $9235,  param
                  .ENDM                  
ANDIopHzpx          .MACRO param          
                  .BYTE $9335,  param
                  .ENDM
ANDIopIzpx          .MACRO param
                  .BYTE $A035,  param
                  .ENDM
ANDIopJzpx          .MACRO param
                  .BYTE $A135,  param
                  .ENDM
ANDIopKzpx          .MACRO param          
                  .BYTE $A235,  param
                  .ENDM
ANDIopLzpx          .MACRO param
                  .BYTE $A335,  param
                  .ENDM
ANDIopMzpx          .MACRO param
                  .BYTE $B035,  param
                  .ENDM                  
ANDIopNzpx          .MACRO param          
                  .BYTE $B135,  param
                  .ENDM
ANDIopOzpx          .MACRO param
                  .BYTE $B235,  param
                  .ENDM
ANDIopQzpx          .MACRO param
                  .BYTE $B335,  param
                  .ENDM
                  
ANDJopAzpx          .MACRO param
                  .BYTE $8435,  param
                  .ENDM                
ANDJopBzpx          .MACRO param          
                  .BYTE $8535,  param
                  .ENDM
ANDJopCzpx          .MACRO param
                  .BYTE $8635,  param
                  .ENDM
ANDJopDzpx          .MACRO param
                  .BYTE $8735,  param
                  .ENDM
ANDJopEzpx          .MACRO param          
                  .BYTE $9435,  param
                  .ENDM
ANDJopFzpx          .MACRO param
                  .BYTE $9535,  param
                  .ENDM
ANDJopGzpx          .MACRO param
                  .BYTE $9635,  param
                  .ENDM                  
ANDJopHzpx          .MACRO param          
                  .BYTE $9735,  param
                  .ENDM
ANDJopIzpx          .MACRO param
                  .BYTE $A435,  param
                  .ENDM
ANDJopJzpx          .MACRO param
                  .BYTE $A535,  param
                  .ENDM
ANDJopKzpx          .MACRO param          
                  .BYTE $A635,  param
                  .ENDM
ANDJopLzpx          .MACRO param
                  .BYTE $A735,  param
                  .ENDM
ANDJopMzpx          .MACRO param
                  .BYTE $B435,  param
                  .ENDM                  
ANDJopNzpx          .MACRO param          
                  .BYTE $B535,  param
                  .ENDM
ANDJopOzpx          .MACRO param
                  .BYTE $B635,  param
                  .ENDM
ANDJopQzpx          .MACRO param
                  .BYTE $B735,  param
                  .ENDM
                  
ANDKopAzpx          .MACRO param
                  .BYTE $8835,  param
                  .ENDM                
ANDKopBzpx          .MACRO param          
                  .BYTE $8935,  param
                  .ENDM
ANDKopCzpx          .MACRO param
                  .BYTE $8A35,  param
                  .ENDM
ANDKopDzpx          .MACRO param
                  .BYTE $8B35,  param
                  .ENDM
ANDKopEzpx          .MACRO param          
                  .BYTE $9835,  param
                  .ENDM
ANDKopFzpx          .MACRO param
                  .BYTE $9935,  param
                  .ENDM
ANDKopGzpx          .MACRO param
                  .BYTE $9A35,  param
                  .ENDM                  
ANDKopHzpx          .MACRO param          
                  .BYTE $9B35,  param
                  .ENDM
ANDKopIzpx          .MACRO param
                  .BYTE $A835,  param
                  .ENDM
ANDKopJzpx          .MACRO param
                  .BYTE $A935,  param
                  .ENDM
ANDKopKzpx          .MACRO param          
                  .BYTE $AA35,  param
                  .ENDM
ANDKopLzpx          .MACRO param
                  .BYTE $AB35,  param
                  .ENDM
ANDKopMzpx          .MACRO param
                  .BYTE $B835,  param
                  .ENDM                  
ANDKopNzpx          .MACRO param          
                  .BYTE $B935,  param
                  .ENDM
ANDKopOzpx          .MACRO param
                  .BYTE $BA35,  param
                  .ENDM
ANDKopQzpx          .MACRO param
                  .BYTE $BB35,  param
                  .ENDM
                  
ANDLopAzpx          .MACRO param
                  .BYTE $8C35,  param
                  .ENDM                
ANDLopBzpx          .MACRO param          
                  .BYTE $8D35,  param
                  .ENDM
ANDLopCzpx          .MACRO param
                  .BYTE $8E35,  param
                  .ENDM
ANDLopDzpx          .MACRO param
                  .BYTE $8F35,  param
                  .ENDM
ANDLopEzpx          .MACRO param          
                  .BYTE $9C35,  param
                  .ENDM
ANDLopFzpx          .MACRO param
                  .BYTE $9D35,  param
                  .ENDM
ANDLopGzpx          .MACRO param
                  .BYTE $9E35,  param
                  .ENDM                  
ANDLopHzpx          .MACRO param          
                  .BYTE $9F35,  param
                  .ENDM
ANDLopIzpx          .MACRO param
                  .BYTE $AC35,  param
                  .ENDM
ANDLopJzpx          .MACRO param
                  .BYTE $AD35,  param
                  .ENDM
ANDLopKzpx          .MACRO param          
                  .BYTE $AE35,  param
                  .ENDM
ANDLopLzpx          .MACRO param
                  .BYTE $AF35,  param
                  .ENDM
ANDLopMzpx          .MACRO param
                  .BYTE $BC35,  param
                  .ENDM                  
ANDLopNzpx          .MACRO param          
                  .BYTE $BD35,  param
                  .ENDM
ANDLopOzpx          .MACRO param
                  .BYTE $BE35,  param
                  .ENDM
ANDLopQzpx          .MACRO param
                  .BYTE $BF35,  param
                  .ENDM
                  
ANDMopAzpx          .MACRO param
                  .BYTE $C035,  param
                  .ENDM                
ANDMopBzpx          .MACRO param          
                  .BYTE $C135,  param
                  .ENDM
ANDMopCzpx          .MACRO param
                  .BYTE $C235,  param
                  .ENDM
ANDMopDzpx          .MACRO param
                  .BYTE $C335,  param
                  .ENDM
ANDMopEzpx          .MACRO param          
                  .BYTE $D035,  param
                  .ENDM
ANDMopFzpx          .MACRO param
                  .BYTE $D135,  param
                  .ENDM
ANDMopGzpx          .MACRO param
                  .BYTE $D235,  param
                  .ENDM                  
ANDMopHzpx          .MACRO param          
                  .BYTE $D335,  param
                  .ENDM
ANDMopIzpx          .MACRO param
                  .BYTE $E035,  param
                  .ENDM
ANDMopJzpx          .MACRO param
                  .BYTE $E135,  param
                  .ENDM
ANDMopKzpx          .MACRO param          
                  .BYTE $E235,  param
                  .ENDM
ANDMopLzpx          .MACRO param
                  .BYTE $E335,  param
                  .ENDM
ANDMopMzpx          .MACRO param
                  .BYTE $F035,  param
                  .ENDM                  
ANDMopNzpx          .MACRO param          
                  .BYTE $F135,  param
                  .ENDM
ANDMopOzpx          .MACRO param
                  .BYTE $F235,  param
                  .ENDM
ANDMopQzpx          .MACRO param
                  .BYTE $F335,  param
                  .ENDM
                  
ANDNopAzpx          .MACRO param
                  .BYTE $C435,  param
                  .ENDM                
ANDNopBzpx          .MACRO param          
                  .BYTE $C535,  param
                  .ENDM
ANDNopCzpx          .MACRO param
                  .BYTE $C635,  param
                  .ENDM
ANDNopDzpx          .MACRO param
                  .BYTE $C735,  param
                  .ENDM
ANDNopEzpx          .MACRO param          
                  .BYTE $D435,  param
                  .ENDM
ANDNopFzpx          .MACRO param
                  .BYTE $D535,  param
                  .ENDM
ANDNopGzpx          .MACRO param
                  .BYTE $D635,  param
                  .ENDM                  
ANDNopHzpx          .MACRO param          
                  .BYTE $D735,  param
                  .ENDM
ANDNopIzpx          .MACRO param
                  .BYTE $E435,  param
                  .ENDM
ANDNopJzpx          .MACRO param
                  .BYTE $E535,  param
                  .ENDM
ANDNopKzpx          .MACRO param          
                  .BYTE $E635,  param
                  .ENDM
ANDNopLzpx          .MACRO param
                  .BYTE $E735,  param
                  .ENDM
ANDNopMzpx          .MACRO param
                  .BYTE $F435,  param
                  .ENDM                  
ANDNopNzpx          .MACRO param          
                  .BYTE $F535,  param
                  .ENDM
ANDNopOzpx          .MACRO param
                  .BYTE $F635,  param
                  .ENDM
ANDNopQzpx          .MACRO param
                  .BYTE $F735,  param
                  .ENDM
            
ANDOopAzpx          .MACRO param
                  .BYTE $C835,  param
                  .ENDM                
ANDOopBzpx          .MACRO param          
                  .BYTE $C935,  param
                  .ENDM
ANDOopCzpx          .MACRO param
                  .BYTE $CA35,  param
                  .ENDM
ANDOopDzpx          .MACRO param
                  .BYTE $CB35,  param
                  .ENDM
ANDOopEzpx          .MACRO param          
                  .BYTE $D835,  param
                  .ENDM
ANDOopFzpx          .MACRO param
                  .BYTE $D935,  param
                  .ENDM
ANDOopGzpx          .MACRO param
                  .BYTE $DA35,  param
                  .ENDM                  
ANDOopHzpx          .MACRO param          
                  .BYTE $DB35,  param
                  .ENDM
ANDOopIzpx          .MACRO param
                  .BYTE $E835,  param
                  .ENDM
ANDOopJzpx          .MACRO param
                  .BYTE $E935,  param
                  .ENDM
ANDOopKzpx          .MACRO param          
                  .BYTE $EA35,  param
                  .ENDM
ANDOopLzpx          .MACRO param
                  .BYTE $EB35,  param
                  .ENDM
ANDOopMzpx          .MACRO param
                  .BYTE $F835,  param
                  .ENDM                  
ANDOopNzpx          .MACRO param          
                  .BYTE $F935,  param
                  .ENDM
ANDOopOzpx          .MACRO param
                  .BYTE $FA35,  param
                  .ENDM
ANDOopQzpx          .MACRO param
                  .BYTE $FB35,  param
                  .ENDM
                  
ANDQopAzpx          .MACRO param
                  .BYTE $CC35,  param
                  .ENDM                
ANDQopBzpx          .MACRO param          
                  .BYTE $CD35,  param
                  .ENDM
ANDQopCzpx          .MACRO param
                  .BYTE $CE35,  param
                  .ENDM
ANDQopDzpx          .MACRO param
                  .BYTE $CF35,  param
                  .ENDM
ANDQopEzpx          .MACRO param          
                  .BYTE $DC35,  param
                  .ENDM
ANDQopFzpx          .MACRO param
                  .BYTE $DD35,  param
                  .ENDM
ANDQopGzpx          .MACRO param
                  .BYTE $DE35,  param
                  .ENDM                  
ANDQopHzpx          .MACRO param          
                  .BYTE $DF35,  param
                  .ENDM
ANDQopIzpx          .MACRO param
                  .BYTE $EC35,  param
                  .ENDM
ANDQopJzpx          .MACRO param
                  .BYTE $ED35,  param
                  .ENDM
ANDQopKzpx          .MACRO param          
                  .BYTE $EE35,  param
                  .ENDM
ANDQopLzpx          .MACRO param
                  .BYTE $EF35,  param
                  .ENDM
ANDQopMzpx          .MACRO param
                  .BYTE $FC35,  param
                  .ENDM                  
ANDQopNzpx          .MACRO param          
                  .BYTE $FD35,  param
                  .ENDM
ANDQopOzpx          .MACRO param
                  .BYTE $FE35,  param
                  .ENDM
ANDQopQzpx          .MACRO param
                  .BYTE $FF35,  param
                  .ENDM
                  
;EOR $xxxx              $0055
EORAopBzpx          .MACRO param          
                  .BYTE $0155,  param
                  .ENDM
EORAopCzpx          .MACRO param
                  .BYTE $0255,  param
                  .ENDM
EORAopDzpx          .MACRO param
                  .BYTE $0355,  param
                  .ENDM
EORAopEzpx          .MACRO param          
                  .BYTE $1055,  param
                  .ENDM
EORAopFzpx          .MACRO param
                  .BYTE $1155,  param
                  .ENDM
EORAopGzpx          .MACRO param
                  .BYTE $1255,  param
                  .ENDM                  
EORAopHzpx          .MACRO param          
                  .BYTE $1355,  param
                  .ENDM
EORAopIzpx          .MACRO param
                  .BYTE $2055,  param
                  .ENDM
EORAopJzpx          .MACRO param
                  .BYTE $2155,  param
                  .ENDM
EORAopKzpx          .MACRO param          
                  .BYTE $2255,  param
                  .ENDM
EORAopLzpx          .MACRO param
                  .BYTE $2355,  param
                  .ENDM
EORAopMzpx          .MACRO param
                  .BYTE $3055,  param
                  .ENDM                  
EORAopNzpx          .MACRO param          
                  .BYTE $3155,  param
                  .ENDM
EORAopOzpx          .MACRO param
                  .BYTE $3255,  param
                  .ENDM
EORAopQzpx          .MACRO param
                  .BYTE $3355,  param
                  .ENDM
                                    
EORBopAzpx          .MACRO param
                  .BYTE $0455,  param
                  .ENDM                
EORBopBzpx          .MACRO param          
                  .BYTE $0555,  param
                  .ENDM
EORBopCzpx          .MACRO param
                  .BYTE $0655,  param
                  .ENDM
EORBopDzpx          .MACRO param
                  .BYTE $0755,  param
                  .ENDM
EORBopEzpx          .MACRO param          
                  .BYTE $1455,  param
                  .ENDM
EORBopFzpx          .MACRO param
                  .BYTE $1555,  param
                  .ENDM
EORBopGzpx          .MACRO param
                  .BYTE $1655,  param
                  .ENDM                  
EORBopHzpx          .MACRO param          
                  .BYTE $1755,  param
                  .ENDM
EORBopIzpx          .MACRO param
                  .BYTE $2455,  param
                  .ENDM
EORBopJzpx          .MACRO param
                  .BYTE $2555,  param
                  .ENDM
EORBopKzpx          .MACRO param          
                  .BYTE $2655,  param
                  .ENDM
EORBopLzpx          .MACRO param
                  .BYTE $2755,  param
                  .ENDM
EORBopMzpx          .MACRO param
                  .BYTE $3055,  param
                  .ENDM                  
EORBopNzpx          .MACRO param          
                  .BYTE $3155,  param
                  .ENDM
EORBopOzpx          .MACRO param
                  .BYTE $3255,  param
                  .ENDM
EORBopQzpx          .MACRO param
                  .BYTE $3355,  param
                  .ENDM
                                    
EORCopAzpx          .MACRO param
                  .BYTE $0855,  param
                  .ENDM                
EORCopBzpx          .MACRO param          
                  .BYTE $0955,  param
                  .ENDM
EORCopCzpx          .MACRO param
                  .BYTE $0A55,  param
                  .ENDM
EORCopDzpx          .MACRO param
                  .BYTE $0B55,  param
                  .ENDM
EORCopEzpx          .MACRO param          
                  .BYTE $1855,  param
                  .ENDM
EORCopFzpx          .MACRO param
                  .BYTE $1955,  param
                  .ENDM
EORCopGzpx          .MACRO param
                  .BYTE $1A55,  param
                  .ENDM                  
EORCopHzpx          .MACRO param          
                  .BYTE $1B55,  param
                  .ENDM
EORCopIzpx          .MACRO param
                  .BYTE $2855,  param
                  .ENDM
EORCopJzpx          .MACRO param
                  .BYTE $2955,  param
                  .ENDM
EORCopKzpx          .MACRO param          
                  .BYTE $2A55,  param
                  .ENDM
EORCopLzpx          .MACRO param
                  .BYTE $2B55,  param
                  .ENDM
EORCopMzpx          .MACRO param
                  .BYTE $3855,  param
                  .ENDM                  
EORCopNzpx          .MACRO param          
                  .BYTE $3955,  param
                  .ENDM
EORCopOzpx          .MACRO param
                  .BYTE $3A55,  param
                  .ENDM
EORCopQzpx          .MACRO param
                  .BYTE $3B55,  param
                  .ENDM

EORDopAzpx          .MACRO param
                  .BYTE $0C55,  param
                  .ENDM                
EORDopBzpx          .MACRO param          
                  .BYTE $0D55,  param
                  .ENDM
EORDopCzpx          .MACRO param
                  .BYTE $0E55,  param
                  .ENDM
EORDopDzpx          .MACRO param
                  .BYTE $0F55,  param
                  .ENDM
EORDopEzpx          .MACRO param          
                  .BYTE $1C55,  param
                  .ENDM
EORDopFzpx          .MACRO param
                  .BYTE $1D55,  param
                  .ENDM
EORDopGzpx          .MACRO param
                  .BYTE $1E55,  param
                  .ENDM                  
EORDopHzpx          .MACRO param          
                  .BYTE $1F55,  param
                  .ENDM
EORDopIzpx          .MACRO param
                  .BYTE $2C55,  param
                  .ENDM
EORDopJzpx          .MACRO param
                  .BYTE $2D55,  param
                  .ENDM
EORDopKzpx          .MACRO param          
                  .BYTE $2E55,  param
                  .ENDM
EORDopLzpx          .MACRO param
                  .BYTE $2F55,  param
                  .ENDM
EORDopMzpx          .MACRO param
                  .BYTE $3C55,  param
                  .ENDM                  
EORDopNzpx          .MACRO param          
                  .BYTE $3D55,  param
                  .ENDM
EORDopOzpx          .MACRO param
                  .BYTE $3E55,  param
                  .ENDM
EORDopQzpx          .MACRO param
                  .BYTE $3F55,  param
                  .ENDM                  

EOREopAzpx          .MACRO param
                  .BYTE $4055,  param
                  .ENDM                
EOREopBzpx          .MACRO param          
                  .BYTE $4155,  param
                  .ENDM
EOREopCzpx          .MACRO param
                  .BYTE $4255,  param
                  .ENDM
EOREopDzpx          .MACRO param
                  .BYTE $4355,  param
                  .ENDM
EOREopEzpx          .MACRO param          
                  .BYTE $5055,  param
                  .ENDM
EOREopFzpx          .MACRO param
                  .BYTE $5155,  param
                  .ENDM
EOREopGzpx          .MACRO param
                  .BYTE $5255,  param
                  .ENDM                  
EOREopHzpx          .MACRO param          
                  .BYTE $5355,  param
                  .ENDM
EOREopIzpx          .MACRO param
                  .BYTE $6055,  param
                  .ENDM
EOREopJzpx          .MACRO param
                  .BYTE $6155,  param
                  .ENDM
EOREopKzpx          .MACRO param          
                  .BYTE $6255,  param
                  .ENDM
EOREopLzpx          .MACRO param
                  .BYTE $6355,  param
                  .ENDM
EOREopMzpx          .MACRO param
                  .BYTE $7055,  param
                  .ENDM                  
EOREopNzpx          .MACRO param          
                  .BYTE $7155,  param
                  .ENDM
EOREopOzpx          .MACRO param
                  .BYTE $7255,  param
                  .ENDM
EOREopQzpx          .MACRO param
                  .BYTE $7355,  param
                  .ENDM
                  
EORFopAzpx          .MACRO param
                  .BYTE $4455,  param
                  .ENDM                
EORFopBzpx          .MACRO param          
                  .BYTE $4555,  param
                  .ENDM
EORFopCzpx          .MACRO param
                  .BYTE $4655,  param
                  .ENDM
EORFopDzpx          .MACRO param
                  .BYTE $4755,  param
                  .ENDM
EORFopEzpx          .MACRO param          
                  .BYTE $5455,  param
                  .ENDM
EORFopFzpx          .MACRO param
                  .BYTE $5555,  param
                  .ENDM
EORFopGzpx          .MACRO param
                  .BYTE $5655,  param
                  .ENDM                  
EORFopHzpx          .MACRO param          
                  .BYTE $5755,  param
                  .ENDM
EORFopIzpx          .MACRO param
                  .BYTE $6455,  param
                  .ENDM
EORFopJzpx          .MACRO param
                  .BYTE $6555,  param
                  .ENDM
EORFopKzpx          .MACRO param          
                  .BYTE $6655,  param
                  .ENDM
EORFopLzpx          .MACRO param
                  .BYTE $6755,  param
                  .ENDM
EORFopMzpx          .MACRO param
                  .BYTE $7455,  param
                  .ENDM                  
EORFopNzpx          .MACRO param          
                  .BYTE $7555,  param
                  .ENDM
EORFopOzpx          .MACRO param
                  .BYTE $7655,  param
                  .ENDM
EORFopQzpx          .MACRO param
                  .BYTE $7755,  param
                  .ENDM                  
                           
EORGopAzpx          .MACRO param
                  .BYTE $4855,  param
                  .ENDM                
EORGopBzpx          .MACRO param          
                  .BYTE $4955,  param
                  .ENDM
EORGopCzpx          .MACRO param
                  .BYTE $4A55,  param
                  .ENDM
EORGopDzpx          .MACRO param
                  .BYTE $4B55,  param
                  .ENDM
EORGopEzpx          .MACRO param          
                  .BYTE $5855,  param
                  .ENDM
EORGopFzpx          .MACRO param
                  .BYTE $5955,  param
                  .ENDM
EORGopGzpx          .MACRO param
                  .BYTE $5A55,  param
                  .ENDM                  
EORGopHzpx          .MACRO param          
                  .BYTE $5B55,  param
                  .ENDM
EORGopIzpx          .MACRO param
                  .BYTE $6855,  param
                  .ENDM
EORGopJzpx          .MACRO param
                  .BYTE $6955,  param
                  .ENDM
EORGopKzpx          .MACRO param          
                  .BYTE $6A55,  param
                  .ENDM
EORGopLzpx          .MACRO param
                  .BYTE $6B55,  param
                  .ENDM
EORGopMzpx          .MACRO param
                  .BYTE $7855,  param
                  .ENDM                  
EORGopNzpx          .MACRO param          
                  .BYTE $7955,  param
                  .ENDM
EORGopOzpx          .MACRO param
                  .BYTE $7A55,  param
                  .ENDM
EORGopQzpx          .MACRO param
                  .BYTE $7B55,  param
                  .ENDM
                  
EORHopAzpx          .MACRO param
                  .BYTE $4C55,  param
                  .ENDM                
EORHopBzpx          .MACRO param          
                  .BYTE $4D55,  param
                  .ENDM
EORHopCzpx          .MACRO param
                  .BYTE $4E55,  param
                  .ENDM
EORHopDzpx          .MACRO param
                  .BYTE $4F55,  param
                  .ENDM
EORHopEzpx          .MACRO param          
                  .BYTE $5C55,  param
                  .ENDM
EORHopFzpx          .MACRO param
                  .BYTE $5D55,  param
                  .ENDM
EORHopGzpx          .MACRO param
                  .BYTE $5E55,  param
                  .ENDM                  
EORHopHzpx          .MACRO param          
                  .BYTE $5F55,  param
                  .ENDM
EORHopIzpx          .MACRO param
                  .BYTE $6C55,  param
                  .ENDM
EORHopJzpx          .MACRO param
                  .BYTE $6D55,  param
                  .ENDM
EORHopKzpx          .MACRO param          
                  .BYTE $6E55,  param
                  .ENDM
EORHopLzpx          .MACRO param
                  .BYTE $6F55,  param
                  .ENDM
EORHopMzpx          .MACRO param
                  .BYTE $7C55,  param
                  .ENDM                  
EORHopNzpx          .MACRO param          
                  .BYTE $7D55,  param
                  .ENDM
EORHopOzpx          .MACRO param
                  .BYTE $7E55,  param
                  .ENDM
EORHopQzpx          .MACRO param
                  .BYTE $7F55,  param
                  .ENDM
                  
EORIopAzpx          .MACRO param
                  .BYTE $8055,  param
                  .ENDM                
EORIopBzpx          .MACRO param          
                  .BYTE $8155,  param
                  .ENDM
EORIopCzpx          .MACRO param
                  .BYTE $8255,  param
                  .ENDM
EORIopDzpx          .MACRO param
                  .BYTE $8355,  param
                  .ENDM
EORIopEzpx          .MACRO param          
                  .BYTE $9055,  param
                  .ENDM
EORIopFzpx          .MACRO param
                  .BYTE $9155,  param
                  .ENDM
EORIopGzpx          .MACRO param
                  .BYTE $9255,  param
                  .ENDM                  
EORIopHzpx          .MACRO param          
                  .BYTE $9355,  param
                  .ENDM
EORIopIzpx          .MACRO param
                  .BYTE $A055,  param
                  .ENDM
EORIopJzpx          .MACRO param
                  .BYTE $A155,  param
                  .ENDM
EORIopKzpx          .MACRO param          
                  .BYTE $A255,  param
                  .ENDM
EORIopLzpx          .MACRO param
                  .BYTE $A355,  param
                  .ENDM
EORIopMzpx          .MACRO param
                  .BYTE $B055,  param
                  .ENDM                  
EORIopNzpx          .MACRO param          
                  .BYTE $B155,  param
                  .ENDM
EORIopOzpx          .MACRO param
                  .BYTE $B255,  param
                  .ENDM
EORIopQzpx          .MACRO param
                  .BYTE $B355,  param
                  .ENDM
                  
EORJopAzpx          .MACRO param
                  .BYTE $8455,  param
                  .ENDM                
EORJopBzpx          .MACRO param          
                  .BYTE $8555,  param
                  .ENDM
EORJopCzpx          .MACRO param
                  .BYTE $8655,  param
                  .ENDM
EORJopDzpx          .MACRO param
                  .BYTE $8755,  param
                  .ENDM
EORJopEzpx          .MACRO param          
                  .BYTE $9455,  param
                  .ENDM
EORJopFzpx          .MACRO param
                  .BYTE $9555,  param
                  .ENDM
EORJopGzpx          .MACRO param
                  .BYTE $9655,  param
                  .ENDM                  
EORJopHzpx          .MACRO param          
                  .BYTE $9755,  param
                  .ENDM
EORJopIzpx          .MACRO param
                  .BYTE $A455,  param
                  .ENDM
EORJopJzpx          .MACRO param
                  .BYTE $A555,  param
                  .ENDM
EORJopKzpx          .MACRO param          
                  .BYTE $A655,  param
                  .ENDM
EORJopLzpx          .MACRO param
                  .BYTE $A755,  param
                  .ENDM
EORJopMzpx          .MACRO param
                  .BYTE $B455,  param
                  .ENDM                  
EORJopNzpx          .MACRO param          
                  .BYTE $B555,  param
                  .ENDM
EORJopOzpx          .MACRO param
                  .BYTE $B655,  param
                  .ENDM
EORJopQzpx          .MACRO param
                  .BYTE $B755,  param
                  .ENDM
                  
EORKopAzpx          .MACRO param
                  .BYTE $8855,  param
                  .ENDM                
EORKopBzpx          .MACRO param          
                  .BYTE $8955,  param
                  .ENDM
EORKopCzpx          .MACRO param
                  .BYTE $8A55,  param
                  .ENDM
EORKopDzpx          .MACRO param
                  .BYTE $8B55,  param
                  .ENDM
EORKopEzpx          .MACRO param          
                  .BYTE $9855,  param
                  .ENDM
EORKopFzpx          .MACRO param
                  .BYTE $9955,  param
                  .ENDM
EORKopGzpx          .MACRO param
                  .BYTE $9A55,  param
                  .ENDM                  
EORKopHzpx          .MACRO param          
                  .BYTE $9B55,  param
                  .ENDM
EORKopIzpx          .MACRO param
                  .BYTE $A855,  param
                  .ENDM
EORKopJzpx          .MACRO param
                  .BYTE $A955,  param
                  .ENDM
EORKopKzpx          .MACRO param          
                  .BYTE $AA55,  param
                  .ENDM
EORKopLzpx          .MACRO param
                  .BYTE $AB55,  param
                  .ENDM
EORKopMzpx          .MACRO param
                  .BYTE $B855,  param
                  .ENDM                  
EORKopNzpx          .MACRO param          
                  .BYTE $B955,  param
                  .ENDM
EORKopOzpx          .MACRO param
                  .BYTE $BA55,  param
                  .ENDM
EORKopQzpx          .MACRO param
                  .BYTE $BB55,  param
                  .ENDM
                  
EORLopAzpx          .MACRO param
                  .BYTE $8C55,  param
                  .ENDM                
EORLopBzpx          .MACRO param          
                  .BYTE $8D55,  param
                  .ENDM
EORLopCzpx          .MACRO param
                  .BYTE $8E55,  param
                  .ENDM
EORLopDzpx          .MACRO param
                  .BYTE $8F55,  param
                  .ENDM
EORLopEzpx          .MACRO param          
                  .BYTE $9C55,  param
                  .ENDM
EORLopFzpx          .MACRO param
                  .BYTE $9D55,  param
                  .ENDM
EORLopGzpx          .MACRO param
                  .BYTE $9E55,  param
                  .ENDM                  
EORLopHzpx          .MACRO param          
                  .BYTE $9F55,  param
                  .ENDM
EORLopIzpx          .MACRO param
                  .BYTE $AC55,  param
                  .ENDM
EORLopJzpx          .MACRO param
                  .BYTE $AD55,  param
                  .ENDM
EORLopKzpx          .MACRO param          
                  .BYTE $AE55,  param
                  .ENDM
EORLopLzpx          .MACRO param
                  .BYTE $AF55,  param
                  .ENDM
EORLopMzpx          .MACRO param
                  .BYTE $BC55,  param
                  .ENDM                  
EORLopNzpx          .MACRO param          
                  .BYTE $BD55,  param
                  .ENDM
EORLopOzpx          .MACRO param
                  .BYTE $BE55,  param
                  .ENDM
EORLopQzpx          .MACRO param
                  .BYTE $BF55,  param
                  .ENDM
                  
EORMopAzpx          .MACRO param
                  .BYTE $C055,  param
                  .ENDM                
EORMopBzpx          .MACRO param          
                  .BYTE $C155,  param
                  .ENDM
EORMopCzpx          .MACRO param
                  .BYTE $C255,  param
                  .ENDM
EORMopDzpx          .MACRO param
                  .BYTE $C355,  param
                  .ENDM
EORMopEzpx          .MACRO param          
                  .BYTE $D055,  param
                  .ENDM
EORMopFzpx          .MACRO param
                  .BYTE $D155,  param
                  .ENDM
EORMopGzpx          .MACRO param
                  .BYTE $D255,  param
                  .ENDM                  
EORMopHzpx          .MACRO param          
                  .BYTE $D355,  param
                  .ENDM
EORMopIzpx          .MACRO param
                  .BYTE $E055,  param
                  .ENDM
EORMopJzpx          .MACRO param
                  .BYTE $E155,  param
                  .ENDM
EORMopKzpx          .MACRO param          
                  .BYTE $E255,  param
                  .ENDM
EORMopLzpx          .MACRO param
                  .BYTE $E355,  param
                  .ENDM
EORMopMzpx          .MACRO param
                  .BYTE $F055,  param
                  .ENDM                  
EORMopNzpx          .MACRO param          
                  .BYTE $F155,  param
                  .ENDM
EORMopOzpx          .MACRO param
                  .BYTE $F255,  param
                  .ENDM
EORMopQzpx          .MACRO param
                  .BYTE $F355,  param
                  .ENDM
                  
EORNopAzpx          .MACRO param
                  .BYTE $C455,  param
                  .ENDM                
EORNopBzpx          .MACRO param          
                  .BYTE $C555,  param
                  .ENDM
EORNopCzpx          .MACRO param
                  .BYTE $C655,  param
                  .ENDM
EORNopDzpx          .MACRO param
                  .BYTE $C755,  param
                  .ENDM
EORNopEzpx          .MACRO param          
                  .BYTE $D455,  param
                  .ENDM
EORNopFzpx          .MACRO param
                  .BYTE $D555,  param
                  .ENDM
EORNopGzpx          .MACRO param
                  .BYTE $D655,  param
                  .ENDM                  
EORNopHzpx          .MACRO param          
                  .BYTE $D755,  param
                  .ENDM
EORNopIzpx          .MACRO param
                  .BYTE $E455,  param
                  .ENDM
EORNopJzpx          .MACRO param
                  .BYTE $E555,  param
                  .ENDM
EORNopKzpx          .MACRO param          
                  .BYTE $E655,  param
                  .ENDM
EORNopLzpx          .MACRO param
                  .BYTE $E755,  param
                  .ENDM
EORNopMzpx          .MACRO param
                  .BYTE $F455,  param
                  .ENDM                  
EORNopNzpx          .MACRO param          
                  .BYTE $F555,  param
                  .ENDM
EORNopOzpx          .MACRO param
                  .BYTE $F655,  param
                  .ENDM
EORNopQzpx          .MACRO param
                  .BYTE $F755,  param
                  .ENDM
            
EOROopAzpx          .MACRO param
                  .BYTE $C855,  param
                  .ENDM                
EOROopBzpx          .MACRO param          
                  .BYTE $C955,  param
                  .ENDM
EOROopCzpx          .MACRO param
                  .BYTE $CA55,  param
                  .ENDM
EOROopDzpx          .MACRO param
                  .BYTE $CB55,  param
                  .ENDM
EOROopEzpx          .MACRO param          
                  .BYTE $D855,  param
                  .ENDM
EOROopFzpx          .MACRO param
                  .BYTE $D955,  param
                  .ENDM
EOROopGzpx          .MACRO param
                  .BYTE $DA55,  param
                  .ENDM                  
EOROopHzpx          .MACRO param          
                  .BYTE $DB55,  param
                  .ENDM
EOROopIzpx          .MACRO param
                  .BYTE $E855,  param
                  .ENDM
EOROopJzpx          .MACRO param
                  .BYTE $E955,  param
                  .ENDM
EOROopKzpx          .MACRO param          
                  .BYTE $EA55,  param
                  .ENDM
EOROopLzpx          .MACRO param
                  .BYTE $EB55,  param
                  .ENDM
EOROopMzpx          .MACRO param
                  .BYTE $F855,  param
                  .ENDM                  
EOROopNzpx          .MACRO param          
                  .BYTE $F955,  param
                  .ENDM
EOROopOzpx          .MACRO param
                  .BYTE $FA55,  param
                  .ENDM
EOROopQzpx          .MACRO param
                  .BYTE $FB55,  param
                  .ENDM
                  
EORQopAzpx          .MACRO param
                  .BYTE $CC55,  param
                  .ENDM                
EORQopBzpx          .MACRO param          
                  .BYTE $CD55,  param
                  .ENDM
EORQopCzpx          .MACRO param
                  .BYTE $CE55,  param
                  .ENDM
EORQopDzpx          .MACRO param
                  .BYTE $CF55,  param
                  .ENDM
EORQopEzpx          .MACRO param          
                  .BYTE $DC55,  param
                  .ENDM
EORQopFzpx          .MACRO param
                  .BYTE $DD55,  param
                  .ENDM
EORQopGzpx          .MACRO param
                  .BYTE $DE55,  param
                  .ENDM                  
EORQopHzpx          .MACRO param          
                  .BYTE $DF55,  param
                  .ENDM
EORQopIzpx          .MACRO param
                  .BYTE $EC55,  param
                  .ENDM
EORQopJzpx          .MACRO param
                  .BYTE $ED55,  param
                  .ENDM
EORQopKzpx          .MACRO param          
                  .BYTE $EE55,  param
                  .ENDM
EORQopLzpx          .MACRO param
                  .BYTE $EF55,  param
                  .ENDM
EORQopMzpx          .MACRO param
                  .BYTE $FC55,  param
                  .ENDM                  
EORQopNzpx          .MACRO param          
                  .BYTE $FD55,  param
                  .ENDM
EORQopOzpx          .MACRO param
                  .BYTE $FE55,  param
                  .ENDM
EORQopQzpx          .MACRO param
                  .BYTE $FF55,  param
                  .ENDM

;ADC $xxxxxxxx          $006D
ADCAopBa          .MACRO param          
                  .BYTE $016D
		  .WORD  param
                  .ENDM
ADCAopCa          .MACRO param
                  .BYTE $026D
		  .WORD  param
                  .ENDM
ADCAopDa          .MACRO param
                  .BYTE $036D
		  .WORD  param
                  .ENDM
ADCAopEa          .MACRO param          
                  .BYTE $106D
		  .WORD  param
                  .ENDM
ADCAopFa          .MACRO param
                  .BYTE $116D
		  .WORD  param
                  .ENDM
ADCAopGa          .MACRO param
                  .BYTE $126D
		  .WORD  param
                  .ENDM                  
ADCAopHa          .MACRO param          
                  .BYTE $136D
		  .WORD  param
                  .ENDM
ADCAopIa          .MACRO param
                  .BYTE $206D
		  .WORD  param
                  .ENDM
ADCAopJa          .MACRO param
                  .BYTE $216D
		  .WORD  param
                  .ENDM
ADCAopKa          .MACRO param          
                  .BYTE $226D
		  .WORD  param
                  .ENDM
ADCAopLa          .MACRO param
                  .BYTE $236D
		  .WORD  param
                  .ENDM
ADCAopMa          .MACRO param
                  .BYTE $306D
		  .WORD  param
                  .ENDM                  
ADCAopNa          .MACRO param          
                  .BYTE $316D
		  .WORD  param
                  .ENDM
ADCAopOa          .MACRO param
                  .BYTE $326D
		  .WORD  param
                  .ENDM
ADCAopQa          .MACRO param
                  .BYTE $336D
		  .WORD  param
                  .ENDM
                                    
ADCBopAa          .MACRO param
                  .BYTE $046D
		  .WORD  param
                  .ENDM                
ADCBopBa          .MACRO param          
                  .BYTE $056D
		  .WORD  param
                  .ENDM
ADCBopCa          .MACRO param
                  .BYTE $066D
		  .WORD  param
                  .ENDM
ADCBopDa          .MACRO param
                  .BYTE $076D
		  .WORD  param
                  .ENDM
ADCBopEa          .MACRO param          
                  .BYTE $146D
		  .WORD  param
                  .ENDM
ADCBopFa          .MACRO param
                  .BYTE $156D
		  .WORD  param
                  .ENDM
ADCBopGa          .MACRO param
                  .BYTE $166D
		  .WORD  param
                  .ENDM                  
ADCBopHa          .MACRO param          
                  .BYTE $176D
		  .WORD  param
                  .ENDM
ADCBopIa          .MACRO param
                  .BYTE $246D
		  .WORD  param
                  .ENDM
ADCBopJa          .MACRO param
                  .BYTE $256D
		  .WORD  param
                  .ENDM
ADCBopKa          .MACRO param          
                  .BYTE $266D
		  .WORD  param
                  .ENDM
ADCBopLa          .MACRO param
                  .BYTE $276D
		  .WORD  param
                  .ENDM
ADCBopMa          .MACRO param
                  .BYTE $306D
		  .WORD  param
                  .ENDM                  
ADCBopNa          .MACRO param          
                  .BYTE $316D
		  .WORD  param
                  .ENDM
ADCBopOa          .MACRO param
                  .BYTE $326D
		  .WORD  param
                  .ENDM
ADCBopQa          .MACRO param
                  .BYTE $336D
		  .WORD  param
                  .ENDM
                                    
ADCCopAa          .MACRO param
                  .BYTE $086D
		  .WORD  param
                  .ENDM                
ADCCopBa          .MACRO param          
                  .BYTE $096D
		  .WORD  param
                  .ENDM
ADCCopCa          .MACRO param
                  .BYTE $0A6D
		  .WORD  param
                  .ENDM
ADCCopDa          .MACRO param
                  .BYTE $0B6D
		  .WORD  param
                  .ENDM
ADCCopEa          .MACRO param          
                  .BYTE $186D
		  .WORD  param
                  .ENDM
ADCCopFa          .MACRO param
                  .BYTE $196D
		  .WORD  param
                  .ENDM
ADCCopGa          .MACRO param
                  .BYTE $1A6D
		  .WORD  param
                  .ENDM                  
ADCCopHa          .MACRO param          
                  .BYTE $1B6D
		  .WORD  param
                  .ENDM
ADCCopIa          .MACRO param
                  .BYTE $286D
		  .WORD  param
                  .ENDM
ADCCopJa          .MACRO param
                  .BYTE $296D
		  .WORD  param
                  .ENDM
ADCCopKa          .MACRO param          
                  .BYTE $2A6D
		  .WORD  param
                  .ENDM
ADCCopLa          .MACRO param
                  .BYTE $2B6D
		  .WORD  param
                  .ENDM
ADCCopMa          .MACRO param
                  .BYTE $386D
		  .WORD  param
                  .ENDM                  
ADCCopNa          .MACRO param          
                  .BYTE $396D
	 	  .WORD  param
                  .ENDM
ADCCopOa          .MACRO param
                  .BYTE $3A6D
		  .WORD  param
                  .ENDM
ADCCopQa          .MACRO param
                  .BYTE $3B6D
		  .WORD  param
                  .ENDM

ADCDopAa          .MACRO param
                  .BYTE $0C6D
		  .WORD  param
                  .ENDM                
ADCDopBa          .MACRO param          
                  .BYTE $0D6D
		  .WORD  param
                  .ENDM
ADCDopCa          .MACRO param
                  .BYTE $0E6D
		  .WORD  param
                  .ENDM
ADCDopDa          .MACRO param
                  .BYTE $0F6D
		  .WORD  param
                  .ENDM
ADCDopEa          .MACRO param          
                  .BYTE $1C6D
		  .WORD  param
                  .ENDM
ADCDopFa          .MACRO param
                  .BYTE $1D6D
		  .WORD  param
                  .ENDM
ADCDopGa          .MACRO param
                  .BYTE $1E6D
		  .WORD  param
                  .ENDM                  
ADCDopHa          .MACRO param          
                  .BYTE $1F6D
		  .WORD  param
                  .ENDM
ADCDopIa          .MACRO param
                  .BYTE $2C6D
		  .WORD  param
                  .ENDM
ADCDopJa          .MACRO param
                  .BYTE $2D6D
		  .WORD  param
                  .ENDM
ADCDopKa          .MACRO param          
                  .BYTE $2E6D
		  .WORD  param
                  .ENDM
ADCDopLa          .MACRO param
                  .BYTE $2F6D
		  .WORD  param
                  .ENDM
ADCDopMa          .MACRO param
                  .BYTE $3C6D
		  .WORD  param
                  .ENDM                  
ADCDopNa          .MACRO param          
                  .BYTE $3D6D
		  .WORD  param
                  .ENDM
ADCDopOa          .MACRO param
                  .BYTE $3E6D
		  .WORD  param
                  .ENDM
ADCDopQa          .MACRO param
                  .BYTE $3F6D
		  .WORD  param
                  .ENDM                  

ADCEopAa          .MACRO param
                  .BYTE $406D
		  .WORD  param
                  .ENDM                
ADCEopBa          .MACRO param          
                  .BYTE $416D
		  .WORD  param
                  .ENDM
ADCEopCa          .MACRO param
                  .BYTE $426D
		  .WORD  param
                  .ENDM
ADCEopDa          .MACRO param
                  .BYTE $436D
		  .WORD  param
                  .ENDM
ADCEopEa          .MACRO param          
                  .BYTE $506D
		  .WORD  param
                  .ENDM
ADCEopFa          .MACRO param
                  .BYTE $516D
		  .WORD  param
                  .ENDM
ADCEopGa          .MACRO param
                  .BYTE $526D
		  .WORD  param
                  .ENDM                  
ADCEopHa          .MACRO param          
                  .BYTE $536D
		  .WORD  param
                  .ENDM
ADCEopIa          .MACRO param
                  .BYTE $606D
		  .WORD  param
                  .ENDM
ADCEopJa          .MACRO param
                  .BYTE $616D
		  .WORD  param
                  .ENDM
ADCEopKa          .MACRO param          
                  .BYTE $626D
		  .WORD  param
                  .ENDM
ADCEopLa          .MACRO param
                  .BYTE $636D
		  .WORD  param
                  .ENDM
ADCEopMa          .MACRO param
                  .BYTE $706D
		  .WORD  param
                  .ENDM                  
ADCEopNa          .MACRO param          
                  .BYTE $716D
		  .WORD  param
                  .ENDM
ADCEopOa          .MACRO param
                  .BYTE $726D
		  .WORD  param
                  .ENDM
ADCEopQa          .MACRO param
                  .BYTE $736D
		  .WORD  param
                  .ENDM
                  
ADCFopAa          .MACRO param
                  .BYTE $446D
		  .WORD  param
                  .ENDM                
ADCFopBa          .MACRO param          
                  .BYTE $456D
		  .WORD  param
                  .ENDM
ADCFopCa          .MACRO param
                  .BYTE $466D
		  .WORD  param
                  .ENDM
ADCFopDa          .MACRO param
                  .BYTE $476D
		  .WORD  param
                  .ENDM
ADCFopEa          .MACRO param          
                  .BYTE $546D
		  .WORD  param
                  .ENDM
ADCFopFa          .MACRO param
                  .BYTE $556D
		  .WORD  param
                  .ENDM
ADCFopGa          .MACRO param
                  .BYTE $566D
		  .WORD  param
                  .ENDM                  
ADCFopHa          .MACRO param          
                  .BYTE $576D
		  .WORD  param
                  .ENDM
ADCFopIa          .MACRO param
                  .BYTE $646D
	 	  .WORD  param
                  .ENDM
ADCFopJa          .MACRO param
                  .BYTE $656D
		  .WORD  param
                  .ENDM
ADCFopKa          .MACRO param          
                  .BYTE $666D
		  .WORD  param
                  .ENDM
ADCFopLa          .MACRO param
                  .BYTE $676D
		  .WORD  param
                  .ENDM
ADCFopMa          .MACRO param
                  .BYTE $746D
		  .WORD  param
                  .ENDM                  
ADCFopNa          .MACRO param          
                  .BYTE $756D
		  .WORD  param
                  .ENDM
ADCFopOa          .MACRO param
                  .BYTE $766D
		  .WORD  param
                  .ENDM
ADCFopQa          .MACRO param
                  .BYTE $776D
		  .WORD  param
                  .ENDM                  
                           
ADCGopAa          .MACRO param
                  .BYTE $486D
		  .WORD  param
                  .ENDM                
ADCGopBa          .MACRO param          
                  .BYTE $496D
		  .WORD  param
                  .ENDM
ADCGopCa          .MACRO param
                  .BYTE $4A6D
		  .WORD  param
                  .ENDM
ADCGopDa          .MACRO param
                  .BYTE $4B6D
		  .WORD  param
                  .ENDM
ADCGopEa          .MACRO param          
                  .BYTE $586D
		  .WORD  param
                  .ENDM
ADCGopFa          .MACRO param
                  .BYTE $596D
		  .WORD  param
                  .ENDM
ADCGopGa          .MACRO param
                  .BYTE $5A6D
		  .WORD  param
                  .ENDM                  
ADCGopHa          .MACRO param          
                  .BYTE $5B6D
		  .WORD  param
                  .ENDM
ADCGopIa          .MACRO param
                  .BYTE $686D
		  .WORD  param
                  .ENDM
ADCGopJa          .MACRO param
                  .BYTE $696D
		  .WORD  param
                  .ENDM
ADCGopKa          .MACRO param          
                  .BYTE $6A6D
		  .WORD  param
                  .ENDM
ADCGopLa          .MACRO param
                  .BYTE $6B6D
		  .WORD  param
                  .ENDM
ADCGopMa          .MACRO param
                  .BYTE $786D
		  .WORD  param
                  .ENDM                  
ADCGopNa          .MACRO param          
                  .BYTE $796D
		  .WORD  param
                  .ENDM
ADCGopOa          .MACRO param
                  .BYTE $7A6D
		  .WORD  param
                  .ENDM
ADCGopQa          .MACRO param
                  .BYTE $7B6D
		  .WORD  param
                  .ENDM
                  
ADCHopAa          .MACRO param
                  .BYTE $4C6D
		  .WORD  param
                  .ENDM                
ADCHopBa          .MACRO param          
                  .BYTE $4D6D
		  .WORD  param
                  .ENDM
ADCHopCa          .MACRO param
                  .BYTE $4E6D
		  .WORD  param
                  .ENDM
ADCHopDa          .MACRO param
                  .BYTE $4F6D
		  .WORD  param
                  .ENDM
ADCHopEa          .MACRO param          
                  .BYTE $5C6D
		  .WORD  param
                  .ENDM
ADCHopFa          .MACRO param
                  .BYTE $5D6D
		  .WORD  param
                  .ENDM
ADCHopGa          .MACRO param
                  .BYTE $5E6D
		  .WORD  param
                  .ENDM                  
ADCHopHa          .MACRO param          
                  .BYTE $5F6D
		  .WORD  param
                  .ENDM
ADCHopIa          .MACRO param
                  .BYTE $6C6D
		  .WORD  param
                  .ENDM
ADCHopJa          .MACRO param
                  .BYTE $6D6D
		  .WORD  param
                  .ENDM
ADCHopKa          .MACRO param          
                  .BYTE $6E6D
		  .WORD  param
                  .ENDM
ADCHopLa          .MACRO param
                  .BYTE $6F6D
		  .WORD  param
                  .ENDM
ADCHopMa          .MACRO param
                  .BYTE $7C6D
		  .WORD  param
                  .ENDM                  
ADCHopNa          .MACRO param          
                  .BYTE $7D6D
		  .WORD  param
                  .ENDM
ADCHopOa          .MACRO param
                  .BYTE $7E6D
		  .WORD  param
                  .ENDM
ADCHopQa          .MACRO param
                  .BYTE $7F6D
		  .WORD  param
                  .ENDM
                  
ADCIopAa          .MACRO param
                  .BYTE $806D
		  .WORD  param
                  .ENDM                
ADCIopBa          .MACRO param          
                  .BYTE $816D
		  .WORD  param
                  .ENDM
ADCIopCa          .MACRO param
                  .BYTE $826D
		  .WORD  param
                  .ENDM
ADCIopDa          .MACRO param
                  .BYTE $836D
		  .WORD  param
                  .ENDM
ADCIopEa          .MACRO param          
                  .BYTE $906D
		  .WORD  param
                  .ENDM
ADCIopFa          .MACRO param
                  .BYTE $916D
		  .WORD  param
                  .ENDM
ADCIopGa          .MACRO param
                  .BYTE $926D
		  .WORD  param
                  .ENDM                  
ADCIopHa          .MACRO param          
                  .BYTE $936D
		  .WORD  param
                  .ENDM
ADCIopIa          .MACRO param
                  .BYTE $A06D
		  .WORD  param
                  .ENDM
ADCIopJa          .MACRO param
                  .BYTE $A16D
		  .WORD  param
                  .ENDM
ADCIopKa          .MACRO param          
                  .BYTE $A26D
		  .WORD  param
                  .ENDM
ADCIopLa          .MACRO param
                  .BYTE $A36D
		  .WORD  param
                  .ENDM
ADCIopMa          .MACRO param
                  .BYTE $B06D
		  .WORD  param
                  .ENDM                  
ADCIopNa          .MACRO param          
                  .BYTE $B16D
		  .WORD  param
                  .ENDM
ADCIopOa          .MACRO param
                  .BYTE $B26D
		  .WORD  param
                  .ENDM
ADCIopQa          .MACRO param
                  .BYTE $B36D
		  .WORD  param
                  .ENDM
                  
ADCJopAa          .MACRO param
                  .BYTE $846D
		  .WORD  param
                  .ENDM                
ADCJopBa          .MACRO param          
                  .BYTE $856D
		  .WORD  param
                  .ENDM
ADCJopCa          .MACRO param
                  .BYTE $866D
		  .WORD  param
                  .ENDM
ADCJopDa          .MACRO param
                  .BYTE $876D
		  .WORD  param
                  .ENDM
ADCJopEa          .MACRO param          
                  .BYTE $946D
		  .WORD  param
                  .ENDM
ADCJopFa          .MACRO param
                  .BYTE $956D
		  .WORD  param
                  .ENDM
ADCJopGa          .MACRO param
                  .BYTE $966D
		  .WORD  param
                  .ENDM                  
ADCJopHa          .MACRO param          
                  .BYTE $976D
		  .WORD  param
                  .ENDM
ADCJopIa          .MACRO param
                  .BYTE $A46D
		  .WORD  param
                  .ENDM
ADCJopJa          .MACRO param
                  .BYTE $A56D
		  .WORD  param
                  .ENDM
ADCJopKa          .MACRO param          
                  .BYTE $A66D
 		  .WORD  param
                  .ENDM
ADCJopLa          .MACRO param
                  .BYTE $A76D
		  .WORD  param
                  .ENDM
ADCJopMa          .MACRO param
                  .BYTE $B46D
		  .WORD  param
                  .ENDM                  
ADCJopNa          .MACRO param          
                  .BYTE $B56D
		  .WORD  param
                  .ENDM
ADCJopOa          .MACRO param
                  .BYTE $B66D
		  .WORD  param
                  .ENDM
ADCJopQa          .MACRO param
                  .BYTE $B76D
		  .WORD  param
                  .ENDM
                  
ADCKopAa          .MACRO param
                  .BYTE $886D
		  .WORD  param
                  .ENDM                
ADCKopBa          .MACRO param          
                  .BYTE $896D
		  .WORD  param
                  .ENDM
ADCKopCa          .MACRO param
                  .BYTE $8A6D
		  .WORD  param
                  .ENDM
ADCKopDa          .MACRO param
                  .BYTE $8B6D
		  .WORD  param
                  .ENDM
ADCKopEa          .MACRO param          
                  .BYTE $986D
		  .WORD  param
                  .ENDM
ADCKopFa          .MACRO param
                  .BYTE $996D
		  .WORD  param
                  .ENDM
ADCKopGa          .MACRO param
                  .BYTE $9A6D
		  .WORD  param
                  .ENDM                  
ADCKopHa          .MACRO param          
                  .BYTE $9B6D
		  .WORD  param
                  .ENDM
ADCKopIa          .MACRO param
                  .BYTE $A86D
		  .WORD  param
                  .ENDM
ADCKopJa          .MACRO param
                  .BYTE $A96D
		  .WORD  param
                  .ENDM
ADCKopKa          .MACRO param          
                  .BYTE $AA6D
		  .WORD  param
                  .ENDM
ADCKopLa          .MACRO param
                  .BYTE $AB6D
		  .WORD  param
                  .ENDM
ADCKopMa          .MACRO param
                  .BYTE $B86D
		  .WORD  param
                  .ENDM                  
ADCKopNa          .MACRO param          
                  .BYTE $B96D
		  .WORD  param
                  .ENDM
ADCKopOa          .MACRO param
                  .BYTE $BA6D
		  .WORD  param
                  .ENDM
ADCKopQa          .MACRO param
                  .BYTE $BB6D
		  .WORD  param
                  .ENDM
                  
ADCLopAa          .MACRO param
                  .BYTE $8C6D
		  .WORD  param
                  .ENDM                
ADCLopBa          .MACRO param          
                  .BYTE $8D6D
		  .WORD  param
                  .ENDM
ADCLopCa          .MACRO param
                  .BYTE $8E6D
		  .WORD  param
                  .ENDM
ADCLopDa          .MACRO param
                  .BYTE $8F6D
		  .WORD  param
                  .ENDM
ADCLopEa          .MACRO param          
                  .BYTE $9C6D
		  .WORD  param
                  .ENDM
ADCLopFa          .MACRO param
                  .BYTE $9D6D
		  .WORD  param
                  .ENDM
ADCLopGa          .MACRO param
                  .BYTE $9E6D
		  .WORD  param
                  .ENDM                  
ADCLopHa          .MACRO param          
                  .BYTE $9F6D
		  .WORD  param
                  .ENDM
ADCLopIa          .MACRO param
                  .BYTE $AC6D
		  .WORD  param
                  .ENDM
ADCLopJa          .MACRO param
                  .BYTE $AD6D
		  .WORD  param
                  .ENDM
ADCLopKa          .MACRO param          
                  .BYTE $AE6D
		  .WORD  param
                  .ENDM
ADCLopLa          .MACRO param
                  .BYTE $AF6D
		  .WORD  param
                  .ENDM
ADCLopMa          .MACRO param
                  .BYTE $BC6D
		  .WORD  param
                  .ENDM                  
ADCLopNa          .MACRO param          
                  .BYTE $BD6D
		  .WORD  param
                  .ENDM
ADCLopOa          .MACRO param
                  .BYTE $BE6D
		  .WORD  param
                  .ENDM
ADCLopQa          .MACRO param
                  .BYTE $BF6D
		  .WORD  param
                  .ENDM
                  
ADCMopAa          .MACRO param
                  .BYTE $C06D
		  .WORD  param
                  .ENDM                
ADCMopBa          .MACRO param          
                  .BYTE $C16D
		  .WORD  param
                  .ENDM
ADCMopCa          .MACRO param
                  .BYTE $C26D
		  .WORD  param
                  .ENDM
ADCMopDa          .MACRO param
                  .BYTE $C36D
		  .WORD  param
                  .ENDM
ADCMopEa          .MACRO param          
                  .BYTE $D06D
		  .WORD  param
                  .ENDM
ADCMopFa          .MACRO param
                  .BYTE $D16D
		  .WORD  param
                  .ENDM
ADCMopGa          .MACRO param
                  .BYTE $D26D
		  .WORD  param
                  .ENDM                  
ADCMopHa          .MACRO param          
                  .BYTE $D36D
		  .WORD  param
                  .ENDM
ADCMopIa          .MACRO param
                  .BYTE $E06D
		  .WORD  param
                  .ENDM
ADCMopJa          .MACRO param
                  .BYTE $E16D
		  .WORD  param
                  .ENDM
ADCMopKa          .MACRO param          
                  .BYTE $E26D
		  .WORD  param
                  .ENDM
ADCMopLa          .MACRO param
                  .BYTE $E36D
		  .WORD  param
                  .ENDM
ADCMopMa          .MACRO param
                  .BYTE $F06D
		  .WORD  param
                  .ENDM                  
ADCMopNa          .MACRO param          
                  .BYTE $F16D
		  .WORD  param
                  .ENDM
ADCMopOa          .MACRO param
                  .BYTE $F26D
		  .WORD  param
                  .ENDM
ADCMopQa          .MACRO param
                  .BYTE $F36D
		  .WORD  param
                  .ENDM
                  
ADCNopAa          .MACRO param
                  .BYTE $C46D
		  .WORD  param
                  .ENDM                
ADCNopBa          .MACRO param          
                  .BYTE $C56D
		  .WORD  param
                  .ENDM
ADCNopCa          .MACRO param
                  .BYTE $C66D
		  .WORD  param
                  .ENDM
ADCNopDa          .MACRO param
                  .BYTE $C76D
		  .WORD  param
                  .ENDM
ADCNopEa          .MACRO param          
                  .BYTE $D46D
		  .WORD  param
                  .ENDM
ADCNopFa          .MACRO param
                  .BYTE $D56D
		  .WORD  param
                  .ENDM
ADCNopGa          .MACRO param
                  .BYTE $D66D
		  .WORD  param
                  .ENDM                  
ADCNopHa          .MACRO param          
                  .BYTE $D76D
		  .WORD  param
                  .ENDM
ADCNopIa          .MACRO param
                  .BYTE $E46D
		  .WORD  param
                  .ENDM
ADCNopJa          .MACRO param
                  .BYTE $E56D
		  .WORD  param
                  .ENDM
ADCNopKa          .MACRO param          
                  .BYTE $E66D
		  .WORD  param
                  .ENDM
ADCNopLa          .MACRO param
                  .BYTE $E76D
		  .WORD  param
                  .ENDM
ADCNopMa          .MACRO param
                  .BYTE $F46D
		  .WORD  param
                  .ENDM                  
ADCNopNa          .MACRO param          
                  .BYTE $F56D
		  .WORD  param
                  .ENDM
ADCNopOa          .MACRO param
                  .BYTE $F66D
		  .WORD  param
                  .ENDM
ADCNopQa          .MACRO param
                  .BYTE $F76D
		  .WORD  param
                  .ENDM
            
ADCOopAa          .MACRO param
                  .BYTE $C86D
		  .WORD  param
                  .ENDM                
ADCOopBa          .MACRO param          
                  .BYTE $C96D
		  .WORD  param
                  .ENDM
ADCOopCa          .MACRO param
                  .BYTE $CA6D
		  .WORD  param
                  .ENDM
ADCOopDa          .MACRO param
                  .BYTE $CB6D
		  .WORD  param
                  .ENDM
ADCOopEa          .MACRO param          
                  .BYTE $D86D
		  .WORD  param
                  .ENDM
ADCOopFa          .MACRO param
                  .BYTE $D96D
		  .WORD  param
                  .ENDM
ADCOopGa          .MACRO param
                  .BYTE $DA6D
		  .WORD  param
                  .ENDM                  
ADCOopHa          .MACRO param          
                  .BYTE $DB6D
		  .WORD  param
                  .ENDM
ADCOopIa          .MACRO param
                  .BYTE $E86D
		  .WORD  param
                  .ENDM
ADCOopJa          .MACRO param
                  .BYTE $E96D
		  .WORD  param
                  .ENDM
ADCOopKa          .MACRO param          
                  .BYTE $EA6D
		  .WORD  param
                  .ENDM
ADCOopLa          .MACRO param
                  .BYTE $EB6D
		  .WORD  param
                  .ENDM
ADCOopMa          .MACRO param
                  .BYTE $F86D
		  .WORD  param
                  .ENDM                  
ADCOopNa          .MACRO param          
                  .BYTE $F96D
		  .WORD  param
                  .ENDM
ADCOopOa          .MACRO param
                  .BYTE $FA6D
		  .WORD  param
                  .ENDM
ADCOopQa          .MACRO param
                  .BYTE $FB6D
		  .WORD  param
                  .ENDM
                  
ADCQopAa          .MACRO param
                  .BYTE $CC6D
		  .WORD  param
                  .ENDM                
ADCQopBa          .MACRO param          
                  .BYTE $CD6D
		  .WORD  param
                  .ENDM
ADCQopCa          .MACRO param
                  .BYTE $CE6D
		  .WORD  param
                  .ENDM
ADCQopDa          .MACRO param
                  .BYTE $CF6D
		  .WORD  param
                  .ENDM
ADCQopEa          .MACRO param          
                  .BYTE $DC6D
		  .WORD  param
                  .ENDM
ADCQopFa          .MACRO param
                  .BYTE $DD6D
		  .WORD  param
                  .ENDM
ADCQopGa          .MACRO param
                  .BYTE $DE6D
		  .WORD  param
                  .ENDM                  
ADCQopHa          .MACRO param          
                  .BYTE $DF6D
		  .WORD  param
                  .ENDM
ADCQopIa          .MACRO param
                  .BYTE $EC6D
		  .WORD  param
                  .ENDM
ADCQopJa          .MACRO param
                  .BYTE $ED6D
		  .WORD  param
                  .ENDM
ADCQopKa          .MACRO param          
                  .BYTE $EE6D
		  .WORD  param
                  .ENDM
ADCQopLa          .MACRO param
                  .BYTE $EF6D
		  .WORD  param
                  .ENDM
ADCQopMa          .MACRO param
                  .BYTE $FC6D
		  .WORD  param
                  .ENDM                  
ADCQopNa          .MACRO param          
                  .BYTE $FD6D
		  .WORD  param
                  .ENDM
ADCQopOa          .MACRO param
                  .BYTE $FE6D
		  .WORD  param
                  .ENDM
ADCQopQa          .MACRO param
                  .BYTE $FF6D
		  .WORD  param
                  .ENDM

;SBC $xxxxxxxx          $00ED
SBCAopBa          .MACRO param          
                  .BYTE $01ED
		  .WORD  param
                  .ENDM
SBCAopCa          .MACRO param
                  .BYTE $02ED
		  .WORD  param
                  .ENDM
SBCAopDa          .MACRO param
                  .BYTE $03ED
		  .WORD  param
                  .ENDM
SBCAopEa          .MACRO param          
                  .BYTE $10ED
		  .WORD  param
                  .ENDM
SBCAopFa          .MACRO param
                  .BYTE $11ED
		  .WORD  param
                  .ENDM
SBCAopGa          .MACRO param
                  .BYTE $12ED
		  .WORD  param
                  .ENDM                  
SBCAopHa          .MACRO param          
                  .BYTE $13ED
		  .WORD  param
                  .ENDM
SBCAopIa          .MACRO param
                  .BYTE $20ED
		  .WORD  param
                  .ENDM
SBCAopJa          .MACRO param
                  .BYTE $21ED
		  .WORD  param
                  .ENDM
SBCAopKa          .MACRO param          
                  .BYTE $22ED
		  .WORD  param
                  .ENDM
SBCAopLa          .MACRO param
                  .BYTE $23ED
		  .WORD  param
                  .ENDM
SBCAopMa          .MACRO param
                  .BYTE $30ED
		  .WORD  param
                  .ENDM                  
SBCAopNa          .MACRO param          
                  .BYTE $31ED
		  .WORD  param
                  .ENDM
SBCAopOa          .MACRO param
                  .BYTE $32ED
		  .WORD  param
                  .ENDM
SBCAopQa          .MACRO param
                  .BYTE $33ED
		  .WORD  param
                  .ENDM
                                    
SBCBopAa          .MACRO param
                  .BYTE $04ED
		  .WORD  param
                  .ENDM                
SBCBopBa          .MACRO param          
                  .BYTE $05ED
		  .WORD  param
                  .ENDM
SBCBopCa          .MACRO param
                  .BYTE $06ED
		  .WORD  param
                  .ENDM
SBCBopDa          .MACRO param
                  .BYTE $07ED
		  .WORD  param
                  .ENDM
SBCBopEa          .MACRO param          
                  .BYTE $14ED
		  .WORD  param
                  .ENDM
SBCBopFa          .MACRO param
                  .BYTE $15ED
		  .WORD  param
                  .ENDM
SBCBopGa          .MACRO param
                  .BYTE $16ED
		  .WORD  param
                  .ENDM                  
SBCBopHa          .MACRO param          
                  .BYTE $17ED
		  .WORD  param
                  .ENDM
SBCBopIa          .MACRO param
                  .BYTE $24ED
		  .WORD  param
                  .ENDM
SBCBopJa          .MACRO param
                  .BYTE $25ED
		  .WORD  param
                  .ENDM
SBCBopKa          .MACRO param          
                  .BYTE $26ED
		  .WORD  param
                  .ENDM
SBCBopLa          .MACRO param
                  .BYTE $27ED
		  .WORD  param
                  .ENDM
SBCBopMa          .MACRO param
                  .BYTE $30ED
		  .WORD  param
                  .ENDM                  
SBCBopNa          .MACRO param          
                  .BYTE $31ED
		  .WORD  param
                  .ENDM
SBCBopOa          .MACRO param
                  .BYTE $32ED
		  .WORD  param
                  .ENDM
SBCBopQa          .MACRO param
                  .BYTE $33ED
		  .WORD  param
                  .ENDM
                                    
SBCCopAa          .MACRO param
                  .BYTE $08ED
		  .WORD  param
                  .ENDM                
SBCCopBa          .MACRO param          
                  .BYTE $09ED
		  .WORD  param
                  .ENDM
SBCCopCa          .MACRO param
                  .BYTE $0AED
		  .WORD  param
                  .ENDM
SBCCopDa          .MACRO param
                  .BYTE $0BED
		  .WORD  param
                  .ENDM
SBCCopEa          .MACRO param          
                  .BYTE $18ED
		  .WORD  param
                  .ENDM
SBCCopFa          .MACRO param
                  .BYTE $19ED
		  .WORD  param
                  .ENDM
SBCCopGa          .MACRO param
                  .BYTE $1AED
		  .WORD  param
                  .ENDM                  
SBCCopHa          .MACRO param          
                  .BYTE $1BED
		  .WORD  param
                  .ENDM
SBCCopIa          .MACRO param
                  .BYTE $28ED
		  .WORD  param
                  .ENDM
SBCCopJa          .MACRO param
                  .BYTE $29ED
		  .WORD  param
                  .ENDM
SBCCopKa          .MACRO param          
                  .BYTE $2AED
		  .WORD  param
                  .ENDM
SBCCopLa          .MACRO param
                  .BYTE $2BED
		  .WORD  param
                  .ENDM
SBCCopMa          .MACRO param
                  .BYTE $38ED
		  .WORD  param
                  .ENDM                  
SBCCopNa          .MACRO param          
                  .BYTE $39ED
	 	  .WORD  param
                  .ENDM
SBCCopOa          .MACRO param
                  .BYTE $3AED
		  .WORD  param
                  .ENDM
SBCCopQa          .MACRO param
                  .BYTE $3BED
		  .WORD  param
                  .ENDM

SBCDopAa          .MACRO param
                  .BYTE $0CED
		  .WORD  param
                  .ENDM                
SBCDopBa          .MACRO param          
                  .BYTE $0DED
		  .WORD  param
                  .ENDM
SBCDopCa          .MACRO param
                  .BYTE $0EED
		  .WORD  param
                  .ENDM
SBCDopDa          .MACRO param
                  .BYTE $0FED
		  .WORD  param
                  .ENDM
SBCDopEa          .MACRO param          
                  .BYTE $1CED
		  .WORD  param
                  .ENDM
SBCDopFa          .MACRO param
                  .BYTE $1DED
		  .WORD  param
                  .ENDM
SBCDopGa          .MACRO param
                  .BYTE $1EED
		  .WORD  param
                  .ENDM                  
SBCDopHa          .MACRO param          
                  .BYTE $1FED
		  .WORD  param
                  .ENDM
SBCDopIa          .MACRO param
                  .BYTE $2CED
		  .WORD  param
                  .ENDM
SBCDopJa          .MACRO param
                  .BYTE $2DED
		  .WORD  param
                  .ENDM
SBCDopKa          .MACRO param          
                  .BYTE $2EED
		  .WORD  param
                  .ENDM
SBCDopLa          .MACRO param
                  .BYTE $2FED
		  .WORD  param
                  .ENDM
SBCDopMa          .MACRO param
                  .BYTE $3CED
		  .WORD  param
                  .ENDM                  
SBCDopNa          .MACRO param          
                  .BYTE $3DED
		  .WORD  param
                  .ENDM
SBCDopOa          .MACRO param
                  .BYTE $3EED
		  .WORD  param
                  .ENDM
SBCDopQa          .MACRO param
                  .BYTE $3FED
		  .WORD  param
                  .ENDM                  

SBCEopAa          .MACRO param
                  .BYTE $40ED
		  .WORD  param
                  .ENDM                
SBCEopBa          .MACRO param          
                  .BYTE $41ED
		  .WORD  param
                  .ENDM
SBCEopCa          .MACRO param
                  .BYTE $42ED
		  .WORD  param
                  .ENDM
SBCEopDa          .MACRO param
                  .BYTE $43ED
		  .WORD  param
                  .ENDM
SBCEopEa          .MACRO param          
                  .BYTE $50ED
		  .WORD  param
                  .ENDM
SBCEopFa          .MACRO param
                  .BYTE $51ED
		  .WORD  param
                  .ENDM
SBCEopGa          .MACRO param
                  .BYTE $52ED
		  .WORD  param
                  .ENDM                  
SBCEopHa          .MACRO param          
                  .BYTE $53ED
		  .WORD  param
                  .ENDM
SBCEopIa          .MACRO param
                  .BYTE $60ED
		  .WORD  param
                  .ENDM
SBCEopJa          .MACRO param
                  .BYTE $61ED
		  .WORD  param
                  .ENDM
SBCEopKa          .MACRO param          
                  .BYTE $62ED
		  .WORD  param
                  .ENDM
SBCEopLa          .MACRO param
                  .BYTE $63ED
		  .WORD  param
                  .ENDM
SBCEopMa          .MACRO param
                  .BYTE $70ED
		  .WORD  param
                  .ENDM                  
SBCEopNa          .MACRO param          
                  .BYTE $71ED
		  .WORD  param
                  .ENDM
SBCEopOa          .MACRO param
                  .BYTE $72ED
		  .WORD  param
                  .ENDM
SBCEopQa          .MACRO param
                  .BYTE $73ED
		  .WORD  param
                  .ENDM
                  
SBCFopAa          .MACRO param
                  .BYTE $44ED
		  .WORD  param
                  .ENDM                
SBCFopBa          .MACRO param          
                  .BYTE $45ED
		  .WORD  param
                  .ENDM
SBCFopCa          .MACRO param
                  .BYTE $46ED
		  .WORD  param
                  .ENDM
SBCFopDa          .MACRO param
                  .BYTE $47ED
		  .WORD  param
                  .ENDM
SBCFopEa          .MACRO param          
                  .BYTE $54ED
		  .WORD  param
                  .ENDM
SBCFopFa          .MACRO param
                  .BYTE $55ED
		  .WORD  param
                  .ENDM
SBCFopGa          .MACRO param
                  .BYTE $56ED
		  .WORD  param
                  .ENDM                  
SBCFopHa          .MACRO param          
                  .BYTE $57ED
		  .WORD  param
                  .ENDM
SBCFopIa          .MACRO param
                  .BYTE $64ED
	 	  .WORD  param
                  .ENDM
SBCFopJa          .MACRO param
                  .BYTE $65ED
		  .WORD  param
                  .ENDM
SBCFopKa          .MACRO param          
                  .BYTE $66ED
		  .WORD  param
                  .ENDM
SBCFopLa          .MACRO param
                  .BYTE $67ED
		  .WORD  param
                  .ENDM
SBCFopMa          .MACRO param
                  .BYTE $74ED
		  .WORD  param
                  .ENDM                  
SBCFopNa          .MACRO param          
                  .BYTE $75ED
		  .WORD  param
                  .ENDM
SBCFopOa          .MACRO param
                  .BYTE $76ED
		  .WORD  param
                  .ENDM
SBCFopQa          .MACRO param
                  .BYTE $77ED
		  .WORD  param
                  .ENDM                  
                           
SBCGopAa          .MACRO param
                  .BYTE $48ED
		  .WORD  param
                  .ENDM                
SBCGopBa          .MACRO param          
                  .BYTE $49ED
		  .WORD  param
                  .ENDM
SBCGopCa          .MACRO param
                  .BYTE $4AED
		  .WORD  param
                  .ENDM
SBCGopDa          .MACRO param
                  .BYTE $4BED
		  .WORD  param
                  .ENDM
SBCGopEa          .MACRO param          
                  .BYTE $58ED
		  .WORD  param
                  .ENDM
SBCGopFa          .MACRO param
                  .BYTE $59ED
		  .WORD  param
                  .ENDM
SBCGopGa          .MACRO param
                  .BYTE $5AED
		  .WORD  param
                  .ENDM                  
SBCGopHa          .MACRO param          
                  .BYTE $5BED
		  .WORD  param
                  .ENDM
SBCGopIa          .MACRO param
                  .BYTE $68ED
		  .WORD  param
                  .ENDM
SBCGopJa          .MACRO param
                  .BYTE $69ED
		  .WORD  param
                  .ENDM
SBCGopKa          .MACRO param          
                  .BYTE $6AED
		  .WORD  param
                  .ENDM
SBCGopLa          .MACRO param
                  .BYTE $6BED
		  .WORD  param
                  .ENDM
SBCGopMa          .MACRO param
                  .BYTE $78ED
		  .WORD  param
                  .ENDM                  
SBCGopNa          .MACRO param          
                  .BYTE $79ED
		  .WORD  param
                  .ENDM
SBCGopOa          .MACRO param
                  .BYTE $7AED
		  .WORD  param
                  .ENDM
SBCGopQa          .MACRO param
                  .BYTE $7BED
		  .WORD  param
                  .ENDM
                  
SBCHopAa          .MACRO param
                  .BYTE $4CED
		  .WORD  param
                  .ENDM                
SBCHopBa          .MACRO param          
                  .BYTE $4DED
		  .WORD  param
                  .ENDM
SBCHopCa          .MACRO param
                  .BYTE $4EED
		  .WORD  param
                  .ENDM
SBCHopDa          .MACRO param
                  .BYTE $4FED
		  .WORD  param
                  .ENDM
SBCHopEa          .MACRO param          
                  .BYTE $5CED
		  .WORD  param
                  .ENDM
SBCHopFa          .MACRO param
                  .BYTE $5DED
		  .WORD  param
                  .ENDM
SBCHopGa          .MACRO param
                  .BYTE $5EED
		  .WORD  param
                  .ENDM                  
SBCHopHa          .MACRO param          
                  .BYTE $5FED
		  .WORD  param
                  .ENDM
SBCHopIa          .MACRO param
                  .BYTE $6CED
		  .WORD  param
                  .ENDM
SBCHopJa          .MACRO param
                  .BYTE $6DED
		  .WORD  param
                  .ENDM
SBCHopKa          .MACRO param          
                  .BYTE $6EED
		  .WORD  param
                  .ENDM
SBCHopLa          .MACRO param
                  .BYTE $6FED
		  .WORD  param
                  .ENDM
SBCHopMa          .MACRO param
                  .BYTE $7CED
		  .WORD  param
                  .ENDM                  
SBCHopNa          .MACRO param          
                  .BYTE $7DED
		  .WORD  param
                  .ENDM
SBCHopOa          .MACRO param
                  .BYTE $7EED
		  .WORD  param
                  .ENDM
SBCHopQa          .MACRO param
                  .BYTE $7FED
		  .WORD  param
                  .ENDM
                  
SBCIopAa          .MACRO param
                  .BYTE $80ED
		  .WORD  param
                  .ENDM                
SBCIopBa          .MACRO param          
                  .BYTE $81ED
		  .WORD  param
                  .ENDM
SBCIopCa          .MACRO param
                  .BYTE $82ED
		  .WORD  param
                  .ENDM
SBCIopDa          .MACRO param
                  .BYTE $83ED
		  .WORD  param
                  .ENDM
SBCIopEa          .MACRO param          
                  .BYTE $90ED
		  .WORD  param
                  .ENDM
SBCIopFa          .MACRO param
                  .BYTE $91ED
		  .WORD  param
                  .ENDM
SBCIopGa          .MACRO param
                  .BYTE $92ED
		  .WORD  param
                  .ENDM                  
SBCIopHa          .MACRO param          
                  .BYTE $93ED
		  .WORD  param
                  .ENDM
SBCIopIa          .MACRO param
                  .BYTE $A0ED
		  .WORD  param
                  .ENDM
SBCIopJa          .MACRO param
                  .BYTE $A1ED
		  .WORD  param
                  .ENDM
SBCIopKa          .MACRO param          
                  .BYTE $A2ED
		  .WORD  param
                  .ENDM
SBCIopLa          .MACRO param
                  .BYTE $A3ED
		  .WORD  param
                  .ENDM
SBCIopMa          .MACRO param
                  .BYTE $B0ED
		  .WORD  param
                  .ENDM                  
SBCIopNa          .MACRO param          
                  .BYTE $B1ED
		  .WORD  param
                  .ENDM
SBCIopOa          .MACRO param
                  .BYTE $B2ED
		  .WORD  param
                  .ENDM
SBCIopQa          .MACRO param
                  .BYTE $B3ED
		  .WORD  param
                  .ENDM
                  
SBCJopAa          .MACRO param
                  .BYTE $84ED
		  .WORD  param
                  .ENDM                
SBCJopBa          .MACRO param          
                  .BYTE $85ED
		  .WORD  param
                  .ENDM
SBCJopCa          .MACRO param
                  .BYTE $86ED
		  .WORD  param
                  .ENDM
SBCJopDa          .MACRO param
                  .BYTE $87ED
		  .WORD  param
                  .ENDM
SBCJopEa          .MACRO param          
                  .BYTE $94ED
		  .WORD  param
                  .ENDM
SBCJopFa          .MACRO param
                  .BYTE $95ED
		  .WORD  param
                  .ENDM
SBCJopGa          .MACRO param
                  .BYTE $96ED
		  .WORD  param
                  .ENDM                  
SBCJopHa          .MACRO param          
                  .BYTE $97ED
		  .WORD  param
                  .ENDM
SBCJopIa          .MACRO param
                  .BYTE $A4ED
		  .WORD  param
                  .ENDM
SBCJopJa          .MACRO param
                  .BYTE $A5ED
		  .WORD  param
                  .ENDM
SBCJopKa          .MACRO param          
                  .BYTE $A6ED
 		  .WORD  param
                  .ENDM
SBCJopLa          .MACRO param
                  .BYTE $A7ED
		  .WORD  param
                  .ENDM
SBCJopMa          .MACRO param
                  .BYTE $B4ED
		  .WORD  param
                  .ENDM                  
SBCJopNa          .MACRO param          
                  .BYTE $B5ED
		  .WORD  param
                  .ENDM
SBCJopOa          .MACRO param
                  .BYTE $B6ED
		  .WORD  param
                  .ENDM
SBCJopQa          .MACRO param
                  .BYTE $B7ED
		  .WORD  param
                  .ENDM
                  
SBCKopAa          .MACRO param
                  .BYTE $88ED
		  .WORD  param
                  .ENDM                
SBCKopBa          .MACRO param          
                  .BYTE $89ED
		  .WORD  param
                  .ENDM
SBCKopCa          .MACRO param
                  .BYTE $8AED
		  .WORD  param
                  .ENDM
SBCKopDa          .MACRO param
                  .BYTE $8BED
		  .WORD  param
                  .ENDM
SBCKopEa          .MACRO param          
                  .BYTE $98ED
		  .WORD  param
                  .ENDM
SBCKopFa          .MACRO param
                  .BYTE $99ED
		  .WORD  param
                  .ENDM
SBCKopGa          .MACRO param
                  .BYTE $9AED
		  .WORD  param
                  .ENDM                  
SBCKopHa          .MACRO param          
                  .BYTE $9BED
		  .WORD  param
                  .ENDM
SBCKopIa          .MACRO param
                  .BYTE $A8ED
		  .WORD  param
                  .ENDM
SBCKopJa          .MACRO param
                  .BYTE $A9ED
		  .WORD  param
                  .ENDM
SBCKopKa          .MACRO param          
                  .BYTE $AAED
		  .WORD  param
                  .ENDM
SBCKopLa          .MACRO param
                  .BYTE $ABED
		  .WORD  param
                  .ENDM
SBCKopMa          .MACRO param
                  .BYTE $B8ED
		  .WORD  param
                  .ENDM                  
SBCKopNa          .MACRO param          
                  .BYTE $B9ED
		  .WORD  param
                  .ENDM
SBCKopOa          .MACRO param
                  .BYTE $BAED
		  .WORD  param
                  .ENDM
SBCKopQa          .MACRO param
                  .BYTE $BBED
		  .WORD  param
                  .ENDM
                  
SBCLopAa          .MACRO param
                  .BYTE $8CED
		  .WORD  param
                  .ENDM                
SBCLopBa          .MACRO param          
                  .BYTE $8DED
		  .WORD  param
                  .ENDM
SBCLopCa          .MACRO param
                  .BYTE $8EED
		  .WORD  param
                  .ENDM
SBCLopDa          .MACRO param
                  .BYTE $8FED
		  .WORD  param
                  .ENDM
SBCLopEa          .MACRO param          
                  .BYTE $9CED
		  .WORD  param
                  .ENDM
SBCLopFa          .MACRO param
                  .BYTE $9DED
		  .WORD  param
                  .ENDM
SBCLopGa          .MACRO param
                  .BYTE $9EED
		  .WORD  param
                  .ENDM                  
SBCLopHa          .MACRO param          
                  .BYTE $9FED
		  .WORD  param
                  .ENDM
SBCLopIa          .MACRO param
                  .BYTE $ACED
		  .WORD  param
                  .ENDM
SBCLopJa          .MACRO param
                  .BYTE $ADED
		  .WORD  param
                  .ENDM
SBCLopKa          .MACRO param          
                  .BYTE $AEED
		  .WORD  param
                  .ENDM
SBCLopLa          .MACRO param
                  .BYTE $AFED
		  .WORD  param
                  .ENDM
SBCLopMa          .MACRO param
                  .BYTE $BCED
		  .WORD  param
                  .ENDM                  
SBCLopNa          .MACRO param          
                  .BYTE $BDED
		  .WORD  param
                  .ENDM
SBCLopOa          .MACRO param
                  .BYTE $BEED
		  .WORD  param
                  .ENDM
SBCLopQa          .MACRO param
                  .BYTE $BFED
		  .WORD  param
                  .ENDM
                  
SBCMopAa          .MACRO param
                  .BYTE $C0ED
		  .WORD  param
                  .ENDM                
SBCMopBa          .MACRO param          
                  .BYTE $C1ED
		  .WORD  param
                  .ENDM
SBCMopCa          .MACRO param
                  .BYTE $C2ED
		  .WORD  param
                  .ENDM
SBCMopDa          .MACRO param
                  .BYTE $C3ED
		  .WORD  param
                  .ENDM
SBCMopEa          .MACRO param          
                  .BYTE $D0ED
		  .WORD  param
                  .ENDM
SBCMopFa          .MACRO param
                  .BYTE $D1ED
		  .WORD  param
                  .ENDM
SBCMopGa          .MACRO param
                  .BYTE $D2ED
		  .WORD  param
                  .ENDM                  
SBCMopHa          .MACRO param          
                  .BYTE $D3ED
		  .WORD  param
                  .ENDM
SBCMopIa          .MACRO param
                  .BYTE $E0ED
		  .WORD  param
                  .ENDM
SBCMopJa          .MACRO param
                  .BYTE $E1ED
		  .WORD  param
                  .ENDM
SBCMopKa          .MACRO param          
                  .BYTE $E2ED
		  .WORD  param
                  .ENDM
SBCMopLa          .MACRO param
                  .BYTE $E3ED
		  .WORD  param
                  .ENDM
SBCMopMa          .MACRO param
                  .BYTE $F0ED
		  .WORD  param
                  .ENDM                  
SBCMopNa          .MACRO param          
                  .BYTE $F1ED
		  .WORD  param
                  .ENDM
SBCMopOa          .MACRO param
                  .BYTE $F2ED
		  .WORD  param
                  .ENDM
SBCMopQa          .MACRO param
                  .BYTE $F3ED
		  .WORD  param
                  .ENDM
                  
SBCNopAa          .MACRO param
                  .BYTE $C4ED
		  .WORD  param
                  .ENDM                
SBCNopBa          .MACRO param          
                  .BYTE $C5ED
		  .WORD  param
                  .ENDM
SBCNopCa          .MACRO param
                  .BYTE $C6ED
		  .WORD  param
                  .ENDM
SBCNopDa          .MACRO param
                  .BYTE $C7ED
		  .WORD  param
                  .ENDM
SBCNopEa          .MACRO param          
                  .BYTE $D4ED
		  .WORD  param
                  .ENDM
SBCNopFa          .MACRO param
                  .BYTE $D5ED
		  .WORD  param
                  .ENDM
SBCNopGa          .MACRO param
                  .BYTE $D6ED
		  .WORD  param
                  .ENDM                  
SBCNopHa          .MACRO param          
                  .BYTE $D7ED
		  .WORD  param
                  .ENDM
SBCNopIa          .MACRO param
                  .BYTE $E4ED
		  .WORD  param
                  .ENDM
SBCNopJa          .MACRO param
                  .BYTE $E5ED
		  .WORD  param
                  .ENDM
SBCNopKa          .MACRO param          
                  .BYTE $E6ED
		  .WORD  param
                  .ENDM
SBCNopLa          .MACRO param
                  .BYTE $E7ED
		  .WORD  param
                  .ENDM
SBCNopMa          .MACRO param
                  .BYTE $F4ED
		  .WORD  param
                  .ENDM                  
SBCNopNa          .MACRO param          
                  .BYTE $F5ED
		  .WORD  param
                  .ENDM
SBCNopOa          .MACRO param
                  .BYTE $F6ED
		  .WORD  param
                  .ENDM
SBCNopQa          .MACRO param
                  .BYTE $F7ED
		  .WORD  param
                  .ENDM
            
SBCOopAa          .MACRO param
                  .BYTE $C8ED
		  .WORD  param
                  .ENDM                
SBCOopBa          .MACRO param          
                  .BYTE $C9ED
		  .WORD  param
                  .ENDM
SBCOopCa          .MACRO param
                  .BYTE $CAED
		  .WORD  param
                  .ENDM
SBCOopDa          .MACRO param
                  .BYTE $CBED
		  .WORD  param
                  .ENDM
SBCOopEa          .MACRO param          
                  .BYTE $D8ED
		  .WORD  param
                  .ENDM
SBCOopFa          .MACRO param
                  .BYTE $D9ED
		  .WORD  param
                  .ENDM
SBCOopGa          .MACRO param
                  .BYTE $DAED
		  .WORD  param
                  .ENDM                  
SBCOopHa          .MACRO param          
                  .BYTE $DBED
		  .WORD  param
                  .ENDM
SBCOopIa          .MACRO param
                  .BYTE $E8ED
		  .WORD  param
                  .ENDM
SBCOopJa          .MACRO param
                  .BYTE $E9ED
		  .WORD  param
                  .ENDM
SBCOopKa          .MACRO param          
                  .BYTE $EAED
		  .WORD  param
                  .ENDM
SBCOopLa          .MACRO param
                  .BYTE $EBED
		  .WORD  param
                  .ENDM
SBCOopMa          .MACRO param
                  .BYTE $F8ED
		  .WORD  param
                  .ENDM                  
SBCOopNa          .MACRO param          
                  .BYTE $F9ED
		  .WORD  param
                  .ENDM
SBCOopOa          .MACRO param
                  .BYTE $FAED
		  .WORD  param
                  .ENDM
SBCOopQa          .MACRO param
                  .BYTE $FBED
		  .WORD  param
                  .ENDM
                  
SBCQopAa          .MACRO param
                  .BYTE $CCED
		  .WORD  param
                  .ENDM                
SBCQopBa          .MACRO param          
                  .BYTE $CDED
		  .WORD  param
                  .ENDM
SBCQopCa          .MACRO param
                  .BYTE $CEED
		  .WORD  param
                  .ENDM
SBCQopDa          .MACRO param
                  .BYTE $CFED
		  .WORD  param
                  .ENDM
SBCQopEa          .MACRO param          
                  .BYTE $DCED
		  .WORD  param
                  .ENDM
SBCQopFa          .MACRO param
                  .BYTE $DDED
		  .WORD  param
                  .ENDM
SBCQopGa          .MACRO param
                  .BYTE $DEED
		  .WORD  param
                  .ENDM                  
SBCQopHa          .MACRO param          
                  .BYTE $DFED
		  .WORD  param
                  .ENDM
SBCQopIa          .MACRO param
                  .BYTE $ECED
		  .WORD  param
                  .ENDM
SBCQopJa          .MACRO param
                  .BYTE $EDED
		  .WORD  param
                  .ENDM
SBCQopKa          .MACRO param          
                  .BYTE $EEED
		  .WORD  param
                  .ENDM
SBCQopLa          .MACRO param
                  .BYTE $EFED
		  .WORD  param
                  .ENDM
SBCQopMa          .MACRO param
                  .BYTE $FCED
		  .WORD  param
                  .ENDM                  
SBCQopNa          .MACRO param          
                  .BYTE $FDED
		  .WORD  param
                  .ENDM
SBCQopOa          .MACRO param
                  .BYTE $FEED
		  .WORD  param
                  .ENDM
SBCQopQa          .MACRO param
                  .BYTE $FFED
		  .WORD  param
                  .ENDM

;ORA $xxxxxxxx          $000D
ORAAopBa          .MACRO param          
                  .BYTE $010D
		  .WORD  param
                  .ENDM
ORAAopCa          .MACRO param
                  .BYTE $020D
		  .WORD  param
                  .ENDM
ORAAopDa          .MACRO param
                  .BYTE $030D
		  .WORD  param
                  .ENDM
ORAAopEa          .MACRO param          
                  .BYTE $100D
		  .WORD  param
                  .ENDM
ORAAopFa          .MACRO param
                  .BYTE $110D
		  .WORD  param
                  .ENDM
ORAAopGa          .MACRO param
                  .BYTE $120D
		  .WORD  param
                  .ENDM                  
ORAAopHa          .MACRO param          
                  .BYTE $130D
		  .WORD  param
                  .ENDM
ORAAopIa          .MACRO param
                  .BYTE $200D
		  .WORD  param
                  .ENDM
ORAAopJa          .MACRO param
                  .BYTE $210D
		  .WORD  param
                  .ENDM
ORAAopKa          .MACRO param          
                  .BYTE $220D
		  .WORD  param
                  .ENDM
ORAAopLa          .MACRO param
                  .BYTE $230D
		  .WORD  param
                  .ENDM
ORAAopMa          .MACRO param
                  .BYTE $300D
		  .WORD  param
                  .ENDM                  
ORAAopNa          .MACRO param          
                  .BYTE $310D
		  .WORD  param
                  .ENDM
ORAAopOa          .MACRO param
                  .BYTE $320D
		  .WORD  param
                  .ENDM
ORAAopQa          .MACRO param
                  .BYTE $330D
		  .WORD  param
                  .ENDM
                                    
ORABopAa          .MACRO param
                  .BYTE $040D
		  .WORD  param
                  .ENDM                
ORABopBa          .MACRO param          
                  .BYTE $050D
		  .WORD  param
                  .ENDM
ORABopCa          .MACRO param
                  .BYTE $060D
		  .WORD  param
                  .ENDM
ORABopDa          .MACRO param
                  .BYTE $070D
		  .WORD  param
                  .ENDM
ORABopEa          .MACRO param          
                  .BYTE $140D
		  .WORD  param
                  .ENDM
ORABopFa          .MACRO param
                  .BYTE $150D
		  .WORD  param
                  .ENDM
ORABopGa          .MACRO param
                  .BYTE $160D
		  .WORD  param
                  .ENDM                  
ORABopHa          .MACRO param          
                  .BYTE $170D
		  .WORD  param
                  .ENDM
ORABopIa          .MACRO param
                  .BYTE $240D
		  .WORD  param
                  .ENDM
ORABopJa          .MACRO param
                  .BYTE $250D
		  .WORD  param
                  .ENDM
ORABopKa          .MACRO param          
                  .BYTE $260D
		  .WORD  param
                  .ENDM
ORABopLa          .MACRO param
                  .BYTE $270D
		  .WORD  param
                  .ENDM
ORABopMa          .MACRO param
                  .BYTE $300D
		  .WORD  param
                  .ENDM                  
ORABopNa          .MACRO param          
                  .BYTE $310D
		  .WORD  param
                  .ENDM
ORABopOa          .MACRO param
                  .BYTE $320D
		  .WORD  param
                  .ENDM
ORABopQa          .MACRO param
                  .BYTE $330D
		  .WORD  param
                  .ENDM
                                    
ORACopAa          .MACRO param
                  .BYTE $080D
		  .WORD  param
                  .ENDM                
ORACopBa          .MACRO param          
                  .BYTE $090D
		  .WORD  param
                  .ENDM
ORACopCa          .MACRO param
                  .BYTE $0A0D
		  .WORD  param
                  .ENDM
ORACopDa          .MACRO param
                  .BYTE $0B0D
		  .WORD  param
                  .ENDM
ORACopEa          .MACRO param          
                  .BYTE $180D
		  .WORD  param
                  .ENDM
ORACopFa          .MACRO param
                  .BYTE $190D
		  .WORD  param
                  .ENDM
ORACopGa          .MACRO param
                  .BYTE $1A0D
		  .WORD  param
                  .ENDM                  
ORACopHa          .MACRO param          
                  .BYTE $1B0D
		  .WORD  param
                  .ENDM
ORACopIa          .MACRO param
                  .BYTE $280D
		  .WORD  param
                  .ENDM
ORACopJa          .MACRO param
                  .BYTE $290D
		  .WORD  param
                  .ENDM
ORACopKa          .MACRO param          
                  .BYTE $2A0D
		  .WORD  param
                  .ENDM
ORACopLa          .MACRO param
                  .BYTE $2B0D
		  .WORD  param
                  .ENDM
ORACopMa          .MACRO param
                  .BYTE $380D
		  .WORD  param
                  .ENDM                  
ORACopNa          .MACRO param          
                  .BYTE $390D
	 	  .WORD  param
                  .ENDM
ORACopOa          .MACRO param
                  .BYTE $3A0D
		  .WORD  param
                  .ENDM
ORACopQa          .MACRO param
                  .BYTE $3B0D
		  .WORD  param
                  .ENDM

ORADopAa          .MACRO param
                  .BYTE $0C0D
		  .WORD  param
                  .ENDM                
ORADopBa          .MACRO param          
                  .BYTE $0D0D
		  .WORD  param
                  .ENDM
ORADopCa          .MACRO param
                  .BYTE $0E0D
		  .WORD  param
                  .ENDM
ORADopDa          .MACRO param
                  .BYTE $0F0D
		  .WORD  param
                  .ENDM
ORADopEa          .MACRO param          
                  .BYTE $1C0D
		  .WORD  param
                  .ENDM
ORADopFa          .MACRO param
                  .BYTE $1D0D
		  .WORD  param
                  .ENDM
ORADopGa          .MACRO param
                  .BYTE $1E0D
		  .WORD  param
                  .ENDM                  
ORADopHa          .MACRO param          
                  .BYTE $1F0D
		  .WORD  param
                  .ENDM
ORADopIa          .MACRO param
                  .BYTE $2C0D
		  .WORD  param
                  .ENDM
ORADopJa          .MACRO param
                  .BYTE $2D0D
		  .WORD  param
                  .ENDM
ORADopKa          .MACRO param          
                  .BYTE $2E0D
		  .WORD  param
                  .ENDM
ORADopLa          .MACRO param
                  .BYTE $2F0D
		  .WORD  param
                  .ENDM
ORADopMa          .MACRO param
                  .BYTE $3C0D
		  .WORD  param
                  .ENDM                  
ORADopNa          .MACRO param          
                  .BYTE $3D0D
		  .WORD  param
                  .ENDM
ORADopOa          .MACRO param
                  .BYTE $3E0D
		  .WORD  param
                  .ENDM
ORADopQa          .MACRO param
                  .BYTE $3F0D
		  .WORD  param
                  .ENDM                  

ORAEopAa          .MACRO param
                  .BYTE $400D
		  .WORD  param
                  .ENDM                
ORAEopBa          .MACRO param          
                  .BYTE $410D
		  .WORD  param
                  .ENDM
ORAEopCa          .MACRO param
                  .BYTE $420D
		  .WORD  param
                  .ENDM
ORAEopDa          .MACRO param
                  .BYTE $430D
		  .WORD  param
                  .ENDM
ORAEopEa          .MACRO param          
                  .BYTE $500D
		  .WORD  param
                  .ENDM
ORAEopFa          .MACRO param
                  .BYTE $510D
		  .WORD  param
                  .ENDM
ORAEopGa          .MACRO param
                  .BYTE $520D
		  .WORD  param
                  .ENDM                  
ORAEopHa          .MACRO param          
                  .BYTE $530D
		  .WORD  param
                  .ENDM
ORAEopIa          .MACRO param
                  .BYTE $600D
		  .WORD  param
                  .ENDM
ORAEopJa          .MACRO param
                  .BYTE $610D
		  .WORD  param
                  .ENDM
ORAEopKa          .MACRO param          
                  .BYTE $620D
		  .WORD  param
                  .ENDM
ORAEopLa          .MACRO param
                  .BYTE $630D
		  .WORD  param
                  .ENDM
ORAEopMa          .MACRO param
                  .BYTE $700D
		  .WORD  param
                  .ENDM                  
ORAEopNa          .MACRO param          
                  .BYTE $710D
		  .WORD  param
                  .ENDM
ORAEopOa          .MACRO param
                  .BYTE $720D
		  .WORD  param
                  .ENDM
ORAEopQa          .MACRO param
                  .BYTE $730D
		  .WORD  param
                  .ENDM
                  
ORAFopAa          .MACRO param
                  .BYTE $440D
		  .WORD  param
                  .ENDM                
ORAFopBa          .MACRO param          
                  .BYTE $450D
		  .WORD  param
                  .ENDM
ORAFopCa          .MACRO param
                  .BYTE $460D
		  .WORD  param
                  .ENDM
ORAFopDa          .MACRO param
                  .BYTE $470D
		  .WORD  param
                  .ENDM
ORAFopEa          .MACRO param          
                  .BYTE $540D
		  .WORD  param
                  .ENDM
ORAFopFa          .MACRO param
                  .BYTE $550D
		  .WORD  param
                  .ENDM
ORAFopGa          .MACRO param
                  .BYTE $560D
		  .WORD  param
                  .ENDM                  
ORAFopHa          .MACRO param          
                  .BYTE $570D
		  .WORD  param
                  .ENDM
ORAFopIa          .MACRO param
                  .BYTE $640D
	 	  .WORD  param
                  .ENDM
ORAFopJa          .MACRO param
                  .BYTE $650D
		  .WORD  param
                  .ENDM
ORAFopKa          .MACRO param          
                  .BYTE $660D
		  .WORD  param
                  .ENDM
ORAFopLa          .MACRO param
                  .BYTE $670D
		  .WORD  param
                  .ENDM
ORAFopMa          .MACRO param
                  .BYTE $740D
		  .WORD  param
                  .ENDM                  
ORAFopNa          .MACRO param          
                  .BYTE $750D
		  .WORD  param
                  .ENDM
ORAFopOa          .MACRO param
                  .BYTE $760D
		  .WORD  param
                  .ENDM
ORAFopQa          .MACRO param
                  .BYTE $770D
		  .WORD  param
                  .ENDM                  
                           
ORAGopAa          .MACRO param
                  .BYTE $480D
		  .WORD  param
                  .ENDM                
ORAGopBa          .MACRO param          
                  .BYTE $490D
		  .WORD  param
                  .ENDM
ORAGopCa          .MACRO param
                  .BYTE $4A0D
		  .WORD  param
                  .ENDM
ORAGopDa          .MACRO param
                  .BYTE $4B0D
		  .WORD  param
                  .ENDM
ORAGopEa          .MACRO param          
                  .BYTE $580D
		  .WORD  param
                  .ENDM
ORAGopFa          .MACRO param
                  .BYTE $590D
		  .WORD  param
                  .ENDM
ORAGopGa          .MACRO param
                  .BYTE $5A0D
		  .WORD  param
                  .ENDM                  
ORAGopHa          .MACRO param          
                  .BYTE $5B0D
		  .WORD  param
                  .ENDM
ORAGopIa          .MACRO param
                  .BYTE $680D
		  .WORD  param
                  .ENDM
ORAGopJa          .MACRO param
                  .BYTE $690D
		  .WORD  param
                  .ENDM
ORAGopKa          .MACRO param          
                  .BYTE $6A0D
		  .WORD  param
                  .ENDM
ORAGopLa          .MACRO param
                  .BYTE $6B0D
		  .WORD  param
                  .ENDM
ORAGopMa          .MACRO param
                  .BYTE $780D
		  .WORD  param
                  .ENDM                  
ORAGopNa          .MACRO param          
                  .BYTE $790D
		  .WORD  param
                  .ENDM
ORAGopOa          .MACRO param
                  .BYTE $7A0D
		  .WORD  param
                  .ENDM
ORAGopQa          .MACRO param
                  .BYTE $7B0D
		  .WORD  param
                  .ENDM
                  
ORAHopAa          .MACRO param
                  .BYTE $4C0D
		  .WORD  param
                  .ENDM                
ORAHopBa          .MACRO param          
                  .BYTE $4D0D
		  .WORD  param
                  .ENDM
ORAHopCa          .MACRO param
                  .BYTE $4E0D
		  .WORD  param
                  .ENDM
ORAHopDa          .MACRO param
                  .BYTE $4F0D
		  .WORD  param
                  .ENDM
ORAHopEa          .MACRO param          
                  .BYTE $5C0D
		  .WORD  param
                  .ENDM
ORAHopFa          .MACRO param
                  .BYTE $5D0D
		  .WORD  param
                  .ENDM
ORAHopGa          .MACRO param
                  .BYTE $5E0D
		  .WORD  param
                  .ENDM                  
ORAHopHa          .MACRO param          
                  .BYTE $5F0D
		  .WORD  param
                  .ENDM
ORAHopIa          .MACRO param
                  .BYTE $6C0D
		  .WORD  param
                  .ENDM
ORAHopJa          .MACRO param
                  .BYTE $6D0D
		  .WORD  param
                  .ENDM
ORAHopKa          .MACRO param          
                  .BYTE $6E0D
		  .WORD  param
                  .ENDM
ORAHopLa          .MACRO param
                  .BYTE $6F0D
		  .WORD  param
                  .ENDM
ORAHopMa          .MACRO param
                  .BYTE $7C0D
		  .WORD  param
                  .ENDM                  
ORAHopNa          .MACRO param          
                  .BYTE $7D0D
		  .WORD  param
                  .ENDM
ORAHopOa          .MACRO param
                  .BYTE $7E0D
		  .WORD  param
                  .ENDM
ORAHopQa          .MACRO param
                  .BYTE $7F0D
		  .WORD  param
                  .ENDM
                  
ORAIopAa          .MACRO param
                  .BYTE $800D
		  .WORD  param
                  .ENDM                
ORAIopBa          .MACRO param          
                  .BYTE $810D
		  .WORD  param
                  .ENDM
ORAIopCa          .MACRO param
                  .BYTE $820D
		  .WORD  param
                  .ENDM
ORAIopDa          .MACRO param
                  .BYTE $830D
		  .WORD  param
                  .ENDM
ORAIopEa          .MACRO param          
                  .BYTE $900D
		  .WORD  param
                  .ENDM
ORAIopFa          .MACRO param
                  .BYTE $910D
		  .WORD  param
                  .ENDM
ORAIopGa          .MACRO param
                  .BYTE $920D
		  .WORD  param
                  .ENDM                  
ORAIopHa          .MACRO param          
                  .BYTE $930D
		  .WORD  param
                  .ENDM
ORAIopIa          .MACRO param
                  .BYTE $A00D
		  .WORD  param
                  .ENDM
ORAIopJa          .MACRO param
                  .BYTE $A10D
		  .WORD  param
                  .ENDM
ORAIopKa          .MACRO param          
                  .BYTE $A20D
		  .WORD  param
                  .ENDM
ORAIopLa          .MACRO param
                  .BYTE $A30D
		  .WORD  param
                  .ENDM
ORAIopMa          .MACRO param
                  .BYTE $B00D
		  .WORD  param
                  .ENDM                  
ORAIopNa          .MACRO param          
                  .BYTE $B10D
		  .WORD  param
                  .ENDM
ORAIopOa          .MACRO param
                  .BYTE $B20D
		  .WORD  param
                  .ENDM
ORAIopQa          .MACRO param
                  .BYTE $B30D
		  .WORD  param
                  .ENDM
                  
ORAJopAa          .MACRO param
                  .BYTE $840D
		  .WORD  param
                  .ENDM                
ORAJopBa          .MACRO param          
                  .BYTE $850D
		  .WORD  param
                  .ENDM
ORAJopCa          .MACRO param
                  .BYTE $860D
		  .WORD  param
                  .ENDM
ORAJopDa          .MACRO param
                  .BYTE $870D
		  .WORD  param
                  .ENDM
ORAJopEa          .MACRO param          
                  .BYTE $940D
		  .WORD  param
                  .ENDM
ORAJopFa          .MACRO param
                  .BYTE $950D
		  .WORD  param
                  .ENDM
ORAJopGa          .MACRO param
                  .BYTE $960D
		  .WORD  param
                  .ENDM                  
ORAJopHa          .MACRO param          
                  .BYTE $970D
		  .WORD  param
                  .ENDM
ORAJopIa          .MACRO param
                  .BYTE $A40D
		  .WORD  param
                  .ENDM
ORAJopJa          .MACRO param
                  .BYTE $A50D
		  .WORD  param
                  .ENDM
ORAJopKa          .MACRO param          
                  .BYTE $A60D
 		  .WORD  param
                  .ENDM
ORAJopLa          .MACRO param
                  .BYTE $A70D
		  .WORD  param
                  .ENDM
ORAJopMa          .MACRO param
                  .BYTE $B40D
		  .WORD  param
                  .ENDM                  
ORAJopNa          .MACRO param          
                  .BYTE $B50D
		  .WORD  param
                  .ENDM
ORAJopOa          .MACRO param
                  .BYTE $B60D
		  .WORD  param
                  .ENDM
ORAJopQa          .MACRO param
                  .BYTE $B70D
		  .WORD  param
                  .ENDM
                  
ORAKopAa          .MACRO param
                  .BYTE $880D
		  .WORD  param
                  .ENDM                
ORAKopBa          .MACRO param          
                  .BYTE $890D
		  .WORD  param
                  .ENDM
ORAKopCa          .MACRO param
                  .BYTE $8A0D
		  .WORD  param
                  .ENDM
ORAKopDa          .MACRO param
                  .BYTE $8B0D
		  .WORD  param
                  .ENDM
ORAKopEa          .MACRO param          
                  .BYTE $980D
		  .WORD  param
                  .ENDM
ORAKopFa          .MACRO param
                  .BYTE $990D
		  .WORD  param
                  .ENDM
ORAKopGa          .MACRO param
                  .BYTE $9A0D
		  .WORD  param
                  .ENDM                  
ORAKopHa          .MACRO param          
                  .BYTE $9B0D
		  .WORD  param
                  .ENDM
ORAKopIa          .MACRO param
                  .BYTE $A80D
		  .WORD  param
                  .ENDM
ORAKopJa          .MACRO param
                  .BYTE $A90D
		  .WORD  param
                  .ENDM
ORAKopKa          .MACRO param          
                  .BYTE $AA0D
		  .WORD  param
                  .ENDM
ORAKopLa          .MACRO param
                  .BYTE $AB0D
		  .WORD  param
                  .ENDM
ORAKopMa          .MACRO param
                  .BYTE $B80D
		  .WORD  param
                  .ENDM                  
ORAKopNa          .MACRO param          
                  .BYTE $B90D
		  .WORD  param
                  .ENDM
ORAKopOa          .MACRO param
                  .BYTE $BA0D
		  .WORD  param
                  .ENDM
ORAKopQa          .MACRO param
                  .BYTE $BB0D
		  .WORD  param
                  .ENDM
                  
ORALopAa          .MACRO param
                  .BYTE $8C0D
		  .WORD  param
                  .ENDM                
ORALopBa          .MACRO param          
                  .BYTE $8D0D
		  .WORD  param
                  .ENDM
ORALopCa          .MACRO param
                  .BYTE $8E0D
		  .WORD  param
                  .ENDM
ORALopDa          .MACRO param
                  .BYTE $8F0D
		  .WORD  param
                  .ENDM
ORALopEa          .MACRO param          
                  .BYTE $9C0D
		  .WORD  param
                  .ENDM
ORALopFa          .MACRO param
                  .BYTE $9D0D
		  .WORD  param
                  .ENDM
ORALopGa          .MACRO param
                  .BYTE $9E0D
		  .WORD  param
                  .ENDM                  
ORALopHa          .MACRO param          
                  .BYTE $9F0D
		  .WORD  param
                  .ENDM
ORALopIa          .MACRO param
                  .BYTE $AC0D
		  .WORD  param
                  .ENDM
ORALopJa          .MACRO param
                  .BYTE $AD0D
		  .WORD  param
                  .ENDM
ORALopKa          .MACRO param          
                  .BYTE $AE0D
		  .WORD  param
                  .ENDM
ORALopLa          .MACRO param
                  .BYTE $AF0D
		  .WORD  param
                  .ENDM
ORALopMa          .MACRO param
                  .BYTE $BC0D
		  .WORD  param
                  .ENDM                  
ORALopNa          .MACRO param          
                  .BYTE $BD0D
		  .WORD  param
                  .ENDM
ORALopOa          .MACRO param
                  .BYTE $BE0D
		  .WORD  param
                  .ENDM
ORALopQa          .MACRO param
                  .BYTE $BF0D
		  .WORD  param
                  .ENDM
                  
ORAMopAa          .MACRO param
                  .BYTE $C00D
		  .WORD  param
                  .ENDM                
ORAMopBa          .MACRO param          
                  .BYTE $C10D
		  .WORD  param
                  .ENDM
ORAMopCa          .MACRO param
                  .BYTE $C20D
		  .WORD  param
                  .ENDM
ORAMopDa          .MACRO param
                  .BYTE $C30D
		  .WORD  param
                  .ENDM
ORAMopEa          .MACRO param          
                  .BYTE $D00D
		  .WORD  param
                  .ENDM
ORAMopFa          .MACRO param
                  .BYTE $D10D
		  .WORD  param
                  .ENDM
ORAMopGa          .MACRO param
                  .BYTE $D20D
		  .WORD  param
                  .ENDM                  
ORAMopHa          .MACRO param          
                  .BYTE $D30D
		  .WORD  param
                  .ENDM
ORAMopIa          .MACRO param
                  .BYTE $E00D
		  .WORD  param
                  .ENDM
ORAMopJa          .MACRO param
                  .BYTE $E10D
		  .WORD  param
                  .ENDM
ORAMopKa          .MACRO param          
                  .BYTE $E20D
		  .WORD  param
                  .ENDM
ORAMopLa          .MACRO param
                  .BYTE $E30D
		  .WORD  param
                  .ENDM
ORAMopMa          .MACRO param
                  .BYTE $F00D
		  .WORD  param
                  .ENDM                  
ORAMopNa          .MACRO param          
                  .BYTE $F10D
		  .WORD  param
                  .ENDM
ORAMopOa          .MACRO param
                  .BYTE $F20D
		  .WORD  param
                  .ENDM
ORAMopQa          .MACRO param
                  .BYTE $F30D
		  .WORD  param
                  .ENDM
                  
ORANopAa          .MACRO param
                  .BYTE $C40D
		  .WORD  param
                  .ENDM                
ORANopBa          .MACRO param          
                  .BYTE $C50D
		  .WORD  param
                  .ENDM
ORANopCa          .MACRO param
                  .BYTE $C60D
		  .WORD  param
                  .ENDM
ORANopDa          .MACRO param
                  .BYTE $C70D
		  .WORD  param
                  .ENDM
ORANopEa          .MACRO param          
                  .BYTE $D40D
		  .WORD  param
                  .ENDM
ORANopFa          .MACRO param
                  .BYTE $D50D
		  .WORD  param
                  .ENDM
ORANopGa          .MACRO param
                  .BYTE $D60D
		  .WORD  param
                  .ENDM                  
ORANopHa          .MACRO param          
                  .BYTE $D70D
		  .WORD  param
                  .ENDM
ORANopIa          .MACRO param
                  .BYTE $E40D
		  .WORD  param
                  .ENDM
ORANopJa          .MACRO param
                  .BYTE $E50D
		  .WORD  param
                  .ENDM
ORANopKa          .MACRO param          
                  .BYTE $E60D
		  .WORD  param
                  .ENDM
ORANopLa          .MACRO param
                  .BYTE $E70D
		  .WORD  param
                  .ENDM
ORANopMa          .MACRO param
                  .BYTE $F40D
		  .WORD  param
                  .ENDM                  
ORANopNa          .MACRO param          
                  .BYTE $F50D
		  .WORD  param
                  .ENDM
ORANopOa          .MACRO param
                  .BYTE $F60D
		  .WORD  param
                  .ENDM
ORANopQa          .MACRO param
                  .BYTE $F70D
		  .WORD  param
                  .ENDM
            
ORAOopAa          .MACRO param
                  .BYTE $C80D
		  .WORD  param
                  .ENDM                
ORAOopBa          .MACRO param          
                  .BYTE $C90D
		  .WORD  param
                  .ENDM
ORAOopCa          .MACRO param
                  .BYTE $CA0D
		  .WORD  param
                  .ENDM
ORAOopDa          .MACRO param
                  .BYTE $CB0D
		  .WORD  param
                  .ENDM
ORAOopEa          .MACRO param          
                  .BYTE $D80D
		  .WORD  param
                  .ENDM
ORAOopFa          .MACRO param
                  .BYTE $D90D
		  .WORD  param
                  .ENDM
ORAOopGa          .MACRO param
                  .BYTE $DA0D
		  .WORD  param
                  .ENDM                  
ORAOopHa          .MACRO param          
                  .BYTE $DB0D
		  .WORD  param
                  .ENDM
ORAOopIa          .MACRO param
                  .BYTE $E80D
		  .WORD  param
                  .ENDM
ORAOopJa          .MACRO param
                  .BYTE $E90D
		  .WORD  param
                  .ENDM
ORAOopKa          .MACRO param          
                  .BYTE $EA0D
		  .WORD  param
                  .ENDM
ORAOopLa          .MACRO param
                  .BYTE $EB0D
		  .WORD  param
                  .ENDM
ORAOopMa          .MACRO param
                  .BYTE $F80D
		  .WORD  param
                  .ENDM                  
ORAOopNa          .MACRO param          
                  .BYTE $F90D
		  .WORD  param
                  .ENDM
ORAOopOa          .MACRO param
                  .BYTE $FA0D
		  .WORD  param
                  .ENDM
ORAOopQa          .MACRO param
                  .BYTE $FB0D
		  .WORD  param
                  .ENDM
                  
ORAQopAa          .MACRO param
                  .BYTE $CC0D
		  .WORD  param
                  .ENDM                
ORAQopBa          .MACRO param          
                  .BYTE $CD0D
		  .WORD  param
                  .ENDM
ORAQopCa          .MACRO param
                  .BYTE $CE0D
		  .WORD  param
                  .ENDM
ORAQopDa          .MACRO param
                  .BYTE $CF0D
		  .WORD  param
                  .ENDM
ORAQopEa          .MACRO param          
                  .BYTE $DC0D
		  .WORD  param
                  .ENDM
ORAQopFa          .MACRO param
                  .BYTE $DD0D
		  .WORD  param
                  .ENDM
ORAQopGa          .MACRO param
                  .BYTE $DE0D
		  .WORD  param
                  .ENDM                  
ORAQopHa          .MACRO param          
                  .BYTE $DF0D
		  .WORD  param
                  .ENDM
ORAQopIa          .MACRO param
                  .BYTE $EC0D
		  .WORD  param
                  .ENDM
ORAQopJa          .MACRO param
                  .BYTE $ED0D
		  .WORD  param
                  .ENDM
ORAQopKa          .MACRO param          
                  .BYTE $EE0D
		  .WORD  param
                  .ENDM
ORAQopLa          .MACRO param
                  .BYTE $EF0D
		  .WORD  param
                  .ENDM
ORAQopMa          .MACRO param
                  .BYTE $FC0D
		  .WORD  param
                  .ENDM                  
ORAQopNa          .MACRO param          
                  .BYTE $FD0D
		  .WORD  param
                  .ENDM
ORAQopOa          .MACRO param
                  .BYTE $FE0D
		  .WORD  param
                  .ENDM
ORAQopQa          .MACRO param
                  .BYTE $FF0D
		  .WORD  param
                  .ENDM

;AND $xxxxxxxx          $002D
ANDAopBa          .MACRO param          
                  .BYTE $012D
		  .WORD  param
                  .ENDM
ANDAopCa          .MACRO param
                  .BYTE $022D
		  .WORD  param
                  .ENDM
ANDAopDa          .MACRO param
                  .BYTE $032D
		  .WORD  param
                  .ENDM
ANDAopEa          .MACRO param          
                  .BYTE $102D
		  .WORD  param
                  .ENDM
ANDAopFa          .MACRO param
                  .BYTE $112D
		  .WORD  param
                  .ENDM
ANDAopGa          .MACRO param
                  .BYTE $122D
		  .WORD  param
                  .ENDM                  
ANDAopHa          .MACRO param          
                  .BYTE $132D
		  .WORD  param
                  .ENDM
ANDAopIa          .MACRO param
                  .BYTE $202D
		  .WORD  param
                  .ENDM
ANDAopJa          .MACRO param
                  .BYTE $212D
		  .WORD  param
                  .ENDM
ANDAopKa          .MACRO param          
                  .BYTE $222D
		  .WORD  param
                  .ENDM
ANDAopLa          .MACRO param
                  .BYTE $232D
		  .WORD  param
                  .ENDM
ANDAopMa          .MACRO param
                  .BYTE $302D
		  .WORD  param
                  .ENDM                  
ANDAopNa          .MACRO param          
                  .BYTE $312D
		  .WORD  param
                  .ENDM
ANDAopOa          .MACRO param
                  .BYTE $322D
		  .WORD  param
                  .ENDM
ANDAopQa          .MACRO param
                  .BYTE $332D
		  .WORD  param
                  .ENDM
                                    
ANDBopAa          .MACRO param
                  .BYTE $042D
		  .WORD  param
                  .ENDM                
ANDBopBa          .MACRO param          
                  .BYTE $052D
		  .WORD  param
                  .ENDM
ANDBopCa          .MACRO param
                  .BYTE $062D
		  .WORD  param
                  .ENDM
ANDBopDa          .MACRO param
                  .BYTE $072D
		  .WORD  param
                  .ENDM
ANDBopEa          .MACRO param          
                  .BYTE $142D
		  .WORD  param
                  .ENDM
ANDBopFa          .MACRO param
                  .BYTE $152D
		  .WORD  param
                  .ENDM
ANDBopGa          .MACRO param
                  .BYTE $162D
		  .WORD  param
                  .ENDM                  
ANDBopHa          .MACRO param          
                  .BYTE $172D
		  .WORD  param
                  .ENDM
ANDBopIa          .MACRO param
                  .BYTE $242D
		  .WORD  param
                  .ENDM
ANDBopJa          .MACRO param
                  .BYTE $252D
		  .WORD  param
                  .ENDM
ANDBopKa          .MACRO param          
                  .BYTE $262D
		  .WORD  param
                  .ENDM
ANDBopLa          .MACRO param
                  .BYTE $272D
		  .WORD  param
                  .ENDM
ANDBopMa          .MACRO param
                  .BYTE $302D
		  .WORD  param
                  .ENDM                  
ANDBopNa          .MACRO param          
                  .BYTE $312D
		  .WORD  param
                  .ENDM
ANDBopOa          .MACRO param
                  .BYTE $322D
		  .WORD  param
                  .ENDM
ANDBopQa          .MACRO param
                  .BYTE $332D
		  .WORD  param
                  .ENDM
                                    
ANDCopAa          .MACRO param
                  .BYTE $082D
		  .WORD  param
                  .ENDM                
ANDCopBa          .MACRO param          
                  .BYTE $092D
		  .WORD  param
                  .ENDM
ANDCopCa          .MACRO param
                  .BYTE $0A2D
		  .WORD  param
                  .ENDM
ANDCopDa          .MACRO param
                  .BYTE $0B2D
		  .WORD  param
                  .ENDM
ANDCopEa          .MACRO param          
                  .BYTE $182D
		  .WORD  param
                  .ENDM
ANDCopFa          .MACRO param
                  .BYTE $192D
		  .WORD  param
                  .ENDM
ANDCopGa          .MACRO param
                  .BYTE $1A2D
		  .WORD  param
                  .ENDM                  
ANDCopHa          .MACRO param          
                  .BYTE $1B2D
		  .WORD  param
                  .ENDM
ANDCopIa          .MACRO param
                  .BYTE $282D
		  .WORD  param
                  .ENDM
ANDCopJa          .MACRO param
                  .BYTE $292D
		  .WORD  param
                  .ENDM
ANDCopKa          .MACRO param          
                  .BYTE $2A2D
		  .WORD  param
                  .ENDM
ANDCopLa          .MACRO param
                  .BYTE $2B2D
		  .WORD  param
                  .ENDM
ANDCopMa          .MACRO param
                  .BYTE $382D
		  .WORD  param
                  .ENDM                  
ANDCopNa          .MACRO param          
                  .BYTE $392D
	 	  .WORD  param
                  .ENDM
ANDCopOa          .MACRO param
                  .BYTE $3A2D
		  .WORD  param
                  .ENDM
ANDCopQa          .MACRO param
                  .BYTE $3B2D
		  .WORD  param
                  .ENDM

ANDDopAa          .MACRO param
                  .BYTE $0C2D
		  .WORD  param
                  .ENDM                
ANDDopBa          .MACRO param          
                  .BYTE $0D2D
		  .WORD  param
                  .ENDM
ANDDopCa          .MACRO param
                  .BYTE $0E2D
		  .WORD  param
                  .ENDM
ANDDopDa          .MACRO param
                  .BYTE $0F2D
		  .WORD  param
                  .ENDM
ANDDopEa          .MACRO param          
                  .BYTE $1C2D
		  .WORD  param
                  .ENDM
ANDDopFa          .MACRO param
                  .BYTE $1D2D
		  .WORD  param
                  .ENDM
ANDDopGa          .MACRO param
                  .BYTE $1E2D
		  .WORD  param
                  .ENDM                  
ANDDopHa          .MACRO param          
                  .BYTE $1F2D
		  .WORD  param
                  .ENDM
ANDDopIa          .MACRO param
                  .BYTE $2C2D
		  .WORD  param
                  .ENDM
ANDDopJa          .MACRO param
                  .BYTE $2D2D
		  .WORD  param
                  .ENDM
ANDDopKa          .MACRO param          
                  .BYTE $2E2D
		  .WORD  param
                  .ENDM
ANDDopLa          .MACRO param
                  .BYTE $2F2D
		  .WORD  param
                  .ENDM
ANDDopMa          .MACRO param
                  .BYTE $3C2D
		  .WORD  param
                  .ENDM                  
ANDDopNa          .MACRO param          
                  .BYTE $3D2D
		  .WORD  param
                  .ENDM
ANDDopOa          .MACRO param
                  .BYTE $3E2D
		  .WORD  param
                  .ENDM
ANDDopQa          .MACRO param
                  .BYTE $3F2D
		  .WORD  param
                  .ENDM                  

ANDEopAa          .MACRO param
                  .BYTE $402D
		  .WORD  param
                  .ENDM                
ANDEopBa          .MACRO param          
                  .BYTE $412D
		  .WORD  param
                  .ENDM
ANDEopCa          .MACRO param
                  .BYTE $422D
		  .WORD  param
                  .ENDM
ANDEopDa          .MACRO param
                  .BYTE $432D
		  .WORD  param
                  .ENDM
ANDEopEa          .MACRO param          
                  .BYTE $502D
		  .WORD  param
                  .ENDM
ANDEopFa          .MACRO param
                  .BYTE $512D
		  .WORD  param
                  .ENDM
ANDEopGa          .MACRO param
                  .BYTE $522D
		  .WORD  param
                  .ENDM                  
ANDEopHa          .MACRO param          
                  .BYTE $532D
		  .WORD  param
                  .ENDM
ANDEopIa          .MACRO param
                  .BYTE $602D
		  .WORD  param
                  .ENDM
ANDEopJa          .MACRO param
                  .BYTE $612D
		  .WORD  param
                  .ENDM
ANDEopKa          .MACRO param          
                  .BYTE $622D
		  .WORD  param
                  .ENDM
ANDEopLa          .MACRO param
                  .BYTE $632D
		  .WORD  param
                  .ENDM
ANDEopMa          .MACRO param
                  .BYTE $702D
		  .WORD  param
                  .ENDM                  
ANDEopNa          .MACRO param          
                  .BYTE $712D
		  .WORD  param
                  .ENDM
ANDEopOa          .MACRO param
                  .BYTE $722D
		  .WORD  param
                  .ENDM
ANDEopQa          .MACRO param
                  .BYTE $732D
		  .WORD  param
                  .ENDM
                  
ANDFopAa          .MACRO param
                  .BYTE $442D
		  .WORD  param
                  .ENDM                
ANDFopBa          .MACRO param          
                  .BYTE $452D
		  .WORD  param
                  .ENDM
ANDFopCa          .MACRO param
                  .BYTE $462D
		  .WORD  param
                  .ENDM
ANDFopDa          .MACRO param
                  .BYTE $472D
		  .WORD  param
                  .ENDM
ANDFopEa          .MACRO param          
                  .BYTE $542D
		  .WORD  param
                  .ENDM
ANDFopFa          .MACRO param
                  .BYTE $552D
		  .WORD  param
                  .ENDM
ANDFopGa          .MACRO param
                  .BYTE $562D
		  .WORD  param
                  .ENDM                  
ANDFopHa          .MACRO param          
                  .BYTE $572D
		  .WORD  param
                  .ENDM
ANDFopIa          .MACRO param
                  .BYTE $642D
	 	  .WORD  param
                  .ENDM
ANDFopJa          .MACRO param
                  .BYTE $652D
		  .WORD  param
                  .ENDM
ANDFopKa          .MACRO param          
                  .BYTE $662D
		  .WORD  param
                  .ENDM
ANDFopLa          .MACRO param
                  .BYTE $672D
		  .WORD  param
                  .ENDM
ANDFopMa          .MACRO param
                  .BYTE $742D
		  .WORD  param
                  .ENDM                  
ANDFopNa          .MACRO param          
                  .BYTE $752D
		  .WORD  param
                  .ENDM
ANDFopOa          .MACRO param
                  .BYTE $762D
		  .WORD  param
                  .ENDM
ANDFopQa          .MACRO param
                  .BYTE $772D
		  .WORD  param
                  .ENDM                  
                           
ANDGopAa          .MACRO param
                  .BYTE $482D
		  .WORD  param
                  .ENDM                
ANDGopBa          .MACRO param          
                  .BYTE $492D
		  .WORD  param
                  .ENDM
ANDGopCa          .MACRO param
                  .BYTE $4A2D
		  .WORD  param
                  .ENDM
ANDGopDa          .MACRO param
                  .BYTE $4B2D
		  .WORD  param
                  .ENDM
ANDGopEa          .MACRO param          
                  .BYTE $582D
		  .WORD  param
                  .ENDM
ANDGopFa          .MACRO param
                  .BYTE $592D
		  .WORD  param
                  .ENDM
ANDGopGa          .MACRO param
                  .BYTE $5A2D
		  .WORD  param
                  .ENDM                  
ANDGopHa          .MACRO param          
                  .BYTE $5B2D
		  .WORD  param
                  .ENDM
ANDGopIa          .MACRO param
                  .BYTE $682D
		  .WORD  param
                  .ENDM
ANDGopJa          .MACRO param
                  .BYTE $692D
		  .WORD  param
                  .ENDM
ANDGopKa          .MACRO param          
                  .BYTE $6A2D
		  .WORD  param
                  .ENDM
ANDGopLa          .MACRO param
                  .BYTE $6B2D
		  .WORD  param
                  .ENDM
ANDGopMa          .MACRO param
                  .BYTE $782D
		  .WORD  param
                  .ENDM                  
ANDGopNa          .MACRO param          
                  .BYTE $792D
		  .WORD  param
                  .ENDM
ANDGopOa          .MACRO param
                  .BYTE $7A2D
		  .WORD  param
                  .ENDM
ANDGopQa          .MACRO param
                  .BYTE $7B2D
		  .WORD  param
                  .ENDM
                  
ANDHopAa          .MACRO param
                  .BYTE $4C2D
		  .WORD  param
                  .ENDM                
ANDHopBa          .MACRO param          
                  .BYTE $4D2D
		  .WORD  param
                  .ENDM
ANDHopCa          .MACRO param
                  .BYTE $4E2D
		  .WORD  param
                  .ENDM
ANDHopDa          .MACRO param
                  .BYTE $4F2D
		  .WORD  param
                  .ENDM
ANDHopEa          .MACRO param          
                  .BYTE $5C2D
		  .WORD  param
                  .ENDM
ANDHopFa          .MACRO param
                  .BYTE $5D2D
		  .WORD  param
                  .ENDM
ANDHopGa          .MACRO param
                  .BYTE $5E2D
		  .WORD  param
                  .ENDM                  
ANDHopHa          .MACRO param          
                  .BYTE $5F2D
		  .WORD  param
                  .ENDM
ANDHopIa          .MACRO param
                  .BYTE $6C2D
		  .WORD  param
                  .ENDM
ANDHopJa          .MACRO param
                  .BYTE $6D2D
		  .WORD  param
                  .ENDM
ANDHopKa          .MACRO param          
                  .BYTE $6E2D
		  .WORD  param
                  .ENDM
ANDHopLa          .MACRO param
                  .BYTE $6F2D
		  .WORD  param
                  .ENDM
ANDHopMa          .MACRO param
                  .BYTE $7C2D
		  .WORD  param
                  .ENDM                  
ANDHopNa          .MACRO param          
                  .BYTE $7D2D
		  .WORD  param
                  .ENDM
ANDHopOa          .MACRO param
                  .BYTE $7E2D
		  .WORD  param
                  .ENDM
ANDHopQa          .MACRO param
                  .BYTE $7F2D
		  .WORD  param
                  .ENDM
                  
ANDIopAa          .MACRO param
                  .BYTE $802D
		  .WORD  param
                  .ENDM                
ANDIopBa          .MACRO param          
                  .BYTE $812D
		  .WORD  param
                  .ENDM
ANDIopCa          .MACRO param
                  .BYTE $822D
		  .WORD  param
                  .ENDM
ANDIopDa          .MACRO param
                  .BYTE $832D
		  .WORD  param
                  .ENDM
ANDIopEa          .MACRO param          
                  .BYTE $902D
		  .WORD  param
                  .ENDM
ANDIopFa          .MACRO param
                  .BYTE $912D
		  .WORD  param
                  .ENDM
ANDIopGa          .MACRO param
                  .BYTE $922D
		  .WORD  param
                  .ENDM                  
ANDIopHa          .MACRO param          
                  .BYTE $932D
		  .WORD  param
                  .ENDM
ANDIopIa          .MACRO param
                  .BYTE $A02D
		  .WORD  param
                  .ENDM
ANDIopJa          .MACRO param
                  .BYTE $A12D
		  .WORD  param
                  .ENDM
ANDIopKa          .MACRO param          
                  .BYTE $A22D
		  .WORD  param
                  .ENDM
ANDIopLa          .MACRO param
                  .BYTE $A32D
		  .WORD  param
                  .ENDM
ANDIopMa          .MACRO param
                  .BYTE $B02D
		  .WORD  param
                  .ENDM                  
ANDIopNa          .MACRO param          
                  .BYTE $B12D
		  .WORD  param
                  .ENDM
ANDIopOa          .MACRO param
                  .BYTE $B22D
		  .WORD  param
                  .ENDM
ANDIopQa          .MACRO param
                  .BYTE $B32D
		  .WORD  param
                  .ENDM
                  
ANDJopAa          .MACRO param
                  .BYTE $842D
		  .WORD  param
                  .ENDM                
ANDJopBa          .MACRO param          
                  .BYTE $852D
		  .WORD  param
                  .ENDM
ANDJopCa          .MACRO param
                  .BYTE $862D
		  .WORD  param
                  .ENDM
ANDJopDa          .MACRO param
                  .BYTE $872D
		  .WORD  param
                  .ENDM
ANDJopEa          .MACRO param          
                  .BYTE $942D
		  .WORD  param
                  .ENDM
ANDJopFa          .MACRO param
                  .BYTE $952D
		  .WORD  param
                  .ENDM
ANDJopGa          .MACRO param
                  .BYTE $962D
		  .WORD  param
                  .ENDM                  
ANDJopHa          .MACRO param          
                  .BYTE $972D
		  .WORD  param
                  .ENDM
ANDJopIa          .MACRO param
                  .BYTE $A42D
		  .WORD  param
                  .ENDM
ANDJopJa          .MACRO param
                  .BYTE $A52D
		  .WORD  param
                  .ENDM
ANDJopKa          .MACRO param          
                  .BYTE $A62D
 		  .WORD  param
                  .ENDM
ANDJopLa          .MACRO param
                  .BYTE $A72D
		  .WORD  param
                  .ENDM
ANDJopMa          .MACRO param
                  .BYTE $B42D
		  .WORD  param
                  .ENDM                  
ANDJopNa          .MACRO param          
                  .BYTE $B52D
		  .WORD  param
                  .ENDM
ANDJopOa          .MACRO param
                  .BYTE $B62D
		  .WORD  param
                  .ENDM
ANDJopQa          .MACRO param
                  .BYTE $B72D
		  .WORD  param
                  .ENDM
                  
ANDKopAa          .MACRO param
                  .BYTE $882D
		  .WORD  param
                  .ENDM                
ANDKopBa          .MACRO param          
                  .BYTE $892D
		  .WORD  param
                  .ENDM
ANDKopCa          .MACRO param
                  .BYTE $8A2D
		  .WORD  param
                  .ENDM
ANDKopDa          .MACRO param
                  .BYTE $8B2D
		  .WORD  param
                  .ENDM
ANDKopEa          .MACRO param          
                  .BYTE $982D
		  .WORD  param
                  .ENDM
ANDKopFa          .MACRO param
                  .BYTE $992D
		  .WORD  param
                  .ENDM
ANDKopGa          .MACRO param
                  .BYTE $9A2D
		  .WORD  param
                  .ENDM                  
ANDKopHa          .MACRO param          
                  .BYTE $9B2D
		  .WORD  param
                  .ENDM
ANDKopIa          .MACRO param
                  .BYTE $A82D
		  .WORD  param
                  .ENDM
ANDKopJa          .MACRO param
                  .BYTE $A92D
		  .WORD  param
                  .ENDM
ANDKopKa          .MACRO param          
                  .BYTE $AA2D
		  .WORD  param
                  .ENDM
ANDKopLa          .MACRO param
                  .BYTE $AB2D
		  .WORD  param
                  .ENDM
ANDKopMa          .MACRO param
                  .BYTE $B82D
		  .WORD  param
                  .ENDM                  
ANDKopNa          .MACRO param          
                  .BYTE $B92D
		  .WORD  param
                  .ENDM
ANDKopOa          .MACRO param
                  .BYTE $BA2D
		  .WORD  param
                  .ENDM
ANDKopQa          .MACRO param
                  .BYTE $BB2D
		  .WORD  param
                  .ENDM
                  
ANDLopAa          .MACRO param
                  .BYTE $8C2D
		  .WORD  param
                  .ENDM                
ANDLopBa          .MACRO param          
                  .BYTE $8D2D
		  .WORD  param
                  .ENDM
ANDLopCa          .MACRO param
                  .BYTE $8E2D
		  .WORD  param
                  .ENDM
ANDLopDa          .MACRO param
                  .BYTE $8F2D
		  .WORD  param
                  .ENDM
ANDLopEa          .MACRO param          
                  .BYTE $9C2D
		  .WORD  param
                  .ENDM
ANDLopFa          .MACRO param
                  .BYTE $9D2D
		  .WORD  param
                  .ENDM
ANDLopGa          .MACRO param
                  .BYTE $9E2D
		  .WORD  param
                  .ENDM                  
ANDLopHa          .MACRO param          
                  .BYTE $9F2D
		  .WORD  param
                  .ENDM
ANDLopIa          .MACRO param
                  .BYTE $AC2D
		  .WORD  param
                  .ENDM
ANDLopJa          .MACRO param
                  .BYTE $AD2D
		  .WORD  param
                  .ENDM
ANDLopKa          .MACRO param          
                  .BYTE $AE2D
		  .WORD  param
                  .ENDM
ANDLopLa          .MACRO param
                  .BYTE $AF2D
		  .WORD  param
                  .ENDM
ANDLopMa          .MACRO param
                  .BYTE $BC2D
		  .WORD  param
                  .ENDM                  
ANDLopNa          .MACRO param          
                  .BYTE $BD2D
		  .WORD  param
                  .ENDM
ANDLopOa          .MACRO param
                  .BYTE $BE2D
		  .WORD  param
                  .ENDM
ANDLopQa          .MACRO param
                  .BYTE $BF2D
		  .WORD  param
                  .ENDM
                  
ANDMopAa          .MACRO param
                  .BYTE $C02D
		  .WORD  param
                  .ENDM                
ANDMopBa          .MACRO param          
                  .BYTE $C12D
		  .WORD  param
                  .ENDM
ANDMopCa          .MACRO param
                  .BYTE $C22D
		  .WORD  param
                  .ENDM
ANDMopDa          .MACRO param
                  .BYTE $C32D
		  .WORD  param
                  .ENDM
ANDMopEa          .MACRO param          
                  .BYTE $D02D
		  .WORD  param
                  .ENDM
ANDMopFa          .MACRO param
                  .BYTE $D12D
		  .WORD  param
                  .ENDM
ANDMopGa          .MACRO param
                  .BYTE $D22D
		  .WORD  param
                  .ENDM                  
ANDMopHa          .MACRO param          
                  .BYTE $D32D
		  .WORD  param
                  .ENDM
ANDMopIa          .MACRO param
                  .BYTE $E02D
		  .WORD  param
                  .ENDM
ANDMopJa          .MACRO param
                  .BYTE $E12D
		  .WORD  param
                  .ENDM
ANDMopKa          .MACRO param          
                  .BYTE $E22D
		  .WORD  param
                  .ENDM
ANDMopLa          .MACRO param
                  .BYTE $E32D
		  .WORD  param
                  .ENDM
ANDMopMa          .MACRO param
                  .BYTE $F02D
		  .WORD  param
                  .ENDM                  
ANDMopNa          .MACRO param          
                  .BYTE $F12D
		  .WORD  param
                  .ENDM
ANDMopOa          .MACRO param
                  .BYTE $F22D
		  .WORD  param
                  .ENDM
ANDMopQa          .MACRO param
                  .BYTE $F32D
		  .WORD  param
                  .ENDM
                  
ANDNopAa          .MACRO param
                  .BYTE $C42D
		  .WORD  param
                  .ENDM                
ANDNopBa          .MACRO param          
                  .BYTE $C52D
		  .WORD  param
                  .ENDM
ANDNopCa          .MACRO param
                  .BYTE $C62D
		  .WORD  param
                  .ENDM
ANDNopDa          .MACRO param
                  .BYTE $C72D
		  .WORD  param
                  .ENDM
ANDNopEa          .MACRO param          
                  .BYTE $D42D
		  .WORD  param
                  .ENDM
ANDNopFa          .MACRO param
                  .BYTE $D52D
		  .WORD  param
                  .ENDM
ANDNopGa          .MACRO param
                  .BYTE $D62D
		  .WORD  param
                  .ENDM                  
ANDNopHa          .MACRO param          
                  .BYTE $D72D
		  .WORD  param
                  .ENDM
ANDNopIa          .MACRO param
                  .BYTE $E42D
		  .WORD  param
                  .ENDM
ANDNopJa          .MACRO param
                  .BYTE $E52D
		  .WORD  param
                  .ENDM
ANDNopKa          .MACRO param          
                  .BYTE $E62D
		  .WORD  param
                  .ENDM
ANDNopLa          .MACRO param
                  .BYTE $E72D
		  .WORD  param
                  .ENDM
ANDNopMa          .MACRO param
                  .BYTE $F42D
		  .WORD  param
                  .ENDM                  
ANDNopNa          .MACRO param          
                  .BYTE $F52D
		  .WORD  param
                  .ENDM
ANDNopOa          .MACRO param
                  .BYTE $F62D
		  .WORD  param
                  .ENDM
ANDNopQa          .MACRO param
                  .BYTE $F72D
		  .WORD  param
                  .ENDM
            
ANDOopAa          .MACRO param
                  .BYTE $C82D
		  .WORD  param
                  .ENDM                
ANDOopBa          .MACRO param          
                  .BYTE $C92D
		  .WORD  param
                  .ENDM
ANDOopCa          .MACRO param
                  .BYTE $CA2D
		  .WORD  param
                  .ENDM
ANDOopDa          .MACRO param
                  .BYTE $CB2D
		  .WORD  param
                  .ENDM
ANDOopEa          .MACRO param          
                  .BYTE $D82D
		  .WORD  param
                  .ENDM
ANDOopFa          .MACRO param
                  .BYTE $D92D
		  .WORD  param
                  .ENDM
ANDOopGa          .MACRO param
                  .BYTE $DA2D
		  .WORD  param
                  .ENDM                  
ANDOopHa          .MACRO param          
                  .BYTE $DB2D
		  .WORD  param
                  .ENDM
ANDOopIa          .MACRO param
                  .BYTE $E82D
		  .WORD  param
                  .ENDM
ANDOopJa          .MACRO param
                  .BYTE $E92D
		  .WORD  param
                  .ENDM
ANDOopKa          .MACRO param          
                  .BYTE $EA2D
		  .WORD  param
                  .ENDM
ANDOopLa          .MACRO param
                  .BYTE $EB2D
		  .WORD  param
                  .ENDM
ANDOopMa          .MACRO param
                  .BYTE $F82D
		  .WORD  param
                  .ENDM                  
ANDOopNa          .MACRO param          
                  .BYTE $F92D
		  .WORD  param
                  .ENDM
ANDOopOa          .MACRO param
                  .BYTE $FA2D
		  .WORD  param
                  .ENDM
ANDOopQa          .MACRO param
                  .BYTE $FB2D
		  .WORD  param
                  .ENDM
                  
ANDQopAa          .MACRO param
                  .BYTE $CC2D
		  .WORD  param
                  .ENDM                
ANDQopBa          .MACRO param          
                  .BYTE $CD2D
		  .WORD  param
                  .ENDM
ANDQopCa          .MACRO param
                  .BYTE $CE2D
		  .WORD  param
                  .ENDM
ANDQopDa          .MACRO param
                  .BYTE $CF2D
		  .WORD  param
                  .ENDM
ANDQopEa          .MACRO param          
                  .BYTE $DC2D
		  .WORD  param
                  .ENDM
ANDQopFa          .MACRO param
                  .BYTE $DD2D
		  .WORD  param
                  .ENDM
ANDQopGa          .MACRO param
                  .BYTE $DE2D
		  .WORD  param
                  .ENDM                  
ANDQopHa          .MACRO param          
                  .BYTE $DF2D
		  .WORD  param
                  .ENDM
ANDQopIa          .MACRO param
                  .BYTE $EC2D
		  .WORD  param
                  .ENDM
ANDQopJa          .MACRO param
                  .BYTE $ED2D
		  .WORD  param
                  .ENDM
ANDQopKa          .MACRO param          
                  .BYTE $EE2D
		  .WORD  param
                  .ENDM
ANDQopLa          .MACRO param
                  .BYTE $EF2D
		  .WORD  param
                  .ENDM
ANDQopMa          .MACRO param
                  .BYTE $FC2D
		  .WORD  param
                  .ENDM                  
ANDQopNa          .MACRO param          
                  .BYTE $FD2D
		  .WORD  param
                  .ENDM
ANDQopOa          .MACRO param
                  .BYTE $FE2D
		  .WORD  param
                  .ENDM
ANDQopQa          .MACRO param
                  .BYTE $FF2D
		  .WORD  param
                  .ENDM

;EOR $xxxxxxxx          $004D
EORAopBa          .MACRO param          
                  .BYTE $014D
		  .WORD  param
                  .ENDM
EORAopCa          .MACRO param
                  .BYTE $024D
		  .WORD  param
                  .ENDM
EORAopDa          .MACRO param
                  .BYTE $034D
		  .WORD  param
                  .ENDM
EORAopEa          .MACRO param          
                  .BYTE $104D
		  .WORD  param
                  .ENDM
EORAopFa          .MACRO param
                  .BYTE $114D
		  .WORD  param
                  .ENDM
EORAopGa          .MACRO param
                  .BYTE $124D
		  .WORD  param
                  .ENDM                  
EORAopHa          .MACRO param          
                  .BYTE $134D
		  .WORD  param
                  .ENDM
EORAopIa          .MACRO param
                  .BYTE $204D
		  .WORD  param
                  .ENDM
EORAopJa          .MACRO param
                  .BYTE $214D
		  .WORD  param
                  .ENDM
EORAopKa          .MACRO param          
                  .BYTE $224D
		  .WORD  param
                  .ENDM
EORAopLa          .MACRO param
                  .BYTE $234D
		  .WORD  param
                  .ENDM
EORAopMa          .MACRO param
                  .BYTE $304D
		  .WORD  param
                  .ENDM                  
EORAopNa          .MACRO param          
                  .BYTE $314D
		  .WORD  param
                  .ENDM
EORAopOa          .MACRO param
                  .BYTE $324D
		  .WORD  param
                  .ENDM
EORAopQa          .MACRO param
                  .BYTE $334D
		  .WORD  param
                  .ENDM
                                    
EORBopAa          .MACRO param
                  .BYTE $044D
		  .WORD  param
                  .ENDM                
EORBopBa          .MACRO param          
                  .BYTE $054D
		  .WORD  param
                  .ENDM
EORBopCa          .MACRO param
                  .BYTE $064D
		  .WORD  param
                  .ENDM
EORBopDa          .MACRO param
                  .BYTE $074D
		  .WORD  param
                  .ENDM
EORBopEa          .MACRO param          
                  .BYTE $144D
		  .WORD  param
                  .ENDM
EORBopFa          .MACRO param
                  .BYTE $154D
		  .WORD  param
                  .ENDM
EORBopGa          .MACRO param
                  .BYTE $164D
		  .WORD  param
                  .ENDM                  
EORBopHa          .MACRO param          
                  .BYTE $174D
		  .WORD  param
                  .ENDM
EORBopIa          .MACRO param
                  .BYTE $244D
		  .WORD  param
                  .ENDM
EORBopJa          .MACRO param
                  .BYTE $254D
		  .WORD  param
                  .ENDM
EORBopKa          .MACRO param          
                  .BYTE $264D
		  .WORD  param
                  .ENDM
EORBopLa          .MACRO param
                  .BYTE $274D
		  .WORD  param
                  .ENDM
EORBopMa          .MACRO param
                  .BYTE $304D
		  .WORD  param
                  .ENDM                  
EORBopNa          .MACRO param          
                  .BYTE $314D
		  .WORD  param
                  .ENDM
EORBopOa          .MACRO param
                  .BYTE $324D
		  .WORD  param
                  .ENDM
EORBopQa          .MACRO param
                  .BYTE $334D
		  .WORD  param
                  .ENDM
                                    
EORCopAa          .MACRO param
                  .BYTE $084D
		  .WORD  param
                  .ENDM                
EORCopBa          .MACRO param          
                  .BYTE $094D
		  .WORD  param
                  .ENDM
EORCopCa          .MACRO param
                  .BYTE $0A4D
		  .WORD  param
                  .ENDM
EORCopDa          .MACRO param
                  .BYTE $0B4D
		  .WORD  param
                  .ENDM
EORCopEa          .MACRO param          
                  .BYTE $184D
		  .WORD  param
                  .ENDM
EORCopFa          .MACRO param
                  .BYTE $194D
		  .WORD  param
                  .ENDM
EORCopGa          .MACRO param
                  .BYTE $1A4D
		  .WORD  param
                  .ENDM                  
EORCopHa          .MACRO param          
                  .BYTE $1B4D
		  .WORD  param
                  .ENDM
EORCopIa          .MACRO param
                  .BYTE $284D
		  .WORD  param
                  .ENDM
EORCopJa          .MACRO param
                  .BYTE $294D
		  .WORD  param
                  .ENDM
EORCopKa          .MACRO param          
                  .BYTE $2A4D
		  .WORD  param
                  .ENDM
EORCopLa          .MACRO param
                  .BYTE $2B4D
		  .WORD  param
                  .ENDM
EORCopMa          .MACRO param
                  .BYTE $384D
		  .WORD  param
                  .ENDM                  
EORCopNa          .MACRO param          
                  .BYTE $394D
	 	  .WORD  param
                  .ENDM
EORCopOa          .MACRO param
                  .BYTE $3A4D
		  .WORD  param
                  .ENDM
EORCopQa          .MACRO param
                  .BYTE $3B4D
		  .WORD  param
                  .ENDM

EORDopAa          .MACRO param
                  .BYTE $0C4D
		  .WORD  param
                  .ENDM                
EORDopBa          .MACRO param          
                  .BYTE $0D4D
		  .WORD  param
                  .ENDM
EORDopCa          .MACRO param
                  .BYTE $0E4D
		  .WORD  param
                  .ENDM
EORDopDa          .MACRO param
                  .BYTE $0F4D
		  .WORD  param
                  .ENDM
EORDopEa          .MACRO param          
                  .BYTE $1C4D
		  .WORD  param
                  .ENDM
EORDopFa          .MACRO param
                  .BYTE $1D4D
		  .WORD  param
                  .ENDM
EORDopGa          .MACRO param
                  .BYTE $1E4D
		  .WORD  param
                  .ENDM                  
EORDopHa          .MACRO param          
                  .BYTE $1F4D
		  .WORD  param
                  .ENDM
EORDopIa          .MACRO param
                  .BYTE $2C4D
		  .WORD  param
                  .ENDM
EORDopJa          .MACRO param
                  .BYTE $2D4D
		  .WORD  param
                  .ENDM
EORDopKa          .MACRO param          
                  .BYTE $2E4D
		  .WORD  param
                  .ENDM
EORDopLa          .MACRO param
                  .BYTE $2F4D
		  .WORD  param
                  .ENDM
EORDopMa          .MACRO param
                  .BYTE $3C4D
		  .WORD  param
                  .ENDM                  
EORDopNa          .MACRO param          
                  .BYTE $3D4D
		  .WORD  param
                  .ENDM
EORDopOa          .MACRO param
                  .BYTE $3E4D
		  .WORD  param
                  .ENDM
EORDopQa          .MACRO param
                  .BYTE $3F4D
		  .WORD  param
                  .ENDM                  

EOREopAa          .MACRO param
                  .BYTE $404D
		  .WORD  param
                  .ENDM                
EOREopBa          .MACRO param          
                  .BYTE $414D
		  .WORD  param
                  .ENDM
EOREopCa          .MACRO param
                  .BYTE $424D
		  .WORD  param
                  .ENDM
EOREopDa          .MACRO param
                  .BYTE $434D
		  .WORD  param
                  .ENDM
EOREopEa          .MACRO param          
                  .BYTE $504D
		  .WORD  param
                  .ENDM
EOREopFa          .MACRO param
                  .BYTE $514D
		  .WORD  param
                  .ENDM
EOREopGa          .MACRO param
                  .BYTE $524D
		  .WORD  param
                  .ENDM                  
EOREopHa          .MACRO param          
                  .BYTE $534D
		  .WORD  param
                  .ENDM
EOREopIa          .MACRO param
                  .BYTE $604D
		  .WORD  param
                  .ENDM
EOREopJa          .MACRO param
                  .BYTE $614D
		  .WORD  param
                  .ENDM
EOREopKa          .MACRO param          
                  .BYTE $624D
		  .WORD  param
                  .ENDM
EOREopLa          .MACRO param
                  .BYTE $634D
		  .WORD  param
                  .ENDM
EOREopMa          .MACRO param
                  .BYTE $704D
		  .WORD  param
                  .ENDM                  
EOREopNa          .MACRO param          
                  .BYTE $714D
		  .WORD  param
                  .ENDM
EOREopOa          .MACRO param
                  .BYTE $724D
		  .WORD  param
                  .ENDM
EOREopQa          .MACRO param
                  .BYTE $734D
		  .WORD  param
                  .ENDM
                  
EORFopAa          .MACRO param
                  .BYTE $444D
		  .WORD  param
                  .ENDM                
EORFopBa          .MACRO param          
                  .BYTE $454D
		  .WORD  param
                  .ENDM
EORFopCa          .MACRO param
                  .BYTE $464D
		  .WORD  param
                  .ENDM
EORFopDa          .MACRO param
                  .BYTE $474D
		  .WORD  param
                  .ENDM
EORFopEa          .MACRO param          
                  .BYTE $544D
		  .WORD  param
                  .ENDM
EORFopFa          .MACRO param
                  .BYTE $554D
		  .WORD  param
                  .ENDM
EORFopGa          .MACRO param
                  .BYTE $564D
		  .WORD  param
                  .ENDM                  
EORFopHa          .MACRO param          
                  .BYTE $574D
		  .WORD  param
                  .ENDM
EORFopIa          .MACRO param
                  .BYTE $644D
	 	  .WORD  param
                  .ENDM
EORFopJa          .MACRO param
                  .BYTE $654D
		  .WORD  param
                  .ENDM
EORFopKa          .MACRO param          
                  .BYTE $664D
		  .WORD  param
                  .ENDM
EORFopLa          .MACRO param
                  .BYTE $674D
		  .WORD  param
                  .ENDM
EORFopMa          .MACRO param
                  .BYTE $744D
		  .WORD  param
                  .ENDM                  
EORFopNa          .MACRO param          
                  .BYTE $754D
		  .WORD  param
                  .ENDM
EORFopOa          .MACRO param
                  .BYTE $764D
		  .WORD  param
                  .ENDM
EORFopQa          .MACRO param
                  .BYTE $774D
		  .WORD  param
                  .ENDM                  
                           
EORGopAa          .MACRO param
                  .BYTE $484D
		  .WORD  param
                  .ENDM                
EORGopBa          .MACRO param          
                  .BYTE $494D
		  .WORD  param
                  .ENDM
EORGopCa          .MACRO param
                  .BYTE $4A4D
		  .WORD  param
                  .ENDM
EORGopDa          .MACRO param
                  .BYTE $4B4D
		  .WORD  param
                  .ENDM
EORGopEa          .MACRO param          
                  .BYTE $584D
		  .WORD  param
                  .ENDM
EORGopFa          .MACRO param
                  .BYTE $594D
		  .WORD  param
                  .ENDM
EORGopGa          .MACRO param
                  .BYTE $5A4D
		  .WORD  param
                  .ENDM                  
EORGopHa          .MACRO param          
                  .BYTE $5B4D
		  .WORD  param
                  .ENDM
EORGopIa          .MACRO param
                  .BYTE $684D
		  .WORD  param
                  .ENDM
EORGopJa          .MACRO param
                  .BYTE $694D
		  .WORD  param
                  .ENDM
EORGopKa          .MACRO param          
                  .BYTE $6A4D
		  .WORD  param
                  .ENDM
EORGopLa          .MACRO param
                  .BYTE $6B4D
		  .WORD  param
                  .ENDM
EORGopMa          .MACRO param
                  .BYTE $784D
		  .WORD  param
                  .ENDM                  
EORGopNa          .MACRO param          
                  .BYTE $794D
		  .WORD  param
                  .ENDM
EORGopOa          .MACRO param
                  .BYTE $7A4D
		  .WORD  param
                  .ENDM
EORGopQa          .MACRO param
                  .BYTE $7B4D
		  .WORD  param
                  .ENDM
                  
EORHopAa          .MACRO param
                  .BYTE $4C4D
		  .WORD  param
                  .ENDM                
EORHopBa          .MACRO param          
                  .BYTE $4D4D
		  .WORD  param
                  .ENDM
EORHopCa          .MACRO param
                  .BYTE $4E4D
		  .WORD  param
                  .ENDM
EORHopDa          .MACRO param
                  .BYTE $4F4D
		  .WORD  param
                  .ENDM
EORHopEa          .MACRO param          
                  .BYTE $5C4D
		  .WORD  param
                  .ENDM
EORHopFa          .MACRO param
                  .BYTE $5D4D
		  .WORD  param
                  .ENDM
EORHopGa          .MACRO param
                  .BYTE $5E4D
		  .WORD  param
                  .ENDM                  
EORHopHa          .MACRO param          
                  .BYTE $5F4D
		  .WORD  param
                  .ENDM
EORHopIa          .MACRO param
                  .BYTE $6C4D
		  .WORD  param
                  .ENDM
EORHopJa          .MACRO param
                  .BYTE $6D4D
		  .WORD  param
                  .ENDM
EORHopKa          .MACRO param          
                  .BYTE $6E4D
		  .WORD  param
                  .ENDM
EORHopLa          .MACRO param
                  .BYTE $6F4D
		  .WORD  param
                  .ENDM
EORHopMa          .MACRO param
                  .BYTE $7C4D
		  .WORD  param
                  .ENDM                  
EORHopNa          .MACRO param          
                  .BYTE $7D4D
		  .WORD  param
                  .ENDM
EORHopOa          .MACRO param
                  .BYTE $7E4D
		  .WORD  param
                  .ENDM
EORHopQa          .MACRO param
                  .BYTE $7F4D
		  .WORD  param
                  .ENDM
                  
EORIopAa          .MACRO param
                  .BYTE $804D
		  .WORD  param
                  .ENDM                
EORIopBa          .MACRO param          
                  .BYTE $814D
		  .WORD  param
                  .ENDM
EORIopCa          .MACRO param
                  .BYTE $824D
		  .WORD  param
                  .ENDM
EORIopDa          .MACRO param
                  .BYTE $834D
		  .WORD  param
                  .ENDM
EORIopEa          .MACRO param          
                  .BYTE $904D
		  .WORD  param
                  .ENDM
EORIopFa          .MACRO param
                  .BYTE $914D
		  .WORD  param
                  .ENDM
EORIopGa          .MACRO param
                  .BYTE $924D
		  .WORD  param
                  .ENDM                  
EORIopHa          .MACRO param          
                  .BYTE $934D
		  .WORD  param
                  .ENDM
EORIopIa          .MACRO param
                  .BYTE $A04D
		  .WORD  param
                  .ENDM
EORIopJa          .MACRO param
                  .BYTE $A14D
		  .WORD  param
                  .ENDM
EORIopKa          .MACRO param          
                  .BYTE $A24D
		  .WORD  param
                  .ENDM
EORIopLa          .MACRO param
                  .BYTE $A34D
		  .WORD  param
                  .ENDM
EORIopMa          .MACRO param
                  .BYTE $B04D
		  .WORD  param
                  .ENDM                  
EORIopNa          .MACRO param          
                  .BYTE $B14D
		  .WORD  param
                  .ENDM
EORIopOa          .MACRO param
                  .BYTE $B24D
		  .WORD  param
                  .ENDM
EORIopQa          .MACRO param
                  .BYTE $B34D
		  .WORD  param
                  .ENDM
                  
EORJopAa          .MACRO param
                  .BYTE $844D
		  .WORD  param
                  .ENDM                
EORJopBa          .MACRO param          
                  .BYTE $854D
		  .WORD  param
                  .ENDM
EORJopCa          .MACRO param
                  .BYTE $864D
		  .WORD  param
                  .ENDM
EORJopDa          .MACRO param
                  .BYTE $874D
		  .WORD  param
                  .ENDM
EORJopEa          .MACRO param          
                  .BYTE $944D
		  .WORD  param
                  .ENDM
EORJopFa          .MACRO param
                  .BYTE $954D
		  .WORD  param
                  .ENDM
EORJopGa          .MACRO param
                  .BYTE $964D
		  .WORD  param
                  .ENDM                  
EORJopHa          .MACRO param          
                  .BYTE $974D
		  .WORD  param
                  .ENDM
EORJopIa          .MACRO param
                  .BYTE $A44D
		  .WORD  param
                  .ENDM
EORJopJa          .MACRO param
                  .BYTE $A54D
		  .WORD  param
                  .ENDM
EORJopKa          .MACRO param          
                  .BYTE $A64D
 		  .WORD  param
                  .ENDM
EORJopLa          .MACRO param
                  .BYTE $A74D
		  .WORD  param
                  .ENDM
EORJopMa          .MACRO param
                  .BYTE $B44D
		  .WORD  param
                  .ENDM                  
EORJopNa          .MACRO param          
                  .BYTE $B54D
		  .WORD  param
                  .ENDM
EORJopOa          .MACRO param
                  .BYTE $B64D
		  .WORD  param
                  .ENDM
EORJopQa          .MACRO param
                  .BYTE $B74D
		  .WORD  param
                  .ENDM
                  
EORKopAa          .MACRO param
                  .BYTE $884D
		  .WORD  param
                  .ENDM                
EORKopBa          .MACRO param          
                  .BYTE $894D
		  .WORD  param
                  .ENDM
EORKopCa          .MACRO param
                  .BYTE $8A4D
		  .WORD  param
                  .ENDM
EORKopDa          .MACRO param
                  .BYTE $8B4D
		  .WORD  param
                  .ENDM
EORKopEa          .MACRO param          
                  .BYTE $984D
		  .WORD  param
                  .ENDM
EORKopFa          .MACRO param
                  .BYTE $994D
		  .WORD  param
                  .ENDM
EORKopGa          .MACRO param
                  .BYTE $9A4D
		  .WORD  param
                  .ENDM                  
EORKopHa          .MACRO param          
                  .BYTE $9B4D
		  .WORD  param
                  .ENDM
EORKopIa          .MACRO param
                  .BYTE $A84D
		  .WORD  param
                  .ENDM
EORKopJa          .MACRO param
                  .BYTE $A94D
		  .WORD  param
                  .ENDM
EORKopKa          .MACRO param          
                  .BYTE $AA4D
		  .WORD  param
                  .ENDM
EORKopLa          .MACRO param
                  .BYTE $AB4D
		  .WORD  param
                  .ENDM
EORKopMa          .MACRO param
                  .BYTE $B84D
		  .WORD  param
                  .ENDM                  
EORKopNa          .MACRO param          
                  .BYTE $B94D
		  .WORD  param
                  .ENDM
EORKopOa          .MACRO param
                  .BYTE $BA4D
		  .WORD  param
                  .ENDM
EORKopQa          .MACRO param
                  .BYTE $BB4D
		  .WORD  param
                  .ENDM
                  
EORLopAa          .MACRO param
                  .BYTE $8C4D
		  .WORD  param
                  .ENDM                
EORLopBa          .MACRO param          
                  .BYTE $8D4D
		  .WORD  param
                  .ENDM
EORLopCa          .MACRO param
                  .BYTE $8E4D
		  .WORD  param
                  .ENDM
EORLopDa          .MACRO param
                  .BYTE $8F4D
		  .WORD  param
                  .ENDM
EORLopEa          .MACRO param          
                  .BYTE $9C4D
		  .WORD  param
                  .ENDM
EORLopFa          .MACRO param
                  .BYTE $9D4D
		  .WORD  param
                  .ENDM
EORLopGa          .MACRO param
                  .BYTE $9E4D
		  .WORD  param
                  .ENDM                  
EORLopHa          .MACRO param          
                  .BYTE $9F4D
		  .WORD  param
                  .ENDM
EORLopIa          .MACRO param
                  .BYTE $AC4D
		  .WORD  param
                  .ENDM
EORLopJa          .MACRO param
                  .BYTE $AD4D
		  .WORD  param
                  .ENDM
EORLopKa          .MACRO param          
                  .BYTE $AE4D
		  .WORD  param
                  .ENDM
EORLopLa          .MACRO param
                  .BYTE $AF4D
		  .WORD  param
                  .ENDM
EORLopMa          .MACRO param
                  .BYTE $BC4D
		  .WORD  param
                  .ENDM                  
EORLopNa          .MACRO param          
                  .BYTE $BD4D
		  .WORD  param
                  .ENDM
EORLopOa          .MACRO param
                  .BYTE $BE4D
		  .WORD  param
                  .ENDM
EORLopQa          .MACRO param
                  .BYTE $BF4D
		  .WORD  param
                  .ENDM
                  
EORMopAa          .MACRO param
                  .BYTE $C04D
		  .WORD  param
                  .ENDM                
EORMopBa          .MACRO param          
                  .BYTE $C14D
		  .WORD  param
                  .ENDM
EORMopCa          .MACRO param
                  .BYTE $C24D
		  .WORD  param
                  .ENDM
EORMopDa          .MACRO param
                  .BYTE $C34D
		  .WORD  param
                  .ENDM
EORMopEa          .MACRO param          
                  .BYTE $D04D
		  .WORD  param
                  .ENDM
EORMopFa          .MACRO param
                  .BYTE $D14D
		  .WORD  param
                  .ENDM
EORMopGa          .MACRO param
                  .BYTE $D24D
		  .WORD  param
                  .ENDM                  
EORMopHa          .MACRO param          
                  .BYTE $D34D
		  .WORD  param
                  .ENDM
EORMopIa          .MACRO param
                  .BYTE $E04D
		  .WORD  param
                  .ENDM
EORMopJa          .MACRO param
                  .BYTE $E14D
		  .WORD  param
                  .ENDM
EORMopKa          .MACRO param          
                  .BYTE $E24D
		  .WORD  param
                  .ENDM
EORMopLa          .MACRO param
                  .BYTE $E34D
		  .WORD  param
                  .ENDM
EORMopMa          .MACRO param
                  .BYTE $F04D
		  .WORD  param
                  .ENDM                  
EORMopNa          .MACRO param          
                  .BYTE $F14D
		  .WORD  param
                  .ENDM
EORMopOa          .MACRO param
                  .BYTE $F24D
		  .WORD  param
                  .ENDM
EORMopQa          .MACRO param
                  .BYTE $F34D
		  .WORD  param
                  .ENDM
                  
EORNopAa          .MACRO param
                  .BYTE $C44D
		  .WORD  param
                  .ENDM                
EORNopBa          .MACRO param          
                  .BYTE $C54D
		  .WORD  param
                  .ENDM
EORNopCa          .MACRO param
                  .BYTE $C64D
		  .WORD  param
                  .ENDM
EORNopDa          .MACRO param
                  .BYTE $C74D
		  .WORD  param
                  .ENDM
EORNopEa          .MACRO param          
                  .BYTE $D44D
		  .WORD  param
                  .ENDM
EORNopFa          .MACRO param
                  .BYTE $D54D
		  .WORD  param
                  .ENDM
EORNopGa          .MACRO param
                  .BYTE $D64D
		  .WORD  param
                  .ENDM                  
EORNopHa          .MACRO param          
                  .BYTE $D74D
		  .WORD  param
                  .ENDM
EORNopIa          .MACRO param
                  .BYTE $E44D
		  .WORD  param
                  .ENDM
EORNopJa          .MACRO param
                  .BYTE $E54D
		  .WORD  param
                  .ENDM
EORNopKa          .MACRO param          
                  .BYTE $E64D
		  .WORD  param
                  .ENDM
EORNopLa          .MACRO param
                  .BYTE $E74D
		  .WORD  param
                  .ENDM
EORNopMa          .MACRO param
                  .BYTE $F44D
		  .WORD  param
                  .ENDM                  
EORNopNa          .MACRO param          
                  .BYTE $F54D
		  .WORD  param
                  .ENDM
EORNopOa          .MACRO param
                  .BYTE $F64D
		  .WORD  param
                  .ENDM
EORNopQa          .MACRO param
                  .BYTE $F74D
		  .WORD  param
                  .ENDM
            
EOROopAa          .MACRO param
                  .BYTE $C84D
		  .WORD  param
                  .ENDM                
EOROopBa          .MACRO param          
                  .BYTE $C94D
		  .WORD  param
                  .ENDM
EOROopCa          .MACRO param
                  .BYTE $CA4D
		  .WORD  param
                  .ENDM
EOROopDa          .MACRO param
                  .BYTE $CB4D
		  .WORD  param
                  .ENDM
EOROopEa          .MACRO param          
                  .BYTE $D84D
		  .WORD  param
                  .ENDM
EOROopFa          .MACRO param
                  .BYTE $D94D
		  .WORD  param
                  .ENDM
EOROopGa          .MACRO param
                  .BYTE $DA4D
		  .WORD  param
                  .ENDM                  
EOROopHa          .MACRO param          
                  .BYTE $DB4D
		  .WORD  param
                  .ENDM
EOROopIa          .MACRO param
                  .BYTE $E84D
		  .WORD  param
                  .ENDM
EOROopJa          .MACRO param
                  .BYTE $E94D
		  .WORD  param
                  .ENDM
EOROopKa          .MACRO param          
                  .BYTE $EA4D
		  .WORD  param
                  .ENDM
EOROopLa          .MACRO param
                  .BYTE $EB4D
		  .WORD  param
                  .ENDM
EOROopMa          .MACRO param
                  .BYTE $F84D
		  .WORD  param
                  .ENDM                  
EOROopNa          .MACRO param          
                  .BYTE $F94D
		  .WORD  param
                  .ENDM
EOROopOa          .MACRO param
                  .BYTE $FA4D
		  .WORD  param
                  .ENDM
EOROopQa          .MACRO param
                  .BYTE $FB4D
		  .WORD  param
                  .ENDM
                  
EORQopAa          .MACRO param
                  .BYTE $CC4D
		  .WORD  param
                  .ENDM                
EORQopBa          .MACRO param          
                  .BYTE $CD4D
		  .WORD  param
                  .ENDM
EORQopCa          .MACRO param
                  .BYTE $CE4D
		  .WORD  param
                  .ENDM
EORQopDa          .MACRO param
                  .BYTE $CF4D
		  .WORD  param
                  .ENDM
EORQopEa          .MACRO param          
                  .BYTE $DC4D
		  .WORD  param
                  .ENDM
EORQopFa          .MACRO param
                  .BYTE $DD4D
		  .WORD  param
                  .ENDM
EORQopGa          .MACRO param
                  .BYTE $DE4D
		  .WORD  param
                  .ENDM                  
EORQopHa          .MACRO param          
                  .BYTE $DF4D
		  .WORD  param
                  .ENDM
EORQopIa          .MACRO param
                  .BYTE $EC4D
		  .WORD  param
                  .ENDM
EORQopJa          .MACRO param
                  .BYTE $ED4D
		  .WORD  param
                  .ENDM
EORQopKa          .MACRO param          
                  .BYTE $EE4D
		  .WORD  param
                  .ENDM
EORQopLa          .MACRO param
                  .BYTE $EF4D
		  .WORD  param
                  .ENDM
EORQopMa          .MACRO param
                  .BYTE $FC4D
		  .WORD  param
                  .ENDM                  
EORQopNa          .MACRO param          
                  .BYTE $FD4D
		  .WORD  param
                  .ENDM
EORQopOa          .MACRO param
                  .BYTE $FE4D
		  .WORD  param
                  .ENDM
EORQopQa          .MACRO param
                  .BYTE $FF4D
		  .WORD  param
                  .ENDM

;ADC $xxxxxxxx,x        $007D
ADCAopBax         .MACRO param          
                  .BYTE $017D
		  .WORD  param
                  .ENDM
ADCAopCax         .MACRO param
                  .BYTE $027D
		  .WORD  param
                  .ENDM
ADCAopDax         .MACRO param
                  .BYTE $037D
		  .WORD  param
                  .ENDM
ADCAopEax         .MACRO param          
                  .BYTE $107D
		  .WORD  param
                  .ENDM
ADCAopFax         .MACRO param
                  .BYTE $117D
		  .WORD  param
                  .ENDM
ADCAopGax         .MACRO param
                  .BYTE $127D
		  .WORD  param
                  .ENDM                  
ADCAopHax         .MACRO param          
                  .BYTE $137D
		  .WORD  param
                  .ENDM
ADCAopIax         .MACRO param
                  .BYTE $207D
		  .WORD  param
                  .ENDM
ADCAopJax         .MACRO param
                  .BYTE $217D
		  .WORD  param
                  .ENDM
ADCAopKax         .MACRO param          
                  .BYTE $227D
		  .WORD  param
                  .ENDM
ADCAopLax         .MACRO param
                  .BYTE $237D
		  .WORD  param
                  .ENDM
ADCAopMax         .MACRO param
                  .BYTE $307D
		  .WORD  param
                  .ENDM                  
ADCAopNax         .MACRO param          
                  .BYTE $317D
		  .WORD  param
                  .ENDM
ADCAopOax         .MACRO param
                  .BYTE $327D
		  .WORD  param
                  .ENDM
ADCAopQax         .MACRO param
                  .BYTE $337D
		  .WORD  param
                  .ENDM
                                    
ADCBopAax         .MACRO param
                  .BYTE $047D
		  .WORD  param
                  .ENDM                
ADCBopBax         .MACRO param          
                  .BYTE $057D
		  .WORD  param
                  .ENDM
ADCBopCax         .MACRO param
                  .BYTE $067D
		  .WORD  param
                  .ENDM
ADCBopDax         .MACRO param
                  .BYTE $077D
		  .WORD  param
                  .ENDM
ADCBopEax         .MACRO param          
                  .BYTE $147D
		  .WORD  param
                  .ENDM
ADCBopFax         .MACRO param
                  .BYTE $157D
		  .WORD  param
                  .ENDM
ADCBopGax         .MACRO param
                  .BYTE $167D
		  .WORD  param
                  .ENDM                  
ADCBopHax         .MACRO param          
                  .BYTE $177D
		  .WORD  param
                  .ENDM
ADCBopIax         .MACRO param
                  .BYTE $247D
		  .WORD  param
                  .ENDM
ADCBopJax         .MACRO param
                  .BYTE $257D
		  .WORD  param
                  .ENDM
ADCBopKax         .MACRO param          
                  .BYTE $267D
		  .WORD  param
                  .ENDM
ADCBopLax         .MACRO param
                  .BYTE $277D
		  .WORD  param
                  .ENDM
ADCBopMax         .MACRO param
                  .BYTE $307D
		  .WORD  param
                  .ENDM                  
ADCBopNax         .MACRO param          
                  .BYTE $317D
		  .WORD  param
                  .ENDM
ADCBopOax         .MACRO param
                  .BYTE $327D
		  .WORD  param
                  .ENDM
ADCBopQax         .MACRO param
                  .BYTE $337D
		  .WORD  param
                  .ENDM
                                    
ADCCopAax         .MACRO param
                  .BYTE $087D
		  .WORD  param
                  .ENDM                
ADCCopBax         .MACRO param          
                  .BYTE $097D
		  .WORD  param
                  .ENDM
ADCCopCax         .MACRO param
                  .BYTE $0A7D
		  .WORD  param
                  .ENDM
ADCCopDax         .MACRO param
                  .BYTE $0B7D
		  .WORD  param
                  .ENDM
ADCCopEax         .MACRO param          
                  .BYTE $187D
		  .WORD  param
                  .ENDM
ADCCopFax         .MACRO param
                  .BYTE $197D
		  .WORD  param
                  .ENDM
ADCCopGax         .MACRO param
                  .BYTE $1A7D
		  .WORD  param
                  .ENDM                  
ADCCopHax         .MACRO param          
                  .BYTE $1B7D
		  .WORD  param
                  .ENDM
ADCCopIax         .MACRO param
                  .BYTE $287D
		  .WORD  param
                  .ENDM
ADCCopJax         .MACRO param
                  .BYTE $297D
		  .WORD  param
                  .ENDM
ADCCopKax         .MACRO param          
                  .BYTE $2A7D
		  .WORD  param
                  .ENDM
ADCCopLax         .MACRO param
                  .BYTE $2B7D
		  .WORD  param
                  .ENDM
ADCCopMax         .MACRO param
                  .BYTE $387D
		  .WORD  param
                  .ENDM                  
ADCCopNax         .MACRO param          
                  .BYTE $397D
	 	  .WORD  param
                  .ENDM
ADCCopOax         .MACRO param
                  .BYTE $3A7D
		  .WORD  param
                  .ENDM
ADCCopQax         .MACRO param
                  .BYTE $3B7D
		  .WORD  param
                  .ENDM

ADCDopAax         .MACRO param
                  .BYTE $0C7D
		  .WORD  param
                  .ENDM                
ADCDopBax         .MACRO param          
                  .BYTE $0D7D
		  .WORD  param
                  .ENDM
ADCDopCax         .MACRO param
                  .BYTE $0E7D
		  .WORD  param
                  .ENDM
ADCDopDax         .MACRO param
                  .BYTE $0F7D
		  .WORD  param
                  .ENDM
ADCDopEax         .MACRO param          
                  .BYTE $1C7D
		  .WORD  param
                  .ENDM
ADCDopFax         .MACRO param
                  .BYTE $1D7D
		  .WORD  param
                  .ENDM
ADCDopGax         .MACRO param
                  .BYTE $1E7D
		  .WORD  param
                  .ENDM                  
ADCDopHax         .MACRO param          
                  .BYTE $1F7D
		  .WORD  param
                  .ENDM
ADCDopIax         .MACRO param
                  .BYTE $2C7D
		  .WORD  param
                  .ENDM
ADCDopJax         .MACRO param
                  .BYTE $2D7D
		  .WORD  param
                  .ENDM
ADCDopKax         .MACRO param          
                  .BYTE $2E7D
		  .WORD  param
                  .ENDM
ADCDopLax         .MACRO param
                  .BYTE $2F7D
		  .WORD  param
                  .ENDM
ADCDopMax         .MACRO param
                  .BYTE $3C7D
		  .WORD  param
                  .ENDM                  
ADCDopNax         .MACRO param          
                  .BYTE $3D7D
		  .WORD  param
                  .ENDM
ADCDopOax         .MACRO param
                  .BYTE $3E7D
		  .WORD  param
                  .ENDM
ADCDopQax         .MACRO param
                  .BYTE $3F7D
		  .WORD  param
                  .ENDM                  

ADCEopAax         .MACRO param
                  .BYTE $407D
		  .WORD  param
                  .ENDM                
ADCEopBax         .MACRO param          
                  .BYTE $417D
		  .WORD  param
                  .ENDM
ADCEopCax         .MACRO param
                  .BYTE $427D
		  .WORD  param
                  .ENDM
ADCEopDax         .MACRO param
                  .BYTE $437D
		  .WORD  param
                  .ENDM
ADCEopEax         .MACRO param          
                  .BYTE $507D
		  .WORD  param
                  .ENDM
ADCEopFax         .MACRO param
                  .BYTE $517D
		  .WORD  param
                  .ENDM
ADCEopGax         .MACRO param
                  .BYTE $527D
		  .WORD  param
                  .ENDM                  
ADCEopHax         .MACRO param          
                  .BYTE $537D
		  .WORD  param
                  .ENDM
ADCEopIax         .MACRO param
                  .BYTE $607D
		  .WORD  param
                  .ENDM
ADCEopJax         .MACRO param
                  .BYTE $617D
		  .WORD  param
                  .ENDM
ADCEopKax         .MACRO param          
                  .BYTE $627D
		  .WORD  param
                  .ENDM
ADCEopLax         .MACRO param
                  .BYTE $637D
		  .WORD  param
                  .ENDM
ADCEopMax         .MACRO param
                  .BYTE $707D
		  .WORD  param
                  .ENDM                  
ADCEopNax         .MACRO param          
                  .BYTE $717D
		  .WORD  param
                  .ENDM
ADCEopOax         .MACRO param
                  .BYTE $727D
		  .WORD  param
                  .ENDM
ADCEopQax         .MACRO param
                  .BYTE $737D
		  .WORD  param
                  .ENDM
                  
ADCFopAax         .MACRO param
                  .BYTE $447D
		  .WORD  param
                  .ENDM                
ADCFopBax         .MACRO param          
                  .BYTE $457D
		  .WORD  param
                  .ENDM
ADCFopCax         .MACRO param
                  .BYTE $467D
		  .WORD  param
                  .ENDM
ADCFopDax         .MACRO param
                  .BYTE $477D
		  .WORD  param
                  .ENDM
ADCFopEax         .MACRO param          
                  .BYTE $547D
		  .WORD  param
                  .ENDM
ADCFopFax         .MACRO param
                  .BYTE $557D
		  .WORD  param
                  .ENDM
ADCFopGax         .MACRO param
                  .BYTE $567D
		  .WORD  param
                  .ENDM                  
ADCFopHax         .MACRO param          
                  .BYTE $577D
		  .WORD  param
                  .ENDM
ADCFopIax         .MACRO param
                  .BYTE $647D
	 	  .WORD  param
                  .ENDM
ADCFopJax         .MACRO param
                  .BYTE $657D
		  .WORD  param
                  .ENDM
ADCFopKax         .MACRO param          
                  .BYTE $667D
		  .WORD  param
                  .ENDM
ADCFopLax         .MACRO param
                  .BYTE $677D
		  .WORD  param
                  .ENDM
ADCFopMax         .MACRO param
                  .BYTE $747D
		  .WORD  param
                  .ENDM                  
ADCFopNax         .MACRO param          
                  .BYTE $757D
		  .WORD  param
                  .ENDM
ADCFopOax         .MACRO param
                  .BYTE $767D
		  .WORD  param
                  .ENDM
ADCFopQax         .MACRO param
                  .BYTE $777D
		  .WORD  param
                  .ENDM                  
                           
ADCGopAax         .MACRO param
                  .BYTE $487D
		  .WORD  param
                  .ENDM                
ADCGopBax         .MACRO param          
                  .BYTE $497D
		  .WORD  param
                  .ENDM
ADCGopCax         .MACRO param
                  .BYTE $4A7D
		  .WORD  param
                  .ENDM
ADCGopDax         .MACRO param
                  .BYTE $4B7D
		  .WORD  param
                  .ENDM
ADCGopEax         .MACRO param          
                  .BYTE $587D
		  .WORD  param
                  .ENDM
ADCGopFax         .MACRO param
                  .BYTE $597D
		  .WORD  param
                  .ENDM
ADCGopGax         .MACRO param
                  .BYTE $5A7D
		  .WORD  param
                  .ENDM                  
ADCGopHax         .MACRO param          
                  .BYTE $5B7D
		  .WORD  param
                  .ENDM
ADCGopIax         .MACRO param
                  .BYTE $687D
		  .WORD  param
                  .ENDM
ADCGopJax         .MACRO param
                  .BYTE $697D
		  .WORD  param
                  .ENDM
ADCGopKax         .MACRO param          
                  .BYTE $6A7D
		  .WORD  param
                  .ENDM
ADCGopLax         .MACRO param
                  .BYTE $6B7D
		  .WORD  param
                  .ENDM
ADCGopMax         .MACRO param
                  .BYTE $787D
		  .WORD  param
                  .ENDM                  
ADCGopNax         .MACRO param          
                  .BYTE $797D
		  .WORD  param
                  .ENDM
ADCGopOax         .MACRO param
                  .BYTE $7A7D
		  .WORD  param
                  .ENDM
ADCGopQax         .MACRO param
                  .BYTE $7B7D
		  .WORD  param
                  .ENDM
                  
ADCHopAax         .MACRO param
                  .BYTE $4C7D
		  .WORD  param
                  .ENDM                
ADCHopBax         .MACRO param          
                  .BYTE $4D7D
		  .WORD  param
                  .ENDM
ADCHopCax         .MACRO param
                  .BYTE $4E7D
		  .WORD  param
                  .ENDM
ADCHopDax         .MACRO param
                  .BYTE $4F7D
		  .WORD  param
                  .ENDM
ADCHopEax         .MACRO param          
                  .BYTE $5C7D
		  .WORD  param
                  .ENDM
ADCHopFax         .MACRO param
                  .BYTE $5D7D
		  .WORD  param
                  .ENDM
ADCHopGax         .MACRO param
                  .BYTE $5E7D
		  .WORD  param
                  .ENDM                  
ADCHopHax         .MACRO param          
                  .BYTE $5F7D
		  .WORD  param
                  .ENDM
ADCHopIax         .MACRO param
                  .BYTE $6C7D
		  .WORD  param
                  .ENDM
ADCHopJax         .MACRO param
                  .BYTE $6D7D
		  .WORD  param
                  .ENDM
ADCHopKax         .MACRO param          
                  .BYTE $6E7D
		  .WORD  param
                  .ENDM
ADCHopLax         .MACRO param
                  .BYTE $6F7D
		  .WORD  param
                  .ENDM
ADCHopMax         .MACRO param
                  .BYTE $7C7D
		  .WORD  param
                  .ENDM                  
ADCHopNax         .MACRO param          
                  .BYTE $7D7D
		  .WORD  param
                  .ENDM
ADCHopOax         .MACRO param
                  .BYTE $7E7D
		  .WORD  param
                  .ENDM
ADCHopQax         .MACRO param
                  .BYTE $7F7D
		  .WORD  param
                  .ENDM
                  
ADCIopAax         .MACRO param
                  .BYTE $807D
		  .WORD  param
                  .ENDM                
ADCIopBax         .MACRO param          
                  .BYTE $817D
		  .WORD  param
                  .ENDM
ADCIopCax         .MACRO param
                  .BYTE $827D
		  .WORD  param
                  .ENDM
ADCIopDax         .MACRO param
                  .BYTE $837D
		  .WORD  param
                  .ENDM
ADCIopEax         .MACRO param          
                  .BYTE $907D
		  .WORD  param
                  .ENDM
ADCIopFax         .MACRO param
                  .BYTE $917D
		  .WORD  param
                  .ENDM
ADCIopGax         .MACRO param
                  .BYTE $927D
		  .WORD  param
                  .ENDM                  
ADCIopHax         .MACRO param          
                  .BYTE $937D
		  .WORD  param
                  .ENDM
ADCIopIax         .MACRO param
                  .BYTE $A07D
		  .WORD  param
                  .ENDM
ADCIopJax         .MACRO param
                  .BYTE $A17D
		  .WORD  param
                  .ENDM
ADCIopKax         .MACRO param          
                  .BYTE $A27D
		  .WORD  param
                  .ENDM
ADCIopLax         .MACRO param
                  .BYTE $A37D
		  .WORD  param
                  .ENDM
ADCIopMax         .MACRO param
                  .BYTE $B07D
		  .WORD  param
                  .ENDM                  
ADCIopNax         .MACRO param          
                  .BYTE $B17D
		  .WORD  param
                  .ENDM
ADCIopOax         .MACRO param
                  .BYTE $B27D
		  .WORD  param
                  .ENDM
ADCIopQax         .MACRO param
                  .BYTE $B37D
		  .WORD  param
                  .ENDM
                  
ADCJopAax         .MACRO param
                  .BYTE $847D
		  .WORD  param
                  .ENDM                
ADCJopBax         .MACRO param          
                  .BYTE $857D
		  .WORD  param
                  .ENDM
ADCJopCax         .MACRO param
                  .BYTE $867D
		  .WORD  param
                  .ENDM
ADCJopDax         .MACRO param
                  .BYTE $877D
		  .WORD  param
                  .ENDM
ADCJopEax         .MACRO param          
                  .BYTE $947D
		  .WORD  param
                  .ENDM
ADCJopFax         .MACRO param
                  .BYTE $957D
		  .WORD  param
                  .ENDM
ADCJopGax         .MACRO param
                  .BYTE $967D
		  .WORD  param
                  .ENDM                  
ADCJopHax         .MACRO param          
                  .BYTE $977D
		  .WORD  param
                  .ENDM
ADCJopIax         .MACRO param
                  .BYTE $A47D
		  .WORD  param
                  .ENDM
ADCJopJax         .MACRO param
                  .BYTE $A57D
		  .WORD  param
                  .ENDM
ADCJopKax         .MACRO param          
                  .BYTE $A67D
 		  .WORD  param
                  .ENDM
ADCJopLax         .MACRO param
                  .BYTE $A77D
		  .WORD  param
                  .ENDM
ADCJopMax         .MACRO param
                  .BYTE $B47D
		  .WORD  param
                  .ENDM                  
ADCJopNax         .MACRO param          
                  .BYTE $B57D
		  .WORD  param
                  .ENDM
ADCJopOax         .MACRO param
                  .BYTE $B67D
		  .WORD  param
                  .ENDM
ADCJopQax         .MACRO param
                  .BYTE $B77D
		  .WORD  param
                  .ENDM
                  
ADCKopAax         .MACRO param
                  .BYTE $887D
		  .WORD  param
                  .ENDM                
ADCKopBax         .MACRO param          
                  .BYTE $897D
		  .WORD  param
                  .ENDM
ADCKopCax         .MACRO param
                  .BYTE $8A7D
		  .WORD  param
                  .ENDM
ADCKopDax         .MACRO param
                  .BYTE $8B7D
		  .WORD  param
                  .ENDM
ADCKopEax         .MACRO param          
                  .BYTE $987D
		  .WORD  param
                  .ENDM
ADCKopFax         .MACRO param
                  .BYTE $997D
		  .WORD  param
                  .ENDM
ADCKopGax         .MACRO param
                  .BYTE $9A7D
		  .WORD  param
                  .ENDM                  
ADCKopHax         .MACRO param          
                  .BYTE $9B7D
		  .WORD  param
                  .ENDM
ADCKopIax         .MACRO param
                  .BYTE $A87D
		  .WORD  param
                  .ENDM
ADCKopJax         .MACRO param
                  .BYTE $A97D
		  .WORD  param
                  .ENDM
ADCKopKax         .MACRO param          
                  .BYTE $AA7D
		  .WORD  param
                  .ENDM
ADCKopLax         .MACRO param
                  .BYTE $AB7D
		  .WORD  param
                  .ENDM
ADCKopMax         .MACRO param
                  .BYTE $B87D
		  .WORD  param
                  .ENDM                  
ADCKopNax         .MACRO param          
                  .BYTE $B97D
		  .WORD  param
                  .ENDM
ADCKopOax         .MACRO param
                  .BYTE $BA7D
		  .WORD  param
                  .ENDM
ADCKopQax         .MACRO param
                  .BYTE $BB7D
		  .WORD  param
                  .ENDM
                  
ADCLopAax         .MACRO param
                  .BYTE $8C7D
		  .WORD  param
                  .ENDM                
ADCLopBax         .MACRO param          
                  .BYTE $8D7D
		  .WORD  param
                  .ENDM
ADCLopCax         .MACRO param
                  .BYTE $8E7D
		  .WORD  param
                  .ENDM
ADCLopDax         .MACRO param
                  .BYTE $8F7D
		  .WORD  param
                  .ENDM
ADCLopEax         .MACRO param          
                  .BYTE $9C7D
		  .WORD  param
                  .ENDM
ADCLopFax         .MACRO param
                  .BYTE $9D7D
		  .WORD  param
                  .ENDM
ADCLopGax         .MACRO param
                  .BYTE $9E7D
		  .WORD  param
                  .ENDM                  
ADCLopHax         .MACRO param          
                  .BYTE $9F7D
		  .WORD  param
                  .ENDM
ADCLopIax         .MACRO param
                  .BYTE $AC7D
		  .WORD  param
                  .ENDM
ADCLopJax         .MACRO param
                  .BYTE $AD7D
		  .WORD  param
                  .ENDM
ADCLopKax         .MACRO param          
                  .BYTE $AE7D
		  .WORD  param
                  .ENDM
ADCLopLax         .MACRO param
                  .BYTE $AF7D
		  .WORD  param
                  .ENDM
ADCLopMax         .MACRO param
                  .BYTE $BC7D
		  .WORD  param
                  .ENDM                  
ADCLopNax         .MACRO param          
                  .BYTE $BD7D
		  .WORD  param
                  .ENDM
ADCLopOax         .MACRO param
                  .BYTE $BE7D
		  .WORD  param
                  .ENDM
ADCLopQax         .MACRO param
                  .BYTE $BF7D
		  .WORD  param
                  .ENDM
                  
ADCMopAax         .MACRO param
                  .BYTE $C07D
		  .WORD  param
                  .ENDM                
ADCMopBax         .MACRO param          
                  .BYTE $C17D
		  .WORD  param
                  .ENDM
ADCMopCax         .MACRO param
                  .BYTE $C27D
		  .WORD  param
                  .ENDM
ADCMopDax         .MACRO param
                  .BYTE $C37D
		  .WORD  param
                  .ENDM
ADCMopEax         .MACRO param          
                  .BYTE $D07D
		  .WORD  param
                  .ENDM
ADCMopFax         .MACRO param
                  .BYTE $D17D
		  .WORD  param
                  .ENDM
ADCMopGax         .MACRO param
                  .BYTE $D27D
		  .WORD  param
                  .ENDM                  
ADCMopHax         .MACRO param          
                  .BYTE $D37D
		  .WORD  param
                  .ENDM
ADCMopIax         .MACRO param
                  .BYTE $E07D
		  .WORD  param
                  .ENDM
ADCMopJax         .MACRO param
                  .BYTE $E17D
		  .WORD  param
                  .ENDM
ADCMopKax         .MACRO param          
                  .BYTE $E27D
		  .WORD  param
                  .ENDM
ADCMopLax         .MACRO param
                  .BYTE $E37D
		  .WORD  param
                  .ENDM
ADCMopMax         .MACRO param
                  .BYTE $F07D
		  .WORD  param
                  .ENDM                  
ADCMopNax         .MACRO param          
                  .BYTE $F17D
		  .WORD  param
                  .ENDM
ADCMopOax         .MACRO param
                  .BYTE $F27D
		  .WORD  param
                  .ENDM
ADCMopQax         .MACRO param
                  .BYTE $F37D
		  .WORD  param
                  .ENDM
                  
ADCNopAax         .MACRO param
                  .BYTE $C47D
		  .WORD  param
                  .ENDM                
ADCNopBax         .MACRO param          
                  .BYTE $C57D
		  .WORD  param
                  .ENDM
ADCNopCax         .MACRO param
                  .BYTE $C67D
		  .WORD  param
                  .ENDM
ADCNopDax         .MACRO param
                  .BYTE $C77D
		  .WORD  param
                  .ENDM
ADCNopEax         .MACRO param          
                  .BYTE $D47D
		  .WORD  param
                  .ENDM
ADCNopFax         .MACRO param
                  .BYTE $D57D
		  .WORD  param
                  .ENDM
ADCNopGax         .MACRO param
                  .BYTE $D67D
		  .WORD  param
                  .ENDM                  
ADCNopHax         .MACRO param          
                  .BYTE $D77D
		  .WORD  param
                  .ENDM
ADCNopIax         .MACRO param
                  .BYTE $E47D
		  .WORD  param
                  .ENDM
ADCNopJax         .MACRO param
                  .BYTE $E57D
		  .WORD  param
                  .ENDM
ADCNopKax         .MACRO param          
                  .BYTE $E67D
		  .WORD  param
                  .ENDM
ADCNopLax         .MACRO param
                  .BYTE $E77D
		  .WORD  param
                  .ENDM
ADCNopMax         .MACRO param
                  .BYTE $F47D
		  .WORD  param
                  .ENDM                  
ADCNopNax         .MACRO param          
                  .BYTE $F57D
		  .WORD  param
                  .ENDM
ADCNopOax         .MACRO param
                  .BYTE $F67D
		  .WORD  param
                  .ENDM
ADCNopQax         .MACRO param
                  .BYTE $F77D
		  .WORD  param
                  .ENDM
            
ADCOopAax         .MACRO param
                  .BYTE $C87D
		  .WORD  param
                  .ENDM                
ADCOopBax         .MACRO param          
                  .BYTE $C97D
		  .WORD  param
                  .ENDM
ADCOopCax         .MACRO param
                  .BYTE $CA7D
		  .WORD  param
                  .ENDM
ADCOopDax         .MACRO param
                  .BYTE $CB7D
		  .WORD  param
                  .ENDM
ADCOopEax         .MACRO param          
                  .BYTE $D87D
		  .WORD  param
                  .ENDM
ADCOopFax         .MACRO param
                  .BYTE $D97D
		  .WORD  param
                  .ENDM
ADCOopGax         .MACRO param
                  .BYTE $DA7D
		  .WORD  param
                  .ENDM                  
ADCOopHax         .MACRO param          
                  .BYTE $DB7D
		  .WORD  param
                  .ENDM
ADCOopIax         .MACRO param
                  .BYTE $E87D
		  .WORD  param
                  .ENDM
ADCOopJax         .MACRO param
                  .BYTE $E97D
		  .WORD  param
                  .ENDM
ADCOopKax         .MACRO param          
                  .BYTE $EA7D
		  .WORD  param
                  .ENDM
ADCOopLax         .MACRO param
                  .BYTE $EB7D
		  .WORD  param
                  .ENDM
ADCOopMax         .MACRO param
                  .BYTE $F87D
		  .WORD  param
                  .ENDM                  
ADCOopNax         .MACRO param          
                  .BYTE $F97D
		  .WORD  param
                  .ENDM
ADCOopOax         .MACRO param
                  .BYTE $FA7D
		  .WORD  param
                  .ENDM
ADCOopQax         .MACRO param
                  .BYTE $FB7D
		  .WORD  param
                  .ENDM
                  
ADCQopAax         .MACRO param
                  .BYTE $CC7D
		  .WORD  param
                  .ENDM                
ADCQopBax         .MACRO param          
                  .BYTE $CD7D
		  .WORD  param
                  .ENDM
ADCQopCax         .MACRO param
                  .BYTE $CE7D
		  .WORD  param
                  .ENDM
ADCQopDax         .MACRO param
                  .BYTE $CF7D
		  .WORD  param
                  .ENDM
ADCQopEax         .MACRO param          
                  .BYTE $DC7D
		  .WORD  param
                  .ENDM
ADCQopFax         .MACRO param
                  .BYTE $DD7D
		  .WORD  param
                  .ENDM
ADCQopGax         .MACRO param
                  .BYTE $DE7D
		  .WORD  param
                  .ENDM                  
ADCQopHax         .MACRO param          
                  .BYTE $DF7D
		  .WORD  param
                  .ENDM
ADCQopIax         .MACRO param
                  .BYTE $EC7D
		  .WORD  param
                  .ENDM
ADCQopJax         .MACRO param
                  .BYTE $ED7D
		  .WORD  param
                  .ENDM
ADCQopKax         .MACRO param          
                  .BYTE $EE7D
		  .WORD  param
                  .ENDM
ADCQopLax         .MACRO param
                  .BYTE $EF7D
		  .WORD  param
                  .ENDM
ADCQopMax         .MACRO param
                  .BYTE $FC7D
		  .WORD  param
                  .ENDM                  
ADCQopNax         .MACRO param          
                  .BYTE $FD7D
		  .WORD  param
                  .ENDM
ADCQopOax         .MACRO param
                  .BYTE $FE7D
		  .WORD  param
                  .ENDM
ADCQopQax         .MACRO param
                  .BYTE $FF7D
		  .WORD  param
                  .ENDM

;SBC $xxxxxxxx,x        $00FD
SBCAopBax         .MACRO param          
                  .BYTE $01FD
		  .WORD  param
                  .ENDM
SBCAopCax         .MACRO param
                  .BYTE $02FD
		  .WORD  param
                  .ENDM
SBCAopDax         .MACRO param
                  .BYTE $03FD
		  .WORD  param
                  .ENDM
SBCAopEax         .MACRO param          
                  .BYTE $10FD
		  .WORD  param
                  .ENDM
SBCAopFax         .MACRO param
                  .BYTE $11FD
		  .WORD  param
                  .ENDM
SBCAopGax         .MACRO param
                  .BYTE $12FD
		  .WORD  param
                  .ENDM                  
SBCAopHax         .MACRO param          
                  .BYTE $13FD
		  .WORD  param
                  .ENDM
SBCAopIax         .MACRO param
                  .BYTE $20FD
		  .WORD  param
                  .ENDM
SBCAopJax         .MACRO param
                  .BYTE $21FD
		  .WORD  param
                  .ENDM
SBCAopKax         .MACRO param          
                  .BYTE $22FD
		  .WORD  param
                  .ENDM
SBCAopLax         .MACRO param
                  .BYTE $23FD
		  .WORD  param
                  .ENDM
SBCAopMax         .MACRO param
                  .BYTE $30FD
		  .WORD  param
                  .ENDM                  
SBCAopNax         .MACRO param          
                  .BYTE $31FD
		  .WORD  param
                  .ENDM
SBCAopOax         .MACRO param
                  .BYTE $32FD
		  .WORD  param
                  .ENDM
SBCAopQax         .MACRO param
                  .BYTE $33FD
		  .WORD  param
                  .ENDM
                                    
SBCBopAax         .MACRO param
                  .BYTE $04FD
		  .WORD  param
                  .ENDM                
SBCBopBax         .MACRO param          
                  .BYTE $05FD
		  .WORD  param
                  .ENDM
SBCBopCax         .MACRO param
                  .BYTE $06FD
		  .WORD  param
                  .ENDM
SBCBopDax         .MACRO param
                  .BYTE $07FD
		  .WORD  param
                  .ENDM
SBCBopEax         .MACRO param          
                  .BYTE $14FD
		  .WORD  param
                  .ENDM
SBCBopFax         .MACRO param
                  .BYTE $15FD
		  .WORD  param
                  .ENDM
SBCBopGax         .MACRO param
                  .BYTE $16FD
		  .WORD  param
                  .ENDM                  
SBCBopHax         .MACRO param          
                  .BYTE $17FD
		  .WORD  param
                  .ENDM
SBCBopIax         .MACRO param
                  .BYTE $24FD
		  .WORD  param
                  .ENDM
SBCBopJax         .MACRO param
                  .BYTE $25FD
		  .WORD  param
                  .ENDM
SBCBopKax         .MACRO param          
                  .BYTE $26FD
		  .WORD  param
                  .ENDM
SBCBopLax         .MACRO param
                  .BYTE $27FD
		  .WORD  param
                  .ENDM
SBCBopMax         .MACRO param
                  .BYTE $30FD
		  .WORD  param
                  .ENDM                  
SBCBopNax         .MACRO param          
                  .BYTE $31FD
		  .WORD  param
                  .ENDM
SBCBopOax         .MACRO param
                  .BYTE $32FD
		  .WORD  param
                  .ENDM
SBCBopQax         .MACRO param
                  .BYTE $33FD
		  .WORD  param
                  .ENDM
                                    
SBCCopAax         .MACRO param
                  .BYTE $08FD
		  .WORD  param
                  .ENDM                
SBCCopBax         .MACRO param          
                  .BYTE $09FD
		  .WORD  param
                  .ENDM
SBCCopCax         .MACRO param
                  .BYTE $0AFD
		  .WORD  param
                  .ENDM
SBCCopDax         .MACRO param
                  .BYTE $0BFD
		  .WORD  param
                  .ENDM
SBCCopEax         .MACRO param          
                  .BYTE $18FD
		  .WORD  param
                  .ENDM
SBCCopFax         .MACRO param
                  .BYTE $19FD
		  .WORD  param
                  .ENDM
SBCCopGax         .MACRO param
                  .BYTE $1AFD
		  .WORD  param
                  .ENDM                  
SBCCopHax         .MACRO param          
                  .BYTE $1BFD
		  .WORD  param
                  .ENDM
SBCCopIax         .MACRO param
                  .BYTE $28FD
		  .WORD  param
                  .ENDM
SBCCopJax         .MACRO param
                  .BYTE $29FD
		  .WORD  param
                  .ENDM
SBCCopKax         .MACRO param          
                  .BYTE $2AFD
		  .WORD  param
                  .ENDM
SBCCopLax         .MACRO param
                  .BYTE $2BFD
		  .WORD  param
                  .ENDM
SBCCopMax         .MACRO param
                  .BYTE $38FD
		  .WORD  param
                  .ENDM                  
SBCCopNax         .MACRO param          
                  .BYTE $39FD
	 	  .WORD  param
                  .ENDM
SBCCopOax         .MACRO param
                  .BYTE $3AFD
		  .WORD  param
                  .ENDM
SBCCopQax         .MACRO param
                  .BYTE $3BFD
		  .WORD  param
                  .ENDM

SBCDopAax         .MACRO param
                  .BYTE $0CFD
		  .WORD  param
                  .ENDM                
SBCDopBax         .MACRO param          
                  .BYTE $0DFD
		  .WORD  param
                  .ENDM
SBCDopCax         .MACRO param
                  .BYTE $0EFD
		  .WORD  param
                  .ENDM
SBCDopDax         .MACRO param
                  .BYTE $0FFD
		  .WORD  param
                  .ENDM
SBCDopEax         .MACRO param          
                  .BYTE $1CFD
		  .WORD  param
                  .ENDM
SBCDopFax         .MACRO param
                  .BYTE $1DFD
		  .WORD  param
                  .ENDM
SBCDopGax         .MACRO param
                  .BYTE $1EFD
		  .WORD  param
                  .ENDM                  
SBCDopHax         .MACRO param          
                  .BYTE $1FFD
		  .WORD  param
                  .ENDM
SBCDopIax         .MACRO param
                  .BYTE $2CFD
		  .WORD  param
                  .ENDM
SBCDopJax         .MACRO param
                  .BYTE $2DFD
		  .WORD  param
                  .ENDM
SBCDopKax         .MACRO param          
                  .BYTE $2EFD
		  .WORD  param
                  .ENDM
SBCDopLax         .MACRO param
                  .BYTE $2FFD
		  .WORD  param
                  .ENDM
SBCDopMax         .MACRO param
                  .BYTE $3CFD
		  .WORD  param
                  .ENDM                  
SBCDopNax         .MACRO param          
                  .BYTE $3DFD
		  .WORD  param
                  .ENDM
SBCDopOax         .MACRO param
                  .BYTE $3EFD
		  .WORD  param
                  .ENDM
SBCDopQax         .MACRO param
                  .BYTE $3FFD
		  .WORD  param
                  .ENDM                  

SBCEopAax         .MACRO param
                  .BYTE $40FD
		  .WORD  param
                  .ENDM                
SBCEopBax         .MACRO param          
                  .BYTE $41FD
		  .WORD  param
                  .ENDM
SBCEopCax         .MACRO param
                  .BYTE $42FD
		  .WORD  param
                  .ENDM
SBCEopDax         .MACRO param
                  .BYTE $43FD
		  .WORD  param
                  .ENDM
SBCEopEax         .MACRO param          
                  .BYTE $50FD
		  .WORD  param
                  .ENDM
SBCEopFax         .MACRO param
                  .BYTE $51FD
		  .WORD  param
                  .ENDM
SBCEopGax         .MACRO param
                  .BYTE $52FD
		  .WORD  param
                  .ENDM                  
SBCEopHax         .MACRO param          
                  .BYTE $53FD
		  .WORD  param
                  .ENDM
SBCEopIax         .MACRO param
                  .BYTE $60FD
		  .WORD  param
                  .ENDM
SBCEopJax         .MACRO param
                  .BYTE $61FD
		  .WORD  param
                  .ENDM
SBCEopKax         .MACRO param          
                  .BYTE $62FD
		  .WORD  param
                  .ENDM
SBCEopLax         .MACRO param
                  .BYTE $63FD
		  .WORD  param
                  .ENDM
SBCEopMax         .MACRO param
                  .BYTE $70FD
		  .WORD  param
                  .ENDM                  
SBCEopNax         .MACRO param          
                  .BYTE $71FD
		  .WORD  param
                  .ENDM
SBCEopOax         .MACRO param
                  .BYTE $72FD
		  .WORD  param
                  .ENDM
SBCEopQax         .MACRO param
                  .BYTE $73FD
		  .WORD  param
                  .ENDM
                  
SBCFopAax         .MACRO param
                  .BYTE $44FD
		  .WORD  param
                  .ENDM                
SBCFopBax         .MACRO param          
                  .BYTE $45FD
		  .WORD  param
                  .ENDM
SBCFopCax         .MACRO param
                  .BYTE $46FD
		  .WORD  param
                  .ENDM
SBCFopDax         .MACRO param
                  .BYTE $47FD
		  .WORD  param
                  .ENDM
SBCFopEax         .MACRO param          
                  .BYTE $54FD
		  .WORD  param
                  .ENDM
SBCFopFax         .MACRO param
                  .BYTE $55FD
		  .WORD  param
                  .ENDM
SBCFopGax         .MACRO param
                  .BYTE $56FD
		  .WORD  param
                  .ENDM                  
SBCFopHax         .MACRO param          
                  .BYTE $57FD
		  .WORD  param
                  .ENDM
SBCFopIax         .MACRO param
                  .BYTE $64FD
	 	  .WORD  param
                  .ENDM
SBCFopJax         .MACRO param
                  .BYTE $65FD
		  .WORD  param
                  .ENDM
SBCFopKax         .MACRO param          
                  .BYTE $66FD
		  .WORD  param
                  .ENDM
SBCFopLax         .MACRO param
                  .BYTE $67FD
		  .WORD  param
                  .ENDM
SBCFopMax         .MACRO param
                  .BYTE $74FD
		  .WORD  param
                  .ENDM                  
SBCFopNax         .MACRO param          
                  .BYTE $75FD
		  .WORD  param
                  .ENDM
SBCFopOax         .MACRO param
                  .BYTE $76FD
		  .WORD  param
                  .ENDM
SBCFopQax         .MACRO param
                  .BYTE $77FD
		  .WORD  param
                  .ENDM                  
                           
SBCGopAax         .MACRO param
                  .BYTE $48FD
		  .WORD  param
                  .ENDM                
SBCGopBax         .MACRO param          
                  .BYTE $49FD
		  .WORD  param
                  .ENDM
SBCGopCax         .MACRO param
                  .BYTE $4AFD
		  .WORD  param
                  .ENDM
SBCGopDax         .MACRO param
                  .BYTE $4BFD
		  .WORD  param
                  .ENDM
SBCGopEax         .MACRO param          
                  .BYTE $58FD
		  .WORD  param
                  .ENDM
SBCGopFax         .MACRO param
                  .BYTE $59FD
		  .WORD  param
                  .ENDM
SBCGopGax         .MACRO param
                  .BYTE $5AFD
		  .WORD  param
                  .ENDM                  
SBCGopHax         .MACRO param          
                  .BYTE $5BFD
		  .WORD  param
                  .ENDM
SBCGopIax         .MACRO param
                  .BYTE $68FD
		  .WORD  param
                  .ENDM
SBCGopJax         .MACRO param
                  .BYTE $69FD
		  .WORD  param
                  .ENDM
SBCGopKax         .MACRO param          
                  .BYTE $6AFD
		  .WORD  param
                  .ENDM
SBCGopLax         .MACRO param
                  .BYTE $6BFD
		  .WORD  param
                  .ENDM
SBCGopMax         .MACRO param
                  .BYTE $78FD
		  .WORD  param
                  .ENDM                  
SBCGopNax         .MACRO param          
                  .BYTE $79FD
		  .WORD  param
                  .ENDM
SBCGopOax         .MACRO param
                  .BYTE $7AFD
		  .WORD  param
                  .ENDM
SBCGopQax         .MACRO param
                  .BYTE $7BFD
		  .WORD  param
                  .ENDM
                  
SBCHopAax         .MACRO param
                  .BYTE $4CFD
		  .WORD  param
                  .ENDM                
SBCHopBax         .MACRO param          
                  .BYTE $4DFD
		  .WORD  param
                  .ENDM
SBCHopCax         .MACRO param
                  .BYTE $4EFD
		  .WORD  param
                  .ENDM
SBCHopDax         .MACRO param
                  .BYTE $4FFD
		  .WORD  param
                  .ENDM
SBCHopEax         .MACRO param          
                  .BYTE $5CFD
		  .WORD  param
                  .ENDM
SBCHopFax         .MACRO param
                  .BYTE $5DFD
		  .WORD  param
                  .ENDM
SBCHopGax         .MACRO param
                  .BYTE $5EFD
		  .WORD  param
                  .ENDM                  
SBCHopHax         .MACRO param          
                  .BYTE $5FFD
		  .WORD  param
                  .ENDM
SBCHopIax         .MACRO param
                  .BYTE $6CFD
		  .WORD  param
                  .ENDM
SBCHopJax         .MACRO param
                  .BYTE $6DFD
		  .WORD  param
                  .ENDM
SBCHopKax         .MACRO param          
                  .BYTE $6EFD
		  .WORD  param
                  .ENDM
SBCHopLax         .MACRO param
                  .BYTE $6FFD
		  .WORD  param
                  .ENDM
SBCHopMax         .MACRO param
                  .BYTE $7CFD
		  .WORD  param
                  .ENDM                  
SBCHopNax         .MACRO param          
                  .BYTE $7DFD
		  .WORD  param
                  .ENDM
SBCHopOax         .MACRO param
                  .BYTE $7EFD
		  .WORD  param
                  .ENDM
SBCHopQax         .MACRO param
                  .BYTE $7FFD
		  .WORD  param
                  .ENDM
                  
SBCIopAax         .MACRO param
                  .BYTE $80FD
		  .WORD  param
                  .ENDM                
SBCIopBax         .MACRO param          
                  .BYTE $81FD
		  .WORD  param
                  .ENDM
SBCIopCax         .MACRO param
                  .BYTE $82FD
		  .WORD  param
                  .ENDM
SBCIopDax         .MACRO param
                  .BYTE $83FD
		  .WORD  param
                  .ENDM
SBCIopEax         .MACRO param          
                  .BYTE $90FD
		  .WORD  param
                  .ENDM
SBCIopFax         .MACRO param
                  .BYTE $91FD
		  .WORD  param
                  .ENDM
SBCIopGax         .MACRO param
                  .BYTE $92FD
		  .WORD  param
                  .ENDM                  
SBCIopHax         .MACRO param          
                  .BYTE $93FD
		  .WORD  param
                  .ENDM
SBCIopIax         .MACRO param
                  .BYTE $A0FD
		  .WORD  param
                  .ENDM
SBCIopJax         .MACRO param
                  .BYTE $A1FD
		  .WORD  param
                  .ENDM
SBCIopKax         .MACRO param          
                  .BYTE $A2FD
		  .WORD  param
                  .ENDM
SBCIopLax         .MACRO param
                  .BYTE $A3FD
		  .WORD  param
                  .ENDM
SBCIopMax         .MACRO param
                  .BYTE $B0FD
		  .WORD  param
                  .ENDM                  
SBCIopNax         .MACRO param          
                  .BYTE $B1FD
		  .WORD  param
                  .ENDM
SBCIopOax         .MACRO param
                  .BYTE $B2FD
		  .WORD  param
                  .ENDM
SBCIopQax         .MACRO param
                  .BYTE $B3FD
		  .WORD  param
                  .ENDM
                  
SBCJopAax         .MACRO param
                  .BYTE $84FD
		  .WORD  param
                  .ENDM                
SBCJopBax         .MACRO param          
                  .BYTE $85FD
		  .WORD  param
                  .ENDM
SBCJopCax         .MACRO param
                  .BYTE $86FD
		  .WORD  param
                  .ENDM
SBCJopDax         .MACRO param
                  .BYTE $87FD
		  .WORD  param
                  .ENDM
SBCJopEax         .MACRO param          
                  .BYTE $94FD
		  .WORD  param
                  .ENDM
SBCJopFax         .MACRO param
                  .BYTE $95FD
		  .WORD  param
                  .ENDM
SBCJopGax         .MACRO param
                  .BYTE $96FD
		  .WORD  param
                  .ENDM                  
SBCJopHax         .MACRO param          
                  .BYTE $97FD
		  .WORD  param
                  .ENDM
SBCJopIax         .MACRO param
                  .BYTE $A4FD
		  .WORD  param
                  .ENDM
SBCJopJax         .MACRO param
                  .BYTE $A5FD
		  .WORD  param
                  .ENDM
SBCJopKax         .MACRO param          
                  .BYTE $A6FD
 		  .WORD  param
                  .ENDM
SBCJopLax         .MACRO param
                  .BYTE $A7FD
		  .WORD  param
                  .ENDM
SBCJopMax         .MACRO param
                  .BYTE $B4FD
		  .WORD  param
                  .ENDM                  
SBCJopNax         .MACRO param          
                  .BYTE $B5FD
		  .WORD  param
                  .ENDM
SBCJopOax         .MACRO param
                  .BYTE $B6FD
		  .WORD  param
                  .ENDM
SBCJopQax         .MACRO param
                  .BYTE $B7FD
		  .WORD  param
                  .ENDM
                  
SBCKopAax         .MACRO param
                  .BYTE $88FD
		  .WORD  param
                  .ENDM                
SBCKopBax         .MACRO param          
                  .BYTE $89FD
		  .WORD  param
                  .ENDM
SBCKopCax         .MACRO param
                  .BYTE $8AFD
		  .WORD  param
                  .ENDM
SBCKopDax         .MACRO param
                  .BYTE $8BFD
		  .WORD  param
                  .ENDM
SBCKopEax         .MACRO param          
                  .BYTE $98FD
		  .WORD  param
                  .ENDM
SBCKopFax         .MACRO param
                  .BYTE $99FD
		  .WORD  param
                  .ENDM
SBCKopGax         .MACRO param
                  .BYTE $9AFD
		  .WORD  param
                  .ENDM                  
SBCKopHax         .MACRO param          
                  .BYTE $9BFD
		  .WORD  param
                  .ENDM
SBCKopIax         .MACRO param
                  .BYTE $A8FD
		  .WORD  param
                  .ENDM
SBCKopJax         .MACRO param
                  .BYTE $A9FD
		  .WORD  param
                  .ENDM
SBCKopKax         .MACRO param          
                  .BYTE $AAFD
		  .WORD  param
                  .ENDM
SBCKopLax         .MACRO param
                  .BYTE $ABFD
		  .WORD  param
                  .ENDM
SBCKopMax         .MACRO param
                  .BYTE $B8FD
		  .WORD  param
                  .ENDM                  
SBCKopNax         .MACRO param          
                  .BYTE $B9FD
		  .WORD  param
                  .ENDM
SBCKopOax         .MACRO param
                  .BYTE $BAFD
		  .WORD  param
                  .ENDM
SBCKopQax         .MACRO param
                  .BYTE $BBFD
		  .WORD  param
                  .ENDM
                  
SBCLopAax         .MACRO param
                  .BYTE $8CFD
		  .WORD  param
                  .ENDM                
SBCLopBax         .MACRO param          
                  .BYTE $8DFD
		  .WORD  param
                  .ENDM
SBCLopCax         .MACRO param
                  .BYTE $8EFD
		  .WORD  param
                  .ENDM
SBCLopDax         .MACRO param
                  .BYTE $8FFD
		  .WORD  param
                  .ENDM
SBCLopEax         .MACRO param          
                  .BYTE $9CFD
		  .WORD  param
                  .ENDM
SBCLopFax         .MACRO param
                  .BYTE $9DFD
		  .WORD  param
                  .ENDM
SBCLopGax         .MACRO param
                  .BYTE $9EFD
		  .WORD  param
                  .ENDM                  
SBCLopHax         .MACRO param          
                  .BYTE $9FFD
		  .WORD  param
                  .ENDM
SBCLopIax         .MACRO param
                  .BYTE $ACFD
		  .WORD  param
                  .ENDM
SBCLopJax         .MACRO param
                  .BYTE $ADFD
		  .WORD  param
                  .ENDM
SBCLopKax         .MACRO param          
                  .BYTE $AEFD
		  .WORD  param
                  .ENDM
SBCLopLax         .MACRO param
                  .BYTE $AFFD
		  .WORD  param
                  .ENDM
SBCLopMax         .MACRO param
                  .BYTE $BCFD
		  .WORD  param
                  .ENDM                  
SBCLopNax         .MACRO param          
                  .BYTE $BDFD
		  .WORD  param
                  .ENDM
SBCLopOax         .MACRO param
                  .BYTE $BEFD
		  .WORD  param
                  .ENDM
SBCLopQax         .MACRO param
                  .BYTE $BFFD
		  .WORD  param
                  .ENDM
                  
SBCMopAax         .MACRO param
                  .BYTE $C0FD
		  .WORD  param
                  .ENDM                
SBCMopBax         .MACRO param          
                  .BYTE $C1FD
		  .WORD  param
                  .ENDM
SBCMopCax         .MACRO param
                  .BYTE $C2FD
		  .WORD  param
                  .ENDM
SBCMopDax         .MACRO param
                  .BYTE $C3FD
		  .WORD  param
                  .ENDM
SBCMopEax         .MACRO param          
                  .BYTE $D0FD
		  .WORD  param
                  .ENDM
SBCMopFax         .MACRO param
                  .BYTE $D1FD
		  .WORD  param
                  .ENDM
SBCMopGax         .MACRO param
                  .BYTE $D2FD
		  .WORD  param
                  .ENDM                  
SBCMopHax         .MACRO param          
                  .BYTE $D3FD
		  .WORD  param
                  .ENDM
SBCMopIax         .MACRO param
                  .BYTE $E0FD
		  .WORD  param
                  .ENDM
SBCMopJax         .MACRO param
                  .BYTE $E1FD
		  .WORD  param
                  .ENDM
SBCMopKax         .MACRO param          
                  .BYTE $E2FD
		  .WORD  param
                  .ENDM
SBCMopLax         .MACRO param
                  .BYTE $E3FD
		  .WORD  param
                  .ENDM
SBCMopMax         .MACRO param
                  .BYTE $F0FD
		  .WORD  param
                  .ENDM                  
SBCMopNax         .MACRO param          
                  .BYTE $F1FD
		  .WORD  param
                  .ENDM
SBCMopOax         .MACRO param
                  .BYTE $F2FD
		  .WORD  param
                  .ENDM
SBCMopQax         .MACRO param
                  .BYTE $F3FD
		  .WORD  param
                  .ENDM
                  
SBCNopAax         .MACRO param
                  .BYTE $C4FD
		  .WORD  param
                  .ENDM                
SBCNopBax         .MACRO param          
                  .BYTE $C5FD
		  .WORD  param
                  .ENDM
SBCNopCax         .MACRO param
                  .BYTE $C6FD
		  .WORD  param
                  .ENDM
SBCNopDax         .MACRO param
                  .BYTE $C7FD
		  .WORD  param
                  .ENDM
SBCNopEax         .MACRO param          
                  .BYTE $D4FD
		  .WORD  param
                  .ENDM
SBCNopFax         .MACRO param
                  .BYTE $D5FD
		  .WORD  param
                  .ENDM
SBCNopGax         .MACRO param
                  .BYTE $D6FD
		  .WORD  param
                  .ENDM                  
SBCNopHax         .MACRO param          
                  .BYTE $D7FD
		  .WORD  param
                  .ENDM
SBCNopIax         .MACRO param
                  .BYTE $E4FD
		  .WORD  param
                  .ENDM
SBCNopJax         .MACRO param
                  .BYTE $E5FD
		  .WORD  param
                  .ENDM
SBCNopKax         .MACRO param          
                  .BYTE $E6FD
		  .WORD  param
                  .ENDM
SBCNopLax         .MACRO param
                  .BYTE $E7FD
		  .WORD  param
                  .ENDM
SBCNopMax         .MACRO param
                  .BYTE $F4FD
		  .WORD  param
                  .ENDM                  
SBCNopNax         .MACRO param          
                  .BYTE $F5FD
		  .WORD  param
                  .ENDM
SBCNopOax         .MACRO param
                  .BYTE $F6FD
		  .WORD  param
                  .ENDM
SBCNopQax         .MACRO param
                  .BYTE $F7FD
		  .WORD  param
                  .ENDM
            
SBCOopAax         .MACRO param
                  .BYTE $C8FD
		  .WORD  param
                  .ENDM                
SBCOopBax         .MACRO param          
                  .BYTE $C9FD
		  .WORD  param
                  .ENDM
SBCOopCax         .MACRO param
                  .BYTE $CAFD
		  .WORD  param
                  .ENDM
SBCOopDax         .MACRO param
                  .BYTE $CBFD
		  .WORD  param
                  .ENDM
SBCOopEax         .MACRO param          
                  .BYTE $D8FD
		  .WORD  param
                  .ENDM
SBCOopFax         .MACRO param
                  .BYTE $D9FD
		  .WORD  param
                  .ENDM
SBCOopGax         .MACRO param
                  .BYTE $DAFD
		  .WORD  param
                  .ENDM                  
SBCOopHax         .MACRO param          
                  .BYTE $DBFD
		  .WORD  param
                  .ENDM
SBCOopIax         .MACRO param
                  .BYTE $E8FD
		  .WORD  param
                  .ENDM
SBCOopJax         .MACRO param
                  .BYTE $E9FD
		  .WORD  param
                  .ENDM
SBCOopKax         .MACRO param          
                  .BYTE $EAFD
		  .WORD  param
                  .ENDM
SBCOopLax         .MACRO param
                  .BYTE $EBFD
		  .WORD  param
                  .ENDM
SBCOopMax         .MACRO param
                  .BYTE $F8FD
		  .WORD  param
                  .ENDM                  
SBCOopNax         .MACRO param          
                  .BYTE $F9FD
		  .WORD  param
                  .ENDM
SBCOopOax         .MACRO param
                  .BYTE $FAFD
		  .WORD  param
                  .ENDM
SBCOopQax         .MACRO param
                  .BYTE $FBFD
		  .WORD  param
                  .ENDM
                  
SBCQopAax         .MACRO param
                  .BYTE $CCFD
		  .WORD  param
                  .ENDM                
SBCQopBax         .MACRO param          
                  .BYTE $CDFD
		  .WORD  param
                  .ENDM
SBCQopCax         .MACRO param
                  .BYTE $CEFD
		  .WORD  param
                  .ENDM
SBCQopDax         .MACRO param
                  .BYTE $CFFD
		  .WORD  param
                  .ENDM
SBCQopEax         .MACRO param          
                  .BYTE $DCFD
		  .WORD  param
                  .ENDM
SBCQopFax         .MACRO param
                  .BYTE $DDFD
		  .WORD  param
                  .ENDM
SBCQopGax         .MACRO param
                  .BYTE $DEFD
		  .WORD  param
                  .ENDM                  
SBCQopHax         .MACRO param          
                  .BYTE $DFFD
		  .WORD  param
                  .ENDM
SBCQopIax         .MACRO param
                  .BYTE $ECFD
		  .WORD  param
                  .ENDM
SBCQopJax         .MACRO param
                  .BYTE $EDFD
		  .WORD  param
                  .ENDM
SBCQopKax         .MACRO param          
                  .BYTE $EEFD
		  .WORD  param
                  .ENDM
SBCQopLax         .MACRO param
                  .BYTE $EFFD
		  .WORD  param
                  .ENDM
SBCQopMax         .MACRO param
                  .BYTE $FCFD
		  .WORD  param
                  .ENDM                  
SBCQopNax         .MACRO param          
                  .BYTE $FDFD
		  .WORD  param
                  .ENDM
SBCQopOax         .MACRO param
                  .BYTE $FEFD
		  .WORD  param
                  .ENDM
SBCQopQax         .MACRO param
                  .BYTE $FFFD
		  .WORD  param
                  .ENDM

;ORA $xxxxxxxx,x        $001D
ORAAopBax         .MACRO param          
                  .BYTE $011D
		  .WORD  param
                  .ENDM
ORAAopCax         .MACRO param
                  .BYTE $021D
		  .WORD  param
                  .ENDM
ORAAopDax         .MACRO param
                  .BYTE $031D
		  .WORD  param
                  .ENDM
ORAAopEax         .MACRO param          
                  .BYTE $101D
		  .WORD  param
                  .ENDM
ORAAopFax         .MACRO param
                  .BYTE $111D
		  .WORD  param
                  .ENDM
ORAAopGax         .MACRO param
                  .BYTE $121D
		  .WORD  param
                  .ENDM                  
ORAAopHax         .MACRO param          
                  .BYTE $131D
		  .WORD  param
                  .ENDM
ORAAopIax         .MACRO param
                  .BYTE $201D
		  .WORD  param
                  .ENDM
ORAAopJax         .MACRO param
                  .BYTE $211D
		  .WORD  param
                  .ENDM
ORAAopKax         .MACRO param          
                  .BYTE $221D
		  .WORD  param
                  .ENDM
ORAAopLax         .MACRO param
                  .BYTE $231D
		  .WORD  param
                  .ENDM
ORAAopMax         .MACRO param
                  .BYTE $301D
		  .WORD  param
                  .ENDM                  
ORAAopNax         .MACRO param          
                  .BYTE $311D
		  .WORD  param
                  .ENDM
ORAAopOax         .MACRO param
                  .BYTE $321D
		  .WORD  param
                  .ENDM
ORAAopQax         .MACRO param
                  .BYTE $331D
		  .WORD  param
                  .ENDM
                                    
ORABopAax         .MACRO param
                  .BYTE $041D
		  .WORD  param
                  .ENDM                
ORABopBax         .MACRO param          
                  .BYTE $051D
		  .WORD  param
                  .ENDM
ORABopCax         .MACRO param
                  .BYTE $061D
		  .WORD  param
                  .ENDM
ORABopDax         .MACRO param
                  .BYTE $071D
		  .WORD  param
                  .ENDM
ORABopEax         .MACRO param          
                  .BYTE $141D
		  .WORD  param
                  .ENDM
ORABopFax         .MACRO param
                  .BYTE $151D
		  .WORD  param
                  .ENDM
ORABopGax         .MACRO param
                  .BYTE $161D
		  .WORD  param
                  .ENDM                  
ORABopHax         .MACRO param          
                  .BYTE $171D
		  .WORD  param
                  .ENDM
ORABopIax         .MACRO param
                  .BYTE $241D
		  .WORD  param
                  .ENDM
ORABopJax         .MACRO param
                  .BYTE $251D
		  .WORD  param
                  .ENDM
ORABopKax         .MACRO param          
                  .BYTE $261D
		  .WORD  param
                  .ENDM
ORABopLax         .MACRO param
                  .BYTE $271D
		  .WORD  param
                  .ENDM
ORABopMax         .MACRO param
                  .BYTE $301D
		  .WORD  param
                  .ENDM                  
ORABopNax         .MACRO param          
                  .BYTE $311D
		  .WORD  param
                  .ENDM
ORABopOax         .MACRO param
                  .BYTE $321D
		  .WORD  param
                  .ENDM
ORABopQax         .MACRO param
                  .BYTE $331D
		  .WORD  param
                  .ENDM
                                    
ORACopAax         .MACRO param
                  .BYTE $081D
		  .WORD  param
                  .ENDM                
ORACopBax         .MACRO param          
                  .BYTE $091D
		  .WORD  param
                  .ENDM
ORACopCax         .MACRO param
                  .BYTE $0A1D
		  .WORD  param
                  .ENDM
ORACopDax         .MACRO param
                  .BYTE $0B1D
		  .WORD  param
                  .ENDM
ORACopEax         .MACRO param          
                  .BYTE $181D
		  .WORD  param
                  .ENDM
ORACopFax         .MACRO param
                  .BYTE $191D
		  .WORD  param
                  .ENDM
ORACopGax         .MACRO param
                  .BYTE $1A1D
		  .WORD  param
                  .ENDM                  
ORACopHax         .MACRO param          
                  .BYTE $1B1D
		  .WORD  param
                  .ENDM
ORACopIax         .MACRO param
                  .BYTE $281D
		  .WORD  param
                  .ENDM
ORACopJax         .MACRO param
                  .BYTE $291D
		  .WORD  param
                  .ENDM
ORACopKax         .MACRO param          
                  .BYTE $2A1D
		  .WORD  param
                  .ENDM
ORACopLax         .MACRO param
                  .BYTE $2B1D
		  .WORD  param
                  .ENDM
ORACopMax         .MACRO param
                  .BYTE $381D
		  .WORD  param
                  .ENDM                  
ORACopNax         .MACRO param          
                  .BYTE $391D
	 	  .WORD  param
                  .ENDM
ORACopOax         .MACRO param
                  .BYTE $3A1D
		  .WORD  param
                  .ENDM
ORACopQax         .MACRO param
                  .BYTE $3B1D
		  .WORD  param
                  .ENDM

ORADopAax         .MACRO param
                  .BYTE $0C1D
		  .WORD  param
                  .ENDM                
ORADopBax         .MACRO param          
                  .BYTE $0D1D
		  .WORD  param
                  .ENDM
ORADopCax         .MACRO param
                  .BYTE $0E1D
		  .WORD  param
                  .ENDM
ORADopDax         .MACRO param
                  .BYTE $0F1D
		  .WORD  param
                  .ENDM
ORADopEax         .MACRO param          
                  .BYTE $1C1D
		  .WORD  param
                  .ENDM
ORADopFax         .MACRO param
                  .BYTE $1D1D
		  .WORD  param
                  .ENDM
ORADopGax         .MACRO param
                  .BYTE $1E1D
		  .WORD  param
                  .ENDM                  
ORADopHax         .MACRO param          
                  .BYTE $1F1D
		  .WORD  param
                  .ENDM
ORADopIax         .MACRO param
                  .BYTE $2C1D
		  .WORD  param
                  .ENDM
ORADopJax         .MACRO param
                  .BYTE $2D1D
		  .WORD  param
                  .ENDM
ORADopKax         .MACRO param          
                  .BYTE $2E1D
		  .WORD  param
                  .ENDM
ORADopLax         .MACRO param
                  .BYTE $2F1D
		  .WORD  param
                  .ENDM
ORADopMax         .MACRO param
                  .BYTE $3C1D
		  .WORD  param
                  .ENDM                  
ORADopNax         .MACRO param          
                  .BYTE $3D1D
		  .WORD  param
                  .ENDM
ORADopOax         .MACRO param
                  .BYTE $3E1D
		  .WORD  param
                  .ENDM
ORADopQax         .MACRO param
                  .BYTE $3F1D
		  .WORD  param
                  .ENDM                  

ORAEopAax         .MACRO param
                  .BYTE $401D
		  .WORD  param
                  .ENDM                
ORAEopBax         .MACRO param          
                  .BYTE $411D
		  .WORD  param
                  .ENDM
ORAEopCax         .MACRO param
                  .BYTE $421D
		  .WORD  param
                  .ENDM
ORAEopDax         .MACRO param
                  .BYTE $431D
		  .WORD  param
                  .ENDM
ORAEopEax         .MACRO param          
                  .BYTE $501D
		  .WORD  param
                  .ENDM
ORAEopFax         .MACRO param
                  .BYTE $511D
		  .WORD  param
                  .ENDM
ORAEopGax         .MACRO param
                  .BYTE $521D
		  .WORD  param
                  .ENDM                  
ORAEopHax         .MACRO param          
                  .BYTE $531D
		  .WORD  param
                  .ENDM
ORAEopIax         .MACRO param
                  .BYTE $601D
		  .WORD  param
                  .ENDM
ORAEopJax         .MACRO param
                  .BYTE $611D
		  .WORD  param
                  .ENDM
ORAEopKax         .MACRO param          
                  .BYTE $621D
		  .WORD  param
                  .ENDM
ORAEopLax         .MACRO param
                  .BYTE $631D
		  .WORD  param
                  .ENDM
ORAEopMax         .MACRO param
                  .BYTE $701D
		  .WORD  param
                  .ENDM                  
ORAEopNax         .MACRO param          
                  .BYTE $711D
		  .WORD  param
                  .ENDM
ORAEopOax         .MACRO param
                  .BYTE $721D
		  .WORD  param
                  .ENDM
ORAEopQax         .MACRO param
                  .BYTE $731D
		  .WORD  param
                  .ENDM
                  
ORAFopAax         .MACRO param
                  .BYTE $441D
		  .WORD  param
                  .ENDM                
ORAFopBax         .MACRO param          
                  .BYTE $451D
		  .WORD  param
                  .ENDM
ORAFopCax         .MACRO param
                  .BYTE $461D
		  .WORD  param
                  .ENDM
ORAFopDax         .MACRO param
                  .BYTE $471D
		  .WORD  param
                  .ENDM
ORAFopEax         .MACRO param          
                  .BYTE $541D
		  .WORD  param
                  .ENDM
ORAFopFax         .MACRO param
                  .BYTE $551D
		  .WORD  param
                  .ENDM
ORAFopGax         .MACRO param
                  .BYTE $561D
		  .WORD  param
                  .ENDM                  
ORAFopHax         .MACRO param          
                  .BYTE $571D
		  .WORD  param
                  .ENDM
ORAFopIax         .MACRO param
                  .BYTE $641D
	 	  .WORD  param
                  .ENDM
ORAFopJax         .MACRO param
                  .BYTE $651D
		  .WORD  param
                  .ENDM
ORAFopKax         .MACRO param          
                  .BYTE $661D
		  .WORD  param
                  .ENDM
ORAFopLax         .MACRO param
                  .BYTE $671D
		  .WORD  param
                  .ENDM
ORAFopMax         .MACRO param
                  .BYTE $741D
		  .WORD  param
                  .ENDM                  
ORAFopNax         .MACRO param          
                  .BYTE $751D
		  .WORD  param
                  .ENDM
ORAFopOax         .MACRO param
                  .BYTE $761D
		  .WORD  param
                  .ENDM
ORAFopQax         .MACRO param
                  .BYTE $771D
		  .WORD  param
                  .ENDM                  
                           
ORAGopAax         .MACRO param
                  .BYTE $481D
		  .WORD  param
                  .ENDM                
ORAGopBax         .MACRO param          
                  .BYTE $491D
		  .WORD  param
                  .ENDM
ORAGopCax         .MACRO param
                  .BYTE $4A1D
		  .WORD  param
                  .ENDM
ORAGopDax         .MACRO param
                  .BYTE $4B1D
		  .WORD  param
                  .ENDM
ORAGopEax         .MACRO param          
                  .BYTE $581D
		  .WORD  param
                  .ENDM
ORAGopFax         .MACRO param
                  .BYTE $591D
		  .WORD  param
                  .ENDM
ORAGopGax         .MACRO param
                  .BYTE $5A1D
		  .WORD  param
                  .ENDM                  
ORAGopHax         .MACRO param          
                  .BYTE $5B1D
		  .WORD  param
                  .ENDM
ORAGopIax         .MACRO param
                  .BYTE $681D
		  .WORD  param
                  .ENDM
ORAGopJax         .MACRO param
                  .BYTE $691D
		  .WORD  param
                  .ENDM
ORAGopKax         .MACRO param          
                  .BYTE $6A1D
		  .WORD  param
                  .ENDM
ORAGopLax         .MACRO param
                  .BYTE $6B1D
		  .WORD  param
                  .ENDM
ORAGopMax         .MACRO param
                  .BYTE $781D
		  .WORD  param
                  .ENDM                  
ORAGopNax         .MACRO param          
                  .BYTE $791D
		  .WORD  param
                  .ENDM
ORAGopOax         .MACRO param
                  .BYTE $7A1D
		  .WORD  param
                  .ENDM
ORAGopQax         .MACRO param
                  .BYTE $7B1D
		  .WORD  param
                  .ENDM
                  
ORAHopAax         .MACRO param
                  .BYTE $4C1D
		  .WORD  param
                  .ENDM                
ORAHopBax         .MACRO param          
                  .BYTE $4D1D
		  .WORD  param
                  .ENDM
ORAHopCax         .MACRO param
                  .BYTE $4E1D
		  .WORD  param
                  .ENDM
ORAHopDax         .MACRO param
                  .BYTE $4F1D
		  .WORD  param
                  .ENDM
ORAHopEax         .MACRO param          
                  .BYTE $5C1D
		  .WORD  param
                  .ENDM
ORAHopFax         .MACRO param
                  .BYTE $5D1D
		  .WORD  param
                  .ENDM
ORAHopGax         .MACRO param
                  .BYTE $5E1D
		  .WORD  param
                  .ENDM                  
ORAHopHax         .MACRO param          
                  .BYTE $5F1D
		  .WORD  param
                  .ENDM
ORAHopIax         .MACRO param
                  .BYTE $6C1D
		  .WORD  param
                  .ENDM
ORAHopJax         .MACRO param
                  .BYTE $6D1D
		  .WORD  param
                  .ENDM
ORAHopKax         .MACRO param          
                  .BYTE $6E1D
		  .WORD  param
                  .ENDM
ORAHopLax         .MACRO param
                  .BYTE $6F1D
		  .WORD  param
                  .ENDM
ORAHopMax         .MACRO param
                  .BYTE $7C1D
		  .WORD  param
                  .ENDM                  
ORAHopNax         .MACRO param          
                  .BYTE $7D1D
		  .WORD  param
                  .ENDM
ORAHopOax         .MACRO param
                  .BYTE $7E1D
		  .WORD  param
                  .ENDM
ORAHopQax         .MACRO param
                  .BYTE $7F1D
		  .WORD  param
                  .ENDM
                  
ORAIopAax         .MACRO param
                  .BYTE $801D
		  .WORD  param
                  .ENDM                
ORAIopBax         .MACRO param          
                  .BYTE $811D
		  .WORD  param
                  .ENDM
ORAIopCax         .MACRO param
                  .BYTE $821D
		  .WORD  param
                  .ENDM
ORAIopDax         .MACRO param
                  .BYTE $831D
		  .WORD  param
                  .ENDM
ORAIopEax         .MACRO param          
                  .BYTE $901D
		  .WORD  param
                  .ENDM
ORAIopFax         .MACRO param
                  .BYTE $911D
		  .WORD  param
                  .ENDM
ORAIopGax         .MACRO param
                  .BYTE $921D
		  .WORD  param
                  .ENDM                  
ORAIopHax         .MACRO param          
                  .BYTE $931D
		  .WORD  param
                  .ENDM
ORAIopIax         .MACRO param
                  .BYTE $A01D
		  .WORD  param
                  .ENDM
ORAIopJax         .MACRO param
                  .BYTE $A11D
		  .WORD  param
                  .ENDM
ORAIopKax         .MACRO param          
                  .BYTE $A21D
		  .WORD  param
                  .ENDM
ORAIopLax         .MACRO param
                  .BYTE $A31D
		  .WORD  param
                  .ENDM
ORAIopMax         .MACRO param
                  .BYTE $B01D
		  .WORD  param
                  .ENDM                  
ORAIopNax         .MACRO param          
                  .BYTE $B11D
		  .WORD  param
                  .ENDM
ORAIopOax         .MACRO param
                  .BYTE $B21D
		  .WORD  param
                  .ENDM
ORAIopQax         .MACRO param
                  .BYTE $B31D
		  .WORD  param
                  .ENDM
                  
ORAJopAax         .MACRO param
                  .BYTE $841D
		  .WORD  param
                  .ENDM                
ORAJopBax         .MACRO param          
                  .BYTE $851D
		  .WORD  param
                  .ENDM
ORAJopCax         .MACRO param
                  .BYTE $861D
		  .WORD  param
                  .ENDM
ORAJopDax         .MACRO param
                  .BYTE $871D
		  .WORD  param
                  .ENDM
ORAJopEax         .MACRO param          
                  .BYTE $941D
		  .WORD  param
                  .ENDM
ORAJopFax         .MACRO param
                  .BYTE $951D
		  .WORD  param
                  .ENDM
ORAJopGax         .MACRO param
                  .BYTE $961D
		  .WORD  param
                  .ENDM                  
ORAJopHax         .MACRO param          
                  .BYTE $971D
		  .WORD  param
                  .ENDM
ORAJopIax         .MACRO param
                  .BYTE $A41D
		  .WORD  param
                  .ENDM
ORAJopJax         .MACRO param
                  .BYTE $A51D
		  .WORD  param
                  .ENDM
ORAJopKax         .MACRO param          
                  .BYTE $A61D
 		  .WORD  param
                  .ENDM
ORAJopLax         .MACRO param
                  .BYTE $A71D
		  .WORD  param
                  .ENDM
ORAJopMax         .MACRO param
                  .BYTE $B41D
		  .WORD  param
                  .ENDM                  
ORAJopNax         .MACRO param          
                  .BYTE $B51D
		  .WORD  param
                  .ENDM
ORAJopOax         .MACRO param
                  .BYTE $B61D
		  .WORD  param
                  .ENDM
ORAJopQax         .MACRO param
                  .BYTE $B71D
		  .WORD  param
                  .ENDM
                  
ORAKopAax         .MACRO param
                  .BYTE $881D
		  .WORD  param
                  .ENDM                
ORAKopBax         .MACRO param          
                  .BYTE $891D
		  .WORD  param
                  .ENDM
ORAKopCax         .MACRO param
                  .BYTE $8A1D
		  .WORD  param
                  .ENDM
ORAKopDax         .MACRO param
                  .BYTE $8B1D
		  .WORD  param
                  .ENDM
ORAKopEax         .MACRO param          
                  .BYTE $981D
		  .WORD  param
                  .ENDM
ORAKopFax         .MACRO param
                  .BYTE $991D
		  .WORD  param
                  .ENDM
ORAKopGax         .MACRO param
                  .BYTE $9A1D
		  .WORD  param
                  .ENDM                  
ORAKopHax         .MACRO param          
                  .BYTE $9B1D
		  .WORD  param
                  .ENDM
ORAKopIax         .MACRO param
                  .BYTE $A81D
		  .WORD  param
                  .ENDM
ORAKopJax         .MACRO param
                  .BYTE $A91D
		  .WORD  param
                  .ENDM
ORAKopKax         .MACRO param          
                  .BYTE $AA1D
		  .WORD  param
                  .ENDM
ORAKopLax         .MACRO param
                  .BYTE $AB1D
		  .WORD  param
                  .ENDM
ORAKopMax         .MACRO param
                  .BYTE $B81D
		  .WORD  param
                  .ENDM                  
ORAKopNax         .MACRO param          
                  .BYTE $B91D
		  .WORD  param
                  .ENDM
ORAKopOax         .MACRO param
                  .BYTE $BA1D
		  .WORD  param
                  .ENDM
ORAKopQax         .MACRO param
                  .BYTE $BB1D
		  .WORD  param
                  .ENDM
                  
ORALopAax         .MACRO param
                  .BYTE $8C1D
		  .WORD  param
                  .ENDM                
ORALopBax         .MACRO param          
                  .BYTE $8D1D
		  .WORD  param
                  .ENDM
ORALopCax         .MACRO param
                  .BYTE $8E1D
		  .WORD  param
                  .ENDM
ORALopDax         .MACRO param
                  .BYTE $8F1D
		  .WORD  param
                  .ENDM
ORALopEax         .MACRO param          
                  .BYTE $9C1D
		  .WORD  param
                  .ENDM
ORALopFax         .MACRO param
                  .BYTE $9D1D
		  .WORD  param
                  .ENDM
ORALopGax         .MACRO param
                  .BYTE $9E1D
		  .WORD  param
                  .ENDM                  
ORALopHax         .MACRO param          
                  .BYTE $9F1D
		  .WORD  param
                  .ENDM
ORALopIax         .MACRO param
                  .BYTE $AC1D
		  .WORD  param
                  .ENDM
ORALopJax         .MACRO param
                  .BYTE $AD1D
		  .WORD  param
                  .ENDM
ORALopKax         .MACRO param          
                  .BYTE $AE1D
		  .WORD  param
                  .ENDM
ORALopLax         .MACRO param
                  .BYTE $AF1D
		  .WORD  param
                  .ENDM
ORALopMax         .MACRO param
                  .BYTE $BC1D
		  .WORD  param
                  .ENDM                  
ORALopNax         .MACRO param          
                  .BYTE $BD1D
		  .WORD  param
                  .ENDM
ORALopOax         .MACRO param
                  .BYTE $BE1D
		  .WORD  param
                  .ENDM
ORALopQax         .MACRO param
                  .BYTE $BF1D
		  .WORD  param
                  .ENDM
                  
ORAMopAax         .MACRO param
                  .BYTE $C01D
		  .WORD  param
                  .ENDM                
ORAMopBax         .MACRO param          
                  .BYTE $C11D
		  .WORD  param
                  .ENDM
ORAMopCax         .MACRO param
                  .BYTE $C21D
		  .WORD  param
                  .ENDM
ORAMopDax         .MACRO param
                  .BYTE $C31D
		  .WORD  param
                  .ENDM
ORAMopEax         .MACRO param          
                  .BYTE $D01D
		  .WORD  param
                  .ENDM
ORAMopFax         .MACRO param
                  .BYTE $D11D
		  .WORD  param
                  .ENDM
ORAMopGax         .MACRO param
                  .BYTE $D21D
		  .WORD  param
                  .ENDM                  
ORAMopHax         .MACRO param          
                  .BYTE $D31D
		  .WORD  param
                  .ENDM
ORAMopIax         .MACRO param
                  .BYTE $E01D
		  .WORD  param
                  .ENDM
ORAMopJax         .MACRO param
                  .BYTE $E11D
		  .WORD  param
                  .ENDM
ORAMopKax         .MACRO param          
                  .BYTE $E21D
		  .WORD  param
                  .ENDM
ORAMopLax         .MACRO param
                  .BYTE $E31D
		  .WORD  param
                  .ENDM
ORAMopMax         .MACRO param
                  .BYTE $F01D
		  .WORD  param
                  .ENDM                  
ORAMopNax         .MACRO param          
                  .BYTE $F11D
		  .WORD  param
                  .ENDM
ORAMopOax         .MACRO param
                  .BYTE $F21D
		  .WORD  param
                  .ENDM
ORAMopQax         .MACRO param
                  .BYTE $F31D
		  .WORD  param
                  .ENDM
                  
ORANopAax         .MACRO param
                  .BYTE $C41D
		  .WORD  param
                  .ENDM                
ORANopBax         .MACRO param          
                  .BYTE $C51D
		  .WORD  param
                  .ENDM
ORANopCax         .MACRO param
                  .BYTE $C61D
		  .WORD  param
                  .ENDM
ORANopDax         .MACRO param
                  .BYTE $C71D
		  .WORD  param
                  .ENDM
ORANopEax         .MACRO param          
                  .BYTE $D41D
		  .WORD  param
                  .ENDM
ORANopFax         .MACRO param
                  .BYTE $D51D
		  .WORD  param
                  .ENDM
ORANopGax         .MACRO param
                  .BYTE $D61D
		  .WORD  param
                  .ENDM                  
ORANopHax         .MACRO param          
                  .BYTE $D71D
		  .WORD  param
                  .ENDM
ORANopIax         .MACRO param
                  .BYTE $E41D
		  .WORD  param
                  .ENDM
ORANopJax         .MACRO param
                  .BYTE $E51D
		  .WORD  param
                  .ENDM
ORANopKax         .MACRO param          
                  .BYTE $E61D
		  .WORD  param
                  .ENDM
ORANopLax         .MACRO param
                  .BYTE $E71D
		  .WORD  param
                  .ENDM
ORANopMax         .MACRO param
                  .BYTE $F41D
		  .WORD  param
                  .ENDM                  
ORANopNax         .MACRO param          
                  .BYTE $F51D
		  .WORD  param
                  .ENDM
ORANopOax         .MACRO param
                  .BYTE $F61D
		  .WORD  param
                  .ENDM
ORANopQax         .MACRO param
                  .BYTE $F71D
		  .WORD  param
                  .ENDM
            
ORAOopAax         .MACRO param
                  .BYTE $C81D
		  .WORD  param
                  .ENDM                
ORAOopBax         .MACRO param          
                  .BYTE $C91D
		  .WORD  param
                  .ENDM
ORAOopCax         .MACRO param
                  .BYTE $CA1D
		  .WORD  param
                  .ENDM
ORAOopDax         .MACRO param
                  .BYTE $CB1D
		  .WORD  param
                  .ENDM
ORAOopEax         .MACRO param          
                  .BYTE $D81D
		  .WORD  param
                  .ENDM
ORAOopFax         .MACRO param
                  .BYTE $D91D
		  .WORD  param
                  .ENDM
ORAOopGax         .MACRO param
                  .BYTE $DA1D
		  .WORD  param
                  .ENDM                  
ORAOopHax         .MACRO param          
                  .BYTE $DB1D
		  .WORD  param
                  .ENDM
ORAOopIax         .MACRO param
                  .BYTE $E81D
		  .WORD  param
                  .ENDM
ORAOopJax         .MACRO param
                  .BYTE $E91D
		  .WORD  param
                  .ENDM
ORAOopKax         .MACRO param          
                  .BYTE $EA1D
		  .WORD  param
                  .ENDM
ORAOopLax         .MACRO param
                  .BYTE $EB1D
		  .WORD  param
                  .ENDM
ORAOopMax         .MACRO param
                  .BYTE $F81D
		  .WORD  param
                  .ENDM                  
ORAOopNax         .MACRO param          
                  .BYTE $F91D
		  .WORD  param
                  .ENDM
ORAOopOax         .MACRO param
                  .BYTE $FA1D
		  .WORD  param
                  .ENDM
ORAOopQax         .MACRO param
                  .BYTE $FB1D
		  .WORD  param
                  .ENDM
                  
ORAQopAax         .MACRO param
                  .BYTE $CC1D
		  .WORD  param
                  .ENDM                
ORAQopBax         .MACRO param          
                  .BYTE $CD1D
		  .WORD  param
                  .ENDM
ORAQopCax         .MACRO param
                  .BYTE $CE1D
		  .WORD  param
                  .ENDM
ORAQopDax         .MACRO param
                  .BYTE $CF1D
		  .WORD  param
                  .ENDM
ORAQopEax         .MACRO param          
                  .BYTE $DC1D
		  .WORD  param
                  .ENDM
ORAQopFax         .MACRO param
                  .BYTE $DD1D
		  .WORD  param
                  .ENDM
ORAQopGax         .MACRO param
                  .BYTE $DE1D
		  .WORD  param
                  .ENDM                  
ORAQopHax         .MACRO param          
                  .BYTE $DF1D
		  .WORD  param
                  .ENDM
ORAQopIax         .MACRO param
                  .BYTE $EC1D
		  .WORD  param
                  .ENDM
ORAQopJax         .MACRO param
                  .BYTE $ED1D
		  .WORD  param
                  .ENDM
ORAQopKax         .MACRO param          
                  .BYTE $EE1D
		  .WORD  param
                  .ENDM
ORAQopLax         .MACRO param
                  .BYTE $EF1D
		  .WORD  param
                  .ENDM
ORAQopMax         .MACRO param
                  .BYTE $FC1D
		  .WORD  param
                  .ENDM                  
ORAQopNax         .MACRO param          
                  .BYTE $FD1D
		  .WORD  param
                  .ENDM
ORAQopOax         .MACRO param
                  .BYTE $FE1D
		  .WORD  param
                  .ENDM
ORAQopQax         .MACRO param
                  .BYTE $FF1D
		  .WORD  param
                  .ENDM

;AND $xxxxxxxx,x        $003D
ANDAopBax         .MACRO param          
                  .BYTE $013D
		  .WORD  param
                  .ENDM
ANDAopCax         .MACRO param
                  .BYTE $023D
		  .WORD  param
                  .ENDM
ANDAopDax         .MACRO param
                  .BYTE $033D
		  .WORD  param
                  .ENDM
ANDAopEax         .MACRO param          
                  .BYTE $103D
		  .WORD  param
                  .ENDM
ANDAopFax         .MACRO param
                  .BYTE $113D
		  .WORD  param
                  .ENDM
ANDAopGax         .MACRO param
                  .BYTE $123D
		  .WORD  param
                  .ENDM                  
ANDAopHax         .MACRO param          
                  .BYTE $133D
		  .WORD  param
                  .ENDM
ANDAopIax         .MACRO param
                  .BYTE $203D
		  .WORD  param
                  .ENDM
ANDAopJax         .MACRO param
                  .BYTE $213D
		  .WORD  param
                  .ENDM
ANDAopKax         .MACRO param          
                  .BYTE $223D
		  .WORD  param
                  .ENDM
ANDAopLax         .MACRO param
                  .BYTE $233D
		  .WORD  param
                  .ENDM
ANDAopMax         .MACRO param
                  .BYTE $303D
		  .WORD  param
                  .ENDM                  
ANDAopNax         .MACRO param          
                  .BYTE $313D
		  .WORD  param
                  .ENDM
ANDAopOax         .MACRO param
                  .BYTE $323D
		  .WORD  param
                  .ENDM
ANDAopQax         .MACRO param
                  .BYTE $333D
		  .WORD  param
                  .ENDM
                                    
ANDBopAax         .MACRO param
                  .BYTE $043D
		  .WORD  param
                  .ENDM                
ANDBopBax         .MACRO param          
                  .BYTE $053D
		  .WORD  param
                  .ENDM
ANDBopCax         .MACRO param
                  .BYTE $063D
		  .WORD  param
                  .ENDM
ANDBopDax         .MACRO param
                  .BYTE $073D
		  .WORD  param
                  .ENDM
ANDBopEax         .MACRO param          
                  .BYTE $143D
		  .WORD  param
                  .ENDM
ANDBopFax         .MACRO param
                  .BYTE $153D
		  .WORD  param
                  .ENDM
ANDBopGax         .MACRO param
                  .BYTE $163D
		  .WORD  param
                  .ENDM                  
ANDBopHax         .MACRO param          
                  .BYTE $173D
		  .WORD  param
                  .ENDM
ANDBopIax         .MACRO param
                  .BYTE $243D
		  .WORD  param
                  .ENDM
ANDBopJax         .MACRO param
                  .BYTE $253D
		  .WORD  param
                  .ENDM
ANDBopKax         .MACRO param          
                  .BYTE $263D
		  .WORD  param
                  .ENDM
ANDBopLax         .MACRO param
                  .BYTE $273D
		  .WORD  param
                  .ENDM
ANDBopMax         .MACRO param
                  .BYTE $303D
		  .WORD  param
                  .ENDM                  
ANDBopNax         .MACRO param          
                  .BYTE $313D
		  .WORD  param
                  .ENDM
ANDBopOax         .MACRO param
                  .BYTE $323D
		  .WORD  param
                  .ENDM
ANDBopQax         .MACRO param
                  .BYTE $333D
		  .WORD  param
                  .ENDM
                                    
ANDCopAax         .MACRO param
                  .BYTE $083D
		  .WORD  param
                  .ENDM                
ANDCopBax         .MACRO param          
                  .BYTE $093D
		  .WORD  param
                  .ENDM
ANDCopCax         .MACRO param
                  .BYTE $0A3D
		  .WORD  param
                  .ENDM
ANDCopDax         .MACRO param
                  .BYTE $0B3D
		  .WORD  param
                  .ENDM
ANDCopEax         .MACRO param          
                  .BYTE $183D
		  .WORD  param
                  .ENDM
ANDCopFax         .MACRO param
                  .BYTE $193D
		  .WORD  param
                  .ENDM
ANDCopGax         .MACRO param
                  .BYTE $1A3D
		  .WORD  param
                  .ENDM                  
ANDCopHax         .MACRO param          
                  .BYTE $1B3D
		  .WORD  param
                  .ENDM
ANDCopIax         .MACRO param
                  .BYTE $283D
		  .WORD  param
                  .ENDM
ANDCopJax         .MACRO param
                  .BYTE $293D
		  .WORD  param
                  .ENDM
ANDCopKax         .MACRO param          
                  .BYTE $2A3D
		  .WORD  param
                  .ENDM
ANDCopLax         .MACRO param
                  .BYTE $2B3D
		  .WORD  param
                  .ENDM
ANDCopMax         .MACRO param
                  .BYTE $383D
		  .WORD  param
                  .ENDM                  
ANDCopNax         .MACRO param          
                  .BYTE $393D
	 	  .WORD  param
                  .ENDM
ANDCopOax         .MACRO param
                  .BYTE $3A3D
		  .WORD  param
                  .ENDM
ANDCopQax         .MACRO param
                  .BYTE $3B3D
		  .WORD  param
                  .ENDM

ANDDopAax         .MACRO param
                  .BYTE $0C3D
		  .WORD  param
                  .ENDM                
ANDDopBax         .MACRO param          
                  .BYTE $0D3D
		  .WORD  param
                  .ENDM
ANDDopCax         .MACRO param
                  .BYTE $0E3D
		  .WORD  param
                  .ENDM
ANDDopDax         .MACRO param
                  .BYTE $0F3D
		  .WORD  param
                  .ENDM
ANDDopEax         .MACRO param          
                  .BYTE $1C3D
		  .WORD  param
                  .ENDM
ANDDopFax         .MACRO param
                  .BYTE $1D3D
		  .WORD  param
                  .ENDM
ANDDopGax         .MACRO param
                  .BYTE $1E3D
		  .WORD  param
                  .ENDM                  
ANDDopHax         .MACRO param          
                  .BYTE $1F3D
		  .WORD  param
                  .ENDM
ANDDopIax         .MACRO param
                  .BYTE $2C3D
		  .WORD  param
                  .ENDM
ANDDopJax         .MACRO param
                  .BYTE $2D3D
		  .WORD  param
                  .ENDM
ANDDopKax         .MACRO param          
                  .BYTE $2E3D
		  .WORD  param
                  .ENDM
ANDDopLax         .MACRO param
                  .BYTE $2F3D
		  .WORD  param
                  .ENDM
ANDDopMax         .MACRO param
                  .BYTE $3C3D
		  .WORD  param
                  .ENDM                  
ANDDopNax         .MACRO param          
                  .BYTE $3D3D
		  .WORD  param
                  .ENDM
ANDDopOax         .MACRO param
                  .BYTE $3E3D
		  .WORD  param
                  .ENDM
ANDDopQax         .MACRO param
                  .BYTE $3F3D
		  .WORD  param
                  .ENDM                  

ANDEopAax         .MACRO param
                  .BYTE $403D
		  .WORD  param
                  .ENDM                
ANDEopBax         .MACRO param          
                  .BYTE $413D
		  .WORD  param
                  .ENDM
ANDEopCax         .MACRO param
                  .BYTE $423D
		  .WORD  param
                  .ENDM
ANDEopDax         .MACRO param
                  .BYTE $433D
		  .WORD  param
                  .ENDM
ANDEopEax         .MACRO param          
                  .BYTE $503D
		  .WORD  param
                  .ENDM
ANDEopFax         .MACRO param
                  .BYTE $513D
		  .WORD  param
                  .ENDM
ANDEopGax         .MACRO param
                  .BYTE $523D
		  .WORD  param
                  .ENDM                  
ANDEopHax         .MACRO param          
                  .BYTE $533D
		  .WORD  param
                  .ENDM
ANDEopIax         .MACRO param
                  .BYTE $603D
		  .WORD  param
                  .ENDM
ANDEopJax         .MACRO param
                  .BYTE $613D
		  .WORD  param
                  .ENDM
ANDEopKax         .MACRO param          
                  .BYTE $623D
		  .WORD  param
                  .ENDM
ANDEopLax         .MACRO param
                  .BYTE $633D
		  .WORD  param
                  .ENDM
ANDEopMax         .MACRO param
                  .BYTE $703D
		  .WORD  param
                  .ENDM                  
ANDEopNax         .MACRO param          
                  .BYTE $713D
		  .WORD  param
                  .ENDM
ANDEopOax         .MACRO param
                  .BYTE $723D
		  .WORD  param
                  .ENDM
ANDEopQax         .MACRO param
                  .BYTE $733D
		  .WORD  param
                  .ENDM
                  
ANDFopAax         .MACRO param
                  .BYTE $443D
		  .WORD  param
                  .ENDM                
ANDFopBax         .MACRO param          
                  .BYTE $453D
		  .WORD  param
                  .ENDM
ANDFopCax         .MACRO param
                  .BYTE $463D
		  .WORD  param
                  .ENDM
ANDFopDax         .MACRO param
                  .BYTE $473D
		  .WORD  param
                  .ENDM
ANDFopEax         .MACRO param          
                  .BYTE $543D
		  .WORD  param
                  .ENDM
ANDFopFax         .MACRO param
                  .BYTE $553D
		  .WORD  param
                  .ENDM
ANDFopGax         .MACRO param
                  .BYTE $563D
		  .WORD  param
                  .ENDM                  
ANDFopHax         .MACRO param          
                  .BYTE $573D
		  .WORD  param
                  .ENDM
ANDFopIax         .MACRO param
                  .BYTE $643D
	 	  .WORD  param
                  .ENDM
ANDFopJax         .MACRO param
                  .BYTE $653D
		  .WORD  param
                  .ENDM
ANDFopKax         .MACRO param          
                  .BYTE $663D
		  .WORD  param
                  .ENDM
ANDFopLax         .MACRO param
                  .BYTE $673D
		  .WORD  param
                  .ENDM
ANDFopMax         .MACRO param
                  .BYTE $743D
		  .WORD  param
                  .ENDM                  
ANDFopNax         .MACRO param          
                  .BYTE $753D
		  .WORD  param
                  .ENDM
ANDFopOax         .MACRO param
                  .BYTE $763D
		  .WORD  param
                  .ENDM
ANDFopQax         .MACRO param
                  .BYTE $773D
		  .WORD  param
                  .ENDM                  
                           
ANDGopAax         .MACRO param
                  .BYTE $483D
		  .WORD  param
                  .ENDM                
ANDGopBax         .MACRO param          
                  .BYTE $493D
		  .WORD  param
                  .ENDM
ANDGopCax         .MACRO param
                  .BYTE $4A3D
		  .WORD  param
                  .ENDM
ANDGopDax         .MACRO param
                  .BYTE $4B3D
		  .WORD  param
                  .ENDM
ANDGopEax         .MACRO param          
                  .BYTE $583D
		  .WORD  param
                  .ENDM
ANDGopFax         .MACRO param
                  .BYTE $593D
		  .WORD  param
                  .ENDM
ANDGopGax         .MACRO param
                  .BYTE $5A3D
		  .WORD  param
                  .ENDM                  
ANDGopHax         .MACRO param          
                  .BYTE $5B3D
		  .WORD  param
                  .ENDM
ANDGopIax         .MACRO param
                  .BYTE $683D
		  .WORD  param
                  .ENDM
ANDGopJax         .MACRO param
                  .BYTE $693D
		  .WORD  param
                  .ENDM
ANDGopKax         .MACRO param          
                  .BYTE $6A3D
		  .WORD  param
                  .ENDM
ANDGopLax         .MACRO param
                  .BYTE $6B3D
		  .WORD  param
                  .ENDM
ANDGopMax         .MACRO param
                  .BYTE $783D
		  .WORD  param
                  .ENDM                  
ANDGopNax         .MACRO param          
                  .BYTE $793D
		  .WORD  param
                  .ENDM
ANDGopOax         .MACRO param
                  .BYTE $7A3D
		  .WORD  param
                  .ENDM
ANDGopQax         .MACRO param
                  .BYTE $7B3D
		  .WORD  param
                  .ENDM
                  
ANDHopAax         .MACRO param
                  .BYTE $4C3D
		  .WORD  param
                  .ENDM                
ANDHopBax         .MACRO param          
                  .BYTE $4D3D
		  .WORD  param
                  .ENDM
ANDHopCax         .MACRO param
                  .BYTE $4E3D
		  .WORD  param
                  .ENDM
ANDHopDax         .MACRO param
                  .BYTE $4F3D
		  .WORD  param
                  .ENDM
ANDHopEax         .MACRO param          
                  .BYTE $5C3D
		  .WORD  param
                  .ENDM
ANDHopFax         .MACRO param
                  .BYTE $5D3D
		  .WORD  param
                  .ENDM
ANDHopGax         .MACRO param
                  .BYTE $5E3D
		  .WORD  param
                  .ENDM                  
ANDHopHax         .MACRO param          
                  .BYTE $5F3D
		  .WORD  param
                  .ENDM
ANDHopIax         .MACRO param
                  .BYTE $6C3D
		  .WORD  param
                  .ENDM
ANDHopJax         .MACRO param
                  .BYTE $6D3D
		  .WORD  param
                  .ENDM
ANDHopKax         .MACRO param          
                  .BYTE $6E3D
		  .WORD  param
                  .ENDM
ANDHopLax         .MACRO param
                  .BYTE $6F3D
		  .WORD  param
                  .ENDM
ANDHopMax         .MACRO param
                  .BYTE $7C3D
		  .WORD  param
                  .ENDM                  
ANDHopNax         .MACRO param          
                  .BYTE $7D3D
		  .WORD  param
                  .ENDM
ANDHopOax         .MACRO param
                  .BYTE $7E3D
		  .WORD  param
                  .ENDM
ANDHopQax         .MACRO param
                  .BYTE $7F3D
		  .WORD  param
                  .ENDM
                  
ANDIopAax         .MACRO param
                  .BYTE $803D
		  .WORD  param
                  .ENDM                
ANDIopBax         .MACRO param          
                  .BYTE $813D
		  .WORD  param
                  .ENDM
ANDIopCax         .MACRO param
                  .BYTE $823D
		  .WORD  param
                  .ENDM
ANDIopDax         .MACRO param
                  .BYTE $833D
		  .WORD  param
                  .ENDM
ANDIopEax         .MACRO param          
                  .BYTE $903D
		  .WORD  param
                  .ENDM
ANDIopFax         .MACRO param
                  .BYTE $913D
		  .WORD  param
                  .ENDM
ANDIopGax         .MACRO param
                  .BYTE $923D
		  .WORD  param
                  .ENDM                  
ANDIopHax         .MACRO param          
                  .BYTE $933D
		  .WORD  param
                  .ENDM
ANDIopIax         .MACRO param
                  .BYTE $A03D
		  .WORD  param
                  .ENDM
ANDIopJax         .MACRO param
                  .BYTE $A13D
		  .WORD  param
                  .ENDM
ANDIopKax         .MACRO param          
                  .BYTE $A23D
		  .WORD  param
                  .ENDM
ANDIopLax         .MACRO param
                  .BYTE $A33D
		  .WORD  param
                  .ENDM
ANDIopMax         .MACRO param
                  .BYTE $B03D
		  .WORD  param
                  .ENDM                  
ANDIopNax         .MACRO param          
                  .BYTE $B13D
		  .WORD  param
                  .ENDM
ANDIopOax         .MACRO param
                  .BYTE $B23D
		  .WORD  param
                  .ENDM
ANDIopQax         .MACRO param
                  .BYTE $B33D
		  .WORD  param
                  .ENDM
                  
ANDJopAax         .MACRO param
                  .BYTE $843D
		  .WORD  param
                  .ENDM                
ANDJopBax         .MACRO param          
                  .BYTE $853D
		  .WORD  param
                  .ENDM
ANDJopCax         .MACRO param
                  .BYTE $863D
		  .WORD  param
                  .ENDM
ANDJopDax         .MACRO param
                  .BYTE $873D
		  .WORD  param
                  .ENDM
ANDJopEax         .MACRO param          
                  .BYTE $943D
		  .WORD  param
                  .ENDM
ANDJopFax         .MACRO param
                  .BYTE $953D
		  .WORD  param
                  .ENDM
ANDJopGax         .MACRO param
                  .BYTE $963D
		  .WORD  param
                  .ENDM                  
ANDJopHax         .MACRO param          
                  .BYTE $973D
		  .WORD  param
                  .ENDM
ANDJopIax         .MACRO param
                  .BYTE $A43D
		  .WORD  param
                  .ENDM
ANDJopJax         .MACRO param
                  .BYTE $A53D
		  .WORD  param
                  .ENDM
ANDJopKax         .MACRO param          
                  .BYTE $A63D
 		  .WORD  param
                  .ENDM
ANDJopLax         .MACRO param
                  .BYTE $A73D
		  .WORD  param
                  .ENDM
ANDJopMax         .MACRO param
                  .BYTE $B43D
		  .WORD  param
                  .ENDM                  
ANDJopNax         .MACRO param          
                  .BYTE $B53D
		  .WORD  param
                  .ENDM
ANDJopOax         .MACRO param
                  .BYTE $B63D
		  .WORD  param
                  .ENDM
ANDJopQax         .MACRO param
                  .BYTE $B73D
		  .WORD  param
                  .ENDM
                  
ANDKopAax         .MACRO param
                  .BYTE $883D
		  .WORD  param
                  .ENDM                
ANDKopBax         .MACRO param          
                  .BYTE $893D
		  .WORD  param
                  .ENDM
ANDKopCax         .MACRO param
                  .BYTE $8A3D
		  .WORD  param
                  .ENDM
ANDKopDax         .MACRO param
                  .BYTE $8B3D
		  .WORD  param
                  .ENDM
ANDKopEax         .MACRO param          
                  .BYTE $983D
		  .WORD  param
                  .ENDM
ANDKopFax         .MACRO param
                  .BYTE $993D
		  .WORD  param
                  .ENDM
ANDKopGax         .MACRO param
                  .BYTE $9A3D
		  .WORD  param
                  .ENDM                  
ANDKopHax         .MACRO param          
                  .BYTE $9B3D
		  .WORD  param
                  .ENDM
ANDKopIax         .MACRO param
                  .BYTE $A83D
		  .WORD  param
                  .ENDM
ANDKopJax         .MACRO param
                  .BYTE $A93D
		  .WORD  param
                  .ENDM
ANDKopKax         .MACRO param          
                  .BYTE $AA3D
		  .WORD  param
                  .ENDM
ANDKopLax         .MACRO param
                  .BYTE $AB3D
		  .WORD  param
                  .ENDM
ANDKopMax         .MACRO param
                  .BYTE $B83D
		  .WORD  param
                  .ENDM                  
ANDKopNax         .MACRO param          
                  .BYTE $B93D
		  .WORD  param
                  .ENDM
ANDKopOax         .MACRO param
                  .BYTE $BA3D
		  .WORD  param
                  .ENDM
ANDKopQax         .MACRO param
                  .BYTE $BB3D
		  .WORD  param
                  .ENDM
                  
ANDLopAax         .MACRO param
                  .BYTE $8C3D
		  .WORD  param
                  .ENDM                
ANDLopBax         .MACRO param          
                  .BYTE $8D3D
		  .WORD  param
                  .ENDM
ANDLopCax         .MACRO param
                  .BYTE $8E3D
		  .WORD  param
                  .ENDM
ANDLopDax         .MACRO param
                  .BYTE $8F3D
		  .WORD  param
                  .ENDM
ANDLopEax         .MACRO param          
                  .BYTE $9C3D
		  .WORD  param
                  .ENDM
ANDLopFax         .MACRO param
                  .BYTE $9D3D
		  .WORD  param
                  .ENDM
ANDLopGax         .MACRO param
                  .BYTE $9E3D
		  .WORD  param
                  .ENDM                  
ANDLopHax         .MACRO param          
                  .BYTE $9F3D
		  .WORD  param
                  .ENDM
ANDLopIax         .MACRO param
                  .BYTE $AC3D
		  .WORD  param
                  .ENDM
ANDLopJax         .MACRO param
                  .BYTE $AD3D
		  .WORD  param
                  .ENDM
ANDLopKax         .MACRO param          
                  .BYTE $AE3D
		  .WORD  param
                  .ENDM
ANDLopLax         .MACRO param
                  .BYTE $AF3D
		  .WORD  param
                  .ENDM
ANDLopMax         .MACRO param
                  .BYTE $BC3D
		  .WORD  param
                  .ENDM                  
ANDLopNax         .MACRO param          
                  .BYTE $BD3D
		  .WORD  param
                  .ENDM
ANDLopOax         .MACRO param
                  .BYTE $BE3D
		  .WORD  param
                  .ENDM
ANDLopQax         .MACRO param
                  .BYTE $BF3D
		  .WORD  param
                  .ENDM
                  
ANDMopAax         .MACRO param
                  .BYTE $C03D
		  .WORD  param
                  .ENDM                
ANDMopBax         .MACRO param          
                  .BYTE $C13D
		  .WORD  param
                  .ENDM
ANDMopCax         .MACRO param
                  .BYTE $C23D
		  .WORD  param
                  .ENDM
ANDMopDax         .MACRO param
                  .BYTE $C33D
		  .WORD  param
                  .ENDM
ANDMopEax         .MACRO param          
                  .BYTE $D03D
		  .WORD  param
                  .ENDM
ANDMopFax         .MACRO param
                  .BYTE $D13D
		  .WORD  param
                  .ENDM
ANDMopGax         .MACRO param
                  .BYTE $D23D
		  .WORD  param
                  .ENDM                  
ANDMopHax         .MACRO param          
                  .BYTE $D33D
		  .WORD  param
                  .ENDM
ANDMopIax         .MACRO param
                  .BYTE $E03D
		  .WORD  param
                  .ENDM
ANDMopJax         .MACRO param
                  .BYTE $E13D
		  .WORD  param
                  .ENDM
ANDMopKax         .MACRO param          
                  .BYTE $E23D
		  .WORD  param
                  .ENDM
ANDMopLax         .MACRO param
                  .BYTE $E33D
		  .WORD  param
                  .ENDM
ANDMopMax         .MACRO param
                  .BYTE $F03D
		  .WORD  param
                  .ENDM                  
ANDMopNax         .MACRO param          
                  .BYTE $F13D
		  .WORD  param
                  .ENDM
ANDMopOax         .MACRO param
                  .BYTE $F23D
		  .WORD  param
                  .ENDM
ANDMopQax         .MACRO param
                  .BYTE $F33D
		  .WORD  param
                  .ENDM
                  
ANDNopAax         .MACRO param
                  .BYTE $C43D
		  .WORD  param
                  .ENDM                
ANDNopBax         .MACRO param          
                  .BYTE $C53D
		  .WORD  param
                  .ENDM
ANDNopCax         .MACRO param
                  .BYTE $C63D
		  .WORD  param
                  .ENDM
ANDNopDax         .MACRO param
                  .BYTE $C73D
		  .WORD  param
                  .ENDM
ANDNopEax         .MACRO param          
                  .BYTE $D43D
		  .WORD  param
                  .ENDM
ANDNopFax         .MACRO param
                  .BYTE $D53D
		  .WORD  param
                  .ENDM
ANDNopGax         .MACRO param
                  .BYTE $D63D
		  .WORD  param
                  .ENDM                  
ANDNopHax         .MACRO param          
                  .BYTE $D73D
		  .WORD  param
                  .ENDM
ANDNopIax         .MACRO param
                  .BYTE $E43D
		  .WORD  param
                  .ENDM
ANDNopJax         .MACRO param
                  .BYTE $E53D
		  .WORD  param
                  .ENDM
ANDNopKax         .MACRO param          
                  .BYTE $E63D
		  .WORD  param
                  .ENDM
ANDNopLax         .MACRO param
                  .BYTE $E73D
		  .WORD  param
                  .ENDM
ANDNopMax         .MACRO param
                  .BYTE $F43D
		  .WORD  param
                  .ENDM                  
ANDNopNax         .MACRO param          
                  .BYTE $F53D
		  .WORD  param
                  .ENDM
ANDNopOax         .MACRO param
                  .BYTE $F63D
		  .WORD  param
                  .ENDM
ANDNopQax         .MACRO param
                  .BYTE $F73D
		  .WORD  param
                  .ENDM
            
ANDOopAax         .MACRO param
                  .BYTE $C83D
		  .WORD  param
                  .ENDM                
ANDOopBax         .MACRO param          
                  .BYTE $C93D
		  .WORD  param
                  .ENDM
ANDOopCax         .MACRO param
                  .BYTE $CA3D
		  .WORD  param
                  .ENDM
ANDOopDax         .MACRO param
                  .BYTE $CB3D
		  .WORD  param
                  .ENDM
ANDOopEax         .MACRO param          
                  .BYTE $D83D
		  .WORD  param
                  .ENDM
ANDOopFax         .MACRO param
                  .BYTE $D93D
		  .WORD  param
                  .ENDM
ANDOopGax         .MACRO param
                  .BYTE $DA3D
		  .WORD  param
                  .ENDM                  
ANDOopHax         .MACRO param          
                  .BYTE $DB3D
		  .WORD  param
                  .ENDM
ANDOopIax         .MACRO param
                  .BYTE $E83D
		  .WORD  param
                  .ENDM
ANDOopJax         .MACRO param
                  .BYTE $E93D
		  .WORD  param
                  .ENDM
ANDOopKax         .MACRO param          
                  .BYTE $EA3D
		  .WORD  param
                  .ENDM
ANDOopLax         .MACRO param
                  .BYTE $EB3D
		  .WORD  param
                  .ENDM
ANDOopMax         .MACRO param
                  .BYTE $F83D
		  .WORD  param
                  .ENDM                  
ANDOopNax         .MACRO param          
                  .BYTE $F93D
		  .WORD  param
                  .ENDM
ANDOopOax         .MACRO param
                  .BYTE $FA3D
		  .WORD  param
                  .ENDM
ANDOopQax         .MACRO param
                  .BYTE $FB3D
		  .WORD  param
                  .ENDM
                  
ANDQopAax         .MACRO param
                  .BYTE $CC3D
		  .WORD  param
                  .ENDM                
ANDQopBax         .MACRO param          
                  .BYTE $CD3D
		  .WORD  param
                  .ENDM
ANDQopCax         .MACRO param
                  .BYTE $CE3D
		  .WORD  param
                  .ENDM
ANDQopDax         .MACRO param
                  .BYTE $CF3D
		  .WORD  param
                  .ENDM
ANDQopEax         .MACRO param          
                  .BYTE $DC3D
		  .WORD  param
                  .ENDM
ANDQopFax         .MACRO param
                  .BYTE $DD3D
		  .WORD  param
                  .ENDM
ANDQopGax         .MACRO param
                  .BYTE $DE3D
		  .WORD  param
                  .ENDM                  
ANDQopHax         .MACRO param          
                  .BYTE $DF3D
		  .WORD  param
                  .ENDM
ANDQopIax         .MACRO param
                  .BYTE $EC3D
		  .WORD  param
                  .ENDM
ANDQopJax         .MACRO param
                  .BYTE $ED3D
		  .WORD  param
                  .ENDM
ANDQopKax         .MACRO param          
                  .BYTE $EE3D
		  .WORD  param
                  .ENDM
ANDQopLax         .MACRO param
                  .BYTE $EF3D
		  .WORD  param
                  .ENDM
ANDQopMax         .MACRO param
                  .BYTE $FC3D
		  .WORD  param
                  .ENDM                  
ANDQopNax         .MACRO param          
                  .BYTE $FD3D
		  .WORD  param
                  .ENDM
ANDQopOax         .MACRO param
                  .BYTE $FE3D
		  .WORD  param
                  .ENDM
ANDQopQax         .MACRO param
                  .BYTE $FF3D
		  .WORD  param
                  .ENDM

;EOR $xxxxxxxx,x        $005D
EORAopBax         .MACRO param          
                  .BYTE $015D
		  .WORD  param
                  .ENDM
EORAopCax         .MACRO param
                  .BYTE $025D
		  .WORD  param
                  .ENDM
EORAopDax         .MACRO param
                  .BYTE $035D
		  .WORD  param
                  .ENDM
EORAopEax         .MACRO param          
                  .BYTE $105D
		  .WORD  param
                  .ENDM
EORAopFax         .MACRO param
                  .BYTE $115D
		  .WORD  param
                  .ENDM
EORAopGax         .MACRO param
                  .BYTE $125D
		  .WORD  param
                  .ENDM                  
EORAopHax         .MACRO param          
                  .BYTE $135D
		  .WORD  param
                  .ENDM
EORAopIax         .MACRO param
                  .BYTE $205D
		  .WORD  param
                  .ENDM
EORAopJax         .MACRO param
                  .BYTE $215D
		  .WORD  param
                  .ENDM
EORAopKax         .MACRO param          
                  .BYTE $225D
		  .WORD  param
                  .ENDM
EORAopLax         .MACRO param
                  .BYTE $235D
		  .WORD  param
                  .ENDM
EORAopMax         .MACRO param
                  .BYTE $305D
		  .WORD  param
                  .ENDM                  
EORAopNax         .MACRO param          
                  .BYTE $315D
		  .WORD  param
                  .ENDM
EORAopOax         .MACRO param
                  .BYTE $325D
		  .WORD  param
                  .ENDM
EORAopQax         .MACRO param
                  .BYTE $335D
		  .WORD  param
                  .ENDM
                                    
EORBopAax         .MACRO param
                  .BYTE $045D
		  .WORD  param
                  .ENDM                
EORBopBax         .MACRO param          
                  .BYTE $055D
		  .WORD  param
                  .ENDM
EORBopCax         .MACRO param
                  .BYTE $065D
		  .WORD  param
                  .ENDM
EORBopDax         .MACRO param
                  .BYTE $075D
		  .WORD  param
                  .ENDM
EORBopEax         .MACRO param          
                  .BYTE $145D
		  .WORD  param
                  .ENDM
EORBopFax         .MACRO param
                  .BYTE $155D
		  .WORD  param
                  .ENDM
EORBopGax         .MACRO param
                  .BYTE $165D
		  .WORD  param
                  .ENDM                  
EORBopHax         .MACRO param          
                  .BYTE $175D
		  .WORD  param
                  .ENDM
EORBopIax         .MACRO param
                  .BYTE $245D
		  .WORD  param
                  .ENDM
EORBopJax         .MACRO param
                  .BYTE $255D
		  .WORD  param
                  .ENDM
EORBopKax         .MACRO param          
                  .BYTE $265D
		  .WORD  param
                  .ENDM
EORBopLax         .MACRO param
                  .BYTE $275D
		  .WORD  param
                  .ENDM
EORBopMax         .MACRO param
                  .BYTE $305D
		  .WORD  param
                  .ENDM                  
EORBopNax         .MACRO param          
                  .BYTE $315D
		  .WORD  param
                  .ENDM
EORBopOax         .MACRO param
                  .BYTE $325D
		  .WORD  param
                  .ENDM
EORBopQax         .MACRO param
                  .BYTE $335D
		  .WORD  param
                  .ENDM
                                    
EORCopAax         .MACRO param
                  .BYTE $085D
		  .WORD  param
                  .ENDM                
EORCopBax         .MACRO param          
                  .BYTE $095D
		  .WORD  param
                  .ENDM
EORCopCax         .MACRO param
                  .BYTE $0A5D
		  .WORD  param
                  .ENDM
EORCopDax         .MACRO param
                  .BYTE $0B5D
		  .WORD  param
                  .ENDM
EORCopEax         .MACRO param          
                  .BYTE $185D
		  .WORD  param
                  .ENDM
EORCopFax         .MACRO param
                  .BYTE $195D
		  .WORD  param
                  .ENDM
EORCopGax         .MACRO param
                  .BYTE $1A5D
		  .WORD  param
                  .ENDM                  
EORCopHax         .MACRO param          
                  .BYTE $1B5D
		  .WORD  param
                  .ENDM
EORCopIax         .MACRO param
                  .BYTE $285D
		  .WORD  param
                  .ENDM
EORCopJax         .MACRO param
                  .BYTE $295D
		  .WORD  param
                  .ENDM
EORCopKax         .MACRO param          
                  .BYTE $2A5D
		  .WORD  param
                  .ENDM
EORCopLax         .MACRO param
                  .BYTE $2B5D
		  .WORD  param
                  .ENDM
EORCopMax         .MACRO param
                  .BYTE $385D
		  .WORD  param
                  .ENDM                  
EORCopNax         .MACRO param          
                  .BYTE $395D
	 	  .WORD  param
                  .ENDM
EORCopOax         .MACRO param
                  .BYTE $3A5D
		  .WORD  param
                  .ENDM
EORCopQax         .MACRO param
                  .BYTE $3B5D
		  .WORD  param
                  .ENDM

EORDopAax         .MACRO param
                  .BYTE $0C5D
		  .WORD  param
                  .ENDM                
EORDopBax         .MACRO param          
                  .BYTE $0D5D
		  .WORD  param
                  .ENDM
EORDopCax         .MACRO param
                  .BYTE $0E5D
		  .WORD  param
                  .ENDM
EORDopDax         .MACRO param
                  .BYTE $0F5D
		  .WORD  param
                  .ENDM
EORDopEax         .MACRO param          
                  .BYTE $1C5D
		  .WORD  param
                  .ENDM
EORDopFax         .MACRO param
                  .BYTE $1D5D
		  .WORD  param
                  .ENDM
EORDopGax         .MACRO param
                  .BYTE $1E5D
		  .WORD  param
                  .ENDM                  
EORDopHax         .MACRO param          
                  .BYTE $1F5D
		  .WORD  param
                  .ENDM
EORDopIax         .MACRO param
                  .BYTE $2C5D
		  .WORD  param
                  .ENDM
EORDopJax         .MACRO param
                  .BYTE $2D5D
		  .WORD  param
                  .ENDM
EORDopKax         .MACRO param          
                  .BYTE $2E5D
		  .WORD  param
                  .ENDM
EORDopLax         .MACRO param
                  .BYTE $2F5D
		  .WORD  param
                  .ENDM
EORDopMax         .MACRO param
                  .BYTE $3C5D
		  .WORD  param
                  .ENDM                  
EORDopNax         .MACRO param          
                  .BYTE $3D5D
		  .WORD  param
                  .ENDM
EORDopOax         .MACRO param
                  .BYTE $3E5D
		  .WORD  param
                  .ENDM
EORDopQax         .MACRO param
                  .BYTE $3F5D
		  .WORD  param
                  .ENDM                  

EOREopAax         .MACRO param
                  .BYTE $405D
		  .WORD  param
                  .ENDM                
EOREopBax         .MACRO param          
                  .BYTE $415D
		  .WORD  param
                  .ENDM
EOREopCax         .MACRO param
                  .BYTE $425D
		  .WORD  param
                  .ENDM
EOREopDax         .MACRO param
                  .BYTE $435D
		  .WORD  param
                  .ENDM
EOREopEax         .MACRO param          
                  .BYTE $505D
		  .WORD  param
                  .ENDM
EOREopFax         .MACRO param
                  .BYTE $515D
		  .WORD  param
                  .ENDM
EOREopGax         .MACRO param
                  .BYTE $525D
		  .WORD  param
                  .ENDM                  
EOREopHax         .MACRO param          
                  .BYTE $535D
		  .WORD  param
                  .ENDM
EOREopIax         .MACRO param
                  .BYTE $605D
		  .WORD  param
                  .ENDM
EOREopJax         .MACRO param
                  .BYTE $615D
		  .WORD  param
                  .ENDM
EOREopKax         .MACRO param          
                  .BYTE $625D
		  .WORD  param
                  .ENDM
EOREopLax         .MACRO param
                  .BYTE $635D
		  .WORD  param
                  .ENDM
EOREopMax         .MACRO param
                  .BYTE $705D
		  .WORD  param
                  .ENDM                  
EOREopNax         .MACRO param          
                  .BYTE $715D
		  .WORD  param
                  .ENDM
EOREopOax         .MACRO param
                  .BYTE $725D
		  .WORD  param
                  .ENDM
EOREopQax         .MACRO param
                  .BYTE $735D
		  .WORD  param
                  .ENDM
                  
EORFopAax         .MACRO param
                  .BYTE $445D
		  .WORD  param
                  .ENDM                
EORFopBax         .MACRO param          
                  .BYTE $455D
		  .WORD  param
                  .ENDM
EORFopCax         .MACRO param
                  .BYTE $465D
		  .WORD  param
                  .ENDM
EORFopDax         .MACRO param
                  .BYTE $475D
		  .WORD  param
                  .ENDM
EORFopEax         .MACRO param          
                  .BYTE $545D
		  .WORD  param
                  .ENDM
EORFopFax         .MACRO param
                  .BYTE $555D
		  .WORD  param
                  .ENDM
EORFopGax         .MACRO param
                  .BYTE $565D
		  .WORD  param
                  .ENDM                  
EORFopHax         .MACRO param          
                  .BYTE $575D
		  .WORD  param
                  .ENDM
EORFopIax         .MACRO param
                  .BYTE $645D
	 	  .WORD  param
                  .ENDM
EORFopJax         .MACRO param
                  .BYTE $655D
		  .WORD  param
                  .ENDM
EORFopKax         .MACRO param          
                  .BYTE $665D
		  .WORD  param
                  .ENDM
EORFopLax         .MACRO param
                  .BYTE $675D
		  .WORD  param
                  .ENDM
EORFopMax         .MACRO param
                  .BYTE $745D
		  .WORD  param
                  .ENDM                  
EORFopNax         .MACRO param          
                  .BYTE $755D
		  .WORD  param
                  .ENDM
EORFopOax         .MACRO param
                  .BYTE $765D
		  .WORD  param
                  .ENDM
EORFopQax         .MACRO param
                  .BYTE $775D
		  .WORD  param
                  .ENDM                  
                           
EORGopAax         .MACRO param
                  .BYTE $485D
		  .WORD  param
                  .ENDM                
EORGopBax         .MACRO param          
                  .BYTE $495D
		  .WORD  param
                  .ENDM
EORGopCax         .MACRO param
                  .BYTE $4A5D
		  .WORD  param
                  .ENDM
EORGopDax         .MACRO param
                  .BYTE $4B5D
		  .WORD  param
                  .ENDM
EORGopEax         .MACRO param          
                  .BYTE $585D
		  .WORD  param
                  .ENDM
EORGopFax         .MACRO param
                  .BYTE $595D
		  .WORD  param
                  .ENDM
EORGopGax         .MACRO param
                  .BYTE $5A5D
		  .WORD  param
                  .ENDM                  
EORGopHax         .MACRO param          
                  .BYTE $5B5D
		  .WORD  param
                  .ENDM
EORGopIax         .MACRO param
                  .BYTE $685D
		  .WORD  param
                  .ENDM
EORGopJax         .MACRO param
                  .BYTE $695D
		  .WORD  param
                  .ENDM
EORGopKax         .MACRO param          
                  .BYTE $6A5D
		  .WORD  param
                  .ENDM
EORGopLax         .MACRO param
                  .BYTE $6B5D
		  .WORD  param
                  .ENDM
EORGopMax         .MACRO param
                  .BYTE $785D
		  .WORD  param
                  .ENDM                  
EORGopNax         .MACRO param          
                  .BYTE $795D
		  .WORD  param
                  .ENDM
EORGopOax         .MACRO param
                  .BYTE $7A5D
		  .WORD  param
                  .ENDM
EORGopQax         .MACRO param
                  .BYTE $7B5D
		  .WORD  param
                  .ENDM
                  
EORHopAax         .MACRO param
                  .BYTE $4C5D
		  .WORD  param
                  .ENDM                
EORHopBax         .MACRO param          
                  .BYTE $4D5D
		  .WORD  param
                  .ENDM
EORHopCax         .MACRO param
                  .BYTE $4E5D
		  .WORD  param
                  .ENDM
EORHopDax         .MACRO param
                  .BYTE $4F5D
		  .WORD  param
                  .ENDM
EORHopEax         .MACRO param          
                  .BYTE $5C5D
		  .WORD  param
                  .ENDM
EORHopFax         .MACRO param
                  .BYTE $5D5D
		  .WORD  param
                  .ENDM
EORHopGax         .MACRO param
                  .BYTE $5E5D
		  .WORD  param
                  .ENDM                  
EORHopHax         .MACRO param          
                  .BYTE $5F5D
		  .WORD  param
                  .ENDM
EORHopIax         .MACRO param
                  .BYTE $6C5D
		  .WORD  param
                  .ENDM
EORHopJax         .MACRO param
                  .BYTE $6D5D
		  .WORD  param
                  .ENDM
EORHopKax         .MACRO param          
                  .BYTE $6E5D
		  .WORD  param
                  .ENDM
EORHopLax         .MACRO param
                  .BYTE $6F5D
		  .WORD  param
                  .ENDM
EORHopMax         .MACRO param
                  .BYTE $7C5D
		  .WORD  param
                  .ENDM                  
EORHopNax         .MACRO param          
                  .BYTE $7D5D
		  .WORD  param
                  .ENDM
EORHopOax         .MACRO param
                  .BYTE $7E5D
		  .WORD  param
                  .ENDM
EORHopQax         .MACRO param
                  .BYTE $7F5D
		  .WORD  param
                  .ENDM
                  
EORIopAax         .MACRO param
                  .BYTE $805D
		  .WORD  param
                  .ENDM                
EORIopBax         .MACRO param          
                  .BYTE $815D
		  .WORD  param
                  .ENDM
EORIopCax         .MACRO param
                  .BYTE $825D
		  .WORD  param
                  .ENDM
EORIopDax         .MACRO param
                  .BYTE $835D
		  .WORD  param
                  .ENDM
EORIopEax         .MACRO param          
                  .BYTE $905D
		  .WORD  param
                  .ENDM
EORIopFax         .MACRO param
                  .BYTE $915D
		  .WORD  param
                  .ENDM
EORIopGax         .MACRO param
                  .BYTE $925D
		  .WORD  param
                  .ENDM                  
EORIopHax         .MACRO param          
                  .BYTE $935D
		  .WORD  param
                  .ENDM
EORIopIax         .MACRO param
                  .BYTE $A05D
		  .WORD  param
                  .ENDM
EORIopJax         .MACRO param
                  .BYTE $A15D
		  .WORD  param
                  .ENDM
EORIopKax         .MACRO param          
                  .BYTE $A25D
		  .WORD  param
                  .ENDM
EORIopLax         .MACRO param
                  .BYTE $A35D
		  .WORD  param
                  .ENDM
EORIopMax         .MACRO param
                  .BYTE $B05D
		  .WORD  param
                  .ENDM                  
EORIopNax         .MACRO param          
                  .BYTE $B15D
		  .WORD  param
                  .ENDM
EORIopOax         .MACRO param
                  .BYTE $B25D
		  .WORD  param
                  .ENDM
EORIopQax         .MACRO param
                  .BYTE $B35D
		  .WORD  param
                  .ENDM
                  
EORJopAax         .MACRO param
                  .BYTE $845D
		  .WORD  param
                  .ENDM                
EORJopBax         .MACRO param          
                  .BYTE $855D
		  .WORD  param
                  .ENDM
EORJopCax         .MACRO param
                  .BYTE $865D
		  .WORD  param
                  .ENDM
EORJopDax         .MACRO param
                  .BYTE $875D
		  .WORD  param
                  .ENDM
EORJopEax         .MACRO param          
                  .BYTE $945D
		  .WORD  param
                  .ENDM
EORJopFax         .MACRO param
                  .BYTE $955D
		  .WORD  param
                  .ENDM
EORJopGax         .MACRO param
                  .BYTE $965D
		  .WORD  param
                  .ENDM                  
EORJopHax         .MACRO param          
                  .BYTE $975D
		  .WORD  param
                  .ENDM
EORJopIax         .MACRO param
                  .BYTE $A45D
		  .WORD  param
                  .ENDM
EORJopJax         .MACRO param
                  .BYTE $A55D
		  .WORD  param
                  .ENDM
EORJopKax         .MACRO param          
                  .BYTE $A65D
 		  .WORD  param
                  .ENDM
EORJopLax         .MACRO param
                  .BYTE $A75D
		  .WORD  param
                  .ENDM
EORJopMax         .MACRO param
                  .BYTE $B45D
		  .WORD  param
                  .ENDM                  
EORJopNax         .MACRO param          
                  .BYTE $B55D
		  .WORD  param
                  .ENDM
EORJopOax         .MACRO param
                  .BYTE $B65D
		  .WORD  param
                  .ENDM
EORJopQax         .MACRO param
                  .BYTE $B75D
		  .WORD  param
                  .ENDM
                  
EORKopAax         .MACRO param
                  .BYTE $885D
		  .WORD  param
                  .ENDM                
EORKopBax         .MACRO param          
                  .BYTE $895D
		  .WORD  param
                  .ENDM
EORKopCax         .MACRO param
                  .BYTE $8A5D
		  .WORD  param
                  .ENDM
EORKopDax         .MACRO param
                  .BYTE $8B5D
		  .WORD  param
                  .ENDM
EORKopEax         .MACRO param          
                  .BYTE $985D
		  .WORD  param
                  .ENDM
EORKopFax         .MACRO param
                  .BYTE $995D
		  .WORD  param
                  .ENDM
EORKopGax         .MACRO param
                  .BYTE $9A5D
		  .WORD  param
                  .ENDM                  
EORKopHax         .MACRO param          
                  .BYTE $9B5D
		  .WORD  param
                  .ENDM
EORKopIax         .MACRO param
                  .BYTE $A85D
		  .WORD  param
                  .ENDM
EORKopJax         .MACRO param
                  .BYTE $A95D
		  .WORD  param
                  .ENDM
EORKopKax         .MACRO param          
                  .BYTE $AA5D
		  .WORD  param
                  .ENDM
EORKopLax         .MACRO param
                  .BYTE $AB5D
		  .WORD  param
                  .ENDM
EORKopMax         .MACRO param
                  .BYTE $B85D
		  .WORD  param
                  .ENDM                  
EORKopNax         .MACRO param          
                  .BYTE $B95D
		  .WORD  param
                  .ENDM
EORKopOax         .MACRO param
                  .BYTE $BA5D
		  .WORD  param
                  .ENDM
EORKopQax         .MACRO param
                  .BYTE $BB5D
		  .WORD  param
                  .ENDM
                  
EORLopAax         .MACRO param
                  .BYTE $8C5D
		  .WORD  param
                  .ENDM                
EORLopBax         .MACRO param          
                  .BYTE $8D5D
		  .WORD  param
                  .ENDM
EORLopCax         .MACRO param
                  .BYTE $8E5D
		  .WORD  param
                  .ENDM
EORLopDax         .MACRO param
                  .BYTE $8F5D
		  .WORD  param
                  .ENDM
EORLopEax         .MACRO param          
                  .BYTE $9C5D
		  .WORD  param
                  .ENDM
EORLopFax         .MACRO param
                  .BYTE $9D5D
		  .WORD  param
                  .ENDM
EORLopGax         .MACRO param
                  .BYTE $9E5D
		  .WORD  param
                  .ENDM                  
EORLopHax         .MACRO param          
                  .BYTE $9F5D
		  .WORD  param
                  .ENDM
EORLopIax         .MACRO param
                  .BYTE $AC5D
		  .WORD  param
                  .ENDM
EORLopJax         .MACRO param
                  .BYTE $AD5D
		  .WORD  param
                  .ENDM
EORLopKax         .MACRO param          
                  .BYTE $AE5D
		  .WORD  param
                  .ENDM
EORLopLax         .MACRO param
                  .BYTE $AF5D
		  .WORD  param
                  .ENDM
EORLopMax         .MACRO param
                  .BYTE $BC5D
		  .WORD  param
                  .ENDM                  
EORLopNax         .MACRO param          
                  .BYTE $BD5D
		  .WORD  param
                  .ENDM
EORLopOax         .MACRO param
                  .BYTE $BE5D
		  .WORD  param
                  .ENDM
EORLopQax         .MACRO param
                  .BYTE $BF5D
		  .WORD  param
                  .ENDM
                  
EORMopAax         .MACRO param
                  .BYTE $C05D
		  .WORD  param
                  .ENDM                
EORMopBax         .MACRO param          
                  .BYTE $C15D
		  .WORD  param
                  .ENDM
EORMopCax         .MACRO param
                  .BYTE $C25D
		  .WORD  param
                  .ENDM
EORMopDax         .MACRO param
                  .BYTE $C35D
		  .WORD  param
                  .ENDM
EORMopEax         .MACRO param          
                  .BYTE $D05D
		  .WORD  param
                  .ENDM
EORMopFax         .MACRO param
                  .BYTE $D15D
		  .WORD  param
                  .ENDM
EORMopGax         .MACRO param
                  .BYTE $D25D
		  .WORD  param
                  .ENDM                  
EORMopHax         .MACRO param          
                  .BYTE $D35D
		  .WORD  param
                  .ENDM
EORMopIax         .MACRO param
                  .BYTE $E05D
		  .WORD  param
                  .ENDM
EORMopJax         .MACRO param
                  .BYTE $E15D
		  .WORD  param
                  .ENDM
EORMopKax         .MACRO param          
                  .BYTE $E25D
		  .WORD  param
                  .ENDM
EORMopLax         .MACRO param
                  .BYTE $E35D
		  .WORD  param
                  .ENDM
EORMopMax         .MACRO param
                  .BYTE $F05D
		  .WORD  param
                  .ENDM                  
EORMopNax         .MACRO param          
                  .BYTE $F15D
		  .WORD  param
                  .ENDM
EORMopOax         .MACRO param
                  .BYTE $F25D
		  .WORD  param
                  .ENDM
EORMopQax         .MACRO param
                  .BYTE $F35D
		  .WORD  param
                  .ENDM
                  
EORNopAax         .MACRO param
                  .BYTE $C45D
		  .WORD  param
                  .ENDM                
EORNopBax         .MACRO param          
                  .BYTE $C55D
		  .WORD  param
                  .ENDM
EORNopCax         .MACRO param
                  .BYTE $C65D
		  .WORD  param
                  .ENDM
EORNopDax         .MACRO param
                  .BYTE $C75D
		  .WORD  param
                  .ENDM
EORNopEax         .MACRO param          
                  .BYTE $D45D
		  .WORD  param
                  .ENDM
EORNopFax         .MACRO param
                  .BYTE $D55D
		  .WORD  param
                  .ENDM
EORNopGax         .MACRO param
                  .BYTE $D65D
		  .WORD  param
                  .ENDM                  
EORNopHax         .MACRO param          
                  .BYTE $D75D
		  .WORD  param
                  .ENDM
EORNopIax         .MACRO param
                  .BYTE $E45D
		  .WORD  param
                  .ENDM
EORNopJax         .MACRO param
                  .BYTE $E55D
		  .WORD  param
                  .ENDM
EORNopKax         .MACRO param          
                  .BYTE $E65D
		  .WORD  param
                  .ENDM
EORNopLax         .MACRO param
                  .BYTE $E75D
		  .WORD  param
                  .ENDM
EORNopMax         .MACRO param
                  .BYTE $F45D
		  .WORD  param
                  .ENDM                  
EORNopNax         .MACRO param          
                  .BYTE $F55D
		  .WORD  param
                  .ENDM
EORNopOax         .MACRO param
                  .BYTE $F65D
		  .WORD  param
                  .ENDM
EORNopQax         .MACRO param
                  .BYTE $F75D
		  .WORD  param
                  .ENDM
            
EOROopAax         .MACRO param
                  .BYTE $C85D
		  .WORD  param
                  .ENDM                
EOROopBax         .MACRO param          
                  .BYTE $C95D
		  .WORD  param
                  .ENDM
EOROopCax         .MACRO param
                  .BYTE $CA5D
		  .WORD  param
                  .ENDM
EOROopDax         .MACRO param
                  .BYTE $CB5D
		  .WORD  param
                  .ENDM
EOROopEax         .MACRO param          
                  .BYTE $D85D
		  .WORD  param
                  .ENDM
EOROopFax         .MACRO param
                  .BYTE $D95D
		  .WORD  param
                  .ENDM
EOROopGax         .MACRO param
                  .BYTE $DA5D
		  .WORD  param
                  .ENDM                  
EOROopHax         .MACRO param          
                  .BYTE $DB5D
		  .WORD  param
                  .ENDM
EOROopIax         .MACRO param
                  .BYTE $E85D
		  .WORD  param
                  .ENDM
EOROopJax         .MACRO param
                  .BYTE $E95D
		  .WORD  param
                  .ENDM
EOROopKax         .MACRO param          
                  .BYTE $EA5D
		  .WORD  param
                  .ENDM
EOROopLax         .MACRO param
                  .BYTE $EB5D
		  .WORD  param
                  .ENDM
EOROopMax         .MACRO param
                  .BYTE $F85D
		  .WORD  param
                  .ENDM                  
EOROopNax         .MACRO param          
                  .BYTE $F95D
		  .WORD  param
                  .ENDM
EOROopOax         .MACRO param
                  .BYTE $FA5D
		  .WORD  param
                  .ENDM
EOROopQax         .MACRO param
                  .BYTE $FB5D
		  .WORD  param
                  .ENDM
                  
EORQopAax         .MACRO param
                  .BYTE $CC5D
		  .WORD  param
                  .ENDM                
EORQopBax         .MACRO param          
                  .BYTE $CD5D
		  .WORD  param
                  .ENDM
EORQopCax         .MACRO param
                  .BYTE $CE5D
		  .WORD  param
                  .ENDM
EORQopDax         .MACRO param
                  .BYTE $CF5D
		  .WORD  param
                  .ENDM
EORQopEax         .MACRO param          
                  .BYTE $DC5D
		  .WORD  param
                  .ENDM
EORQopFax         .MACRO param
                  .BYTE $DD5D
		  .WORD  param
                  .ENDM
EORQopGax         .MACRO param
                  .BYTE $DE5D
		  .WORD  param
                  .ENDM                  
EORQopHax         .MACRO param          
                  .BYTE $DF5D
		  .WORD  param
                  .ENDM
EORQopIax         .MACRO param
                  .BYTE $EC5D
		  .WORD  param
                  .ENDM
EORQopJax         .MACRO param
                  .BYTE $ED5D
		  .WORD  param
                  .ENDM
EORQopKax         .MACRO param          
                  .BYTE $EE5D
		  .WORD  param
                  .ENDM
EORQopLax         .MACRO param
                  .BYTE $EF5D
		  .WORD  param
                  .ENDM
EORQopMax         .MACRO param
                  .BYTE $FC5D
		  .WORD  param
                  .ENDM                  
EORQopNax         .MACRO param          
                  .BYTE $FD5D
		  .WORD  param
                  .ENDM
EORQopOax         .MACRO param
                  .BYTE $FE5D
		  .WORD  param
                  .ENDM
EORQopQax         .MACRO param
                  .BYTE $FF5D
		  .WORD  param
                  .ENDM

ASLAopA4          .MACRO         ;ASL X4
                  .BYTE $300A
                  .ENDM
ASLAopB4          .MACRO          
                  .BYTE $310A
                  .ENDM
ASLAopC4          .MACRO
                  .BYTE $320A
                  .ENDM
ASLAopD4          .MACRO
                  .BYTE $330A
                  .ENDM
                                    
ASLBopA4          .MACRO
                  .BYTE $340A
                  .ENDM                
ASLBopB4          .MACRO          
                  .BYTE $350A
                  .ENDM
ASLBopC4          .MACRO
                  .BYTE $360A
                  .ENDM
ASLBopD4          .MACRO
                  .BYTE $370A
                  .ENDM
                                    
ASLCopA4          .MACRO
                  .BYTE $380A
                  .ENDM                
ASLCopB4          .MACRO          
                  .BYTE $390A
                  .ENDM
ASLCopC4          .MACRO
                  .BYTE $3A0A
                  .ENDM
ASLCopD4          .MACRO
                  .BYTE $3B0A
                  .ENDM

ASLDopA4          .MACRO
                  .BYTE $3C0A
                  .ENDM                
ASLDopB4          .MACRO          
                  .BYTE $3D0A
                  .ENDM
ASLDopC4          .MACRO
                  .BYTE $3E0A
                  .ENDM
ASLDopD4          .MACRO
                  .BYTE $3F0A
                  .ENDM

ASLAopA6          .MACRO         ;ASL X6
                  .BYTE $500A
                  .ENDM
ASLAopB6          .MACRO          
                  .BYTE $510A
                  .ENDM
ASLAopC6          .MACRO
                  .BYTE $520A
                  .ENDM
ASLAopD6          .MACRO
                  .BYTE $530A
                  .ENDM
                                    
ASLBopA6          .MACRO
                  .BYTE $540A
                  .ENDM                
ASLBopB6          .MACRO          
                  .BYTE $550A
                  .ENDM
ASLBopC6          .MACRO
                  .BYTE $560A
                  .ENDM
ASLBopD6          .MACRO
                  .BYTE $570A
                  .ENDM
                                    
ASLCopA6          .MACRO
                  .BYTE $580A
                  .ENDM                
ASLCopB6          .MACRO          
                  .BYTE $590A
                  .ENDM
ASLCopC6          .MACRO
                  .BYTE $5A0A
                  .ENDM
ASLCopD6          .MACRO
                  .BYTE $5B0A
                  .ENDM

ASLDopA6          .MACRO
                  .BYTE $5C0A
                  .ENDM                
ASLDopB6          .MACRO          
                  .BYTE $5D0A
                  .ENDM
ASLDopC6          .MACRO
                  .BYTE $5E0A
                  .ENDM
ASLDopD6          .MACRO
                  .BYTE $5F0A
                  .ENDM
                                    
ASLAopA8          .MACRO         ;ASL X8
                  .BYTE $700A
                  .ENDM
ASLAopB8          .MACRO          
                  .BYTE $710A
                  .ENDM
ASLAopC8          .MACRO
                  .BYTE $720A
                  .ENDM
ASLAopD8          .MACRO
                  .BYTE $730A
                  .ENDM
 
ASLBopA8          .MACRO
                  .BYTE $740A
                  .ENDM                
ASLBopB8          .MACRO          
                  .BYTE $750A
                  .ENDM
ASLBopC8          .MACRO
                  .BYTE $760A
                  .ENDM
ASLBopD8          .MACRO
                  .BYTE $770A
                  .ENDM
                                    
ASLCopA8          .MACRO
                  .BYTE $780A
                  .ENDM                
ASLCopB8          .MACRO          
                  .BYTE $790A
                  .ENDM
ASLCopC8          .MACRO
                  .BYTE $7A0A
                  .ENDM
ASLCopD8          .MACRO
                  .BYTE $7B0A
                  .ENDM

ASLDopA8          .MACRO
                  .BYTE $7C0A
                  .ENDM                
ASLDopB8          .MACRO          
                  .BYTE $7D0A
                  .ENDM
ASLDopC8          .MACRO
                  .BYTE $7E0A
                  .ENDM
ASLDopD8          .MACRO
                  .BYTE $7F0A
                  .ENDM

ASLAopA12         .MACRO         ;ASL X12
                  .BYTE $B00A
                  .ENDM
ASLAopB12         .MACRO          
                  .BYTE $B10A
                  .ENDM
ASLAopC12         .MACRO
                  .BYTE $B20A
                  .ENDM
ASLAopD12         .MACRO
                  .BYTE $B30A
                  .ENDM
                                    
ASLBopA12         .MACRO
                  .BYTE $B40A
                  .ENDM                
ASLBopB12         .MACRO          
                  .BYTE $B50A
                  .ENDM
ASLBopC12         .MACRO
                  .BYTE $B60A
                  .ENDM
ASLBopD12         .MACRO
                  .BYTE $B70A
                  .ENDM
                                    
ASLCopA12         .MACRO
                  .BYTE $B80A
                  .ENDM                
ASLCopB12         .MACRO          
                  .BYTE $B90A
                  .ENDM
ASLCopC12         .MACRO
                  .BYTE $BA0A
                  .ENDM
ASLCopD12         .MACRO
                  .BYTE $BB0A
                  .ENDM

ASLDopA12         .MACRO
                  .BYTE $BC0A
                  .ENDM                
ASLDopB12         .MACRO          
                  .BYTE $BD0A
                  .ENDM
ASLDopC12         .MACRO
                  .BYTE $BE0A
                  .ENDM
ASLDopD12         .MACRO
                  .BYTE $BF0A
                  .ENDM
                  
LSRAopA4          .MACRO         ;LSR X4
                  .BYTE $304A
                  .ENDM
LSRAopB4          .MACRO          
                  .BYTE $314A
                  .ENDM
LSRAopC4          .MACRO
                  .BYTE $324A
                  .ENDM
LSRAopD4          .MACRO
                  .BYTE $334A
                  .ENDM
                                    
LSRBopA4          .MACRO
                  .BYTE $344A
                  .ENDM                
LSRBopB4          .MACRO          
                  .BYTE $354A
                  .ENDM
LSRBopC4          .MACRO
                  .BYTE $364A
                  .ENDM
LSRBopD4          .MACRO
                  .BYTE $374A
                  .ENDM
                                    
LSRCopA4          .MACRO
                  .BYTE $384A
                  .ENDM                
LSRCopB4          .MACRO          
                  .BYTE $394A
                  .ENDM
LSRCopC4          .MACRO
                  .BYTE $3A4A
                  .ENDM
LSRCopD4          .MACRO
                  .BYTE $3B4A
                  .ENDM

LSRDopA4          .MACRO
                  .BYTE $3C4A
                  .ENDM                
LSRDopB4          .MACRO          
                  .BYTE $3D4A
                  .ENDM
LSRDopC4          .MACRO
                  .BYTE $3E4A
                  .ENDM
LSRDopD4          .MACRO
                  .BYTE $3F4A
                  .ENDM

LSRAopA6          .MACRO         ;LSR X6
                  .BYTE $504A
                  .ENDM
LSRAopB6          .MACRO          
                  .BYTE $514A
                  .ENDM
LSRAopC6          .MACRO
                  .BYTE $524A
                  .ENDM
LSRAopD6          .MACRO
                  .BYTE $534A
                  .ENDM
                                    
LSRBopA6          .MACRO
                  .BYTE $544A
                  .ENDM                
LSRBopB6          .MACRO          
                  .BYTE $554A
                  .ENDM
LSRBopC6          .MACRO
                  .BYTE $564A
                  .ENDM
LSRBopD6          .MACRO
                  .BYTE $574A
                  .ENDM
                                    
LSRCopA6          .MACRO
                  .BYTE $584A
                  .ENDM                
LSRCopB6          .MACRO          
                  .BYTE $594A
                  .ENDM
LSRCopC6          .MACRO
                  .BYTE $5A4A
                  .ENDM
LSRCopD6          .MACRO
                  .BYTE $5B4A
                  .ENDM

LSRDopA6          .MACRO
                  .BYTE $5C4A
                  .ENDM                
LSRDopB6          .MACRO          
                  .BYTE $5D4A
                  .ENDM
LSRDopC6          .MACRO
                  .BYTE $5E4A
                  .ENDM
LSRDopD6          .MACRO
                  .BYTE $5F4A
                  .ENDM
                                    
LSRAopA8          .MACRO         ;LSR X8
                  .BYTE $704A
                  .ENDM
LSRAopB8          .MACRO          
                  .BYTE $714A
                  .ENDM
LSRAopC8          .MACRO
                  .BYTE $724A
                  .ENDM
LSRAopD8          .MACRO
                  .BYTE $734A
                  .ENDM
 
LSRBopA8          .MACRO
                  .BYTE $744A
                  .ENDM                
LSRBopB8          .MACRO          
                  .BYTE $754A
                  .ENDM
LSRBopC8          .MACRO
                  .BYTE $764A
                  .ENDM
LSRBopD8          .MACRO
                  .BYTE $774A
                  .ENDM
                                    
LSRCopA8          .MACRO
                  .BYTE $784A
                  .ENDM                
LSRCopB8          .MACRO          
                  .BYTE $794A
                  .ENDM
LSRCopC8          .MACRO
                  .BYTE $7A4A
                  .ENDM
LSRCopD8          .MACRO
                  .BYTE $7B4A
                  .ENDM

LSRDopA8          .MACRO
                  .BYTE $7C4A
                  .ENDM                
LSRDopB8          .MACRO          
                  .BYTE $7D4A
                  .ENDM
LSRDopC8          .MACRO
                  .BYTE $7E4A
                  .ENDM
LSRDopD8          .MACRO
                  .BYTE $7F4A
                  .ENDM

LSRAopA12         .MACRO         ;LSR X12
                  .BYTE $B04A
                  .ENDM
LSRAopB12         .MACRO          
                  .BYTE $B14A
                  .ENDM
LSRAopC12         .MACRO
                  .BYTE $B24A
                  .ENDM
LSRAopD12         .MACRO
                  .BYTE $B34A
                  .ENDM
                                    
LSRBopA12         .MACRO
                  .BYTE $B44A
                  .ENDM                
LSRBopB12         .MACRO          
                  .BYTE $B54A
                  .ENDM
LSRBopC12         .MACRO
                  .BYTE $B64A
                  .ENDM
LSRBopD12         .MACRO
                  .BYTE $B74A
                  .ENDM
                                    
LSRCopA12         .MACRO
                  .BYTE $B84A
                  .ENDM                
LSRCopB12         .MACRO          
                  .BYTE $B94A
                  .ENDM
LSRCopC12         .MACRO
                  .BYTE $BA4A
                  .ENDM
LSRCopD12         .MACRO
                  .BYTE $BB4A
                  .ENDM

LSRDopA12         .MACRO
                  .BYTE $BC4A
                  .ENDM                
LSRDopB12         .MACRO          
                  .BYTE $BD4A
                  .ENDM
LSRDopC12         .MACRO
                  .BYTE $BE4A
                  .ENDM
LSRDopD12         .MACRO
                  .BYTE $BF4A
                  .ENDM
                                    
;INCA             .BYTE $001A
INCB              .MACRO
                  .BYTE $051A
                  .ENDM
INCC              .MACRO
                  .BYTE $0A1A
                  .ENDM
INCD              .MACRO
                  .BYTE $0F1A
                  .ENDM
INCE              .MACRO
                  .BYTE $501A
                  .ENDM
INCF              .MACRO
                  .BYTE $551A
                  .ENDM
INCG              .MACRO
                  .BYTE $5A1A
                  .ENDM
INCH              .MACRO
                  .BYTE $5F1A
                  .ENDM
INCI              .MACRO
                  .BYTE $A01A
                  .ENDM
INCJ              .MACRO
                  .BYTE $A51A
                  .ENDM
INCK              .MACRO
                  .BYTE $AA1A
                  .ENDM
INCL              .MACRO
                  .BYTE $AF1A
                  .ENDM
INCM              .MACRO
                  .BYTE $F01A
                  .ENDM
INCN              .MACRO
                  .BYTE $F51A
                  .ENDM
INCO              .MACRO
                  .BYTE $FA1A
                  .ENDM
INCQ              .MACRO
                  .BYTE $FF1A
                  .ENDM
                  
;DECA             .BYTE $003A
DECB              .MACRO
                  .BYTE $053A
                  .ENDM
DECC              .MACRO
                  .BYTE $0A3A
                  .ENDM
DECD              .MACRO
                  .BYTE $0F3A
                  .ENDM
DECE              .MACRO
                  .BYTE $503A
                  .ENDM
DECF              .MACRO
                  .BYTE $553A
                  .ENDM
DECG              .MACRO
                  .BYTE $5A3A
                  .ENDM
DECH              .MACRO
                  .BYTE $5F3A
                  .ENDM
DECI              .MACRO
                  .BYTE $A03A
                  .ENDM
DECJ              .MACRO
                  .BYTE $A53A
                  .ENDM
DECK              .MACRO
                  .BYTE $AA3A
                  .ENDM
DECL              .MACRO
                  .BYTE $AF3A
                  .ENDM
DECM              .MACRO
                  .BYTE $F03A
                  .ENDM
DECN              .MACRO
                  .BYTE $F53A
                  .ENDM
DECO              .MACRO
                  .BYTE $FA3A
                  .ENDM
DECQ              .MACRO
                  .BYTE $FF3A
                  .ENDM
                  
INW               .MACRO
                  .BYTE $00D8
                  .ENDM
DEW               .MACRO
                  .BYTE $00F8
                  .ENDM

TAZP              .MACRO               ;Transfer A acc to Zeropage Pointer
                  .BYTE $0017
                  .ENDM
TBZP              .MACRO
                  .BYTE $0417
                  .ENDM
TCZP              .MACRO
                  .BYTE $0817
                  .ENDM
TDZP              .MACRO
                  .BYTE $0C17
                  .ENDM
TEZP              .MACRO
                  .BYTE $4017
                  .ENDM
TFZP              .MACRO
                  .BYTE $4417
                  .ENDM
TGZP              .MACRO
                  .BYTE $4817
                  .ENDM
THZP              .MACRO
                  .BYTE $4C17
                  .ENDM
TIZP              .MACRO
                  .BYTE $8017
                  .ENDM
TJZP              .MACRO
                  .BYTE $8417
                  .ENDM
TKZP              .MACRO
                  .BYTE $8817
                  .ENDM
TLZP              .MACRO
                  .BYTE $8C17
                  .ENDM
TMZP              .MACRO
                  .BYTE $C017
                  .ENDM
TNZP              .MACRO
                  .BYTE $C417
                  .ENDM
TOZP              .MACRO
                  .BYTE $C817
                  .ENDM
TQZP              .MACRO
                  .BYTE $CC17
                  .ENDM

TASP              .MACRO            ;Transfer A acc to Stackpage Pointer
                  .BYTE $0037
                  .ENDM
TBSP              .MACRO
                  .BYTE $0437
                  .ENDM
TCSP              .MACRO
                  .BYTE $0837
                  .ENDM
TDSP              .MACRO
                  .BYTE $0C37
                  .ENDM
TESP              .MACRO
                  .BYTE $4037
                  .ENDM
TFSP              .MACRO
                  .BYTE $4437
                  .ENDM
TGSP              .MACRO
                  .BYTE $4837
                  .ENDM
THSP              .MACRO
                  .BYTE $4C37
                  .ENDM
TISP              .MACRO
                  .BYTE $8037
                  .ENDM
TJSP              .MACRO
                  .BYTE $8437
                  .ENDM
TKSP              .MACRO
                  .BYTE $8837
                  .ENDM
TLSP              .MACRO
                  .BYTE $8C37
                  .ENDM
TMSP              .MACRO
                  .BYTE $C037
                  .ENDM
TNSP              .MACRO
                  .BYTE $C437
                  .ENDM
TOSP              .MACRO
                  .BYTE $C837
                  .ENDM
TQSP              .MACRO
                  .BYTE $CC37
                  .ENDM 

TZPA              .MACRO            ;Transfer Teropage Pointer to A Acc
                  .BYTE $0007
                  .ENDM
TZPB              .MACRO
                  .BYTE $0107
                  .ENDM
TZPC              .MACRO
                  .BYTE $0207
                  .ENDM
TZPD              .MACRO
                  .BYTE $0307
                  .ENDM
TZPE              .MACRO
                  .BYTE $1007
                  .ENDM
TZPF              .MACRO
                  .BYTE $1107
                  .ENDM
TZPG              .MACRO
                  .BYTE $1207
                  .ENDM
TZPH              .MACRO
                  .BYTE $1307
                  .ENDM
TZPI              .MACRO
                  .BYTE $2007
                  .ENDM
TZPJ              .MACRO
                  .BYTE $2107
                  .ENDM
TZPK              .MACRO
                  .BYTE $2207
                  .ENDM
TZPL              .MACRO
                  .BYTE $2307
                  .ENDM
TZPM              .MACRO
                  .BYTE $3007
                  .ENDM
TZPN              .MACRO
                  .BYTE $3107
                  .ENDM
TZPO              .MACRO
                  .BYTE $3207
                  .ENDM
TZPQ              .MACRO
                  .BYTE $3307
                  .ENDM
                  
TSPA              .MACRO            ;Transfer Stackpage Pointer to A Acc
                  .BYTE $0027
                  .ENDM
TSPB              .MACRO
                  .BYTE $0127
                  .ENDM
TSPC              .MACRO
                  .BYTE $0227
                  .ENDM
TSPD              .MACRO
                  .BYTE $0327
                  .ENDM
TSPE              .MACRO
                  .BYTE $1027
                  .ENDM
TSPF              .MACRO
                  .BYTE $1127
                  .ENDM
TSPG              .MACRO
                  .BYTE $1227
                  .ENDM
TSPH              .MACRO
                  .BYTE $1327
                  .ENDM
TSPI              .MACRO
                  .BYTE $2027
                  .ENDM
TSPJ              .MACRO
                  .BYTE $2127
                  .ENDM
TSPK              .MACRO
                  .BYTE $2227
                  .ENDM
TSPL              .MACRO
                  .BYTE $2327
                  .ENDM
TSPM              .MACRO
                  .BYTE $3027
                  .ENDM
TSPN              .MACRO
                  .BYTE $3127
                  .ENDM
TSPO              .MACRO
                  .BYTE $3227
                  .ENDM
TSPQ              .MACRO
                  .BYTE $3327
                  .ENDM
                                    
STazpw            .MACRO
                  .BYTE $0092
                  .ENDM
LDazpw            .MACRO
                  .BYTE $00B2
                  .ENDM
                  
            		
START:	    LDA #$0000
            TASP                 ;SET STACKPAGE POINTER =0
            TAZP                 ;SET ZEROPAGE POINTER =0
            STA KBSTAT          ;DISABLE Tx & Rx INTERRUPTS
            LDA #$FF
            STA KBSTAT           ;RESET KEYBOARD
            LDA #$F4
            STA KBSTAT           ;ENABLE KEYBOARD
            ;LDA #$ED
            ;STA KBSTAT          ;
            ;LDA #$07
            ;STA KBSTAT          ;LIGHT UP LEDS
            ;LDA #$80
            ;STA KBDAT
            ;STA KBSTAT 
            
            LDA #$01
    		    STA DCOM
				    STA DCOM
				    STA DCOM
		
        		LDX #$FF
AA:			    DEX
    				BNE AA

    		    LDA #$E0
				    STA DCOM
				    LDA #$01
    		    STA DDAT

				    LDX #$FF
AB:			    DEX
				    BNE AB

    		    LDA #$E0
     		    STA DCOM
     		    LDA #$03
    		    STA DDAT
		
    		    LDA #$B0            ;SET LCD MODE
    		    STA DCOM
				    LDA #$08
				    STA DDAT
				    LDA #$00
				    STA DDAT
				    LDA #$03
				    STA DDAT
				    LDA #$1F
				    STA DDAT
				    LDA #$01
				    STA DDAT
				    LDA #$DF
				    STA DDAT
				    LDA #$00
				    STA DDAT

				    LDA #$F0            ;SET PIXEL INTERFACE
				    STA DCOM
				    LDA #$00            ;8BIT
				    STA DDAT

				    LDA #$36            ;SET ADDRESS MODE
				    STA DCOM
				    LDA #$03
				    STA DDAT

				    LDA #$3A            ;SET PIXEL FORMAT
				    STA DCOM
				    LDA #$60            ;18-BITS/PIXEL
				    STA DDAT

				    LDA #$E2            ;SET PLL
				    STA DCOM
				    LDA #$22
				    STA DDAT
				    LDA #$03
				    STA DDAT
				    LDA #$04
				    STA DDAT

				    LDA #$E6            ;SET PIXEL CLOCK FREQUENCY
				    STA DCOM
				    LDA #$03
				    STA DDAT
				    LDA #$FF
				    STA DDAT
				    STA DDAT

				    LDA #$B4           ;SET HORIZONTAL PERIOD
				    STA DCOM
				    LDA #$03
				    STA DDAT
				    LDA #$EF
				    STA DDAT
				    LDA #$00
				    STA DDAT
				    LDA #$A3
				    STA DDAT
				    LDA #$07
				    STA DDAT
    				LDA #$00
    				STA DDAT
    				STA DDAT
    				STA DDAT
    
    				LDA #$B6            ;SET VERTICAL PERIOD
    				STA DCOM
    				LDA #$01
    				STA DDAT
    				LDA #$EF
    				STA DDAT
    				LDA #$00
    				STA DDAT
    				LDA #$04
    				STA DDAT
    				LDA #$01
    				STA DDAT
    				LDA #$00
    				STA DDAT
    				STA DDAT
    	
    				LDA #$29
    				STA DCOM
    
BEGIN       LDA #%1000010110000000   ;ATTRIBUTE MASK FOR C-64 ASSEMBLER
            STA ATTBUT
            LDA #$00
            STA SCRCOL1
            LDA #$00
            STA SCRCOL2
            LDA #$00
            STA SCRCOL3
            JSR CLRSCR             
          
            LDA #$00
            STA XPOS
            STA YPOS
            
            JSR VIDINIT  
            
WIDTH  .EQU 8         ;must be a power of 2
HEIGHT .EQU 16

MON    ;CLD             
M1     JSR OUTCR
       LDA #$2D       ;output dash prompt
       JSR OUTPUT
M2     LDA #$00
       STA NUMBER+1
       STA NUMBER
M3     AND #$0F
M4     LDY #$04         ;accumulate digit
M5     ASL NUMBER
       ROL NUMBER+1
       DEY
       BNE M5
       ORA NUMBER
       STA NUMBER
M6     JSR INPUT
       CMP #$0D
       BEQ M1         ;branch if cr
;
; Insert additional commands for characters (e.g. control characters)
; outside the range $20 (space) to $7E (tilde) here
;
       CMP #$20       ;don't output if outside $20-$7E
       BCC M6
       CMP #$7F
       BCS M6
       JSR OUTPUT
       CMP #$2C
       BEQ COMMA
       CMP #$2F       ;'/'  STORE
       BEQ AT
       CMP #$2E       ;'.'  STEP
       BEQ SSTEP
;
; Insert additional commands for non-letter characters (or case-sensitive
; letters) here
;
       EOR #$30
       CMP #$0A
       BCC M4         ;branch if digit
       ORA #$20       ;convert to upper case
       SBC #$77
;
; convert:
;   A-F -> $FFFA-$FFFF
;   G-O -> $0000-$0008
;   P-Z -> $FFE9-$FFF3
;
       BEQ GO
       CMP #$FFFA
       BCS M3
;
; Insert additional commands for (case-insensitive) letters here
;
       CMP #$FFF1
       BNE M6
DUMP   JSR OUTCR
       TYA
       PHA
       CLC            ;output address
       ADC NUMBER
       PHA
       LDA #0
       ADC NUMBER+1
       JSR OUTHEX
       PLA
       JSR OUTHSP
D1     LDA (NUMBER),Y ;output hex bytes
       JSR OUTHSP
       INY
       TYA
       AND #WIDTH-1 
       BNE D1
       PLA
       TAY
D2     LDA (NUMBER),Y ;output MSB character
       
       LSRAopA8            ;MACRO TO LSR A X8
       
       AND #$FF
       CMP #$20
       BCC D3
       CMP #$7F
       BCC D4
D3     LDA #$7F        ;INVALID ASCII = CURSOR CHAR
D4     JSR OUTPUT
       LDA (NUMBER),Y  ;OUTPUT LSB CHARACTER
       AND #$00FF
       CMP #$0020
       BCC D5
       CMP #$007F
       BCC D6
D5     LDA #$7F
D6     JSR OUTPUT
       INY
       TYA
       AND #WIDTH-1
       BNE D2
       CPY #WIDTH*HEIGHT
       BCC DUMP
       JMP M1         
COMMA  LDA NUMBER
       STA (ADRESS),Y
       INC ADRESS
       BNE M2
       INC ADRESS+1
       BCS M2         ;always
AT     LDA NUMBER
       STA ADRESS
       LDA NUMBER+1
       STA ADRESS+1
       BCS M2         ;always
GO     JSR G1
       JMP M2
G1     JMP (NUMBER)
OUTHEX JSR OH1
OH1    JSR OH2
OH2    ASL
       ADC #$00
       ASL
       ADC #$00
       ASL
       ADC #$00
       ASL
       ADC #$00
       PHA
       AND #$0F
       CMP #$0A
       BCC OH3
       ADC #$66
OH3    EOR #$30
       JSR OUTPUT
       PLA
       RTS
OUTHSP JSR OUTHEX
       LDA #$20
OA1    JMP OUTPUT
OUTCR  LDA #$0D
       JSR OUTPUT
       LDA #$0A
       BNE OA1        ;always
       
SSTEP  LDX #$07
STEP1  LDA STEP4,X
       STA STBUF+1,X
       DEX
       BPL STEP1
       LDX SREG
       TXS
       LDA (ADRESS),Y
       BEQ STBRK
       JSR GETLEN
       TYA
       PHA
STEP2  LDA (ADRESS),Y
       STA STBUF,Y
       DEY
       BPL STEP2
       EOR #$20
       CMP #$01
       PLA
       JSR STADR
       LDA STBUF
       CMP #$20
       BEQ STJSR
       CMP #$4C
       BEQ STJMP
       CMP #$40
       BEQ STRTI
       CMP #$60
       BEQ STRTS
       CMP #$6C
       BEQ STJMPI
       AND #$1F
       CMP #$10
       BNE STEP3
       LDA #$04
       STA STBUF+1
STEP3  LDA PREG
       PHA
       LDA AREG
       LDX XREG
       LDY YREG
       PLP
       JMP STBUF
STEP4  NOP
       NOP
       JMP STNB
       JMP STBR
STJSR  LDA ADRESS+1
       PHA
       LDA ADRESS
       PHA        ;fall thru
STJMP  LDY STBUF+1
       LDA STBUF+2
STJMP1 STY ADRESS
STJMP2 STA ADRESS+1
       JMP STNB1
STJMPI INY
       LDA (STBUF+1),Y
       STA ADRESS
       INY
       LDA (STBUF+1),Y
       JMP STJMP2
STRTI  PLA
       STA PREG
       PLA
       STA ADRESS
       PLA
       JMP STJMP2
STRTS  PLA
       STA ADRESS
       PLA
       STA ADRESS+1
       LDA #$00
       JSR STADR
       JMP STNB1
STBRK  LDA ADRESS+1
       PHA
       LDA ADRESS
       PHA
       LDA PREG
       PHA
       ORA #$04 ; set i flag
       AND #$F7 ; clear d flag
       STA PREG
       LDY $FFFFFFFE
       LDA $FFFFFFFF
       JMP STJMP1
STNB   PHP
       STA AREG
       STX XREG
       STY YREG
       PLA
       STA PREG
       CLD
STNB1  TSX
       STX SREG
STNB2  JSR STOUT
       JMP M2
STBR   DEC ADRESS+1
       LDY #$FFFF
       LDA (ADRESS),Y
       BMI STBR1
       INC ADRESS+1
STBR1  CLC
       JSR STADR
       JMP STNB2
STADR  ADC ADRESS
       STA ADRESS
       BCC STADR1
       INC ADRESS+1
STADR1 RTS
OUTPC  LDA ADRESS+1
       JSR OUTHEX
       LDA ADRESS
       JMP OUTHSP
STOUT  JSR OUTCR
       JSR OUTPC ; fall thru
OUTREG LDA AREG
       JSR OUTHSP
       LDA SREG
       JSR OUTHSP
       LDA XREG
       JSR OUTHSP
       LDA YREG
       JSR OUTHSP
       LDA PREG
       JSR OUTHSP
       LDA PREG   ;fall thru
OUTBIN SEC
       ROL
OUTB1  PHA
       LDA #$18
       ROL
       JSR OUTPUT
       PLA
       ASL
       BNE OUTB1
       RTS
;
;    0123456789ABCDEF
;
; 00 22...22.121..33.
; 10 22...22.13...33.
; 20 32..222.121.333.
; 30 22...22.13...33.
; 40 12...22.121.333.
; 50 22...22.13...33.
; 60 12...22.121.333.
; 70 22...22.13...33.
; 80 .2..222.1.1.333.
; 90 22..222.131..3..
; A0 222.222.121.333.
; B0 22..222.131.333.
; C0 22..222.121.333.
; D0 22...22.13...33.
; E0 22..222.121.333.
; F0 22...22.13...33.
;
; Return instruction length - 1 (note that BRK is considered to be a 2 byte
; instruction and returns 1)
;
GETLEN LDY #$01
       CMP #$20  ; if opcode = $20, then length = 3
       BEQ GETL3
       AND #$DF
       CMP #$40
       BEQ GETL1 ; if (opcode & $DF) = $40, then length = 1
       AND #$1F
       CMP #$19
       BEQ GETL3 ; if (opcode & $1F) = $19, then length = 3
       AND #$0D
       CMP #$08
       BNE GETL2 ; if (opcode & $0D) = $08, then length = 1
GETL1  DEY
GETL2  CMP #$0C
       BCC GETL4 ; if (opcode & $0D) >= $0C, then length = 3
GETL3  INY
GETL4  RTS

BREK   STA AREG
       STX XREG
       STY YREG
       PLA
       STA PREG
       PLA
       STA ADRESS
       PLA
       STA ADRESS+1
       TSX
       STX SREG
       CLD
       JSR STOUT
       JMP M1

VIDINIT     PHY
            PHX
            PHA
            LDA #$00
            LDX #$00
            LDY #$13
            JSR I2CWREG
            
            LDA #$00
            LDX #$01
            LDY #$16
            JSR I2CWREG
            
            LDA #$00
            LDX #$03
            LDY #$01
            JSR I2CWREG
            
            LDA #$00
            LDX #$04
            LDY #$07
            JSR I2CWREG
            
            LDA #$00
            LDX #$05
            LDY #$78
            JSR I2CWREG
            
            LDA #$00
            LDX #$10
            LDY #$1C
            JSR I2CWREG
            
            LDA #$00
            LDX #$11
            LDY #$3E
            JSR I2CWREG
            
            LDA #$00
            LDX #$12
            LDY #$F8
            JSR I2CWREG
            
            LDA #$00
            LDX #$13
            LDY #$E0
            JSR I2CWREG
            
            LDA #$00
            LDX #$14
            LDY #$43
            JSR I2CWREG
            PLA
            PLX
            PLY
            RTS
                   
;; X contains register 
;; A contains value 
I2CWREG                   
        sta     I2Caddr            
        stx     addr
        sty     val              
        jsr     i2c_delay        
        jsr     i2c_delay        
        jsr     i2c_start
        
        lda     I2Caddr
        ASLAopA8
        ora     #$0080
        jsr     i2c_wrbyte      
        
        lda     addr
        ASLAopA8
        ora     #$0080
        jsr     i2c_wrbyte      

        lda     val
        ASLAopA8
        ora     #$0080
        jsr     i2c_wrbyte      
        
        jmp     i2c_stop     
        RTS
            
sda_low 
        and     #$fe            ; clear SDA bit 
i2c_write 
        sta     I2CREG           ; write to I2C 
        jsr     i2c_delay       ; 
        jmp     i2c_delay       ; 
        
sda_high 
        ora     #$01            ; set SDA bit 
        bne     i2c_write       ; 

scl_low 
        and     #$fd            ; clear SCL bit 
        sta     I2CREG           ; 
        jmp     i2c_delay       ; 
        
scl_high 
        ora     #$02            ; set SCL bit 
        sta     I2CREG            
        jsr     i2c_delay               
i2c_delay 
        ldx     #$0f             ; adjust based on clock speed 
AA1     dex                      ;$0F = 100kHz WITH 40MHz O2
        bne     AA1              
        rts 

i2c_start 
        lda     #2              
        jsr     sda_low          
        jmp     scl_low          
       
i2c_stop 
        jsr     i2c_delay        
        jsr     sda_low          
        jsr     scl_high        
        jmp     sda_high
        
i2c_rdbit 
        sec                      
i2c_wrbit 
        lda     #0                
        adc     #0              
        jsr     scl_low          
        jsr     scl_high        
        jmp     scl_low            
i2c_wrbyte 
        sta     data            
        ldy     #9              
AA2     ;sec                      
        rol     data            
        jsr     i2c_wrbit        
        dey                      
        bne     AA2              
        rts                      

                        
FILEIN      LDA UARTSREG
            AND #$80
            CMP #$80
            BNE AQ
            LDA UARTDREG
            CMP #$02            ;START OF TEXT?
            BNE AU
AS          JSR BYTREC
            CMP #$03            ;END OF TEXT?
            BEQ AQ
            ORA ATTBUT
            JSR PLTCHR
            JMP AS
            JSR PRTCOUNT            
AU          CMP #$0F            ;START OF BITMAP?
            BNE AQ
AV          INC COUNTER              
            JSR BYTREC          ;WAIT UNTIL BYTE RECEIVED
            LDY COUNTER
            CPY #$12            ;XWIDTH VALUE
            BNE AV              ;NO? GET THERE
            LDA UARTDREG
            STA XWIDTH
            LDX #$2A            ;PREPARE TO SEND X COORD'S
            STX DCOM
            LDX #$00
            STX DDAT
            STX DDAT
            STX DDAT
            LDX XWIDTH
            DEX
            STX DDAT
            
AW          JSR BYTREC
            INC COUNTER
            LDY COUNTER
            CPY #$16            ;YWIDTH VALUE
            BNE AW
            LDA UARTDREG
            STA YWIDTH
            LDX #$2B            ;PREPARE TO SEND Y COORD'S
            LDX #$00
            STX DDAT
            STX DDAT
            STX DDAT
            LDX YWIDTH
            DEX
            STX DDAT
                      
            
AX          JSR BYTREC
            INC COUNTER
            LDY COUNTER
            CPY #$35            ;START OF PIXEL DATA
            BNE AX
            LDA #$2C
            STA DCOM            ;PREPARE TO PLOT PIXEL DATA 
            LDX XWIDTH
AY          LDY YWIDTH
BA          JSR BYTREC
            STA DDAT
            JSR BYTREC
            STA DDAT
            JSR BYTREC
            STA DDAT
            DEY 
            BNE BA
            DEX
            BNE AY
            JSR PRTCOUNT
            JMP AQ

BYTREC      LDA UARTSREG
            AND #$80
            CMP #$80
            BNE BYTREC
            LDA UARTDREG
            RTS            
            
PRTCOUNT    PHA
            LDA XPOS            ;PRINT LENGTH OF FILE <65K
            PHA
            LDA YPOS
            PHA
            LDA #742
            STA XPOS
            LDA #$00
            STA YPOS
            LDA COUNTER
            JSR PLTHEX
            PLA
            STA YPOS
            PLA
            STA XPOS
            LDA #$00
            STA COUNTER
            PLA
AQ          RTS     
            
INPUT       PHY
BB          LDY KBSTAT          ;GET KEY FROM LOCAL KEYBOARD, PUT IN ACCUMULATOR
            CPY #$C0
            BEQ BB
            CPY #$C2
            BEQ BB
AK          LDY KBDAT           ;LOAD DATA
            CPY #$F0
            BNE AM              ;CHECK END KEYPRESS
            LDX #$2000
AL          DEX                 ;SMALL DELAY
            BNE AL
            BEQ NPRESS          ;SKIP  END KEYPRESS VALUE
AM          LDA KEYTABLE,Y            
            LDY KBSTAT
            CPY #$C3
            BEQ AK              ;IF KEY STILL BEING PRESSED THEN LOOP
NPRESS      PLY
            RTS

OUTPUT      JSR PLTCHR
            RTS
            

EOL         LDBi $0000            ;END OF LINE, CARRIAGE RETURN ROUTINE
            STBzp XPOS
            LDBzp YPOS
            CMPBi $01D0		; #464            ;CHECK FOR BOTTOM LINE
            BMI AO
            LDBi $0000
            BEQ AP
AO          CLC
            ADCBopBzp CHRYLENFIN
AP          STBzp YPOS
            RTS
                        
NCHAR       CMPBi $000D
            BNE AI
            JSR EOL
AI	    PLA		
	    RTS

PLTCHR           		PHA
				ORA ATTBUT	; Plot Character Subroutine variable (1-4) H and V size
            		       			; A ACC PERMANENT. HAS CHARACTER ASCII + ATTRIBUTE INFO

ATTBUTE     			ANDAopBi $0F00	; USE B ACC TEMP. $0F00=0000_1111_0000_0000. get color VALUE from bits 8,9,10,11
            
            			LSRBopB6      	; multiply by 4 for easy indexing
            
            			TBX
	          	  	LDCax COLTABLE	; USE C ACC TEMP. LDC $xxxxxxxx,x
	          	  	STCzp PXLCOL1	; STC $xxxx. TFT RED
	         	    	INX
	          	  	LDCax COLTABLE
	          	  	STCzp PXLCOL2	; TFT GREEN
	          	  	INX
	          	  	LDCax COLTABLE
	          	  	STCzp PXLCOL3	; TFT BLUE

	          	  	ANDAopBi $3000	;USE B ACC TEMP. $3000=0011_0000_0000_0000. check bits 12,13 for size
	          		          
            			LSRBopB12  	;SIZE 00=1x, 01=2x, 10=3x, 11=4x
            
            			INCB          	;MAKE SIZE 0x = 1x
AG         		  	STBzp XWIDTH
	          	  	STBzp YWIDTH
	
	          	  	ANDAopBi $C000	;#%1100_0000_0000_0000  font bits, 00=16X16  01=DOS  10=C64  11=???
	          	
            			STBzp FONT
	          	  	BEQ n8X8
            
            			LDBi $0008	; 8 PIXELS
            			STBzp PATROW
            			STBzp CHRXLEN
            			STBzp CHRYLEN

            			LDBi $CA00
            			STBzp CHRBASE
		        	LDBi $0080
		        	STBzp SENTINEL
	          		JMP porc

n8X8        			LDBi $000F
            			STBzp PATROW
            			STBzp CHRXLEN
	          		STBzp CHRYLEN
            			LDBi $CD00
            			STBzp CHRBASE
		        	LDBi $0001
		        	STBzp SENTINEL
	
porc        			LDBi $0000
            			LDX YWIDTH
            			CLC
AR          			ADCBopBzp CHRYLEN
            			DEX
            			BNE AR
            			STBzp CHRYLENFIN    ;REAL CHARACTER Y BITSIZE
            
             			ANDAopBi $0080	; $0080=0000_0000_1000_0000 ;test PE bit 7 for plot or clear
            
            			CMPBi $0080
		        	BEQ plot2
	          		LDBzp SCRCOL1
	          		STBzp TMPCOL1
	          		LDBzp SCRCOL2
	          		STBzp TMPCOL2
	          		LDBzp SCRCOL3
	          		STBzp TMPCOL3
	          		JMP PLTPOS
plot2	      			LDBzp PXLCOL1
	          		STBzp TMPCOL1
	          		LDBzp PXLCOL2
	          		STBzp TMPCOL2
	          		LDBzp PXLCOL3
	          		STBzp TMPCOL3

PLTPOS      			LDBi $002A          ;set x address
	          		STBa DCOM	
            			LDBzp XPOS
            			CMPBi $0320     ;$0320=800     ;EOL?
            			BMI AN
            			JSR EOL
            			LDBi $0000
AN          			PHB
            
            			LSRBopB8
            
            			STBa DDAT          ;X START MSB
            			PLB
            			ANDBopBi $00FF
            			STBa DDAT          ;X START LSB

            			LDBzp XPOS
            			CLC
            			LDX XWIDTH
AC          			ADCBopBzp CHRXLEN	
            			DEX
            			BNE AC
            			STBzp XPOS          ;UPDATE X POSITION
            			DECB
            			PHB
            
            			LSRBopB8
            
            			STBa DDAT          ;X END MSB
            			PLB
            			ANDBopBi $00FF
            			STBa DDAT          ;X END LSB

            			LDBi $002B          ;set y address
            			STBa DCOM
	          		LDBzp YPOS
            			PHB
            
            			LSRBopB8
            
            			STBa DDAT          ;Y START MSB
            			PLB
            			ANDBopBi $00FF
            			STBa DDAT          ;Y START LSB

            			LDBzp YPOS
            			CLC
            			ADCBopBzp CHRYLENFIN
            
            			DECB
            			PHB
            
            			LSRBopB8
            
            			STBa DDAT          ;Y END MSB
            			PLB
            			ANDBopBi $00FF
            			STBa DDAT          ;Y END LSB

            
            
CACALC      			LDBi $002C          ; Prepare TFT to Plot 
            			STBa DCOM
              
            			ANDAopBi $007F          ; an ascii char ? MINUS ATTRIBUTE INFO
            			CMPBi $0020
            			BCC NCHAR
nnull       			SEC
            			SBCBopBi $0020
            			
				.BYTE $250A		;ASLBopB3   Bx8      
            			
            			CLC 
            			ADCBopBzp CHRBASE     ; add pointer to base either CA00 (8X8) or CD00(16X16) (carry clear) 
            			TBY 

loop7       			LDBzp XWIDTH        ; plot row repeat count (1-7) 
            			STBzp PIXROW 
loop4       			LDBay CHARPIX	     ; LDB $FFFFCA00,y (c64) or LDB $FFFFCD00,y (16X16)
            			LDX FONT
            			CPX #%1000000000000000          ;CHECK FOR C-64 FONT
            			BNE skasl         ;SKIP SHIFT OUT TOP 8 BITS
            
            			ASLBopB8               ;SHIFT OUT TOP 8 BIT FOR C-64 ONLY 
           
skasl       			CPX #%0100000000000000
            			BNE skas2
            			ANDBopBi $FF00
skas2       			ORABopBzp SENTINEL      ; $0080 (8X8) or $0001 (16X16) 

            			.BYTE $050A		;ASL B        ; get a pixel
 
loop5       			LDX YWIDTH        ; plot column repeat count (1-7) (same as PLTHGT?) 
            			BCC xwnp          ; b: clear ('blank') 

xwp         			LDCzp TMPCOL1    
            			STCa DDAT          ; plot RED pixel TFT data 
            			LDCzp TMPCOL2    
            			STCa DDAT          ; plot GREEN pixel TFT data 
            			LDCzp TMPCOL3    
            			STCa DDAT          ; plot BLUE pixel TFT data 
            			DEX 
            			BNE xwp 
            			BEQ nxtpix        ; b: forced 
                          
xwnp        			LDCzp SCRCOL1    
            			STCa DDAT          ; plot RED "blank" pixel TFT data 
            			LDCzp SCRCOL2    
            			STCa DDAT          ; plot GREEN "blank" pixel TFT data 
            			LDCzp SCRCOL3 
            			STCa DDAT          ; plot BLUE "blank" pixel TFT data 
            			DEX 
            			BNE xwnp 

nxtpix      			.BYTE $050A		;ASL B             ; another pixel to plot ? 
            			BNE loop5         ; b: yes (sentinel still hasn't shifted out) 

            			DEC PIXROW        ; repeat this row ? 
            			BNE loop4         ; b: yes 

            			INY 
            			DEC PATROW        ; another pattern row to plot ? 
            			BNE loop7         ; b: yes 
				PLA
            			RTS


  
CLRSCR:	    			    LDA #$2A          ;set x address
				    STA DCOM
				    LDA #$00          ;start
				    STA DDAT
				    LDA #$00
				    STA DDAT
				    LDA #$03          ;end
				    STA DDAT
				    LDA #$1F
				    STA DDAT
	
				    LDA #$2B          ;set y address
				    STA DCOM
				    LDA #$00          ;start
				    STA DDAT
				    LDA #$00
				    STA DDAT
				    LDA #$01          ;end
				    STA DDAT
				    LDA #$DF
				    STA DDAT
	
				    LDA #$2C          ;prepare to send display data
				    STA DCOM
				    LDY #$06          ;5x65536=800X480=384,000 pixels
AE:			    LDX #$0000
AF:			    LDA SCRCOL1
				    STA DDAT
				    LDA SCRCOL2
				    STA DDAT
				    LDA SCRCOL3
				    STA DDAT
				    DEX
				    BNE AF
				    DEY
				    BNE AE
	   		    RTS
            
PLTHEX      PHY
            PHA
            PHA
            PHA
            
            LSRAopA12
            
            TAX
            LDA HEXDIGIT,X
            JSR PLTCHR
            
            PLA
            AND #$0F00
            
            LSRAopA8
            
            TAX
            LDA HEXDIGIT,X
            JSR PLTCHR
            
            PLA
            AND #$00F0
            
            LSRAopA4
            
            TAX
            LDA HEXDIGIT,X
            JSR PLTCHR
            
            PLA
            AND #$000F
            TAX
            LDA HEXDIGIT,X
            JSR PLTCHR
            PLY
            RTS
            		
;===============================================================================
; Vectors
;-------------------------------------------------------------------------------
	  .ORG HEXDIGIT
          .BYTE $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$41,$42,$43,$44,$45,$46
    
    .ORG KEYTABLE                                ;KEYBOARD TO ASCII TABLE
    		                                         ; 00,01,02, 03,04,05,06,07       
          .BYTE $00,$00,$00,$00,$00,$00,$00,$00  ;UND,F9,UND,F5,F3,F1,F2,F12
                                                 ; 08, 09,0A,0B,0C, 0D,OE,OF
          .BYTE $00,$00,$00,$00,$00,$00,$5F,$00	 ;UND,F10,F8,F6,F4,TAB, ~,UND
		                                             ; 10, 11, 12, 13,  14,15,16, 17
          .BYTE $00,$00,$00,$00,$00,$71,$31,$00  ;UND,ALT,LSH,UND,LCTL, Q, 1,UND
                                                 ; 18, 19,1A, 1B,1C,1D,1E, 1F
          .BYTE $00,$00,$7A,$73,$61,$77,$32,$00  ;UND,UND, Z, S, A, W, 2,UND
		                                             ; 20,21,22,23,24,25,26, 27
          .BYTE $00,$63,$78,$64,$65,$34,$33,$00  ;UND, C, X, D, E, 4, 3,UND
                                                 ; 28, 29,2A,2B,2C,2D,2E, 2F
          .BYTE $00,$20,$76,$66,$74,$72,$35,$00  ;UND,SPA, V, F, T, R, 5,UND
		                                             ; 30,31,32,33,34,35,36, 37
          .BYTE $00,$6E,$62,$68,$67,$79,$36,$00  ;UND, N, B, H, G, Y, 6,UND
                                                 ; 38, 39,3A,3B,3C,3D,3E, 3F
          .BYTE $00,$00,$6D,$6A,$75,$37,$38,$00  ;UND,UND, M, J, U, 7, 8,UND
		                                             ; 40,41,42,43,44,45,46, 47
          .BYTE $00,$2C,$6B,$69,$6F,$30,$39,$00  ;UND, ,, K, I, O, 0, 9,UND
                                                 ; 48,49,4A,4B,4C,4D,4E, 4F
          .BYTE $00,$2E,$2F,$6C,$3B,$70,$2D,$00  ;UND, ., /, L, ;, P, -,UND
		                                             ; 50, 51,52, 53,54,55, 56, 57
          .BYTE $00,$00,$27,$00,$5B,$3D,$00,$00  ;UND,UND, ',UND, [, =,UND,UND
                                                 ; 58, 59, 5A,5B, 5C,5D, 5E, 5F
          .BYTE $00,$00,$0D,$5D,$00,$5C,$00,$00  ;UND,RSH,RET, ],UND, \,UND,UND
		                                             ; 60, 61, 62, 63, 64, 65, 66, 67
          .BYTE $00,$00,$00,$00,$00,$00,$00,$00  ;UND,UND,UND,UND,UND,UND,UND,UND
                                                 ; 68,69, 6A,6B,6C, 6D, 6E, 6F
          .BYTE $00,$31,$00,$34,$37,$00,$00,$00  ;UND, 1,UND, 4, 7,UND,UND,UND
		                                             ;70,71,72,73,74,75, 76, 77
          .BYTE $30,$2E,$32,$35,$00,$38,$00,$00  ; 0, ., 2, 5, 6, 8,UND,UND
                                                 ; 78,79,7A,7B,7C,7D,  7E, 7F
          .BYTE $00,$2B,$33,$2D,$2A,$39,$00,$00  ;UND, +, 3, -, *, 9,SCRL,UND
             
    .ORG COLTABLE                 ;4-bit C-64 color table
    		  .BYTE $00,$00,$00,$00   ;0 - BLACK
          .BYTE $FF,$FF,$FF,$00   ;1 - WHITE
          .BYTE $FF,$00,$00,$00   ;2 - RED
          .BYTE $00,$FF,$FF,$00	  ;3 - CYAN
		      .BYTE $FF,$00,$FF,$00   ;4 - PURPLE
          .BYTE $00,$FF,$00,$00   ;5 - GREEN
          .BYTE $00,$00,$FF,$00   ;6 - BLUE
          .BYTE $FF,$FF,$00,$00   ;7 - YELLOW
		      .BYTE $FF,$3F,$00,$00   ;8 - ORANGE
          .BYTE $8B,$45,$13,$00   ;9 - BROWN
          .BYTE $9A,$67,$59,$00   ;A - LIGHT RED
          .BYTE $44,$44,$44,$00   ;B - DARK GRAY
		      .BYTE $6C,$6C,$6C,$00   ;C - MEDIUM GRAY
          .BYTE $9A,$D2,$84,$00   ;D - LIGHT GREEN
          .BYTE $6C,$5E,$B5,$00   ;E - LIGHT BLUE
          .BYTE $95,$95,$95,$00   ;F - LIGHT GRAY
    
    .ORG $FFFFCA00         ;8x8 DOS/C-64 Combined Character Pixel Data
	        .BYTE $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000      ;Char $20   " "
          .BYTE $3018,$7818,$7818,$3018,$3000,$0000,$3018,$0000      ;           "!"
          .BYTE $6C66,$6C66,$6C66,$0000,$0000,$0000,$0000,$0000      ;           """   quote
          .BYTE $6C66,$6C66,$FEFF,$6C66,$FEFF,$6C66,$6C66,$0000      ;           "#"
          .BYTE $3018,$7C3E,$C060,$783C,$0C06,$F87C,$3018,$0000      ;           "$"
          .BYTE $0062,$C666,$CC0C,$1818,$3030,$6666,$C646,$0000      ;           "%"
          .BYTE $383C,$6C66,$383C,$7638,$DC67,$CC66,$763F,$0000      ;           "&"
          .BYTE $6006,$600C,$C018,$0000,$0000,$0000,$0000,$0000      ;           "'"   single quote
          .BYTE $180C,$3018,$6030,$6030,$6030,$3018,$180C,$0000      ;           "("
          .BYTE $6030,$3018,$180C,$180C,$180C,$3018,$6030,$0000      ;           ")"
          .BYTE $0000,$6666,$3C3C,$FFFF,$3C3C,$6666,$0000,$0000      ;           "*"
          .BYTE $0000,$3018,$3018,$FC7E,$3018,$3018,$0000,$0000      ;           "+"
          .BYTE $0000,$0000,$0000,$0000,$0000,$3018,$3018,$6030      ;           ","
          .BYTE $0000,$0000,$0000,$FC7E,$0000,$0000,$0000,$0000      ;           "-"
          .BYTE $0000,$0000,$0000,$0000,$0000,$3018,$3018,$0000      ;           "."
          .BYTE $0600,$0C03,$1806,$300C,$6018,$C030,$8060,$0000      ;Char $2F   "/"    
          .BYTE $7C3C,$C666,$CE6E,$DE76,$F666,$E666,$7C3C,$0000      ;Char $30   "0"
          .BYTE $3018,$7018,$3038,$3018,$3018,$3018,$FC7E,$0000      ;           "1"
          .BYTE $783C,$CC66,$0C06,$380C,$6030,$CC60,$FC7E,$0000      ;           "2"
          .BYTE $783C,$CC66,$0C06,$381C,$0C06,$CC66,$783C,$0000      ;           "3"
          .BYTE $1C06,$3C0E,$6C1E,$CC66,$FE7F,$0C06,$1E06,$0000      ;           "4"
          .BYTE $FC7E,$C060,$F87C,$0C06,$0C06,$CC66,$783C,$0000      ;           "5"
          .BYTE $383C,$6066,$C060,$F87C,$CC66,$CC66,$783C,$0000      ;           "6"
          .BYTE $FC7E,$CC66,$0C0C,$1818,$3018,$3018,$3018,$0000      ;           "7"
          .BYTE $783C,$CC66,$CC66,$783C,$CC66,$CC66,$783C,$0000      ;           "8"
          .BYTE $783C,$CC66,$CC66,$7C3E,$0C06,$1866,$703C,$0000      ;Char $39   "9"
          .BYTE $0000,$3000,$3018,$0000,$0000,$3018,$3000,$0000      ;           ":"
          .BYTE $0000,$3000,$3018,$0000,$0000,$3018,$3018,$6030      ;           ";"
          .BYTE $180E,$3018,$6030,$C060,$6030,$3018,$180E,$0000      ;           "<"
          .BYTE $0000,$0000,$FC7E,$0000,$FC7E,$0000,$0000,$0000      ;           "="
          .BYTE $6070,$3018,$180C,$0C06,$180C,$3018,$6070,$0000      ;           ">"
          .BYTE $783C,$CC66,$0C06,$180C,$3018,$0000,$3018,$0000      ;           "?"
          .BYTE $7C3C,$C666,$DE6E,$DE6E,$DE60,$C062,$783C,$0000      ;           "@"
          .BYTE $3018,$783C,$CC66,$CC7E,$FC66,$CC66,$CC66,$0000      ;Char $41   "A"
          .BYTE $FC7C,$6666,$6666,$7C7C,$6666,$6666,$FC7C,$0000      ;           "B"
          .BYTE $3C3C,$6666,$C060,$C060,$C060,$6666,$3C3C,$0000      ;           "C"
          .BYTE $F878,$6C6C,$6666,$6666,$6666,$6C6C,$F878,$0000      ;           "D"
          .BYTE $FE7E,$6260,$6860,$7878,$6860,$6260,$FE7E,$0000      ;           "E"
          .BYTE $FE7E,$6260,$6860,$7878,$6860,$6060,$F060,$0000      ;           "F"
          .BYTE $3C3C,$6666,$C060,$C06E,$CE66,$6666,$3E3C,$0000      ;           "G"
          .BYTE $CC66,$CC66,$CC66,$FC7E,$CC66,$CC66,$CC66,$0000      ;           "H"
          .BYTE $783C,$3018,$3018,$3018,$3018,$3018,$783C,$0000      ;           "I"
          .BYTE $1E1E,$0C0C,$0C0C,$0C0C,$CC0C,$CC6C,$7838,$0000      ;           "J"
          .BYTE $E666,$666C,$6C78,$7870,$6C78,$666C,$E666,$0000      ;           "K"
          .BYTE $F060,$6060,$6060,$6060,$6260,$6660,$FE7E,$0000      ;           "L"
          .BYTE $C663,$EE77,$FE7F,$FE6B,$D663,$C663,$C663,$0000      ;           "M"
          .BYTE $C666,$E676,$F67E,$DE7E,$CE6E,$C666,$C666,$0000      ;           "N"
          .BYTE $383C,$6C66,$C666,$C666,$C666,$6C66,$383C,$0000      ;           "O"
          .BYTE $FC7C,$6666,$6666,$7C7C,$6060,$6060,$F060,$0000      ;           "P"
          .BYTE $783C,$CC66,$CC66,$CC66,$DC66,$783C,$1C0E,$0000      ;           "Q"
          .BYTE $FC7C,$6666,$6666,$7C7C,$6C78,$666C,$E666,$0000      ;           "R"
          .BYTE $783C,$CC66,$E060,$703C,$1C06,$CC66,$783C,$0000      ;           "S"
          .BYTE $FC7E,$B418,$3018,$3018,$3018,$3018,$7818,$0000      ;           "T"
          .BYTE $CC66,$CC66,$CC66,$CC66,$CC66,$CC66,$FC3C,$0000      ;           "U"
          .BYTE $CC66,$CC66,$CC66,$CC66,$CC66,$783C,$3018,$0000      ;           "V"
          .BYTE $C663,$C663,$C663,$D66B,$FE7F,$EE77,$C663,$0000      ;           "W"
          .BYTE $C666,$C666,$6C3C,$3818,$383C,$6C66,$C666,$0000      ;           "X"
          .BYTE $CC66,$CC66,$CC66,$783C,$3018,$3018,$7818,$0000      ;           "Y"
          .BYTE $FE7E,$C606,$8C0C,$1818,$3230,$6660,$FE7E,$0000      ;Char $5A   "Z"
          .BYTE $783C,$6030,$6030,$6030,$6030,$6030,$783C,$0000      ;           "["
          .BYTE $C000,$6060,$3030,$1818,$0C0C,$0606,$0203,$0000      ;           "\"     
          .BYTE $783C,$180C,$180C,$180C,$180C,$180C,$783C,$0000      ;           "]"
          .BYTE $1010,$3838,$6C6C,$C6C6,$0000,$0000,$0000,$0000      ;           "^"       
          .BYTE $0000,$0000,$0000,$0000,$0000,$0000,$0000,$FFFF      ;Char $5F   "_"       
          .BYTE $3030,$3030,$1818,$0000,$0000,$0000,$0000,$0000      ;Char $60   "'"       
          .BYTE $0000,$0000,$783C,$0C06,$7C3E,$CC66,$763E,$0000      ;Char $61   "a"
          .BYTE $E000,$6060,$6060,$7C7C,$6666,$6666,$DC7C,$0000      ;           "b"
          .BYTE $0000,$0000,$783C,$CC60,$C060,$CC60,$783C,$0000      ;           "c"
          .BYTE $1C00,$0C06,$0C06,$7C3E,$CC66,$CC66,$763E,$0000      ;           "d"
          .BYTE $0000,$0000,$783C,$CC66,$FC7E,$C060,$783C,$0000      ;           "e"
          .BYTE $3800,$6C0E,$6018,$F03E,$6018,$6018,$F018,$0000      ;           "f"
          .BYTE $0000,$0000,$763E,$CC66,$CC66,$7C3E,$0C06,$F87C      ;           "g"
          .BYTE $E000,$6060,$6C60,$767C,$6666,$6666,$E666,$0000      ;           "h"
          .BYTE $3000,$0018,$7000,$3038,$3018,$3018,$783C,$0000      ;           "i"
          .BYTE $0C00,$0006,$0C00,$0C06,$0C06,$CC06,$CC06,$783C      ;           "j"
          .BYTE $E000,$6060,$6660,$6C6C,$7878,$6C6C,$E666,$0000      ;           "k"
          .BYTE $7000,$3038,$3018,$3018,$3018,$3018,$783C,$0000      ;           "l"
          .BYTE $0000,$0000,$CC66,$FE7F,$FE7F,$D66B,$C663,$0000      ;           "m"
          .BYTE $0000,$0000,$F87C,$CC66,$CC66,$CC66,$CC66,$0000      ;           "n"
          .BYTE $0000,$0000,$783C,$CC66,$CC66,$CC66,$783C,$0000      ;           "o"
          .BYTE $0000,$0000,$DC7C,$6666,$6666,$7C7C,$6060,$F060      ;           "p"
          .BYTE $0000,$0000,$763E,$CC66,$CC66,$7C3E,$0C06,$1E06      ;           "q"
          .BYTE $0000,$0000,$DC7C,$7666,$6660,$6060,$F060,$0000      ;           "r"
          .BYTE $0000,$0000,$7C3E,$C060,$783C,$0C06,$F87C,$0000      ;           "s"
          .BYTE $1000,$3018,$7C7E,$3018,$3018,$3418,$180E,$0000      ;           "t"
          .BYTE $0000,$0000,$CC66,$CC66,$CC66,$CC66,$763E,$0000      ;           "u"
          .BYTE $0000,$0000,$CC66,$CC66,$CC66,$783C,$3018,$0000      ;           "v"
          .BYTE $0000,$0000,$C663,$D66B,$FE7F,$FE3E,$6C36,$0000      ;           "w"
          .BYTE $0000,$0000,$C666,$6C3C,$3818,$6C3C,$C666,$0000      ;           "x"
          .BYTE $0000,$0000,$CC66,$CC66,$CC66,$7C3E,$0C0C,$F878      ;           "y"
          .BYTE $0000,$0000,$FC7E,$980C,$3018,$6430,$FC7E,$0000      ;Char $7A   "z"
          .BYTE $1C3C,$3030,$3030,$E030,$3030,$3030,$1C3C,$0000      ;           "{" error same as $5b
          .BYTE $180C,$1812,$1830,$007C,$1830,$1862,$18FC,$0000      ;           "|" error same as $5c
          .BYTE $E03C,$300C,$300C,$1C0C,$300C,$300C,$E03C,$0000      ;           "}" error same as $5d
          .BYTE $7600,$DC18,$003C,$007E,$0018,$0018,$0018,$0018      ;
          .BYTE $FEFE,$FEFE,$FEFE,$FEFE,$FEFE,$FEFE,$FEFE,$FEFE      ;           "CURSOR"

          ;.BYTE $0E,$11,$01,$0D,$15,$15,$0E,$00      
          ;.BYTE $04,$0A,$11,$11,$1F,$11,$11,$00
          ;.BYTE $1E,$09,$09,$0E,$09,$09,$1E,$00
          ;.BYTE $0E,$11,$10,$10,$10,$11,$0E,$00
          ;.BYTE $1E,$0A,$0A,$0A,$0A,$0A,$1E,$00
          ;.BYTE $1F,$10,$10,$1C,$10,$10,$1F,$00
          ;.BYTE $1F,$10,$10,$1C,$10,$10,$10,$00
          ;.BYTE $0E,$11,$10,$17,$11,$11,$0E,$00
          ;.BYTE $11,$11,$11,$1F,$11,$11,$11,$00
          ;.BYTE $0E,$04,$04,$04,$04,$04,$0E,$00
          ;.BYTE $07,$02,$02,$02,$02,$12,$0C,$00
          ;.BYTE $11,$12,$14,$18,$14,$12,$11,$00
          ;.BYTE $10,$10,$10,$10,$10,$10,$1F,$00
          ;.BYTE $11,$1B,$15,$15,$11,$11,$11,$00
          ;.BYTE $11,$19,$15,$13,$11,$11,$11,$00
          ;.BYTE $0E,$11,$11,$11,$11,$11,$0E,$00
          
                                   ;FFFFCD00  3X5 Custom Character Pixel Data
          
          .BYTE $5468,$6973,$2069,$7320,$6120,$5445,$5354,$2053
          .BYTE $5452,$494E,$472E,$00,$40,$00,$00,$00
          .BYTE $A0,$A0,$00,$00,$00,$00,$00,$00
          .BYTE $00,$FF,$00,$FF,$00,$FF,$00,$FF
          .BYTE $FF,$00,$FF,$00,$FF,$00,$FF,$00
          .BYTE $00,$FF,$00,$FF,$00,$FF,$00,$FF
          .BYTE $FF,$00,$FF,$00,$FF,$00,$FF,$00
          .BYTE $40,$80,$00,$00,$00,$00,$00,$00
          .BYTE $40,$80,$80,$80,$40,$00,$00,$00
          .BYTE $40,$20,$20,$20,$40,$00,$00,$00
          .BYTE $00,$A0,$40,$A0,$00,$00,$00,$00
          .BYTE $00,$40,$E0,$40,$00,$00,$00,$00
          .BYTE $00,$00,$00,$40,$80,$00,$00,$00
          .BYTE $00,$00,$E0,$00,$00,$00,$00,$00
          .BYTE $00,$00,$00,$00,$40,$00,$00,$00
          .BYTE $20,$20,$40,$80,$80,$00,$00,$00
          .BYTE $E0,$A0,$A0,$A0,$E0,$00,$00,$00
          .BYTE $40,$C0,$40,$40,$E0,$00,$00,$00
          .BYTE $E0,$20,$E0,$80,$E0,$00,$00,$00
          .BYTE $E0,$20,$E0,$20,$E0,$00,$00,$00
          .BYTE $A0,$A0,$E0,$20,$20,$00,$00,$00
          .BYTE $E0,$80,$E0,$20,$E0,$00,$00,$00
          .BYTE $80,$80,$E0,$A0,$E0,$00,$00,$00
          .BYTE $E0,$20,$20,$20,$20,$00,$00,$00
          .BYTE $E0,$A0,$E0,$A0,$E0,$00,$00,$00
          .BYTE $E0,$A0,$E0,$20,$20,$00,$00,$00
          .BYTE $00,$40,$00,$40,$00,$00,$00,$00
          .BYTE $40,$00,$40,$80,$00,$00,$00,$00
          .BYTE $20,$40,$80,$40,$20,$00,$00,$00
          .BYTE $00,$E0,$00,$E0,$00,$00,$00,$00
          .BYTE $80,$40,$20,$40,$80,$00,$00,$00
          .BYTE $E0,$20,$60,$00,$40,$00,$00,$00
          .BYTE $40,$A0,$C0,$80,$60,$00,$00,$00
          .BYTE $40,$A0,$E0,$A0,$A0,$00,$00,$00
          .BYTE $C0,$A0,$C0,$A0,$C0,$00,$00,$00
          .BYTE $40,$A0,$80,$A0,$40,$00,$00,$00
          .BYTE $C0,$A0,$A0,$A0,$C0,$00,$00,$00
          .BYTE $E0,$80,$C0,$80,$E0,$00,$00,$00
          .BYTE $E0,$80,$C0,$80,$80,$00,$00,$00
          .BYTE $40,$80,$A0,$A0,$40,$00,$00,$00
          .BYTE $A0,$A0,$E0,$A0,$A0,$00,$00,$00
          .BYTE $E0,$40,$40,$40,$E0,$00,$00,$00
          .BYTE $20,$20,$20,$A0,$40,$00,$00,$00
          .BYTE $E0,$C0,$80,$C0,$E0,$00,$00,$00
          .BYTE $80,$80,$80,$80,$E0,$00,$00,$00
          .BYTE $A0,$C0,$C0,$A0,$A0,$00,$00,$00
          .BYTE $A0,$A0,$E0,$E0,$A0,$00,$00,$00
          .BYTE $40,$A0,$A0,$A0,$40,$00,$00,$00
          .BYTE $C0,$A0,$C0,$80,$80,$00,$00,$00
          .BYTE $40,$A0,$A0,$E0,$40,$00,$00,$00
          .BYTE $E0,$A0,$E0,$C0,$A0,$00,$00,$00
          .BYTE $60,$80,$40,$20,$C0,$00,$00,$00
          .BYTE $E0,$40,$40,$40,$40,$00,$00,$00
          .BYTE $A0,$A0,$A0,$A0,$E0,$00,$00,$00
          .BYTE $A0,$A0,$A0,$40,$40,$00,$00,$00
          .BYTE $A0,$A0,$E0,$E0,$A0,$00,$00,$00
          .BYTE $A0,$A0,$40,$A0,$A0,$00,$00,$00
          .BYTE $A0,$A0,$40,$40,$40,$00,$00,$00
          .BYTE $E0,$20,$40,$80,$E0,$00,$00,$00
          .BYTE $E0,$80,$80,$80,$E0,$00,$00,$00
          .BYTE $FF,$00,$FF,$00,$FF,$00,$FF,$00
          .BYTE $E0,$20,$20,$20,$E0,$00,$00,$00
          .BYTE $FF,$00,$FF,$00,$FF,$00,$FF,$00
          .BYTE $FF,$00,$FF,$00,$FF,$00,$FF,$00
          .BYTE $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
          .BYTE $40,$A0,$E0,$A0,$A0,$00,$00,$00
          .BYTE $C0,$A0,$C0,$A0,$C0,$00,$00,$00
          .BYTE $40,$A0,$80,$A0,$40,$00,$00,$00
          .BYTE $C0,$A0,$A0,$A0,$C0,$00,$00,$00
          .BYTE $E0,$80,$C0,$80,$E0,$00,$00,$00
          .BYTE $E0,$80,$C0,$80,$80,$00,$00,$00
          .BYTE $40,$80,$A0,$A0,$40,$00,$00,$00
          .BYTE $A0,$A0,$E0,$A0,$A0,$00,$00,$00
          .BYTE $E0,$40,$40,$40,$E0,$00,$00,$00
          .BYTE $20,$20,$20,$A0,$40,$00,$00,$00
          .BYTE $E0,$C0,$80,$C0,$E0,$00,$00,$00
          .BYTE $80,$80,$80,$80,$E0,$00,$00,$00
          .BYTE $A0,$C0,$C0,$A0,$A0,$00,$00,$00
          .BYTE $A0,$A0,$E0,$E0,$A0,$00,$00,$00
          .BYTE $40,$A0,$A0,$A0,$40,$00,$00,$00
          .BYTE $C0,$A0,$C0,$80,$80,$00,$00,$00
          .BYTE $40,$A0,$A0,$E0,$40,$00,$00,$00
          .BYTE $E0,$A0,$E0,$C0,$A0,$00,$00,$00
          .BYTE $60,$80,$40,$20,$C0,$00,$00,$00
          .BYTE $E0,$40,$40,$40,$40,$00,$00,$00
          .BYTE $A0,$A0,$A0,$A0,$E0,$00,$00,$00
          .BYTE $A0,$A0,$A0,$40,$40,$00,$00,$00
          .BYTE $A0,$A0,$E0,$E0,$A0,$00,$00,$00
          .BYTE $A0,$A0,$40,$A0,$A0,$00,$00,$00
          .BYTE $A0,$A0,$40,$40,$40,$00,$00,$00
          .BYTE $E0,$20,$40,$80,$E0,$00,$00,$00
          .BYTE $E0,$80,$80,$80,$E0,$00,$00,$00
          .BYTE $FF,$00,$FF,$00,$FF,$00,$FF,$00
          .BYTE $E0,$20,$20,$20,$E0,$00,$00,$00
          .BYTE $FF,$00,$FF,$00,$FF,$00,$FF,$00
          .BYTE $FF,$00,$FF,$00,$FF,$00,$FF,$00

		.ORG	$FFFFFFFA
		
		.WORD	START
		.WORD	START
		.WORD	START
		
		.END
