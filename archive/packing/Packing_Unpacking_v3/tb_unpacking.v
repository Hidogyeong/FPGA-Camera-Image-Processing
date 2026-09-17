`timescale 1ns/10ps
`define   CC  5


module tb_unpacking();

    reg clk;
    reg nRST;
    reg wea;
    reg [3:0] addri;
    reg [31:0] rdata;
    wire [2:0] addro;
    wire [15:0] Unpacked_data;

    Unpacking dut (
        .clk(clk),
        .nRST(nRST),
        .wea(wea),
        .addri(addri),
        .rdata(rdata),
        .addro(addro),
        .Unpacked_data(Unpacked_data)
    );

   always begin
        #5 clk = ~clk;
    end

     initial begin
        // Initialize signals
        clk = 0;
        nRST = 0;
        wea = 0;
        addri = 0;
        rdata = 0;

        // Reset
        #10 nRST = 1;
        #5

        // Test data
        addri = 4'b0001;
        wea = 1'b0;
        rdata = 32'hAAAA_BBBB;
        #20;

        addri = 4'b0010;
        wea = 1'b1;
        rdata = 32'hCCCC_DDDD;
        #20;

        addri = 4'b0011;
        wea = 1'b0;
        rdata = 32'hEEEE_FFFF;
        #20;

        // Done
    end

endmodule
