class clk_test extends uvm_test;
    `uvm_component_utils(clk_test)

    function new(string name = "clk_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    clk_env env;
    variable_baud vbaud;
    rst_clk rclk;

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env=clk_env::type_id::create("env", this); // this because env is a uvm_component
        vbaud = variable_baud::type_id::create("vbaud");
        rclk = rst_clk::type_id::create("rclk");
    endfunction: build_phase

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        vbaud.start(env.agnt.seqr);
        #20;
        phase.drop_objection(this);
    endtask: run_phase
endclass: clk_test