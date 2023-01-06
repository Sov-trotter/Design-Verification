class alu_test extends uvm_test;
  
  `uvm_component_utils(alu_test)
  
  alu_env env;
  
  alu_base_sequence reset_seq;
  alu_test_sequence test_seq;
  
  function new(string name = "alu_test", uvm_component parent);
    super.new(name, parent);
    `uvm_info("TEST_CLASS", "Inside constructor", UVM_HIGH);	
  endfunction
  
  // run phase includes statements that take longer time to run
  // so it is declared as a task unlike build phase and connect phase
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TEST_CLASS", "BUILD PHASE", UVM_HIGH);	
    env=alu_env::type_id::create("env", this);
  endfunction: build_phase
  
  
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("TEST_CLASS", "Connect PHASE", UVM_HIGH);	
    
    // connect monitor with scoreboard
    
  endfunction: connect_phase
  
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    
    //logic
    `uvm_info("TEST_CLASS", "RUN PHASE", UVM_HIGH);	
    
    phase.raise_objection(this);
    
    // sequences come here
    reset_seq=alu_base_sequence::type_id::create("reset_seq");
    reset_seq.start(env.agnt.seqr); //start the seq on a sequencer
    
    test_seq=alu_test_sequence::type_id::create("test_seq");
    test_seq.start(env.agnt.seqr); //start the seq on a sequencer
    
    
    
    phase.drop_objection(this);
    
  endtask: run_phase
  
  
endclass: alu_test