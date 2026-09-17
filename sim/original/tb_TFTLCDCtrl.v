`timescale 1ns/1ps

module TFTLCDCtrl_tb;

  // 모듈 인스턴스 생성
  reg CLK;
  reg nRESET;
  wire TCLK, Hsync, Vsync, DE_out, data_en;
  wire [7:3] R;
  wire [7:2] G;
  wire [7:3] B;
  wire Tpower;
  wire [16:0] BRAMADDR;
  wire [16:0] filter_addr;
  reg [15:0] BRAMDATA;

  TFTLCDCtrl uut (
    .CLK(CLK),
    .nRESET(nRESET),
    .TCLK(TCLK),
    .Hsync(Hsync),
    .Vsync(Vsync),
    .DE_out(DE_out),
    .data_en(data_en),
    .R(R),
    .G(G),
    .B(B),
    .Tpower(Tpower),
    .BRAMADDR(BRAMADDR),
    .BRAMDATA(BRAMDATA)
  );

  // 시간 스케일과 초기화
  initial begin

    // 테스트 입력값 초기화
    CLK = 0;
    nRESET = 1;
    BRAMDATA = 16'h0000;

    // 초기화 후 대기
    #10;

    // 테스트 케이스 1: 리셋 후 클럭 신호 생성 확인
    nRESET = 0;
    #10;
    nRESET = 1;

    // 테스트 케이스 2: BRAMDATA 값 변경 및 클럭 사이클 진행
    #100000;
    BRAMDATA = 16'h1234;
    #10;
  end

  // Clock 생성
  always #5 CLK = ~CLK;

endmodule


