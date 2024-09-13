module top_LFSR_Checker(
  input wire clk
);

  wire [7:0] i_lfsr; // output from the LFSR, input to the Checker
  wire [7:0] i_seed;
  wire [7:0] corrupted_lfsr; // signal to hold the corrupted LFSR

  wire rst;
  wire soft_rst;
  wire i_valid;
  wire i_corrupt; 
  
  wire o_lock;

  // Apply corruption to the LFSR output (negate bit 0 if i_corrupt is active)
  assign corrupted_lfsr = i_corrupt ? {i_lfsr[7:1], ~i_lfsr[0]} : i_lfsr;

  // LFSR's instance
  LFSR16_1002D lfsr_inst (
    .clk(clk),
    .i_valid(i_valid),
    .i_seed(i_seed),
    .i_rst(rst),
    .i_soft_reset(soft_rst),
    .LFSR(i_lfsr)
  );

  // Checker's instance with corrupted input
  checker checker_inst (
    .clock(clk),
    .rst(rst),
    .soft_rst(soft_rst),
    .i_valid(i_valid),
    .i_lfsr(corrupted_lfsr), // feed the potentially corrupted sequence
    .o_lock(o_lock)
  );

  
  //! vio instance
  vio u_vio (
      .clk_0       (clk),
      .probe_in0_0  (o_lock),
      .probe_out0_0 (i_corrupt),
      .probe_out1_0 (i_valid),
      .probe_out2_0 (rst),
      .probe_out3_0 (soft_rst),
      .probe_out4_0 (i_seed)       
  );


  //! ila instance - signals to check
  ila u_ila (
      .clk_0    (clk),
      .probe0_0 (i_valid),
      .probe1_0 (i_lfsr)  
  );


endmodule