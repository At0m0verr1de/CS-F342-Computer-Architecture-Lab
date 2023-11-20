module MUX_2x1 (
    input wire a,
    input wire b,
    input wire sel,
    output wire y
);
    assign y = (sel == 1'b0) ? a : b;
endmodule


module MUX_8x1 (
    input wire [7:0] data,
    input wire [2:0] sel,
    output wire y
);
    assign y = data[sel];
endmodule


module MUX_ARRAY (
    input wire [7:0] in_data [0:7],
    input wire [2:0] sel,
    output wire out_data
);
    generate
        genvar i;
        for (i = 0; i < 8; i = i + 1) begin : MUX_GEN
            MUX_2x1 u_mux (
                .a(in_data[i]),
                .b(out_data),
                .sel(sel == i),
                .y(out_data)
            );
        end
    endgenerate
endmodule


module COUNTER_3BIT (
    input wire clk,
    input wire clear,
    output wire [2:0] count
);
    reg [2:0] count_reg;

    always_ff @(posedge clk or posedge clear) begin
        if (clear)
            count_reg <= 3'b000;
        else
            count_reg <= count_reg + 1;
    end

    assign count = count_reg;
endmodule


module DECODER (
    input wire [2:0] in,
    output wire [7:0] out
);
    assign out = (in == 3'b000) ? 8'b00000001 :
                (in == 3'b001) ? 8'b00000011 :
                (in == 3'b010) ? 8'b00000111 :
                (in == 3'b011) ? 8'b00001111 :
                (in == 3'b100) ? 8'b00011111 :
                (in == 3'b101) ? 8'b00111111 :
                (in == 3'b110) ? 8'b01111111 :
                (in == 3'b111) ? 8'b11111111 :
                8'b00000000;
endmodule


module MEMORY (
    input wire [2:0] address,
    output wire [7:0] data
);
    reg [7:0] mem [0:7];

    initial begin
        mem[0] = 8'b00000001;
        mem[1] = 8'b00000011;
        mem[2] = 8'b00000111;
        mem[3] = 8'b00001111;
        mem[4] = 8'b00011111;
        mem[5] = 8'b00111111;
        mem[6] = 8'b01111111;
        mem[7] = 8'b11111111;
    end

    assign data = mem[address];
endmodule


module TOP_MODULE (
    input wire clk,
    output wire [7:0] out_data
);
    reg [2:0] counter_out;
    reg [2:0] mux_sel;
    reg [2:0] decoder_in;
    wire [7:0] mux_array_out;
    wire [7:0] memory_out;

    COUNTER_3BIT u_counter (
        .clk(clk),
        .clear(1'b0),
        .count(counter_out)
    );

    MUX_8x1 u_mux8 (
        .data({8'b00000001, 8'b00000011, 8'b00000111, 8'b00001111, 8'b00011111, 8'b00111111, 8'b01111111, 8'b11111111}),
        .sel(counter_out),
        .y(mux_array_out)
    );

    MUX_ARRAY u_mux_array (
        .in_data({8'b00000001, 8'b00000011, 8'b00000111, 8'b00001111, 8'b00011111, 8'b00111111, 8'b01111111, 8'b11111111}),
        .sel(mux_sel),
        .out_data(out_data)
    );

    DECODER u_decoder (
        .in(decoder_in),
        .out(mux_sel)
    );

    MEMORY u_memory (
        .address(counter_out),
        .data(memory_out)
    );

    always_ff @(posedge clk) begin
        decoder_in <= counter_out;
    end

    assign out_data = mux_array_out | memory_out;

endmodule

module tb_TOP_MODULE;
    reg clk;
    wire [7:0] out_data;

    TOP_MODULE uut (
        .clk(clk),
        .out_data(out_data)
    );

    initial begin
        clk = 0;
        #5;

        // Clear counter
        uut.u_counter.clear = 1;
        #5 uut.u_counter.clear = 0;

        // Apply clock of 1 KHz
        repeat (1000) begin
            #1 clk = ~clk;
        end

        // Increment the value of counter every 8 msec
        repeat (125) begin
            #8;
            uut.u_counter.count = uut.u_counter.count + 1;
        end

        #10 $finish;
    end

    always #1 clk = ~clk;

endmodule
