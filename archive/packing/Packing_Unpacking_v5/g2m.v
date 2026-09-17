//
// TFT-LCD Clock 생성
// 입력 Clock을 2분주 시킴
//

module g2m(
  input CLK,
  input RESET,
  output reg UP_CLK);

  reg g2m_cnt;

  always@(posedge RESET or posedge CLK)
  begin
    if(RESET)
    begin
        UP_CLK <= 1'b0;
        g2m_cnt <= 1'b0;
    end
    else
    begin
      g2m_cnt <= ~g2m_cnt;
      if (!g2m_cnt)
        UP_CLK <= ~UP_CLK;
    end
  end
    
endmodule
