interface alu_interface(input logic clock);

  logic reset;
  
  logic [7:0] a, b;
  logic [3:0] opcode;
  logic [7:0] result;

  bit carryout;
  
endinterface: alu_interface