`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2019 08:40:32 AM
// Design Name: 
// Module Name: sigmul_10
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module claN(a, b, cin, s, cout);
  parameter N = 4;
  input [N-1:0] a, b;
  input cin;
  output [N-1:0] s;
  output cout;
  
  wire [N-1:1] c;
  wire [N-1:0] p, g;
  
  assign p = a ^ b; // This column will propagate a carry
  assign g = a & b; // This column will generate a carry
  
  assign {cout, c} = g | (p & {c, cin});
  assign s = p ^ {c, cin};
endmodule

module a11x2(a, b, s);
  input [10:0] a;
  input [11:1] b;
  output [12:0] s;
  
  wire [1:0] c;
  
  assign s[0] = a[0];
  
  claN S0(a[4:1], b[4:1], 1'b0, s[4:1], c[0]);
  claN S4(a[8:5], b[8:5], c[0], s[8:5], c[1]);
  claN #(3) S8({1'b0, a[10:9]}, b[11:9], c[1], s[11:9], s[12]);
endmodule

module hadder(a, b, s, c);
  input a, b;
  output s, c;
  
  assign s = a ^ b;
  assign c = a & b;
endmodule
 
module a11x4(input [12:0] a,
             input [14:2] b,
             output [14:0] s);
  wire [3:0] c;
  
  assign s[1:0] = a[1:0];
  
  claN i2345(a[5:2], b[5:2], 1'b0, s[5:2], c[0]);
  claN i6789(a[9:6], b[9:6], c[0], s[9:6], c[1]);
  claN iABCD({1'b0, a[12:10]}, b[13:10], c[1], s[13:10], c[2]);
  
  hadder ie(b[14], c[2], s[14], c[3]);
endmodule

module a11x8(input [14:0] a,
             input [18:4] b,
             output [18:0] s);
  wire [3:0] c;
  
  assign s[3:0] = a[3:0];
  
  claN i4567(a[7:4], b[7:4], 1'b0, s[7:4], c[0]);
  claN i89AB(a[11:8], b[11:8], c[0], s[11:8], c[1]);
  claN iCDEF({1'b0, a[14:12]}, b[15:12], c[1], s[15:12], c[2]);
  claN #(3) iGHIJ(3'b000, b[18:16], c[2], s[18:16], c[3]); 
endmodule

module a11x3(input [20:8] a,
             input [20:10] b,
             output [21:8] s);

  wire [1:0] c;
  
  assign s[9:8] = a[9:8];

  claN i2345(a[13:10], b[13:10], 1'b0, s[13:10], c[0]);
  claN i6789(a[17:14], b[17:14], c[0], s[17:14], c[1]);
  claN #(3) iABC(a[20:18], b[20:18], c[1], s[20:18], s[21]);
endmodule

module a11x11(input [18:0] a,
              input [21:8] b,
              output [21:0] s);

  wire [4:0] c;
  assign c[0] = 1'b0;
  
  assign s[7:0] = a[7:0];
  claN i89AB(a[11:8], b[11:8], c[0], s[11:8], c[1]);
  claN iCDEF(a[15:12], b[15:12], c[1], s[15:12], c[2]);
  claN iGHIJ({1'b0, a[18:16]}, b[19:16], c[2], s[19:16], c[3]);
  claN #(2) iKL(2'b00, b[21:20], c[3], s[21:20], c[4]);
endmodule

module sigmul_10(a, b, p);
  input [10:0] a, b;
  output [21:0] p;
  
  wire [10:0] pp[9:0];
  wire [12:0] s0[4:0]; // 11 X 2
  wire [14:0] s1[1:0]; // 11 X 4
  wire [18:0] s2;      // 11 X 8
  wire [21:8] s3;      // 11 X 3
  
  genvar i;
  generate
    for (i = 0; i < 10; i = i + 1)
      begin
        assign pp[i] = a & {11{b[i]}};
        
        if (i < 5)
        begin
          a11x2 Si(pp[2*i], pp[2*i+1], s0[i]);
          
          if (i < 2)
            a11x4 Ti(s0[2*i], s0[2*i+1], s1[i]);
        end
      end
  endgenerate
  
  a11x8 U0(s1[0], s1[1], s2);
    
  a11x3 V0(s0[4], a, s3);
  
  a11x11 W0(s2, s3, p);
endmodule
