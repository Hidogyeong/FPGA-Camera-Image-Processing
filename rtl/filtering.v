module process(
    input           clk,
    input           UP_CLK,
    input           nRST,
    input           data_EN,
    input   [23:0]  vcnt,
    input   [23:0]  YCbCr_data,
    output  [23:0]  filtered_data
);

wire nUP_CLK;

assign nUP_CLK = ~UP_CLK;


wire [47:0] Ram_data;

// conv_data_en
reg conv_data_en;

always @(posedge nUP_CLK or negedge nRST) begin

    if(!nRST) begin
        conv_data_en <= 0;
    end
    else begin
        conv_data_en <= data_EN;
    end

end

// line_num;
wire [8:0] line_num;
reg [23:0] vcnt_d;
reg [23:0] vcnt_d2;
 
always @(posedge UP_CLK or negedge nRST) begin

    if(!nRST) begin
        vcnt_d <= 0;
        vcnt_d2 <= 0;
    end
    else begin
        vcnt_d <= vcnt;
        vcnt_d2 <= vcnt_d;
    end

end

assign line_num = vcnt_d2/(23'd480);

//make_addr
reg [8:0] addr;

always @(posedge UP_CLK or negedge nRST) begin

    if(!nRST) begin
        addr <= 0;
    end
    else begin
        if(data_EN) begin
            addr <= addr + 1'b1;
        end
        else begin
            addr <= 1'b0;
        end
    end

end

//package_data
reg [47:0] packed_data;

always @(posedge nUP_CLK or negedge nRST) begin

    if(!nRST) begin
        packed_data <= 0;
    end
    else begin
        if(data_EN) begin
            if(!line_num) begin // 1_Line
                packed_data <= {YCbCr_data, YCbCr_data};
            end
            else begin
                packed_data <= {Ram_data[23:0], YCbCr_data};
            end
        end
        else begin

        end
    end

end

//filter_data_en
reg filter_data_en;

always @(posedge nUP_CLK or negedge nRST) begin

    if(!nRST) begin
        filter_data_en <= 0;
    end
    else begin
        filter_data_en <= data_EN;
    end

end

//filter_data
reg [71:0] filter_data;

always @(posedge nUP_CLK or negedge nRST) begin

    if(!nRST) begin
        filter_data <= 0;
    end
    else begin
        if(data_EN) begin
            filter_data <= {Ram_data,YCbCr_data};
        end
        else begin
            filter_data <= filter_data;
        end
    end

end

conv
    conv_i(
        .nUP_CLK        (nUP_CLK),
        .nRST           (nRST),
        .line_num       (line_num),
        .filter_data_en (filter_data_en),
        .filter_data    (filter_data),
        .filtered_data  (filtered_data)
);


line_ram
    line_ram(
        .clka       (clk),
        .wea        (nUP_CLK),
        .addra      (addr), //240addr
        .dina       (packed_data),
        .douta      (Ram_data)
    );

endmodule
