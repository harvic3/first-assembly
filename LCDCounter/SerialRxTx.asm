		LIST P=16F876A
		INCLUDE P16F876A.INC
			RS	EQU	2
			E	EQU	3
CBLOCK 20H
AUX,PDel0,PDel1,PDel2,CENT,DEC,HABIL,DATOS,DIRECC
ENDC

		ORG		00H
		GOTO	CONFIG
		ORG		05H

;---------------------------------------------
;Retardo 1 Seg
RETAR3  	movlw     .14       ; 1 set number of repetitions (C)
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

;---------------------------------------------
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

;---------------------------------------------
;Datos de presentacion Display
SERIAL	MOVLW	01H
		CALL	CONTROL
		MOVLW	81H
		CALL	CONTROL
		MOVLW	'T'
		CALL	DATO
		MOVLW	'R'
		CALL	DATO
		MOVLW	'A'
		CALL	DATO
		MOVLW	'N'
		CALL	DATO
		MOVLW	'S'
		CALL	DATO
		MOVLW	'E'
		CALL	DATO
		MOVLW	'R'
		CALL	DATO
		MOVLW	'I'
		CALL	DATO
		MOVLW	'A'
		CALL	DATO
		MOVLW	'L'
		CALL	DATO
		MOVLW	' '
		CALL	DATO
		MOVLW	'P'
		CALL	DATO
		MOVLW	'I'
		CALL	DATO
		MOVLW	'C'
		CALL	DATO
		MOVLW	0C3H
		CALL	CONTROL
		MOVLW	'T'
		CALL	DATO
		MOVLW	'E'
		CALL	DATO
		MOVLW	'M'
		CALL	DATO
		MOVLW	'P'
		CALL	DATO
		MOVLW	' '
		CALL	DATO
		MOVLW	'W'
		CALL	DATO
		MOVLW	'a'
		CALL	DATO
		MOVLW	'i'
		CALL	DATO
		MOVLW	't'
		CALL	DATO
		MOVLW	'.'
		CALL	DATO
		CALL	RETAR3
		NOP
		CALL	RETAR3
		MOVLW	0C8H
		CALL	CONTROL
		MOVLW	'0'
		CALL	DATO
		MOVLW	'0'
		CALL	DATO
		MOVLW	'0'
		CALL	DATO
		MOVLW	0DFH
		CALL	DATO
		MOVLW	'C'
		CALL	DATO
		RETURN

;--------------------------------------------
;Conversion BINBCD
CENTENA		INCF	CENT ; Numero de centenas
			GOTO	SALTO                
BINBCD		CLRF	CENT
			CLRF	DEC
			MOVF	AUX,W
SALTO		XORLW	.100
			BTFSC	STATUS,Z
			CALL	CENTENA
DECENA		MOVLW	.10
			SUBWF	AUX,F
			BTFSC	STATUS,C
			GOTO	DECENA1
			MOVLW	.10
			ADDWF	AUX ; Ajusta AUX al valor positivo
			RETURN	
DECENA1		INCF	DEC ; Numero de decenas
			MOVF	DEC,W
			XORLW	.10
			BTFSC	STATUS,Z
			CLRF	DEC
			GOTO	DECENA

;--------------------------------------------
;Mostrar Temperatura
VISUAL	MOVLW	0C8H
		CALL	CONTROL
		MOVF	CENT,W
		ADDLW	.48
		CALL	DATO
		CALL	RETAR1
		MOVF	DEC,W
		ADDLW	.48
		CALL	DATO
		CALL	RETAR1
		MOVF	AUX,W
		ADDLW	.48
		CALL	DATO
		CALL	RETAR1
		RETURN

;--------------------------------------------
;Subrutina de control y datos display
CONTROL		BCF			PORTA,RS
			GOTO		DATO2
			NOP
DATO		BSF			PORTA,RS
DATO2		BSF			PORTA,E
			MOVWF		PORTB
			CALL		RETAR1
			BCF			PORTA,E
			CALL		RETAR1
			RETURN

;--------------------------------------------
;Subrutina de transmision serial
TRANSM	NOP
		BANKSEL		TRISA
		BSF			TXSTA,TXEN
		NOP
CONFIR	BTFSC		TXSTA,TRMT
		GOTO		CONFIR
		BANKSEL		PORTA
		RETURN

;--------------------------------------------
;Subrutina de conversion A/D
CONVER		BSF		ADCON0,2; Se inicia la conversion
PREG		BTFSC	ADCON0,2; Se pregunta si termino
			GOTO	PREG
			BANKSEL	TRISA; Cambiamos al banco 1 para pasar la conversion a W
			MOVF	ADRESL,W; Pasamos lo de ADRESL a W
			BANKSEL	PORTA; Cambiamos al Banco 0 donde trabajamos
			MOVWF	AUX
			MOVF	AUX,W
			MOVWF	TXREG
			CALL	TRANSM
			CALL	BINBCD
			CALL	VISUAL
			RETURN

;----------------------------------------------

CONFIG	NOP
		BANKSEL		TRISA
		MOVLW		.192
		MOVWF		INTCON
		MOVLW		.12
		MOVWF		SPBRG
		MOVLW		B'11111111'
		MOVWF		TRISC
		MOVLW		04H
		MOVWF		TXSTA
		MOVLW		.243
		MOVWF		TRISA
		CLRF		OPTION_REG
		CLRF		TRISB
		MOVLW  		8EH
		MOVWF		ADCON1
		BANKSEL		PORTA
		CLRF		PIR1
		MOVLW		0D1H
		MOVWF		ADCON0
		MOVLW		.144
		MOVWF		RCSTA
		CLRF		PORTA
		CLRF		PORTB
		CLRF		PORTC
		CLRF		TXREG
		CLRF		RCREG
		CLRF		PORTC
		MOVLW		0C0H
		MOVWF		DIRECC		
		NOP
INILCD	MOVLW		01H ; Borrado del LCD
		CALL		CONTROL
		MOVLW		03H ; Ir a Home del LCD
		CALL		CONTROL
		MOVLW		06H ; Entra al modo set del LCD
		CALL		CONTROL
		MOVLW		3CH ; Inicializamos LCD configurando bus de datos
		CALL		CONTROL
		MOVLW		0EH ; Display ON y Cursor parpadeando
		CALL		CONTROL
		CALL		RETAR3
		GOTO		INICIO

;---------------------------------------------

ESCRIBIR	MOVF		DIRECC,W
			CALL		CONTROL
			MOVF		DATOS,W
			CALL		DATO
			INCF		DIRECC
			
			RETURN			

INICIO	MOVLW		0C0H
		MOVWF		DIRECC	
		MOVLW		.26
		MOVWF		HABIL
		MOVLW		01H
		CALL		CONTROL
		MOVLW		81H
		CALL		CONTROL
		MOVLW		'C'
		CALL		DATO
		MOVLW		'o'
		CALL		DATO
		MOVLW		'n'
		CALL		DATO
		MOVLW		'n'
		CALL		DATO
		MOVLW		'e'
		CALL		DATO
		MOVLW		'c'
		CALL		DATO
		MOVLW		't'
		CALL		DATO
		MOVLW		'i'
		CALL		DATO
		MOVLW		'n'
		CALL		DATO
		MOVLW		'g'
		CALL		DATO
		MOVLW		' '
		CALL		DATO
		MOVLW		'.'
		CALL		DATO
		MOVLW		'.'
		CALL		DATO
		MOVLW		'.'
		CALL		DATO
		NOP
RECIBIR	BTFSS   	PIR1,RCIF
		GOTO    	RECIBIR
		MOVF		RCREG,W
		MOVWF		DATOS
		CALL		ESCRIBIR
		MOVF		DATOS,W
		BCF			PIR1,RCIF
		XORLW		'0'
		BTFSS		STATUS,Z
		GOTO		RECIBIR
		MOVLW		0C2H
		CALL		CONTROL
		MOVLW		'C'
		CALL		DATO
		MOVLW		'o'
		CALL		DATO
		MOVLW		'n'
		CALL		DATO
		MOVLW		'e'
		CALL		DATO
		MOVLW		'x'
		CALL		DATO
		MOVLW		'i'
		CALL		DATO
		MOVLW		'ó'
		CALL		DATO
		MOVLW		'n'
		CALL		DATO
		MOVLW		' '
		CALL		DATO
		MOVLW		'O'
		CALL		DATO
		MOVLW		'k'
		CALL		DATO
		MOVLW		'.'
		CALL		DATO
		CALL		RETAR3		
		CALL		SERIAL
		GOTO		PROG

;----------------------------------------------

PROG	DECFSZ		HABIL
		GOTO		PROG1
		GOTO		INICIO
PROG1	CALL		CONVER
		CALL		RETAR3
		GOTO		PROG
		
		END
