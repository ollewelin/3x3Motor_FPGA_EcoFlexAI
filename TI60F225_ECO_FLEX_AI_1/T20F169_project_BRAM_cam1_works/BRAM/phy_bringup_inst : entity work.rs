phy_bringup_inst : entity work.phy_bringup
  generic map (
    G_SYS_CLK_HZ => G_SYS_CLK_HZ
  )
  port map (
    sys_clk => sys_clk,
    rst_n => rst_n,
    mdio_start => mdio_start,
    mdio_rw => mdio_rw,
    mdio_phyad => mdio_phyad,
    mdio_regad => mdio_regad,
    mdio_wdata => mdio_wdata,
    mdio_busy => mdio_busy,
    mdio_done => mdio_done,
    mdio_rdata => mdio_rdata,
    phy_rst_n => phy_rst_n,
    phy_intr_n => phy_intr_n,
    led_link => led_link,
    id_hi => id_hi,
    id_lo => id_lo
  );
