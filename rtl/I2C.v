
// 합성할 때, I2C.ngc 파일을 불러오는 코드

// I2C 모듈 선언
module I2C (CLK, RESETn, WRITE, SLV_ADDR, REG_ADDR, WDATA, READY, SCL, SDA);

// 입력, 출력 포트 선언
input CLK;
input RESETn;
input WRITE;
input [6:0] SLV_ADDR;
input [7:0] REG_ADDR;
input [7:0] WDATA;
output READY;
inout SCL;
inout SDA;

endmodule
