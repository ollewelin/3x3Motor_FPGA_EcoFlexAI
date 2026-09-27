onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/inst_dut/mipi_clk
add wave -noupdate /top_tb/inst_dut/mipi_clk_reset_n
add wave -noupdate /top_tb/inst_dut/mipi_dphy_rx_clk_CLKOUT
add wave -noupdate /top_tb/inst_dut/mipi_dphy_rx_clk_LP_N_IN
add wave -noupdate /top_tb/inst_dut/mipi_dphy_rx_clk_LP_P_IN
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/mipi_dphy_rx_data0_LP_N_IN
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/mipi_dphy_rx_data0_LP_P_IN
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/mipi_dphy_rx_data1_LP_N_IN
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/mipi_dphy_rx_data1_LP_P_IN
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/mipi_dphy_rx_data2_LP_N_IN
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/mipi_dphy_rx_data2_LP_P_IN
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/mipi_dphy_rx_data3_LP_N_IN
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/mipi_dphy_rx_data3_LP_P_IN
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/mipi_dphy_rx_data0_HS_IN
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/mipi_dphy_rx_data1_HS_IN
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/mipi_dphy_rx_data2_HS_IN
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/mipi_dphy_rx_data3_HS_IN
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/mipi_dphy_tx_SLOWCLK
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/mipi_dphy_tx_clk_LP_N_OUT
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/mipi_dphy_tx_clk_LP_P_OUT
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/mipi_dphy_tx_data0_LP_N_OUT
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/mipi_dphy_tx_data0_LP_P_OUT
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/mipi_dphy_tx_data1_LP_N_OUT
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/mipi_dphy_tx_data1_LP_P_OUT
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/mipi_dphy_tx_data2_LP_N_OUT
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/mipi_dphy_tx_data2_LP_P_OUT
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/mipi_dphy_tx_data3_LP_N_OUT
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/mipi_dphy_tx_data3_LP_P_OUT
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/mipi_dphy_tx_data0_HS_OUT
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/mipi_dphy_tx_data1_HS_OUT
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/mipi_dphy_tx_data2_HS_OUT
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/mipi_dphy_tx_data3_HS_OUT
add wave -noupdate /top_tb/inst_dut/pass
add wave -noupdate -radix decimal /top_tb/inst_dut/rx_data_cnt
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/RxDataHS_0
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/RxDataHS_1
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/RxDataHS_2
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/RxDataHS_3
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/RxSyncHS
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/RxValidHS
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/TxDataHS_0
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/TxDataHS_1
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/TxDataHS_2
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/TxDataHS_3
add wave -noupdate /top_tb/inst_dut/TxRequestHS
add wave -noupdate -radix hexadecimal /top_tb/inst_dut/TxReadyHS
add wave -noupdate /top_tb/inst_dut/TxRequestHSc
add wave -noupdate /top_tb/inst_dut/TxReadyHSc
add wave -noupdate /top_tb/inst_dut/TxStopStateC
add wave -noupdate /top_tb/inst_dut/TxStopStateD
add wave -noupdate -radix hexadecimal {/top_tb/inst_dut/dphy_tx_inst/genblk3[0]/tx_dlane_fsm_inst/current_state}
add wave -noupdate {/top_tb/inst_dut/dphy_tx_inst/genblk3[0]/tx_dlane_fsm_inst/lp_d_cnt}
add wave -noupdate {/top_tb/inst_dut/dphy_tx_inst/genblk3[0]/tx_dlane_fsm_inst/enter_hs_xfer}
add wave -noupdate -radix hexadecimal {/top_tb/inst_dut/dphy_tx_inst/genblk3[0]/tx_dlane_fsm_inst/tx_hs_d_fsm_inst/hs_current_state}
add wave -noupdate /top_tb/inst_dut/RxValidHS
add wave -noupdate /top_tb/inst_dut/rx_init_done
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {101120875 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 313
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {100993850 ps} {101401167 ps}
