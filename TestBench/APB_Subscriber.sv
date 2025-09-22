`include "defines.svh"

class apb_subscriber extends uvm_component;

  `uvm_component_utils(apb_subscriber)

  apb_seq_item mon;

  real cov_report;

  uvm_tlm_analysis_fifo #(apb_seq_item) mon_cov_port;

  covergroup cg;

    transfer: coverpoint mon.transfer{bins transf []={0,1};}

    read_write: coverpoint mon.read_write{bins read_write []={0,1};}

    apb_write_padd: coverpoint mon.apb_write_paddr{bins write_paddr1 []={[0:100]};
                                                   bins write_paddr2 []={[101:256]};
                                                   bins write_paddr3 []={[257:511]};
                                                  }
    apb_write_data: coverpoint mon.apb_write_data {bins write_data1 []={[0:100]};
                                                   bins write_data2 []={[101:255]};
                                                  }
    apb_read_padd: coverpoint mon.apb_read_paddr{bins read_paddr1 []={[0:100]};
                                                   bins read_paddr2 []={[101:256]};
                                                   bins read_paddr3 []={[257:511]};
                                                  }    
    apb_read_data_out: coverpoint mon.apb_read_data_out{ bins read_out1[] = {[0:100]};
                                                        bins read_out2[] = {[101:256]};
                                                        bins read_out3[] = {[257:511]};
                                                       }
    plsverr: coverpoint mon.pslverr{bins err[] = {0,1};}

  endgroup

  function new(string name =" ",uvm_component parent);
    super.new(name,parent);
    mon_cov_port=new("mon_cov_port",this);
    cg=new;
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      mon_cov_port.get(mon);
      cg.sample();
    end
  endtask

  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    cov_report=cg.get_coverage();
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(),$sformatf("[MONITOR] coverage--%0.2f%%",cov_report),UVM_LOW);
  endfunction

endclass





 
