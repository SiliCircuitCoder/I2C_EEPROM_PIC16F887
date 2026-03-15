
_I2C_Init_Master:

;I2C_EGAG.c,3 :: 		void I2C_Init_Master(unsigned long i2c_speed){
;I2C_EGAG.c,5 :: 		TRISC3_bit = 1; //registro que habilita el puerto como entrar por Open Drain
	BSF        TRISC3_bit+0, BitPos(TRISC3_bit+0)
;I2C_EGAG.c,6 :: 		TRISC4_bit = 1; //registro que habilita el puerto de entrar como Open Drain
	BSF        TRISC4_bit+0, BitPos(TRISC4_bit+0)
;I2C_EGAG.c,8 :: 		SSPSTAT = 0x00; //Registro que selecciona modo de 100kHz para el protocolo I2C
	CLRF       SSPSTAT+0
;I2C_EGAG.c,9 :: 		SSPCON = 0x28; //Registro que configura em modo maestro con la frecuencia(baud rate) adecuada al cristal
	MOVLW      40
	MOVWF      SSPCON+0
;I2C_EGAG.c,10 :: 		SSPCON2 = 0x00; //Se deshabilita registro para el control del start, stop, etc, y se coloca en 0
	CLRF       SSPCON2+0
;I2C_EGAG.c,12 :: 		SSPADD = (_XTAL_FREQ / (4  * i2c_speed)) - 1;  //Se configura el registro par el calculo de la frecuancia(depende del cristal)
	MOVF       FARG_I2C_Init_Master_i2c_speed+0, 0
	MOVWF      R4+0
	MOVF       FARG_I2C_Init_Master_i2c_speed+1, 0
	MOVWF      R4+1
	MOVF       FARG_I2C_Init_Master_i2c_speed+2, 0
	MOVWF      R4+2
	MOVF       FARG_I2C_Init_Master_i2c_speed+3, 0
	MOVWF      R4+3
	RLF        R4+0, 1
	RLF        R4+1, 1
	RLF        R4+2, 1
	RLF        R4+3, 1
	BCF        R4+0, 0
	RLF        R4+0, 1
	RLF        R4+1, 1
	RLF        R4+2, 1
	RLF        R4+3, 1
	BCF        R4+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVLW      36
	MOVWF      R0+1
	MOVLW      244
	MOVWF      R0+2
	MOVLW      0
	MOVWF      R0+3
	CALL       _Div_32x32_U+0
	DECF       R0+0, 0
	MOVWF      SSPADD+0
;I2C_EGAG.c,14 :: 		SSPEN_bit = 1; //Bit del registro que habilita la comunicacion serial MSSP necesario para la inicialización.
	BSF        SSPEN_bit+0, BitPos(SSPEN_bit+0)
;I2C_EGAG.c,15 :: 		}
L_end_I2C_Init_Master:
	RETURN
; end of _I2C_Init_Master

_I2C_Start:

;I2C_EGAG.c,16 :: 		void I2C_Start(void){
;I2C_EGAG.c,17 :: 		SEN_bit = 1; //Registro para inicar el bit de inicio de la comunicación de I2C.
	BSF        SEN_bit+0, BitPos(SEN_bit+0)
;I2C_EGAG.c,18 :: 		while(SEN_bit); //Repetir esto siempre y cuando el bit no este ocupado o hasta que se haga 0
L_I2C_Start0:
	BTFSS      SEN_bit+0, BitPos(SEN_bit+0)
	GOTO       L_I2C_Start1
	GOTO       L_I2C_Start0
L_I2C_Start1:
;I2C_EGAG.c,19 :: 		}
L_end_I2C_Start:
	RETURN
; end of _I2C_Start

_I2C_Stop:

;I2C_EGAG.c,20 :: 		void I2C_Stop(void){
;I2C_EGAG.c,21 :: 		PEN_bit = 1;  //Registo se coloca en alto para la finalizacion de la comunicacion
	BSF        PEN_bit+0, BitPos(PEN_bit+0)
;I2C_EGAG.c,22 :: 		while(PEN_bit); //Se ejecuta una vez que termina
L_I2C_Stop2:
	BTFSS      PEN_bit+0, BitPos(PEN_bit+0)
	GOTO       L_I2C_Stop3
	GOTO       L_I2C_Stop2
L_I2C_Stop3:
;I2C_EGAG.c,23 :: 		}
L_end_I2C_Stop:
	RETURN
; end of _I2C_Stop

_I2C_Restart_COM:

;I2C_EGAG.c,25 :: 		void I2C_Restart_COM(){
;I2C_EGAG.c,27 :: 		while(SSPCON2 & 0x1F);
L_I2C_Restart_COM4:
	MOVLW      31
	ANDWF      SSPCON2+0, 0
	MOVWF      R0+0
	BTFSC      STATUS+0, 2
	GOTO       L_I2C_Restart_COM5
	GOTO       L_I2C_Restart_COM4
L_I2C_Restart_COM5:
;I2C_EGAG.c,28 :: 		while(SSPSTAT.R_W);
L_I2C_Restart_COM6:
	BTFSS      SSPSTAT+0, 2
	GOTO       L_I2C_Restart_COM7
	GOTO       L_I2C_Restart_COM6
L_I2C_Restart_COM7:
;I2C_EGAG.c,30 :: 		SSPCON2.RSEN = 1;
	BSF        SSPCON2+0, 1
;I2C_EGAG.c,31 :: 		while(SSPCON2.RSEN);
L_I2C_Restart_COM8:
	BTFSS      SSPCON2+0, 1
	GOTO       L_I2C_Restart_COM9
	GOTO       L_I2C_Restart_COM8
L_I2C_Restart_COM9:
;I2C_EGAG.c,33 :: 		}
L_end_I2C_Restart_COM:
	RETURN
; end of _I2C_Restart_COM

_I2C_Read:

;I2C_EGAG.c,39 :: 		unsigned char I2C_Read(unsigned char Ack){
;I2C_EGAG.c,44 :: 		while(SSPCON2 & 0x1F);     // Espera que no haya condición activa
L_I2C_Read10:
	MOVLW      31
	ANDWF      SSPCON2+0, 0
	MOVWF      R0+0
	BTFSC      STATUS+0, 2
	GOTO       L_I2C_Read11
	GOTO       L_I2C_Read10
L_I2C_Read11:
;I2C_EGAG.c,45 :: 		while(SSPSTAT.R_W);        // Espera fin de transmisión previa
L_I2C_Read12:
	BTFSS      SSPSTAT+0, 2
	GOTO       L_I2C_Read13
	GOTO       L_I2C_Read12
L_I2C_Read13:
;I2C_EGAG.c,47 :: 		SSPCON2.RCEN = 1;          // Habilita recepción
	BSF        SSPCON2+0, 3
;I2C_EGAG.c,50 :: 		while(!SSPSTAT.BF){
L_I2C_Read14:
	BTFSC      SSPSTAT+0, 0
	GOTO       L_I2C_Read15
;I2C_EGAG.c,51 :: 		PORTD = 0x55;   // Ver si se queda atorado aquí
	MOVLW      85
	MOVWF      PORTD+0
;I2C_EGAG.c,52 :: 		}
	GOTO       L_I2C_Read14
L_I2C_Read15:
;I2C_EGAG.c,53 :: 		received = SSPBUF;         // Lee el dato
	MOVF       SSPBUF+0, 0
	MOVWF      R1+0
;I2C_EGAG.c,55 :: 		if(ack == 0)
	MOVF       FARG_I2C_Read_Ack+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_I2C_Read16
;I2C_EGAG.c,56 :: 		SSPCON2.ACKDT = 1;     // NACK
	BSF        SSPCON2+0, 5
	GOTO       L_I2C_Read17
L_I2C_Read16:
;I2C_EGAG.c,58 :: 		SSPCON2.ACKDT = 0;     // ACK
	BCF        SSPCON2+0, 5
L_I2C_Read17:
;I2C_EGAG.c,60 :: 		SSPCON2.ACKEN = 1;         // Inicia secuencia ACK/NACK
	BSF        SSPCON2+0, 4
;I2C_EGAG.c,61 :: 		while(SSPCON2.ACKEN);      // Espera fin
L_I2C_Read18:
	BTFSS      SSPCON2+0, 4
	GOTO       L_I2C_Read19
	GOTO       L_I2C_Read18
L_I2C_Read19:
;I2C_EGAG.c,63 :: 		return received;
	MOVF       R1+0, 0
	MOVWF      R0+0
;I2C_EGAG.c,64 :: 		}
L_end_I2C_Read:
	RETURN
; end of _I2C_Read

_I2C_Write:

;I2C_EGAG.c,65 :: 		char I2C_Write(unsigned char _data){
;I2C_EGAG.c,67 :: 		PIR1.SSPIF = 0;     // limpiar antes
	BCF        PIR1+0, 3
;I2C_EGAG.c,69 :: 		SSPBUF = _data;
	MOVF       FARG_I2C_Write__data+0, 0
	MOVWF      SSPBUF+0
;I2C_EGAG.c,71 :: 		while(!PIR1.SSPIF);
L_I2C_Write20:
	BTFSC      PIR1+0, 3
	GOTO       L_I2C_Write21
	GOTO       L_I2C_Write20
L_I2C_Write21:
;I2C_EGAG.c,73 :: 		PIR1.SSPIF = 0;
	BCF        PIR1+0, 3
;I2C_EGAG.c,75 :: 		if(ACKSTAT_bit)
	BTFSS      ACKSTAT_bit+0, BitPos(ACKSTAT_bit+0)
	GOTO       L_I2C_Write22
;I2C_EGAG.c,76 :: 		return 0;
	CLRF       R0+0
	GOTO       L_end_I2C_Write
L_I2C_Write22:
;I2C_EGAG.c,78 :: 		return 1;
	MOVLW      1
	MOVWF      R0+0
;I2C_EGAG.c,79 :: 		}
L_end_I2C_Write:
	RETURN
; end of _I2C_Write
