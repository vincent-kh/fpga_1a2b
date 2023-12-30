module com(
    input [3:0] data1,
    input [3:0] data2,
    output reg eq
);

always @* begin
    if (data1 == data2)
        eq = 1'b1;
    else
        eq = 1'b0;
end
endmodule 