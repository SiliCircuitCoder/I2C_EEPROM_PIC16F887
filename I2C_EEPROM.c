#include "I2C_EGAG.h"
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
              I2C_Write(0xA0); // device + write
              I2C_Write(i); // direccion
              I2C_Write(i); // dato
              I2C_Stop();
              Delay_ms(10);
              }

              for(i=0;i<=50;i++){
              I2C_Start();
              I2C_Write(0xA0);
              //I2C_Write(0x00);
              //I2C_Write(0x03);
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