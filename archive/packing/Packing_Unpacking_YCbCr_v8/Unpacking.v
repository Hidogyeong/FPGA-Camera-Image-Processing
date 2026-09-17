module Unpacking(
    input              clk,
    input              UP_CLK,
    input              nRST,
    input       [3:0]  addri,
    input       [47:0] rdata,
    output reg  [3:0]  addro_f,
    output reg  [2:0]  addro,
    output reg  [23:0] Unpacked_data
);


reg [47:0]  temp; 
reg [3:0] addri_t;
reg [3:0] addrt;
reg [3:0] addrt_2;

always @(posedge(UP_CLK) or negedge(nRST)) begin

    if(!nRST) begin
        addri_t <= 0;
        addrt <= 0;
        addrt_2 <= 0;
    end
    else begin
        addri_t <= addri;
        addrt <= addri_t;
        addrt_2 <= addrt;
    end

end

always @(posedge(clk) or negedge(nRST)) begin

    addro_f <= addrt_2;

end

reg [2:0] cnt;

//cnt
always @(posedge UP_CLK or negedge nRST) begin

    if(!nRST) begin
        cnt <= 0;
    end
    else begin
        if(!addri) begin
            cnt <= 0;
        end
        else begin
            if(addri == addrt) begin
                if(cnt == 3'b100) begin
                    cnt <= 3'b100;
                end
                else begin
                    cnt <= cnt + 1;
                end
            end
            else begin
                cnt <= 1;
            end
        end
    end

end

reg [2:0] cnt_t;

always @(posedge UP_CLK or negedge nRST) begin
    cnt_t <= cnt;
end

//addro
always @(posedge(UP_CLK) or negedge(nRST)) begin

    if(!nRST) begin
        addro <= 0;
    end
    else begin

        if(!addri) begin
            addro <= 0;
        end
        else begin
            if(!addri[0]) begin
                addro <= addri >> 1;
            end
            else begin
                addro <= addro;
            end
        end

    end

end


//temp
always @(posedge(UP_CLK) or negedge(nRST)) begin

    if(!nRST) begin
        temp <= 0;
    end
    else begin
        if(addri) begin
            if(addri != addrt) begin
                if(addrt[0]) begin
                    temp <= rdata;
                end
                else begin
                    temp <= temp;
                end
            end
            else begin
                if(cnt == 3'b100) begin
                    temp <= temp;
                end
                else begin
                    temp <= rdata;
                end
            end
        end
        else begin
            temp <= 0;
        end
    end

end



//Unpacked_data
always @(posedge (clk) or negedge (nRST)) begin

    if(!nRST) begin
        Unpacked_data <= 0;
    end
    else begin
        if(!addri) begin
            Unpacked_data <= 0;
        end
        else begin
            if(addrt != addri) begin
                if(cnt_t == 3'b001) begin
                    if(!addrt[0]) begin
                        Unpacked_data <= temp[23:0];
                    end
                    else begin
                        Unpacked_data <= temp[47:24];
                    end
                end
                else begin
                    Unpacked_data <= Unpacked_data;
                end
            end
            else begin
                if(cnt == 3'b010)begin
                    Unpacked_data <= temp[47:24];
                end
                else if(cnt == 3'b001) begin
                    Unpacked_data <= temp[23:0];
                end
                else begin
                    Unpacked_data <= Unpacked_data;
                end
            end
        end
    end

end


endmodule