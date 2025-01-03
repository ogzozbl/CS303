// DO NOT CHANGE THE INPUT/OUTPUT NAMES, OTHERWISE WE CAN'T GRADE YOUR SUBMISSION

module CLA_3bit (
    input  [2:0] C    ,
    input  [2:0] D    ,
    input        Cin  ,
    input        mode , // 0 --> addition , 1 --> subtraction
    output [2:0] RES  ,
    output       Carry
  );
  /* Your design goes here */
  wire [2:0] p;
  wire [2:0] g;
  wire [2:0] c;
  wire [2:0] variable_mode;

  assign variable_mode[0] = D[0] ^ mode;
  assign variable_mode[1] = D[1] ^ mode;
  assign variable_mode[2] = D[2] ^ mode;

  assign p[0] = C[0] ^ variable_mode[0];
  assign p[1] = C[1] ^ variable_mode[1];
  assign p[2] = C[2] ^ variable_mode[2];

  assign g[0] = C[0] & variable_mode[0];
  assign g[1] = C[1] & variable_mode[1];
  assign g[2] = C[2] & variable_mode[2];

  assign c[0] = (g[0] | ((p[0] & Cin)));
  assign c[1] = (g[1] | (p[1] & g[0]) | (p[1] & p[0] & Cin));
  assign c[2] = (g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & Cin));

  assign Carry = c[2];
  assign RES[0] = p[0] ^ Cin;
  assign RES[1] = p[1] ^ c[0];
  assign RES[2] = p[2] ^ c[1];

endmodule
