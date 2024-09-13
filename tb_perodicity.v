`timescale 1ns / 1ps

module tb_perodicity;

reg clk;
reg i_valid;
reg i_rst;
reg i_soft_reset;
reg [7:0] i_seed;

wire  [7:0] LFSR;

LFSR16_1002D lfsr(
  .clk(clk),
  .i_valid(i_valid),
  .i_rst(i_rst),
  .i_soft_reset(i_soft_reset),
  .i_seed(i_seed),
  .LFSR(LFSR)
);

initial begin
  clk = 0;
  forever #50 clk = ~clk;
end

task normal_periodicity;
    integer count;
    begin
        @(posedge clk);
        count = 0;
        i_seed = 8'b00000001;
        i_soft_reset = 1;
        @(posedge clk);
        i_soft_reset = 0;

        //wait for the LFSR to reach the seed
        #100

        while (LFSR != i_seed) begin
            @(posedge clk);
            count = count + 1;
        end
        $display("The period is %d", count);
    end
endtask

task random_periodicity;
    integer count;
    input [7:0] new_seed;
    begin
        @(posedge clk);
        count = 0;
        i_seed = new_seed;
        i_soft_reset = 1;
        @(posedge clk);
        i_soft_reset = 0;

        //wait for the LFSR to reach the new seed
        #100
        while (LFSR != new_seed) begin
            @(posedge clk);
            count = count + 1;
        end
        $display("The period is %d", count);
    end
endtask

// start of the test
initial begin
    $display("Start of the simulation");

    // take the system to a know state
    i_rst = 0;
    i_soft_reset = 0;
    i_valid = 0;

    // wait for the system to stabilize
    #100;

    // now make the i_valid signal change forever for a normal test
    forever begin
        @(posedge clk);
        i_valid = ~i_valid;
    end
end

initial begin
    
    //waits and ejecutes the normal periodicity task
    #20000
    normal_periodicity;

    //waits and ejecutes the random periodicity task
    #200000
    random_periodicity($urandom);

    $finish;
end
endmodule

