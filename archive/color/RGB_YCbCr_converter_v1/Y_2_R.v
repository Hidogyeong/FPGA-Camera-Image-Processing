module YCbCr_to_RGB(
    input clk,
    input nRST,
    input [23:0] YCbCr_data,
    output [15:0] RGB_data
);
    wire [7:0] Y8;
    wire [7:0] Cb8;
    wire [7:0] Cr8;

    assign Y8 = YCbCr_data[23:16];
    assign Cb8 = YCbCr_data[15:8];
    assign Cr8 = YCbCr_data[7:0];


    wire signed [14:0] Y_t;
    wire signed [8:0] Cb_t, Cr_t;

    assign Y_t = Y8 << 6;    
    assign Cb_t = Cb8 - 8'd128;
    assign Cr_t = Cr8 - 8'd128;

    wire [4:0] R5;
    wire [5:0] G6;
    wire [4:0] B5;

    wire [7:0] R8;
    wire [7:0] G8;
    wire [7:0] B8;


//R
    reg [17:0] R_t;
    reg signed [7:0] R_3;

    wire signed [15:0] Cr_r;

    assign Cr_r = R_3*Cr_t;
    always @(posedge clk or negedge nRST) begin
        
        if(!nRST) begin
            R_t <= 0;
            R_3 <= 8'd89;
        end
        else begin
            R_t <= Y_t + Cr_r;
        end

    end
//G
    reg [17:0] G_t;
    reg signed [6:0] G_2;
    reg signed [6:0] G_3;

    wire signed [13:0] Cb_g, Cr_g;

    assign Cb_g = G_2*Cb_t;
    assign Cr_g = G_3*Cr_t;

    always @(posedge clk or negedge nRST) begin
        
        if(!nRST) begin
            G_t <= 0;
            G_2 <= 7'd22;
            G_3 <= 7'd45;
        end
        else begin
            G_t <= Y_t - Cb_g - Cr_g;
        end

    end
//B
    reg [17:0] B_t;
    reg signed [7:0] B_2;

    wire signed [15:0] Cb_b;

    assign Cb_b = B_2*Cb_t;

    always @(posedge clk or negedge nRST) begin
        
        if(!nRST) begin
            B_t <= 0;
            B_2 <= 8'd113;

        end
        else begin
            B_t <= Y_t + Cb_b;
        end

    end

    //Cliping
    
    assign R8 = R_t[15] ? 0 : R_t[14] ? 8'd255 : R_t >> 6;
    assign G8 = G_t[15] ? 0 : G_t[14] ? 8'd255 : G_t >> 6;
    assign B8 = B_t[15] ? 0 : B_t[14] ? 8'd255 : B_t >> 6;

    assign RGB_data = {R8[7:3], G8[7:2], B8[7:3]};


endmodule

