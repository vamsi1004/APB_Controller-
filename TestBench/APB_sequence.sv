`include "defines.svh"

class apb_sequence1 extends uvm_sequence #(apb_seq_item);
   rand bit [`addr_width-1 : 0] trial_addr;
  `uvm_object_utils(apb_sequence1)
  
  function new(string name = "seq1");
    super.new(name);
  endfunction 
  
  virtual task body();
    req = apb_seq_item::type_id::create("req");
    `uvm_rand_send_with(req,{ apb_write_paddr == trial_addr ;read_write == 0; transfer == 1;})
  endtask
endclass

class apb_sequence2 extends uvm_sequence #(apb_seq_item);
   rand bit [`addr_width-1 : 0] trial_addr1;
   
  `uvm_object_utils(apb_sequence2)
  
  function new(string name = "seq2");
    super.new(name);
  endfunction 
  
  virtual task body();
    req = apb_seq_item::type_id::create("req");
    `uvm_rand_send_with(req,{apb_read_paddr == trial_addr1 ;read_write == 1; transfer == 1;})
  endtask
endclass

class apb_sequence3 extends uvm_sequence #(apb_seq_item);
  rand bit [`addr_width-1 : 0] trial_addr3;
  `uvm_object_utils(apb_sequence3)
  
  function new(string name = "seq1");
    super.new(name);
  endfunction 
  
  virtual task body();
    req = apb_seq_item::type_id::create("req");
    `uvm_rand_send_with(req,{apb_write_paddr == trial_addr3; read_write == 0; transfer == 0;})
  endtask
endclass

class apb_sequence4 extends uvm_sequence #(apb_seq_item);
  rand bit [`addr_width-1 : 0] trial_addr4;
   
  `uvm_object_utils(apb_sequence4)
  
  function new(string name = "seq2");
    super.new(name);
  endfunction 
  
  virtual task body();
    req = apb_seq_item::type_id::create("req");
    `uvm_rand_send_with(req,{ apb_read_paddr == trial_addr4 ;read_write == 1; transfer == 0;})
  endtask
endclass

class virtual_sequence extends uvm_sequence #(apb_seq_item);
  rand bit [`addr_width-1 : 0] addr3;
  
  `uvm_object_utils(virtual_sequence)
  
  apb_sequence1 seq1;
  apb_sequence2 seq2;
  apb_sequence3 seq3;
  apb_sequence4 seq4;
  
    
  apb_sequencer seqr;
  
  function new(string name = "");
    super.new(name);
  endfunction
  
  
  virtual task body();
    seq1 = apb_sequence1::type_id::create("seq1");
    seq2 = apb_sequence2::type_id::create("seq2");
    seq3 = apb_sequence3::type_id::create("seq3");
    seq4 = apb_sequence4::type_id::create("seq4");
   `uvm_do_on_with(seq1,seqr,{trial_addr == addr3;})
   `uvm_do_on_with(seq2,seqr,{trial_addr1 == addr3;})
    `uvm_do_on_with(seq3,seqr,{trial_addr3 == addr3;})
    `uvm_do_on_with(seq4,seqr,{trial_addr4 == addr3;})

  endtask
  
endclass
