`timescale 1ns / 1ps

module tb_RGB_to_YCbCr;

    // Inputs
    reg clk;
    reg nRST;
    reg [15:0] RGB_data;

    // Outputs
    wire [23:0] YCbCr_data;

    // Instantiate the module
    RGB_to_YCbCr uut (
        .clk(clk),
        .nRST(nRST),
        .RGB_data(RGB_data),
        .YCbCr_data(YCbCr_data)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Test stimulus
    initial begin
        nRST = 0;
        RGB_data = 16'd0;
        #10 nRST = 1;


        #15
        #20 RGB_data = 16'd8029; //1        
        #20 RGB_data = 16'd57237;//2
        #20 RGB_data = 16'd12190;//3
        #20 RGB_data = 16'd56650;//4
        #20 RGB_data = 16'd13219;//5
        #20 RGB_data = 16'd42553;//6
        #20 RGB_data = 16'd22248;//7


    end

endmodule

