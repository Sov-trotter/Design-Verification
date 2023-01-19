class clk_env extends uvm_env;
    `uvm_component_utils(clk_env)

    clk_agent agnt;
    clk_scoreboard scb;
    
    function new(string name="clk_env", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agnt=clk_agent::type_id::create("agnt", this);
        scb=clk_scoreboard::type_id::create("scb", this);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agnt.mon.monitor_port.connect(scb.scoreboard_port);
    endfunction: connect_phase

endclass: clk_env
