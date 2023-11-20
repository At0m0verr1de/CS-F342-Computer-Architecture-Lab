module RSFlipFlop(
    input R, S, clk,
    output reg Q, Qbar
);
    always @(posedge clk) begin
        if (R & ~S)
            Q <= 0;
        else if (~R & S)
            Q <= 1;
    end

    always @(posedge clk) begin
        Qbar <= ~Q;
    end
endmodule

module DFlipFlop(
    input D, clk, reset,
    output reg Q, Qbar
);
    wire R = 0, S = 0; // For a simple D flip-flop, R and S are always 0

    RSFlipFlop u_rs_ff (
        .R(R),
        .S(S),
        .clk(clk),
        .Q(Q),
        .Qbar(Qbar)
    );

    always @(posedge clk or posedge reset) begin
        if (reset)
            Q <= 0;
        else
            Q <= D;
    end
endmodule

module RippleCounter(
    input clk, reset,
    output reg [3:0] counter
);
    reg [3:0] D_input;

    DFlipFlop u_dff_0 (
        .D(D_input[0]),
        .clk(clk),
        .reset(reset),
        .Q(counter[0]),
        .Qbar()
    );

    DFlipFlop u_dff_1 (
        .D(D_input[1]),
        .clk(clk),
        .reset(reset),
        .Q(counter[1]),
        .Qbar()
    );

    DFlipFlop u_dff_2 (
        .D(D_input[2]),
        .clk(clk),
        .reset(reset),
        .Q(counter[2]),
        .Qbar()
    );

    DFlipFlop u_dff_3 (
        .D(D_input[3]),
        .clk(clk),
        .reset(reset),
        .Q(counter[3]),
        .Qbar()
    );

    always @(posedge clk) begin
        D_input <= counter;
    end
endmodule

module MEM1(
    output reg [7:0] mem[0:7]
);
    initial begin
        mem[0] = 8'b11011001;
        mem[1] = 8'b10101010;
        // Initialize other memory locations as needed
    end
endmodule

module MEM2(
    output reg [7:0] mem[0:7]
);
    initial begin
        mem[0] = 8'b01100110;
        mem[1] = 8'b10010010;
        // Initialize other memory locations as needed
    end
endmodule

module Fetch_Data(
    input [2:0] Addr,
    input [3:0] Counter,
    input [7:0] Mem1[0:7],
    input [7:0] Mem2[0:7],
    output [7:0] Data
);
    wire [7:0] MUX16ToS_out;

    MUX16ToS u_mux16tos (
        .data({Mem1, Mem2}),
        .sel(Counter),
        .out(MUX16ToS_out)
    );

    assign Data = MUX16ToS_out;
endmodule

module MUX16ToS(
    input [7:0] data[0:15],
    input [3:0] sel,
    output reg [7:0] out
);
    always @* begin
        case (sel)
            4'b0000: out = data[0];
            4'b0001: out = data[1];
            // Add cases for 2 to 14 as needed
            4'b1111: out = data[15];
            default: out = 8'b00000000;
        endcase
    end
endmodule

module MUX1To1(
    input [7:0] data0, data1,
    input sel,
    output reg [7:0] out
);
    always @* begin
        if (sel)
            out = data1;
        else
            out = data0;
    end
endmodule

module Parity_Checker(
    input [7:0] Data,
    input Parity,
    output wire Parity_Match
);
    wire [7:0] computed_parity;

    assign computed_parity = ^Data; // XOR of all bits in Data

    assign Parity_Match = (computed_parity == Parity);
endmodule

module Design(
    input clk, reset,
    output wire [7:0] Data,
    output wire Parity_Match
);
    wire [3:0] Counter;
    wire [7:0] Fetch_Data_out;
    wire [7:0] Data_out;

    RippleCounter u_ripple_counter (
        .clk(clk),
        .reset(reset),
        .counter(Counter)
    );

    MEM1 u_mem1 (
        .mem(Data_out)
    );

    MEM2 u_mem2 (
        .mem(Data_out)
    );

    Fetch_Data u_fetch_data (
        .Addr(Counter[2:0]),
        .Counter(Counter),
        .Mem1(u_mem1.mem),
        .Mem2(u_mem2.mem),
        .Data(Fetch_Data_out)
    );

    Parity_Checker u_parity_checker (
        .Data(Fetch_Data_out),
        .Parity(Fetch_Data_out[7]),
        .Parity_Match(Parity_Match)
    );

    assign Data = Fetch_Data_out;

endmodule

module tb_Design;
    reg clk, reset;
    wire [7:0] Data;
    wire Parity_Match;

    Design uut (
        .clk(clk),
        .reset(reset),
        .Data(Data),
        .Parity_Match(Parity_Match)
    );

    initial begin
        clk = 0;
        reset = 1;
        #10 reset = 0;

        // Simulate clock and test functionality

        #100 $finish;
    end

    always #5 clk = ~clk;

endmodule
