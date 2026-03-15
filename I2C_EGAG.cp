#line 1 "C:/Users/Erick Garcia/Documents/GitHub/I2C_EEPROM_PIC16F887/I2C_EGAG.c"


void I2C_Init_Master(unsigned long i2c_speed){

 TRISC3_bit = 1;
 TRISC4_bit = 1;

 SSPSTAT = 0x00;
 SSPCON = 0x28;
 SSPCON2 = 0x00;

 SSPADD = ( 16000000  / (4 * i2c_speed)) - 1;

 SSPEN_bit = 1;
}
void I2C_Start(void){
 SEN_bit = 1;
 while(SEN_bit);
}
void I2C_Stop(void){
 PEN_bit = 1;
 while(PEN_bit);
}

void I2C_Restart_COM(){

 while(SSPCON2 & 0x1F);
 while(SSPSTAT.R_W);

 SSPCON2.RSEN = 1;
 while(SSPCON2.RSEN);

}
#line 39 "C:/Users/Erick Garcia/Documents/GitHub/I2C_EEPROM_PIC16F887/I2C_EGAG.c"
unsigned char I2C_Read(unsigned char Ack){


 unsigned char received;

 while(SSPCON2 & 0x1F);
 while(SSPSTAT.R_W);

 SSPCON2.RCEN = 1;


 while(!SSPSTAT.BF){
 PORTD = 0x55;
}
 received = SSPBUF;

 if(ack == 0)
 SSPCON2.ACKDT = 1;
 else
 SSPCON2.ACKDT = 0;

 SSPCON2.ACKEN = 1;
 while(SSPCON2.ACKEN);

 return received;
}
char I2C_Write(unsigned char _data){

 PIR1.SSPIF = 0;

 SSPBUF = _data;

 while(!PIR1.SSPIF);

 PIR1.SSPIF = 0;

 if(ACKSTAT_bit)
 return 0;

 return 1;
}
