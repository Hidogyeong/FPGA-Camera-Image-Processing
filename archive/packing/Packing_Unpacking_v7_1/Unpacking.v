module Unpacking(
    input              clk,
    input              UP_CLK,
    input              nRST,
    input       [3:0]  addri,
    input       [31:0] rdata,
    output reg  [2:0]  addro,
    output reg  [15:0] Unpacked_data
);


reg [31:0]  temp; 
reg [3:0] addri_t;
reg [3:0] addrt;



always @(posedge(UP_CLK) or negedge(nRST)) begin

    if(!nRST) begin
        addri_t <= 0;
        addrt <= 0;
    end
    else begin
        addri_t <= addri;
        addrt <= addri_t;
    end

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
            addro <= addri >> 1;
        end

    end

end


//temp
always @(posedge(clk) or negedge(nRST)) begin

    if(!nRST) begin
        temp <= 0;
    end
    else begin
        if(addri) begin
            if(addri == addrt) begin
                 if(addri[0]) begin
                    temp <= rdata;
                end
                else begin
                    temp <= temp;
                end               
            end
            else begin
                if(!addri[0]) begin
                    temp <= rdata;
                end
                else begin
                    temp <= temp;
                end
            end
        end
        else begin
                temp <= rdata;
        end
    end

end

//Unpacked_data
always @(posedge (UP_CLK) or negedge (nRST)) begin

    if(!nRST) begin
        Unpacked_data <= 0;
    end
    else begin
        if(!addri_t) begin
            Unpacked_data <= temp[31:16];
        end
        else begin
            if(addri == addri_t) begin
                if(addri[1:0] == 2'b00) begin
                    Unpacked_data <= temp[31:16];
                end
                else begin  
                    Unpacked_data <= rdata[15:0];
                end
            end
            else begin
                if(!addri[0]) begin
                    Unpacked_data <= rdata[15:0];
                end
                else begin
                    Unpacked_data <= temp[31:16];
                end
            end
        end
    end

end


endmodule