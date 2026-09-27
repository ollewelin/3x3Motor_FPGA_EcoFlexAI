onerror {quit -f}
vlib work
vlog +define+SIM+SIM_MODE+EFX_SIM -sv ./temac_ex.v
vlog +define+SIM+SIM_MODE+EFX_SIM -sv ./apb3_2_axi4_lite.v
vlog +define+SIM+SIM_MODE+EFX_SIM -sv ./axi4_st_mux.v
vlog +define+SIM+SIM_MODE+EFX_SIM -sv ./mac_pat_gen.v
vlog +define+SIM+SIM_MODE+EFX_SIM -sv ./mac_rx2tx.v
vlog +define+SIM+SIM_MODE+EFX_SIM -sv ./reg_apb3.v
vlog +define+SIM+SIM_MODE+EFX_SIM -sv ./udp_pat_gen.v
vlog +define+SIM+SIM_MODE+EFX_SIM -sv ./tb_header.v
vlog +define+SIM+SIM_MODE+EFX_SIM -sv ./tb_top.v
vlog +define+SIM+SIM_MODE+EFX_SIM -sv ./ODDR.v
vlog +define+SIM+SIM_MODE+EFX_SIM -sv ./glbl.v
vlog +define+SIM+SIM_MODE+EFX_SIM -sv ./DaulClkFifo.v
vlog +define+SIM+SIM_MODE+EFX_SIM -sv ./modelsim/rgmii_eth_efx_tsemac.sv
vsim -t ns work.tb_top
run -all
