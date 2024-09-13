`timescale 1ns / 1ps // the first number is the time unit, the second is the time precision

module tb_lfsr;

// now the inputs and outputs are regs 'cause now these have values
reg clk;
reg i_valid;
reg i_rst;
reg i_soft_reset;
reg [7:0] i_seed;

// the output is a wire 'cause it's a signal that we can't change
wire  [7:0] LFSR;

// the module that we want to test
LFSR16_1002D lfsr(
  .clk(clk),
  .i_valid(i_valid),
  .i_rst(i_rst),
  .i_soft_reset(i_soft_reset),
  .i_seed(i_seed),
  .LFSR(LFSR)
);

// the clock signal, it has to be a 10MHz signal so 1/10MHz = 100ns
// So it has to be 50ns high and 50ns low
initial begin
  clk = 0;
  forever #50 clk = ~clk;
end

// task to change the value of i_seed
task change_seed;
  input [7:0] new_seed; // vivado let us to choose the new seed
  begin
    @(posedge clk); // wait for the next rising edge
    i_seed = new_seed;
    i_soft_reset = 1;
    @(posedge clk); // wait for the next rising edge
    i_soft_reset = 0;
  end
endtask

// task to stay in the asincronous reset state for a random time between 1 and 250 us
task async_reset;
  integer async_delay;
  begin
    async_delay = (($urandom % 250) + 1) * 1000; // random time between 1 and 250 us
    i_rst = 1;
    #(async_delay);
    @(posedge clk);
    i_rst = 0;
  end
endtask

// task to generate a syncronous reset
task sync_reset;
  integer sync_delay;
  begin
    sync_delay = (($urandom % 250) + 1) * 1000; // random time between 1 and 250 us
    i_soft_reset = 1;
    #(sync_delay);
    @(posedge clk);
    i_soft_reset = 0;
  end
endtask

// start of the test
initial begin
  
  $display("Start of the simulation");
  // take the system to a know state
  i_rst = 0;
  i_soft_reset = 0;
  i_valid = 0;
  i_seed = 8'b10101010;

  // wait for the system to stabilize and make a reset
  #100;
  i_rst = 1;
  #100; 
  i_rst = 0;

  // now make the i_valid signal change forever for a normal test
  forever begin
    @(posedge clk);
    i_valid = $urandom % 2;
  end
end

// we divide the initial block in two because the forever block is infinite

initial begin

  // waits 200 microseconds
  #200000;
  // now we print the current value of the LFSR
  // and trigger the async_reset task
  $display("LFSR = %b", LFSR);
  $display("Triggering async_reset task");
  async_reset;
  $display("LFSR = %b", LFSR);

  // waits 200 microseconds
  #200000;
  // now we trigger the sync_reset task
  $display("Triggering sync_reset task");
  sync_reset;
  $display("LFSR = %b", LFSR);

  // waits 200 microseconds
  #200000;
  // now we change the seed to 8'b11111111
  $display("Changing seed to 8'b11111111");
  $display("Time: %t", $time);
  change_seed(8'b11111111);
  $display("LFSR = %b", LFSR);

  //waits 200 microseconds
  #200000;

  // end of the simulation
  $finish;
end
endmodule



  

  










