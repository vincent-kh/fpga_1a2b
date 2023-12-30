module inp_add99(key,rst,num);

input wire key,rst;
output reg [6:0]num;

always @(posedge key or posedge rst) 
begin
  if (rst) 
    num <= 0;
  else if (key)
  begin
    if (num < 99)
      num <= num + 1;
    else
      num <= 0;
  end
end

endmodule 