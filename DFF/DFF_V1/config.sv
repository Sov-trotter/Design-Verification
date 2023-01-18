class dff_config extends uvm_object;
  `uvm_object_utils(dff_config)

  uvm_active_passive_enum agent_type = UVM_ACTIVE;

    function new(input string path = "dff_config");
        super.new(path);
    endfunction: new
endclass: dff_config
