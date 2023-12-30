module oct_decode2(inp,h1,h0);

input [6:0]inp;
output [3:0]h1;
output [3:0]h0;

assign h0=inp%10;
assign h1=(inp/10)%10;


endmodule 