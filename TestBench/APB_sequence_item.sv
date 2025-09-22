`include "defines.svh"
 `include "uvm_macros.svh"
  import uvm_pkg::*;

class apb_seq_item extends uvm_sequence_item;
  
  function new(string name = "seq_item");
    super.new(name);
  endfunction 
  
  rand bit [`addr_width - 1 : 0] apb_write_paddr ;
  rand bit [`addr_width - 1 : 0] apb_read_paddr  ;
  rand bit [`data_width - 1 : 0] apb_write_data ;
  rand bit transfer;
  randc bit read_write;
  bit [`data_width - 1 : 0] apb_read_data_out;
  bit pslverr;
  
  `uvm_object_utils_begin(apb_seq_item)
  `uvm_field_int(read_write,UVM_ALL_ON)
  `uvm_field_int(apb_write_paddr,UVM_ALL_ON)
  `uvm_field_int(apb_read_paddr,UVM_ALL_ON)
  `uvm_field_int(apb_write_data,UVM_ALL_ON)
  `uvm_field_int(transfer,UVM_ALL_ON)
  `uvm_field_int(pslverr,UVM_ALL_ON)
  `uvm_field_int(apb_read_data_out,UVM_ALL_ON)
  `uvm_object_utils_end
  
  constraint a1{transfer == 1; }
endclass
