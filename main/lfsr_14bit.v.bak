module lfsr_14bit(
    input clk,     // clock signal
    input rst,     // reset signal
    input [13:0] seed,  // seed value
    input en,      // enable signal
    output reg [13:0] ran,   // random number
    output reg done   // done signal
);

// declare a 14-bit register to store the LFSR state
reg [13:0] state;
// declare a reg to store the feedback bit
reg feedback;

// always block to calculate the feedback bit
always @* begin
    // Use different taps for a better pseudorandom sequence
    feedback = state[13] ^ state[11] ^ state[10] ^ state[1];
end

// always block to update the state and the random number at the positive edge of the clock
always @(posedge clk) begin
    // if reset is high, set the state to the seed value
    if (rst) begin
        state <= seed;
        ran <= seed;
        done <= 0;
    end
    // else if enable is high, shift the state to the right and insert the feedback bit to the left
    else if (en) begin
        state <= {feedback, state[13:1]};
        ran <= state;
        // if the state is equal to the seed value, set the done signal to high
        if (state == seed) begin
            done <= 1;
        end
        // else set the done signal to low
        else begin
            done <= 0;
        end
    end
end

endmodule
