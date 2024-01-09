module anser_dis(
  input [3:0] h0,
  input [3:0] h1,
  input [3:0] h2,
  input [3:0] h3,
  input en,
  output [3:0] h0o,
  output [3:0] h1o,
  output [3:0] h2o,
  output [3:0] h3o
);

  genvar i, j, k, m;

  generate
    for (i = 0; i < 4; i = i + 1) begin :h0a
      assign h0o[i] = h0[i] & en;
    end
  endgenerate

  generate
    for (j = 0; j < 4; j = j + 1) begin :h1a
      assign h1o[j] = h1[j] & en;
    end
  endgenerate

  generate
    for (k = 0; k < 4; k = k + 1) begin :h2a
      assign h2o[k] = h2[k] & en;
    end
  endgenerate

  generate
    for (m = 0; m < 4; m = m + 1) begin :h3a
      assign h3o[m] = h3[m] & en;
    end
  endgenerate

endmodule
