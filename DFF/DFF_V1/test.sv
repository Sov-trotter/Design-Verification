class dff_test extends uvm_test;
    `uvm_component_utils(dff_test)

    function new(string name = "dff_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    dff_env env;
    valid_din vdin;
    rst_dff rdff;
    rand_din_rst rdin;

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env=dff_env::type_id::create("env", this); // this because env is a uvm_component
        vdin = valid_din::type_id::create("vdin");
        rdff = rst_dff::type_id::create("rdff");
        rdin = rand_din_rst::type_id::create("rdin");
    endfunction: build_phase

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        rdff.start(env.agnt.seqr);
        #40;
        vdin.start(env.agnt.seqr);
        #40;
        rdin.start(env.agnt.seqr);
        #40;
        phase.drop_objection(this);
    endtask: run_phase
endclass: dff_test