module LFSR16_1002D(
  input wire clk,
  input wire i_valid, // signal to indicate that we can genereate a new bit secuence 
  input wire [7:0 ] i_seed, // new initial seed
  input wire i_rst, // reset signal
  input wire i_soft_reset, // soft reset signal

  output reg [7:0] LFSR
);

wire feedback = LFSR[7] ^ (LFSR[6:0]==7'b0000000);

parameter seed = 8'b00000001 ;

// inside the always block the i_rst has the priority over the i_soft_reset and the other blocks are secuentual
always @(posedge clk or posedge i_rst) begin // i_rst is for an eventual hard reset of the system
  if(i_rst) begin
    LFSR <= seed;
  end
  else if(i_soft_reset) begin
    LFSR <= i_seed;
  end
  else if (i_valid) begin
    LFSR[0] <= feedback;
    LFSR[1] <= LFSR[0];
    LFSR[2] <= LFSR[1] ^ feedback;
    LFSR[3] <= LFSR[2] ^ feedback;
    LFSR[4] <= LFSR[3] ^ feedback;
    LFSR[5] <= LFSR[4];
    LFSR[6] <= LFSR[5];
    LFSR[7] <= LFSR[6];
  end
end
endmodule
