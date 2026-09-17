module Unpacking(
    input              clk,
    input              nRST,
    input              wea,
    input       [17:0]  addri,
    input       [31:0] rdata,
    output reg  [16:0]  addro,
    output      [15:0] Unpacked_data
);

reg [31:0] temp;
reg cnt;

//addro
always @(posedge(clk) or negedge(nRST)) begin

    if(!nRST) begin
        addro <= 0;
    end
    else begin

        if(addri[0]) begin
            addro <= addro + 1;
        end
        else begin
            addro <= addro;
        end

    end


end

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


//temp
always @(posedge(clk) or negedge(nRST)) begin

    if(!nRST) begin
        temp <= 0;
    end
    else begin

        if(!addri) begin
            temp <= 0;
        end
        else begin
            if(cnt==1) begin
                temp <= rdata;
            end
            else begin
                temp <= temp << 16;
            end            
        end

    end

end


assign Unpacked_data = temp[31:16];

endmodule