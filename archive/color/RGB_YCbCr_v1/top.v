
module top (
  // Processor System ����� ��Ʈ

  // TFTLCD I/O
  input TFTLCD_CLK,
  input TFTLCD_nRESET,
  output TFTLCD_TCLK,	// TFT-LCD Clock
  output wire TFTLCD_Hsync,	// TFT-LCD HSYNC
  output wire TFTLCD_Vsync,	// TFT-LCD VSYNC
  output wire TFTLCD_DE_out,	// TFT-LCD Data enable
  output [7:3] TFTLCD_R, // TFT-LCD Red signal 
  output [7:2] TFTLCD_G, // TFT-LCD Green signal
  output [7:3] TFTLCD_B, // TFT-LCD Blue signal
  output TFTLCD_Tpower,  // TFT-LCD Backlight On signal

  // CIS = Contact Image Sensor I/O
  output CMCLK,
  output CRESETB,
  output CENB,
  inout CSCL,
  inout CSDA,
  input CVCLK,
  input CVSYNC,
  input CHSYNC,
  input [7:0] CY);

  wire [16:0] tft_addr;
  wire [23:0] tft_data;

  wire [15:0] camera_data;

  wire [16:0] cis_addr;
  wire [15:0] cis_data;

  wire [15:0] bram_addr1;
  wire bram_we1;
  wire [31:0] bram_data1;


  wire TFTLCD_nCLK;
  wire [31:0] data_w;
  wire TFTLCD_TCL;
  assign TFTLCD_nCLK = ~TFTLCD_CLK;

  packing_unpacking
    packing_unpacking_i(
      .clk(TFTLCD_nCLK),
      .UP_CLK(TFTLCD_TCLK),
      .nRST(TFTLCD_nRESET),
      .datain(cis_data),
      .addr_w(cis_addr),
      .addr_r(tft_addr),
      .data_r(bram_data1),
      .addr(bram_addr1),
      .data_w(data_w), 
      .dataout(camera_data)
);

  bufferram
    bufferram_i1 (
      .clka( TFTLCD_nCLK ),
      .wea( TFTLCD_TCLK ),
      .addra( bram_addr1 ),
      .dina( data_w ),
      .douta( bram_data1 )
    );  
  
  RGB_to_YCbCr
    RGB_to_YCbCr_i (
      .clk(TFTLCD_CLK),
      .nRST(TFTLCD_nRESET),
      .RGB_data(camera_data),
      .YCbCr_data(tft_data)
    );

  TFTLCDCtrl
    TFTLCDCtrl_i (
      .CLK(TFTLCD_CLK),
      .nRESET(TFTLCD_nRESET),
      .TCLK(TFTLCD_TCLK),
      .Hsync(TFTLCD_Hsync),
      .Vsync(TFTLCD_Vsync),
      .DE_out(TFTLCD_DE_out),
      .R(TFTLCD_R),
      .G(TFTLCD_G),
      .B(TFTLCD_B),
      .Tpower(TFTLCD_Tpower),
      .BRAMADDR(tft_addr),
      .BRAMDATA(tft_data));
      

  CIS_IF
    CIS_IF_i (
      .HCLK(TFTLCD_CLK),
      .HRESETn(TFTLCD_nRESET),
      .CLKA(),
      .DINA(cis_data),
      .ADDRA(cis_addr),
      .ENA(),
      .WEA(),
      .TEST_LED(),
      .CSCL(CSCL),
      .CSDA(CSDA),
      .CMCLK(CVCLK),
      .CVsync(CVSYNC),
      .CHsync(CHSYNC),
      .CDATA(CY),
      .CPCLK(CMCLK),
      .CRESET(CRESETB),
      .CPWEN(CENB));

endmodule
