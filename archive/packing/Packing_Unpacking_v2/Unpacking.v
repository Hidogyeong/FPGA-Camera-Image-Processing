module Unpacking(
    input              clk,
    input              nRST,
    input              wea,
    input       [3:0]  addri,
    input       [31:0] rdata,
    output reg  [2:0]  addro,
    output reg  [15:0] Unpacked_data
);


reg [31:0]  temp; 
reg [2:0]   cnt_t;

always @(posedge(wea) or negedge(nRST)) begin

    if(!nRST) begin
        cnt_t <= 0;
    end
    else begin
            if(addri) begin
                if(cnt_t == 3'b100) begin
                    cnt_t <= 1;
                end
                else begin
                    cnt_t <= cnt_t + 1;
                end   
  
            end
            else begin
                    cnt_t <= cnt_t;
            end 
    end      

end

 


//addro
always @(posedge(wea) or negedge(nRST)) begin

    if(!nRST) begin
        addro <= 0;
    end
    else begin

        if(!addri) begin
            addro <= 0;
        end
        else begin
            if(addri[0] == 0) begin
                addro <= addro + 1;
            end
            else begin
                addro <= addro;
            end
        end

    end

end


//temp
always @(posedge(wea) or negedge(nRST)) begin

    if(!nRST) begin
        temp <= 0;
    end
    else begin

        if(addri[0] == 1) begin
            temp <= rdata;
        end


    end

end

//Unpacked_data
always @(posedge (wea) or negedge (nRST)) begin

    if(!nRST) begin
        Unpacked_data <= 0;
    end
    else begin

        if(addri[0] == 0) begin
            Unpacked_data <= temp[31:16];
        end
        else if(addri[0] == 1) begin
            Unpacked_data <= temp[15:0];
        end
        else begin
            Unpacked_data <= Unpacked_data;
        end
        
    end

end


endmodule