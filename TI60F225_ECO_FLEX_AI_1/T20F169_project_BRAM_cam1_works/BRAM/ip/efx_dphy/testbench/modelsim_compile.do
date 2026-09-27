vlib work

vlog top_tb.sv
vlog reset.v
vlog -sv top.sv -f dphy_filelist.f

vsim -t ps work.top_tb

add wave -position insertpoint  \
sim:/top_tb/inst_dut/mipi_clk \
sim:/top_tb/inst_dut/mipi_clk_reset_n \
sim:/top_tb/inst_dut/mipi_dphy_rx_clk_CLKOUT \
sim:/top_tb/inst_dut/mipi_dphy_rx_clk_LP_N_IN \
sim:/top_tb/inst_dut/mipi_dphy_rx_clk_LP_P_IN \
sim:/top_tb/inst_dut/mipi_dphy_rx_data0_HS_IN \
sim:/top_tb/inst_dut/mipi_dphy_rx_data0_LP_N_IN \
sim:/top_tb/inst_dut/mipi_dphy_rx_data0_LP_P_IN \
sim:/top_tb/inst_dut/mipi_dphy_rx_data1_HS_IN \
sim:/top_tb/inst_dut/mipi_dphy_rx_data1_LP_N_IN \
sim:/top_tb/inst_dut/mipi_dphy_rx_data1_LP_P_IN \
sim:/top_tb/inst_dut/mipi_dphy_rx_data2_HS_ENA \
sim:/top_tb/inst_dut/mipi_dphy_rx_data2_LP_N_IN \
sim:/top_tb/inst_dut/mipi_dphy_rx_data2_LP_P_IN \
sim:/top_tb/inst_dut/mipi_dphy_rx_data3_HS_IN \
sim:/top_tb/inst_dut/mipi_dphy_rx_data3_LP_N_IN \
sim:/top_tb/inst_dut/mipi_dphy_rx_data3_LP_P_IN \
sim:/top_tb/inst_dut/mipi_dphy_tx_clk_LP_N_OUT \
sim:/top_tb/inst_dut/mipi_dphy_tx_clk_LP_P_OUT \
sim:/top_tb/inst_dut/mipi_dphy_tx_data0_HS_OUT \
sim:/top_tb/inst_dut/mipi_dphy_tx_data0_LP_N_OUT \
sim:/top_tb/inst_dut/mipi_dphy_tx_data0_LP_P_OUT \
sim:/top_tb/inst_dut/mipi_dphy_tx_data1_HS_OUT \
sim:/top_tb/inst_dut/mipi_dphy_tx_data1_LP_N_OUT \
sim:/top_tb/inst_dut/mipi_dphy_tx_data1_LP_P_OUT \
sim:/top_tb/inst_dut/mipi_dphy_tx_data2_HS_OUT \
sim:/top_tb/inst_dut/mipi_dphy_tx_data2_LP_N_OUT \
sim:/top_tb/inst_dut/mipi_dphy_tx_data2_LP_P_OUT \
sim:/top_tb/inst_dut/mipi_dphy_tx_data3_HS_OUT \
sim:/top_tb/inst_dut/mipi_dphy_tx_data3_LP_N_OUT \
sim:/top_tb/inst_dut/mipi_dphy_tx_data3_LP_P_OUT
add wave -position insertpoint  \
sim:/top_tb/inst_dut/pass
add wave -position insertpoint  \
sim:/top_tb/inst_dut/RxDataHS_0 \
sim:/top_tb/inst_dut/RxDataHS_1 \
sim:/top_tb/inst_dut/RxDataHS_2 \
sim:/top_tb/inst_dut/RxDataHS_3
add wave -position insertpoint  \
sim:/top_tb/inst_dut/RxSyncHS \
sim:/top_tb/inst_dut/RxValidHS
add wave -position insertpoint  \
sim:/top_tb/inst_dut/TxDataHS_0 \
sim:/top_tb/inst_dut/TxDataHS_1 \
sim:/top_tb/inst_dut/TxDataHS_2 \
sim:/top_tb/inst_dut/TxDataHS_3 \
sim:/top_tb/inst_dut/TxReadyHS \
sim:/top_tb/inst_dut/TxRequestHS