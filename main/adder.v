module adder (A,B,C,D,out);

	input A,B,C,D;
	output [3:0]out;
	
	assign out=A+B+C+D;
	
endmodule
