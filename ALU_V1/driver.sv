class alu_driver extends uvm_driver #(alu_sequence_item);
  `uvm_component_utils(alu_driver)
	virtual alu_interface vif;
  
  
  alu_sequence_item item;
  
  
  function new(string name="alu_driver", uvm_component parent=null);
    super.new(name, parent);
    `uvm_info("DRIVER CLASS", "Inside constructor", UVM_HIGH);
  endfunction

  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("DRIVER CLASS", "Inside build phase", UVM_HIGH);
    
    if(!(uvm_config_db #(virtual alu_interface)::get(null, "*", "vif", vif))) begin
      `uvm_error("DRIVER CLASS", "failed to get alu_interface handle");
    end
  
  endfunction:build_phase

  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("DRIVER CLASS", "Inside connect phase", UVM_HIGH);
  endfunction:connect_phase

  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    `uvm_info("DRIVER CLASS", "Run Phase", UVM_HIGH);
    
    // keep driving the transactions forever
    forever begin
      	item = alu_sequence_item::type_id::create("item");
      seq_item_port.get_next_item(item);
      drive(item);
      seq_item_port.item_done();
    end
    
  endtask:run_phase
  
  
  
  task drive(alu_sequence_item item);
    @(posedge vif.clock);
      // Nonblocking assignments in the driver help avoid race conditions in the underlying DUT.
      // They allow the driver to change signal values "just after the clock" such as
    	// This allows the driver to interact with the DUT as if it were a "normal" SystemVerilog module.
      
      vif.reset <= item.reset;
    	vif.a <= item.a;
	    vif.b <= item.b;	
    	vif.opcode <= item.opcode;
  endtask: drive
  
  
endclass: alu_driver