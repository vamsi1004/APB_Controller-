`include "defines.svh"
class apb_driver extends uvm_driver #(apb_seq_item);
  virtual apb_interface vif;
  
  `uvm_component_utils(apb_driver)
  
  function new(string name="apb_driver", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual apb_interface)::get(this,"","vif",vif ))
      `uvm_fatal("NO VIF",{"No virtual interface set for this:",get_full_name(),".vif"});
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      @(posedge vif.drv_cb);
      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
      @(posedge vif.drv_cb);
    end
  endtask
  
  task drive();
    if(req.transfer)
      begin
        if(!req.read_write) begin
            vif.read_write <= req.read_write;
            vif.apb_write_paddr <= req.apb_write_paddr;
            vif.apb_write_data <= req.apb_write_data;
            vif.transfer <= req.transfer;
        end
        else begin
            vif.apb_read_paddr <= req.apb_read_paddr; 
            vif.transfer <= req.transfer;
            vif.read_write <= req.read_write;
        end
            `uvm_info("DRIVER FROM WRITE:",$sformatf("Driverfor write"),UVM_LOW);
            req.print();
      end
    else
      vif.transfer <= req.transfer;
  endtask
  
endclass
