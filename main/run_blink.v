module run_blink(led,clk);

input clk;
output reg [7:0]led;

initial
begin
	led=8'b00000011;
end

always@(posedge clk)
begin
	led <= led*2;
	if (led > 8'b10000000)
		led<=8'b00000011;
end
endmodule

		
