			LIST P=16F876A
			INCLUDE	P16F876A.INC
				RS	EQU	2;	RA2
				E	EQU	3 ; RA3
CBLOCK 20H
CONTPAQ,PDel0,PDel1,PDel2,AUX,CENT,DEC
ENDC

			ORG			00; Se le dice al programa que inicie desde cero
			GOTO		CONFIG
			ORG         05

;****************************************				
;Retardo 5 ms
RETAR1  	movlw     .6        ; 1 set number of repetitions (B)
        	movwf     PDel0     ; 1 |
PLoop01 	movlw     .207      ; 1 set number of repetitions (A)
        	movwf     PDel1     ; 1 |
PLoop02 	clrwdt              ; 1 clear watchdog
        	decfsz    PDel1,1   ; 1 + (1) is the time over? (A)
        	goto      PLoop02   ; 2 no, loop
        	decfsz    PDel0,1   ; 1 + (1) is the time over? (B)
        	goto      PLoop01   ; 2 no, loop
PDelL1  	goto 	  PDelL02   ; 2 cycles delay
PDelL02 	clrwdt              ; 1 cycle delay
        	return              ; 2+2 Done

;****************************************
;Retardo 1 Seg
RETAR2  	movlw     .14       ; 1 set number of repetitions (C)
        	movwf     PDel0     ; 1 |
PLoop11  	movlw     .72       ; 1 set number of repetitions (B)
        	movwf     PDel1     ; 1 |
PLoop12  	movlw     .247      ; 1 set number of repetitions (A)
        	movwf     PDel2     ; 1 |
PLoop21  	clrwdt              ; 1 clear watchdog
        	decfsz    PDel2,1   ; 1 + (1) is the time over? (A)
        	goto      PLoop21   ; 2 no, loop
        	decfsz    PDel1,1   ; 1 + (1) is the time over? (B)
       	 	goto      PLoop12   ; 2 no, loop
       	 	decfsz    PDel0,1   ; 1 + (1) is the time over? (C)
        	goto      PLoop11   ; 2 no, loop
PDelL11  	goto	  PDelL21   ; 2 cycles delay
PDelL21  	clrwdt              ; 1 cycle delay
        	return              ; 2+2 Done

;**************************************************************
;Control y Datos LCD
CONTROL		BCF				PORTA,RS
			GOTO			DATO2

DATO		BSF				PORTA,RS
DATO2		BSF				PORTA,E
			MOVWF			PORTC
			CALL			RETAR1
			BCF				PORTA,E
			CALL			RETAR1
			RETURN

;*******************************************
;Inicializar el LCD
INICLCD		MOVLW		01H ; Borrado del LCD
			CALL		CONTROL
			MOVLW		03H ; Ir a Home del LCD
			CALL		CONTROL
			MOVLW		06H ; Entra al modO set del LCD
			CALL		CONTROL
			MOVLW		38H ; Inicializamos LCD configurando bus de datos
			CALL		CONTROL
			MOVLW		0FH ; Display ON y Cursor parpadeando
			CALL		CONTROL		
			CALL		RETAR1
			GOTO		INTRO

;*******************************************
; Copiar Intro en LCD
INTRO		MOVLW		01H
			CALL		CONTROL
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
			CALL		RETAR2
			NOP
NAME		MOVLW		0C1H
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
			CALL		DATO
			CALL		RETAR2
			GOTO		GALLETAS
		
;*******************************************
;Galletas
GALLETAS	MOVLW		01H
			CALL		CONTROL
			MOVLW		84H
			CALL		CONTROL
			MOVLW		'G'
			CALL		DATO
			MOVLW		'A'
			CALL		DATO
			MOVLW		'L'
			CALL		DATO
			MOVLW		'L'
			CALL		DATO
			MOVLW		'E'
			CALL		DATO
			MOVLW		'T'
			CALL		DATO
			MOVLW		'A'
			CALL		DATO
			MOVLW		'S'
			CALL		DATO
			CALL		RETAR1
			GOTO		PAQUET

;*******************************************
;Paquetes
PAQUET		MOVLW		0C2H
			CALL		CONTROL
			MOVLW		'P'
			CALL		DATO
			MOVLW		'A'
			CALL		DATO
			MOVLW		'Q'
			CALL		DATO
			MOVLW		'U'
			CALL		DATO
			MOVLW		'E'
			CALL		DATO
			MOVLW		'T'
			CALL		DATO
			MOVLW		'E'
			CALL		DATO
			MOVLW		'S'
			CALL		DATO
			MOVLW		' '
			CALL		DATO
			MOVLW		'0'
			CALL		DATO
			MOVLW		'0'
			CALL		DATO
			MOVLW		'0'			
			CALL		DATO
			GOTO		PROG

;*******************************************
;Contador de Galletas
CENTENAS	INCF		CENT
			GOTO		BINBCD

VISLCD		MOVLW		.245
			MOVWF		TMR0
			INCF		CONTPAQ
			MOVF		CONTPAQ,W
			MOVWF		AUX			
			CLRF		DEC

BINBCD		MOVLW		.100
			SUBWF		AUX,F
			BTFSC		STATUS,C
			GOTO		CENT
			MOVLW		.100
			ADDWF		AUX
DECENA		MOVLW		.10
			SUBWF		AUX
			BTFSC		STATUS,C
			GOTO		DECENA1
			MOVLW		.10
			ADDWF		AUX
			CALL		MOSTRAR
			RETURN
DECENA1		INCF		DEC
			GOTO		DECENA

;*******************************************
MOSTRAR		CALL		RETAR1
			CALL		RETAR1
			MOVLW		0CBH
			CALL		CONTROL
			MOVF		CENT,W
			ADDLW		.48
			CALL		DATO
			CALL		RETAR1
			MOVF		DEC,W
			ADDLW		.48
			CALL		DATO
			CALL		RETAR1
			MOVF		AUX,W
			ADDLW		.48
			CALL		DATO
			RETURN

;*******************************************
;Configuracion de puertos
CONFIG		NOP
			BANKSEL			TRISA
			MOVLW			38H
			MOVWF			OPTION_REG
			MOVLW			.06
			MOVWF			ADCON1
			MOVLW			.243
			MOVWF			TRISA
			CLRF			TRISC
			MOVLW			.162
			MOVF			INTCON
			MOVLW			.255
			MOVF			TRISB
			BCF				STATUS,RP0
			MOVLW			.245
			MOVWF			TMR0
			CLRF			PORTC
			CLRF			PORTA
			BSF				PORTA,4
			CLRF			CONTPAQ
			CLRF			CENT
			GOTO			INICLCD

;*******************************************

PROG		NOP
			MOVFW			TMR0
			XORLW			.255
			BTFSC			STATUS,Z
			CALL			VISLCD
			GOTO			PROG
			END
