//CSI2 TX
./../csi2_source/csi2_delay_sync.sv                                     
./../csi2_source/csi2_ecc_gen.sv
./../csi2_source/csi2_image_iface.sv
./../csi2_source/csi2_packetizer.sv
./../csi2_source/csi2_pixel2byte.sv
./../csi2_source/csi2_pack64bit.sv
./../csi2_source/csi2_pack56bit.sv
./../csi2_source/csi2_pack48bit.sv
./../csi2_source/csi2_pack40bit.sv
./../csi2_source/csi2_tx_csr.sv
./../csi2_source/efx_csi2_tx.sv 

//CSI2 RX
./../csi2_source/csi2_byte2pixel.sv
./../csi2_source/csi2_rx_csr.sv         
./../csi2_source/csi2_depacketizer.sv                                          
./../csi2_source/csi2_lane_aligner.sv
./../csi2_source/csi2_depack40bit.sv    
./../csi2_source/csi2_depack48bit.sv     
./../csi2_source/csi2_depack56bit.sv
./../csi2_source/csi2_depack64bit.sv
./../csi2_source/csi2_ecc_check.sv    
./../csi2_source/efx_csi2_rx.sv 

//CSI2 common
./../csi2_source/csi2_crc16_d8_gen.sv      
./../csi2_source/csi2_crc16_d16_gen.sv 
./../csi2_source/csi2_crc16_d32_gen.sv 
./../csi2_source/csi2_crc16_d64_gen.sv 

//DPHY TX
./../dphy_source/efx_dphy_tx.sv
./../dphy_source/dphy_tx_hs_d_fsm.sv
./../dphy_source/dphy_tx_hs_c_fsm.sv
./../dphy_source/dphy_tx_dlane_fsm.sv
./../dphy_source/dphy_tx_clane_fsm.sv

//DPHY RX
./../dphy_source/efx_dphy_rx.sv
./../dphy_source/dphy_rx_clane_fsm.sv
./../dphy_source/dphy_rx_deskew_cal.sv
./../dphy_source/dphy_rx_dlane_fsm.sv
./../dphy_source/dphy_rx_dword_align.sv

//FIFO
./../fifo_source/bin2gray.v
./../fifo_source/efx_asyncfifo_ctl.v
./../fifo_source/efx_fifo_ctl_sm.v
./../fifo_source/efx_fifo_functions.vh
./../fifo_source/efx_syncfifo_ctl.v
./../fifo_source/gray2bin.v
./../fifo_source/pipe_reg.v
./../fifo_source/simple_dual_port_ram_fifo.v
./../fifo_source/efx_fifo_wrapper.v