module ab(en,a,b);

input en;
output reg [6:0]a;
output reg [6:0]b;

always@(*)
begin
	if (en)
	begin
		a<=7'b0001000;
		b<=7'b0000011;
	end 
	else
	begin
		a<=7'b1111111;
		b<=7'b1111111;
	end 
end
endmodule
