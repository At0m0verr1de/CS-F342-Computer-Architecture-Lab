// one bit full adder: Data Flow Model

module fullAdderDataFlow(a, b, cin, s, cout);
    input a, b, cin;
    output s, cout;

    assign s = (a ^ b) ^ cin;
    assign cout = (a & b) | ((a ^ b) & cin);
endmodule


module fullAdderGateLevel(a, b, cin, s, cout);
    input a, b, cin;
    output s, cout;

    wire w1, w2, w3, w4, w5, w6;

    // XOR gates for sum
    assign w1 = a ^ b;
    assign s = w1 ^ cin;

    // AND gates
    assign w2 = a & b;
    assign w3 = a & cin;
    assign w4 = b & cin;

    // OR gates for carry out
    assign w5 = w2 | w3;
    assign w6 = w4 | w5;
    assign cout = w6;

endmodule


module testbench;
    reg a, b, cin;
    output s, cout;

    fullAdderDataFlow FADF(a, b, cin, s, cout);

    initial
        begin
            $monitor(, $time, " A: %b    B: %b    Cin: %b         Sum: %b   Carry: %b", a, b, cin, s, cout);
            #0 a=1'b0; b=1'b0; cin=1'b0;
            #1 a=1'b0; b=1'b0; cin=1'b1;
            #1 a=1'b0; b=1'b1; cin=1'b0;
            #1 a=1'b0; b=1'b1; cin=1'b1;
            #1 a=1'b1; b=1'b0; cin=1'b0;
            #1 a=1'b1; b=1'b0; cin=1'b1;
            #1 a=1'b1; b=1'b1; cin=1'b0;
            #1 a=1'b1; b=1'b1; cin=1'b1;


        end

endmodule