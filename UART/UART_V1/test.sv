class uart_test extends uvm_test;
    `uvm_component_utils(uart_test)

    function new(string name = "uart_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    uart_env env;
    
    rand_baud rb;
    rand_baud_two_stop rb2s; 

    rand_length rl; 
    rand_length_two_stop rl2s; 

    rand_baud_len5_p rb5p; 
    rand_baud_len6_p rb6p; 
    rand_baud_len7_p rb7p; 
    rand_baud_len8_p rb8p; 
    
    rand_baud_len5_wop rb5wop; 
    rand_baud_len6_wop rb6wop; 
    rand_baud_len7_wop rb7wop; 
    rand_baud_len8_wop rb8wop; 
        
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env=uart_env::type_id::create("env", this); // this because env is a uvm_component
        
        rb = rand_baud::type_id::create("rb");
        rb2s = rand_baud_two_stop::type_id::create("rb2s"); 

        rl = rand_length::type_id::create("rl"); 
        rl2s = rand_length_two_stop::type_id::create("rl2s"); 

        rb5p = rand_baud_len5_p::type_id::create("rb5p"); 
        rb6p = rand_baud_len6_p::type_id::create("rb6p"); 
        rb7p = rand_baud_len7_p::type_id::create("rb7p"); 
        rb8p = rand_baud_len8_p::type_id::create("rb8p"); 
        
        rb5wop = rand_baud_len5_wop::type_id::create("rb5wop"); 
        rb6wop = rand_baud_len6_wop::type_id::create("rb6wop"); 
        rb7wop = rand_baud_len7_wop::type_id::create("rb7wop"); 
        rb8wop = rand_baud_len8_wop::type_id::create("rb8wop"); 
    endfunction: build_phase

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        rb.start(env.agnt.seqr); 
        // rb2s.start(env.agnt.seqr);
        // rl.start(env.agnt.seqr);
        // rl2s.start(env.agnt.seqr);
        // rb5p.start(env.agnt.seqr);
        // rb6p.start(env.agnt.seqr);
        // rb7p.start(env.agnt.seqr);
        // rb8p.start(env.agnt.seqr);
        // rb5wop.start(env.agnt.seqr);
        // rb6wop.start(env.agnt.seqr);
        // rb7wop.start(env.agnt.seqr);
        // rb8wop.start(env.agnt.seqr);
        
        // drain time- allows last sequence's data to propagate through dut and out
        // before dropping the objection
        #40 
        
        phase.drop_objection(this);
    endtask: run_phase
endclass: uart_test