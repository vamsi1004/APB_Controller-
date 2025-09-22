`include "defines.svh"

class apb_agent extends uvm_agent;
  apb_sequencer seqr;
  apb_driver drv;
  apb_monitor mon;
  
  `uvm_component_utils(apb_agent);
  
  function new(string name ="apb_agent",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(get_is_active()==UVM_ACTIVE) begin
      seqr = apb_sequencer::type_id::create("seqr",this);
      drv = apb_driver::type_id::create("drv",this);
    end
      mon= apb_monitor::type_id::create("mon",this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(get_is_active()==UVM_ACTIVE) begin
      drv.seq_item_port.connect(seqr.seq_item_export);
    end
  endfunction
endclass
