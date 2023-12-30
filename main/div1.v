module div1(clk,out);

input clk;
output reg out;

reg [25:0]r;

always@(posedge clk)
begin
if (r<25000000)
	r<=r+1;
else
	begin
	r<=0;
	out=~out;
	end
end
endmodule
