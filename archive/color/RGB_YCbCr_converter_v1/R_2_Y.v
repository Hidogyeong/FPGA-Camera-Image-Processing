module RGB_to_YCbCr(
    input clk,
    input nRST,
    input [15:0] RGB_data,
    output [23:0] YCbCr_data
);
    wire [7:0] R8;
    wire [7:0] G8;
    wire [7:0] B8;

    assign R8 = RGB_data[15:11] << 3;
    assign G8 = RGB_data[10:5] << 2;
    assign B8 = RGB_data[4:0] << 3;


//Y
    reg [15:0] Y_t;
    reg [5:0] Y_1;
    reg [5:0] Y_2;
    reg [5:0] Y_3;
    wire [13:0] Y2_1, Y2_2, Y2_3;
    wire [7:0] Y8;

    assign Y2_1 = Y_1*R8;
    assign Y2_2 = Y_2*G8;
    assign Y2_3 = Y_3*B8;
    assign Y8 = Y_t[15] ? 0 : Y_t[14] ? 7'd255 : Y_t[13:6];
    always @(posedge clk or negedge nRST) begin
        
        if(!nRST) begin
            Y_t <= 0;
            Y_1 <= 6'd19;
            Y_2 <= 6'd37;
            Y_3 <= 6'd7;
        end
        else begin
            Y_t <= Y2_1 + Y2_2 + Y2_3;
        end

    end
//Cb
    reg signed [16:0] Cb_t;
    reg signed [5:0] Cb_1;
    reg signed [5:0] Cb_2;
    reg signed [5:0] Cb_3;

    wire signed [13:0] Cb2_1, Cb2_2, Cb2_3;
    wire signed [14:0] Cb3_1, Cb3_2;
    wire [7:0] Cb8;

    assign Cb2_1 = Cb_1*R8;
    assign Cb2_2 = Cb_2*G8;
    assign Cb2_3 = Cb_3*B8;

    assign Cb3_1 = 17'd8192 + Cb2_3;
    assign Cb3_2 = Cb2_1 + Cb2_2;

    assign Cb8 = Cb_t[16] ? 0 : Cb_t[14] ? 7'd255 : Cb_t[13:6];

    always @(posedge clk or negedge nRST) begin
        
        if(!nRST) begin
            Cb_t <= 0;
            Cb_1 <= 6'd10;
            Cb_2 <= 6'd21;
            Cb_3 <= 6'd32;
        end
        else begin
            Cb_t <= Cb3_1 - Cb3_2;
        end

    end
//Cr
    reg signed [16:0] Cr_t;
    reg signed [16:0] Cr_1;
    reg signed [16:0] Cr_2;
    reg signed [16:0] Cr_3;

    wire signed [13:0] Cr2_1, Cr2_2, Cr2_3;
    wire signed [14:0] Cr3_1, Cr3_2;
    wire [7:0] Cr8;

    assign Cr2_1 = Cr_1*R8;
    assign Cr2_2 = Cr_2*G8;
    assign Cr2_3 = Cr_3*B8;

    assign Cr3_1 = 17'd8192 + Cr2_1;
    assign Cr3_2 = Cr2_2 + Cr2_3;

    assign Cr8 = Cr_t[16] ? 0 : Cr_t[14] ? 7'd255 : Cr_t[13:6];
    always @(posedge clk or negedge nRST) begin
        
        if(!nRST) begin
            Cr_t <= 0;
            Cr_1 <= 6'd32;
            Cr_2 <= 6'd26;
            Cr_3 <= 6'd5;
        end
        else begin
            Cr_t <= Cr3_1 - Cr3_2;
        end

    end

    assign YCbCr_data = {Y8, Cb8, Cr8};


endmodule
