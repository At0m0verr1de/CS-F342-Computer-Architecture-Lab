module fourBitMagnitudeComparator();

endmodule



module testbench;
    reg a1, a2, a3, a4, 
    initial
        begin
            $monitor(,$time, "A = %b%b%b%b   B = %b%b%b%b     A<B: %b       A>B: %b       A=B: %b");
        end
endmodule