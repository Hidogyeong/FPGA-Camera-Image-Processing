module horizontal(CLK,UP_CLKa, Hsync,hDE,RESET);
    
    input CLK;
    input RESET;
    
    output reg UP_CLKa;
    output reg Hsync;
    output reg hDE;
    
    reg [9:0] H_COUNT;

    always@(posedge CLK or posedge RESET)
    begin
        if(RESET)
        begin
            Hsync <= 1'b0;
            H_COUNT <= 10'd0;
            hDE <= 1'b0;
            UP_CLKa <= 1'b0;
        end
        else
        begin
            UP_CLKa <= ~Hsync;        
            if (H_COUNT <= 10'd40)
            begin
                Hsync <= 1'b0;
                hDE <= 1'b0;
            end
            else if ((H_COUNT > 10'd40) && (H_COUNT <= 10'd42))
            begin
                Hsync <= 1'b1;
                hDE <= 1'b0;
            end
            else if ((H_COUNT > 10'd42) && (H_COUNT <= 10'd522))
            begin
                Hsync <= 1'b1;
                hDE <= 1'b1;
            end
            else if ((H_COUNT > 10'd522) && (H_COUNT <= 10'd524))
            begin
                Hsync <= 1'b1;
                hDE <= 1'b0;
            end
            if (H_COUNT < 10'd524)
                H_COUNT <= H_COUNT + 10'd1;
            else
                H_COUNT <= 10'd0;
        end
    end

endmodule
