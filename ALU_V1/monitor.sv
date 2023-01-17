class alu_monitor extends uvm_monitor;
  `uvm_component_utils(alu_monitor)
  
  virtual alu_interface vif;
  alu_sequence_item item;

  uvm_analysis_port #(alu_sequence_item) monitor_port;
  
  function new(string name="alu_monitor", uvm_component parent=null);
    super.new(name, parent);
    `uvm_info("MONITOR CLASS", "Inside constructor", UVM_HIGH);
  endfunction

  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("MONITOR CLASS", "Inside build phase", UVM_HIGH);
    
    if(!(uvm_config_db #(virtual alu_interface)::get(null, "*", "vif", vif))) begin
      `uvm_error("MONITOR CLASS", "failed to get interface handle");
    end
    
    monitor_port = new("monitor_port", this);
  endfunction:build_phase

  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("MONITOR CLASS", "Inside connect phase", UVM_HIGH);
  endfunction:connect_phase

  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("MONITOR CLASS", "RUn Phase", UVM_HIGH);

    forever begin
      wait(!vif.reset) // keep on waiting until the dut is not in reset mode
      
      // sample inputs
      // general practice to use blocking for mon and non blocking for driver
      // For monitor we use blocking assignments because there is no worry about race conditions,
      // since monitors typically sample values on the clock edge and then just do stuff with them
      @(posedge vif.clock);
      	item.a = vif.a;
      	item.b = vif.b;
        item.opcode = vif.opcode;
      	
      //sample output
      @(posedge vif.clock); // because the output is one clock delayed
      item.result = vif.result;
      
      
      
      // send item to scoreboard
      monitor_port.write(item);
    end
    
    
  endtask:run_phase  
  
endclass: alu_monitor