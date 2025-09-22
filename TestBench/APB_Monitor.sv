`include "defines.svh"
class apb_monitor extends uvm_monitor;
 
  virtual apb_interface vif;
  uvm_analysis_port #(apb_seq_item) item_collected_port;
 
  `uvm_component_utils(apb_monitor)
  
  apb_seq_item req;
 
  function new(string name = "APB_monitor", uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
    req = new;
  endfunction
 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db #(virtual apb_interface)::get(this, "", "vif", vif)) begin
      `uvm_fatal("NO_VIF", {"No virtual interface set for ", get_full_name(), ".vif"})
    end
  endfunction
 
  virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.mon_cb);
      if (vif.transfer) begin
        repeat(1) @(posedge vif.mon_cb);
        req.apb_write_paddr   = vif.apb_write_paddr;
        req.apb_write_data    = vif.apb_write_data;
        req.apb_read_paddr    = vif.apb_read_paddr;
        req.apb_read_data_out = vif.apb_read_data_out;
        req.pslverr           = vif.pslverr;
        req.transfer          = vif.transfer;
        req.read_write        = vif.read_write;
        `uvm_info("APB_MON", $sformatf("Collected transaction: %s", req.convert2string()), UVM_LOW)
        req.print();
        item_collected_port.write(req);
      end
    end
  endtask
endclass
 
