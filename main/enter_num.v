module enter_num(stat,key,d0,d1,d2,d3,con);

input [2:0]stat;
input key;
output reg [3:0]d0;
output reg [3:0]d1;
output reg [3:0]d2;
output reg [3:0]d3;
output reg con;


always@(*)
begin 
case(stat)
	0:begin 
		inp_add(key,d0);
		con=1'b0;
	end 
	1:inp_add(key,d1);
	2:inp_add(key,d2);
	3:inp_add(key,d3);
	4:con=1'b1;
	default: begin
            d0 = 4'b0;
            d1 = 4'b0;
            d2 = 4'b0;
            d3 = 4'b0;
            con = 1'b0;
            end
endcase
end 
endmodule 
