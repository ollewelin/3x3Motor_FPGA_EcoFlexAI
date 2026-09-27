/*
 * commom.h
 *
 *  Created on: Aug 18, 2020
 *      Author: shchung
 */

#ifndef SRC_COMMON_H_
#define SRC_COMMON_H_

#include "bsp.h"
#include "compatibility.h"


#define Speed_1000Mhz		0x04
#define Speed_100Mhz		0x02
#define Speed_10Mhz			0x01
#define PHY8211 1 //change to 0 when using Trion
#define Eclipse 0 //change to 1 if using Eclipse IDE
void bsp_printf_c(int c);
void bsp_printf_s(char *p);
void bsp_printf_d(int val);
void bsp_printf(const char *format, ...);
int bsp_puts(char *s);
int putchar(int c);
void print_hex(uint32_t val, uint32_t digits);

/************************** Function File ***************************/
void Reg_Out32(u32 addr,u32 data);
u32 Reg_In32(u32 addr);


#endif /* SRC_COMMON_H_ */
