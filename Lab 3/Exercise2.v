module SequenceDetector (
    input bit in_bit,
    output reg detected
);

typedef enum logic [2:0] {
    S0, S1, S2, S3, S4
} State;

reg [2:0] current_state, next_state;

always_ff @(posedge in_bit) begin
    case (current_state)
        S0: if (in_bit) next_state = S1; else next_state = S0;
        S1: if (in_bit) next_state = S2; else next_state = S0;
        S2: if (in_bit) next_state = S3; else next_state = S0;
        S3: if (in_bit) next_state = S4; else next_state = S0;
        S4: if (in_bit) next_state = S1; else next_state = S0;
        default: next_state = S0;
    endcase
end

always_ff @(posedge in_bit) begin
    if (current_state == S3 && next_state == S4)
        detected <= 1'b1;
    else
        detected <= 1'b0;
end

always_ff @(posedge in_bit) begin
    current_state <= next_state;
end

endmodule


