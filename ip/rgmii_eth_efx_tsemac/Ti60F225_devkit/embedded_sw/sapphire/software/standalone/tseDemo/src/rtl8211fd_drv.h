/*
 * rtl8211fd_drv.h
 *
 *  Created on: 5 Jan 2022
 *      Author: user
 */

#ifndef SRC_RTL8211FD_DRV_H_
#define SRC_RTL8211FD_DRV_H_

#include "bsp.h"

u32 Phy_Rd(u32 RegAddr);
void Phy_Wr(u32 RegAddr,u32 Data);

int rtl8211_drv_rddata(int addr);
void rtl8211_drv_wrdata(int addr ,int data);
void rtl8211_drv_setpage(int page);
void rtl8211_drv_init(void);
int rtl8211_drv_linkup(void);



#endif /* SRC_RTL8211FD_DRV_H_ */
