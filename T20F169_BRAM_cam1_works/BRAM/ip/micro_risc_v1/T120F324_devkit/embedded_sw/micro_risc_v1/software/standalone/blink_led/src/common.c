#include "common.h"

u32 axi_slave_read32(u32 address) {
   u32 data;
   data = read_u32(address);
   return data;
}

u32 number_pow(u32 base ,u32 pow)
{
	u32 i=1;
	u32 out=1;

		 if(pow==0)return 1;
	else if(pow==1)return base;
	else
	{
		while(i<=pow){
			out=out*base;
			i++;
		}
		return out;
	}

	return 0;	//error
}

void msDelay(u32 ms)
{
	bsp_uDelay(ms*1000);
}



void mipi_i2c_init(){
    //I2C init
    I2c_Config i2c_mipi;
    i2c_mipi.samplingClockDivider = 3;
    i2c_mipi.timeout = I2C_CTRL_HZ/1000;
    i2c_mipi.tsuDat  = I2C_CTRL_HZ/2000000;

    i2c_mipi.tLow  = I2C_CTRL_HZ/800000;
    i2c_mipi.tHigh = I2C_CTRL_HZ/800000;
    i2c_mipi.tBuf  = I2C_CTRL_HZ/400000;
    i2c_applyConfig(I2C_CTRL_MIPI, &i2c_mipi);

}

