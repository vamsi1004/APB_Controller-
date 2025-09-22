`include "uvm_pkg.sv"
`include "uvm_macros.svh"
`include "apb_pkg.sv"
`include "APB_interface.sv"
`include "design.sv"
module top;
   import uvm_pkg::*;  
  import apb_pkg::*;
 
  bit pclk;
  bit presetn;
  
  always #5 pclk = ~pclk;
  
  initial begin
//     presetn = 0;
    pclk = 0;
  presetn = 1;
  end
  apb_interface intf(pclk,presetn);

  APB_Protocol dut (
    .PCLK(pclk),
    .PRESETn(presetn),
    .transfer(intf.transfer),
    .READ_WRITE(intf.read_write),
    .apb_write_paddr(intf.apb_write_paddr),
    .apb_write_data(intf.apb_write_data),
    .apb_read_paddr(intf.apb_read_paddr),
    .PSLVERR(intf.pslverr),
    .apb_read_data_out(intf.apb_read_data_out)
);
  
  initial begin 
    uvm_config_db#(virtual apb_interface)::set(null,"*","vif",intf);
    $dumpfile("dump.vcd");
	$dumpvars;
  end
  
  initial begin 
    run_test("apb_test");
    #100 $finish;
  end
endmodule
