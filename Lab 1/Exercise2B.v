module fourBitMagnitudeComparatorDataFlow(
    input a0, a1, a2, a3, b0, b1, b2, b3,
    output o1, o2, o3
);

    wire w1, w2, w3, w4, w5, w6, w7, w8, 
         w9, w10, 
         w11, w12, 
         w13, w14, 
         w15, w16, 
         w17, w18, w19, w20,
         w21, w22, w23, w24, w25, w26;

    assign w1 = ~a0;
    assign w2 = ~a1;
    assign w3 = ~a2;
    assign w4 = ~a3;
    assign w5 = ~b0;
    assign w6 = ~b1;
    assign w7 = ~b2;
    assign w8 = ~b3;

    assign w9 = b3 & w4;
    assign w10 = a3 & w8;
    assign w17 = ~(w9 | w10);

    assign w11 = b2 & w3;
    assign w12 = a2 & w7;
    assign w18 = ~(w11 | w12);

    assign w13 = b1 & w2;
    assign w14 = a1 & w6;
    assign w19 = ~(w13 | w14);

    assign w15 = b0 & w1;
    assign w16 = a0 & w5;
    assign w20 = ~(w15 | w16);

    assign w21 = w17 & w11;
    assign w22 = w17 & w12;
    assign w23 = w17 & w18 & w13;
    assign w24 = w17 & w18 & w14;
    assign w25 = w17 & w18 & w19 & w15;
    assign w26 = w17 & w18 & w19 & w16;

    assign o3 = w17 & w18 & w19 & w20;

    assign o1 = w9 | w21 | w23 | w25;
    assign o2 = w10 | w22 | w24 | w26;

endmodule
