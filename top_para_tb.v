module top_LFSR_Checker(
  input wire clk,
  input wire rst,
  input wire soft_rst,
  input wire i_valid,
  input wire i_corrupt, // to negate the 0 bit of the LFSR
  input wire [7:0] i_seed,
  output wire o_lock
);

  // signal to interconnect the LFSR and the Checker
  wire [7:0] i_lfsr; // output from the LFSR, input to the Checker
  wire [7:0] corrupted_lfsr; // signal to hold the corrupted LFSR

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

  // Checker's instance 
  checker checker_inst (
    .clock(clk),
    .rst(rst),
    .soft_rst(soft_rst),
    .i_valid(i_valid),
    .i_lfsr(corrupted_lfsr), 
    .o_lock(o_lock)
  );

endmodule
