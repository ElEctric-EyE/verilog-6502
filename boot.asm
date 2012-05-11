	.CODE
  .ORG	$FFFFC000
	
;zero-page variables
XPOS 		    =$00
YPOS			  =$01
ATTBUT      =$02
KEYBUFF     =$03              
COUNTER     =$04
FONT        =$05

ADRESS      =$06
NUMBER      =$08
STBUF       =$10
AREG        =$22
PREG        =$23
SREG        =$24
XREG        =$25
YREG        =$26


I2Caddr     =$0A
addr        =$0B
val         =$0C
data        =$0D
              
BxL				  =$1A
BxH				  =$1B
BxL2			  =$1C
BxH2			  =$1D
ByL				  =$1E
ByH				  =$1F
ByL2			  =$20
ByH2			  =$21

CHRBASE     =$E1
CHR				  =$E2
SENTINEL		=$E3
PATROW		  =$E9
PIXROW		  =$EA
CHRXLEN     =$E5
CHRYLEN		  =$E6
XWIDTH		  =$E7
YWIDTH		  =$E8
CHRYLENFIN  =$E9

TMPCOL1		  =$F7
TMPCOL2		  =$F8
TMPCOL3		  =$F9
PXLCOL1		  =$FA
PXLCOL2		  =$FB
PXLCOL3		  =$FC
SCRCOL1		  =$FD
SCRCOL2		  =$FE
SCRCOL3		  =$FF

;I/O Registers

I2CREG		  =$FFFF0000	      
KBDAT		    =$FFFF0008        ;8-bit Keyboard data
KBSTAT  	  =$FFFF0009        ;8-bit Keyboard status register
SPI1			  =$FFFF000A
SPI2			  =$FFFF000B
SPI3			  =$FFFF000C
SPI4			  =$FFFF000D
UARTDREG	  =$FFFF000E
UARTSREG	  =$FFFF000F
DCOM			  =$FFFF0010	      ;display command
DDAT			  =$FFFF0011	      ;display data
RNG         =$FFFF0017

;internal memory
HEXDIGIT  	=$FFFFC8F0        ;0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F in ascii 	
KEYTABLE		=$FFFFC900        ;keyboard lookup table		         		
COLTABLE		=$FFFFC980        ;4-bit color table					
CHARPIX     =$FFFF0000

; NEW 65O16 OPCODES!   4/24/2012
;LDAi                    $00A9
LDBi              .MACRO          ;LDB #$xxxx
                  .BYTE $01A9
                  .ENDM
LDCi              .MACRO          ;LDC #$xxxx
                  .BYTE $02A9
                  .ENDM
LDDi              .MACRO          ;LDD #$xxxx
                  .BYTE $03A9
                  .ENDM
LDEi              .MACRO          ;LDE #$xxxx
                  .BYTE $10A9
                  .ENDM
LDFi              .MACRO          ;LDF #$xxxx
                  .BYTE $11A9
                  .ENDM
LDGi              .MACRO          ;LDG #$xxxx
                  .BYTE $12A9
                  .ENDM
LDHi              .MACRO          ;LDH #$xxxx
                  .BYTE $13A9
                  .ENDM
LDIi              .MACRO          ;LDI #$xxxx
                  .BYTE $20A9
                  .ENDM
LDJi              .MACRO          ;LDJ #$xxxx
                  .BYTE $21A9
                  .ENDM
LDKi              .MACRO          ;LDK #$xxxx
                  .BYTE $22A9
                  .ENDM
LDLi              .MACRO          ;LDL #$xxxx
                  .BYTE $23A9
                  .ENDM
LDMi              .MACRO          ;LDM #$xxxx
                  .BYTE $30A9
                  .ENDM
LDNi              .MACRO          ;LDN #$xxxx
                  .BYTE $31A9
                  .ENDM
LDOi              .MACRO          ;LDO #$xxxx
                  .BYTE $32A9
                  .ENDM
LDQi              .MACRO          ;LDQ #$xxxx
                  .BYTE $33A9
                  .ENDM
LDWi              .MACRO
                  .BYTE $00C2
                  .ENDM
                  
;STAzp                    $0085
STBzp             .MACRO          ;STB #$xxxx
                  .BYTE $0185
                  .ENDM
STCzp             .MACRO          ;STC #$xxxx
                  .BYTE $0285
                  .ENDM
STDzp             .MACRO          ;STD #$xxxx
                  .BYTE $0385
                  .ENDM
STEzp             .MACRO          ;STE #$xxxx
                  .BYTE $1085
                  .ENDM
STFzp             .MACRO          ;STF #$xxxx
                  .BYTE $1185
                  .ENDM
STGzp             .MACRO          ;STG #$xxxx
                  .BYTE $1285
                  .ENDM
STHzp             .MACRO          ;STH #$xxxx
                  .BYTE $1385
                  .ENDM
STIzp             .MACRO           ;STI #$xxxx
                  .BYTE $2085
                  .ENDM
STJzp             .MACRO          ;STJ #$xxxx
                  .BYTE $2185
                  .ENDM
STKzp             .MACRO          ;STK #$xxxx
                  .BYTE $2285
                  .ENDM
STLzp             .MACRO          ;STL #$xxxx
                  .BYTE $2385
                  .ENDM
STMzp             .MACRO          ;STM #$xxxx
                  .BYTE $3085
                  .ENDM
STNzp             .MACRO          ;STN #$xxxx
                  .BYTE $3185
                  .ENDM
STOzp             .MACRO          ;STO #$xxxx
                  .BYTE $3285
                  .ENDM
STQzp             .MACRO          ;STQ #$xxxx
                  .BYTE $3385
                  .ENDM
STWzp             .MACRO
                  .BYTE $0087
                  .ENDM


                  
;LDA $xxxxxxxx          $00AD
LDBa              .MACRO          ;LDB $xxxxxxxx
                  .BYTE $01AD
                  .ENDM
LDCa              .MACRO          ;LDC $xxxxxxxx
                  .BYTE $02AD
                  .ENDM
LDDa              .MACRO          ;LDD $xxxxxxxx
                  .BYTE $03AD
                  .ENDM
LDEa              .MACRO          ;LDE $xxxxxxxx
                  .BYTE $10AD
                  .ENDM
LDFa              .MACRO          ;LDF $xxxxxxxx
                  .BYTE $11AD
                  .ENDM
LDGa              .MACRO          ;LDG $xxxxxxxx
                  .BYTE $12AD
                  .ENDM
LDHa              .MACRO          ;LDH $xxxxxxxx
                  .BYTE $13AD
                  .ENDM
LDIa              .MACRO          ;LDI $xxxxxxxx
                  .BYTE $20AD
                  .ENDM
LDJa              .MACRO          ;LDJ $xxxxxxxx
                  .BYTE $21AD
                  .ENDM
LDKa              .MACRO          ;LDK $xxxxxxxx
                  .BYTE $22AD
                  .ENDM
LDLa              .MACRO          ;LDL $xxxxxxxx
                  .BYTE $23AD
                  .ENDM
LDMa              .MACRO          ;LDM $xxxxxxxx
                  .BYTE $30AD
                  .ENDM
LDNa              .MACRO          ;LDN $xxxxxxxx
                  .BYTE $31AD
                  .ENDM
LDOa              .MACRO          ;LDO $xxxxxxxx
                  .BYTE $32AD
                  .ENDM
LDQa              .MACRO          ;LDQ $xxxxxxxx
                  .BYTE $33AD
                  .ENDM
LDWa              .MACRO
                  .BYTE $00AF
                  .ENDM

;STAa                   $008D                  
STBa              .MACRO          ;STB $xxxxxxxx
                  .BYTE $048D
                  .ENDM
STCa              .MACRO          ;STC $xxxxxxxx
                  .BYTE $088D
                  .ENDM
STDa              .MACRO          ;STD $xxxxxxxx
                  .BYTE $0C8D
                  .ENDM
STEa              .MACRO          ;STE $xxxxxxxx
                  .BYTE $408D
                  .ENDM
STFa              .MACRO          ;STF $xxxxxxxx
                  .BYTE $448D
                  .ENDM
STGa              .MACRO          ;STG $xxxxxxxx
                  .BYTE $488D
                  .ENDM
STHa              .MACRO          ;STH $xxxxxxxx
                  .BYTE $4C8D
                  .ENDM
STIa              .MACRO          ;STI $xxxxxxxx
                  .BYTE $808D
                  .ENDM
STJa              .MACRO          ;STJ $xxxxxxxx
                  .BYTE $848D
                  .ENDM
STKa              .MACRO          ;STK $xxxxxxxx
                  .BYTE $888D
                  .ENDM
STLa              .MACRO          ;STL $xxxxxxxx
                  .BYTE $8C8D
                  .ENDM
STMa              .MACRO          ;STM $xxxxxxxx
                  .BYTE $C08D
                  .ENDM
STNa              .MACRO          ;STN $xxxxxxxx
                  .BYTE $C48D
                  .ENDM
STOa              .MACRO          ;STO $xxxxxxxx
                  .BYTE $C88D
                  .ENDM
STQa              .MACRO          ;STQ $xxxxxxxx
                  .BYTE $CC8D
                  .ENDM
STWa              .MACRO
                  .BYTE $008F
                  .ENDM

;CMPAi                  $00C9                  
CMPBi             .MACRO          ;CMPB #$xxxx
                  .BYTE $04C9
                  .ENDM
CMPCi             .MACRO          ;CMPC #$xxxx
                  .BYTE $08C9
                  .ENDM
CMPDi             .MACRO          ;CMPD #$xxxx
                  .BYTE $0CC9
                  .ENDM
CMPEi             .MACRO          ;CMPE #$xxxx
                  .BYTE $40C9
                  .ENDM
CMPFi             .MACRO          ;CMPF #$xxxx
                  .BYTE $44C9
                  .ENDM
CMPGi             .MACRO          ;CMPG #$xxxx
                  .BYTE $48C9
                  .ENDM
CMPHi             .MACRO          ;CMPH #$xxxx
                  .BYTE $4CC9
                  .ENDM
CMPIi             .MACRO          ;CMPI #$xxxx
                  .BYTE $80C9
                  .ENDM
CMPJi             .MACRO          ;CMPJ #$xxxx
                  .BYTE $84C9
                  .ENDM
CMPKi             .MACRO          ;CMPK #$xxxx
                  .BYTE $88C9
                  .ENDM
CMPLi             .MACRO          ;CMPL #$xxxx
                  .BYTE $8CC9
                  .ENDM
CMPMi             .MACRO          ;CMPM #$xxxx
                  .BYTE $C0C9
                  .ENDM
CMPNi             .MACRO          ;CMPN #$xxxx
                  .BYTE $C4C9
                  .ENDM
CMPOi             .MACRO          ;CMPO #$xxxx
                  .BYTE $C8C9
                  .ENDM
CMPQi             .MACRO          ;CMPQ #$xxxx
                  .BYTE $CCC9
                  .ENDM
CMPWi             .MACRO
                  .BYTE $00E2
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
                  
;ADC #$                 $0069
ADCAopBi          .MACRO          
                  .BYTE $0469
                  .ENDM
ADCAopCi          .MACRO
                  .BYTE $0869
                  .ENDM
ADCAopDi          .MACRO
                  .BYTE $0C69
                  .ENDM
ADCAopEi          .MACRO          
                  .BYTE $4069
                  .ENDM
ADCAopFi          .MACRO
                  .BYTE $4469
                  .ENDM
ADCAopGi          .MACRO
                  .BYTE $4869
                  .ENDM                  
ADCAopHi          .MACRO          
                  .BYTE $4C69
                  .ENDM
ADCAopIi          .MACRO
                  .BYTE $8069
                  .ENDM
ADCAopJi          .MACRO
                  .BYTE $8469
                  .ENDM
ADCAopKi          .MACRO          
                  .BYTE $8869
                  .ENDM
ADCAopLi          .MACRO
                  .BYTE $8C69
                  .ENDM
ADCAopMi          .MACRO
                  .BYTE $C069
                  .ENDM                  
ADCAopNi          .MACRO          
                  .BYTE $C469
                  .ENDM
ADCAopOi          .MACRO
                  .BYTE $C869
                  .ENDM
ADCAopQi          .MACRO
                  .BYTE $CC69
                  .ENDM
                                    
ADCBopAi          .MACRO
                  .BYTE $0169
                  .ENDM                
ADCBopBi          .MACRO          
                  .BYTE $0569
                  .ENDM
ADCBopCi          .MACRO
                  .BYTE $0969
                  .ENDM
ADCBopDi          .MACRO
                  .BYTE $0D69
                  .ENDM
ADCBopEi          .MACRO          
                  .BYTE $4169
                  .ENDM
ADCBopFi          .MACRO
                  .BYTE $4569
                  .ENDM
ADCBopGi          .MACRO
                  .BYTE $4969
                  .ENDM                  
ADCBopHi          .MACRO          
                  .BYTE $4D69
                  .ENDM
ADCBopIi          .MACRO
                  .BYTE $8169
                  .ENDM
ADCBopJi          .MACRO
                  .BYTE $8569
                  .ENDM
ADCBopKi          .MACRO          
                  .BYTE $8969
                  .ENDM
ADCBopLi          .MACRO
                  .BYTE $8D69
                  .ENDM
ADCBopMi          .MACRO
                  .BYTE $C169
                  .ENDM                  
ADCBopNi          .MACRO          
                  .BYTE $C569
                  .ENDM
ADCBopOi          .MACRO
                  .BYTE $C969
                  .ENDM
ADCBopQi          .MACRO
                  .BYTE $CD69
                  .ENDM
                                    
ADCCopAi          .MACRO
                  .BYTE $0269
                  .ENDM                
ADCCopBi          .MACRO          
                  .BYTE $0669
                  .ENDM
ADCCopCi          .MACRO
                  .BYTE $0A69
                  .ENDM
ADCCopDi          .MACRO
                  .BYTE $0E69
                  .ENDM
ADCCopEi          .MACRO          
                  .BYTE $4269
                  .ENDM
ADCCopFi          .MACRO
                  .BYTE $4669
                  .ENDM
ADCCopGi          .MACRO
                  .BYTE $4A69
                  .ENDM                  
ADCCopHi          .MACRO          
                  .BYTE $4E69
                  .ENDM
ADCCopIi          .MACRO
                  .BYTE $8269
                  .ENDM
ADCCopJi          .MACRO
                  .BYTE $8669
                  .ENDM
ADCCopKi          .MACRO          
                  .BYTE $8A69
                  .ENDM
ADCCopLi          .MACRO
                  .BYTE $8E69
                  .ENDM
ADCCopMi          .MACRO
                  .BYTE $C269
                  .ENDM                  
ADCCopNi          .MACRO          
                  .BYTE $C669
                  .ENDM
ADCCopOi          .MACRO
                  .BYTE $CA69
                  .ENDM
ADCCopQi          .MACRO
                  .BYTE $CE69
                  .ENDM

ADCDopAi          .MACRO
                  .BYTE $0369
                  .ENDM                
ADCDopBi          .MACRO          
                  .BYTE $0769
                  .ENDM
ADCDopCi          .MACRO
                  .BYTE $0B69
                  .ENDM
ADCDopDi          .MACRO
                  .BYTE $0F69
                  .ENDM
ADCDopEi          .MACRO          
                  .BYTE $4369
                  .ENDM
ADCDopFi          .MACRO
                  .BYTE $4769
                  .ENDM
ADCDopGi          .MACRO
                  .BYTE $4B69
                  .ENDM                  
ADCDopHi          .MACRO          
                  .BYTE $4F69
                  .ENDM
ADCDopIi          .MACRO
                  .BYTE $8369
                  .ENDM
ADCDopJi          .MACRO
                  .BYTE $8769
                  .ENDM
ADCDopKi          .MACRO          
                  .BYTE $8B69
                  .ENDM
ADCDopLi          .MACRO
                  .BYTE $8F69
                  .ENDM
ADCDopMi          .MACRO
                  .BYTE $C369
                  .ENDM                  
ADCDopNi          .MACRO          
                  .BYTE $C769
                  .ENDM
ADCDopOi          .MACRO
                  .BYTE $CB69
                  .ENDM
ADCDopQi          .MACRO
                  .BYTE $CF69
                  .ENDM                  

ADCEopAi          .MACRO
                  .BYTE $1069
                  .ENDM                
ADCEopBi          .MACRO          
                  .BYTE $1469
                  .ENDM
ADCEopCi          .MACRO
                  .BYTE $1869
                  .ENDM
ADCEopDi          .MACRO
                  .BYTE $1C69
                  .ENDM
ADCEopEi          .MACRO          
                  .BYTE $5069
                  .ENDM
ADCEopFi          .MACRO
                  .BYTE $5469
                  .ENDM
ADCEopGi          .MACRO
                  .BYTE $5869
                  .ENDM                  
ADCEopHi          .MACRO          
                  .BYTE $5C69
                  .ENDM
ADCEopIi          .MACRO
                  .BYTE $9069
                  .ENDM
ADCEopJi          .MACRO
                  .BYTE $9469
                  .ENDM
ADCEopKi          .MACRO          
                  .BYTE $9869
                  .ENDM
ADCEopLi          .MACRO
                  .BYTE $9C69
                  .ENDM
ADCEopMi          .MACRO
                  .BYTE $D069
                  .ENDM                  
ADCEopNi          .MACRO          
                  .BYTE $D469
                  .ENDM
ADCEopOi          .MACRO
                  .BYTE $D869
                  .ENDM
ADCEopQi          .MACRO
                  .BYTE $DC69
                  .ENDM
                  
ADCFopAi          .MACRO
                  .BYTE $1169
                  .ENDM                
ADCFopBi          .MACRO          
                  .BYTE $1569
                  .ENDM
ADCFopCi          .MACRO
                  .BYTE $1969
                  .ENDM
ADCFopDi          .MACRO
                  .BYTE $1D69
                  .ENDM
ADCFopEi          .MACRO          
                  .BYTE $5169
                  .ENDM
ADCFopFi          .MACRO
                  .BYTE $5569
                  .ENDM
ADCFopGi          .MACRO
                  .BYTE $5969
                  .ENDM                  
ADCFopHi          .MACRO          
                  .BYTE $5D69
                  .ENDM
ADCFopIi          .MACRO
                  .BYTE $9169
                  .ENDM
ADCFopJi          .MACRO
                  .BYTE $9569
                  .ENDM
ADCFopKi          .MACRO          
                  .BYTE $9969
                  .ENDM
ADCFopLi          .MACRO
                  .BYTE $9D69
                  .ENDM
ADCFopMi          .MACRO
                  .BYTE $D169
                  .ENDM                  
ADCFopNi          .MACRO          
                  .BYTE $D569
                  .ENDM
ADCFopOi          .MACRO
                  .BYTE $D969
                  .ENDM
ADCFopQi          .MACRO
                  .BYTE $DD69
                  .ENDM                  
                           
ADCGopAi          .MACRO
                  .BYTE $1269
                  .ENDM                
ADCGopBi          .MACRO          
                  .BYTE $1669
                  .ENDM
ADCGopCi          .MACRO
                  .BYTE $1A69
                  .ENDM
ADCGopDi          .MACRO
                  .BYTE $1E69
                  .ENDM
ADCGopEi          .MACRO          
                  .BYTE $5269
                  .ENDM
ADCGopFi          .MACRO
                  .BYTE $5669
                  .ENDM
ADCGopGi          .MACRO
                  .BYTE $5A69
                  .ENDM                  
ADCGopHi          .MACRO          
                  .BYTE $5E69
                  .ENDM
ADCGopIi          .MACRO
                  .BYTE $9269
                  .ENDM
ADCGopJi          .MACRO
                  .BYTE $9669
                  .ENDM
ADCGopKi          .MACRO          
                  .BYTE $9A69
                  .ENDM
ADCGopLi          .MACRO
                  .BYTE $9E69
                  .ENDM
ADCGopMi          .MACRO
                  .BYTE $D269
                  .ENDM                  
ADCGopNi          .MACRO          
                  .BYTE $D669
                  .ENDM
ADCGopOi          .MACRO
                  .BYTE $DA69
                  .ENDM
ADCGopQi          .MACRO
                  .BYTE $DE69
                  .ENDM
                  
ADCHopAi          .MACRO
                  .BYTE $1369
                  .ENDM                
ADCHopBi          .MACRO          
                  .BYTE $1769
                  .ENDM
ADCHopCi          .MACRO
                  .BYTE $1B69
                  .ENDM
ADCHopDi          .MACRO
                  .BYTE $1F69
                  .ENDM
ADCHopEi          .MACRO          
                  .BYTE $5369
                  .ENDM
ADCHopFi          .MACRO
                  .BYTE $5769
                  .ENDM
ADCHopGi          .MACRO
                  .BYTE $5B69
                  .ENDM                  
ADCHopHi          .MACRO          
                  .BYTE $5F69
                  .ENDM
ADCHopIi          .MACRO
                  .BYTE $9369
                  .ENDM
ADCHopJi          .MACRO
                  .BYTE $9769
                  .ENDM
ADCHopKi          .MACRO          
                  .BYTE $9B69
                  .ENDM
ADCHopLi          .MACRO
                  .BYTE $9F69
                  .ENDM
ADCHopMi          .MACRO
                  .BYTE $D369
                  .ENDM                  
ADCHopNi          .MACRO          
                  .BYTE $D769
                  .ENDM
ADCHopOi          .MACRO
                  .BYTE $DB69
                  .ENDM
ADCHopQi          .MACRO
                  .BYTE $DF69
                  .ENDM
                  
ADCIopAi          .MACRO
                  .BYTE $2069
                  .ENDM                
ADCIopBi          .MACRO          
                  .BYTE $2469
                  .ENDM
ADCIopCi          .MACRO
                  .BYTE $2869
                  .ENDM
ADCIopDi          .MACRO
                  .BYTE $2C69
                  .ENDM
ADCIopEi          .MACRO          
                  .BYTE $6069
                  .ENDM
ADCIopFi          .MACRO
                  .BYTE $6469
                  .ENDM
ADCIopGi          .MACRO
                  .BYTE $6869
                  .ENDM                  
ADCIopHi          .MACRO          
                  .BYTE $6C69
                  .ENDM
ADCIopIi          .MACRO
                  .BYTE $A069
                  .ENDM
ADCIopJi          .MACRO
                  .BYTE $A469
                  .ENDM
ADCIopKi          .MACRO          
                  .BYTE $A869
                  .ENDM
ADCIopLi          .MACRO
                  .BYTE $AC69
                  .ENDM
ADCIopMi          .MACRO
                  .BYTE $E069
                  .ENDM                  
ADCIopNi          .MACRO          
                  .BYTE $E469
                  .ENDM
ADCIopOi          .MACRO
                  .BYTE $E869
                  .ENDM
ADCIopQi          .MACRO
                  .BYTE $EC69
                  .ENDM
                  
ADCJopAi          .MACRO
                  .BYTE $2169
                  .ENDM                
ADCJopBi          .MACRO          
                  .BYTE $2569
                  .ENDM
ADCJopCi          .MACRO
                  .BYTE $2969
                  .ENDM
ADCJopDi          .MACRO
                  .BYTE $2D69
                  .ENDM
ADCJopEi          .MACRO          
                  .BYTE $6169
                  .ENDM
ADCJopFi          .MACRO
                  .BYTE $6569
                  .ENDM
ADCJopGi          .MACRO
                  .BYTE $6969
                  .ENDM                  
ADCJopHi          .MACRO          
                  .BYTE $6D69
                  .ENDM
ADCJopIi          .MACRO
                  .BYTE $A169
                  .ENDM
ADCJopJi          .MACRO
                  .BYTE $A569
                  .ENDM
ADCJopKi          .MACRO          
                  .BYTE $A969
                  .ENDM
ADCJopLi          .MACRO
                  .BYTE $AD69
                  .ENDM
ADCJopMi          .MACRO
                  .BYTE $E169
                  .ENDM                  
ADCJopNi          .MACRO          
                  .BYTE $E569
                  .ENDM
ADCJopOi          .MACRO
                  .BYTE $E969
                  .ENDM
ADCJopQi          .MACRO
                  .BYTE $ED69
                  .ENDM
                  
ADCKopAi          .MACRO
                  .BYTE $2269
                  .ENDM                
ADCKopBi          .MACRO          
                  .BYTE $2669
                  .ENDM
ADCKopCi          .MACRO
                  .BYTE $2A69
                  .ENDM
ADCKopDi          .MACRO
                  .BYTE $2E69
                  .ENDM
ADCKopEi          .MACRO          
                  .BYTE $6269
                  .ENDM
ADCKopFi          .MACRO
                  .BYTE $6669
                  .ENDM
ADCKopGi          .MACRO
                  .BYTE $6A69
                  .ENDM                  
ADCKopHi          .MACRO          
                  .BYTE $6E69
                  .ENDM
ADCKopIi          .MACRO
                  .BYTE $A269
                  .ENDM
ADCKopJi          .MACRO
                  .BYTE $A669
                  .ENDM
ADCKopKi          .MACRO          
                  .BYTE $AA69
                  .ENDM
ADCKopLi          .MACRO
                  .BYTE $AE69
                  .ENDM
ADCKopMi          .MACRO
                  .BYTE $E269
                  .ENDM                  
ADCKopNi          .MACRO          
                  .BYTE $E669
                  .ENDM
ADCKopOi          .MACRO
                  .BYTE $EA69
                  .ENDM
ADCKopQi          .MACRO
                  .BYTE $EE69
                  .ENDM
                  
ADCLopAi          .MACRO
                  .BYTE $2369
                  .ENDM                
ADCLopBi          .MACRO          
                  .BYTE $2769
                  .ENDM
ADCLopCi          .MACRO
                  .BYTE $2B69
                  .ENDM
ADCLopDi          .MACRO
                  .BYTE $2F69
                  .ENDM
ADCLopEi          .MACRO          
                  .BYTE $6369
                  .ENDM
ADCLopFi          .MACRO
                  .BYTE $6769
                  .ENDM
ADCLopGi          .MACRO
                  .BYTE $6B69
                  .ENDM                  
ADCLopHi          .MACRO          
                  .BYTE $6F69
                  .ENDM
ADCLopIi          .MACRO
                  .BYTE $A369
                  .ENDM
ADCLopJi          .MACRO
                  .BYTE $A769
                  .ENDM
ADCLopKi          .MACRO          
                  .BYTE $AB69
                  .ENDM
ADCLopLi          .MACRO
                  .BYTE $AF69
                  .ENDM
ADCLopMi          .MACRO
                  .BYTE $E369
                  .ENDM                  
ADCLopNi          .MACRO          
                  .BYTE $E769
                  .ENDM
ADCLopOi          .MACRO
                  .BYTE $EB69
                  .ENDM
ADCLopQi          .MACRO
                  .BYTE $EF69
                  .ENDM
                  
ADCMopAi          .MACRO
                  .BYTE $3069
                  .ENDM                
ADCMopBi          .MACRO          
                  .BYTE $3469
                  .ENDM
ADCMopCi          .MACRO
                  .BYTE $3869
                  .ENDM
ADCMopDi          .MACRO
                  .BYTE $3C69
                  .ENDM
ADCMopEi          .MACRO          
                  .BYTE $7069
                  .ENDM
ADCMopFi          .MACRO
                  .BYTE $7469
                  .ENDM
ADCMopGi          .MACRO
                  .BYTE $7869
                  .ENDM                  
ADCMopHi          .MACRO          
                  .BYTE $7C69
                  .ENDM
ADCMopIi          .MACRO
                  .BYTE $B069
                  .ENDM
ADCMopJi          .MACRO
                  .BYTE $B469
                  .ENDM
ADCMopKi          .MACRO          
                  .BYTE $B869
                  .ENDM
ADCMopLi          .MACRO
                  .BYTE $BC69
                  .ENDM
ADCMopMi          .MACRO
                  .BYTE $F069
                  .ENDM                  
ADCMopNi          .MACRO          
                  .BYTE $F469
                  .ENDM
ADCMopOi          .MACRO
                  .BYTE $F869
                  .ENDM
ADCMopQi          .MACRO
                  .BYTE $FC69
                  .ENDM
                  
ADCNopAi          .MACRO
                  .BYTE $3169
                  .ENDM                
ADCNopBi          .MACRO          
                  .BYTE $3569
                  .ENDM
ADCNopCi          .MACRO
                  .BYTE $3969
                  .ENDM
ADCNopDi          .MACRO
                  .BYTE $3D69
                  .ENDM
ADCNopEi          .MACRO          
                  .BYTE $7169
                  .ENDM
ADCNopFi          .MACRO
                  .BYTE $7569
                  .ENDM
ADCNopGi          .MACRO
                  .BYTE $7969
                  .ENDM                  
ADCNopHi          .MACRO          
                  .BYTE $7D69
                  .ENDM
ADCNopIi          .MACRO
                  .BYTE $B169
                  .ENDM
ADCNopJi          .MACRO
                  .BYTE $B569
                  .ENDM
ADCNopKi          .MACRO          
                  .BYTE $B969
                  .ENDM
ADCNopLi          .MACRO
                  .BYTE $BD69
                  .ENDM
ADCNopMi          .MACRO
                  .BYTE $F169
                  .ENDM                  
ADCNopNi          .MACRO          
                  .BYTE $F569
                  .ENDM
ADCNopOi          .MACRO
                  .BYTE $F969
                  .ENDM
ADCNopQi          .MACRO
                  .BYTE $FD69
                  .ENDM
            
ADCOopAi          .MACRO
                  .BYTE $3269
                  .ENDM                
ADCOopBi          .MACRO          
                  .BYTE $3669
                  .ENDM
ADCOopCi          .MACRO
                  .BYTE $3A69
                  .ENDM
ADCOopDi          .MACRO
                  .BYTE $3E69
                  .ENDM
ADCOopEi          .MACRO          
                  .BYTE $7269
                  .ENDM
ADCOopFi          .MACRO
                  .BYTE $7669
                  .ENDM
ADCOopGi          .MACRO
                  .BYTE $7A69
                  .ENDM                  
ADCOopHi          .MACRO          
                  .BYTE $7E69
                  .ENDM
ADCOopIi          .MACRO
                  .BYTE $B269
                  .ENDM
ADCOopJi          .MACRO
                  .BYTE $B669
                  .ENDM
ADCOopKi          .MACRO          
                  .BYTE $BA69
                  .ENDM
ADCOopLi          .MACRO
                  .BYTE $BE69
                  .ENDM
ADCOopMi          .MACRO
                  .BYTE $F269
                  .ENDM                  
ADCOopNi          .MACRO          
                  .BYTE $F669
                  .ENDM
ADCOopOi          .MACRO
                  .BYTE $FA69
                  .ENDM
ADCOopQi          .MACRO
                  .BYTE $FE69
                  .ENDM
                  
ADCQopAi          .MACRO
                  .BYTE $3369
                  .ENDM                
ADCQopBi          .MACRO          
                  .BYTE $3769
                  .ENDM
ADCQopCi          .MACRO
                  .BYTE $3B69
                  .ENDM
ADCQopDi          .MACRO
                  .BYTE $3F69
                  .ENDM
ADCQopEi          .MACRO          
                  .BYTE $7369
                  .ENDM
ADCQopFi          .MACRO
                  .BYTE $7769
                  .ENDM
ADCQopGi          .MACRO
                  .BYTE $7B69
                  .ENDM                  
ADCQopHi          .MACRO          
                  .BYTE $7F69
                  .ENDM
ADCQopIi          .MACRO
                  .BYTE $B369
                  .ENDM
ADCQopJi          .MACRO
                  .BYTE $B769
                  .ENDM
ADCQopKi          .MACRO          
                  .BYTE $BB69
                  .ENDM
ADCQopLi          .MACRO
                  .BYTE $BF69
                  .ENDM
ADCQopMi          .MACRO
                  .BYTE $F369
                  .ENDM                  
ADCQopNi          .MACRO          
                  .BYTE $F769
                  .ENDM
ADCQopOi          .MACRO
                  .BYTE $FB69
                  .ENDM
ADCQopQi          .MACRO
                  .BYTE $FF69
                  .ENDM
                  
;-------------------------------------------------------------------------------

;ADC #$                 $0069
SBCAopBi          .MACRO          
                  .BYTE $04E9
                  .ENDM
SBCAopCi          .MACRO
                  .BYTE $08E9
                  .ENDM
SBCAopDi          .MACRO
                  .BYTE $0CE9
                  .ENDM
SBCAopEi          .MACRO          
                  .BYTE $40E9
                  .ENDM
SBCAopFi          .MACRO
                  .BYTE $44E9
                  .ENDM
SBCAopGi          .MACRO
                  .BYTE $48E9
                  .ENDM                  
SBCAopHi          .MACRO          
                  .BYTE $4CE9
                  .ENDM
SBCAopIi          .MACRO
                  .BYTE $80E9
                  .ENDM
SBCAopJi          .MACRO
                  .BYTE $84E9
                  .ENDM
SBCAopKi          .MACRO          
                  .BYTE $88E9
                  .ENDM
SBCAopLi          .MACRO
                  .BYTE $8CE9
                  .ENDM
SBCAopMi          .MACRO
                  .BYTE $C0E9
                  .ENDM                  
SBCAopNi          .MACRO          
                  .BYTE $C4E9
                  .ENDM
SBCAopOi          .MACRO
                  .BYTE $C8E9
                  .ENDM
SBCAopQi          .MACRO
                  .BYTE $CCE9
                  .ENDM
                                    
SBCBopAi          .MACRO
                  .BYTE $01E9
                  .ENDM                
SBCBopBi          .MACRO          
                  .BYTE $05E9
                  .ENDM
SBCBopCi          .MACRO
                  .BYTE $09E9
                  .ENDM
SBCBopDi          .MACRO
                  .BYTE $0DE9
                  .ENDM
SBCBopEi          .MACRO          
                  .BYTE $41E9
                  .ENDM
SBCBopFi          .MACRO
                  .BYTE $45E9
                  .ENDM
SBCBopGi          .MACRO
                  .BYTE $49E9
                  .ENDM                  
SBCBopHi          .MACRO          
                  .BYTE $4DE9
                  .ENDM
SBCBopIi          .MACRO
                  .BYTE $81E9
                  .ENDM
SBCBopJi          .MACRO
                  .BYTE $85E9
                  .ENDM
SBCBopKi          .MACRO          
                  .BYTE $89E9
                  .ENDM
SBCBopLi          .MACRO
                  .BYTE $8DE9
                  .ENDM
SBCBopMi          .MACRO
                  .BYTE $C1E9
                  .ENDM                  
SBCBopNi          .MACRO          
                  .BYTE $C5E9
                  .ENDM
SBCBopOi          .MACRO
                  .BYTE $C9E9
                  .ENDM
SBCBopQi          .MACRO
                  .BYTE $CDE9
                  .ENDM
                                    
SBCCopAi          .MACRO
                  .BYTE $02E9
                  .ENDM                
SBCCopBi          .MACRO          
                  .BYTE $06E9
                  .ENDM
SBCCopCi          .MACRO
                  .BYTE $0AE9
                  .ENDM
SBCCopDi          .MACRO
                  .BYTE $0EE9
                  .ENDM
SBCCopEi          .MACRO          
                  .BYTE $42E9
                  .ENDM
SBCCopFi          .MACRO
                  .BYTE $46E9
                  .ENDM
SBCCopGi          .MACRO
                  .BYTE $4AE9
                  .ENDM                  
SBCCopHi          .MACRO          
                  .BYTE $4EE9
                  .ENDM
SBCCopIi          .MACRO
                  .BYTE $82E9
                  .ENDM
SBCCopJi          .MACRO
                  .BYTE $86E9
                  .ENDM
SBCCopKi          .MACRO          
                  .BYTE $8AE9
                  .ENDM
SBCCopLi          .MACRO
                  .BYTE $8EE9
                  .ENDM
SBCCopMi          .MACRO
                  .BYTE $C2E9
                  .ENDM                  
SBCCopNi          .MACRO          
                  .BYTE $C6E9
                  .ENDM
SBCCopOi          .MACRO
                  .BYTE $CAE9
                  .ENDM
SBCCopQi          .MACRO
                  .BYTE $CEE9
                  .ENDM

SBCDopAi          .MACRO
                  .BYTE $03E9
                  .ENDM                
SBCDopBi          .MACRO          
                  .BYTE $07E9
                  .ENDM
SBCDopCi          .MACRO
                  .BYTE $0BE9
                  .ENDM
SBCDopDi          .MACRO
                  .BYTE $0FE9
                  .ENDM
SBCDopEi          .MACRO          
                  .BYTE $43E9
                  .ENDM
SBCDopFi          .MACRO
                  .BYTE $47E9
                  .ENDM
SBCDopGi          .MACRO
                  .BYTE $4BE9
                  .ENDM                  
SBCDopHi          .MACRO          
                  .BYTE $4FE9
                  .ENDM
SBCDopIi          .MACRO
                  .BYTE $83E9
                  .ENDM
SBCDopJi          .MACRO
                  .BYTE $87E9
                  .ENDM
SBCDopKi          .MACRO          
                  .BYTE $8BE9
                  .ENDM
SBCDopLi          .MACRO
                  .BYTE $8FE9
                  .ENDM
SBCDopMi          .MACRO
                  .BYTE $C3E9
                  .ENDM                  
SBCDopNi          .MACRO          
                  .BYTE $C7E9
                  .ENDM
SBCDopOi          .MACRO
                  .BYTE $CBE9
                  .ENDM
SBCDopQi          .MACRO
                  .BYTE $CFE9
                  .ENDM                  

SBCEopAi          .MACRO
                  .BYTE $10E9
                  .ENDM                
SBCEopBi          .MACRO          
                  .BYTE $14E9
                  .ENDM
SBCEopCi          .MACRO
                  .BYTE $18E9
                  .ENDM
SBCEopDi          .MACRO
                  .BYTE $1CE9
                  .ENDM
SBCEopEi          .MACRO          
                  .BYTE $50E9
                  .ENDM
SBCEopFi          .MACRO
                  .BYTE $54E9
                  .ENDM
SBCEopGi          .MACRO
                  .BYTE $58E9
                  .ENDM                  
SBCEopHi          .MACRO          
                  .BYTE $5CE9
                  .ENDM
SBCEopIi          .MACRO
                  .BYTE $90E9
                  .ENDM
SBCEopJi          .MACRO
                  .BYTE $94E9
                  .ENDM
SBCEopKi          .MACRO          
                  .BYTE $98E9
                  .ENDM
SBCEopLi          .MACRO
                  .BYTE $9CE9
                  .ENDM
SBCEopMi          .MACRO
                  .BYTE $D0E9
                  .ENDM                  
SBCEopNi          .MACRO          
                  .BYTE $D4E9
                  .ENDM
SBCEopOi          .MACRO
                  .BYTE $D8E9
                  .ENDM
SBCEopQi          .MACRO
                  .BYTE $DCE9
                  .ENDM
                  
SBCFopAi          .MACRO
                  .BYTE $11E9
                  .ENDM                
SBCFopBi          .MACRO          
                  .BYTE $15E9
                  .ENDM
SBCFopCi          .MACRO
                  .BYTE $19E9
                  .ENDM
SBCFopDi          .MACRO
                  .BYTE $1DE9
                  .ENDM
SBCFopEi          .MACRO          
                  .BYTE $51E9
                  .ENDM
SBCFopFi          .MACRO
                  .BYTE $55E9
                  .ENDM
SBCFopGi          .MACRO
                  .BYTE $59E9
                  .ENDM                  
SBCFopHi          .MACRO          
                  .BYTE $5DE9
                  .ENDM
SBCFopIi          .MACRO
                  .BYTE $91E9
                  .ENDM
SBCFopJi          .MACRO
                  .BYTE $95E9
                  .ENDM
SBCFopKi          .MACRO          
                  .BYTE $99E9
                  .ENDM
SBCFopLi          .MACRO
                  .BYTE $9DE9
                  .ENDM
SBCFopMi          .MACRO
                  .BYTE $D1E9
                  .ENDM                  
SBCFopNi          .MACRO          
                  .BYTE $D5E9
                  .ENDM
SBCFopOi          .MACRO
                  .BYTE $D9E9
                  .ENDM
SBCFopQi          .MACRO
                  .BYTE $DDE9
                  .ENDM                  
                           
SBCGopAi          .MACRO
                  .BYTE $12E9
                  .ENDM                
SBCGopBi          .MACRO          
                  .BYTE $16E9
                  .ENDM
SBCGopCi          .MACRO
                  .BYTE $1AE9
                  .ENDM
SBCGopDi          .MACRO
                  .BYTE $1EE9
                  .ENDM
SBCGopEi          .MACRO          
                  .BYTE $52E9
                  .ENDM
SBCGopFi          .MACRO
                  .BYTE $56E9
                  .ENDM
SBCGopGi          .MACRO
                  .BYTE $5AE9
                  .ENDM                  
SBCGopHi          .MACRO          
                  .BYTE $5EE9
                  .ENDM
SBCGopIi          .MACRO
                  .BYTE $92E9
                  .ENDM
SBCGopJi          .MACRO
                  .BYTE $96E9
                  .ENDM
SBCGopKi          .MACRO          
                  .BYTE $9AE9
                  .ENDM
SBCGopLi          .MACRO
                  .BYTE $9EE9
                  .ENDM
SBCGopMi          .MACRO
                  .BYTE $D2E9
                  .ENDM                  
SBCGopNi          .MACRO          
                  .BYTE $D6E9
                  .ENDM
SBCGopOi          .MACRO
                  .BYTE $DAE9
                  .ENDM
SBCGopQi          .MACRO
                  .BYTE $DEE9
                  .ENDM
                  
SBCHopAi          .MACRO
                  .BYTE $13E9
                  .ENDM                
SBCHopBi          .MACRO          
                  .BYTE $17E9
                  .ENDM
SBCHopCi          .MACRO
                  .BYTE $1BE9
                  .ENDM
SBCHopDi          .MACRO
                  .BYTE $1FE9
                  .ENDM
SBCHopEi          .MACRO          
                  .BYTE $53E9
                  .ENDM
SBCHopFi          .MACRO
                  .BYTE $57E9
                  .ENDM
SBCHopGi          .MACRO
                  .BYTE $5BE9
                  .ENDM                  
SBCHopHi          .MACRO          
                  .BYTE $5FE9
                  .ENDM
SBCHopIi          .MACRO
                  .BYTE $93E9
                  .ENDM
SBCHopJi          .MACRO
                  .BYTE $97E9
                  .ENDM
SBCHopKi          .MACRO          
                  .BYTE $9BE9
                  .ENDM
SBCHopLi          .MACRO
                  .BYTE $9FE9
                  .ENDM
SBCHopMi          .MACRO
                  .BYTE $D3E9
                  .ENDM                  
SBCHopNi          .MACRO          
                  .BYTE $D7E9
                  .ENDM
SBCHopOi          .MACRO
                  .BYTE $DBE9
                  .ENDM
SBCHopQi          .MACRO
                  .BYTE $DFE9
                  .ENDM
                  
SBCIopAi          .MACRO
                  .BYTE $20E9
                  .ENDM                
SBCIopBi          .MACRO          
                  .BYTE $24E9
                  .ENDM
SBCIopCi          .MACRO
                  .BYTE $28E9
                  .ENDM
SBCIopDi          .MACRO
                  .BYTE $2CE9
                  .ENDM
SBCIopEi          .MACRO          
                  .BYTE $60E9
                  .ENDM
SBCIopFi          .MACRO
                  .BYTE $64E9
                  .ENDM
SBCIopGi          .MACRO
                  .BYTE $68E9
                  .ENDM                  
SBCIopHi          .MACRO          
                  .BYTE $6CE9
                  .ENDM
SBCIopIi          .MACRO
                  .BYTE $A0E9
                  .ENDM
SBCIopJi          .MACRO
                  .BYTE $A4E9
                  .ENDM
SBCIopKi          .MACRO          
                  .BYTE $A8E9
                  .ENDM
SBCIopLi          .MACRO
                  .BYTE $ACE9
                  .ENDM
SBCIopMi          .MACRO
                  .BYTE $E0E9
                  .ENDM                  
SBCIopNi          .MACRO          
                  .BYTE $E4E9
                  .ENDM
SBCIopOi          .MACRO
                  .BYTE $E8E9
                  .ENDM
SBCIopQi          .MACRO
                  .BYTE $ECE9
                  .ENDM
                  
SBCJopAi          .MACRO
                  .BYTE $21E9
                  .ENDM                
SBCJopBi          .MACRO          
                  .BYTE $25E9
                  .ENDM
SBCJopCi          .MACRO
                  .BYTE $29E9
                  .ENDM
SBCJopDi          .MACRO
                  .BYTE $2DE9
                  .ENDM
SBCJopEi          .MACRO          
                  .BYTE $61E9
                  .ENDM
SBCJopFi          .MACRO
                  .BYTE $65E9
                  .ENDM
SBCJopGi          .MACRO
                  .BYTE $E9E9
                  .ENDM                  
SBCJopHi          .MACRO          
                  .BYTE $6DE9
                  .ENDM
SBCJopIi          .MACRO
                  .BYTE $A1E9
                  .ENDM
SBCJopJi          .MACRO
                  .BYTE $A5E9
                  .ENDM
SBCJopKi          .MACRO          
                  .BYTE $A9E9
                  .ENDM
SBCJopLi          .MACRO
                  .BYTE $ADE9
                  .ENDM
SBCJopMi          .MACRO
                  .BYTE $E1E9
                  .ENDM                  
SBCJopNi          .MACRO          
                  .BYTE $E5E9
                  .ENDM
SBCJopOi          .MACRO
                  .BYTE $E9E9
                  .ENDM
SBCJopQi          .MACRO
                  .BYTE $EDE9
                  .ENDM
                  
SBCKopAi          .MACRO
                  .BYTE $22E9
                  .ENDM                
SBCKopBi          .MACRO          
                  .BYTE $26E9
                  .ENDM
SBCKopCi          .MACRO
                  .BYTE $2AE9
                  .ENDM
SBCKopDi          .MACRO
                  .BYTE $2EE9
                  .ENDM
SBCKopEi          .MACRO          
                  .BYTE $62E9
                  .ENDM
SBCKopFi          .MACRO
                  .BYTE $66E9
                  .ENDM
SBCKopGi          .MACRO
                  .BYTE $6AE9
                  .ENDM                  
SBCKopHi          .MACRO          
                  .BYTE $6EE9
                  .ENDM
SBCKopIi          .MACRO
                  .BYTE $A2E9
                  .ENDM
SBCKopJi          .MACRO
                  .BYTE $A6E9
                  .ENDM
SBCKopKi          .MACRO          
                  .BYTE $AAE9
                  .ENDM
SBCKopLi          .MACRO
                  .BYTE $AEE9
                  .ENDM
SBCKopMi          .MACRO
                  .BYTE $E2E9
                  .ENDM                  
SBCKopNi          .MACRO          
                  .BYTE $E6E9
                  .ENDM
SBCKopOi          .MACRO
                  .BYTE $EAE9
                  .ENDM
SBCKopQi          .MACRO
                  .BYTE $EEE9
                  .ENDM
                  
SBCLopAi          .MACRO
                  .BYTE $23E9
                  .ENDM                
SBCLopBi          .MACRO          
                  .BYTE $27E9
                  .ENDM
SBCLopCi          .MACRO
                  .BYTE $2BE9
                  .ENDM
SBCLopDi          .MACRO
                  .BYTE $2FE9
                  .ENDM
SBCLopEi          .MACRO          
                  .BYTE $63E9
                  .ENDM
SBCLopFi          .MACRO
                  .BYTE $67E9
                  .ENDM
SBCLopGi          .MACRO
                  .BYTE $6BE9
                  .ENDM                  
SBCLopHi          .MACRO          
                  .BYTE $6FE9
                  .ENDM
SBCLopIi          .MACRO
                  .BYTE $A3E9
                  .ENDM
SBCLopJi          .MACRO
                  .BYTE $A7E9
                  .ENDM
SBCLopKi          .MACRO          
                  .BYTE $ABE9
                  .ENDM
SBCLopLi          .MACRO
                  .BYTE $AFE9
                  .ENDM
SBCLopMi          .MACRO
                  .BYTE $E3E9
                  .ENDM                  
SBCLopNi          .MACRO          
                  .BYTE $E7E9
                  .ENDM
SBCLopOi          .MACRO
                  .BYTE $EBE9
                  .ENDM
SBCLopQi          .MACRO
                  .BYTE $EFE9
                  .ENDM
                  
SBCMopAi          .MACRO
                  .BYTE $30E9
                  .ENDM                
SBCMopBi          .MACRO          
                  .BYTE $34E9
                  .ENDM
SBCMopCi          .MACRO
                  .BYTE $38E9
                  .ENDM
SBCMopDi          .MACRO
                  .BYTE $3CE9
                  .ENDM
SBCMopEi          .MACRO          
                  .BYTE $70E9
                  .ENDM
SBCMopFi          .MACRO
                  .BYTE $74E9
                  .ENDM
SBCMopGi          .MACRO
                  .BYTE $78E9
                  .ENDM                  
SBCMopHi          .MACRO          
                  .BYTE $7CE9
                  .ENDM
SBCMopIi          .MACRO
                  .BYTE $B0E9
                  .ENDM
SBCMopJi          .MACRO
                  .BYTE $B4E9
                  .ENDM
SBCMopKi          .MACRO          
                  .BYTE $B8E9
                  .ENDM
SBCMopLi          .MACRO
                  .BYTE $BCE9
                  .ENDM
SBCMopMi          .MACRO
                  .BYTE $F0E9
                  .ENDM                  
SBCMopNi          .MACRO          
                  .BYTE $F4E9
                  .ENDM
SBCMopOi          .MACRO
                  .BYTE $F8E9
                  .ENDM
SBCMopQi          .MACRO
                  .BYTE $FCE9
                  .ENDM
                  
SBCNopAi          .MACRO
                  .BYTE $31E9
                  .ENDM                
SBCNopBi          .MACRO          
                  .BYTE $35E9
                  .ENDM
SBCNopCi          .MACRO
                  .BYTE $39E9
                  .ENDM
SBCNopDi          .MACRO
                  .BYTE $3DE9
                  .ENDM
SBCNopEi          .MACRO          
                  .BYTE $71E9
                  .ENDM
SBCNopFi          .MACRO
                  .BYTE $75E9
                  .ENDM
SBCNopGi          .MACRO
                  .BYTE $79E9
                  .ENDM                  
SBCNopHi          .MACRO          
                  .BYTE $7DE9
                  .ENDM
SBCNopIi          .MACRO
                  .BYTE $B1E9
                  .ENDM
SBCNopJi          .MACRO
                  .BYTE $B5E9
                  .ENDM
SBCNopKi          .MACRO          
                  .BYTE $B9E9
                  .ENDM
SBCNopLi          .MACRO
                  .BYTE $BDE9
                  .ENDM
SBCNopMi          .MACRO
                  .BYTE $F1E9
                  .ENDM                  
SBCNopNi          .MACRO          
                  .BYTE $F5E9
                  .ENDM
SBCNopOi          .MACRO
                  .BYTE $F9E9
                  .ENDM
SBCNopQi          .MACRO
                  .BYTE $FDE9
                  .ENDM
            
SBCOopAi          .MACRO
                  .BYTE $32E9
                  .ENDM                
SBCOopBi          .MACRO          
                  .BYTE $36E9
                  .ENDM
SBCOopCi          .MACRO
                  .BYTE $3AE9
                  .ENDM
SBCOopDi          .MACRO
                  .BYTE $3EE9
                  .ENDM
SBCOopEi          .MACRO          
                  .BYTE $72E9
                  .ENDM
SBCOopFi          .MACRO
                  .BYTE $76E9
                  .ENDM
SBCOopGi          .MACRO
                  .BYTE $7AE9
                  .ENDM                  
SBCOopHi          .MACRO          
                  .BYTE $7EE9
                  .ENDM
SBCOopIi          .MACRO
                  .BYTE $B2E9
                  .ENDM
SBCOopJi          .MACRO
                  .BYTE $B6E9
                  .ENDM
SBCOopKi          .MACRO          
                  .BYTE $BAE9
                  .ENDM
SBCOopLi          .MACRO
                  .BYTE $BEE9
                  .ENDM
SBCOopMi          .MACRO
                  .BYTE $F2E9
                  .ENDM                  
SBCOopNi          .MACRO          
                  .BYTE $F6E9
                  .ENDM
SBCOopOi          .MACRO
                  .BYTE $FAE9
                  .ENDM
SBCOopQi          .MACRO
                  .BYTE $FEE9
                  .ENDM
                  
SBCQopAi          .MACRO
                  .BYTE $33E9
                  .ENDM                
SBCQopBi          .MACRO          
                  .BYTE $37E9
                  .ENDM
SBCQopCi          .MACRO
                  .BYTE $3BE9
                  .ENDM
SBCQopDi          .MACRO
                  .BYTE $3FE9
                  .ENDM
SBCQopEi          .MACRO          
                  .BYTE $73E9
                  .ENDM
SBCQopFi          .MACRO
                  .BYTE $77E9
                  .ENDM
SBCQopGi          .MACRO
                  .BYTE $7BE9
                  .ENDM                  
SBCQopHi          .MACRO          
                  .BYTE $7FE9
                  .ENDM
SBCQopIi          .MACRO
                  .BYTE $B3E9
                  .ENDM
SBCQopJi          .MACRO
                  .BYTE $B7E9
                  .ENDM
SBCQopKi          .MACRO          
                  .BYTE $BBE9
                  .ENDM
SBCQopLi          .MACRO
                  .BYTE $BFE9
                  .ENDM
SBCQopMi          .MACRO
                  .BYTE $F3E9
                  .ENDM                  
SBCQopNi          .MACRO          
                  .BYTE $F7E9
                  .ENDM
SBCQopOi          .MACRO
                  .BYTE $FBE9
                  .ENDM
SBCQopQi          .MACRO
                  .BYTE $FFE9
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

TAZ               .MACRO               ;transfer A acc to zeropage pointer
                  .BYTE $0017
                  .ENDM
TBZ               .MACRO
                  .BYTE $0417
                  .ENDM
TCZ               .MACRO
                  .BYTE $0817
                  .ENDM
TDZ               .MACRO
                  .BYTE $0C17
                  .ENDM
TEZ               .MACRO
                  .BYTE $4017
                  .ENDM
TFZ               .MACRO
                  .BYTE $4417
                  .ENDM
TGZ               .MACRO
                  .BYTE $4817
                  .ENDM
THZ               .MACRO
                  .BYTE $4C17
                  .ENDM
TIZ               .MACRO
                  .BYTE $8017
                  .ENDM
TJZ               .MACRO
                  .BYTE $8417
                  .ENDM
TKZ               .MACRO
                  .BYTE $8817
                  .ENDM
TLZ               .MACRO
                  .BYTE $8C17
                  .ENDM
TMZ               .MACRO
                  .BYTE $C017
                  .ENDM
TNZ               .MACRO
                  .BYTE $C417
                  .ENDM
TOZ               .MACRO
                  .BYTE $C817
                  .ENDM
TQZ               .MACRO
                  .BYTE $CC17
                  .ENDM

TAS               .MACRO            ;transfer A acc to stackpage pointer
                  .BYTE $0037
                  .ENDM
TBS               .MACRO
                  .BYTE $0437
                  .ENDM
TCS               .MACRO
                  .BYTE $0837
                  .ENDM
TDS               .MACRO
                  .BYTE $0C37
                  .ENDM
TES               .MACRO
                  .BYTE $4037
                  .ENDM
TFS               .MACRO
                  .BYTE $4437
                  .ENDM
TGS               .MACRO
                  .BYTE $4837
                  .ENDM
THS               .MACRO
                  .BYTE $4C37
                  .ENDM
TIS               .MACRO
                  .BYTE $8037
                  .ENDM
TJS               .MACRO
                  .BYTE $8437
                  .ENDM
TKS               .MACRO
                  .BYTE $8837
                  .ENDM
TLS               .MACRO
                  .BYTE $8C37
                  .ENDM
TMS               .MACRO
                  .BYTE $C037
                  .ENDM
TNS               .MACRO
                  .BYTE $C437
                  .ENDM
TOS               .MACRO
                  .BYTE $C837
                  .ENDM
TQS               .MACRO
                  .BYTE $CC37
                  .ENDM 

TZA               .MACRO            ;transfer zeropage pointer to A Acc
                  .BYTE $0007
                  .ENDM
TZB               .MACRO
                  .BYTE $0107
                  .ENDM
TZC               .MACRO
                  .BYTE $0207
                  .ENDM
TZD               .MACRO
                  .BYTE $0307
                  .ENDM
TZE               .MACRO
                  .BYTE $1007
                  .ENDM
TZF               .MACRO
                  .BYTE $1107
                  .ENDM
TZG               .MACRO
                  .BYTE $1207
                  .ENDM
TZH               .MACRO
                  .BYTE $1307
                  .ENDM
TZI               .MACRO
                  .BYTE $2007
                  .ENDM
TZJ               .MACRO
                  .BYTE $2107
                  .ENDM
TZK               .MACRO
                  .BYTE $2207
                  .ENDM
TZL               .MACRO
                  .BYTE $2307
                  .ENDM
TZM               .MACRO
                  .BYTE $3007
                  .ENDM
TZN               .MACRO
                  .BYTE $3107
                  .ENDM
TZO               .MACRO
                  .BYTE $3207
                  .ENDM
TZQ               .MACRO
                  .BYTE $3307
                  .ENDM
                  
TSA               .MACRO            ;transfer stackpage pointer to A Acc
                  .BYTE $0027
                  .ENDM
TSB               .MACRO
                  .BYTE $0127
                  .ENDM
TSC               .MACRO
                  .BYTE $0227
                  .ENDM
TSD               .MACRO
                  .BYTE $0327
                  .ENDM
TSE               .MACRO
                  .BYTE $1027
                  .ENDM
TSF               .MACRO
                  .BYTE $1127
                  .ENDM
TSG               .MACRO
                  .BYTE $1227
                  .ENDM
TSH               .MACRO
                  .BYTE $1327
                  .ENDM
TSI               .MACRO
                  .BYTE $2027
                  .ENDM
TSJ               .MACRO
                  .BYTE $2127
                  .ENDM
TSK               .MACRO
                  .BYTE $2227
                  .ENDM
TSL               .MACRO
                  .BYTE $2327
                  .ENDM
TSM               .MACRO
                  .BYTE $3027
                  .ENDM
TSN               .MACRO
                  .BYTE $3127
                  .ENDM
TSO               .MACRO
                  .BYTE $3227
                  .ENDM
TSQ               .MACRO
                  .BYTE $3327
                  .ENDM
                                    
STazpw            .MACRO
                  .BYTE $0092
                  .ENDM
LDazpw            .MACRO
                  .BYTE $00B2
                  .ENDM
                  
; SHIFTING
SR12        .MACRO
            .BYTE $B04A     ;LSR A Acc 12x
            ;LSR
            ;LSR
            ;LSR
            ;LSR
            ;LSR
            ;;LSR
            ;LSR
            ;LSR
            ;LSR
            ;LSR
            ;LSR
            ;LSR
            .ENDM
            
SR8         .MACRO
            .BYTE $704A     ;LSR A Acc 7x
           ; LSR
            ;LSR
            ;LSR
            ;LSR
            ;LSR
            ;LSR
            ;LSR
            ;LSR
            .ENDM
            
SR6         .MACRO
            .BYTE $504A     ;LSR A Acc 6x
            ;LSR
            ;LSR
            ;LSR
            ;LSR
            ;LSR
            ;LSR
            .ENDM
            
SR4         .MACRO
            .BYTE $304A     ;LSR A Acc 4x
            ;LSR
            ;LSR
            ;LSR
            ;LSR
            .ENDM
            
SL8         .MACRO
            .BYTE $700A     ;ASL A Acc 8x
            ;ASL
            ;ASL
            ;ASL
            ;ASL
            ;ASL
            ;ASL
            ;ASL
            ;ASL
            .ENDM
            		
START:	    LDA #$0000
            TAS
            TAZ
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
    
BEGIN       LDA #%1001010110000000   ;ATTRIBUTE MASK FOR C-64 ASSEMBLER
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
       
       SR8            ;MACRO TO LSR A X8
       
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
       JSR OUTCR
       LDA #$2D
       JSR OUTPUT
       BCS M2         ;always
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

BREAK   STA AREG
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
        SL8
        ora     #$0080
        jsr     i2c_wrbyte      
        
        lda     addr
        SL8
        ora     #$0080
        jsr     i2c_wrbyte      

        lda     val
        SL8
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
            
INPUT       TYA
            PHA
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
NPRESS      TAX
            PLA
            TAY
            TXA
            RTS

OUTPUT      PHA
            JSR PLTCHR
            PLA
            RTS
            

EOL         PHA
            TXA
            PHA
            LDA #$00            ;END OF LINE, CARRIAGE RETURN ROUTINE
            STA XPOS
            LDA YPOS
            CMP #464            ;CHECK FOR BOTTOM LINE
            BMI AO
            LDA #$00
            BEQ AP
AO          CLC
            ADC CHRYLENFIN
AP          STA YPOS
            PLA
            TAX
            PLA
            RTS
                        
NCHAR       CMP #$0D
            BNE AI
            JSR EOL
AI          PLA
            TAX
            PLA
            TAY
            RTS

PLTCHR      ORA ATTBUT
            STA CHR           ; Plot Character Subroutine variable (1-7) H and V size 
            TYA               ; save all reg's 
            PHA 
            TXA 
            PHA        

ATTBUTE     LDA CHR
            AND #%00000111100000000    ;get color VALUE from bits 8,9,10,11
            
	          SR6                        ;multiply by 4 for easy indexing
                               
	          TAX
	          LDA COLTABLE,X
	          STA PXLCOL1
	          INX
	          LDA COLTABLE,X
	          STA PXLCOL2
	          INX
	          LDA COLTABLE,X
	          STA PXLCOL3

	          LDA CHR           ;check bits 12,13,14 for size
	          AND #%0011000000000000
	          
            SR12  	          ;SIZE 00=1, 01=2, 10=3, 11=4
            
            CLC
            ADC #$01          ;MAKE SIZE 0 = 1
AG         	STA XWIDTH
	          STA YWIDTH
	
	          LDA CHR    	      ;check font bits, 00=16X16  01=DOS  10=C64  11=???
	          AND #%1100000000000000
            STA FONT
	          BEQ n8X8
            
            LDA #$08
            STA PATROW
            STA CHRXLEN
            STA CHRYLEN

            LDA #$CA00
            STA CHRBASE
		        LDA #$0080
		        STA SENTINEL
	          JMP porc

n8X8        LDA #$0F
            STA PATROW
            STA CHRXLEN
	          STA CHRYLEN
            LDA #$CD00
            STA CHRBASE
		        LDA #$0008
		        STA SENTINEL
	
porc        LDA #$00
            LDX YWIDTH
            CLC
AR          ADC CHRYLEN
            DEX
            BNE AR
            STA CHRYLENFIN    ;REAL CHARACTER Y BITSIZE
            
            LDA CHR		        ;test PE bit 7 for plot or clear
            AND #%0000000010000000
            CMP #$0080
		        BEQ plot2
	          LDA SCRCOL1
	          STA TMPCOL1
	          LDA SCRCOL2
	          STA TMPCOL2
	          LDA SCRCOL3
	          STA TMPCOL3
	          JMP PLTPOS
plot2	      LDA PXLCOL1
	          STA TMPCOL1
	          LDA PXLCOL2
	          STA TMPCOL2
	          LDA PXLCOL3
	          STA TMPCOL3

PLTPOS      LDA #$2A          ;set x address
	          STA DCOM
            LDA XPOS
            CMP #800          ;EOL?
            BMI AN
            JSR EOL
            LDA #$00
AN          PHA
            
            SR8
            
            STA DDAT          ;X START MSB
            PLA
            AND #$00FF
            STA DDAT          ;X START LSB

            LDA XPOS
            CLC
            LDX XWIDTH
AC          ADC CHRXLEN
            DEX
            BNE AC
            STA XPOS          ;UPDATE X POSITION
            SEC
            SBC #$01
            PHA
            
            SR8
            
            STA DDAT          ;X END MSB
            PLA
            AND #$00FF
            STA DDAT          ;X END LSB

            LDA #$2B          ;set y address
            STA DCOM
	          LDA YPOS
            PHA
            
            SR8
            
            STA DDAT          ;Y START MSB
            PLA
            AND #$00FF
            STA DDAT          ;Y START LSB

            LDA YPOS
            CLC
            ADC CHRYLENFIN
            
            SEC
            SBC #$01
            PHA
            
            SR8
            
            STA DDAT          ;Y END MSB
            PLA
            AND #$00FF
            STA DDAT          ;Y END LSB

            
            
CACALC      LDA #$2C          ; Prepare TFT to Plot 
            STA DCOM
             
            LDA CHR 
            AND #$7F          ; an ascii char ? MINUS ATTRIBUTE INFO
            CMP #$20
            BCC NCHAR
nnull       SEC
            SBC #$20
            ASL A             ; * 2 
            ASL A             ; * 4 
            ASL A             ; * 8
            CLC 
            ADC CHRBASE       ; add pointer to base either CA00 (8X8) or CD00(16X16) (carry clear) 
            TAY 

loop7       LDA XWIDTH        ; plot row repeat count (1-7) 
            STA PIXROW 
loop4       LDA CHARPIX,Y     ; $FFFFCA00(c64) or $FFFFCD00(16X16)
            LDX FONT
            CPX #%1000000000000000          ;CHECK FOR C-64 FONT
            BNE skasl         ;SKIP SHIFT OUT TOP 8 BITS
            
            SL8               ;SHIFT OUT TOP 8 BIT FOR C-64 ONLY 
           
skasl       CPX #%0100000000000000
            BNE skas2
            AND #$FF00
skas2       ORA SENTINEL      ; $0080 (8X8) or $0008 (16X16) 

            ASL A             ; get a pixel 
loop5       PHA               ; save remaining pixel row data 
            LDX YWIDTH        ; plot column repeat count (1-7) (same as PLTHGT?) 
            BCC xwnp          ; b: clear ('blank') 

xwp         LDA TMPCOL1    
            STA DDAT          ; plot RED pixel TFT data 
            LDA TMPCOL2    
            STA DDAT          ; plot GREEN pixel TFT data 
            LDA TMPCOL3    
            STA DDAT          ; plot BLUE pixel TFT data 
            DEX 
            BNE xwp 
            BEQ nxtpix        ; b: forced 
                          
xwnp        LDA SCRCOL1    
            STA DDAT          ; plot RED "blank" pixel TFT data 
            LDA SCRCOL2    
            STA DDAT          ; plot GREEN "blank" pixel TFT data 
            LDA SCRCOL3 
            STA DDAT          ; plot BLUE "blank" pixel TFT data 
            DEX 
            BNE xwnp 

nxtpix      PLA               ; get pixel row data back 
            ASL A             ; another pixel to plot ? 
            BNE loop5         ; b: yes (sentinel still hasn't shifted out) 

            DEC PIXROW        ; repeat this row ? 
            BNE loop4         ; b: yes 

            INY 
            DEC PATROW        ; another pattern row to plot ? 
            BNE loop7         ; b: yes 

            PLA        
            TAX 
            PLA        
            TAY               ;reload reg's 
            RTS


  
CLRSCR:	    LDA #$2A          ;set x address
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
            
            SR12
            
            TAX
            LDA HEXDIGIT,X
            JSR PLTCHR
            
            PLA
            AND #$0F00
            
            SR8
            
            TAX
            LDA HEXDIGIT,X
            JSR PLTCHR
            
            PLA
            AND #$00F0
            
            SR4
            
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
