module packing(
    input               clk,
    input               nRST,
    input       [17:0]   addri,
    input       [15:0]  datain,
    input               wea,
    //output          wea,
    output reg  [15:0]   addro,
    output reg     [31:0]  packed_data
);
reg [2:0]   cnt;
reg [31:0]  temp;
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
            if(cnt < 4) begin
                cnt <= cnt + 1;
            end
            else begin
                cnt <= 1;
            end
        end

    end

end


//addro
always @(posedge(clk) or negedge(nRST)) begin

    if(!nRST) begin
        addro <= 0;
    end
    else begin
        if(addro == 65280) begin
            addro <= 0;
        end
        else begin
            if( cnt == 2'b10  ) begin
                addro <= addro + 1;
            end
            else begin
                addro <= addro;
            end
        end

    end

end



//packed_data
always @(posedge(clk) or negedge(nRST)) begin

    if(!nRST) begin
        temp <= 0;
    end
    else begin
        if(cnt[1] == 0) begin
            temp[31:16] <= datain;
        end
        else begin
            temp[15:0] <= datain;
        end            
    end

end

always @(posedge clk or negedge nRST) begin

    if(!nRST) begin
        packed_data <= 0;
    end
    else begin
        if(cnt == 3'b011) begin        
            packed_data <= temp;
        end
        else begin
            packed_data <= packed_data;
        end
    end

end

endmodule
