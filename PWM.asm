; Los BITS 0 al 3 del PORTA son las Salidas de las filas del Teclado.
; Los BITS 4 al 7 del PORTC son las Entradas para las columnas del Teclado.
; Los BITS 0 y 1 del PORTA son el RS y E del LCD.
; Puerto D salidas para LCD.
		LIST		P=16F876A
		INCLUDE 	P16F876A.INC
		RS		EQU		6
		E		EQU		7	
CBLOCK	20H
AUX,AUX1,TIME,PDel0,PDel1,PDel2,DEC,CENT,REG
ENDC

			ORG			00
			GOTO		CONFIGURAR
			ORG			04
			BTFSC		INTCON,INTF
			GOTO		EXTINT
			GOTO		CRUCEX0

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

;***********************************************************
;Retardo 1/2 Segundo
RETAR2   movlw     .239      ; 1 set numero de repeticion  (B)
         movwf     PDel0     ; 1 |
PLoop17  movlw     .232      ; 1 set numero de repeticion  (A)
         movwf     PDel1     ; 1 |
PLoop27  clrwdt              ; 1 clear watchdog
PDelL17  goto 	   PDelL27         ; 2 ciclos delay
PDelL27  goto	   PDelL37         ; 2 ciclos delay
PDelL37  clrwdt              ; 1 ciclo delay
         decfsz    PDel1,1  ; 1 + (1) es el tiempo 0  ? (A)
         goto      PLoop27    ; 2 no, loop
         decfsz    PDel0,1 ; 1 + (1) es el tiempo 0  ? (B)
         goto      PLoop17    ; 2 no, loop
PDelL47  goto 	   PDelL57         ; 2 ciclos delay
PDelL57  goto	   PDelL67         ; 2 ciclos delay
PDelL67  goto 	   PDelL77         ; 2 ciclos delay
PDelL77  clrwdt              ; 1 ciclo delay
         return              ; 2+2 Fin.

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
			GOTO		DATO2
			
DATO		NOP
			BSF			PORTC,RS
DATO2		BSF			PORTC,E
			MOVWF		REG
			ANDLW		0FH
			MOVWF		PORTA
			MOVF		REG,W
			ANDLW		0F0H
			MOVWF		PORTB			
			CALL		RETAR1
			BCF			PORTC,E
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
CENTENA		INCF		CENT ; Numero de centenas
			CLRF		DEC
			CLRF		AUX1
			GOTO		VISUAL
                
BINBCD		CLRF		DEC
			CLRF		CENT
			MOVF		AUX1,W
			XORLW		.100
			BTFSC		STATUS,Z
			GOTO		CENTENA
DECENA		MOVLW		.10
			SUBWF		AUX1,F
			BTFSC		STATUS,C
			GOTO		DECENA1
			MOVLW		.10
			ADDWF		AUX1 ; Ajusta AUX al valor positivo
			CALL		VISUAL
			RETURN		
DECENA1		INCF		DEC ; Numero de decenas
			MOVF		DEC,W
			XORLW		.10
			BTFSC		STATUS,Z
			CLRF		DEC
			GOTO		DECENA

VISUAL		MOVLW		0CBH
			CALL		CONTROL
			MOVF		CENT,W
			ADDLW		.48
			CALL		DATO
			MOVF		DEC,W
			ADDLW		.48
			CALL		DATO
			MOVF		AUX1,W
			ADDLW		.48
			CALL		DATO
			MOVLW		'%'
			CALL		DATO
			RETURN

;************************************************
; Aumentar Disminuir
ESTADO			BTFSC		PORTC,3
				GOTO		ESTADO
				BSF			PORTC,0
				BTFSC		PORTC,4
				GOTO		BAJAR
				BTFSC		PORTC,5
				GOTO		SUBIR
				BTFSS		PORTC,3
				GOTO		ESTADO
				BCF			PORTC,0
				GOTO		PROG1
				
BAJAR			BTFSC		PORTC,4
				GOTO		BAJAR
				MOVF		AUX,W
				XORLW		00H
				BTFSC		STATUS,Z
				GOTO		ESTADO
				MOVLW		02H
				SUBWF		AUX,F
				GOTO		EJECUTAR

SUBIR			BTFSC		PORTC,5
				GOTO		SUBIR
				MOVF		AUX,W
				XORLW		64H
				BTFSC		STATUS,Z
				GOTO		ESTADO
				MOVLW		02H
				ADDWF		AUX,F
				GOTO		EJECUTAR
			
EJECUTAR		MOVF		AUX,W
				MOVWF		AUX1
				MOVWF		CCPR1L
				CALL		BINBCD
				BANKSEL		TRISA
				MOVLW		0D0H
				MOVWF		INTCON ; Habilitamos interrupciones por RB0
				BANKSEL		PORTA
				GOTO		ESTADO

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
				CLRF		OPTION_REG; La INT/RB0 se da por 1
				MOVLW		06H
				MOVWF		ADCON1; ADCON1 como digital
				MOVLW		B'00111010'
				MOVWF		TRISC ; Puerto C como salida PWM y Control de RS y E para el LCD, Activar, Subir y Bajar y led
				MOVLW		0FH
				MOVWF		TRISB ; Puerto B como Entradas para Interrupcion por RB0 Y  a la vez como salidas para LCD
				MOVLW		B'11110000'
				MOVWF		TRISA ; Puerto A como Salidas para el LCD
				MOVLW		0C0H
				MOVWF		INTCON ; Habilitamos Interrupciones por TMR1
				MOVLW		03H
				MOVWF		T2CON ; Configuramos Prescaler de 16 para TMR2
				MOVLW		01H
				MOVWF		PIE1 ; Habilita Interupciones por TMR1
				MOVLW		.130
				MOVWF		PR2 ; Valor que me da el periodo del PWM 8.33mS
				BANKSEL		PORTA
				CLRF		PORTA
				CLRF		PORTB
				CLRF		PORTC
				MOVLW		30H
				MOVWF		T1CON ; Configuramos TMR1 con prescaler de 8
				MOVLW		0CH
				MOVWF		CCP1CON ; Configurar prescaler y LSB del TMR2
				CLRF		CCPR1L
				CLRF		CCPR1H
				CLRF		AUX
				CLRF		AUX1
				GOTO		INILCD

;************************************************

PROG1			BTFSC		PORTC,3; Pulso de Activacion
				GOTO		PROG1
PROG			NOP
				BTFSC		PORTC,3 ; Tecla para Habiliatar el Aumento y Decremento del PWM
				GOTO		ESTADO
				GOTO		PROG

				END
