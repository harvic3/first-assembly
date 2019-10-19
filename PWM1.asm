; Los BITS 0 al 3 del PORTA son las Salidas de las filas del Teclado.
; Los BITS 4 al 7 del PORTC son las Entradas para las columnas del Teclado.
; Los BITS 0 y 1 del PORTA son el RS y E del LCD.
; Puerto D salidas para LCD.
		LIST		P=16F876A
		INCLUDE 	P16F876A.INC
		RS		EQU		0
		E		EQU		3	
CBLOCK	20H
AUX,AUX1,TECLA,HABIL,DATO1,TIME,PDel0,PDel1,PDel2,CENT,DEC,MIL,AUX2
ENDC

			ORG			00
			GOTO		CONFIGURAR
			ORG			04
			BTFSC		INTCON,INTF
			GOTO		EXTINT
			GOTO		CRUCEX0

;************************************************
;Teclas
COLUMNA4		ADDWF		PCL,F
				NOP
				RETLW		.1
				RETLW		.4
				RETLW		.7
				RETURN
				
COLUMNA5		ADDWF		PCL,F
				NOP
				RETLW		.2
				RETLW		.5
				RETLW		.8
				RETLW		.0

COLUMNA6		ADDWF		PCL,F
				NOP
				RETLW		.3
				RETLW		.6
				RETLW		.9
				RETURN

COLUMNA7		RETURN

;************************************************
; Interrupcion Externa RB0
EXTINT		BSF		T2CON,2 ; Enciende el PWM
			BCF		INTCON,1 ; Deshabilita el BIT de Interrupciones por RB0
			MOVLW	.60
			MOVWF	TIME
			BSF		T1CON,0 ; Enciende TMR1 para ineterupcion por Timer 1
			BANKSEL	TRISA
			MOVLW	0C0H
			MOVWF	INTCON ; Deshabilitamos interrupciones por RB0
			BANKSEL	PORTA
			RETFIE

CRUCEX0		BCF		PIR1,0 ; Deshbilita el Bit de inerrupciones por TMR1
			DECFSZ	TIME
			GOTO	CONTINUE
			NOP
			BANKSEL	TRISA
			MOVLW	0D0H
			MOVWF	INTCON ; Habilitamos interrupciones por RB0
			BANKSEL	PORTA
			NOP
CONTINUE	RETFIE
			
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

;************************************************			
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

;************************************************
;Comandos y datos LCD
CONTROL		BCF			PORTC,RS
			BANKSEL		TRISA
			CLRF		TRISB
			BANKSEL		PORTA
			GOTO		DATO2
			
DATO		NOP
			BCF			PORTA,5 ; Habilitar el RB0 como Salida
			NOP
			BANKSEL		TRISA
			CLRF		TRISB
			BANKSEL		PORTA
			NOP
			BSF			PORTC,RS
DATO2		BSF			PORTC,E
			MOVWF		PORTB
			CALL		RETAR1
			BCF			PORTC,E
			BANKSEL		TRISA
			MOVLW		.255
			MOVWF		TRISB
			BANKSEL		PORTA
			BSF			PORTA,5 ; Habilitar el RB0 como Entrada
			CALL		RETAR1			
			RETURN

;************************************************
NAME		MOVLW		01H
			CALL		CONTROL
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
			CALL		DATO
			CALL		RETAR3
INTRO		MOVLW		0C1H
			CALL		CONTROL
			MOVLW		'P'
			CALL		DATO
			MOVLW		'O'
			CALL		DATO
			MOVLW		'T'
			CALL		DATO
			MOVLW		'E'
			CALL		DATO
			MOVLW		'N'
			CALL		DATO
			MOVLW		'C'
			CALL		DATO
			MOVLW		'I'
			CALL		DATO
			MOVLW		'A'
			CALL		DATO
			MOVLW		' '
			CALL		DATO
			MOVLW		' '
			CALL		DATO
			MOVLW		'0'
			CALL		DATO
			MOVLW		'0'
			CALL		DATO
			MOVLW		'0'
			CALL		DATO
			MOVLW		'%'
			CALL		DATO
			GOTO		PROG

;************************************************
;Conversion BIN a DEC	
CENTENA			INCF		CENT ; Numero de centenas
				MOVF		CENT,W
				XORLW		.10
				BTFSS		STATUS,Z ; Salta si Z = 1 donde el resultado es 0
				RETURN
				NOP
MILES			INCF		MIL ; Numero de miles
				CLRF		CENT
           		RETURN
                
BINBCD			CLRF		DEC
				MOVF		AUX1,W
				XORLW		.100
				BTFSC		STATUS,Z
				CALL		CENTENA
DECENA			MOVLW		.10
				SUBWF		AUX1,F
				BTFSC		STATUS,C
				GOTO		DECENA1
				MOVLW		.10
				ADDWF		AUX1 ; Ajusta AUX al valor positivo
				CALL		RETAR1
				CALL		VISUAL
				RETURN		
DECENA1			INCF		DEC ; Numero de decenas
				MOVF		DEC,W
				XORLW		.10
				BTFSC		STATUS,Z
				CLRF		DEC
				GOTO		DECENA

VISUAL			MOVLW		0CBH
				CALL		CONTROL
				MOVF		CENT,W
				CALL		DATO
				MOVF		DEC,W
				CALL		DATO
				MOVF		AUX1,W
				CALL		DATO
				RETURN

;************************************************
; Teclado Matriz
AJUSTE			MOVLW		.254
				MOVWF		AUX2
				RETURN

TECLADO			BTFSS		PORTC,4
				GOTO		TECLADO
TECLADO1		BSF			STATUS,C
				BTFSS		AUX2,4
				CALL		AJUSTE
				MOVF		AUX2,W
				MOVWF		PORTA
				CLRF		TECLA
				INCF		TECLA
CHECKFIL		BTFSS		PORTC,4
				GOTO		ANTIREBOTS4
				INCF		TECLA,F
				BTFSS		PORTC,5
				GOTO		ANTIREBOTS5
				INCF		TECLA,F
				BTFSS		PORTC,6
				GOTO		ANTIREBOTS6
				INCF		TECLA,F
				BTFSS		PORTC,7
				NOP;GOTO		ANTIREBOTS7
				RLF			AUX2
				GOTO		TECLADO1		
			
ANTIREBOTS4		NOP
ESPERA4			BTFSS		PORTC,4
				GOTO		ESPERA4
				MOVF		TECLA,W
				CALL		COLUMNA4
				DECFSZ		HABIL
				GOTO		VALOR1
				GOTO		VALOR2

ANTIREBOTS5		NOP
ESPERA5			BTFSS		PORTC,5
				GOTO		ESPERA5
				MOVF		TECLA,W
				CALL		COLUMNA5
				DECFSZ		HABIL
				GOTO		VALOR1
				GOTO		VALOR2

ANTIREBOTS6		NOP
ESPERA6			BTFSS		PORTC,6
				GOTO		ESPERA6
				MOVF		TECLA,W
				CALL		COLUMNA6
				DECFSZ		HABIL
				GOTO		VALOR1
				GOTO		VALOR2
				
ANTIREBOTS7		NOP
ESPERA7			BTFSS		PORTC,7
				GOTO		ESPERA7
				MOVF		TECLA,W
				CALL		COLUMNA7
				DECFSZ		HABIL
				GOTO		VALOR1
				GOTO		VALOR2

VALOR1			CLRF		DATO1
				MOVWF		AUX
				ADDWF		AUX,F
				ADDWF		AUX,F
				ADDWF		AUX,F
				ADDWF		AUX,F
				ADDWF		AUX,F
				ADDWF		AUX,F
				ADDWF		AUX,F
				ADDWF		AUX,F
				ADDWF		AUX,F
				MOVF		AUX,W
				MOVWF		DATO1
				MOVWF		AUX1
				CALL		BINBCD
				GOTO		TECLADO		
			
VALOR2			ADDWF		DATO1
				MOVF		DATO1,W
				MOVWF		AUX1
				CALL		BINBCD
				MOVLW		.2
				MOVWF		HABIL
				NOP	
MULTIPLICAR		BCF			PORTA,4
				MOVF		DATO1,W
				MOVWF		CCPR1L
				BANKSEL		TRISA
				MOVLW		0D0H
				MOVWF		INTCON ; Habilitamos interrupciones por RB0
				BANKSEL		PORTA
				GOTO		PROG

;************************************************
;Inicializar LCD
INILCD		MOVLW		01H ; Borrado del LCD
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
			GOTO		NAME

;************************************************
;Configuracion de puertos
CONFIGURAR		NOP
				BANKSEL		TRISA
				CLRF		OPTION_REG
				MOVLW		06H
				MOVWF		ADCON1; ADCON1 como digital
				MOVLW		B'11110000'
				MOVWF		TRISC ; Puerto C como salida PWM y Control de RS y E para el LCD a demas de entradas para el Teclado Matriz
				CLRF		TRISB ; Puerto B como Entradas para Interrupcion por RB0 Y  a la vez como salidas para LCD
				MOVLW		B'11010000'
				MOVWF		TRISA ; Puerto A como salidas hacia el teclado matricial
				MOVLW		0C0H
				MOVWF		INTCON ; Habilitamos Interrupciones por TMR1
				MOVLW		03H
				MOVWF		T2CON ; Configuramos Prescaler de 16 para TMR2
				MOVLW		01H
				MOVWF		PIE1 ; Habilita Interupciones por TMR1
				MOVLW		.131
				MOVWF		PR2 ; Valor que me da el periodo del PWM 8.33mS
				BANKSEL		PORTA
				CLRF		PORTA
				CLRF		PORTB
				CLRF		PORTC
				MOVLW		30H
				MOVWF		T1CON ; Configuramos TMR1 con prescaler de 8
				MOVLW		3CH
				MOVWF		CCP1CON ; Configurar prescaler y LSB del TMR2
				MOVLW		.254
				MOVWF		AUX2
				MOVLW		.2
				MOVWF		HABIL
				CLRF		CCPR1L
				BCF			PORTA,4
				GOTO		INILCD

;************************************************

PROG			NOP
				BTFSS		PORTC,4
				GOTO		TECLADO
				GOTO		PROG

				END
