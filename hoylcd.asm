	LIST P=16F876a
INCLUDE P16F876A.INC; Define registros y bits.
RS  EQU 2
E   EQU 3
CBLOCK 20H; Registros de proposito gral.
REG1,REG2,REG3,REG4,DATO_H,DATO_L,AUX,CONTA
ENDC

			ORG			00; Se le dice al programa que inicie desde cero
			GOTO		CONFIG
			ORG         05
		

RETAR1		MOVLW		.50
			MOVWF		REG2
RETARDO		DECFSZ		REG2
			GOTO		RETARDO
			RETURN
;********************************

RETAR2		MOVLW		.255
			MOVWF		REG2
RETA22		MOVLW       .255
			MOVWF       REG3
RETARDO1	DECFSZ		REG3
			GOTO		RETARDO1
            DECFSZ      REG2
			GOTO        RETA22
			RETURN
;*******************************
CONTROL		BCF			PORTA,RS
			GOTO		DATO2
DATO		BSF			PORTA,RS
DATO2		BSF			PORTA,3
			MOVWF		PORTC
			CALL		RETAR1
			BCF			PORTA,3
			CALL		RETAR1
			RETURN

;************************************
CONFIG		NOP
			BANKSEL		TRISA
			MOVLW		.255
			MOVWF		TRISB
			CLRF		TRISC
			MOVLW		B'11110011'; RA3>E LCD, RA2>RS LCD
			MOVWF		TRISA
			BSF			TRISB,0
			BCF			OPTION_REG,6
			MOVLW		B'10010000'
			MOVWF		INTCON
            MOVLW       06
			MOVWF      	ADCON1
			BANKSEL		PORTA
			CLRF		REG1
			CLRF		PORTA
			CLRF		PORTC
			GOTO		INILCD




INILCD		MOVLW		38H; Inicializamos LCD configurando bus de datos
			CALL		CONTROL
			MOVLW		0FH ; Configura # de lineas, cursor, y tamaño segmento
			CALL		CONTROL
			GOTO		INTRO
	
NOMBRE		MOVLW       01
			CALL        CONTROL
			MOVLW		81H
			CALL		CONTROL
			MOVLW		'V'
			CALL		DATO
			MOVLW		'I'
			CALL		DATO
			MOVLW		'C'
			CALL		DATO
			MOVLW		'T'
			CALL		DATO
			MOVLW		'O'
			CALL		DATO
			MOVLW		'R'
			CALL		DATO
			MOVLW		' '
			CALL		DATO
			MOVLW		'H'
			CALL		DATO
			MOVLW		'I'
			CALL		DATO
			MOVLW		'G'
			CALL		DATO
			MOVLW		'U'
			CALL		DATO
			MOVLW		'I'
			CALL		DATO
			MOVLW		'T'
			CALL		DATO
			MOVLW		'A'
			CALL        DATO
			CALL       RETAR2
			GOTO	   INTRO

INTRO	    MOVLW       01
			CALL        CONTROL
			MOVLW		82H
			CALL		CONTROL
			MOVLW		'$'
			CALL		DATO
			MOVLW		'I'
			CALL		DATO
			MOVLW		'L'
			CALL		DATO
			MOVLW		'L'
			CALL		DATO
			MOVLW		'U'
			CALL		DATO
			MOVLW		'M'
			CALL		DATO
			MOVLW		'I'
			CALL		DATO
			MOVLW		'N'
			CALL		DATO
			MOVLW		'A'
			CALL		DATO
			MOVLW		'T'
			CALL		DATO
			MOVLW		'I'
			CALL		DATO
			MOVLW		'$'
			CALL		DATO
			CALL       RETAR2
			GOTO		NOMBRE
			END
