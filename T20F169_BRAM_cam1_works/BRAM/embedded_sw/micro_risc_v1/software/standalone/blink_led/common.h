#ifndef SRC_COMMON_H_
#define SRC_COMMON_H_

#include "soc.h"
#include "bsp.h"
#include "i2c.h"

#define I2C_CTRL_MIPI	SYSTEM_I2C_0_IO_CTRL
#define I2C_CTRL_HDMI	SYSTEM_I2C_1_IO_CTRL

u32 axi_slave_read32(u32 address);
void msDelay(u32 ms);
u32 number_pow(u32 base ,u32 pow);
void mipi_i2c_init(void);

#endif 
