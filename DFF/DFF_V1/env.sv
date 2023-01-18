class dff_env extends uvm_env;
    `uvm_component_utils(dff_env)

    dff_agent agnt;
    dff_scoreboard scb;
    dff_config cfg;

    function new(string name="dff_env", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agnt=dff_agent::type_id::create("agnt", this);
        scb=dff_scoreboard::type_id::create("scb", this);
        cfg = dff_config::type_id::create("cfg");
        uvm_config_db #(dff_config)::set(this, "agnt", "cfg", cfg); // set the access of config class to agent
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agnt.mon.monitor_port.connect(scb.scoreboard_port);
    endfunction: connect_phase

endclass: dff_env
