`timescale 1ns/10ps
`define   CC  5


module tb_pack_unpack();

    reg clk;
    reg nRST;
    reg [15:0] datain;
    reg [3:0] addr_w;
    reg [3:0] addr_r;
    wire UP_CLK;
    wire [2:0] addr;
    wire [31:0] data_r;
    wire [31:0] data_w;
    wire [15:0] dataout;

    packing_unpacking dut (
        .clk(clk),
        .nRST(nRST),
        .datain(datain),
        .addr_w(addr_w),
        .addr_r(addr_r),
        .data_r(data_r),
        .UP_CLK(UP_CLK),
        .addr(addr),
        .data_w(data_w),
        .dataout(dataout)
    );

    spsram block_ram (
        .CK(~clk),
        .WEN(UP_CLK),
        .A(addr),
        .DI(data_w),
        .DOUT(data_r)
        );

    always begin
        #5 clk = ~clk;
    end
    initial begin
        #125
        addr_r = 1;
        #40
        addr_r = 2;
        #40
        addr_r = 3;
        #40
        addr_r = 4;
        #40
        addr_r = 5;
        #40
        addr_r = 6;
        #40
        addr_r = 7;
                #40
        addr_r = 8;
                #40
        addr_r = 9;
                #40
        addr_r = 10;
                #40
        addr_r = 11;
                #40
        addr_r = 12;
                #40
        addr_r = 13;
                #40
        addr_r = 14;
        #40
        addr_r = 0;
        #120
        addr_r = 1;
        #40
        addr_r = 2;
        #40
        addr_r = 3;
        #40
        addr_r = 4;
        #40
        addr_r = 5;
        #40
        addr_r = 6;
        #40
        addr_r = 7;
                #40
        addr_r = 8;
                #40
        addr_r = 9;
                #40
        addr_r = 10;
                #40
        addr_r = 11;
                #40
        addr_r = 12;
                #40
        addr_r = 13;
                #40
        addr_r = 14;


    end

    initial begin
        // Initialize signals
        clk = 0;
        nRST = 0;
        datain = 0;
        addr_w = 0;


        // Reset
        #40 nRST = 1;


        #5
        // Test data
        datain = 16'hAAAA;
        addr_w = 1;

        #40;

        datain = 16'hBBBB;
        addr_w = 2;

        #40;

        datain = 16'hCCCC;
        addr_w = 3;

        #40;

        datain = 16'hDDDD;
        addr_w = 4;
        #40;

        datain = 16'hEEEE;
        addr_w = 5;
        #40;

        datain = 16'hFFFF;
        addr_w = 6;
        #40;

        datain = 16'h1111;
        addr_w = 7;
        #40;

        datain = 16'h2222;
        addr_w = 8;
        #40;
        
        datain = 16'h3333;
        addr_w = 9;
        #40;
        
        datain = 16'h4444;
        addr_w = 10;
        #40;
        
        datain = 16'h5555;
        addr_w = 11;
        #40;
        
        datain = 16'h6666;
        addr_w = 12;
        #40;
        
        datain = 16'h7777;
        addr_w = 13;
        #40;
        
        datain = 16'h8888;
        addr_w = 14;
        #40;
        datain = 0;
        addr_w = 0;
        #400;

        datain = 16'h1111;
        addr_w = 1;

        #40;

        datain = 16'h2222;
        addr_w = 2;

        #40;

        datain = 16'h3333;
        addr_w = 3;

        #40;

        datain = 16'h4444;
        addr_w = 4;
        #40;

        datain = 16'h5555;
        addr_w = 5;
        #40;

        datain = 16'h6666;
        addr_w = 6;
        #40;

        datain = 16'h7777;
        addr_w = 7;
        #40;

        datain = 16'h8888;
        addr_w = 8;
        #40;
        
        datain = 16'h9999;
        addr_w = 9;
        #40;
        
        datain = 16'haaaa;
        addr_w = 10;
        #40;
        
        datain = 16'hbbbb;
        addr_w = 11;
        #40;
        
        datain = 16'hcccc;
        addr_w = 12;
        #40;
        
        datain = 16'hdddd;
        addr_w = 13;
        #40;
        
        datain = 16'heeee;
        addr_w = 14;
        #40;

                addr_w = 0;
        #80;

        datain = 16'hAAAA;
        addr_w = 1;

        #40;

        datain = 16'hBBBB;
        addr_w = 2;

        #40;

        datain = 16'hCCCC;
        addr_w = 3;

        #40;

        datain = 16'hDDDD;
        addr_w = 4;
        #40;

        datain = 16'hEEEE;
        addr_w = 5;
        #40;

        datain = 16'hFFFF;
        addr_w = 6;
        #40;

        datain = 16'h1111;
        addr_w = 7;
        #40;

        datain = 16'h2222;
        addr_w = 8;
        #40;
        
        datain = 16'h3333;
        addr_w = 9;
        #40;
        
        datain = 16'h4444;
        addr_w = 10;
        #40;
        
        datain = 16'h5555;
        addr_w = 11;
        #40;
        
        datain = 16'h6666;
        addr_w = 12;
        #40;
        
        datain = 16'h7777;
        addr_w = 13;
        #40;
        
        datain = 16'h8888;
        addr_w = 14;
        #40;
        
        addr_w = 0;
        #80;

        datain = 16'h1111;
        addr_w = 1;

        #40;

        datain = 16'h2222;
        addr_w = 2;

        #40;

        datain = 16'h3333;
        addr_w = 3;

        #40;

        datain = 16'h4444;
        addr_w = 4;
        #40;

        datain = 16'h5555;
        addr_w = 5;
        #40;

        datain = 16'h6666;
        addr_w = 6;
        #40;

        datain = 16'h7777;
        addr_w = 7;
        #40;

        datain = 16'h8888;
        addr_w = 8;
        #40;
        
        datain = 16'h9999;
        addr_w = 9;
        #40;
        
        datain = 16'haaaa;
        addr_w = 10;
        #40;
        
        datain = 16'hbbbb;
        addr_w = 11;
        #40;
        
        datain = 16'hcccc;
        addr_w = 12;
        #40;
        
        datain = 16'hdddd;
        addr_w = 13;
        #40;
        
        datain = 16'heeee;
        addr_w = 14;
        #40;
    end

endmodule
