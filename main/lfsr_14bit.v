module lfsr_14bit(
    input clk,
    input rst,
    input [13:0] seed,
    input en,
    output reg [13:0] ran,
    output reg done
);

reg [13:0] state;
reg feedback;

always @* begin
    feedback = state[13] ^ state[11] ^ state[10] ^ state[1];
end

always @(posedge clk) begin
    if (rst) begin
        state <= seed;
        ran <= seed;
        done <= 0;
    end

    else if (en) begin
        state <= {feedback, state[13:1]};
        ran <= state;

        if (state == seed) begin
            done <= 1;
        end
        else begin
            done <= 0;
        end
    end
end

endmodule
