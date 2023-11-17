// S(x, y, z) = (1,2,4,7) 
// C(x, y, z) = (3,5,6,7)         

module DECODER(d0,d1,d2,d3,d4,d5,d6,d7,x,y,z); 
    input x,y,z; 
    output d0,d1,d2,d3,d4,d5,d6,d7; 
    wire x0,y0,z0; 
    not n1(x0,x); 
    not n2(y0,y); 
    not n3(z0,z); 
    and a0(d0,x0,y0,z0); 
    and a1(d1,x0,y0,z); 
    and a2(d2,x0,y,z0); 
    and a3(d3,x0,y,z); 
    and a4(d4,x,y0,z0); 
    and a5(d5,x,y0,z); 
    and a6(d6,x,y,z0); 
    and a7(d7,x,y,z);  
endmodule  

module FADDER(c,s,x,y,z); 
    input x,y,z; 
    wire d0,d1,d2,d3,d4,d5,d6,d7; 
    output s,c; 
    DECODER dec(d0,d1,d2,d3,d4,d5,d6,d7,x,y,z); 
    assign s = d1 | d2 | d4 | d7, 
            c = d3 | d5 | d6 | d7;  
endmodule

module EightBitAdder(carryout, sumout, num1, num2);
    input [7:0] num1;
    input [7:0] num2;
    output carryout;
    output [7:0] sumout;
    wire [6:0] w;

    FADDER f0(w[0], sumout[0], num1[0], num2[0], 0);
    FADDER f1(w[1], sumout[1], num1[1], num2[1], w[0]);
    FADDER f2(w[2], sumout[2], num1[2], num2[2], w[1]);
    FADDER f3(w[3], sumout[3], num1[3], num2[3], w[2]);
    FADDER f4(w[4], sumout[4], num1[4], num2[4], w[3]);
    FADDER f5(w[5], sumout[5], num1[5], num2[5], w[4]);
    FADDER f6(w[6], sumout[6], num1[6], num2[6], w[5]);
    FADDER f7(carryout, sumout[7], num1[7], num2[7], w[6]);

endmodule


module testbench;
    reg [7:0] num1, num2;
    wire [7:0] s;
    wire c;
    EightBitAdder eba(c,s,num1,num2);
    initial
        $monitor(,$time,"num1: %b%b%b%b%b%b%b%b   num2: %b%b%b%b%b%b%b%b         sum: %b%b%b%b%b%b%b%b       carry: %b", num1[7], num1[6], num1[5], num1[4], num1[3], num1[2], num1[1], num1[0], num2[7], num2[6], num2[5], num2[4], num2[3], num2[2], num2[1], num2[0], s[7], s[6], s[5], s[4], s[3], s[2], s[1], s[0], c);     
    initial        
        begin        
            #0 num1=8'b00000000; num2=8'b00000001;        
            #4 num1=8'b00001000; num2=8'b00000001;
            #4 num1=8'b01110100; num2=8'b11010101;      
            #4 num1=8'b00111111; num2=8'b00111001;      
            #4 num1=8'b11100000; num2=8'b00000001;      
            #4 num1=8'b01111110; num2=8'b00101101;     
            #4 num1=8'b00001110; num2=8'b01111001;       
            #4 num1=8'b00111110; num2=8'b11110001;     
        end
endmodule


// not implementing the 32 bit adder because it basically combining 4, 8 bit adders and its just bitch work