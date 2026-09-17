module top(
    input         clk,
    input         nRST,
    input  [15:0] datain,
    input  [3:0]  addr_w,
    input  [3:0]  addr_r,
    input  [31:0] data_r,
    output        wea,
    output [2:0]  addr,
    output [31:0] data_w, 
    output [15:0] dataout
);


wire [2:0] p_addr;
wire [2:0] u_addr;
assign addr = (wea == 0) ? u_addr : p_addr; 

packing
        package(
    .clk(clk),
    .nRST(nRST),
    .addri(addr_w),
    .datain(datain),
    .wea(wea),
    .addro(p_addr),
    .packed_data(data_w)
);



Unpacking
        unpackage(
    .clk(clk),
    .nRST(nRST),
    .wea(wea),
    .addri(addr_r),
    .rdata(data_r),
    .addro(u_addr),
    .Unpacked_data(dataout)
);




endmodule
