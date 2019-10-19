;Programa para un ascensor de un edificio de tres pisos con un contador parcial de personas que se incrementa y 
;decrementa segun sea hasta 9 y un contador general
;diario de personas que llegue hasta 999, con sensorres de barrera
;Entrada del Conversor BIN a 7 SEG > "RC0 - RC3"
;5 Display 7 SEG > "RC4 - RC7 y RB7"
;Sensores de barrera "RB4 y RB5"
;Controles ascensor PPiso > RB1 - Subir
;					SPiso > RB2 y RB0 - Subir y bajar
;					TPiso > RB3 - Bajar
;Sensores de PPiso > RA1
;			 SPiso > RA2
;			 TPiso > RA3
;Alarma de sobrepersonas RB6
;Pulso correspondiente primer piso RA0 "Esta dentro del ascensor"
;Pulso correspondiente segundo piso RA4 "Esta dentro del ascensor"
;Pulso correspondiente tercer piso RA5 "Esta dentro del ascensor"
		
		LIST	P=16F876A
		INCLUDE P16F876A.INC
CBLOCK 20H
CONTP,CONTAL,PISO,AUX,DEC,CENT,HABIL,PDel0,PDel1,PDel2,TEMP
ENDC

			ORG		00; Se le dice al programa que inicie desde cero
			GOTO	CONFIG
			ORG		05

;-------------------------------------------
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

;-------------------------------------------
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

;-------------------------------------------
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

;-------------------------------------------
;Conversion de datos
CENTENA		INCF		CENT ; Numero de centenas
			MOVF		CENT,W
			XORLW		.10
			BTFSC		STATUS,Z
			CLRF		CENT
			GOTO		CONTI                                
BINBCD		MOVF		CONTAL,W
			MOVWF		AUX
			MOVF		CONTAL
			XORLW		.100; Controla el conteo del CONTAL contador general diario 
			BTFSC		STATUS,Z ;de personas que solo es hasta 100
			CLRF		CONTAL
			CLRF		DEC
			NOP
CONTI		MOVLW		.100
			SUBWF		AUX,F		
			BTFSC		STATUS,C
			GOTO		CENTENA
			MOVLW		.100
			ADDWF		AUX ; Volvemos AUX al estado de decimas
DECENA		MOVLW		.10
			SUBWF		AUX,F
			BTFSC		STATUS,C
			GOTO		DECENA1
			MOVLW		.10
			ADDWF		AUX ; Complemento de AUX que son las Unidades
			CALL		VISUAL
			RETURN		
DECENA1		INCF		DEC ; Numero de decenas
			GOTO		DECENA
;-------------------------------------------
;Visualizacion Completa
VISUAL		MOVLW		.20
			MOVWF		TEMP
CICLO		BCF			PORTB,7
			MOVF		CONTP,W; Contador parcial de personas
			MOVWF		PORTC
			BSF			PORTC,7
			CALL		RETAR1; 1 mS
			BCF			PORTC,7
			MOVF		AUX,W; Total personas en el dia
			MOVWF		PORTC
			BSF			PORTC,6
			CALL		RETAR1; 1 mS
			BCF			PORTC,6
			MOVF		DEC,W
			MOVWF		PORTC
			BSF			PORTC,5
			CALL		RETAR1; 1 mS
			BCF			PORTC,5
			MOVF		CENT,W
			MOVWF		PORTC
			BSF			PORTC,4
			CALL		RETAR1; 1 mS
			BCF			PORTC,4
			MOVF		PISO,W; Posicion del ascensor en los tres pisos
			MOVWF		PORTC
			BSF			PORTB,7
			CALL		RETAR1; 1mS
			DECFSZ		TEMP
			GOTO		CICLO
			RETURN

;--------------------------------------------
CHECKOUT	MOVF		CONTP,W
			XORLW		.0
			BTFSC		STATUS,Z
			RETURN
			MOVLW		.30
			MOVWF		HABIL
PROCESO		CALL		VISUAL
			DECFSZ		HABIL
			GOTO		PROC
			RETURN
PROC		CALL		RETAR3; 10 mS Para darle tiempo a las personas de alcanzar el sensor 
			BTFSC		PORTB,5;Chequea y cuenta personas al salir, controlando que no sean menor a 0
			GOTO		PROCESO
			CALL		RETAR1
			BTFSC		PORTB,4 
			GOTO		PROCESO
			DECFSZ		CONTP
			GOTO		PROCESO
			RETURN
			
CHECKIN		MOVLW		.20
			MOVWF		HABIL			
PROCES1		CALL		VISUAL
			DECFSZ		HABIL
			GOTO		PROC1
			RETURN
PROC1		CALL		RETAR3; 10 mS Para darle tiempo a las personas de alcanzar el sensor
			BTFSC		PORTB,4;Chequea y cuenta personas para subir, controlando que no sean mayores a 9
			GOTO		PROCES1
			CALL		RETAR1
			BTFSC		PORTB,5 
			GOTO		PROCES1
			INCF		CONTP
			MOVF		CONTP,W
			XORLW		.9
			BTFSC		STATUS,Z
			CALL		WARNING; Llama a peligro para verificar si puede estar alguien entrando y esto seria sobrecupo
			INCF		CONTAL; Incrementa contdor total de personas
			CALL		BINBCD
			GOTO		PROCES1
						
WARNING		DECF		CONTAL
			BTFSC		PORTB,4
			RETURN
			CALL		RETAR1
			BTFSC		PORTB,5
			GOTO		WARNING
			CALL		ALARMA
			RETURN

ALARMA		BSF			PORTB,6; Enciende la alarma de sobrecupo
			BTFSC		PORTB,5 ; No sale de esta subrutina hasta que la persona no se salga del ascensor
			GOTO		ALARMA
			CALL		RETAR1
			BTFSC		PORTB,4
			GOTO		ALARMA
			BCF			PORTB,6;Apaga la alarma de sobrecupo
			RETURN

;-------------------------------------------
;Subir, habilitado solo para el primer piso
ACCION1		CALL		RETAR2
			BTFSC		PORTA,3
			CALL		BAJAR25
			BTFSC		PORTA,2
			CALL		BAJAR15
			CALL		CHECKOUT
			CALL		CHECKIN
			CALL		DATOS1
			CALL		VISUAL
			RETURN

BAJAR15		CALL		BAJAR; Bajar un piso
			CALL		CHECKOUT
			CALL		CHECKIN
			CALL		DATOS1
			RETURN

BAJAR25		CALL		BAJAR; Bajar dos pisos
			CALL		BAJAR
			CALL		CHECKOUT
			CALL		CHECKIN
			CALL		DATOS1
			RETURN

DATOS1		MOVLW		.5
			MOVWF		HABIL
DATO1		CALL		RETAR2
			BTFSC		PORTA,4; Preguntar por pulsos dentro de ascensor
			GOTO		SUBIR
			BTFSC		PORTA,5
			GOTO		SUBIR2
			DECFSZ		HABIL
			GOTO		DATO1
			RETURN

SUBIR		CALL		RETAR3; 1 seg ; Si se demora mucho 
			INCF		PISO ;Sube un piso
			CALL		VISUAL
			RETURN

BAJAR		CALL		RETAR3
			DECF		PISO ; Baja un piso
			CALL		VISUAL
			RETURN

SUBIR2		CALL		SUBIR
			CALL		SUBIR; Sube dos pisos			
			RETURN

BAJAR2		CALL		BAJAR
			CALL		BAJAR; Sube dos pisos
			RETURN

;Bajar o subir, solamente habilitado para el pulso de bajada del segundo piso			
ACCION2		CALL		RETAR2
			BTFSC		PORTA,3
			CALL		BAJAR10
			BTFSC		PORTA,1
			CALL		SUBIR10
			CALL		CHECKOUT
			CALL		CHECKIN
			CALL		DATOS2
			CALL		VISUAL
			RETURN

BAJAR10		CALL		BAJAR; Bajar un piso
			CALL		CHECKOUT
			CALL		CHECKIN
			CALL		DATOS2
			RETURN

SUBIR10		CALL		SUBIR; Subir un piso
			CALL		CHECKOUT
			CALL		CHECKIN
			CALL		DATOS2
			RETURN

DATOS2		MOVLW		.5
			MOVWF		HABIL
DATO2		CALL		RETAR2
			BTFSC		PORTA,0; Preguntar por pulsos dentro de ascensor
			GOTO		BAJAR
			BTFSC		PORTA,5
			GOTO		SUBIR
			DECFSZ		HABIL
			GOTO		DATO2
			RETURN

;Bajar, solamente habilitado para el pulso de bajada del tercer piso
ACCION3		CALL		RETAR2
			BTFSC		PORTA,1
			CALL		SUBIR20
			BTFSC		PORTA,2
			CALL		SUBIR11
			CALL		CHECKOUT
			CALL		CHECKIN
			CALL		DATOS3
			CALL		VISUAL
			RETURN

SUBIR20		CALL		SUBIR; Subir dos pisos
			CALL		SUBIR
			CALL		CHECKOUT
			CALL		CHECKIN
			CALL		DATOS3
			RETURN

SUBIR11		CALL		SUBIR; Subir un piso
			CALL		CHECKOUT
			CALL		CHECKIN
			CALL		DATOS3
			RETURN

DATOS3		MOVLW		.10
			MOVWF		HABIL
DATO3		CALL		RETAR2
			BTFSC		PORTA,4; Preguntar por pulsos dentro de ascensor
			GOTO		BAJAR
			BTFSC		PORTA,0
			GOTO		BAJAR2
			DECFSZ		HABIL
			GOTO		DATO3
			RETURN

;-------------------------------------------
;Configuracion de registros
CONFIG		NOP
			BANKSEL		TRISA
			MOVLW       06
			MOVWF      	ADCON1
			BSF			OPTION_REG,7
			MOVLW		B'11111111'
			MOVWF		TRISA
			MOVLW		B'00111111'
			MOVWF		TRISB
			CLRF		TRISC
			CLRF		INTCON
			BANKSEL		PORTA
			CLRF		PORTA
			CLRF		PORTB
			CLRF		PORTC
			CLRF		CONTP
			CLRF		CONTAL
			CLRF		PISO
			CLRF		AUX
			CLRF		DEC
			CLRF		CENT
			MOVLW		.30
			MOVWF		HABIL
			GOTO		INIASC; Iniciar Ascensor en posicion de piso X
;--------------------------------------------			
; Chequear el estado del Ascensor con respecto al piso
INIASC		BTFSC		PORTA,1
			GOTO		NIVEL1
			BTFSC		PORTA,2
			GOTO		NIVEL2
			BTFSC		PORTA,3
			GOTO		NIVEL3
			GOTO		INIASC

NIVEL1		MOVLW		.1
			MOVWF		PISO
			GOTO		PROG
NIVEL2		MOVLW		.2
			MOVWF		PISO
			GOTO		PROG
NIVEL3		MOVLW		.3
			MOVWF		PISO
			GOTO		PROG
;-------------------------------------------
;Programa general				
PROG		CALL		VISUAL
			BTFSC		PORTB,1;Chequea pulso de subida en el piso 1
			CALL		ACCION1
			CALL		DATOS3 ; Chequea pulsos dentro del ascensor
			BTFSC		PORTB,0; Chequea el pulso de bajada en el piso 2
			CALL		ACCION2
			CALL		VISUAL
			CALL		DATOS2 ; Chequea datos dentro del ascensor
			BTFSC		PORTB,2; Chequea el pulso de subida en el piso 2
			CALL		ACCION2
			BTFSC		PORTB,3; Chequea el pulso de bajada en el piso 3
			CALL		ACCION3; Ascensor
			CALL		DATOS1
			GOTO		PROG

			END

;---------------------------------------------
