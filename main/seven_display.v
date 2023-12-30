module seven_display(SW,H);

	input [3:0]SW;
	output [6:0]H;
	reg [6:0]H;
	
	always@ (SW)
	begin
		case (SW)
				  //gfedcba
			0: H=7'b1000000;
			1: H=7'b1111001;
			2: H=7'b0100100;
			3: H=7'b0110000;
			4: H=7'b0011001;
			5: H=7'b0010010;
			6: H=7'b0000010;
			7: H=7'b1011000;
			8: H=7'b0000000;
			9: H=7'b0011000;
		default:H=7'b1111111;
	endcase
end
endmodule 