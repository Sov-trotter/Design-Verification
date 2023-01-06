// object class
class alu_sequence_item extends uvm_sequence;
  `uvm_object_utils(alu_sequence_item)
  

  
  // define thesignales we will use
  rand logic reset;
  
  rand logic [7:0] a, b;
  logic [7:0] result;
  rand logic [3:0] opcode;
  bit carryout;
  
  
  constraint input1_c {a inside {[10:20]};}
  constraint input2_c {b inside {[1:10]};}
  constraint opcode_c {opcode inside {0,1,2,3};}

  
  
  
  
  function new(string name="alu_sequence_item");
  	super.new(name);
  endfunction: new

  
endclass:alu_sequence_item