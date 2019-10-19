LIST P=16F876A
INCLUDE P16F876A.INC; Define registros y bits.
		RS	EQU	2
		E	EQU	3
CBLOCK 20H; Registros de proposito gral.
CONTA,AUX,PDel0,PDel1,PDel2,CENT,DEC,BHSL,MIL,HABIL
ENDC

			ORG		00; Se le dice al programa que inicie desde cero
			GOTO	CONFIG
			ORG		05
			
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

;***********************************************************

;Retardo 10 ms
RETAR2  	movlw     .100      ; 1 set number of repetitions (B)
        	movwf     PDel0     ; 1 |
PLoop10 	movlw     .249      ; 1 set number of repetitions (A)
        	movwf     PDel1     ; 1 |
PLoop20 	clrwdt              ; 1 clear watchdog
        	clrwdt              ; 1 cycle delay
        	decfsz    PDel1,1   ; 1 + (1) is the time over? (A)
        	goto      PLoop20   ; 2 no, loop
        	decfsz    PDel0,1   ; 1 + (1) is the time over? (B)
       	    goto      PLoop10   ; 2 no, loop
PDelL10  	goto 	  PDelL20   ; 2 cycles delay
PDelL20 	clrwdt              ; 1 cycle delay
        	return              ; 2+2 Done

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

;**************************************************************
;Interrupcion Externa
EXTINT		;BCF			INTCON,INTF
			MOVF		CONTA,W
			XORLW		.100
			BTFSC		STATUS,Z
			CLRF		CONTA
			MOVLW		.10
			ADDWF		CONTA
			MOVF		CONTA,W
			MOVWF		AUX ; Para operar en la conversion BIN A DEC
			CALL		BINBCD
			CALL		VISCONTA
			GOTO		EXTINT
			;RETFIE

;**************************************************************

;Conversion BIN a DEC	
CENTENA		INCF		CENT ; Numero de centenas
			MOVF		CENT,W
			XORLW		.10
			BTFSS		STATUS,Z ; Salta si Z = 1 donde el resultado es 0
			RETURN
			NOP
MILES		INCF		MIL ; Numero de miles
			MOVF		MIL,W
			XORLW		.10
			BTFSC		STATUS,Z
			CLRF		MIL
			CLRF		CENT
            RETURN
                
BINBCD		CLRF		DEC
			MOVF		AUX,W
			XORLW		.100
			BTFSC		STATUS,Z
			CALL		CENTENA
DECENA		MOVLW		.10
			SUBWF		AUX,F
			BTFSC		STATUS,C
			GOTO		DECENA1
			MOVLW		.10
			ADDWF		AUX ; Ajusta AUX al valor positivo
			CALL		RETAR1
			RETURN		
DECENA1		INCF		DEC ; Numero de decenas
			MOVF		DEC,W
			XORLW		.10
			BTFSC		STATUS,Z
			CLRF		DEC
			GOTO		DECENA

;**************************************************************

; Visualizar Contador en la segunda linea		
VCONTA1		MOVLW		.1
			MOVWF		BHSL
			MOVLW		0C1H
			CALL		CONTROL
			MOVLW		'C'
			CALL		DATO
			MOVLW		'O'
			CALL		DATO
			MOVLW		'N'
			CALL		DATO
			MOVLW		'T'
			CALL		DATO
			MOVLW		'A'
			CALL		DATO
			MOVLW		'D'
			CALL		DATO
			MOVLW		'O'
			CALL		DATO
			MOVLW		'R'
			CALL		DATO
			MOVLW		' '
			CALL		DATO
			RETURN

;***************************************************************

; Mostrar los numeros del contador
VISCONTA	CALL		RETAR2
			MOVLW		0CBH
			CALL		CONTROL
			MOVF		MIL,W
			ADDLW		.48
			CALL		DATO
			CALL		RETAR2
			MOVF		CENT,W
			ADDLW		.48
			CALL		DATO
			CALL		RETAR2
			MOVF		DEC,W
			ADDLW		.48
			CALL		DATO
			CALL		RETAR2
			MOVF		AUX,W
			ADDLW		.48
			CALL		DATO
			DECFSZ		HABIL
			RETURN
			MOVLW		.16
			MOVWF		HABIL
			CALL		FUCK
			CALL		RETAR3
			CALL		NAME
			RETURN
;***************************************************************

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

;***************************************************************

;Copiar Nombre en LCD
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
			BTFSS		BHSL,1
			CALL		VCONTA1
			RETURN

;*****************************************************************

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
			RETURN

;**************************************************************

;Fockyou Pirobos
FUCK		MOVLW		01H
			CALL		CONTROL
			MOVLW		80H
			CALL		CONTROL
			MOVLW		'F'
			CALL		DATO
			MOVLW		'U'
			CALL		DATO
			MOVLW		'C'
			CALL		DATO
			MOVLW		'K'
			CALL		DATO
			MOVLW		'Y'
			CALL		DATO
			MOVLW		'O'
			CALL		DATO
			MOVLW		'U'
			CALL		DATO
			MOVLW		' '
			CALL		DATO
			MOVLW		' '
			CALL		DATO
			MOVLW		'P'
			CALL		DATO
			MOVLW		'I'
			CALL		DATO
			MOVLW		'R'
			CALL		DATO
			MOVLW		'O'
			CALL		DATO
			MOVLW		'B'
			CALL		DATO
			MOVLW		'O'
			CALL		DATO
			MOVLW		'S'
			CALL		DATO
			RETURN

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
			CLRF		CONTA
			CLRF		PORTA
			CLRF		PORTC
			CLRF		CONTA
			MOVLW		.16
			MOVWF		HABIL
			GOTO		INILCD

;***************************************************************

;Inicializar LCD
INILCD		MOVLW		01H ; Borrado del LCD
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
			CALL		RETAR3
			GOTO		PROG

;******************************************************************	

PROG		NOP
			CALL		INTRO
			CALL		RETAR3
			CALL		NAME
			CALL		RETAR3
			GOTO		EXTINT
							
			END
