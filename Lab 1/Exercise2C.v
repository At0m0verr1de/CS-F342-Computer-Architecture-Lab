module fourBitMagnitudeComparatorGateLevel(a0, a1, a2, a3, b0, b1, b2, b3, o1, o2, o3);
    input a0, a1, a2, a3, b0, b1, b2, b3;
    output o1, o2, o3;

    wire w1, w2, w3, w4, w5, w6, w7, w8, 
    w9, w10, 
    w11, w12, 
    w13, w14, 
    w15, w16, 
    w17, w18, w19, w20,
    w21, w22, w23, w24, w25, w26;

    // nots for each input: 1st level
    not(w1, a0);
    not(w2, a1);
    not(w3, a2);
    not(w4, a3);
    not(w5, b0);
    not(w6, b1);
    not(w7, b2);
    not(w8, b3);

    // 2nd + 3rd level
    and(w9, b3, w4);
    and(w10, a3, w8);
    nor(w17, w9, w10);

    and(w11, b2, w3);
    and(w12, a2, w7);
    nor(w18, w11, w12);

    and(w13, b1, w2);
    and(w14, a1, w6);
    nor(w19, w13, w14);

    and(w15, b0, w1);
    and(w16, a0, w5);
    nor(w20, w15, w16);

    // 4th level
    and(w21, w17, w11);
    and(w22, w17, w12);
    and(w23, w17, w18, w13);
    and(w24, w17, w18, w14);
    and(w25, w17, w18, w19, w15);
    and(w26, w17, w18, w19, w16);
    and(o3, w17, w18, w19, w20);

    // 5th level
    or(o1, w9, w21, w23, w25);
    or(o2, w10, w22, w24, w26);

endmodule



module testbench;
    reg a0, a1, a2, a3, b0, b1, b2, b3;
    wire o1, o2, o3;

    fourBitMagnitudeComparatorGateLevel comparator(a0, a1, a2, a3, b0, b1, b2, b3, o1, o2, o3);

    initial
        begin
            $monitor(,$time, " A = %b%b%b%b   B = %b%b%b%b     A<B: %b       A>B: %b       A=B: %b", a3, a2, a1, a0, b3, b2, b1, b0, o1, o2, o3);
            #0 a3=1'b1; a2=1'b0; a1=1'b0; a0=1'b1; b3=1'b1; b2=1'b0; b1=1'b0; b0=1'b1;
        end
endmodule