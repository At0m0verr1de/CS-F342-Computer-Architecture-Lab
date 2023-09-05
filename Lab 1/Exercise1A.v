/*
Binary to Gray conversion using Gate Level Modelling: 
    The Most Significant Bit (MSB) of the gray code is always equal to the MSB of the given binary code.
    Other bits of the output gray code can be obtained by XORing binary code bit at that index and previous index.
*/

module bcdToGreyGateLevel (b3, b2, b1, b0, g2, g1, g0);

    input b3, b2, b1, b0;
    output g2, g1, g0;
    wire w1, w2, w3, w4, w5, w6, w7, w8;

    not(w1, b0);
    not(w2, b1);
    not(w3, b2);
    not(w4, b3);

    // finding G0
    and(w5, b0, w2);
    and(w6, b1, w1);
    or(g0, w5, w6);

    // finding G1
    and(w7, b1, w3);
    and(w8, b2, w2);
    or(g1, w7, w8);

    // finding G2
    or(g2, b2, b3);

    // finding G3
    // Use b3 directly for g3

endmodule


module testbench;
    reg a, b, c, d;
    wire f, g, h;
    bcdToGreyGateLevel bcdConverter(a, b, c, d, f, g, h);

    initial
        begin
            $monitor(,$time," bcd=%b%b%b%b    grey=%b%b%b%b",a,b,c,d,a,f,g,h); 
            #0 a=1'b0; b=1'b0; c=1'b0; d=1'b0;
            #1 a=1'b0; b=1'b0; c=1'b0; d=1'b1;
            #1 a=1'b0; b=1'b0; c=1'b1; d=1'b0;
            #1 a=1'b0; b=1'b0; c=1'b1; d=1'b1;
            #1 a=1'b0; b=1'b1; c=1'b0; d=1'b0;
            #1 a=1'b0; b=1'b1; c=1'b0; d=1'b1;
            #1 a=1'b0; b=1'b1; c=1'b1; d=1'b0;
            #1 a=1'b0; b=1'b1; c=1'b1; d=1'b1;
            #1 a=1'b1; b=1'b0; c=1'b0; d=1'b0;
            #1 a=1'b1; b=1'b0; c=1'b0; d=1'b1;
        end

endmodule