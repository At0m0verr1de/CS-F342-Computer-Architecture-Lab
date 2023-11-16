// Gate Level Modelling
// Can build the logic for output using K-Map
module mux2to1_gate (a,b,s,f); // notice the semi colon here
    input a,b,s;
    output f; 
    wire c,d,e;

    not n1(e,s); // e=~s and a1(c,a,s);
    and a2(d,b,e);
    or o1(f,c,d);
endmodule


// Dataflow Modelling
module mux2to1_df (a,b,s,f); 
    input a,b,s;
    output f;

    // assign f = (s & a) | (~s & b);
    assign f = s ? a : b;
endmodule


// Behavioural Modelling
module mux2to1_beh(a, b, s, f);
    input a, b, s;
    output f;

    reg f;

    always@ (s or a or b)
        if (s==1) f = a;
        else f = b;

endmodule



// module testbench; 
//     reg a,b,s;
//     wire f;
//     // mux2to1_gate mux_gate (a,b,s,f); 
//     // mux2to1_df mux_df (a,b,s,f);
//     mux2to1_beh mux_beh (a,b,s,f);
    
//     initial 
//         begin
//             // monitor displays the output in the simulation for each time stamp mentioned
//             $monitor(,$time," a=%b, b=%b, s=%b f=%b",a,b,s,f); 
//             #0 a=1'b0; b=1'b1;
//             #2 s=1'b1;
//             #5 s=1'b0;
//             #10 a=1'b1; b=1'b0;
//             #15 s=1'b1;
//             #20 s=1'b0;
//             #100 $finish;
//         end 
// endmodule
