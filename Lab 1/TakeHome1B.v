// one bit full adder: Data Flow Model

module fullAdderDataFlow(a, b, cin, s, cout);
    input a, b, cin;
    output s, cout;

    assign s = (a ^ b) ^ cin;
    assign cout = (a & b) | ((a ^ b) & cin);
endmodule

module fourBitAdder(a3, a2, a1, a0, b3, b2, b1, b0, cin, o3, o2, o1, o0, cout);
    input a3, a2, a1, a0, b3, b2, b1, b0, cin;
    output o3, o2, o1, o0, cout;

    wire c0, c1, c2;

    fullAdderDataFlow f1 (a0, b0, cin, o0, c0);
    fullAdderDataFlow f2 (a1, b1, c0, o1, c1);
    fullAdderDataFlow f3 (a2, b2, c1, o2, c2);
    fullAdderDataFlow f4 (a3, b3, c2, o3, cout);

endmodule



module testbench;
    reg a3, a2, a1, a0, b3, b2, b1, b0, cin;
    output o3, o2, o1, o0, cout;

    fourBitAdder fBA(a3, a2, a1, a0, b3, b2, b1, b0, cin, o3, o2, o1, o0, cout);

    initial
        begin
            $monitor(, $time, " A: %b%b%b%b    B: %b%b%b%b    Cin: %b         Sum: %b%b%b%b   Carry: %b", a3, a2, a1, a0, b3, b2, b1, b0, cin, o3, o2, o1, o0, cout);
            #0 a3=1'b0; a2=1'b0; a1=1'b0; a0=1'b0; b3=1'b1; b2=1'b1; b1=1'b1; b0=1'b1; cin=1'b0;
            #1 a3=1'b1; a2=1'b0; a1=1'b1; a0=1'b0; b3=1'b1; b2=1'b1; b1=1'b1; b0=1'b1; cin=1'b0;
            #1 a3=1'b0; a2=1'b1; a1=1'b0; a0=1'b1; b3=1'b1; b2=1'b1; b1=1'b0; b0=1'b0; cin=1'b0;
            #1 a3=1'b0; a2=1'b0; a1=1'b0; a0=1'b0; b3=1'b0; b2=1'b1; b1=1'b1; b0=1'b0; cin=1'b0;
        end

endmodule