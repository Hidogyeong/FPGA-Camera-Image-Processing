module horizontal(CLK,UP_CLKa,Hsync,hDE,data_EN,RESET);
    
    input CLK;
    input RESET;
    
    output reg UP_CLKa;        // Hsync를 반전시킨 신호를 생성함 -> 이게 vertical의 CLK으로 들어감
    output reg Hsync;          // Hsync 생성
    output reg hDE;            // horizontal 방향에서의 valid pixel을 구분하는 enable
    output reg data_EN;

    reg [9:0] H_COUNT;  // horizontal 방향의 pixel 개수를 셈
    always@(posedge CLK or posedge RESET)
    begin
        if(RESET)
        begin
            Hsync <= 1'b0;
            H_COUNT <= 10'd0;
            hDE <= 1'b0;
            data_EN <= 1'b0;
            UP_CLKa <= 1'b0;
        end
        else
        begin
            UP_CLKa <= ~Hsync;        
            if (H_COUNT <= 10'd40) // 41 CLK (t_hp)
            begin
                Hsync <= 1'b0;     // Hsync 0      // invalid data
            end
            else if ((H_COUNT > 10'd40) && (H_COUNT <= 10'd524)) // 2 CLK (t_hb)
            begin
                Hsync <= 1'b1;     // Hsync 1      // invalid data
            end

            
            if (H_COUNT <= 10'd37) // 2 CLK (t_hb)
            begin    // Hsync 1
                hDE <= 1'b0;       // invalid data
            end
            else if ((H_COUNT > 10'd37) && (H_COUNT <= 10'd517)) // 480 CLK (t_hd)
            begin   // Hsync 1
                hDE <= 1'b1;      // valid data
            end
            else if ((H_COUNT > 10'd517) && (H_COUNT <= 10'd524)) // 2 CLK (t_hf)
            begin    // Hsync 1
                hDE <= 1'b0;      // invalid data
            end

            if(H_COUNT <= 10'd40) begin
                data_EN <= 1'b0;
            end
            else if((H_COUNT> 10'd40) && (H_COUNT <= 10'd519)) begin
                data_EN <= 1'b1;
            end
            else begin
                data_EN <= 1'b0;
            end


            if (H_COUNT < 10'd524) // H_COUNT -> 0~524 repeat
                H_COUNT <= H_COUNT + 10'd1;
            else
                H_COUNT <= 10'd0;
        end
    end


endmodule
