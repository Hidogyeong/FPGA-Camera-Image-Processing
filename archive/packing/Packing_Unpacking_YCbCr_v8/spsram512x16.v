
module spsram (CK, WEN, A, DI, DOUT);
input CK;
input WEN;
input [2:0] A;
input [47:0] DI;
output [47:0] DOUT;
reg [47:0] RAM [7:0];
reg [47:0] DOUT;

always @(posedge CK)
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