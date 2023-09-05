/*
Binary to Gray conversion using Data Flow Modelling: 
    The Most Significant Bit (MSB) of the gray code is always equal to the MSB of the given binary code.
    Other bits of the output gray code can be obtained by XORing binary code bit at that index and previous index.
*/

module bcdToGreyDataFlow (b3, b2, b1, b0, g2, g1, g0);

    input b3, b2, b1, b0;
    output g2, g1, g0;

    // finding G0
    assign g0 = (b0&(~b1)) | (b1&(~b0));

    // finding G1
    assign g1 = (b1&(~b2)) | (b2&(~b1));

    // finding G2
    assign g2 = b2 | b3;

    // finding G3
    // Use b3 directly for g3

endmodule


module testbench;
    reg a, b, c, d;
    wire f, g, h;
    bcdToGreyDataFlow bcdConverter(a, b, c, d, f, g, h);

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