module D_FF (
    input D, CLK, RST,
    output Q
);
    reg Q;

    always @(posedge CLK or posedge RST) begin
        if (RST)
            Q <= 1'b0;
        else
            Q <= D;
    end
endmodule


module T_FF (
    input T, CLK, RST,
    output Q
);
    reg Q;

    always @(posedge CLK or posedge RST) begin
        if (RST)
            Q <= 1'b0;
        else if (T)
            Q <= ~Q;
    end
endmodule


module COUNTER_4BIT (
    input CLK, RST,
    output reg [3:0] counter
);
    wire T1, T2, T3;

    T_FF u_tff0 (.T(1'b1), .CLK(CLK), .RST(RST), .Q(T1));
    T_FF u_tff1 (.T(T1), .CLK(CLK), .RST(RST), .Q(T2));
    T_FF u_tff2 (.T(T2), .CLK(CLK), .RST(RST), .Q(T3));
    T_FF u_tff3 (.T(T3), .CLK(CLK), .RST(RST), .Q(counter[0]));

    always @(posedge CLK or posedge RST) begin
        if (RST)
            counter <= 4'b0000;
        else
            counter <= counter + 1;
    end
endmodule


module ControlLogic (
    input [4:0] S,
    input Z, X, CLK,
    output wire TO, T1, T2
);
    wire D1, D2, D3;

    // Implementing the logic for D Flip-Flops
    assign D1 = ~S[4] & Z & ~X;
    assign D2 = ~S[3] & Z & X;
    assign D3 = ~S[2] & ~S[1] & ~S[0] & ~Z & ~X;

    // Connecting D Flip-Flops
    D_FF u_dff0 (.D(D1), .CLK(CLK), .RST(~S[4]), .Q(TO));
    D_FF u_dff1 (.D(D2), .CLK(CLK), .RST(~S[3]), .Q(T1));
    D_FF u_dff2 (.D(D3), .CLK(CLK), .RST(~S[2]), .Q(T2));
endmodule



module INTG (
    input S, CLK,
    output [3:0] counter,
    output TO, T1, T2
);
    wire Z, X, T0, T_1, T_2;

    // Assuming Z, X are derived from some logic
    // Implement your logic for Z and X here

    ControlLogic u_control_logic (
        .S(S),
        .Z(Z),
        .X(X),
        .CLK(CLK),
        .TO(TO),
        .T1(T1),
        .T2(T2)
    );

    COUNTER_4BIT u_counter (
        .CLK(CLK),
        .RST(~S),
        .counter(counter)
    );
endmodule



module tb_INTG;
    reg S, CLK;
    wire [3:0] counter;
    wire TO, T1, T2;

    INTG u_intg (
        .S(S),
        .CLK(CLK),
        .counter(counter),
        .TO(TO),
        .T1(T1),
        .T2(T2)
    );

    initial begin
        S = 1;
        CLK = 0;

        // Apply a clock of 1 KHz
        forever #500 CLK = ~CLK;

        // Toggle S and X
        #100 S = ~S;
        #100 S = ~S;

        // Monitor the outputs
        $monitor("Time=%t, Counter=%b, TO=%b, T1=%b, T2=%b", $time, counter, TO, T1, T2);
        #2000 $finish;
    end
endmodule
