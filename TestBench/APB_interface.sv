`include "defines.svh"

interface apb_interface(input logic pclk,presetn);
  
  logic transfer;
  logic read_write;
  logic [`addr_width - 1 : 0] apb_write_paddr;
  logic [`addr_width - 1 : 0] apb_read_paddr;
  logic [`data_width - 1 : 0] apb_write_data;
  logic [`data_width - 1 : 0] apb_read_data_out; 
  logic pslverr;
  
  clocking drv_cb @(posedge pclk);
    default input #0 output #0;
    output transfer;
    output read_write;
    output apb_write_paddr;
    output apb_read_paddr;
    output apb_write_data;
  endclocking 
 
  clocking mon_cb @(posedge pclk);
    default input #0 output #0;
    input apb_read_data_out;
    input pslverr;
    input transfer;
    input read_write;
    input apb_write_paddr;
    input apb_read_paddr;
    input apb_write_data;
  endclocking 
  
  modport drv(clocking drv_cb, input pclk,presetn);
  modport mon(clocking mon_cb, input pclk,presetn);
  
    //Assertions 
    
property p0;
  @(posedge pclk)
  !presetn |-> (apb_read_paddr == 9'b0 && pslverr == 0);
endproperty
 
assert property (p0)
  $info("p0 pass");
  else
  $error("p0 fail");
 
 
property p1;  
  @(posedge pclk)disable iff(!presetn)
  transfer |-> (read_write == 1'b1 || read_write ==1'b0);
endproperty
 
assert property (p1)
  $info("p1 pass");
  else
  $error("p1 fail");

property p2;
   @(posedge pclk)disable iff(!presetn)
  (transfer && read_write)|=> $stable(apb_read_paddr);
endproperty
  assert property (p2)
   $info("p2 pass");
  else
   $error("p2 fail");

property p3;
    @(posedge pclk)disable iff(!presetn)
  (transfer && !read_write)|=> $stable({apb_write_paddr,apb_write_data});
endproperty
    assert property (p3)
    $info("p3 pass");
  else
    $error("p3 fail");
      
property p4;
     @(posedge pclk)disable iff(!presetn)
     (transfer && !read_write) |=> !$isunknown(apb_read_data_out);
endproperty
assert property (p4)
   $info("p4 pass");
   else
   $error("p4 fail");
  
property p5;
  @(posedge pclk)disable iff(!presetn)
  (transfer && read_write) |-> (apb_read_paddr !== 9'bx);
endproperty
assert property (p5)
    $info("p5 pass");
    else
     $error("p5 fail");
  
           property p6;
             @(posedge pclk)disable iff(!presetn)
             (transfer && !read_write) |-> (apb_write_paddr !== 9'bx);
        endproperty
          assert property (p6)
            $info("p6 pass");
         else
         $error("p6 fail");
            
            property p7;
              @(posedge pclk) disable iff(!presetn)
              (!read_write) ##2 (read_write);
            endproperty 
            
            assert property(p7)
              $info("pass");
              else
                $info("Fail");
endinterface

