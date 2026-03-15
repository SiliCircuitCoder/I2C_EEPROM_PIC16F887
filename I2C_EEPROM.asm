
_main:

;I2C_EEPROM.c,7 :: 		void main() {
;I2C_EEPROM.c,8 :: 		TRISD = 0x00;
	CLRF       TRISD+0
;I2C_EEPROM.c,9 :: 		PORTD =0x00;
	CLRF       PORTD+0
;I2C_EEPROM.c,10 :: 		I2C_Init_Master(100000);
	MOVLW      160
	MOVWF      FARG_I2C_Init_Master_i2c_speed+0
	MOVLW      134
	MOVWF      FARG_I2C_Init_Master_i2c_speed+1
	MOVLW      1
	MOVWF      FARG_I2C_Init_Master_i2c_speed+2
	MOVLW      0
	MOVWF      FARG_I2C_Init_Master_i2c_speed+3
	CALL       _I2C_Init_Master+0
;I2C_EEPROM.c,13 :: 		for(i=0;i<=50;i++){
	CLRF       _i+0
L_main2:
	MOVF       _i+0, 0
	SUBLW      50
	BTFSS      STATUS+0, 0
	GOTO       L_main3
;I2C_EEPROM.c,14 :: 		I2C_Start();
	CALL       _I2C_Start+0
;I2C_EEPROM.c,15 :: 		I2C_Write(0xA0); // device + write
	MOVLW      160
	MOVWF      FARG_I2C_Write__data+0
	CALL       _I2C_Write+0
;I2C_EEPROM.c,16 :: 		I2C_Write(i); // direccion
	MOVF       _i+0, 0
	MOVWF      FARG_I2C_Write__data+0
	CALL       _I2C_Write+0
;I2C_EEPROM.c,17 :: 		I2C_Write(i); // dato
	MOVF       _i+0, 0
	MOVWF      FARG_I2C_Write__data+0
	CALL       _I2C_Write+0
;I2C_EEPROM.c,18 :: 		I2C_Stop();
	CALL       _I2C_Stop+0
;I2C_EEPROM.c,19 :: 		Delay_ms(10);
	MOVLW      52
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_main5:
	DECFSZ     R13+0, 1
	GOTO       L_main5
	DECFSZ     R12+0, 1
	GOTO       L_main5
	NOP
	NOP
;I2C_EEPROM.c,13 :: 		for(i=0;i<=50;i++){
	INCF       _i+0, 1
;I2C_EEPROM.c,20 :: 		}
	GOTO       L_main2
L_main3:
;I2C_EEPROM.c,22 :: 		for(i=0;i<=50;i++){
	CLRF       _i+0
L_main6:
	MOVF       _i+0, 0
	SUBLW      50
	BTFSS      STATUS+0, 0
	GOTO       L_main7
;I2C_EEPROM.c,23 :: 		I2C_Start();
	CALL       _I2C_Start+0
;I2C_EEPROM.c,24 :: 		I2C_Write(0xA0);
	MOVLW      160
	MOVWF      FARG_I2C_Write__data+0
	CALL       _I2C_Write+0
;I2C_EEPROM.c,27 :: 		I2C_Write(i);
	MOVF       _i+0, 0
	MOVWF      FARG_I2C_Write__data+0
	CALL       _I2C_Write+0
;I2C_EEPROM.c,29 :: 		I2C_Restart_COM();
	CALL       _I2C_Restart_COM+0
;I2C_EEPROM.c,30 :: 		I2C_Write(0xA1);
	MOVLW      161
	MOVWF      FARG_I2C_Write__data+0
	CALL       _I2C_Write+0
;I2C_EEPROM.c,31 :: 		dato = I2C_Read(0);
	CLRF       FARG_I2C_Read_Ack+0
	CALL       _I2C_Read+0
	MOVF       R0+0, 0
	MOVWF      _dato+0
;I2C_EEPROM.c,32 :: 		I2C_Stop();
	CALL       _I2C_Stop+0
;I2C_EEPROM.c,33 :: 		PORTD = dato;
	MOVF       _dato+0, 0
	MOVWF      PORTD+0
;I2C_EEPROM.c,34 :: 		Delay_ms(600);
	MOVLW      13
	MOVWF      R11+0
	MOVLW      45
	MOVWF      R12+0
	MOVLW      215
	MOVWF      R13+0
L_main9:
	DECFSZ     R13+0, 1
	GOTO       L_main9
	DECFSZ     R12+0, 1
	GOTO       L_main9
	DECFSZ     R11+0, 1
	GOTO       L_main9
	NOP
	NOP
;I2C_EEPROM.c,22 :: 		for(i=0;i<=50;i++){
	INCF       _i+0, 1
;I2C_EEPROM.c,35 :: 		}
	GOTO       L_main6
L_main7:
;I2C_EEPROM.c,38 :: 		}
L_main1:
;I2C_EEPROM.c,39 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
