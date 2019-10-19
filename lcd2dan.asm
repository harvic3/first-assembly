LIST P=16F873A
INCLUDE P16F873A.INC; Define registros y bits.
		RS	EQU	2
		E	EQU	3
CBLOCK 20H; Registros de proposito gral.
AUX,DEC,CENT,CONT,PDel0,PDel1
ENDC

			ORG		00; Se le dice al programa que inicie desde cero
			GOTO	CONFIG
			ORG		04
			GOTO	INTEXT
			
;***********************************************************

;Retardo 5 ms
RETARDO  	movlw     .6        ; 1 set number of repetitions (B)
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

;***********************************************************
;Interrupcion Externa
INTEXT	BCF		INTCON,INTF
		MOVLW	.10
		ADDWF	CONT
		MOVF	CONT,W
		MOVWF	AUX
		MOVF	CONT,W
		XORLW	.4
		BTFSC	STATUS,Z
		GOTO	BORRAR
		CALL	BINBCD
		CALL	MOSTRAR
		RETFIE
BORRAR	CLRF	CONT
		CLRF	DEC
		CLRF	CENT
		CLRF	AUX
		CALL	MOSTRAR
		RETFIE

;**************************************************************

;Conversion BIN a DEC	
CENTENA		INCF	CENT
			GOTO	SALTO
BINBCD		CLRF	CENT
			CLRF	DEC
SALTO		MOVLW	.100
			SUBWF	AUX,F
			BTFSC	STATUS,C
			GOTO	CENTENA
			MOVLW	.100
			ADDWF	AUX
DECENAS		MOVLW	.10
			SUBWF	AUX,F
			BTFSC	STATUS,C
			GOTO	DECEN1
			MOVLW	.10
			ADDWF	AUX
			RETURN
DECEN1		INCF	DEC
			GOTO	DECENAS

;***************************************************************

; Mostrar los numeros del contador
MOSTRAR		MOVLW	0C7H
			CALL	CONTROL
			MOVF	CENT,W
			ADDLW	.48
			CALL	DATO
			MOVF	DEC,W
			ADDLW	.48
			CALL	DATO
			MOVF	AUX,W
			ADDLW	.48
			CALL	DATO
			RETURN

;***************************************************************

;Comandos y datos LCD
CONTROL		BCF			PORTA,RS
			GOTO		DATO2
			NOP
DATO		BSF			PORTA,RS
DATO2		BSF			PORTA,E
			MOVWF		PORTC
			CALL		RETARDO
			BCF			PORTA,E
			CALL		RETARDO
			RETURN

;***************************************************************

;Copiar Nombre en LCD	
MINAME 	MOVLW	81H
		CALL	CONTROL
		MOVLW 	'J'
		CALL 	DATO
		MOVLW 	'O'
		CALL 	DATO
		MOVLW 	'R'
		CALL 	DATO
		MOVLW 	'G'
		CALL 	DATO
		MOVLW 	'E'
		CALL 	DATO
		MOVLW 	' '
		CALL 	DATO
		MOVLW 	' '
		CALL 	DATO
		MOVLW 	'A'
		CALL 	DATO
		MOVLW 	'C'
		CALL 	DATO
		MOVLW 	'E'
		CALL 	DATO
		MOVLW 	'V'
		CALL 	DATO
		MOVLW 	'E'
		CALL 	DATO
		MOVLW 	'D'
		CALL 	DATO
		MOVLW 	'O'
		CALL 	DATO
		MOVLW	0C7H
		CALL	CONTROL
		MOVLW 	'0'
		CALL 	DATO
		MOVLW 	'0'
		CALL 	DATO
		MOVLW 	'0'
		CALL 	DATO
		GOTO 	PROG

				
;**************************************************************

;Configuracion de puertos
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
			CLRF		PORTA
			CLRF		PORTC
			CLRF		CONT
			CLRF		CENT
			CLRF		DEC
			GOTO		LCDIN

;***************************************************************

;Inicializar LCD
LCDIN		MOVLW		01H ; Borrado del LCD
			CALL		CONTROL
			MOVLW		03H ; Ir a Home del LCD
			CALL		CONTROL
			MOVLW		06H ; Entra al modO set del LCD
			CALL		CONTROL
			MOVLW		18H ; Desplazar Display a la Izquierda
			CALL		CONTROL
			MOVLW		38H ; Inicializamos LCD configurando bus de datos
			CALL		CONTROL
			MOVLW		0FH ; Display ON y Cursor parpadeando
			CALL		CONTROL		
			CALL		RETARDO
			GOTO		MINAME

;******************************************************************	

PROG		NOP
			NOP
			NOP
			NOP
			NOP
			GOTO	PROG
							
			END
