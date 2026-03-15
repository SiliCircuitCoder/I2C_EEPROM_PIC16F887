#define _XTAL_FREQ 16000000

void I2C_Init_Master(unsigned long i2c_speed){

     TRISC3_bit = 1; //registro que habilita el puerto como entrar por Open Drain
     TRISC4_bit = 1; //registro que habilita el puerto de entrar como Open Drain

     SSPSTAT = 0x00; //Registro que selecciona modo de 100kHz para el protocolo I2C
     SSPCON = 0x28; //Registro que configura em modo maestro con la frecuencia(baud rate) adecuada al cristal
     SSPCON2 = 0x00; //Se deshabilita registro para el control del start, stop, etc, y se coloca en 0

     SSPADD = (_XTAL_FREQ / (4  * i2c_speed)) - 1;  //Se configura el registro par el calculo de la frecuancia(depende del cristal)

     SSPEN_bit = 1; //Bit del registro que habilita la comunicacion serial MSSP necesario para la inicialización.
}
void I2C_Start(void){
     SEN_bit = 1; //Registro para inicar el bit de inicio de la comunicación de I2C.
      while(SEN_bit); //Repetir esto siempre y cuando el bit no este ocupado o hasta que se haga 0
}
void I2C_Stop(void){
     PEN_bit = 1;  //Registo se coloca en alto para la finalizacion de la comunicacion
     while(PEN_bit); //Se ejecuta una vez que termina
}

void I2C_Restart_COM(){

    while(SSPCON2 & 0x1F);
    while(SSPSTAT.R_W);

    SSPCON2.RSEN = 1;
    while(SSPCON2.RSEN);

}
/*void I2C_Write(unsigned char _data){
     SSPBUF = _data; //Se coloca el dato en en el Shift register
     while(BF_bit); //Espera hasta que el buffer quede libre para poder transimitir
     while(SSPCON2 & 0x1F);  //Finaliza la stansmisión.
}*/
unsigned char I2C_Read(unsigned char Ack){


    unsigned char received;

    while(SSPCON2 & 0x1F);     // Espera que no haya condición activa
    while(SSPSTAT.R_W);        // Espera fin de transmisión previa

    SSPCON2.RCEN = 1;          // Habilita recepción

  //  while(!SSPSTAT.BF);        // Espera que llegue el byte
    while(!SSPSTAT.BF){
    PORTD = 0x55;   // Ver si se queda atorado aquí
}
    received = SSPBUF;         // Lee el dato

    if(ack == 0)
        SSPCON2.ACKDT = 1;     // NACK
    else
        SSPCON2.ACKDT = 0;     // ACK

    SSPCON2.ACKEN = 1;         // Inicia secuencia ACK/NACK
    while(SSPCON2.ACKEN);      // Espera fin

    return received;
}
char I2C_Write(unsigned char _data){

    PIR1.SSPIF = 0;     // limpiar antes

    SSPBUF = _data;

    while(!PIR1.SSPIF);

    PIR1.SSPIF = 0;

    if(ACKSTAT_bit)
        return 0;

    return 1;
}