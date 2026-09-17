//
// TFT-LCD�� Color Test Pattern�� display�ϱ� ���� coding
//

module TFTLCDCtrl (
    input CLK,
    input nRESET,
    output TCLK,
    output reg Hsync,	// TFT-LCD HSYNC
    output reg Vsync,	// TFT-LCD VSYNC
    output DE_out,	// TFT-LCD Data enable
    output [7:3] R, // TFT-LCD Red signal 
    output [7:2] G, // TFT-LCD Green signal
    output [7:3] B, // TFT-LCD Blue signal
    output Tpower,  // TFT-LCD Backlight On signal
    output [16:0] BRAMADDR, //BRAM Address
    input [23:0] BRAMDATA); //BRAM Data 16bits
    
    wire RESET;
    wire g2mclk;
    wire hclk;

    wire hDE;
    wire vDE;
    wire [23:0] V_COUNT;
    wire data_en;
    wire DEimage;	 
	  wire Cam_image;
    wire Hsyncimage;	// TFT-LCD HSYNC
	  wire Vsyncimage;	// TFT-LCD VSYNC

    wire [7:3] BRAM_R;
    wire [7:2] BRAM_G;
    wire [7:3] BRAM_B;
    wire [23:0] filtered_data;

    assign TCLK = g2mclk;
	  assign RESET = ~nRESET;
    assign Tpower = 1;
  	assign DE_out = 1'b1;
    assign DEimage = hDE & vDE;



    always @ (posedge g2mclk or posedge RESET)
    begin
      if (RESET)
      begin
        Vsync <= 1'b0;
        Hsync <= 1'b0;
      end
      else
      begin
        Vsync <= Vsyncimage;
        Hsync <= Hsyncimage;
      end
    end 
	
  g2m a_g2m
	(
		.CLK		(CLK),
		.UP_CLK		(g2mclk),
		.RESET		(RESET)
		);
	// HSYNC ����
	horizontal b_horizontal
	(
		.CLK		  (g2mclk),
		.UP_CLKa	(hclk),
		.Hsync		(Hsyncimage),
		.hDE		  (hDE),
    .data_EN  (data_en),
		.RESET		(RESET)
		);


	// VSYNC ����
    vertical c_vertical
	(
		.CLK		(hclk),
		.Vsync  (Vsyncimage),
		.vDE		(vDE),
		.RESET	(RESET)
		);


    // BRAM Controller
    BRAMCtrl f_BRAMCtrl
    (
        .CLK(g2mclk),
        .down_clk(CLK),
        .RESET(RESET),
        .nRST(nRESET),
        .Vsync(Vsyncimage),
        .Hsync(Hsyncimage),
        .DE(DEimage),
        .BRAMCLK(BRAMCLK),
        .BRAMADDR(BRAMADDR),
        .BRAMDATA(filtered_data),
        .R(BRAM_R),
        .G(BRAM_G),
        .B(BRAM_B),
        .vcnt(V_COUNT)
    );


  process process_i
  (
    .clk            (CLK),
    .UP_CLK         (g2mclk),
    .nRST           (nRESET),
    .data_EN        (data_en),
    .vcnt           (V_COUNT),
    .YCbCr_data     (BRAMDATA),
    .filtered_data  (filtered_data)
);



assign R = BRAM_R;
assign G = BRAM_G;
assign B = BRAM_B;

endmodule











