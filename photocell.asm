;configuracion 
;status 
	DATO 	EQU 0X21
    varA    EQU 0x41
    varB    EQU 0x42
    varC    EQU 0x43
    VARDISPLAY    EQU 0x44
    cont    EQU 0x45 
    ADC     EQU 0x46
    CON     EQU 0X47
    CON2    EQU 0X48
    CON3    EQU 0X49
	GROUPNUMBER	EQU 0x50


INICIO
	ORG 0x00 ;se elige en que posicion de memoria empezaremos 
	GOTO START
START
	bcf STATUS,RP0 ;Ir banco 0
	bcf STATUS,RP1
	movlw b'01000001' ;A/D conversion Fosc/8
	movwf ADCON0
	;     	     7     6     5    4    3    2       1 0
	; 1Fh ADCON0 ADCS1 ADCS0 CHS2 CHS1 CHS0 GO/DONE � ADON
	bsf STATUS,RP0 ;Ir banco 1
	bcf STATUS,RP1
	movlw b'00000111'
	movwf OPTION_REG ;TMR0 preescaler, 1:156
	;                7    6      5    4    3   2   1   0 
	; 81h OPTION_REG RBPU INTEDG T0CS T0SE PSA PS2 PS1 PS0
	movlw b'00001110' ;A/D Port AN0/RA0
	movwf ADCON1
	;            7    6     5 4 3     2     1     0 
	; 9Fh ADCON1 ADFM ADCS2 � � PCFG3 PCFG2 PCFG1 PCFG0
	bsf TRISA,0 ;RA0 linea de entrada para el ADC
	clrf TRISB
	bcf STATUS,RP0 ;Ir banco 0
	bcf STATUS,RP1
	clrf PORTB ;Limpiar PORTB
    ;----------------------------------------------------------------------------
    BSF	STATUS,	5	; BIT SET FILE coloca el registro 5 del banco status en 1
	CLRF	TRISB
	MOVLW	B'00000001'	
	MOVWF	TRISC
	BCF	STATUS,	5	;Limpiamos el B CON BCF. TRIS ES PARA DIRECCIONES
	MOVLW	0X00
	MOVWF	PORTB	; L a W, y de W a F 
	BCF	STATUS,	RP0	
	MOVLW	0X01
	MOVWF	PORTB	; L a W, y de W a F
	
	MOVLW	B'00000100'
	MOVWF	varA
	MOVLW	B'00001000'
	MOVWF	varB
	MOVLW	B'00000101'
	MOVWF	varC
	MOVLW	B'00000000'
	MOVWF	VARDISPLAY
	MOVLW	B'00000000'
	MOVWF	cont
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
MENU 
	;MAYBE ADD A DELAY HERE :)
	BTFSC	PORTC,0	;PRESS THE BUTTON
	call	INC
	GOTO	SwitchCont
INC:
	INCF	cont,1
	BTFSC	cont,2
	call	ResetCont
	RETURN
ResetCont:
	MOVLW	B'00000000'
	MOVWF	cont
	RETURN
SwitchCont:
	BTFSC	cont,0
	GOTO	CI	
	GOTO	CP	
CP:
	BTFSC	cont,1
	GOTO	CASE3	;10
	GOTO	CASE1	;00
CI:
	BTFSC	cont,1
	GOTO	CASE4	;11
	GOTO	CASE2	;01
CASE1:
	MOVFW	varA
	MOVWF	VARDISPLAY
	GOTO	DECODIFICADOR
CASE2:
	MOVFW	varB
	MOVWF	VARDISPLAY
	GOTO	DECODIFICADOR
CASE3:
	MOVFW	varC
	MOVWF	VARDISPLAY
	GOTO	DECODIFICADOR
CASE4:
	MOVLW	GROUPNUMBER
	MOVWF	VARDISPLAY
	GOTO	DECODIFICADOR
;---------------------------------------------------------------------
					;DISPLAY ON PORT B WHATS IN VARDISPLAY
DECODIFICADOR:
    BTFSC   VARDISPLAY, 7
    GOTO    OCHOYNUEVE
	BTFSC	VARDISPLAY, 6
	GOTO	CUATROASIETE
	GOTO	CEROATRES
	GOTO	MENU
MV:	
	MOVF	DATO, W  
	MOVWF	PORTB	
	RETURN

CEROATRES:
	BTFSC	VARDISPLAY, 5
	GOTO	DOSYTRES
	GOTO	CEROYUNO
	GOTO	DECODIFICADOR
CEROYUNO:
	BTFSC	VARDISPLAY, 4
	GOTO	UNO
	MOVLW	B'01011111' ;ZERO
	MOVWF	DATO
	call	MV
	GOTO	DECODIFICADOR
UNO:
	MOVLW	B'00000110'
	MOVWF	DATO
	call	MV
	GOTO	DECODIFICADOR
DOSYTRES:
	BTFSC	VARDISPLAY, 4
	GOTO	TRES
	MOVLW	B'00111011';TWO
	MOVWF	DATO
	call	MV
	GOTO	DECODIFICADOR
TRES:	
	MOVLW	B'00101111'
	MOVWF	DATO
	call	MV
	GOTO    DECODIFICADOR

CUATROASIETE:	
	BTFSC	VARDISPLAY, 5
	GOTO	SEISYSIETE
	GOTO	CINCOYCUATRO
	GOTO	DECODIFICADOR
CINCOYCUATRO:
	BTFSC	VARDISPLAY, 4
	GOTO	CINCO
        MOVLW	B'01100110';SEIS
	MOVWF	DATO
	call	MV
	GOTO	DECODIFICADOR
CINCO:
        MOVLW	B'01101101'
	MOVWF	DATO
	call	MV
	GOTO	DECODIFICADOR
	
SEISYSIETE:	
	BTFSC	VARDISPLAY, 4
	GOTO	SIETE
        MOVLW	B'01111101';SEIS
	MOVWF	DATO
	call	MV
	GOTO	DECODIFICADOR
SIETE:
        MOVLW	B'00000111'
	MOVWF	DATO
	call	MV
	GOTO	DECODIFICADOR

OCHOYNUEVE:
        BTFSS   VARDISPLAY, 4
        GOTO    OCHO
        MOVLW	B'01101111';NUEVE
	MOVWF	DATO
	call	MV
	GOTO	DECODIFICADOR
OCHO:
	MOVLW	B'01111111'
	MOVWF	DATO
	call	MV
	GOTO    DECODIFICADOR
