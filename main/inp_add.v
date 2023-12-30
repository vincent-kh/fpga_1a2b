module inp_add(key,rst,num);

input wire key,rst;
output reg [3:0]num;

always @(posedge key or posedge rst) 
begin
  if (rst) 
    num <= 0;
  else if (key)
  begin
    if (num < 9)
      num <= num + 1;
    else
      num <= 0;
  end
end

endmodule 
