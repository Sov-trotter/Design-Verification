// agent connects sequencer and driver
class dff_agent extends uvm_agent;
  `uvm_component_utils(dff_agent)

    function new(string name="dff_agent", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    dff_driver drv;
    dff_monitor mon;
    uvm_sequencer #(dff_transaction) seqr; // we use the default uvm sequencer

    dff_config cfg;

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon = dff_monitor::type_id::create("mon", this);
        
        cfg = dff_config::type_id::create("cfg");

        /* we are using config db to access the value of variable in the config
         if the variable is not changing its value we could just use dot operator and access the value
         But incase we have requirement to change the type of agent, eg env classs could change the type of 
         argument in a go */ 

        if(!(uvm_config_db #(dff_config)::get(this, "", "cfg", cfg))) 
        begin
            `uvm_error("AGENT", "FAILED TO ACCESS CONFIG");
        end

        if(cfg.agent_type == UVM_ACTIVE) 
        begin
            drv = dff_driver::type_id::create("drv", this);
            seqr = uvm_sequencer #(dff_transaction) ::type_id::create("seqr", this);
        end
    endfunction: build_phase    

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction:connect_phase
endclass:dff_agent