module inp_add4(key,num);

input key;
output reg [2:0]num;

always@(posedge key)
begin
	if(num<4)
	num=num+1;
	else
	num=0;
end
endmodule
