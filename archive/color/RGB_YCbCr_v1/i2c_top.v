
// 모듈 선언
module i2c_top (MCLK, MRESETn, CSCL, CSDA);

// 입력 출력 포트 선언
input MCLK;
input MRESETn;
inout CSCL;
inout CSDA;

// wire 선언
wire CSCL;
wire CSDA;

wire i_write;
wire [6:0] i_slv_addr;
wire [7:0] i_reg_addr;
wire [7:0] i_wdata;
wire i_ready;
wire de_a;
wire VFLAG;

// i2cset를 입력/출력 포트, I2C 모듈에 연결
i2cset ui2cset (.MCLK(MCLK), .MRESETn(MRESETn),
                .I_WRITE(i_write), .I_SLV_ADDR(i_slv_addr),
                .I_REG_ADDR(i_reg_addr), .I_WDATA(i_wdata),
                .I_READY(i_ready));

// I2C 입력/출력 포트, i2cset 모듈에 연결
I2C i2c_logic (.CLK(MCLK), .RESETn(MRESETn),
               .WRITE(i_write), .SLV_ADDR(i_slv_addr),
               .REG_ADDR(i_reg_addr), .WDATA(i_wdata),
               .READY(i_ready), .SCL(CSCL),
               .SDA(CSDA));
endmodule
