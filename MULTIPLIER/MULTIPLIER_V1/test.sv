class mul_test extends uvm_test;
    `uvm_component_utils(mul_test)

    function new(string name = "mul_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    mul_env env;
    mul_sequence seq;

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env=mul_env::type_id::create("env", this); // this because env is a uvm_component
        seq = mul_sequence::type_id::create("seq");
    endfunction: build_phase

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        seq.start(env.agnt.seqr);
        #20;
        phase.drop_objection(this);
    endtask: run_phase
endclass: mul_test