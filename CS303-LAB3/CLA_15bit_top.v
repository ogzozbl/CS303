// DO NOT CHANGE THE INPUT/OUTPUT NAMES, OTHERWISE WE CAN'T GRADE YOUR SUBMISSION

module CLA_15bit_top (
  input  [14:0] A   ,
  input  [14:0] B   ,
  input         mode, // 0 --> addition , 1 --> subtraction
  output [14:0] S   ,
  output        Cout,
  output        OVF
);

  /* Your design goes here */
wire [4:0] p; // carry wires
assign p[0] = mode;

CLA_3bit CLA_0 (
  .C(A[2:0]),
  .D(B[2:0]),
  .Cin(p[0]), 
  .mode(mode), 
  .RES(S[2:0]), 
  .Carry(p[1])
  );
CLA_3bit CLA_1 (
  .C(A[5:3]), 
  .D(B[5:3]), 
  .Cin(p[1]), 
  .mode(mode), 
  .RES(S[5:3]), 
  .Carry(p[2])
  );
CLA_3bit CLA_2 (
  .C(A[8:6]), 
  .D(B[8:6]), 
  .Cin(p[2]), 
  .mode(mode), 
  .RES(S[8:6]), 
  .Carry(p[3])
  );
CLA_3bit CLA_3 (
  .C(A[11:9]), 
  .D(B[11:9]), 
  .Cin(p[3]), 
  .mode(mode), 
  .RES(S[11:9]), 
  .Carry(p[4])
  );
CLA_3bit CLA_4 (
  .C(A[14:12]), 
  .D(B[14:12]), 
  .Cin(p[4]), 
  .mode(mode), 
  .RES(S[14:12]), 
  .Carry(Cout)
  );

  assign OVF = ((~mode) & ((~A[14] & ~B[14] & S[14]) | (A[14] & B[14] & (~S[14])))) |  (mode & (((~A[14]) & B[14] & S[14]) | (A[14] & (~B[14]) & (~S[14]))));

endmodule 