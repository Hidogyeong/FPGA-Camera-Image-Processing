module packing_unpacking(
    input         clk,
    input         nRST,
    input  [15:0] datain,
    input  [3:0]  addr_w,
    input  [3:0]  addr_r,
    input  [47:0] data_r,
    output        UP_CLK,
    output [2:0]  addr,
    output [3:0]  addro_f,
    output [47:0] data_w, 
    output [23:0] dataout
);

wire [2:0] p_addr;
wire [2:0] u_addr;
assign addr = (UP_CLK == 0) ? u_addr : p_addr; 
reg UP_CLK_r;
assign UP_CLK = UP_CLK_r;

wire [23:0] Y_datain;

reg g2m_cnt;
wire RST = ~nRST;
  always@(posedge RST or posedge clk)
  begin
    if(RST)
    begin
        UP_CLK_r <= 1'b0;
        g2m_cnt <= 1'b0;
    end
    else
    begin
      g2m_cnt <= ~g2m_cnt;
      if (!g2m_cnt)
        UP_CLK_r <= ~UP_CLK_r;
    end
  end

RGB_to_YCbCr
        R_to_Y(
    .clk        (clk),
    .nRST       (nRST),
    .RGB_data   (datain),
    .YCbCr_data (Y_datain)
);




packing
        package(
    .clk        (UP_CLK),
    .nRST       (nRST),
    .addri      (addr_w),
    .datain     (Y_datain),
    .addro      (p_addr),
    .packed_data(data_w)
);



Unpacking
        unpackage(
    .clk(clk),
    .UP_CLK(UP_CLK),
    .nRST(nRST),
    .addri(addr_r),
    .rdata(data_r),
    .addro_f(addro_f),
    .addro(u_addr),
    .Unpacked_data(dataout)
);




endmodule
