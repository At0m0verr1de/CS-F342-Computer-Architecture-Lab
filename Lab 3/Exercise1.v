module JKFlipFlop (
    input J,
    input K,
    input clk,
    input rst,
    output reg Q
);

    always @(posedge clk or posedge rst)
        begin
            if (rst) Q <= 4'b0000;
            else
                case({J, K})
                    2'b00: Q <= Q;
                    2'b01: Q <= 1'b0;
                    2'b10: Q <= 1'b1;
                    2'b11: Q <= ~Q;
                endcase
        end
endmodule


module synCounter(
    input clk,
    input rst,
    output reg [3:0] counter
);

    reg jk_in, jk_out;

    JKFlipFlop bitThree(1'b1, 1'b1, clk, rst, counter[0]);
    JKFlipFlop bitTwo(counter[0], counter[0], clk, rst, counter[2]);
    JKFlipFlop bitOne(counter[2]&counter[3], counter[2]&counter[3], clk, rst, counter[1]);
    JKFlipFlop bitZero(counter[1]&counter[2]&counter[3], counter[1]&counter[2]&counter[3], clk, rst, counter[0]);

    always @(posedge clk or posedge rst)
        begin
            if (rst)
                count <= 4'b0000;
            else
                count <= jk_out;
        end

endmodule

