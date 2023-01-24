class spi_test extends uvm_test;
    `uvm_component_utils(spi_test)

    function new(string name = "spi_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    spi_env env;
    
    write_data wdata;
    read_data rdata;

    write_err werr;
    read_err rerr;

    write_read_data wrd;

    reset_dut rstdut;

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        env=spi_env::type_id::create("env", this); // this because env is a uvm_component
        
        wdata = write_data::type_id::create("wdata");
        rdata = read_data::type_id::create("rdata");
        werr = write_err::type_id::create("werr");
        rerr = read_err::type_id::create("rerr");
        wrd = write_read_data::type_id::create("wrd");
        rstdut = reset_dut::type_id::create("rstdut"); 
    endfunction: build_phase

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
 
        wdata.start(env.agnt.seqr);
        // rdata.start(env.agnt.seqr);
        // werr.start(env.agnt.seqr);
        // rerr.start(env.agnt.seqr);
        // wrd.start(env.agnt.seqr);
        // rstdut.start(env.agnt.seqr);
        
        // drain time- allows last sequence's data to propagate through dut and out
        // before dropping the objection
        #100; 
        
        phase.drop_objection(this);
    endtask: run_phase
endclass: spi_test