			LIST		P=16F873A
			INCLUDE		P16F873A.INC
			RS		EQU		1
			E		EQU		2
			STD		EQU		3
CBLOCK 20H
TIMBRES,PDel0,PDel1,PDel2,AUX
ENDC

			ORG			00
			GOTO		CONFIG_PORT
			ORG			04
			GOTO		INTER

;****************************************************************
;Retardo de 1 SEG
DELAY1S		movlw     .14       ; 1 set numero de repeticion  (C)
        	movwf     PDel0     ; 1 |
PLoop10  	movlw     .72       ; 1 set numero de repeticion  (B)
        	movwf     PDel1     ; 1 |
PLoop11  	movlw     .247      ; 1 set numero de repeticion  (A)
        	movwf     PDel2     ; 1 |
PLoop12  	clrwdt              ; 1 clear watchdog
        	decfsz    PDel2, 1  ; 1 + (1) es el tiempo 0  ? (A)
        	goto      PLoop12    ; 2 no, loop
        	decfsz    PDel1,  1 ; 1 + (1) es el tiempo 0  ? (B)
        	goto      PLoop11    ; 2 no, loop
        	decfsz    PDel0,  1 ; 1 + (1) es el tiempo 0  ? (C)
        	goto      PLoop10    ; 2 no, loop
PDelL11  	goto 	  PDelL12         ; 2 ciclos delay
PDelL12  	clrwdt              ; 1 ciclo delay
        	return              ; 2+2 Fin.

;****************************************************************
;Retardo de 100 ms
DELAY100		movlw     .110      ; 1 set numero de repeticion  (B)
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

;************************************************
;Retardo de 50 ms
DELAY50		movlw     .55       ; 1 set numero de repeticion  (B)
        	movwf     PDel0     ; 1 |
PLoop091  	movlw     .181      ; 1 set numero de repeticion  (A)
        	movwf     PDel1     ; 1 |
PLoop092  	clrwdt              ; 1 clear watchdog
        	clrwdt              ; 1 ciclo delay
        	decfsz    PDel1, 1  ; 1 + (1) es el tiempo 0  ? (A)
        	goto      PLoop092    ; 2 no, loop
        	decfsz    PDel0,  1 ; 1 + (1) es el tiempo 0  ? (B)
        	goto      PLoop091    ; 2 no, loop
        	return              ; 2+2 Fin.

;************************************************
;Retardo de 10 ms
DELAY10	  movlw     .8        ; 1 set numero de repeticion  (B)
          movwf     PDel0     ; 1 |
PLoop041  movlw     .249      ; 1 set numero de repeticion  (A)
          movwf     PDel1     ; 1 |
PLoop042  clrwdt              ; 1 clear watchdog
          clrwdt              ; 1 ciclo delay
          decfsz    PDel1, 1  ; 1 + (1) es el tiempo 0  ? (A)
          goto      PLoop042    ; 2 no, loop
          decfsz    PDel0,  1 ; 1 + (1) es el tiempo 0  ? (B)
          goto      PLoop041    ; 2 no, loop
PDelL041  goto 	  	PDelL042         ; 2 ciclos delay
PDelL042  clrwdt              ; 1 ciclo delay
          return              ; 2+2 Fin.	

;************************************************
;Retardo de 5 ms
DELAY5MS  movlw     .6        ; 1 set numero de repeticion  (B)
          movwf     PDel0     ; 1 |
PLoop031  movlw     .207      ; 1 set numero de repeticion  (A)
          movwf     PDel1     ; 1 |
PLoop032  clrwdt              ; 1 clear watchdog
          decfsz    PDel1, 1  ; 1 + (1) es el tiempo 0  ? (A)
          goto      PLoop032    ; 2 no, loop
          decfsz    PDel0,  1 ; 1 + (1) es el tiempo 0  ? (B)
          goto      PLoop031    ; 2 no, loop
PDelL031  goto 		PDelL032         ; 2 ciclos delay
PDelL032  clrwdt              ; 1 ciclo delay
          return              ; 2+2 Fin.	

;****************************************************************
CALLING		MOVLW		01H
			CALL		CONTROL
			MOVLW		83H
			CALL		CONTROL
			MOVLW		'C'
			CALL		DATO
			MOVLW		'A'
			CALL		DATO
			MOVLW		'L'
			CALL		DATO
			MOVLW		'L'
			CALL		DATO
			MOVLW		'I'
			CALL		DATO
			MOVLW		'N'
			CALL		DATO
			MOVLW		'G'
			CALL		DATO
PUNTOS		MOVLW		8AH
			CALL		CONTROL
			MOVLW		' '
			CALL		DATO
			MOVLW		' '
			CALL		DATO
			MOVLW		' '
			CALL		DATO
			CALL		DELAY50
			MOVLW		8AH
			CALL		CONTROL
			MOVLW		'.'
			CALL		DATO
			CALL		DELAY100
			MOVLW		'.'
			CALL		DATO
			CALL		DELAY100
			MOVLW		'.'
			CALL		DATO
			CALL		DELAY100
			RETURN
;****************************************************************
INTRO		MOVLW		01H
			CALL		CONTROL
			MOVLW		84H
			CALL		CONTROL
			MOVLW		'W'
			CALL		DATO
			MOVLW		'E'
			CALL		DATO
			MOVLW		'L'
			CALL		DATO
			MOVLW		'C'
			CALL		DATO
			MOVLW		'O'
			CALL		DATO
			MOVLW		'M'
			CALL		DATO
			MOVLW		'E'
			CALL		DATO
			MOVLW		0C3H
			CALL		CONTROL
			MOVLW		'T'
			CALL		DATO
			MOVLW		'E'
			CALL		DATO
			MOVLW		'L'
			CALL		DATO
			MOVLW		'E'
			CALL		DATO
			MOVLW		'M'
			CALL		DATO
			MOVLW		'A'
			CALL		DATO
			MOVLW		'N'
			CALL		DATO
			MOVLW		'D'
			CALL		DATO
			MOVLW		'O'
			CALL		DATO
			CALL		DELAY1S
			NOP
			CALL		DELAY1S
			RETURN

RESUMEN		MOVLW		01H
			CALL		CONTROL
			MOVLW		80H
			CALL		CONTROL
			MOVLW		'C'
			CALL		DATO
			MOVLW		'A'
			CALL		DATO
			MOVLW		'R'
			CALL		DATO
			MOVLW		'G'
			CALL		DATO
			MOVLW		'A'
			CALL		DATO
			MOVLW		.1
			ADDLW		.48
			CALL		DATO
			MOVLW		' '
			CALL		DATO
			MOVLW		.1
			ADDLW		.48
			CALL		DATO
			MOVLW		'>'
			CALL		DATO
			MOVLW		'O'
			CALL		DATO
			MOVLW		'N'
			CALL		DATO
			MOVLW		' '
			CALL		DATO
			MOVLW		.3
			ADDLW		.48
			CALL		DATO
			MOVLW		'>'
			CALL		DATO
			MOVLW		'O'
			CALL		DATO
			MOVLW		'F'
			CALL		DATO
			MOVLW		0C0H
			CALL		CONTROL
			MOVLW		'C'
			CALL		DATO
			MOVLW		'A'
			CALL		DATO
			MOVLW		'R'
			CALL		DATO
			MOVLW		'G'
			CALL		DATO
			MOVLW		'A'
			CALL		DATO
			MOVLW		.2
			ADDLW		.48
			CALL		DATO
			MOVLW		' '
			CALL		DATO
			MOVLW		.4
			ADDLW		.48
			CALL		DATO
			MOVLW		'>'
			CALL		DATO
			MOVLW		'O'
			CALL		DATO
			MOVLW		'N'
			CALL		DATO
			MOVLW		' '
			CALL		DATO
			MOVLW		.6
			ADDLW		.48
			CALL		DATO
			MOVLW		'>'
			CALL		DATO
			MOVLW		'O'
			CALL		DATO
			MOVLW		'F'
			CALL		DATO
			RETURN

TELEMANDO	MOVLW		01H
			CALL		CONTROL
			MOVLW		81H
			CALL		CONTROL
			MOVLW		'S'
			CALL		DATO
			MOVLW		'L'
			CALL		DATO
			MOVLW		'E'
			CALL		DATO
			MOVLW		'E'
			CALL		DATO
			MOVLW		'P'
			CALL		DATO
			MOVLW		' '
			CALL		DATO
			MOVLW		'T'
			CALL		DATO
			MOVLW		'E'
			CALL		DATO
			MOVLW		'L'
			CALL		DATO
			MOVLW		'E'
			CALL		DATO
			MOVLW		'M'
			CALL		DATO
			MOVLW		'A'
			CALL		DATO
			MOVLW		'N'
			CALL		DATO
			MOVLW		'D'
			CALL		DATO
			MOVLW		'O'
			CALL		DATO
			MOVLW		0C2H
			CALL		CONTROL
			MOVLW		'M'
			CALL		DATO
			MOVLW		'A'
			CALL		DATO
			MOVLW		'D'
			CALL		DATO
			MOVLW		'E'
			CALL		DATO
			MOVLW		' '
			CALL		DATO
			MOVLW		'F'
			CALL		DATO
			MOVLW		'O'
			CALL		DATO
			MOVLW		'R'
			CALL		DATO
			MOVLW		' '
			CALL		DATO
			MOVLW		'A'
			CALL		DATO
			MOVLW		'C'
			CALL		DATO
			MOVLW		'D'
			CALL		DATO
			RETURN

;****************************************************************
; Interrupcion generada por el primer timbre para empezar a ejecutar el programa principal del telemando
INTER		BCF			INTCON,INTF ; Borramos la interrupcion generada por RB0
			CLRF		INTCON ; Deshabilitamos las interrupciones por RB0
			MOVLW		.3
			MOVWF		TIMBRES ; Contador que se decrementa con lso timbres de la linea
			CALL		CALLING 
			RETFIE

EJECUTAR	BTFSC		PORTB,0 ; Chequeamos la señal del DTMF
			GOTO		ANTIREBOT
			GOTO		EJECUTAR

ANTIREBOT	BTFSC		PORTB,0
			GOTO		ANTIREBOT
			CALL		PUNTOS
			NOP
			CALL		PUNTOS
			DECFSZ		TIMBRES
			GOTO		EJECUTAR
			GOTO		SIGA
;****************************************************************
SIGA		BSF			PORTA,0 ; Contesta el telemando, activando el RELE
			CALL		DELAY100 ; Retardo para esperar que se estabilice el voltaje Dc de 12V
			BSF			PORTA,1 ; Habilitamos el DTMF
			CALL		INTRO
			CALL		RESUMEN
TELE		BTFSS		PORTB,STD ; Chequea la señal STD del DTMF para verificar que haya un dato
			GOTO		TELE
			CALL		REBOTS
			MOVF		PORTB,W
			ANDLW		0F0H ; AND para elimanr los datos errados que se puedan meter por culpa de la parte baja del registro portb
			MOVWF		AUX
			MOVLW		10H
			XORWF		AUX,W
			BTFSC		STATUS,Z
			BSF			PORTA,2 ; Enciende carga 1
			MOVLW		30H
			XORWF		AUX,W
			BTFSC		STATUS,Z
			BCF			PORTA,2 ; Apaga carga 1
			MOVLW		40H
			XORWF		AUX,W
			BTFSC		STATUS,Z
			BSF			PORTA,3 ; Enciende carga 2
			MOVLW		60H
			XORWF		AUX,W
			BTFSC		STATUS,Z
			BCF			PORTA,3 ; Apaga carga 2
			MOVLW		0A0H
			XORWF		AUX,W
			BTFSS		STATUS,Z
			GOTO		TELE
			GOTO		SALIR

REBOTS		BTFSC		PORTB,STD
			GOTO		REBOTS
			RETURN

SALIR		MOVLW		90H
			MOVWF		INTCON ; Habilitamos interrupciones por RB0
			BCF			PORTA,1 ; Desconecta el DTMF de la linea telefonica
			CALL		DELAY100
			BCF			PORTA,0 ; Apagar el Rele por lo que deshabilita el telemando
			CALL		TELEMANDO
			GOTO		PROG
			

;****************************************************************
; Configuracion LCD
INILCD	MOVLW		01H ; Borrado del LCD
		CALL		CONTROL
		MOVLW		03H ; Ir a Home del LCD
		CALL		CONTROL
		MOVLW		06H ; Entra al modo set del LCD
		CALL		CONTROL
		MOVLW		3CH ; Inicializamos LCD configurando bus de datos
		CALL		CONTROL
		MOVLW		0EH ; Display ON
		CALL		CONTROL
		CALL		DELAY100
		CALL		TELEMANDO
		GOTO		PROG

;****************************************************************
;Subrutina de control y datos display
CONTROL		BCF			PORTB,RS
			GOTO		DATO2
			NOP
DATO		BSF			PORTB,RS
DATO2		BSF			PORTB,E
			MOVWF		PORTC
			CALL		DELAY5MS
			BCF			PORTB,E
			CALL		DELAY5MS
			RETURN

;****************************************************************
; Configuracion de puertos y registros
CONFIG_PORT	NOP
			BANKSEL		TRISA
			MOVLW		06H
			MOVWF		ADCON1 ; Salidas Puerto A I/O digitales
			MOVLW		40H
			MOVWF		OPTION_REG ; Interrupciones por RB0 se dan con flanco ascendente
			MOVLW		90H
			MOVWF		INTCON ; Habilitar interrupciones por RB0
			CLRF		TRISC ; Puerto salidas al LCD
			MOVLW		B'11111001'
			MOVWF		TRISB ; Entradas delos datos del DTMF, salidas de RS y E del LCD y Intrada de Interrupcion por RB0
			MOVLW		B'11110000'
			MOVWF		TRISA ; Cargas RA2 y RA3, RA0 Rele, RA1 DTMF
			BANKSEL		PORTA
			CLRF		PORTA
			CLRF		PORTB
			CLRF		PORTC
			GOTO		INILCD

;****************************************************************
; Programa Principal			
PROG		NOP
			SLEEP
			NOP
			NOP
			GOTO		EJECUTAR
			GOTO		PROG
			
			END