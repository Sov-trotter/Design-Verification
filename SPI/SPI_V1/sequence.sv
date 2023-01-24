class write_data extends uvm_sequence #(spi_transaction); 
    `uvm_object_utils(write_data)

    spi_transaction trans;

    function new(string name = "write_data");
        super.new(name);
    endfunction: new

    task body();
        repeat(15) begin
            trans = spi_transaction::type_id::create("trans");
            trans.addr_c.constraint_mode(1); // enable the first contraint
            trans.addr_c_err.constraint_mode(0); // disable the second contraint
            
            start_item(trans); //send request to sequencer that we have new data
            assert(trans.randomize());
            trans.oper = writed;
            finish_item(trans);
        end
    endtask:body
endclass: write_data

class read_data extends uvm_sequence #(spi_transaction); 
    `uvm_object_utils(read_data)

    spi_transaction trans;

    function new(string name = "read_data");
        super.new(name);
    endfunction: new

    task body();
        repeat(15) begin
            trans = spi_transaction::type_id::create("trans");
            trans.addr_c.constraint_mode(1); // enable the first contraint
            trans.addr_c_err.constraint_mode(0); // disable the second contraint
            
            start_item(trans); //send request to sequencer that we have new data
            assert(trans.randomize());
            trans.oper = readd;
            finish_item(trans);
        end
    endtask:body
endclass: read_data

class read_err extends uvm_sequence #(spi_transaction);
    `uvm_object_utils(read_err)

    spi_transaction trans;

    function new(string name = "read_err");
        super.new(name);
    endfunction: new

    task body();
        repeat(15) begin
            trans = spi_transaction::type_id::create("trans");
            trans.addr_c.constraint_mode(0); // disable the first contraint
            trans.addr_c_err.constraint_mode(1); // enable the second contraint
            
            start_item(trans); //send request to sequencer that we have new data
            assert(trans.randomize());
            trans.oper = readd;
            finish_item(trans);
        end
    endtask:body
endclass: read_err

class write_err extends uvm_sequence #(spi_transaction);
    `uvm_object_utils(write_err)

    spi_transaction trans;

    function new(string name = "write_err");
        super.new(name);
    endfunction: new

    task body();
        repeat(15) begin
            trans = spi_transaction::type_id::create("trans");
            trans.addr_c.constraint_mode(0); // disable the first contraint
            trans.addr_c_err.constraint_mode(1); // enable the second contraint
            
            start_item(trans); //send request to sequencer that we have new data
            assert(trans.randomize());
            trans.oper = writeerr;
            finish_item(trans);
        end
    endtask:body
endclass: write_err

class reset_dut extends uvm_sequence #(spi_transaction);
    `uvm_object_utils(reset_dut)

    spi_transaction trans;

    function new(string name = "reset_dut");
        super.new(name);
    endfunction: new

    task body();
        repeat(15) begin
            trans = spi_transaction::type_id::create("trans");
            trans.addr_c.constraint_mode(1); // disable the first contraint
            trans.addr_c_err.constraint_mode(0); // enable the second contraint
            
            start_item(trans); //send request to sequencer that we have new data
            assert(trans.randomize());
            trans.oper = rstdut;
            finish_item(trans);
        end
    endtask:body
endclass: reset_dut

class write_read_data extends uvm_sequence #(spi_transaction);
    `uvm_object_utils(write_read_data)

    spi_transaction trans;

    function new(string name = "write_read_data");
        super.new(name);
    endfunction: new

    task body();
        repeat(15) begin
            trans = spi_transaction::type_id::create("trans");
            trans.addr_c.constraint_mode(1); // disable the first contraint
            trans.addr_c_err.constraint_mode(0); // enable the second contraint
            
            start_item(trans); //send request to sequencer that we have new data
            assert(trans.randomize());
            trans.oper = writed;
            finish_item(trans);
        end

        repeat(15) begin
            trans = spi_transaction::type_id::create("trans");
            trans.addr_c.constraint_mode(1); // disable the first contraint
            trans.addr_c_err.constraint_mode(0); // enable the second contraint
            
            start_item(trans); //send request to sequencer that we have new data
            assert(trans.randomize());
            trans.oper = readd;
            finish_item(trans);
        end
    endtask:body
endclass: write_read_data
