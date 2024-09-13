module tb_top_LFSR_Checker();

  // Clock and reset
  reg clk;
  reg rst;
  reg soft_rst;
  reg i_valid;
  reg i_corrupt;
  
  reg [7:0] i_seed;

  // Output from top module
  wire o_lock;

  // Instancia del módulo top
  top_LFSR_Checker uut (
    .clk(clk),
    .rst(rst),
    .soft_rst(soft_rst),
    .i_valid(i_valid),
    .i_seed(i_seed),
    .o_lock(o_lock),
    .i_corrupt(i_corrupt)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #50 clk = ~clk; // 100 MHz clock
  end

  // Test sequence
  initial begin
    $display("Start of the simulation");
    // Initialize signals
    rst = 0;
    soft_rst = 0;
    i_valid = 0;
    i_corrupt = 0; // start with no corruption
    i_seed = 8'b11101110;

    // Wait for the system to stabilize and reset
    @(posedge clk);
    rst = 1;
    @(negedge clk);
    rst = 0;

    // Activate valid signal in a toggle pattern
    forever begin
      @(posedge clk);
      i_valid = ~i_valid;
    end
  end

  // Simulate corruption after a certain time
  initial begin
    // Let the system run normally for some time
    #10000;
    $display("Corrupting the sequence");
    @(posedge i_valid);
    i_corrupt = 1; // Start corrupting the LFSR output
    #1000 @(posedge i_valid);
    i_corrupt = 0; // Stop corrupting the LFSR output
    

    // Run for some time and observe outputs
    #5000;

    $display("Corrupting the sequence");
    @(posedge i_valid);
    i_corrupt = 1; // Start corrupting the LFSR output
    #1000 @(posedge i_valid);
    i_corrupt = 0; // Stop corrupting the LFSR output

    // Run for some time and observe outputs
    #5000;

    // Stop simulation
    $finish;
  end


endmodule
