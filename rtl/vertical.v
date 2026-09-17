module vertical(CLK,Vsync,vDE,RESET);
    
    input CLK;
    input RESET;
    
    output reg Vsync;
    output reg vDE;
    
    reg [9:0] V_COUNT;

    always@(posedge CLK or posedge RESET)
    begin
        if(RESET)
        begin
            V_COUNT <= 10'd0;
            Vsync <= 1'b0;
            vDE <= 1'b0;
        end
        else
        begin
            if (V_COUNT <= 9)
            begin
                Vsync <= 1'b0;
                vDE <= 1'b0;
            end
            else if ((V_COUNT > 9) && (V_COUNT <= 10))
            begin
                Vsync <= 1'b1;
                vDE <= 1'b0;
            end
            else if ((V_COUNT > 10) && (V_COUNT <= 282))
            begin
                Vsync <= 1'b1;
                vDE <= 1'b1;
            end
            else if ((V_COUNT > 282) && (V_COUNT <= 285))
            begin
                Vsync <= 1'b1;
                vDE <= 1'b0;
            end
            if (V_COUNT < 285)
              V_COUNT <= V_COUNT + 10'b1;
            else
              V_COUNT <= 10'd0;
        end
    end
    

endmodule
