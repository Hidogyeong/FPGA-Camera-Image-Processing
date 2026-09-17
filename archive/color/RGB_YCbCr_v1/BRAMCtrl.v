`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2013/02/19 14:59:36
// Design Name: 
// Module Name: BRAMCtrl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module BRAMCtrl(
  input CLK,
  input down_clk,
  input RESET,
  input nRST,
  input Vsync,
  input Hsync,
  input DE,
  output BRAMCLK,
  output [16:0] BRAMADDR,
  input [23:0] BRAMDATA,
  output [7:3] R,
  output [7:2] G,
  output [7:3] B
  );

  parameter HSIZE = 480;
  parameter VSIZE = 272;

  reg [13:0] hcnt;
  reg [23:0] vcnt;
  reg DE1d;

  wire [15:0] RGB_data;

  YCbCr_to_RGB
    YCbCr_to_RGB_i(
      .clk(down_clk),
      .nRST(nRST),
      .YCbCr_data(BRAMDATA),
      .RGB_data(RGB_data)
    );



always @ (posedge CLK or posedge RESET)
begin
  if (RESET)
  begin
    hcnt <= 14'd0;
    vcnt <= 24'd0;
    DE1d <= 1'b0;
  end
  else
  begin
    DE1d <= DE;

    if (!Vsync)
      vcnt <= 18'd0;
    else if ((!DE) && (DE1d))
       vcnt <= vcnt + HSIZE;

    if (!DE)
      hcnt <= HSIZE-1;
    else if (hcnt > 14'd0)
      hcnt <= hcnt - 14'd1;

  end
end

  assign BRAMCLK = CLK;
  assign BRAMADDR = vcnt + hcnt;
  assign R[7:3] = RGB_data[15:11];
  assign G[7:2] = RGB_data[10:5];
  assign B[7:3] = RGB_data[4:0];

endmodule
