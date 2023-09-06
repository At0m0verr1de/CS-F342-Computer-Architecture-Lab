
module testbench;
    reg a, b, cin;
    wire s, cout;

    fullAdderGateLevel fA(a, b, cin, s, cout);

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
