module REG_8BIT(
    output reg [7:0] reg_out,
    input [7:0] num_in,
    input clock,
    input reset
);
    always @(posedge clock or posedge reset) begin
        if (reset)
            reg_out <= 8'b0;
        else
            reg_out <= num_in;
    end
endmodule


module EXPANSION_BOX(
    input [3:0] in,
    output [7:0] out
);
    assign out = {in, in}; // Expanding 4-bit input to 8-bit
endmodule


module XOR_8BIT(
    output reg [7:0] xout_8,
    input [7:0] xin1_8,
    input [7:0] xin2_8
);
    always @* begin
        xout_8 = xin1_8 ^ xin2_8;
    end
endmodule


module XOR_4BIT(
    output reg [3:0] xout_4,
    input [3:0] xin1_4,
    input [3:0] xin2_4
);
    always @* begin
        xout_4 = xin1_4 ^ xin2_4;
    end
endmodule


module CSA_4BIT(
    input cin,
    input [3:0] inA,
    input [3:0] inB,
    output cout,
    output [3:0] out
);
    reg [3:0] carry;
    wire [3:0] sum;

    XOR_4BIT u_xor1 (
        .xin1_4(inA),
        .xin2_4(inB),
        .xout_4(sum)
    );

    XOR_4BIT u_xor2 (
        .xin1_4(sum),
        .xin2_4(cin),
        .xout_4(out)
    );

    always @* begin
        carry = (sum & cin) | (inA & inB);
    end

    assign cout = carry[3];
endmodule

module CONCAT(
    output reg [7:0] concat_out,
    input [3:0] concat_in1,
    input [3:0] concat_in2
);
    always @* begin
        concat_out = {concat_in1, concat_in2};
    end
endmodule

module ENCRYPT(
    input [7:0] number,
    input [7:0] key,
    input clock,
    input reset,
    output reg [7:0] enc_number
);
    wire [7:0] reg_out, exp_out, xor_out, csa_out, concat_out;

    REG_8BIT u_reg (
        .reg_out(reg_out),
        .num_in(number),
        .clock(clock),
        .reset(reset)
    );

    EXPANSION_BOX u_exp_box (
        .in(reg_out[3:0]),
        .out(exp_out)
    );

    XOR_8BIT u_xor_8 (
        .xout_8(xor_out),
        .xin1_8(exp_out),
        .xin2_8(key)
    );

    CSA_4BIT u_csa (
        .cin(xor_out[3]),
        .inA(xor_out[3:0]),
        .inB(key[3:0]),
        .cout(),
        .out(csa_out)
    );

    CONCAT u_concat (
        .concat_out(concat_out),
        .concat_in1(csa_out),
        .concat_in2(key)
    );

    always @(posedge clock or posedge reset) begin
        if (reset)
            enc_number <= 8'b0;
        else
            enc_number <= concat_out;
    end

endmodule


module tb_ENCRYPT;
    reg clock, reset;
    reg [7:0] number, key;
    wire [7:0] enc_number;

    ENCRYPT u_encrypt (
        .number(number),
        .key(key),
        .clock(clock),
        .reset(reset),
        .enc_number(enc_number)
    );

    initial begin
        clock = 0;
        reset = 1;
        number = 8'b01000110;
        key = 8'b10010011;

        #10 reset = 0;
        #10 clock = 1;

        // Test the circuit for the specified combinations
        #10 number = 8'b11001001; key = 8'b10101100;
        #10 number = 8'b10100101; key = 8'b01011010;
        #10 number = 8'b11110000; key = 8'b10110001;

        #50 $finish;
    end

    always #5 clock = ~clock;

endmodule
