// agent connects sequencer and driver
class mul_agent extends uvm_agent;
  `uvm_component_utils(mul_agent)

    function new(string name="mul_agent", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    mul_driver drv;
    mul_monitor mon;
    uvm_sequencer #(mul_transaction) seqr; // we use the default uvm sequencer


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv = mul_driver::type_id::create("drv", this);
        mon = mul_monitor::type_id::create("mon", this);
        seqr = uvm_sequencer #(mul_transaction) ::type_id::create("seqr", this);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction:connect_phase
endclass:mul_agent