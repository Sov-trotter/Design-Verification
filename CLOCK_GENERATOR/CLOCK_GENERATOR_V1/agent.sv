// agent connects sequencer and driver
class clk_agent extends uvm_agent;
  `uvm_component_utils(clk_agent)

    function new(string name="clk_agent", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    clk_driver drv;
    clk_monitor mon;
    uvm_sequencer #(clk_transaction) seqr; // we use the default uvm sequencer

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon = clk_monitor::type_id::create("mon", this);
        drv = clk_driver::type_id::create("drv", this);
        seqr = uvm_sequencer #(clk_transaction) ::type_id::create("seqr", this);
    endfunction: build_phase    

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction:connect_phase
endclass:clk_agent