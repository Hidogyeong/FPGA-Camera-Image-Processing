module packing(
    input clk,
    input nRST,
    input [17:0]addri,
    input [15:0] datain,
    output reg wea,
    output reg [16:0]addro,
    output [31:0] packed_data
);


reg [31:0] temp;
reg cnt;

//cnt
always @(posedge(clk) or negedge(nRST)) begin

    if(!nRST) begin
        cnt <= 0;
    end
    else begin

        if(!addri) begin
            cnt <= 0;
        end
        else begin
            cnt <= cnt + 1;
        end

    end

end

//wea
always @(posedge(clk) or negedge(nRST)) begin

    if(!nRST) begin
        wea <= 0;
    end
    else begin

        if(!addri) begin
            wea <= 0;
        end
        else begin
            wea <= cnt;
        end

    end

end

//addro
always @(posedge(clk) or negedge(nRST)) begin

    if(!nRST) begin
        addro <= 0;
    end
    else begin

        if(cnt == 1) begin
            addro <= addro + 1;
        end
        else begin
            addro <= addro;
        end

    end

end

//packed_data
always @(posedge(clk) or negedge(nRST)) begin

    if(!nRST) begin
        temp <= 0;
    end
    else begin
        if(cnt == 0) begin
            temp[31:16] <= datain;
        end
        else begin
            temp[15:0] <= datain;
        end            
    end

end

assign packed_data = temp;

endmodule
