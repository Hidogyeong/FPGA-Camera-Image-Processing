module conv(
    input nUP_CLK,
    input nRST,
    input [8:0] line_num,
    input filter_data_en,
    input  [71:0] filter_data,
    output [23:0] filtered_data
);


//filter_data_en_delay
reg filter_data_en_delay;

always @(posedge nUP_CLK or negedge nRST) begin

    if(!nRST) begin
        filter_data_en_delay <= 0;
    end
    else begin
        filter_data_en_delay <= filter_data_en;
    end

end

//line_num_delay;
reg [8:0] line_num_data_delay;

always @(posedge filter_data_en or negedge nRST) begin

    if(!nRST) begin
        line_num_data_delay <= 0;
    end
    else begin
        line_num_data_delay <= line_num;
    end

end


//block_data;
// block_data[0] = left, block_data[1] = mid, block_data[2] = right
reg [71:0] block_data [2:0];

always @(posedge nUP_CLK or negedge nRST) begin

    if(!nRST) begin
        block_data[0] <= 0;
        block_data[1] <= 0;
        block_data[2] <= 0;
    end
    else begin
        if(!(filter_data_en||filter_data_en_delay)) begin
            block_data[0] <= block_data[0];
            block_data[1] <= block_data[1];
            block_data[2] <= block_data[2];
        end
        else begin
            if(filter_data_en) begin
                if(line_num_data_delay == 9'd272) begin
                    if(!filter_data_en_delay) begin
                        block_data[2] <= {filter_data[71:24], filter_data[47:24]};
                        block_data[1] <= {filter_data[71:24], filter_data[47:24]};
                        block_data[0] <= {filter_data[71:24], filter_data[47:24]};
                    end
                    else begin
                        block_data[0] <= block_data[1];
                        block_data[1] <= block_data[2];
                        block_data[2] <= {filter_data[71:24], filter_data[47:24]};
                    end
                end
                else begin
                    if(!filter_data_en_delay) begin
                        block_data[2] <= filter_data;
                        block_data[1] <= filter_data;
                        block_data[0] <= filter_data;
                    end
                    else begin
                        block_data[0] <= block_data[1];
                        block_data[1] <= block_data[2];
                        block_data[2] <= filter_data;
                    end
                end
            end
            else begin
                block_data[0] <= block_data[1];
                block_data[1] <= block_data[2];
                block_data[2] <= block_data[2];
            end
        end
    end

end

//convolution_filtered_data
wire signed [15:0] conv_data;
wire [15:0] temp;
wire [15:0] temp2;
assign conv_data =  (block_data[1][47:40]<<2) - (block_data[1][71:64] + block_data[0][47:40] + block_data[1][23:16] + block_data[2][47:40]);
assign temp = conv_data[15] ? 0 : conv_data[8] ? 8'b1111_1111 : conv_data[7:0];
assign temp2 = block_data[1][47:40] + (temp >> 1);

assign filtered_data[23:16] = temp2[15] ? 0 : temp2[8] ? 8'b1111_1111 : temp2[7:0];
assign filtered_data[15:0] = block_data[1][39:24];

endmodule