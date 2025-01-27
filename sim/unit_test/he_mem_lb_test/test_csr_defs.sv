// Copyright (C) 2020 Intel Corporation.
// SPDX-License-Identifier: MIT

//
// Description
//-----------------------------------------------------------------------------
//
//  CSR address 
//
//-----------------------------------------------------------------------------
`ifndef __TEST_CSR_DEFS__
`define __TEST_CSR_DEFS__

package test_csr_defs;
   // ******************************************************************************************
   // DFH logic
   // ******************************************************************************************
   typedef struct packed {
      logic [3:0]  feat_type;
      logic [7:0]  rsvd1;
      logic [3:0]  afu_minor_ver;
      logic [6:0]  rsvd0;
      logic        eol;
      logic [23:0] nxt_dfh_offset;
      logic [3:0]  afu_major_ver;
      logic [11:0] feat_id;
   } t_dfh;

   localparam DFH_START_OFFSET = 32'h0; 
   localparam EMIF_DFH_FEAT_ID = 12'h9; 

   // ******************************************************************************************
   // EMIF feature registers
   // ******************************************************************************************
   localparam EMIF_STATUS_OFFSET     = 32'h8;
   localparam EMIF_CAPABILITY_OFFSET = EMIF_STATUS_OFFSET + 32'h8;
   localparam EMIF_DFH_VAL           = 64'h3_00000_00B000_1009;

   // ******************************************************************************************
   // HE-LB AFU Registers
   // ******************************************************************************************
   localparam DFH                = 32'h0;
   localparam ID_L               = 32'h8;
   localparam ID_H               = 32'h10;
   localparam SCRATCHPAD0        = 32'h100;
   localparam SCRATCHPAD1        = 32'h104;
   localparam SCRATCHPAD2        = 32'h108;
   localparam DSM_BASEL          = 32'h110;
   localparam DSM_BASEH          = 32'h114;
   localparam SRC_ADDR           = 32'h120;
   localparam DST_ADDR           = 32'h128;
   localparam NUM_LINES          = 32'h130;
   localparam CTL                = 32'h138;
   localparam CFG                = 32'h140;
   localparam INACT_THRESH       = 32'h148;
   localparam INTERRUPT0         = 32'h150;
   localparam SWTEST_MSG         = 32'h158;
   localparam STATUS0            = 32'h160;
   localparam STATUS1            = 32'h168;
   localparam ERROR              = 32'h170;
   localparam STRIDE             = 32'h178;
   localparam INFO0              = 32'h180;

   typedef struct packed {
      logic [31:0] rsvd;
      logic [4:0]  local_mem_bus_width_shift; // Local memory bus width (4 bytes << value)
      logic [1:0]  bus_width_shift;           // PCIe bus width (32 bytes << value)
      logic        atomics_supported;
      logic [7:0]  he_lb_api_version;
      logic [15:0] clk_mhz;
   } t_info0;

   // Host channel bus width (PCIe)
   function automatic int bus_bytes(input t_info0 info0);
       return 32 << info0.bus_width_shift;
   endfunction

   // Local memory bus width
   function automatic int local_mem_bus_bytes(input t_info0 info0);
       return 4 << info0.local_mem_bus_width_shift;
   endfunction
endpackage

`endif
