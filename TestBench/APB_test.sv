class apb_test extends uvm_test;
  
  `uvm_component_utils(apb_test)
  
  apb_environment env;
  virtual_sequence v_seq;
  
  function new(string name = "", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = apb_environment::type_id::create("env",this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
      phase.raise_objection(this);
      v_seq = virtual_sequence::type_id::create("seq");
      v_seq.seqr = env.agt.seqr;
    repeat(50)begin
     v_seq.randomize();
     v_seq.start(null);
//       `uvm_do_with(v_seq,{})
    end
      phase.drop_objection(this);
  endtask
endclass
