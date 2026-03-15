#ifndef _I2C_16F887_H_
#define _12C_16F887_H_

void I2C_Init_Master(unsigned long i2c_speed);
void I2C_Start(void);
void I2C_Stop(void);
void I2C_Restart_COM();
//void I2C_Write(unsigned char _data);
char I2C_Write(unsigned char _data);
unsigned char I2C_Read(unsigned char Ack);


#endif