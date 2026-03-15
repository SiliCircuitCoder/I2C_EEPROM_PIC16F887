#line 1 "C:/Users/Erick Garcia/Documents/GitHub/I2C_EEPROM_PIC16F887/I2C_EEPROM.c"
#line 1 "c:/users/erick garcia/documents/github/i2c_eeprom_pic16f887/i2c_egag.h"



void I2C_Init_Master(unsigned long i2c_speed);
void I2C_Start(void);
void I2C_Stop(void);
void I2C_Restart_COM();

char I2C_Write(unsigned char _data);
unsigned char I2C_Read(unsigned char Ack);
#line 2 "C:/Users/Erick Garcia/Documents/GitHub/I2C_EEPROM_PIC16F887/I2C_EEPROM.c"
sbit led at RC1_bit;
unsigned char const dir_exclavo = 0b10100000;
unsigned char i=0;
 unsigned char dato;

void main() {
 TRISD = 0x00;
 PORTD =0x00;
 I2C_Init_Master(100000);

 while(1){
 for(i=0;i<=50;i++){
 I2C_Start();
 I2C_Write(0xA0);
 I2C_Write(i);
 I2C_Write(i);
 I2C_Stop();
 Delay_ms(10);
 }

 for(i=0;i<=50;i++){
 I2C_Start();
 I2C_Write(0xA0);


 I2C_Write(i);

 I2C_Restart_COM();
 I2C_Write(0xA1);
 dato = I2C_Read(0);
 I2C_Stop();
 PORTD = dato;
 Delay_ms(600);
 }
 break;

 }
}
