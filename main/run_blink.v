module run_blink(led,clk);

input clk;
output reg [8:0]led;

initial
begin
	led=9'b000000011;
end

always@(posedge clk)
begin
	led <= led*2;
	if (led > 9'b100000000)
		led<=9'b000000011;
end
endmodule

		
