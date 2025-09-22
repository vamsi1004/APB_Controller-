`include "defines.svh"

class apb_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(apb_scoreboard)

  uvm_tlm_analysis_fifo #(apb_seq_item) mon_scb_port;

  bit [`data_width-1:0] ref_mem_slave1 [bit [`addr_width-2:0]]; 
  bit [`data_width-1:0] ref_mem_slave2 [bit [`addr_width-2:0]];

  apb_seq_item mon_item;

  function new(string name = "apb_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction 

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_scb_port = new("mon_scb_port", this);
  endfunction 

  virtual task run_phase(uvm_phase phase);
    forever begin
      mon_scb_port.get(mon_item);
      compute_val(mon_item);
    end
  endtask 

  task compute_val(apb_seq_item mon);
    bit slave_sel;
    bit [`addr_width-2:0] local_addr; 
    bit [`data_width-1:0] exp_data;

    slave_sel  = mon.read_write ? mon.apb_read_paddr[`addr_width-1] : mon.apb_write_paddr[`addr_width-1] ;
    local_addr = mon.read_write ? mon.apb_read_paddr[`addr_width-2:0] : mon.apb_write_paddr[`addr_width-2:0];
    
     if ((!mon.read_write && (mon.apb_write_data === 'dx)) || ( mon.read_write && (mon.apb_read_paddr === 'dx)) || (!mon.read_write && (mon.apb_write_paddr === 'dx))) begin   
    
    if (mon.pslverr !== 1'b1) begin
      `uvm_error("APB_SCB", $sformatf("PSLVERR expected=1 but got=%0b", mon.pslverr))
    end
    else begin
      `uvm_info("APB_SCB", "PSLVERR correctly asserted!", UVM_LOW)
    end
  end

    if (mon.transfer && !mon.read_write) begin
      if (slave_sel == 1'b0) begin
        ref_mem_slave1[local_addr] = mon.apb_write_data;
        `uvm_info("APB_SCB", $sformatf("WRITE to SLAVE1 addr=%d data=%d",local_addr, mon.apb_write_data), UVM_LOW)
      end
      else begin
        ref_mem_slave2[local_addr] = mon.apb_write_data;
        `uvm_info("APB_SCB", $sformatf("WRITE to SLAVE2 addr=%d data=%d",local_addr, mon.apb_write_data), UVM_LOW)
      end
    end

    else if (mon.transfer && mon.read_write) begin
      if (slave_sel == 1'b0) begin
        exp_data = ref_mem_slave1.exists(local_addr) ? ref_mem_slave1[local_addr] : 0;
        if (mon.apb_read_data_out !== exp_data) begin
          `uvm_error("APB_SCB", $sformatf( "READ MISMATCH on SLAVE1 addr=%d exp=%d got=%d",local_addr, exp_data, mon.apb_read_data_out))
        end
        else begin
          `uvm_info("APB_SCB", $sformatf("READ MATCH on SLAVE1 addr=%d data=%d",local_addr, mon.apb_read_data_out), UVM_LOW)
        end
      end
      else begin
        exp_data = ref_mem_slave2.exists(local_addr) ?  ref_mem_slave2[local_addr] : 0;
        if (mon.apb_read_data_out !== exp_data) begin
          `uvm_error("APB_SCB", $sformatf("READ MISMATCH on SLAVE2 addr=%d exp=%d got=%d",local_addr, exp_data, mon.apb_read_data_out))
        end
        else begin
          `uvm_info("APB_SCB", $sformatf("READ MATCH on SLAVE2  addr=%d data=%d",local_addr, mon.apb_read_data_out), UVM_LOW)
        end
      end
    end

  endtask

endclass
