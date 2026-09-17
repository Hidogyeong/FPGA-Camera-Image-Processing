module packing(
    input               clk,
    input               nRST,
    input       [3:0]   addri,
    input       [15:0]  datain,
    output reg  [2:0]   addro,
    output reg     [31:0]  packed_data
);

reg [31:0]  temp;
reg [3:0] addr_t;


always @(posedge clk or negedge nRST) begin

    if(!nRST) begin
        addr_t <= 0;
    end
    else begin
        addr_t <= addri;
    end

end



//addro
always @(posedge(clk) or negedge(nRST)) begin

    if(!nRST) begin
        addro <= 0;
    end
    else begin
        if(addri[0]) begin
            addro <= addr_t >> 1;
        end
        else if(addr_t[0] == 0) begin
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
        if(addri[0]) begin
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
        if(addri[0]) begin        
            packed_data <= temp;
        end
        else if(addri == 0) begin
            packed_data <= temp;
        end
        else begin
            packed_data <= packed_data;
        end
    end

end

endmodule
