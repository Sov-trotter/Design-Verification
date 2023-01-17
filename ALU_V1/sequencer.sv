class alu_sequencer extends uvm_sequencer #(alu_sequence_item);
  `uvm_component_utils(alu_sequencer)
  
  function new(string name="alu_sequencer", uvm_component parent=null);
    super.new(name, parent);
    `uvm_info("SEQUENCER CLASS", "Inside constructor", UVM_HIGH);
  endfunction

  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("SEQUENCER CLASS", "Inside build phase", UVM_HIGH);
  endfunction:build_phase

  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("SEQUENCER CLASS", "Inside connect phase", UVM_HIGH);
  endfunction:connect_phase

// we dont need the run phase in sequencer
//   task run_phase(uvm_phase phase);
//     super.run_phase(phase);
    
//   endtask:run_phase
  
  
  
endclass: alu_sequencer