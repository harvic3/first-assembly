; RB2 es el por donde entra la señal del IC DTMF que me indica cuando hay un dato en la salida
; RB0 es el pin que se activa por una interrupcion provocada por la linea y abrira la linea despues de 5 timbres
; RB4 - RB7 Son los bits de entrada de los datos DTMF
; El PORTC es el puerto por donde se controlaran los Perifericos a encender o apagar.
; RA0  Salida que activa el rele para habilitar la linea
; RA1 es el pin que habilita el DTMF
; RA2 Salida de los tonos hacia la linea

		LIST P=16F876A
		INCLUDE P16F876A.INC
CBLOCK 20H
AUX,PASE1,PASE2,CONTA,PDel0,PDel1,PDel2,PASS1,PASS2,CONTMR,HABIL
ENDC

			ORG			00
			GOTO		CONFIG_PORT
			ORG			04
			BTFSC		INTCON,INTF ; Interrupcion por RB0 sino por TMR1
			GOTO		INTER
			GOTO		INTTMR1

;************************************************
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

;************************************************
;Retardo 500 mS
DELAY500  movlw     .239      ; 1 set numero de repeticion  (B)
          movwf     PDel0     ; 1 |
PLoop19	  movlw     .232      ; 1 set numero de repeticion  (A)
          movwf     PDel1     ; 1 |
PLoop29   clrwdt              ; 1 clear watchdog
PDelL19   goto 		PDelL29         ; 2 ciclos delay
PDelL29   goto 		PDelL39         ; 2 ciclos delay
PDelL39   clrwdt              ; 1 ciclo delay
          decfsz    PDel1,1  ; 1 + (1) es el tiempo 0  ? (A)
          goto      PLoop29    ; 2 no, loop
          decfsz    PDel0,1 ; 1 + (1) es el tiempo 0  ? (B)
          goto      PLoop19    ; 2 no, loop
PDelL49   goto 	   	PDelL59         ; 2 ciclos delay
PDelL59   goto		PDelL69         ; 2 ciclos delay
PDelL69   goto		PDelL79         ; 2 ciclos delay
PDelL79   clrwdt              ; 1 ciclo delay
          return              ; 2+2 Fin.

;************************************************
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
DELAY5    movlw     .6        ; 1 set numero de repeticion  (B)
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

;************************************************
;Retardo de 4 ms
DELAY4	  movlw     .5        ; 1 set numero de repeticion  (B)
          movwf     PDel0     ; 1 |
PLoop021  movlw     .159      ; 1 set numero de repeticion  (A)
          movwf     PDel1     ; 1 |
PLoop022  clrwdt              ; 1 clear watchdog
          clrwdt              ; 1 ciclo delay
          decfsz    PDel1, 1  ; 1 + (1) es el tiempo 0  ? (A)
          goto      PLoop022    ; 2 no, loop
          decfsz    PDel0,  1 ; 1 + (1) es el tiempo 0  ? (B)
          goto      PLoop021    ; 2 no, loop
          return              ; 2+2 Fin.

;************************************************
;Retardo de 3 ms
DELAY3    movlw    	.4        ; 1 set numero de repeticion  (B)
          movwf    	PDel0     ; 1 |
PLoop011  movlw    	.186      ; 1 set numero de repeticion  (A)
          movwf    	PDel1     ; 1 |
PLoop012  clrwdt              ; 1 clear watchdog
          decfsz  	PDel1, 1  ; 1 + (1) es el tiempo 0  ? (A)
          goto    	PLoop012    ; 2 no, loop
          decfsz  	PDel0,  1 ; 1 + (1) es el tiempo 0  ? (B)
          goto    	PLoop011    ; 2 no, loop
PDelL011  goto 		PDelL012         ; 2 ciclos delay
PDelL012  clrwdt              ; 1 ciclo delay
          return              ; 2+2 Fin.	

;************************************************
;Retardo de 20 ms
DELAY2	  movlw     .21       ; 1 set numero de repeticion  (B)
          movwf     PDel0     ; 1 |
PLoop001  movlw     .237      ; 1 set numero de repeticion  (A)
          movwf     PDel1     ; 1 |
PLoop002  clrwdt              ; 1 clear watchdog
          decfsz    PDel1, 1  ; 1 + (1) es el tiempo 0  ? (A)
          goto      PLoop002    ; 2 no, loop
          decfsz    PDel0,  1 ; 1 + (1) es el tiempo 0  ? (B)
          goto      PLoop001    ; 2 no, loop
PDelL001  goto 	    PDelL002         ; 2 ciclos delay
PDelL002  clrwdt              ; 1 ciclo delay
          return              ; 2+2 Fin.

;************************************************
;Interrupcion al detectar 5 timbres en la linea
INTER		BCF			PORTB,1 ; Apaga LED indicador de SLEEP
			BCF			INTCON,INTF ; Deshabilita el bit de interrupcion generada
			BANKSEL		TRISA
			MOVLW		0C0H
			MOVWF		INTCON ; Desactiva interrupciones por RB0
			BANKSEL		PORTA
			MOVLW		.30 ; Se carga CONTMR para el ciclo de 15 Segundos que controlan el funcionamento del telemando.
			MOVWF		CONTMR
			CLRF		TMR1L
			CLRF		TMR1H
			MOVLW		.6
			MOVWF		CONTA
			BSF			HABIL,3 ; Habilita ejecucion del programa mientras pasan los primeros 15 Segundos
			BSF			HABIL,2 ; Habilita TMR1 Para solo 15 Segundos antes de contestar el telemando
			BSF			T1CON,0 ; Enciende TMR1 para ciclo de conteo de 15 seg.
			BSF			HABIL,0 ; Habilita la secuencia del programa para que salga de la 
			RETFIE				; interrupcion y vuelva al proceso del telemando.

SEGUIR		BTFSC		PORTB,0 ; Espera los timbres de la linea para activarse
			GOTO		ANTIREBOTS
			BTFSC		HABIL,3 ; Bandera de habilitacion para el arreglo del programa cuando se dan los 15 Segundos por TMR1 y el telemando aun no contesta
			GOTO		SEGUIR
			GOTO		SALIR
			
ANTIREBOTS	BTFSC		PORTB,0
			GOTO		ANTIREBOTS
			CALL		DELAY500
			DECFSZ		CONTA
			GOTO		SEGUIR
			GOTO		SEGUIR2

SEGUIR2		BSF			PORTA,0 ; Abrir el canal de la linea telefonica. Activa el rele
			BCF			HABIL,2 ; Deshabilita el TMR1 para 15 Seg por lo tanto lo habilita para minuto y medio
			CALL		DELAY100
			MOVLW		.150
			MOVWF		CONTMR ; Se carga CONTMR con el valor que me dara un ciclo de Minuto y Medio
			BSF			T1CON,0 ; Activa TIMER1 para empezar a contar, retardo de 1 1/2 minuto
			BSF			PORTA,1 ; Habilita el detector de tonos DTMF
			CALL		TONO1
			NOP
			CALL		TONO1			
			NOP
			CALL		TONO1
			MOVLW		.4
			MOVWF		CONTA
INICIO		DECFSZ		CONTA ; Numero de Intentos que tiene una persona con la contraseña al entrar al telemando
			GOTO		PROC0
			GOTO		FAILED
					
PROC0		CALL		TONO3
			NOP
			CALL		TONO3
			NOP
			CALL		TONO3
			BTFSS		PORTB,2 ; Chequea señal entrante del DTMF
			GOTO		PROC0
			MOVF		PORTB,W
			MOVWF		AUX
			MOVLW		0F0H
			ANDWF		AUX,W
			XORLW		0C0H ;verifica que sea # si no vuelve a preguntar
			BTFSS		STATUS,Z ; Si es # entra a comprovar la contraseña para asi ir al menu de seleccion del telemando
			GOTO		PROC0
			BSF			PORTA,3
			NOP
PROC1		BTFSS		PORTB,2
			GOTO		PROC1
			BCF			PORTA,3
			CALL		ANTIREBOTES
			CALL		TONO2
			NOP
			CALL		TONO2
			NOP
			CALL		TONO2
			MOVF		PORTB,W
			MOVWF		AUX
			MOVLW		0F0H
			ANDWF		AUX,W
			CLRF		PASE1
			MOVWF		PASE1 ; Primer Valor del PASE1, 4 BITs mas Significativos
			NOP
PROC2		BTFSS		PORTB,2
			GOTO		PROC2
			BSF			PORTA,3
			CALL		ANTIREBOTES
			CALL		TONO2
			NOP
			CALL		TONO2
			NOP
			CALL		TONO2
			MOVF		PORTB,W
			MOVWF		AUX
			MOVLW		0F0H
			ANDWF		AUX,F
			SWAPF		AUX
			MOVF		AUX,W
			ADDWF		PASE1 ; Segundo Valor del PASE1, 4 BITs menos Significativos
			NOP
PROC3		BTFSS		PORTB,2 ; Chequea señal entrante del DTMF, verifica que sea * si no vuelve a preguntar
			GOTO		PROC3
			BCF			PORTA,3
			CALL		ANTIREBOTES
			CALL		TONO2
			NOP
			CALL		TONO2
			NOP
			CALL		TONO2
			MOVF		PORTB,W
			MOVWF		AUX
			MOVLW		0F0H
			ANDWF		AUX,W
			CLRF		PASE2
			MOVWF		PASE2 ; Primer Valor del PASE2, 4 BITs mas Significativos
			NOP
PROC4		BTFSS		PORTB,2
			GOTO		PROC4
			BSF			PORTA,3
			CALL		ANTIREBOTES
			CALL		TONO2
			NOP
			CALL		TONO2
			NOP
			CALL		TONO2
			MOVF		PORTB,W
			MOVWF		AUX
			MOVLW		0F0H
			ANDWF		AUX,F
			SWAPF		AUX
			MOVF		AUX,W
			ADDWF		PASE2 ; Segundo Valor del PASE2, 4 BITs menos Significativos
			GOTO		VERIFICAR ; Para verificar que los datos con los gauardados en la EEProm sean Iguales

ANTIREBOTES	BTFSC		PORTB,2
			GOTO		ANTIREBOTES
			BCF			PORTA,3
			RETURN

VERIFICAR	NOP
			MOVF		PASE1,W
			XORWF		PASS1,W
			BTFSS		STATUS,Z
			GOTO		ERRORPASS
			MOVF		PASE2,W
			XORWF		PASS2,W
			BTFSS		STATUS,Z
			GOTO		ERRORPASS
			CALL		TONO2
			BSF			PORTA,3
			CALL		TONO2
			BCF			PORTA,3
			CALL		TONO2
			BSF			PORTA,3
			CALL		TONO2
			BCF			PORTA,3
			CALL		TONO2
			BSF			PORTA,3
			CALL		TONO2
			BCF			PORTA,3
			GOTO		SELECCION

ERRORPASS	CALL		TONO3 ; Error de contraseña, solo dara tres oportunidades las cuales seran 
			BSF			PORTA,3				  ; controladas por el INICIO.
			CALL		TONO3
			BCF			PORTA,3
			CALL		TONO3
			BSF			PORTA,3
			CALL		TONO3
			BCF			PORTA,3
			CALL		TONO3
			BSF			PORTA,3
			CALL		TONO3
			BCF			PORTA,3
			GOTO		INICIO

SELECCION	CALL		TONO2
			BSF			PORTA,3
			CALL		TONO2
			BCF			PORTA,3
			CALL		TONO2
			BSF			PORTA,3
			CALL		TONO2
			BCF			PORTA,3
			CALL		TONO2
SELECT		BTFSS		PORTB,2 ; Menu de seleccion del telamando, para la opcion 1 se 
			GOTO		SELECCION ; podra enecender perifericos, para la opcion 2 se podran
			CALL		ANTIREBOTES 
			MOVF		PORTB,W ; apagar perifericos, para el # saldra del menu y para 
			MOVWF		AUX     ; 5 cambiara la contraseña.
			MOVLW		0F0H
			ANDWF		AUX,F
			MOVLW		10H
			XORWF		AUX,W
			BTFSC		STATUS,Z
			GOTO		ON
			MOVLW		20H
			XORWF		AUX,W
			BTFSC		STATUS,Z
			GOTO		OFF
			MOVLW		0C0H
			XORWF		AUX,W
			BTFSC		STATUS,Z
			GOTO		SALIR
			MOVLW		50H
			XORWF		AUX,W
			BTFSC		STATUS,Z
			GOTO		CHANGPASS
			GOTO		SELECT
			
FAILED		BCF			PORTA,1 ; Desactiva la recepcion de tonos del DTMF
			BCF			PORTA,0	; Bloquea el sistema por 5 Minutos por ingresar mal la contraseña por tres veces.
			MOVLW		.255
			MOVWF		CONTA
CICLOCK		CALL		DELAY1S
			DECFSZ		CONTA
			GOTO		CICLOCK
			BANKSEL		TRISA
			MOVLW		0D0H
			MOVWF		INTCON
			BANKSEL		PORTA
			NOP
			RETFIE

ON			CALL		TONO2 ; Subrutina de ENCENDIDO de perifericos enumerados desde 0 hasta 7 que se controlan 
			NOP				  ; con los numeros 0 al 7 desde el telefono y cuya salida es el puerto c del pic
			CALL		TONO2
			NOP
			CALL		TONO2
			NOP
			CALL		TONO2
			BTFSS		PORTB,2
			GOTO		ON
			CALL		ANTIREBOTES
			MOVF		PORTB,W
			ANDLW		0F0H
			MOVWF		AUX
			MOVLW		0A0H
			XORWF		AUX,W
			BTFSC		STATUS,Z
			GOTO		ON0
			MOVLW		10H
			XORWF		AUX,W
			BTFSC		STATUS,Z
			GOTO		ON1
			MOVLW		20H
			XORWF		AUX,W
			BTFSC		STATUS,Z
			GOTO		ON2
			MOVLW		30H
			XORWF		AUX,W
			BTFSC		STATUS,Z
			GOTO		ON3
			MOVLW		40H
			XORWF		AUX,W
			BTFSC		STATUS,Z
			GOTO		ON4
			MOVLW		50H
			XORWF		AUX,W
			BTFSC		STATUS,Z
			GOTO		ON5
			MOVLW		60H
			XORWF		AUX,W
			BTFSC		STATUS,Z
			GOTO		ON6
			MOVLW		70H
			XORWF		AUX,W
			BTFSC		STATUS,Z
			GOTO		ON7
			MOVLW		0C0H
			XORWF		AUX,W
			BTFSC		STATUS,Z
			GOTO		VOLVER
			CALL		DELAY100
			GOTO		ON
			
ON0			CALL		TONO2
			NOP
			CALL		TONO2
			BSF			PORTC,0
			CALL		DELAY100; Enciende el periferico conectado al RC0
			CALL		TONO5  ; y asi sucesivamente hasta 7
			NOP
			CALL		TONO5
			GOTO		ON

ON1			CALL		TONO2
			NOP
			CALL		TONO2
			BSF			PORTC,1
			CALL		DELAY100
			CALL		TONO5
			NOP
			CALL		TONO5
			GOTO		ON

ON2			CALL		TONO2
			NOP
			CALL		TONO2
			BSF			PORTC,2
			CALL		DELAY100
			CALL		TONO5
			NOP
			CALL		TONO5
			GOTO		ON

ON3			CALL		TONO2
			NOP
			CALL		TONO2
			BSF			PORTC,3
			CALL		DELAY100
			CALL		TONO5
			NOP
			CALL		TONO5
			GOTO		ON

ON4			CALL		TONO2
			NOP
			CALL		TONO2
			BSF			PORTC,4
			CALL		DELAY100
			CALL		TONO5
			NOP
			CALL		TONO5
			GOTO		ON

ON5			CALL		TONO2
			NOP
			CALL		TONO2
			BSF			PORTC,5
			CALL		DELAY100
			CALL		TONO5
			NOP
			CALL		TONO5
			GOTO		ON

ON6			CALL		TONO2
			NOP
			CALL		TONO2
			BSF			PORTC,6
			CALL		DELAY100
			CALL		TONO5
			NOP
			CALL		TONO5
			GOTO		ON

ON7			CALL		TONO2
			NOP
			CALL		TONO2
			BSF			PORTC,7
			CALL		DELAY100
			CALL		TONO5
			NOP
			CALL		TONO5
			GOTO		ON

VOLVER		CALL		TONO2
			NOP
			CALL		TONO2
			NOP
			CALL		TONO2
			CALL		DELAY100
			CALL		TONO1
			NOP
			CALL		TONO1
			GOTO		SELECCION

OFF			CALL		TONO2 ; Subrutina de APAGADO de perifericos enumerados desde 0 hasta 7 que se controlan 
			NOP				  ; con los numeros 0 al 7 desde el telefono y cuya salida es el puerto c del pic
			CALL		TONO2
			NOP
			CALL		TONO2
			NOP
			CALL		TONO2
			BTFSS		PORTB,2
			GOTO		OFF
			CALL		ANTIREBOTES
			MOVF		PORTB,W
			ANDLW		0F0H
			MOVWF		AUX
			MOVLW		0A0H
			XORWF		AUX,W
			BTFSC		STATUS,Z
			GOTO		OFF0
			MOVLW		10H
			XORWF		AUX,W
			BTFSC		STATUS,Z
			GOTO		OFF1
			MOVLW		20H
			XORWF		AUX,W
			BTFSC		STATUS,Z
			GOTO		OFF2
			MOVLW		30H
			XORWF		AUX,W
			BTFSC		STATUS,Z
			GOTO		OFF3
			MOVLW		40H
			XORWF		AUX,W
			BTFSC		STATUS,Z
			GOTO		OFF4
			MOVLW		50H
			XORWF		AUX,W
			BTFSC		STATUS,Z
			GOTO		OFF5
			MOVLW		60H
			XORWF		AUX,W
			BTFSC		STATUS,Z
			GOTO		OFF6
			MOVLW		70H
			XORWF		AUX,W
			BTFSC		STATUS,Z
			GOTO		OFF7
			MOVLW		0C0H
			XORWF		AUX,W
			BTFSC		STATUS,Z
			GOTO		VOLVER1
			CALL		DELAY100
			GOTO		OFF
			
OFF0		CALL		TONO2
			NOP
			CALL		TONO2
			BCF			PORTC,0; Apaga el periferico conectado al RC0
			CALL		DELAY100
			CALL		TONO4  ; y asi sucesivamente hasta 7
			NOP
			CALL		TONO4
			GOTO		OFF

OFF1		CALL		TONO2
			NOP
			CALL		TONO2
			BCF			PORTC,1
			CALL		DELAY100
			CALL		TONO4
			NOP
			CALL		TONO4
			GOTO		OFF

OFF2		CALL		TONO2
			NOP
			CALL		TONO2
			BCF			PORTC,2
			CALL		DELAY100
			CALL		TONO4
			NOP
			CALL		TONO4
			GOTO		OFF

OFF3		CALL		TONO2
			NOP
			CALL		TONO2
			BCF			PORTC,3
			CALL		DELAY100
			CALL		TONO4
			NOP
			CALL		TONO4
			GOTO		OFF

OFF4		CALL		TONO2
			NOP
			CALL		TONO2
			BCF			PORTC,4
			CALL		DELAY100
			CALL		TONO4
			NOP
			CALL		TONO4
			GOTO		OFF

OFF5		CALL		TONO2
			NOP
			CALL		TONO2
			BCF			PORTC,5
			CALL		DELAY100
			CALL		TONO4
			NOP
			CALL		TONO4
			GOTO		OFF

OFF6		CALL		TONO2
			NOP
			CALL		TONO2
			BCF			PORTC,6
			CALL		DELAY100
			CALL		TONO4
			NOP
			CALL		TONO4
			GOTO		OFF

OFF7		CALL		TONO2
			NOP
			CALL		TONO2
			BCF			PORTC,7
			CALL		DELAY100
			CALL		TONO4
			NOP
			CALL		TONO4
			GOTO		OFF

VOLVER1		CALL		TONO2
			NOP
			CALL		TONO2
			NOP
			CALL		TONO2
			CALL		DELAY100
			CALL		TONO1
			NOP
			CALL		TONO1
			GOTO		SELECCION

INTTMR1		CLRF		PIR1 ; Desactivamos la Interrupcion generada por TIMER1
			CLRF		TMR1L
			CLRF		TMR1H
			BTFSC		HABIL,2 ; Bandera del ciclo de 15 Segundos
			GOTO		CIC15SEG
			DECFSZ		CONTMR ; Decrementamos el contador para hacer los 150 ciclos de 0.5 segundos
			GOTO		SIGA
			NOP
			GOTO		SALIR

CIC15SEG	DECFSZ		CONTMR ; Ciclo de 15 Segundos mientras contesta.
			GOTO		SIGA
			BCF			HABIL,3 ; Bit de arreglo del programa para quitar la interrupcion final del ciclo de 15 segundos por TMR1
			RETFIE		; Para que no haya una inconsistencia en el programa			
			
SIGA		BSF			T1CON,0
			RETFIE			
			
SALIR		BCF			PORTA,1 ; Deshabilita el detector de tonos DTMF
			CALL		TONO1 ; Salir se activa cuando la tecla # es precionada en el telefono indicando  
			NOP				  ; que no se realizara alguna modificacion del menu del telemando
			CALL		TONO1
			NOP
			CALL		TONO1
			NOP
			CALL		TONO1
			NOP
			CALL		TONO1
			NOP
			CALL		TONO1
			CALL		DELAY100
			BCF			PORTA,0 ; Deshabilita el Telemando
			BANKSEL		TRISA
			MOVLW		0D0H
			MOVWF		INTCON ; Activa nuevamente interrupciones por RB0
			BANKSEL		PORTA
			NOP
			CLRF		HABIL ; Borra el registro de las banderas que controlan las inetrrupciones.
			GOTO		PROG
			
CHANGPASS	CLRF		PASS1
			CLRF		PASS2
			CALL		TONO2 ; Cambio de contraseña se activara cuando pulse la tecla 5 estando en el menu de seleccion
			NOP
			CALL		TONO2
			NOP
			CALL		TONO2
			NOP
VER			CALL		TONO2
			BTFSS		PORTB,2
			GOTO		VER
			CALL		ANTIREBOTES
			MOVF		PORTB,W
			ANDLW		0F0H
			MOVWF		PASS1
			CALL		TONO2
			NOP
			CALL		TONO2
			NOP
			CALL		TONO2
			NOP
			CALL		TONO2
VER1		BTFSS		PORTB,2
			GOTO		VER1
			CALL		ANTIREBOTES
			MOVF		PORTB,W
			ANDLW		0F0H
			MOVWF		AUX
			SWAPF		AUX
			MOVF		AUX,W
			ADDWF		PASS1
			CALL		TONO2
			NOP
			CALL		TONO2
			NOP
			CALL		TONO2
			NOP
			CALL		TONO2
VER2		BTFSS		PORTB,2
			GOTO		VER2
			CALL		ANTIREBOTES
			MOVF		PORTB,W
			ANDLW		0F0H
			MOVWF		PASS2
			CALL		TONO2
			NOP
			CALL		TONO2
			NOP
			CALL		TONO2
			NOP
			CALL		TONO2
VER3		BTFSS		PORTB,2
			GOTO		VER3
			CALL		ANTIREBOTES
			MOVF		PORTB,W
			ANDLW		0F0H
			MOVWF		AUX
			SWAPF		AUX
			MOVF		AUX,W
			ADDWF		PASS2
			CALL		TONO2
			NOP
			CALL		TONO2
			NOP
			CALL		TONO2
			NOP
			CALL		TONO2
			NOP
			CALL		TONO2
			NOP
			CALL		TONO2
			NOP
			CALL		TONO2
			CALL		DELAY100
			GOTO		SELECCION			

;************************************************
;Tonos de aviso			
TONO1		BSF			PORTA,2 ; Tono de Inicio, se usa solo cuando inicia el telemando y al salir
			BSF			PORTA,3
			CALL		DELAY10
			BCF			PORTA,2
			BCF			PORTA,3
			CALL		DELAY2
			BSF			PORTA,2
			BSF			PORTA,3
			CALL		DELAY10
			BCF			PORTA,2
			BCF			PORTA,3
			CALL		DELAY5
			BSF			PORTA,2
			BSF			PORTA,3
			CALL		DELAY10
			BCF			PORTA,2
			BCF			PORTA,3
			CALL		DELAY3
			BSF			PORTA,2
			BSF			PORTA,3
			CALL		DELAY10
			BCF			PORTA,2
			BCF			PORTA,3
			RETURN

TONO2		BSF			PORTA,2 ; Tono de acceso y de comandos correctos
			BSF			PORTA,3
			CALL		DELAY5
			BCF			PORTA,2
			BCF			PORTA,3
			CALL		DELAY10
			BSF			PORTA,2
			BSF			PORTA,3
			CALL		DELAY5
			BCF			PORTA,2
			BCF			PORTA,3
			CALL		DELAY10
			BSF			PORTA,2
			BSF			PORTA,3
			CALL		DELAY2
			BCF			PORTA,2
			BCF			PORTA,3
			RETURN

TONO3		BSF			PORTA,2	; Tono de Errores
			BCF			PORTA,3
			CALL		DELAY10
			BCF			PORTA,2
			BCF			PORTA,3
			CALL		DELAY4
			BSF			PORTA,2
			BSF			PORTA,3
			CALL		DELAY10
			BCF			PORTA,2
			BCF			PORTA,3
			RETURN

TONO4		BSF			PORTA,2 ; Apagado
			BSF			PORTA,3
			CALL		DELAY50
			BCF			PORTA,2
			BCF			PORTA,3
			RETURN

TONO5		BSF			PORTA,2	; Encendido
			BSF			PORTA,3
			CALL		DELAY100
			BCF			PORTA,2
			BCF			PORTA,3
			RETURN

;************************************************

CONFIG_PORT	NOP
			CLRF		PORTB
			BANKSEL		TRISA
			CLRF		OPTION_REG
			MOVLW		0D0H
			MOVWF		INTCON ; Habilitar interrupciones globales y por RB0
			MOVLW		.6
			MOVWF		ADCON1
			MOVLW		B'11111101' ; Puerto B como Entradas, RB0 Interupcion de la linea
			MOVWF		TRISB ; RB2, RB4 - RB7 Señales del DTMF								  
			MOVLW		B'11110000'; Pin RA0 salida que activa el rele para contestar la
			MOVWF		TRISA ;linea telefonica, RC2 Salida del tono de inicio y RA2 Salida de tonos a la linea
			MOVLW		.1
			MOVWF		PIE1 ; Activo Interrupciones por desbordamiento del TMR1
			CLRF		TRISC ; Puerto C como salida para control de perifericos
			BANKSEL 	PORTA 
			CLRF		PORTA
			CLRF		PORTB
			CLRF		PORTC
			MOVLW		12H
			MOVWF		PASS1 ; Primer registro de contraseña
			MOVLW		34H ; Contraseña predeterminada 1234
			MOVWF		PASS2 ; Segundo registro de contraseña
			MOVLW		30H
			MOVWF		T1CON
			CLRF		CONTA
			CLRF		PIR1
			CLRF		HABIL ; Bandera de habilitacion para interrupciones por RB0 bit 0 
			GOTO		PROG  ;y TMR1 de 15 Seg bit 1 y TMR1 de 1-1/2 Minutos bit 2

;************************************************

PROG		NOP
			BSF			PORTB,1
			SLEEP
			NOP
			BTFSC		HABIL,0
			GOTO		SEGUIR ; Al retornar de la interrupcion por RB0 entra a contar la cantidad de pulsos
			GOTO		PROG   ; necesarios para que conteste el TELAMANDO

			END