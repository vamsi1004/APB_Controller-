`include "defines.svh"
class apb_environment extends uvm_env;
  
  `uvm_component_utils(apb_environment)
  
  function new(string name = "", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  apb_subscriber cov;
  apb_scoreboard scb;
  apb_agent agt;
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    cov = apb_subscriber::type_id::create("cov",this);
    scb = apb_scoreboard::type_id::create("scb",this);
    agt = apb_agent::type_id::create("agt",this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agt.mon.item_collected_port.connect(scb.mon_scb_port.analysis_export);
    agt.mon.item_collected_port.connect(cov.mon_cov_port.analysis_export);
  endfunction 
  
endclass
