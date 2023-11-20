module MUX_SMALL (
    input [7:0] A,
    input [7:0] B,
    input sel,
    output reg [7:0] Y
);
    assign Y = (sel) ? B : A;
endmodule

module MUX_BIG (
    input [7:0] A0, A1, A2, A3, A4, A5, A6, A7,
    input [7:0] B0, B1, B2, B3, B4, B5, B6, B7,
    input [2:0] sel,
    output reg [7:0] Y
);
    MUX_SMALL u_mux0 (.A(A0), .B(B0), .sel(sel[0]), .Y(Y));
    MUX_SMALL u_mux1 (.A(A1), .B(B1), .sel(sel[0]), .Y(Y));
    MUX_SMALL u_mux2 (.A(A2), .B(B2), .sel(sel[0]), .Y(Y));
    MUX_SMALL u_mux3 (.A(A3), .B(B3), .sel(sel[0]), .Y(Y));
    MUX_SMALL u_mux4 (.A(A4), .B(B4), .sel(sel[1]), .Y(Y));
    MUX_SMALL u_mux5 (.A(A5), .B(B5), .sel(sel[1]), .Y(Y));
    MUX_SMALL u_mux6 (.A(A6), .B(B6), .sel(sel[1]), .Y(Y));
    MUX_SMALL u_mux7 (.A(A7), .B(B7), .sel(sel[1]), .Y(Y));
endmodule

module TFF (
    input T, CLR, CLK,
    output reg Q
);
    always @(posedge CLK or posedge CLR) begin
        if (CLR)
            Q <= 1'b0;
        else if (T)
            Q <= ~Q;
    end
endmodule

module COUNTER_4BIT (
    input [3:0] CLR,
    input CLK,
    output reg [3:0] counter
);
    wire T0, T1, T2, T3;

    TFF u_tff0 (.T(1'b1), .CLR(CLR[0]), .CLK(CLK), .Q(T0));
    TFF u_tff1 (.T(T0), .CLR(CLR[1]), .CLK(CLK), .Q(T1));
    TFF u_tff2 (.T(T1), .CLR(CLR[2]), .CLK(CLK), .Q(T2));
    TFF u_tff3 (.T(T2), .CLR(CLR[3]), .CLK(CLK), .Q(T3));

    always @(posedge CLK) begin
        if (CLR[0])
            counter <= 4'b0000;
        else
            counter <= counter + 1;
    end
endmodule

module COUNTER_3BIT (
    input [2:0] CLR,
    input CLK,
    output reg [2:0] counter
);
    wire T0, T1, T2;

    TFF u_tff0 (.T(1'b1), .CLR(CLR[0]), .CLK(CLK), .Q(T0));
    TFF u_tff1 (.T(T0), .CLR(CLR[1]), .CLK(CLK), .Q(T1));
    TFF u_tff2 (.T(T1), .CLR(CLR[2]), .CLK(CLK), .Q(T2));

    always @(posedge CLK) begin
        if (CLR[0])
            counter <= 3'b000;
        else
            counter <= counter + 1;
    end
endmodule

module MEMORY (
    input [3:0] addr,
    output reg [7:0] data
);
    reg [7:0] mem [0:15];

    initial begin
        mem[0]  = 8'hCC;
        mem[1]  = 8'hAA;
        mem[2]  = 8'hCC;
        mem[3]  = 8'hAA;
        mem[4]  = 8'hCC;
        mem[5]  = 8'hAA;
        mem[6]  = 8'hCC;
        mem[7]  = 8'hAA;
        mem[8]  = 8'hCC;
        mem[9]  = 8'hAA;
        mem[10] = 8'hCC;
        mem[11] = 8'hAA;
        mem[12] = 8'hCC;
        mem[13] = 8'hAA;
        mem[14] = 8'hCC;
        mem[15] = 8'hAA;
    end

    always @(posedge addr) begin
        data <= mem[addr];
    end
endmodule

module INTG (
    input START, CLK, X,
    output [3:0] CLR_4BIT,
    output [2:0] CLR_3BIT,
    output G, Z
);
    wire [3:0] counter_4bit;
    wire [2:0] counter_3bit;
    wire mem_data;

    COUNTER_4BIT u_counter_4bit (.CLR(CLR_4BIT), .CLK(CLK), .counter(counter_4bit));
    COUNTER_3BIT u_counter_3bit (.CLR(CLR_3BIT), .CLK(CLK), .counter(counter_3bit));
    MEMORY u_memory (.addr(counter_4bit), .data(mem_data));

    always @* begin
        CLR_4BIT = counter_4bit;
        CLR_3BIT = counter_3bit;

        G = mem_data & (counter_4bit == 4'hF);
        Z = G;
    end

endmodule
