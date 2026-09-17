module packing_unpacking(
    input         clk,
    input         nRST,
    input  [15:0] datain,
    input  [17:0]  addr_w,
    input  [17:0]  addr_r,
    input  [31:0] data_r,
    wire        UP_CLK,
    output [15:0]  addr,
    output [31:0] data_w, 
    output [15:0] dataout
);

wire [15:0] p_addr;
wire [15:0] u_addr;
assign addr = (UP_CLK == 0) ? u_addr : p_addr; 


packing
        package(
    .clk(clk),
    .nRST(nRST),
    .addri(addr_w),
    .datain(datain),
    .wea(UP_CLK),
    .addro(p_addr),
    .packed_data(data_w)
);



Unpacking
        unpackage(
    .clk(clk),
    .nRST(nRST),
    .wea(UP_CLK),
    .addri(addr_r),
    .rdata(data_r),
    .addro(u_addr),
    .Unpacked_data(dataout)
);




endmodule
