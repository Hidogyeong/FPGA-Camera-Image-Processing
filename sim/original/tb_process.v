`timescale 1ns/1ps

module process_tb();

  // Inputs
  reg clk;
  wire UP_CLK;
  reg nRST;
  reg data_EN;
  reg [23:0] vcnt;
  reg [23:0] YCbCr_data;

  // Outputs
  wire [15:0] filtered_data;
  wire RESET;

  assign RESET = ~nRST;
  // Instantiate the module
  process uut (
    .clk(clk),
    .UP_CLK(UP_CLK),
    .nRST(nRST),
    .data_EN(data_EN),
    .vcnt(vcnt),
    .YCbCr_data(YCbCr_data),
    .filtered_data(filtered_data)
  );

      g2m uutt (
    .CLK(clk),
    .RESET(RESET),
    .UP_CLK(UP_CLK)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test scenario
  initial begin
    // Initialize inputs
    nRST = 1;
    data_EN = 0;
    vcnt = 0;
    YCbCr_data = 24'h000000;

    // Apply reset
    nRST = 0;
    #10 nRST = 1;

    // Start testing
    #45 
    data_EN = 1;
    YCbCr_data = 24'haaaaaa;
    
    #40
    YCbCr_data = 24'hbbbbbb;

    #40
    YCbCr_data = 24'hcccccc;

    #40
    YCbCr_data = 24'hdddddd;
    vcnt = 480;
    #20

    #20 
    YCbCr_data = 24'h000000;
    data_EN = 0;
    
  

    #120
    data_EN = 1;
    YCbCr_data = 24'h111111;
    
    #40
    YCbCr_data = 24'h222222;

    #40
    YCbCr_data = 24'h333333;

    #40
    YCbCr_data = 24'h444444;
    vcnt = 960;
    #40 
    YCbCr_data = 24'h000000;
    vcnt = 960;
    data_EN = 0;


    #120
    data_EN = 1;
    YCbCr_data = 24'heeeeee;
    
    #40
    YCbCr_data = 24'hffffff;

    #40
    YCbCr_data = 24'h555555;

    #40
    YCbCr_data = 24'h666666;
    vcnt = 24'd130560;
    #40 
    YCbCr_data = 24'h000000;
 
    data_EN = 0;

    #200
    data_EN = 1;
    #160
    data_EN = 0;

  end

endmodule
