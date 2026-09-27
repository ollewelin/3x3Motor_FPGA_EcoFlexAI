vlib work

vlog -sv TI180_MIPI_csi_tb.sv
vlog -sv /projects/DIP/shlim/efx_IP/efx_csi2/project_new/top.sv
vlog -sv /projects/MISC/ip.m31t/MIPI_DPHY/CLN16FFC/TX_latest/verilog_rtl_vqm/M31DPHYTX512TL016D_00117701_A.vp.vqm
vlog -sv /projects/MISC/ip.m31t/MIPI_DPHY/CLN16FFC/TX_latest/verilog_rtl_vqm/M31DPHYTX512TL016D_00117701_rtl.vp.vqm
vlog -sv /projects/MISC/ip.m31t/MIPI_DPHY/CLN16FFC/RX_latest/verilog_rtl_vqm/M31DPHYRX612TL016D_00117701_A.vp.vqm
vlog -sv /projects/MISC/ip.m31t/MIPI_DPHY/CLN16FFC/RX_latest/verilog_rtl_vqm/M31DPHYRX612TL016D_00117701_rtl.vp.vqm
vlog -sv ./mipi_phy_analog_clk_gen_i2c_4st2.v
     
vlog ../../source_exp/reset.v
vlog ../../source_exp/videogen_n_comparator/datatype_gen.v  
vlog ../../source_exp/videogen_n_comparator/dual_clock_fifo.v  
vlog ../../source_exp/videogen_n_comparator/shift_reg.v             
vlog ../../source_exp/videogen_n_comparator/vga_gen.v
vlog ../../source_exp/videogen_n_comparator/data_unpack.v   
vlog ../../source_exp/videogen_n_comparator/pattern_gen.v      
vlog ../../source_exp/videogen_n_comparator/simple_dual_port_ram.v

vlog -f ./rtl_list.f -sv 
vopt +acc=npr -noprotectopt TI180_MIPI_csi_tb -o opt
do wave.do
vsim -t 1ps opt -do "run -a;"