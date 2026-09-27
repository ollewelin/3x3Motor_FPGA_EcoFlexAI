/*
 * rtl8211fd_drv.c
 *
 *  Created on: 5 Jan 2022
 *      Author: user
 */

#include "bsp.h"
#include "riscv.h"
#include "common.h"
#include "dmasg.h"
//#include "mac.h"
#include "tseDemo.h"
#include "compatibility.h"

u32 Phy_Rd(u32 RegAddr)
{
    u32 Value;
    Reg_Out32((TSEMAC_CSR+0x108), ((PHY_ADDR&0x1f)<<8)|(RegAddr&0x1f));
    Reg_Out32((TSEMAC_CSR+0x104), 0x1);
    bsp_uDelay(1000);
    Value = Reg_In32(TSEMAC_CSR+0x110);

    return Value;
}
void Phy_Wr(u32 RegAddr,u32 Data)
{
    Reg_Out32((TSEMAC_CSR+0x108), ((PHY_ADDR&0x1f)<<8)|(RegAddr&0x1f));
    Reg_Out32((TSEMAC_CSR+0x10c), Data);
    Reg_Out32((TSEMAC_CSR+0x104), 0x2);
}

int rtl8211_drv_rddata(int addr)
{
	 return Phy_Rd(addr);
}

void rtl8211_drv_wrdata(int addr ,int data)
{
	 Phy_Wr(addr,data);
	 bsp_uDelay(100);
}

void rtl8211_drv_setpage(int page)
{
	 Phy_Wr(31,page & 0xFFFF);
	 bsp_uDelay(100);
}

int rtl8211_drv_linkup(void)
{
	int phy_reg=0;
	int speed=Speed_100Mhz;//i change from Speed_1000Mhz

	 while(1)
	{
		phy_reg=rtl8211_drv_rddata(26); //Phy_Rd(addr) addr = 26, this is just to read link status

		if(phy_reg & 0x04)
		{
			bsp_printf("Linked Up");
			break;
		}

		bsp_uDelay(10000);
	}

	if((phy_reg & 0x30) == 0x20)//check bit 4&5 for speed 1000Mbps, and maybeeeeeeee linked partner mode
	{
		if(phy_reg & 0x08)//check if full duplex
			bsp_printf("Link Partner Full duplex 1000 Mbps Reg26 0x%x",phy_reg);
		else
			bsp_printf("Link Partner half duplex 1000 Mbps Reg26 0x%x",phy_reg);
		speed = Speed_1000Mhz;
	}
	else if((phy_reg & 0x30) == 0x10)
	{
		if(phy_reg & 0x08)
			bsp_printf("Link Partner Full duplex 100 Mbps Reg26 0x%x",phy_reg);
		else
			bsp_printf("Link Partner half duplex 100 Mbps Reg26 0x%x",phy_reg);
		speed = Speed_100Mhz;
	}
	else if((phy_reg & 0x30) == 0)
	{
		if(phy_reg & 0x08)
			bsp_printf("Link Partner Full duplex 10 Mbps Reg26 0x%x",phy_reg);
		else
			bsp_printf("Link Partner half duplex 10 Mbps Reg26 0x%x",phy_reg);
		speed = Speed_10Mhz;
	}

	return speed;
}

void rtl8211_drv_init(void)
{
	rtl8211_drv_setpage(0);//Phy_Wr(31,page & 0xFFFF);
	rtl8211_drv_wrdata(0,0x9000);//Phy_Wr(addr,data); here eneble auto negotiation and make a phyreset
	bsp_uDelay(1000*50);
	rtl8211_drv_wrdata(0,0x1000);//auto negotiate again just to make sure
	bsp_uDelay(1000*50);

	rtl8211_drv_setpage(0x0A43);
	rtl8211_drv_wrdata(27,0x8011);//reserved register
	rtl8211_drv_wrdata(28,0xD73F);//reserved register

	rtl8211_drv_setpage(0xD04);
	rtl8211_drv_wrdata(0x10,0x820B);//reserved register
}
