		LIST P=16F877A
		INCLUDE P16F877A.INC
CBLOCK 20H
AUX,NUM
ENDC

			ORG			00
			GOTO		CONFIG_PORT
			ORG			05

CHECK			BTFSS		PORTB,3; STD del integrado CM8870
				GOTO		CHECK
				CALL		ANTIREBOT1
				MOVF		PORTB,W
				ANDLW		0F0H
				MOVWF		NUM
				SWAPF		NUM
				MOVF		NUM,W
				XORLW		.1
				BTFSC		STATUS,Z; Enciende la carga de salida
				BSF			PORTC,3;Salida de la carga
				MOVF		NUM,W
				XORLW		.2
				BTFSC		STATUS,Z ; Apaga la carga de salida
				BCF			PORTC,3; Salida de la carga
				MOVF		NUM,W
				XORLW		.9
				BTFSC		STATUS,Z ; Colgar o salir de la aplicacion.
				GOTO		SALIR
				GOTO		CHECK

ANTIREBOT1		BTFSC		PORTB,3
				GOTO		ANTIREBOT1
				RETURN

SALIR			BCF			PORTC,4 ; Cuelga al desactivar el rele que habilita la linea telefonica
				GOTO		INICIO
		
CONFIG_PORT		NOP
				BANKSEL		TRISA
				MOVLW		.255
				MOVWF		TRISE
				MOVLW		.255
				MOVWF		TRISD
				MOVLW		.6
				MOVWF		ADCON1; Puerto del ADCON digital todo
				MOVLW		.255
				MOVWF		TRISA; Puerto A como esntradas
				MOVLW		.255
				MOVWF		TRISB
				MOVLW		B'11110011'; Bits 4-7 del PORTB son las Salidas del Integrado
				MOVWF		TRISC; RC
				BANKSEL		PORTA
				CLRF		PORTA
				CLRF		PORTB
				CLRF		PORTC
				BSF			PORTB,2
				GOTO		PROG
INICIO			MOVLW		.3
				MOVWF		AUX
				NOP
PROG			BTFSS		PORTA,0 ; Pulso de la linea telefonica
				GOTO		PROG
				CALL		ANTIREBOT
				DECFSZ		AUX
				GOTO		PROG
				BSF			PORTC,4 ; Contesta, activa el rele, despues de 4 timbres
				GOTO		CHECK

ANTIREBOT		BTFSC		PORTA,0
				GOTO		ANTIREBOT
				RETURN
				
				END