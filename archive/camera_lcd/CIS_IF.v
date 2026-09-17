
// 모듈 선언
module CIS_IF (HCLK, HRESETn,
               CLKA, DINA, ADDRA, ENA, WEA,
               TEST_LED, CSCL, CSDA, CMCLK, CVsync, CHsync, CDATA, CPCLK, CRESET, CPWEN);

// 입력, 출력 포트 선언
input HCLK;
input HRESETn;
output CLKA; 
output[15:0] DINA; 
output[17:0] ADDRA; 
output ENA; 
output WEA; 
output[3:0] TEST_LED;
inout CSCL;
inout CSDA;
input CMCLK;
input CVsync;
input CHsync;
input[7:0] CDATA;
output CPCLK;
output CRESET;
output CPWEN;

// wire, reg 선언

//clock reg and wire
reg m_clk;
wire MCLK;

//CIS reg and wire
wire CPCLK;
wire CPWEN;
wire CRESET;
wire CSCL;
wire SDA;
reg cis_resetn;

//memory
reg[17:0] dpram_addra;
reg[15:0] fdata;
wire[15:0] DINA;
wire[17:0] ADDRA;
wire WEA;
wire CLKA;
wire ENA;

// 출력 포트에 reg 연결
assign MCLK = m_clk;
assign CPCLK = HCLK;
assign CRESET = cis_resetn;

assign CPWEN = 1'b1;

// 카운터로 클럭 생성 (9 분주)
always@(negedge HRESETn or posedge HCLK)
  begin: m_clkgen
  reg[5:0] cnt; 
  if (HRESETn == 1'b0)
    begin
    cnt = 6'd0; 
    m_clk <= 1'b0 ; 
    cis_resetn <= 1'b0 ; 
    end
  else
    begin
    cis_resetn <= 1'b1 ; 
    if (cnt == 6'd8)
      begin
      m_clk <= ~m_clk ; 
      cnt = 6'd0; 
      end
    else
      begin
      cnt = cnt + 1; 
      m_clk <= m_clk ; 
      end 
    end 
  end

assign TEST_LED = 4'b0000;

// 카메라에서 데이터를 받아 메모리로 보냄
always@(negedge HRESETn or posedge HCLK)
  begin: p_buf
  reg[1:0] buf_status;
  reg[7:0] data;
  if (HRESETn == 1'b0)
    begin
    buf_status = 2'd0;
    dpram_addra <= 18'd0;
    data = 8'd0;
    fdata <= 16'd0;
    end
  else
    begin
    if ((CVsync == 1'b0) && (CHsync == 1'b1))
      begin
      if (buf_status == 2'd0)
        data = CDATA;
      else if (buf_status == 2'd2)
        begin
        fdata <= {data, CDATA};
        dpram_addra <= dpram_addra + 1;
        end
      buf_status = buf_status + 1;
      end
    else if (CVsync == 1'b1)
      begin
      buf_status = 2'd0;
      dpram_addra <= 18'd0;
      data = 8'd0;
      fdata <= 16'd0;
		end
    else
      begin
      buf_status = 2'd0;
      data = 8'd0;
      fdata <= 16'd0;
      end
    end
  end

// 출력 포트와 reg 연결
assign DINA = fdata;
assign ADDRA = dpram_addra;
assign WEA = 1'b1;
assign CLKA = MCLK;
assign ENA = 1'b1;

// 카메라에 있는 I2C Device 셋팅
i2c_top ui2c_top (.MCLK(MCLK), .MRESETn(HRESETn),
                  .CSCL(CSCL), .CSDA(CSDA));

endmodule 
