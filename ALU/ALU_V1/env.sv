class alu_env extends uvm_env;
  `uvm_component_utils(alu_env)
  
      alu_agent agnt;
  	  alu_scoreboard scb;

  function new(string name="alu_env", uvm_component parent=null);
    super.new(name, parent);
    `uvm_info("ENV CLASS", "Inside constructor", UVM_HIGH);
  endfunction

  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("ENV CLASS", "Inside build phase", UVM_HIGH);
    agnt=alu_agent::type_id::create("agnt", this);
    scb=alu_scoreboard::type_id::create("scb", this);
    
  endfunction:build_phase

  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("ENV CLASS", "Inside connect phase", UVM_HIGH);
    
    agnt.mon.monitor_port.connect(scb.scoreboard_port);
    
  endfunction:connect_phase

  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
  endtask:run_phase
  
  
  
endclass: alu_env