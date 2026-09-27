test_cnt_inst : entity work.test_cnt
  port map (
    clk => clk,
    pll_clk => pll_clk,
    cnt => cnt
  );
