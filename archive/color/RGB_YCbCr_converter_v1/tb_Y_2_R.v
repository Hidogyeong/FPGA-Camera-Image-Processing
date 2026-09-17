`timescale 1ns / 1ps

module tb_YCbCr_to_RGB;

    // Inputs
    reg clk;
    reg nRST;
    reg [23:0] YCbCr_data;

    // Outputs
    wire [15:0] RGB_data;

    // Instantiate the module
    YCbCr_to_RGB uut (
        .clk(clk),
        .nRST(nRST),
        .YCbCr_data(YCbCr_data),
        .RGB_data(RGB_data)
    );


    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test stimulus
    initial begin
        nRST = 0;
     // Example YCbCr input

        // Reset
        #15 nRST = 1;
        YCbCr_data = 24'ha6a41b; //1
        // Apply YCbCr data
        #20 YCbCr_data = 24'hff637d; //2
        #20 YCbCr_data = 24'hb0a31f; //3
        #20 YCbCr_data = 24'hfd4fa1; //4
        #20 YCbCr_data = 24'h535e67; //5 
        #20 YCbCr_data = 24'hf98a70; //6
        #20 YCbCr_data = 24'h9d4b49; //7
        #20 YCbCr_data = 24'haf27ad; //8
        // Add more stimulus if necessary
 // Stop simulation after some time
    end

endmodule

