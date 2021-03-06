
DATO  	EQU 0X21
COUNTY 	EQU 0X22
COUNTX 	EQU 0X23
LIMITY 	EQU 0X24
LIMITX 	EQU 0X25
P1	  	EQU 0X26
P2    	EQU 0X27
COUNTBETA EQU 0X28
LIMITBETA EQU 0X29
VARMAXX	EQU	0X30
VARMAXY	EQU	0X31

INICIO

	ORG		0X00
	GOTO	START

START
	;1 = in        0  = out
	;BIT SET FILE
	BSF 	STATUS, 5; COLOCAMOS EN S EL BIT 5 DE REG. ESTATUS
	CLRF	TRISB
	CLRF	TRISD   
	                    ;BIT CLEARE FILE
	BCF		STATUS, RP0 ;TODOS LOS PINES DE B SON SALIDAS

	MOVLW	0X00
	MOVWF 	PORTB  ; SET 0 TO ALL PORTS B
	MOVLW	0X00
	MOVWF 	PORTD  ; SET 0 TO ALL PORTS B
	MOVLW 	0xCA	
	MOVWF 	LIMITY ;LIMIT 20H -> 32D 
	MOVLW 	0x20
	MOVWF 	LIMITX ;LIMIT 40H -> 64D
	MOVLW	0x10	
	MOVWF	LIMITBETA
	CALL 	CLEANY
	CALL 	CLEANX
	CALL 	CLEANBETA
;--------------------------------------------------------------------
						;MAIN
						
SEARCH

	CALL	LOOPX ; MOVE X AND Y
	INCF	COUNTBETA,1
	MOVF	LIMITBETA, W	
	SUBWF	COUNTBETA, w
	BTFSS	STATUS,Z
	GOTO	SEARCH
	CALL	CLEANBETA
	CALL 	LOOPBETA
	GOTO 	END

;---------------------------------------------------------------------

LOOPBETA
	CALL 	LOOPXREVERSE
	
	INCF	COUNTBETA,1
	MOVF	LIMITBETA, W	
	SUBWF	COUNTBETA, w
	BTFSS	STATUS,Z
	GOTO	LOOPBETA
	GOTO 	END


LOOPX ; LOOP i <= LIMITX
	CALL 	EJEX

	;MOVE ON X
	MOVF  	COUNTX, w
	ADDLW 	0x01 	; COUNT++
    MOVWF 	COUNTX 
	MOVF  	LIMITX, w
	SUBWF 	COUNTX,w
	BTFSS 	STATUS,Z ;CHECK COUNT < limitx
	GOTO 	LOOPX	; JUMP IF COUNT !=  limitx
	CALL	LOOPY ; MOVE Y

	CALL 	CLEANX
	RETURN

	

LOOPY ;LOOP i <= LIMITY
	CALL 	EJEY
	;INSERT LOGIC COMPARE VALUE OF PHOTOCELL & SAVE IT


	;MOVE ON Y
	MOVF  	COUNTY, w
	ADDLW 	0x01 	; COUNT++
    MOVWF 	COUNTY 
	MOVF  	LIMITY, w
	SUBWF 	COUNTY,w
	BTFSS 	STATUS,Z ;CHECK COUNT < limity
	GOTO 	LOOPY	; JUMP IF COUNT !=  limity
	;RESET Y
	CALL 	CLEANY
	CALL 	LOOPYREVERSE
	return


;-------------------------------------------------------------------
;						DELAY
Delay ; = 0.0001 seconds
			;496 cycles
	movlw	0xA5
	movwf	p1
Delay_0
	decfsz	p1, f
	goto	Delay_0

			;4 cycles (including call)
	return
;-------------------------------------------------------------------
;						UTILITIES


MV	
	CALL 	DELAY
	MOVF	DATO, W  
	MOVWF	PORTD	
	RETURN

LOOPYREVERSE
	CALL 	REVERSEEJEY
	MOVF  	COUNTY, w
	ADDLW 	0x01 ; sume a w la literal (0x01)
    MOVWF 	COUNTY ; se mueve lo que tiene w a f 
	MOVF  	LIMITY, w
	SUBWF 	COUNTY,w
	BTFSS 	STATUS,Z ;CHECK COUNT <32
	GOTO 	LOOPYREVERSE
	CALL 	CLEANY
	RETURN

LOOPXREVERSE
	CALL 	REVERSEEJEX
	MOVF  	COUNTX, w
	ADDLW 	0x01 ; sume a w la literal (0x01)
    MOVWF 	COUNTX ; se mueve lo que tiene w a f 
	MOVF  	LIMITX, w
	SUBWF 	COUNTX,w
	BTFSS 	STATUS,Z ;CHECK COUNT <32
	GOTO 	LOOPXREVERSE
	CALL 	CLEANX
	RETURN

CLEANY
	MOVLW 	0x00  ;se asigna la literal a w (0x00)
	MOVWF 	COUNTY ;muevo w a COUNT 
	RETURN

CLEANX
	MOVLW 	0x00  ;se asigna la literal a w (0x00)
	MOVWF 	COUNTX ;muevo w a COUNT 
	RETURN
CLEANBETA
	MOVLW 	0x00  ;se asigna la literal a w (0x00)
	MOVWF 	COUNTBETA ;muevo w a COUNT 
	RETURN

EJEX	
	CALL	MV12
	CALL	MV06
	CALL	MV03
	CALL	MV09
	RETURN

EJEY	
	CALL	MVY12
	CALL	MVY6
	CALL	MVY3
	CALL	MVY9
	RETURN

REVERSEEJEY
	CALL	MVY9
	CALL	MVY3
	CALL	MVY6
	CALL	MVY12
	RETURN
REVERSEEJEX
	CALL  	MV09
	CALL	MV03
	CALL	MV06
	CALL	MV12
	RETURN

MV01	
	MOVLW	B'00000001'
	MOVWF	DATO
	CALL	MV
	RETURN

MV02
	MOVLW	B'00000010'
	MOVWF	DATO
	CALL	MV
	RETURN
MV03	
	MOVLW	B'00000011'
	MOVWF	DATO
	CALL	MV
	RETURN

MV04
	MOVLW	B'00000100'
	MOVWF	DATO
	CALL	MV
	RETURN
MV05
	MOVLW	B'00000101'
	MOVWF	DATO
	CALL	MV
	RETURN
MV06
	MOVLW	B'00000110'
	MOVWF	DATO
	CALL	MV
	RETURN
MV07
	MOVLW	B'00000111'
	MOVWF	DATO
	CALL	MV
	RETURN
MV08
	MOVLW	B'00001000'
	MOVWF	DATO
	CALL	MV
	RETURN
MV09
	MOVLW	B'00001001'
	MOVWF	DATO
	CALL	MV
	RETURN
MV12
	MOVLW	B'00001100'
	MOVWF	DATO
	CALL	MV
	RETURN
MVy0
	MOVLW	B'00000000'
	MOVWF	DATO
	CALL	MV
	RETURN
MVY1
	MOVLW	B'00010000'
	MOVWF	DATO
	CALL	MV
	RETURN
MVY2
	MOVLW	B'00100000'
	MOVWF	DATO
	CALL	MV
	RETURN
MVY3
	MOVLW	B'00110000'
	MOVWF	DATO
	CALL	MV
	RETURN
MVY4
	MOVLW	B'01000000'
	MOVWF	DATO
	CALL	MV
	RETURN
MVY5
	MOVLW	B'01010000'
	MOVWF	DATO
	CALL	MV
	RETURN
MVY6
	MOVLW	B'01100000'
	MOVWF	DATO
	CALL	MV
	RETURN
MVY7
	MOVLW	B'01110000'
	MOVWF	DATO
	CALL	MV
	RETURN
MVY8
	MOVLW	B'10000000'
	MOVWF	DATO
	CALL	MV
	RETURN
MVY9
	MOVLW	B'10010000'
	MOVWF	DATO
	CALL	MV
	RETURN
MVY12
	MOVLW	B'11000000'
	MOVWF	DATO
	CALL	MV
	RETURN

END