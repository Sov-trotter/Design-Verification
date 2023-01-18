class mul_env extends uvm_env;
    `uvm_component_utils(mul_env)

    mul_agent agnt;
    mul_scoreboard scb;

    function new(string name="mul_env", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agnt=mul_agent::type_id::create("agnt", this);
        scb=mul_scoreboard::type_id::create("scb", this);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agnt.mon.monitor_port.connect(scb.scoreboard_port);
    endfunction: connect_phase

endclass: mul_env
