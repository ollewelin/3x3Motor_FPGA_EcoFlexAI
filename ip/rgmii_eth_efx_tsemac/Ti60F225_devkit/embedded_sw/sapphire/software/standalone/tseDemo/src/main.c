////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2022 Efinix Inc. All rights reserved.              
//
// This   document  contains  proprietary information  which   is        
// protected by  copyright. All rights  are reserved.  This notice       
// refers to original work by Efinix, Inc. which may be derivitive       
// of other work distributed under license of the authors.  In the       
// case of derivative work, nothing in this notice overrides the         
// original author's license agreement.  Where applicable, the           
// original license agreement is included in it's original               
// unmodified form immediately below this header.                        
//                                                                       
// WARRANTY DISCLAIMER.                                                  
//     THE  DESIGN, CODE, OR INFORMATION ARE PROVIDED “AS IS” AND        
//     EFINIX MAKES NO WARRANTIES, EXPRESS OR IMPLIED WITH               
//     RESPECT THERETO, AND EXPRESSLY DISCLAIMS ANY IMPLIED WARRANTIES,  
//     INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF          
//     MERCHANTABILITY, NON-INFRINGEMENT AND FITNESS FOR A PARTICULAR    
//     PURPOSE.  SOME STATES DO NOT ALLOW EXCLUSIONS OF AN IMPLIED       
//     WARRANTY, SO THIS DISCLAIMER MAY NOT APPLY TO LICENSEE.           
//                                                                       
// LIMITATION OF LIABILITY.                                              
//     NOTWITHSTANDING ANYTHING TO THE CONTRARY, EXCEPT FOR BODILY       
//     INJURY, EFINIX SHALL NOT BE LIABLE WITH RESPECT TO ANY SUBJECT    
//     MATTER OF THIS AGREEMENT UNDER TORT, CONTRACT, STRICT LIABILITY   
//     OR ANY OTHER LEGAL OR EQUITABLE THEORY (I) FOR ANY INDIRECT,      
//     SPECIAL, INCIDENTAL, EXEMPLARY OR CONSEQUENTIAL DAMAGES OF ANY    
//     CHARACTER INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF      
//     GOODWILL, DATA OR PROFIT, WORK STOPPAGE, OR COMPUTER FAILURE OR   
//     MALFUNCTION, OR IN ANY EVENT (II) FOR ANY AMOUNT IN EXCESS, IN    
//     THE AGGREGATE, OF THE FEE PAID BY LICENSEE TO EFINIX HEREUNDER    
//     (OR, IF THE FEE HAS BEEN WAIVED, $100), EVEN IF EFINIX SHALL HAVE 
//     BEEN INFORMED OF THE POSSIBILITY OF SUCH DAMAGES.  SOME STATES DO 
//     NOT ALLOW THE EXCLUSION OR LIMITATION OF INCIDENTAL OR            
//     CONSEQUENTIAL DAMAGES, SO THIS LIMITATION AND EXCLUSION MAY NOT   
//     APPLY TO LICENSEE.                                                
//
////////////////////////////////////////////////////////////////////////////////

#include <stdint.h>
#include "bsp.h"
#include "tseDemo.h"
#include "common.h"
#include "efx_tse_mac.h"

#ifdef PHY8211
#include "rtl8211fd_drv.h"
#else
#include "efx_tse_phy.h"
#endif
////////////////////////////////////////////////////////////////////////////////
void PatGen()
{
	u32 Value;
    //ex_reg pat_dst_mac[47:32]
	write_u32(DST_MAC_H, (TSEMAC_CSR+0x214));
    //ex_reg pat_dst_mac[31:0]
	write_u32(DST_MAC_L, (TSEMAC_CSR+0x210));
    //ex_reg pat_src_mac[47:32]
	write_u32(SRC_MAC_H, (TSEMAC_CSR+0x21c));
    //ex_reg pat_src_mac[31:0]
	write_u32(SRC_MAC_L, (TSEMAC_CSR+0x218));
    //ex_reg pat_src_ip
	write_u32(SRC_IP, (TSEMAC_CSR+0x224));
    //ex_reg pat_dst_ip
	write_u32(DST_IP, (TSEMAC_CSR+0x228));
	Value = (DST_PORT<<16) | (SRC_PORT&0xffff);
    //ex_reg pat_dst_port & pat_src_port 
	write_u32(Value, (TSEMAC_CSR+0x22c));
	Value = (PAT_IPG<<16) | (PAT_NUM&0xffff);
    //ex_reg pat_gen_ipg & pat_gen_num
	write_u32(Value, (TSEMAC_CSR+0x20c));
    //ex_reg pat_mac_dlen
	write_u32(PAT_DLEN, (TSEMAC_CSR+0x220));
    //ex_reg pat_udp_dlen
	write_u32(PAT_DLEN, (TSEMAC_CSR+0x230));
    //ex_reg mac_pat_gen_en & udp_pat_gen_en
	write_u32(0x0, (TSEMAC_CSR+0x208));
	if(PAT_TYPE == 0) {
        //ex_reg pat_mux_select & axi4_st_mux_select
		write_u32(0x0, (TSEMAC_CSR+0x204));
        //ex_reg mac_pat_gen_en & udp_pat_gen_en
		write_u32(0x1, (TSEMAC_CSR+0x208));
        //ex_reg mac_pat_gen_en & udp_pat_gen_en
		write_u32(0x0, (TSEMAC_CSR+0x208));
	} else if(PAT_TYPE == 1) {
        //ex_reg pat_mux_select & axi4_st_mux_select
		write_u32(0x2, (TSEMAC_CSR+0x204));
        //ex_reg mac_pat_gen_en & udp_pat_gen_en
		write_u32(0x2, (TSEMAC_CSR+0x208));
        //ex_reg mac_pat_gen_en & udp_pat_gen_en
		write_u32(0x0, (TSEMAC_CSR+0x208));
	}
	if(PRINTF_EN == 1) {
        bsp_print("Info : Set Pattern Generator.");
	}
}

void StartRunning()
{
    //mac_sw_rst
	write_u32(0x1, (TSEMAC_CSR+0x200));
	if(PRINTF_EN == 1) {
	    bsp_print("Info : Assert mac reset ");
	}
	bsp_uDelay(1);
    //mac_sw_rst
	write_u32(0x0, (TSEMAC_CSR+0x200));
	if(PRINTF_EN == 1) {
	    bsp_print("Info : Deassert mac reset ");
    }

	if(TEST_MODE == 0) {
        //ex_reg pat_mux_select & axi4_st_mux_select
		write_u32(0x0, (TSEMAC_CSR+0x204));
		MacCntClean();
		PatGen();
	} else if(TEST_MODE == 1) {
        //ex_reg pat_mux_select & axi4_st_mux_select
		write_u32(0x1, (TSEMAC_CSR+0x204));
		MacAddrSet(0, 1);
		MacCntClean();

	}

	while(1){
		bsp_uDelay(3000000);
		CntMonitor();
	}
}

static void PhyLoopInit(u32 speed)
{
	//PhyDlySetRXTX(15, 15); //change the delay here for Test_mode_0 (Normal mode)
	u32 Value;
	if(speed == 0x4) {
		Phy_Wr(0x0, 0x4140);
		if(PRINTF_EN == 1) {
			bsp_print("Info : Set Phy 1000Mbps Loopback Mode.");
		}
	} else if(speed == 0x2) {
		Phy_Wr(0x0, 0x6100);
		if(PRINTF_EN == 1) {
			bsp_print("Info : Set Phy 100Mbps Loopback Mode.");
		}
	} else if(speed == 0x1) {
		Phy_Wr(0x0, 0x4100);
		if(PRINTF_EN == 1) {
			bsp_print("Info : Set Phy 10Mbps Loopback Mode.");
		}
	}
}


////////////////////////////////////////////////////////////////////////////////
void main() {
    u32 prompt=0;
    u32 speed;

    bsp_init();
    bsp_print("tse demo !");
	#ifdef PHY8211
    rtl8211_drv_init();
    bsp_print("Waiting Link Up...");
    speed=rtl8211_drv_linkup();
	if(TEST_MODE == 1){
	    	PhyLoopInit(speed); // 4=1000Mbps, 2=100Mbps, 1=10Mbps, change the number to change speed
			MacAddrSet(1,1);
			MacIpgSet(0x0C);
	    }
	else if (TEST_MODE == 0){
		MacNormalInit(speed);
	}
	#else
	speed = PhyNormalInit();
	if(TEST_MODE == 1){
	    	PhyLoopInit(2); // 4=1000Mbps, 2=100Mbps, 1=10Mbps, change the number to change speed
	    }
	#endif
	

    StartRunning();

}
