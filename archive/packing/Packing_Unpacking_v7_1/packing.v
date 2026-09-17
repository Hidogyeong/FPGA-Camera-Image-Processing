module packing(
    input               clk,
    input               nRST,
    input       [3:0]   addri,
    input       [15:0]  datain,
    output reg  [2:0]   addro,
    output reg     [31:0]  packed_data
);

reg [15:0]  temp;
reg [3:0] addri_t;


always @(posedge(clk) or negedge(nRST)) begin

    if(!nRST) begin
        addri_t <= 0;
    end
    else begin
        addri_t <= addri;
    end

end


//addro
always @(posedge(clk) or negedge(nRST)) begin

    if(!nRST) begin
        addro <= 0;
    end
    else begin
        if(!addri) begin 
            addro <= 0;
        end
        else begin
            addro <= addri_t >> 1;
        end
    end
end

//temp
always @(posedge(clk) or negedge(nRST)) begin

    if(!nRST) begin
        temp <= 0;
    end
    else begin
        if(!addri[0]) begin
            temp <= datain;
        end
        else begin
            temp <= temp;
        end          
    end

end

//packed_data;
always @(posedge clk or negedge nRST) begin

    if(!nRST) begin
        packed_data <= 0;
    end
    else begin
        if(!addri) begin
            packed_data <= 0;
        end
        else begin
            if(addri[0]) begin
                packed_data <= {temp,datain};
            end
            else begin
                packed_data <= packed_data;                
            end
        end

    end

end

endmodule
