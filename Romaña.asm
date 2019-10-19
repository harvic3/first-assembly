		LIST		P=16F877A
		INCLUDE 	P16F877A.INC
		RS		EQU		1
		E		EQU		2	
CBLOCK	20H
AUX,TEMP,CENT,DEC,AUX1,PDel0,PDel1,PDel2
ENDC

			ORG			00
			GOTO		CONFI_PORT
			ORG			05

;***********************************************
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
;***********************************************
;Retardo de 100 ms
RETAR2 			movlw     .110      ; 1 set numero de repeticion  (B)
        		movwf     PDel0     ; 1 |
PLoop051 	    movlw     .181      ; 1 set numero de repeticion  (A)
       			movwf     PDel1     ; 1 |
PLoop052 		clrwdt              ; 1 clear watchdog
        		clrwdt              ; 1 ciclo delay
       			decfsz    PDel1, 1  ; 1 + (1) es el tiempo 0  ? (A)
       			goto      PLoop052    ; 2 no, loop
       			decfsz    PDel0,  1 ; 1 + (1) es el tiempo 0  ? (B)
       			goto      PLoop051    ; 2 no, loop
PDelL051 		goto	  PDelL052         ; 2 ciclos delay
PDelL052 		goto 	  PDelL053         ; 2 ciclos delay
PDelL053 		clrwdt              ; 1 ciclo delay
       			return              ; 2+2 Fin.
;***********************************************
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
;***********************************************
;Comandos y datos LCD
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
;***********************************************
; Introduccion
INTRO		MOVLW		01H
			CALL		CONTROL
			MOVLW		82H
			CALL		CONTROL
			MOVLW		'C'
			CALL		DATO
			MOVLW		'O'
			CALL		DATO
			MOVLW		'N'
			CALL		DATO
			MOVLW		'T'
			CALL		DATO
			MOVLW		'R'
			CALL		DATO
			MOVLW		'O'
			CALL		DATO
			MOVLW		'L'
			CALL		DATO
			MOVLW		' '
			CALL		DATO
			MOVLW		'T'
			CALL		DATO
			MOVLW		'E'
			CALL		DATO
			MOVLW		'M'
			CALL		DATO
			MOVLW		'P'
			MOVLW		0C2H
			CALL		CONTROL
			MOVLW		'T'
			CALL		DATO
			MOVLW		'e'
			CALL		DATO
			MOVLW		'm'
			CALL		DATO
			MOVLW		'p'
			CALL		DATO
			MOVLW		'.'
			CALL		DATO
			MOVLW		' '
			CALL		DATO
			MOVLW		' '
			CALL		DATO
			MOVLW		' '
			CALL		DATO
			MOVLW		' '
			CALL		DATO
			MOVLW		' '
			CALL		DATO
			MOVLW		0DFH
			CALL		DATO
			MOVLW		'C'
			CALL		DATO
			BSF			T2CON,2 ; Encendemos el TM2 osea el PWM
			GOTO		PROG
;***********************************************
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
;***********************************************
; Visualizar la temperatura actual
VISUAL		MOVLW		0C9H
			CALL		CONTROL
			MOVF		CENT,W
			ADDLW		.48
			CALL		DATO
			MOVF		DEC,W
			ADDLW		.48
			CALL		DATO
			MOVF		AUX,W
			ADDLW		.48
			CALL		DATO
			MOVLW		0DFH
			CALL		DATO
			MOVLW		'C'
			CALL		DATO
			RETURN			
;***********************************************
; Se inicia la conversion. No se dio el tiempo de retardo de 10Us
; aproximadamente que necesita el conversor A/D para configuarcion pues de antemano
;se habia hecho en CONFIG
CONVER		BSF		ADCON0,2; Se inicia la conversion
PREG		BTFSC	ADCON0,2; Se pregunta si termino
			GOTO	PREG
			NOP
			BANKSEL	TRISA; Cambiamos al banco 1 para pasar la conversion a W
			MOVF	ADRESL,W; Pasamos lo de ADRESL a W
			BANKSEL	PORTA; Cambiamos al Banco 0 donde trabajamos
			MOVWF	TEMP
			MOVWF	AUX
			CALL	BINBCD
			CALL	VISUAL
			RETURN
;***********************************************
; Comparar el valor de la temperatura actaul  #
COMPARAR	NOP
			MOVLW		.20
			SUBWF		TEMP,F
			BTFSC		STATUS,C ;S o C
			GOTO		BAJAR
			MOVF		TEMP,W
			XORLW		.0
			BTFSS		STATUS,Z
			GOTO		SUBIR
			RETURN
;***********************************************
; Ejecutar ajustes con respecto a la temperatura
; Baja el PWM para aumentar la Temperatura #
BAJAR			MOVF		AUX1,W
				XORLW		00H
				BTFSC		STATUS,Z ;S o C
				RETURN
				MOVLW		.1
				SUBWF		AUX1,F
				MOVF		AUX1,W
				MOVWF		CCPR1H
				BSF			STATUS,C
				RRF			AUX1
				BSF			STATUS,C
				RRF			AUX1
				MOVF		AUX1,W
				MOVWF		CCPR1L
				RETURN

; Sube el PWM para disminuir la temperatura  #
SUBIR			MOVF		AUX1,W
				XORLW		.100
				BTFSC		STATUS,Z ;S o C
				RETURN
				MOVLW		.1
				ADDWF		AUX1,F
				MOVF		AUX1,W
				MOVWF		CCPR1H
				BSF			STATUS,C
				RRF			AUX1
				BSF			STATUS,C
				RRF			AUX1
				MOVF		AUX1,W
				MOVWF		CCPR1L
				RETURN

;***********************************************
CONFI_PORT	NOP
			BANKSEL		TRISA
			CLRF		INTCON ; Se deshabilito interrupciones
			MOVLW		.142
			MOVWF		ADCON1 ; Seleccionar RA0 Analogo y Los otros bits Digitales
			MOVLW		B'11111001'
			MOVWF		TRISA ; Configurar puerto A como entrada analoga y salidas RS y E del LCD
			CLRF		TRISB ; Puerto B como salidas al LCD
			MOVLW		B'11111011'
			MOVWF		TRISC ; Puerto C como salida del PWM que es el CCP2 correspondiente al RC2
			MOVLW		.24
			MOVWF		PR2 ; Configuramos Periodo del PWM para 100 uS con Frecuencia de 10KHz
			BANKSEL		PORTA
			CLRF		T2CON ; Configuracion de Prescaler del TMR2 como 1
			MOVLW		.1
			MOVWF		ADCON0 ; Configuarmos CHANNEL de Conversion y Frecuencia de muestreo
			MOVLW		0FH
			MOVWF		CCP1CON ; Configuramos el MODO de PWM
			MOVLW		.1
			MOVWF		CCPR1L ; Iniciamos el PWM al minimo
			CLRF		PORTB
			CLRF		PORTA
			CLRF		AUX
			GOTO		INILCD
;***********************************************
;Inicializar LCD
INILCD		MOVLW		01H ; Borrado del LCD
			CALL		CONTROL
			MOVLW		03H ; Ir a Home del LCD
			CALL		CONTROL
			MOVLW		06H ; Entra al modo set del LCD
			CALL		CONTROL
			MOVLW		3CH ; Inicializamos LCD configurando bus de datos de 8 bits
			CALL		CONTROL
			MOVLW		0EH ; Display ON sin cursor parpadeando
			CALL		CONTROL
			CALL		RETAR3
			GOTO		INTRO
;***********************************************
;Programa
PROG		NOP
			CALL		CONVER
			NOP
			CALL		COMPARAR
			NOP
			CALL		RETAR2
			NOP
			GOTO		PROG			
			END