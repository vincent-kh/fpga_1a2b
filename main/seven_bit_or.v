module seven_bit_or(
    input [6:0] data,
    input en,
    output [6:0] out_data
);

genvar i;

generate
    for (i = 0; i < 7; i = i + 1) 
    begin :sevenor
        assign out_data[i] = |{data[i], en};
    end
endgenerate

endmodule 