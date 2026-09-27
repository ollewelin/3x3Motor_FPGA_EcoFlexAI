edb_top edb_top_inst (
    .bscan_CAPTURE      ( jtag_inst1_CAPTURE ),
    .bscan_DRCK         ( jtag_inst1_DRCK ),
    .bscan_RESET        ( jtag_inst1_RESET ),
    .bscan_RUNTEST      ( jtag_inst1_RUNTEST ),
    .bscan_SEL          ( jtag_inst1_SEL ),
    .bscan_SHIFT        ( jtag_inst1_SHIFT ),
    .bscan_TCK          ( jtag_inst1_TCK ),
    .bscan_TDI          ( jtag_inst1_TDI ),
    .bscan_TMS          ( jtag_inst1_TMS ),
    .bscan_UPDATE       ( jtag_inst1_UPDATE ),
    .bscan_TDO          ( jtag_inst1_TDO ),
    .la0_clk            ( $INSERT_YOUR_CLOCK_NAME ),
    .la0_rst_n      ( la0_rst_n ),
    .la0_led4_OUT       ( la0_led4_OUT ),
    .la0_div        ( la0_div ),
    .la0_u_cam_ctrl/cam_setup_cnt       ( la0_u_cam_ctrl/cam_setup_cnt ),
    .la0_u_cam_ctrl/done        ( la0_u_cam_ctrl/done ),
    .la0_u_cam_ctrl/want_mux_byte       ( la0_u_cam_ctrl/want_mux_byte ),
    .la0_u_cam_ctrl/mux_val     ( la0_u_cam_ctrl/mux_val ),
    .la0_u_cam_ctrl/mux_ok      ( la0_u_cam_ctrl/mux_ok ),
    .la0_u_cam_ctrl/rst_n       ( la0_u_cam_ctrl/rst_n ),
    .la0_u_cam_ctrl/mst_num_bytes       ( la0_u_cam_ctrl/mst_num_bytes ),
    .la0_u_cam_ctrl/i2c_busy        ( la0_u_cam_ctrl/i2c_busy ),
    .la0_u_cam_ctrl/mst_data_out_valid      ( la0_u_cam_ctrl/mst_data_out_valid ),
    .la0_u_cam_ctrl/mst_read        ( la0_u_cam_ctrl/mst_read ),
    .la0_u_cam_ctrl/mst_write_done      ( la0_u_cam_ctrl/mst_write_done ),
    .la0_u_cam_ctrl/mst_command_byte        ( la0_u_cam_ctrl/mst_command_byte ),
    .la0_u_cam_ctrl/i2c_soft_rst        ( la0_u_cam_ctrl/i2c_soft_rst ),
    .la0_u_cam_ctrl/mst_write       ( la0_u_cam_ctrl/mst_write ),
    .la0_u_cam_ctrl/i2c_slave_addr      ( la0_u_cam_ctrl/i2c_slave_addr ),
    .la0_FPGA_IO0_A2        ( la0_FPGA_IO0_A2 ),
    .la0_i2c_scl_line       ( la0_i2c_scl_line ),
    .la0_cam_i2c_done       ( la0_cam_i2c_done ),
    .la0_io_asyncReset_sig      ( la0_io_asyncReset_sig ),
    .la0_I2C_SDA_OUT        ( la0_I2C_SDA_OUT ),
    .la0_cam_setup_cnt      ( la0_cam_setup_cnt ),
    .la0_FPGA_IO0_A0        ( la0_FPGA_IO0_A0 ),
    .la0_I2C_SCL_OE     ( la0_I2C_SCL_OE ),
    .la0_FPGA_IO0_A1        ( la0_FPGA_IO0_A1 ),
    .la0_i2c_busy       ( la0_i2c_busy ),
    .la0_CAM0_EN        ( la0_CAM0_EN ),
    .la0_I2C_SCL_OUT        ( la0_I2C_SCL_OUT ),
    .la0_IO12_manual_reset_n        ( la0_IO12_manual_reset_n ),
    .la0_I2C_SCL_IN     ( la0_I2C_SCL_IN ),
    .la0_I2C_SDA_IN     ( la0_I2C_SDA_IN ),
    .la0_I2C_SDA_OE     ( la0_I2C_SDA_OE ),
    .la0_CAM1_EN        ( la0_CAM1_EN ),
    .la0_u_cam_ctrl/state       ( la0_u_cam_ctrl/state ),
    .la0_u_cam_ctrl/mst_data_out        ( la0_u_cam_ctrl/mst_data_out ),
    .la0_u_cam_ctrl/mst_din     ( la0_u_cam_ctrl/mst_din ),
    .la0_u_cam_ctrl/cam_idx     ( la0_u_cam_ctrl/cam_idx ),
    .la0_u_cam_ctrl/to_cnt      ( la0_u_cam_ctrl/to_cnt ),
    .la0_u_cam_ctrl/sr_cnt      ( la0_u_cam_ctrl/sr_cnt ),
    .la0_div[0]     ( la0_div[0] ),
    .la0_div[5]     ( la0_div[5] ),
    .la0_div[2]     ( la0_div[2] ),
    .la0_div[6]     ( la0_div[6] ),
    .la0_div[3]     ( la0_div[3] ),
    .la0_div[7]     ( la0_div[7] ),
    .la0_div[4]     ( la0_div[4] ),
    .la0_div[1]     ( la0_div[1] )
);

////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2025 Efinix Inc. All rights reserved.              
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
