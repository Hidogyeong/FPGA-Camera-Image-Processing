module packing_unpacking(
    input         clk,
    input         UP_CLK,
    input         nRST,
    input  [15:0] datain,
    input  [16:0] addr_w,
    input  [16:0] addr_r,
    input  [31:0] data_r,
    output [15:0] addr,
    output [31:0] data_w, 
    output [15:0] dataout
);

wire [15:0] p_addr;
wire [15:0] u_addr;
assign addr = (UP_CLK == 0) ? u_addr : p_addr; 


packing
        package(
    .clk(UP_CLK),
    .nRST(nRST),
    .addri(addr_w),
    .datain(datain),
    .addro(p_addr),
    .packed_data(data_w)
);



Unpacking
        unpackage(
    .clk(clk),
    .UP_CLK(UP_CLK),
    .nRST(nRST),
    .addri(addr_r),
    .rdata(data_r),
    .addro(u_addr),
    .Unpacked_data(dataout)
);



endmodule
