				LIST			P=16F877A
				INCLUDE			P16F877A.INC
				RS		EQU		2;RA2
				E		EQU		3;RA3
CBLOCK			20H
CENTE,DECE,UNID,AUX1,AUX2,PDel0,PDel1  
ENDC		
			ORG			00
			GOTO		CONFI
			ORG			04;EMPIEZA AQUI CON UNA INTERRUPCION DESPUES DE ESTAR DURMIENDO
			GOTO		INTEXT
;******************************************************************
INTEXT		BCF			INTCON,INTF
			MOVLW		.10
			ADDWF		AUX1
			MOVFW		AUX1
			XORLW		.4
			BTFSC		STATUS,Z
			GOTO		BORRAR
MOSTRAR		CALL		BINBCD
			CALL		VISUALIZAR
			RETFIE
BORRAR		CLRF		DECE
			CLRF		UNID
			CLRF		AUX1
			GOTO		MOSTRAR

;******************************************************************
RETARDO		movlw     .6    ;RETARDO DE 5m SEGUNDOS 
        	movwf     PDel0      
PLoop01 	movlw     .207      
        	movwf     PDel1      
PLoop02 	clrwdt               
        	decfsz    PDel1,1    
        	goto      PLoop02   
        	decfsz    PDel0,1    
        	goto      PLoop01    
PDelL1  	goto 	  PDelL02   
PDelL02 	clrwdt              
        	return 	
;******************************************************************
CONTROL			BCF				PORTA,RS;SELECCIONA EL REGISTRO DE CONTROL EN LCD
				GOTO			DATO2
DATO			BSF				PORTA,RS;SELECCIONA REGISTRO DE DATOS
DATO2			BSF				PORTA,E;CONECTAMOS MODULO
				MOVWF			PORTC
				CALL			RETARDO
				BCF				PORTA,E;MODULO DESCONECTADO
				CALL			RETARDO
				RETURN
;******************************************************************
BINBCD			MOVF			AUX1,W;CONVERSION BINARIO A BINARIO DECIMAL CODIFICADO
				MOVWF			AUX2
				CLRF			CENTE
				CLRF			DECE
				CLRF			UNID
				MOVLW			.100
CENTEN			SUBWF			AUX2,F
				BTFSC			STATUS,C
				GOTO			CENTENAS
				MOVLW			.100
				ADDWF			AUX2
DECEN			MOVLW			.10
				SUBWF			AUX2,F
				BTFSC			STATUS,C
				GOTO			DECENAS
				MOVLW			.10
				ADDWF			AUX2
				MOVF			AUX2,W
				MOVWF			UNID
				RETURN
CENTENAS		INCF			CENTE
				GOTO			CENTEN	
DECENAS			INCF			DECE
				GOTO			DECEN
;******************************************************************

CONFI_LCD	MOVLW		01H ; BORRADO DEL LCD
			CALL		CONTROL
			MOVLW		03H ; HOME DEL LCD
			CALL		CONTROL
			MOVLW		06H ; ENTRA AL MODO SET
			CALL		CONTROL
			MOVLW		38H ; INICIALIZAMOS LCD CONFIGURANDO BUS DE DATOS
			CALL		CONTROL
			MOVLW		0FH ; DISPLAY ON Y CURSOR PARPADEANDO
			CALL		CONTROL		
			CALL		RETARDO
			CALL		VISUALIZAR
			GOTO		PROG
;******************************************************************
VISUALIZAR		MOVLW			81H;POSICION DE LA PRIMERA LINEA
				CALL			CONTROL
				MOVLW			'W'
				CALL			DATO
				MOVLW			'I'
				CALL			DATO
				MOVLW			'N'
				CALL			DATO
				MOVLW			'S'
				CALL			DATO
				MOVLW			'T'
				CALL			DATO
				MOVLW			'O'
				CALL			DATO
				MOVLW			'N'
				CALL			DATO
				MOVLW			' '
				CALL			DATO
				MOVLW			'C'
				CALL			DATO
				MOVLW			'H'
				CALL			DATO
				MOVLW			'A'
				CALL			DATO
				MOVLW			'T'
				CALL			DATO
				MOVLW			'E'
				CALL			DATO
				MOVLW			'S'
				CALL			DATO
				CALL 			RETARDO
				MOVLW			0C7H;POSICION DE LA SEGUNDA LINEA
				CALL			CONTROL
				MOVF			CENTE,W	
				ADDLW			.48
				CALL			DATO
				MOVF			DECE,W	
				ADDLW			.48
				CALL			DATO
				MOVF			UNID,W
				ADDLW			.48	
				CALL			DATO
				RETURN	
;***********************************************************************
CONFI		NOP
			BSF			STATUS,RP0;SELECCIONO EL BANCO 1
			CLRF		TRISC;PUERTO C COMO SALIDA
			MOVLW		.255
			MOVWF		TRISD
			MOVLW		.255
			MOVWF		TRISE
			MOVLW		90H
			MOVWF		INTCON
			MOVLW		06H
			MOVWF		ADCON1;RA2 Y RA3 COMO SALIDAS DIGITALES
			BCF			OPTION_REG,6
			MOVLW		B'11110011'
			MOVWF		TRISA
			BSF			TRISB,0;ENTRADA RB0 (INT)
			BCF			STATUS,RP0;SELECCIONO BANCO 0
			CLRF		AUX1
			CLRF		CENTE
			CLRF		DECE
			GOTO		CONFI_LCD
;************************************************************************
PROG		NOP
			NOP
			NOP
			NOP
			GOTO	PROG
			END
