// DO NOT CHANGE THE INPUT/OUTPUT NAMES, OTHERWISE WE CAN'T GRADE YOUR SUBMISSION

module CLA_15bit_tb ();

  reg  [14:0] A, B; // Inputs
  reg         mode; // mode (add or subtract)
  wire [14:0] S   ; // result
  wire        Ovf ; // Outputs are wires.
  wire        Cout;

  CLA_15bit_top dut (A,B,mode,S,Cout,Ovf);// Our design-under-test.

  initial begin
    //  * Our waveform is saved under this file.

    $dumpfile("CLA_15bit_top.vcd");

    // * Get the variables from the module.

    $dumpvars(0,CLA_15bit_tb);

    $display("Simulation started.");

    // * Testbench goes here.
    // Addition without carry and without an overflow.
    A = 15'd25;
    B = 15'd50;
    mode = 1'd0; // For addition.
    #10;     // Wait 10 time units.
    // Addition without carry and with an overflow.
    A = 15'd16000;
    B = 15'd1000;
    mode = 1'd0; // For addition.
    #10;     // Wait 10 time units.
    // Addition with carry and without an overflow.
    A = 15'd16000;
    B = -15'd7999;
    mode = 1'd0; // For addition.
    #10;     // Wait 10 time units.
    // Addition with carry and with an overflow.
    A = -15'd10000;
    B = -15'd8000;
    mode = 1'd0; // For addition.
    #10;     // Wait 10 time units.
    // Subtraction without carry and without an overflow.
    A = 15'd30;
    B = 15'd100;
    mode = 1'd1; // For subtraction
    #10;     // Wait 10 time units.
    // Subtraction without carry and with an overflow.
    A = 15'd1;
    B = 15'd16384;
    mode = 1'd1; // For subraction
    #10;     // Wait 10 time units.
    // Subtraction with carry and without an overflow.
    A = -15'd8000;
    B = -15'd12000;
    mode = 1'd1; // For subraction
    #10;     // Wait 10 time units.
    // Subtraction with carry and with an overflow.
    A = 15'd16384;
    B = 15'd2;
    mode = 1'd1; // For subraction
    #10;     // Wait 10 time units.
    

   
    
    

    $display("Simulation finished.");
    $finish(); // Finish simulation.
  end

endmodule