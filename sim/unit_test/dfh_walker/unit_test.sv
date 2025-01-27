// Copyright (C) 2020 Intel Corporation.
// SPDX-License-Identifier: MIT
//---------------------------------------------------------
// Test module for the simulation. 
//---------------------------------------------------------


module unit_test #(
   parameter SOC_ATTACH = 0,
   parameter LINK_NUMBER = 0,
   parameter type pf_type = host_bfm_types_pkg::default_pfs, 
   parameter pf_type pf_list = '{1'b1}, 
   parameter type vf_type = host_bfm_types_pkg::default_vfs, 
   parameter vf_type vf_list = '{0}
)(
   input logic clk,
   input logic rst_n,
   input logic csr_clk,
   input logic csr_rst_n
);

import pfvf_class_pkg::*;
import host_memory_class_pkg::*;
import tag_manager_class_pkg::*;
import pfvf_status_class_pkg::*;
import packet_class_pkg::*;
import host_axis_send_class_pkg::*;
import host_axis_receive_class_pkg::*;
import host_transaction_class_pkg::*;
import host_bfm_types_pkg::*;
import host_bfm_class_pkg::*;
import test_csr_defs::*;


//---------------------------------------------------------
// FLR handle and FLR Memory
//---------------------------------------------------------
//HostFLREvent flr;
//HostFLREvent flrs_received[$];
//HostFLREvent flrs_sent_history[$];


//---------------------------------------------------------
// Packet Handles and Storage
//---------------------------------------------------------
Packet            #(pf_type, vf_type, pf_list, vf_list) p;
PacketPUMemReq    #(pf_type, vf_type, pf_list, vf_list) pumr;
PacketPUAtomic    #(pf_type, vf_type, pf_list, vf_list) pua;
PacketPUCompletion#(pf_type, vf_type, pf_list, vf_list) puc;
PacketDMMemReq    #(pf_type, vf_type, pf_list, vf_list) dmmr;
PacketDMCompletion#(pf_type, vf_type, pf_list, vf_list) dmc;
PacketUnknown     #(pf_type, vf_type, pf_list, vf_list) pu;

Packet#(pf_type, vf_type, pf_list, vf_list) q[$];
Packet#(pf_type, vf_type, pf_list, vf_list) qr[$];


//---------------------------------------------------------
// Transaction Handles and Storage
//---------------------------------------------------------
Transaction      #(pf_type, vf_type, pf_list, vf_list) t;
ReadTransaction  #(pf_type, vf_type, pf_list, vf_list) rt;
WriteTransaction #(pf_type, vf_type, pf_list, vf_list) wt;
AtomicTransaction#(pf_type, vf_type, pf_list, vf_list) at;

Transaction#(pf_type, vf_type, pf_list, vf_list) tx_transaction_queue[$];
Transaction#(pf_type, vf_type, pf_list, vf_list) tx_active_transaction_queue[$];
Transaction#(pf_type, vf_type, pf_list, vf_list) tx_completed_transaction_queue[$];
Transaction#(pf_type, vf_type, pf_list, vf_list) tx_errored_transaction_queue[$];
Transaction#(pf_type, vf_type, pf_list, vf_list) tx_history_transaction_queue[$];


//---------------------------------------------------------
// PFVF Structs 
//---------------------------------------------------------
pfvf_struct pfvf;

//---------------------------------------------------------
//  BEGIN: Test Tasks and Utilities
//---------------------------------------------------------
parameter MAX_TEST = 100;
parameter TIMEOUT = 10ms;
localparam NUMBER_OF_LINKS = `OFS_FIM_IP_CFG_PCIE_SS_NUM_LINKS;
localparam string unit_test_name = "DFH Walker Test";

//---------------------------------------------------------
// Mailbox 
//---------------------------------------------------------
mailbox #(host_bfm_types_pkg::mbx_message_t) mbx = new();
host_bfm_types_pkg::mbx_message_t mbx_msg;

typedef struct packed {
   logic result;
   logic [1024*8-1:0] name;
} t_test_info;

int err_count = 0;
logic [31:0] test_id;
t_test_info [MAX_TEST-1:0] test_summary;
logic reset_test;
logic [7:0] checker_err_count;
logic test_done;
logic all_tests_done;
logic test_result;

//---------------------------------------------------------
//  Test Utilities
//---------------------------------------------------------
function void incr_err_count();
   err_count++;
endfunction


function int get_err_count();
   return err_count;
endfunction


//---------------------------------------------------------
//  Test Tasks
//---------------------------------------------------------
task incr_test_id;
begin
   test_id = test_id + 1;
end
endtask

task post_test_util;
   input logic [31:0] old_test_err_count;
   logic result;
begin
   if (get_err_count() > old_test_err_count) 
   begin
      result = 1'b0;
   end else begin
      result = 1'b1;
   end

   repeat (10) @(posedge clk);

   @(posedge clk);
      reset_test = 1'b1;
   repeat (5) @(posedge clk);
   reset_test = 1'b0;

   if (result) 
   begin
      $display("\nTest status: OK");
      test_summary[test_id].result = 1'b1;
   end 
   else 
   begin
      $display("\nTest status: FAILED");
      test_summary[test_id].result = 1'b0;
   end
   incr_test_id(); 
end
endtask

task print_test_header;
   input [1024*8-1:0] test_name;
begin
   $display("\n********************************************");
   $display(" Running TEST(%0d) : %0s", test_id, test_name);
   $display("********************************************");   
   test_summary[test_id].name = test_name;
end
endtask


// Deassert AFU reset
task deassert_afu_reset;
   int count;
   logic [63:0] scratch;
   logic [31:0] wdata;
   logic        error;
   logic [31:0] PORT_CONTROL;
   byte_t       read_buf[];
   byte_t       write_buf[];
begin
   count = 0;
   PORT_CONTROL = 32'h71000 + 32'h38;
   //De-assert Port Reset 
   $display("\nDe-asserting Port Reset...");
   pfvf = '{0,0,0};
   host_bfm_top.host_bfm.set_pfvf_setting(pfvf);
   host_bfm_top.host_bfm.read64(PORT_CONTROL, scratch);
   wdata = scratch[31:0];
   wdata[0] = 1'b0;
   host_bfm_top.host_bfm.write32(PORT_CONTROL, wdata);
   #5000000 host_bfm_top.host_bfm.read64(PORT_CONTROL, scratch);
   if (scratch[4] != 1'b0) begin
      $display("\nERROR: Port Reset Ack Asserted!");
      incr_err_count();
      $finish;       
   end
   $display("\nAFU is out of reset ...");
   host_bfm_top.host_bfm.revert_to_last_pfvf_setting();
end
endtask


//---------------------------------------------------------
//  END: Test Tasks and Utilities
//---------------------------------------------------------

//---------------------------------------------------------
// Initials for Sim Setup
//---------------------------------------------------------
initial 
begin
   reset_test = 1'b0;
   test_id = '0;
   test_done = 1'b0;
   all_tests_done = 1'b0;
   test_result = 1'b0;
end

initial 
begin
   fork: timeout_thread begin
     $display ("This Test will time out in %0t\n", TIMEOUT);
     // timeout thread, wait for TIMEOUT period to pass
     #(TIMEOUT);
     // The test hasn't finished within TIMEOUT Period
     @(posedge clk);
     $display ("TIMEOUT, test_pass didn't go high in 1 ms\n");
     disable timeout_thread;
   end
 
   wait (test_done==1) begin
      // Test summary
      $display("\n");
      $display("***************************");
      $display("  Test summary for link %0d", LINK_NUMBER);
      $display("***************************");
      for (int i=0; i < test_id; i=i+1) 
      begin
         if (test_summary[i].result)
            $display("   %0s (id=%0d) - pass", test_summary[i].name, i);
         else
            $display("   %0s (id=%0d) - FAILED", test_summary[i].name, i);
      end

      if(get_err_count() == 0) 
      begin
         $display("");
         $display("");
         $display("-----------------------------------------------------");
         $display("Test passed!");
         $display("Test:%s for--> Link:%0d", unit_test_name, LINK_NUMBER);
         $display("-----------------------------------------------------");
         $display("");
         $display("");
         $display("      '||''|.      |      .|'''.|   .|'''.|  ");
         $display("       ||   ||    |||     ||..  '   ||..  '  ");
         $display("       ||...|'   |  ||     ''|||.    ''|||.  ");
         $display("       ||       .''''|.  .     '|| .     '|| ");
         $display("      .||.     .|.  .||. |'....|'  |'....|'  ");
         $display("");
         $display("");
      end 
      else 
      begin
          if (get_err_count() != 0) 
          begin
             $display("");
             $display("");
             $display("-----------------------------------------------------");
             $display("Test FAILED! %0d errors reported.", get_err_count());
             $display("Test:%s for--> Link:%0d", unit_test_name, LINK_NUMBER);
             $display("-----------------------------------------------------");
             $display("");
             $display("");
             $display("      '||''''|     |     '||' '||'      ");
             $display("       ||  .      |||     ||   ||       ");
             $display("       ||''|     |  ||    ||   ||       ");
             $display("       ||       .''''|.   ||   ||       ");
             $display("      .||.     .|.  .||. .||. .||.....| ");
             $display("");
             $display("");
          end
       end
   end
   
   join_any
   if (LINK_NUMBER == 0)
   begin
      wait (all_tests_done);
      $finish();  
   end
end


generate
   if (LINK_NUMBER != 0)
   begin // This block covers the scenario where there is more than one link and link N needs to coordinate execution with link0.
      logic [31:0] old_test_err_count;
      logic result;
      logic [63:0] addr;
      logic [63:0] scratch;
      always begin : main   
         #10000;
         wait (rst_n);
         wait (csr_rst_n);
         //deassert_afu_reset();
         $display(">>> Link #%0d: Sending READY to Link0.  Waiting for release.", LINK_NUMBER);
         host_gen_block0.pcie_top_host0.unit_test.mbx.put(READY);
         mbx_msg = START;
         while (mbx_msg != GO)
         begin
            $display("Mailbox #%0d State: %s", LINK_NUMBER, mbx_msg.name());
            mbx.get(mbx_msg);
         end
         $display(">>> Running %s on Link %0d...", unit_test_name, LINK_NUMBER);
         // Checking for Dummy DFH in Link #1
         print_test_header("test_dfh_walking-link1");
         old_test_err_count = get_err_count();
         addr = 64'h0;
         host_bfm_top.host_bfm.read64(addr,scratch);
         $display("DUMMY DFH");
         $display("   Address   (0x%0x)", addr);
         $display("   DFH value (0x%0x)\n", scratch);
         if (scratch != 64'h1000_0100_0000_0000)
         begin
            incr_err_count();
         end
         post_test_util(old_test_err_count);
         $display(">>> %s on Link %0d Completed.", unit_test_name, LINK_NUMBER);
         test_done = 1'b1;
         host_gen_block0.pcie_top_host0.unit_test.mbx.put(DONE);
      end
   end
   else
   begin
      if (NUMBER_OF_LINKS > 1)
      begin // This block covers the scenario where there is more than one link and link0 needs to communicate with the other links.
         always begin : main   
            #10000;
            wait (rst_n);
            wait (csr_rst_n);
            //-------------------------
            // deassert port reset
            //-------------------------
            deassert_afu_reset();
            //-------------------------
            // Test scenarios 
            //-------------------------
            $display(">>> Running %s on Link 0...", unit_test_name);
            main_test(test_result);
            $display(">>> %s on Link 0 Completed.", unit_test_name);
            test_done = 1'b1;
            $display("*** Number of Links: %0d", NUMBER_OF_LINKS);
            #1000
            $display(">>> Link #0: Getting status from Link #1 Mailbox, testing for READY");
            mbx.try_get(mbx_msg);
            $display(">>> Link #0: Link #1 shows status as %s.", mbx_msg.name());
            $display(">>> Link #0: %s complete.  Sending GO to Link #1.", unit_test_name);
            mbx_msg = READY;
            host_gen_block1.pcie_top_host1.unit_test.mbx.put(GO);
            while (mbx_msg != DONE)
            begin
               $display("Mailbox #0 State: %s", mbx_msg.name());
               mbx.get(mbx_msg);
            end
            all_tests_done = 1'b1;
         end
      end
      else
      begin  // This block covers the scenario where there is only one link and no mailbox communication is required.
         always begin : main   
            #10000;
            wait (rst_n);
            wait (csr_rst_n);
            //-------------------------
            // deassert port reset
            //-------------------------
            deassert_afu_reset();
            //-------------------------
            // Test scenarios 
            //-------------------------
            $display(">>> Running %s on Link 0...", unit_test_name);
            main_test(test_result);
            $display(">>> %s on Link 0 Completed.", unit_test_name);
            test_done = 1'b1;
            all_tests_done = 1'b1;
         end
      end
   end
endgenerate


//---------------------------------------------------------
//  Unit Test Procedure
//---------------------------------------------------------
//
//-------------------
// Test cases 
//-------------------
// Test DFH walking 
task test_dfh_walking;
   output logic result;
   dfh_name[MAX_DFH_IDX-1:0]     dfh_names;
   logic [MAX_DFH_IDX-1:0][63:0] dfh_values;
   t_dfh        dfh;
   int          dfh_cnt;
   logic        eol;
   logic [63:0] scratch;
   logic        error;
   logic [31:0] addr;
   logic [31:0] old_test_err_count;
begin
   print_test_header("test_dfh_walking-link0");
   
   old_test_err_count = get_err_count();
   result = 1'b1;

   //--------------------------
   // DFH Bit mapping
   //--------------------------
   //   [63:60]: Feature Type   
   //   [59:52]: Reserved - 0
   //   [51:48]: If AFU - AFU Minor Revision Number (else, reserved)  - 0
   //   [47:41]: Reserved - 0
   //   [40   ]: EOL (End of DFH list)   
   //   [39:16]: Next DFH Byte Offset 
   //   [15:12]: If AfU, AFU Major version number (else feature #) - 0
   //   [11:0 ]: Feature ID 
   //--------------------------

   dfh_names = get_dfh_names();
   dfh_values = get_dfh_values();

   dfh_cnt = 0;
   eol  = 1'b0;
   addr = DFH_START_OFFSET;

   while (~eol && dfh_cnt < MAX_DFH_IDX) begin
      host_bfm_top.host_bfm.read64(addr, scratch);
      $display("%0s", dfh_names[dfh_cnt]);
      $display("   Address   (0x%0x)", addr);
      $display("   DFH value (0x%0x)\n", scratch);

      dfh = t_dfh'(scratch);
      eol = dfh.eol;

      if (scratch !== dfh_values[dfh_cnt]) begin
         $display("\nERROR: DFH value mismatched, expected: 0x%0x actual:0x%0x\n", dfh_values[dfh_cnt], scratch);      
         incr_err_count();
         eol = 1'b1; // error found, exit the loop
         result = 1'b0;
      end
      
      addr = addr + dfh.nxt_dfh_offset;
      dfh_cnt = dfh_cnt + 1'b1;
   end

   if (result) begin
      if (eol !== 1'b1) begin
         $display("\nERROR: Expect EOL bit to be set for last feature in the DFL (%0s), actual:'b%0b\n", dfh_names[MAX_DFH_IDX-1], eol);      
         incr_err_count();
         result = 1'b0; 
      end

      if (dfh_cnt !== MAX_DFH_IDX) begin
         $display("\nERROR: Expected %d features to be discovered, actual:%0d\n", MAX_DFH_IDX, dfh_cnt);      
         incr_err_count();
         result = 1'b0; 
      end
   end

   post_test_util(old_test_err_count);
end
endtask


task main_test;
   output logic test_result;
   begin
      $display("Entering %s.", unit_test_name);
      host_bfm_top.host_bfm.set_mmio_mode(PU_METHOD_TRANSACTION);
      host_bfm_top.host_bfm.set_dm_mode(DM_AUTO_TRANSACTION);

      test_dfh_walking(test_result);
   end
endtask


endmodule
