	LIST P=16F876A
	INCLUDE P16F876A.INC; Define registros y bits.
		RS	EQU	2
		E	EQU	3
CBLOCK 20H; Registros de proposito gral.
AUX,PDel0,PDel1,PDel2,CENT,DEC
ENDC

			ORG	00
			GOTO	CONFIG
			ORG	05

;***********************************************************
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

;***********************************************************

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

;**************************************************************

;Conversion BIN a DEC	
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

;**************************************************************
; Se inicia la conversion. No se dio el tiempo d retardo de 10Us
; aproximadamente que necesita el conversor A/D para configuarcion pues de antemano
;se habia hecho en CONFIG
CONVER		BSF		ADCON0,2; Se inicia la conversion
PREG		BTFSC	ADCON0,2; Se pregunta si termino
			GOTO	PREG
			BANKSEL	TRISA; Cambiamos al banco 1 para pasar la conversion a W
			MOVF	ADRESL,W; Pasamos lo de ADRESL a W
			BANKSEL	PORTA; Cambiamos al Banco 0 donde trabajamos
			MOVWF	AUX
			CALL	BINBCD
			CALL	VISUAL
			RETURN
		
;******************************************************************
;Nombre
NAME	MOVLW	01H
		CALL	CONTROL
		MOVLW	81H
		CALL	CONTROL
		MOVLW	'V'
		CALL	DATO
		MOVLW	'I'
		CALL	DATO
		MOVLW	'C'
		CALL	DATO
		MOVLW	'T'
		CALL	DATO
		MOVLW	'O'
		CALL	DATO
		MOVLW	'R'
		CALL	DATO
		MOVLW	' '
		CALL	DATO
		MOVLW	'H'
		CALL	DATO
		MOVLW	'I'
		CALL	DATO
		MOVLW	'G'
		CALL	DATO
		MOVLW	'U'
		CALL	DATO
		MOVLW	'I'
		CALL	DATO
		MOVLW	'T'
		CALL	DATO
		MOVLW	'A'
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

;**************************************************************
;Visualizacion de temperatura
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

;**************************************************************
;Comandos y datos LCD
CONTROL		BCF			PORTA,RS
			GOTO		DATO2
			NOP
DATO		BSF			PORTA,RS
DATO2		BSF			PORTA,E
			MOVWF		PORTC
			CALL		RETAR1
			BCF			PORTA,E
			CALL		RETAR1
			RETURN

;**************************************************************
;Configuracion de puertos
CONFIG	NOP
		BANKSEL		TRISA
		CLRF		ADRESL
		MOVLW		.255
		MOVWF		TRISB; Configuramos el REG del puerto B como entradas
		CLRF		TRISC; Configuramos el REG del puerto C como salidas
		MOVLW		B'11110011'; RA3>E LCD, RA2>RS LCD
		MOVWF		TRISA; Configuramos el REG del puerto A como salidas solo en
		BSF			TRISB,0;RA2 y RA3 Que son los E y RS del LCD
		BCF			OPTION_REG,7; Desabilitamos PULL UP
		CLRF		INTCON; Desabilitamos interrupciones
		MOVLW  		8EH
		MOVWF  		ADCON1; Configuramos ADCON1 para RA0>AN0 como analogo y 
		BANKSEL		PORTA; las demas como digitales, si hay dudas mirar ADCON1 y 0
		MOVLW		0C1H; en el datasheet,a demas de justificar a izquierda
		MOVWF		ADCON0; Configurams el modulo A/D con CH 0 osea AN0>RA0
		CLRF		PORTA; a demas con F=FRC interna.
		CLRF		PORTC
		CLRF		CENT
		CLRF		DEC
		CLRF		AUX
		GOTO		INILCD

;***************************************************************

;Inicializar LCD
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
		CALL		NAME
		GOTO		PROG

;******************************************************************

PROG	NOP
		CALL	RETAR3
		CALL	CONVER
		CALL	RETAR3 ; Se ejecuta el programa el cual actualiza la temperatura aproximadamente
		GOTO	PROG; cada 2 Seg.

		END


;******************************************************************
