module line_ram (clk, WEN, A, DI, DOUT);
input clk;
input WEN;
input [8:0] A; //240
input [47:0] DI;
output [95:0] DOUT;
reg [47:0] RAM [4:0];
reg [47:0] DOUT;

always @(posedge clk)
begin

if (WEN)
begin
RAM[A] <= DI;
DOUT <= DI;
end
else
DOUT <= RAM[A];
end

endmodule

