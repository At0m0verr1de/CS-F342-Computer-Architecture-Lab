module fourBitMagnitudeComparatorBehavioral(
    input [3:0] a,
    input [3:0] b,
    output o1, o2, o3
);

    always @(*)
    begin
        if (a < b) begin
            o1 = 1'b1;
            o2 = 1'b0;
            o3 = 1'b0;
        end else if (a > b) begin
            o1 = 1'b0;
            o2 = 1'b1;
            o3 = 1'b0;
        end else begin
            o1 = 1'b0;
            o2 = 1'b0;
            o3 = 1'b1;
        end
    end

endmodule
