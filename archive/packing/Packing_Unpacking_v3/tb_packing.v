`timescale 1ns/10ps
`define   CC  5

module tb_packing();

    reg clk;
    reg nRST;
    reg [3:0] addri;
    reg [15:0] datain;
    wire wea;
    wire [2:0] addro;
    wire [31:0] packed_data;


    packing dut (
        .clk(clk),
        .nRST(nRST),
        .addri(addri),
        .datain(datain),
        .wea(wea),
        .addro(addro),
        .packed_data(packed_data)
    );

 always begin
        #5 clk = ~clk;
    end

 initial begin
        // Initialize signals
        clk = 0;
        nRST = 0;
        addri = 0;
        datain = 0;

        // Reset
        #5 nRST = 1;
        #10

        // Test data
        addri = 16'h0001;
        datain = 16'hAAAA;
        #20;

        addri = 16'h0002;
        datain = 16'hBBBB;
        #20;

        addri = 16'h0003;
        datain = 16'hCCCC;
        #20;

        addri = 16'h0004;
        datain = 16'hDDDD;
        #20;


    end




endmodule
