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
`include "ofs_ip_cfg_db.vh"

import top_cfg_pkg::*;

`ifdef ETH_10G
  `define ETH_10_OR_25G
`elsif ETH_25G
  `define ETH_10_OR_25G
`endif

`ifdef ETH_200G
   `define ETH_200G_OR_400G
`elsif ETH_400G
  `define ETH_200G_OR_400G
`endif

package test_csr_defs;

   // ******************************************************************************************
   // AFU Register Address
   // ******************************************************************************************
   parameter AFU_DFH_ADDR                        = 64'h0000_0000_0004_0000;
   parameter AFU_ID_L_ADDR                       = 64'h0000_0000_0004_0008;
   parameter AFU_ID_H_ADDR                       = 64'h0000_0000_0004_0010;
   parameter AFU_PORT_SEL_ADDR                   = 64'h0000_0000_0004_0040;
   parameter AFU_SCRATCH_ADDR                    = 64'h0000_0000_0004_0048;
   parameter AFU_UNUSED_ADDR                     = 64'h0000_0000_0004_0058;

   // ******************************************************************************************
   // AFU Register Default Values
   // ******************************************************************************************
   parameter AFU_DFH_VAL                        = 64'h1000_0100_0000_1000;
   parameter AFU_ID_L_VAL                       = 64'hBB37_0242_AC13_0002;
   parameter AFU_ID_H_VAL                       = 64'h823C_334C_98BF_11EA;
   parameter AFU_SCRATCH_VAL                    = 64'h0000_0000_4532_4511;

   // ******************************************************************************************
   // HSSI SS IP Register Address
   // ******************************************************************************************
   parameter HSSI_DFH_LO_ADDR               = 64'h0000_0000_0001_4000;
   parameter HSSI_DFH_HI_ADDR               = HSSI_DFH_LO_ADDR + 64'h04;
   parameter HSSI_FEATURE_GUID_L_0_ADDR     = HSSI_DFH_LO_ADDR + 64'h08;
   parameter HSSI_FEATURE_GUID_L_1_ADDR     = HSSI_DFH_LO_ADDR + 64'h0C;
   parameter HSSI_FEATURE_GUID_H_0_ADDR     = HSSI_DFH_LO_ADDR + 64'h10;
   parameter HSSI_FEATURE_GUID_H_1_ADDR     = HSSI_DFH_LO_ADDR + 64'h14;
   parameter HSSI_FEATURE_CSR_ADD_LO_ADDR   = HSSI_DFH_LO_ADDR + 64'h18;
   parameter HSSI_FEATURE_CSR_ADD_HI_ADDR   = HSSI_DFH_LO_ADDR + 64'h1C;
   parameter HSSI_FEATURE_CSR_SIZE_LO_ADDR  = HSSI_DFH_LO_ADDR + 64'h20;
   parameter HSSI_FEATURE_CSR_SIZE_HI_ADDR  = HSSI_DFH_LO_ADDR + 64'h24;

   parameter HSSI_VER_ADDR                  = HSSI_DFH_LO_ADDR + 64'h60;
   parameter HSSI_FEATURE_ADDR              = HSSI_DFH_LO_ADDR + 64'h64;
   parameter HSSI_PORT0_ATTR_ADDR           = HSSI_DFH_LO_ADDR + 64'h68;
   parameter HSSI_PORT1_ATTR_ADDR           = HSSI_PORT0_ATTR_ADDR + 64'h4;
   parameter HSSI_PORT2_ATTR_ADDR           = HSSI_PORT0_ATTR_ADDR + 64'h8;
   parameter HSSI_PORT3_ATTR_ADDR           = HSSI_PORT0_ATTR_ADDR + 64'hC;
   parameter HSSI_PORT4_ATTR_ADDR           = HSSI_PORT0_ATTR_ADDR + 64'h10;
   parameter HSSI_PORT5_ATTR_ADDR           = HSSI_PORT0_ATTR_ADDR + 64'h14;
   parameter HSSI_PORT6_ATTR_ADDR           = HSSI_PORT0_ATTR_ADDR + 64'h18;
   parameter HSSI_PORT7_ATTR_ADDR           = HSSI_PORT0_ATTR_ADDR + 64'h1C;
   parameter HSSI_PORT8_ATTR_ADDR           = HSSI_PORT0_ATTR_ADDR + 64'h20;
   parameter HSSI_PORT9_ATTR_ADDR           = HSSI_PORT0_ATTR_ADDR + 64'h24;
   parameter HSSI_PORT10_ATTR_ADDR          = HSSI_PORT0_ATTR_ADDR + 64'h28;
   parameter HSSI_PORT11_ATTR_ADDR          = HSSI_PORT0_ATTR_ADDR + 64'h2C;
   parameter HSSI_PORT12_ATTR_ADDR          = HSSI_PORT0_ATTR_ADDR + 64'h30;
   parameter HSSI_PORT13_ATTR_ADDR          = HSSI_PORT0_ATTR_ADDR + 64'h34;
   parameter HSSI_PORT14_ATTR_ADDR          = HSSI_PORT0_ATTR_ADDR + 64'h38;
   parameter HSSI_PORT15_ATTR_ADDR          = HSSI_PORT0_ATTR_ADDR + 64'h3C;
   parameter HSSI_PORT0_STATUS_ADDR         = HSSI_DFH_LO_ADDR + 64'hC0;
   parameter HSSI_PORT1_STATUS_ADDR         = HSSI_PORT0_STATUS_ADDR + 64'h4;
   parameter HSSI_PORT2_STATUS_ADDR         = HSSI_PORT0_STATUS_ADDR + 64'h8;
   parameter HSSI_PORT3_STATUS_ADDR         = HSSI_PORT0_STATUS_ADDR + 64'hC;
   parameter HSSI_PORT4_STATUS_ADDR         = HSSI_PORT0_STATUS_ADDR + 64'h10;
   parameter HSSI_PORT5_STATUS_ADDR         = HSSI_PORT0_STATUS_ADDR + 64'h14;
   parameter HSSI_PORT6_STATUS_ADDR         = HSSI_PORT0_STATUS_ADDR + 64'h18;
   parameter HSSI_PORT7_STATUS_ADDR         = HSSI_PORT0_STATUS_ADDR + 64'h1C;
   parameter HSSI_PORT8_STATUS_ADDR         = HSSI_PORT0_STATUS_ADDR + 64'h20;
   parameter HSSI_PORT9_STATUS_ADDR         = HSSI_PORT0_STATUS_ADDR + 64'h24;
   parameter HSSI_PORT10_STATUS_ADDR        = HSSI_PORT0_STATUS_ADDR + 64'h28;
   parameter HSSI_PORT11_STATUS_ADDR        = HSSI_PORT0_STATUS_ADDR + 64'h2C;
   parameter HSSI_PORT12_STATUS_ADDR        = HSSI_PORT0_STATUS_ADDR + 64'h30;
   parameter HSSI_PORT13_STATUS_ADDR        = HSSI_PORT0_STATUS_ADDR + 64'h34;
   parameter HSSI_PORT14_STATUS_ADDR        = HSSI_PORT0_STATUS_ADDR + 64'h38;
   parameter HSSI_PORT15_STATUS_ADDR        = HSSI_PORT0_STATUS_ADDR + 64'h3C;

   // ******************************************************************************************
   // HSSI Wrapper Register Address
   // ******************************************************************************************
   parameter HSSI_WRAP_RST_ADDR             = 64'h0000_0000_0001_4800;
   parameter HSSI_WRAP_ACK_ADDR             = HSSI_WRAP_RST_ADDR + 64'h8;
   parameter HSSI_WRAP_COLD_RST_ACK_ADDR    = HSSI_WRAP_RST_ADDR + 64'h10;
   parameter HSSI_WRAP_STATUS_ADDR          = HSSI_WRAP_RST_ADDR + 64'h18;
   parameter HSSI_WRAP_SCRATCH_ADDR         = HSSI_WRAP_RST_ADDR + 64'h20;
   parameter HSSI_WRAP_UNUSED_ADDR          = HSSI_WRAP_RST_ADDR + 64'h248;
       
   // ******************************************************************************************
   // HSSI Wrapper Register Values
   // ******************************************************************************************
    localparam NUM_ETH_CHANNELS     = `OFS_FIM_IP_CFG_HSSI_SS_NUM_ETH_PORTS;
    parameter HSSI_WRAP_STATUS_VAL  = (NUM_ETH_CHANNELS==16)? 64'h0000ffffffffffff : (NUM_ETH_CHANNELS==4)? 64'h0000000f000f000f : (NUM_ETH_CHANNELS==2)? 64'h0000000300030003 : (NUM_ETH_CHANNELS==1)? 64'h0000000100010001 : 64'h000000FF00FF00FF;

   // ******************************************************************************************
   // HSSI SS IP Register Values
   // ******************************************************************************************
   parameter HSSI_DFH_LO_VAL                = 32'h1000_2015;
   parameter HSSI_DFH_HI_VAL                = 32'h3000_0000;
   parameter HSSI_FEATURE_GUID_L_0_VAL      = 32'h18418b9d;
   parameter HSSI_FEATURE_GUID_L_1_VAL      = 32'h99a078ad;
   parameter HSSI_FEATURE_GUID_H_0_VAL      = 32'hd9db4a9b;
   parameter HSSI_FEATURE_GUID_H_1_VAL      = 32'h4118a7cb;
   parameter HSSI_FEATURE_CSR_ADD_LO_VAL    = 32'hC0;
   parameter HSSI_FEATURE_CSR_ADD_HI_VAL    = 32'h00;
   parameter HSSI_FEATURE_CSR_SIZE_LO_VAL   = 32'h10000;
   parameter HSSI_FEATURE_CSR_SIZE_HI_VAL   = 32'h44;
   parameter HSSI_VER_VAL                   = 32'h0001_0000;
   `ifdef ETH_10G
   parameter HSSI_FEATURE_VAL               = 32'h0000_3FD1;
   parameter HSSI_IF_ATTR_VAL               = 32'h0024_2414;
   parameter HSSI_PORT_STATUS_VAL           = 32'h0000_0195;
   `elsif ETH_100G
   parameter HSSI_FEATURE_VAL               = 32'h0000_0005;
   parameter HSSI_IF_ATTR_VAL               = 32'h0024_301B;
   parameter HSSI_PORT_STATUS_VAL           = 32'h0000_009D;
   `elsif ETH_200G
   parameter HSSI_FEATURE_VAL               = 32'h0004_4005;
   parameter HSSI_IF_ATTR_VAL               = 32'h0024_101D;
   parameter HSSI_PORT_STATUS_VAL           = 32'h0000_0000;
   `else
   parameter HSSI_FEATURE_VAL               = 32'h0000_3FD1;
   parameter HSSI_IF_ATTR_VAL               = 32'h0024_2415;
   parameter HSSI_PORT_STATUS_VAL           = 32'h0000_0195;
   `endif
   
   // ******************************************************************************************
   // Traffic Controller Register Address
   // ******************************************************************************************
   parameter TG_NUM_PKT_ADDR                = 64'h0000_0000_0000_0000;
   parameter TG_PKT_LEN_TYPE_ADDR           = 64'h0000_0000_0000_0001;
   parameter TG_DATA_PATTERN_ADDR           = 64'h0000_0000_0000_0002;
   parameter TG_START_XFR_ADDR              = 64'h0000_0000_0000_0003;
   parameter TG_STOP_XFR_ADDR               = 64'h0000_0000_0000_0004;
   parameter TG_SRC_MAC_L_ADDR              = 64'h0000_0000_0000_0005;
   parameter TG_SRC_MAC_H_ADDR              = 64'h0000_0000_0000_0006;
   parameter TG_DST_MAC_L_ADDR              = 64'h0000_0000_0000_0007;
   parameter TG_DST_MAC_H_ADDR              = 64'h0000_0000_0000_0008;
   parameter TG_PKT_XFRD_ADDR               = 64'h0000_0000_0000_0009;
   parameter TG_RANDOM_SEED0_ADDR           = 64'h0000_0000_0000_000A;
   parameter TG_RANDOM_SEED1_ADDR           = 64'h0000_0000_0000_000B;
   parameter TG_RANDOM_SEED2_ADDR           = 64'h0000_0000_0000_000C;
   parameter TG_PKT_LEN_ADDR                = 64'h0000_0000_0000_000D;
   
   `ifdef ETH_10_OR_25G
   parameter TG_START_TS_ADDR               = 64'h0000_0000_0000_00F4;
   parameter TG_END_TS_ADDR                 = 64'h0000_0000_0000_00F5;
   `elsif ETH_100G
   parameter TG_START_TS_ADDR               = 64'h0000_0000_0000_001F;
   parameter TG_END_TS_ADDR                 = 64'h0000_0000_0000_0021;
   `elsif ETH_200G_OR_400G 
   parameter TG_START_TS_ADDR               = 64'h0000_0000_0000_0050;
   parameter TG_END_TS_ADDR                 = 64'h0000_0000_0000_0058;
   `endif


   parameter TM_NUM_PKT_ADDR                = 64'h0000_0000_0000_0100;
   parameter TM_PKT_GOOD_ADDR               = 64'h0000_0000_0000_0101;
   parameter TM_PKT_BAD_ADDR                = 64'h0000_0000_0000_0102;
   parameter TM_BYTE_CNT0_ADDR              = 64'h0000_0000_0000_0103;
   parameter TM_BYTE_CNT1_ADDR              = 64'h0000_0000_0000_0104;
   parameter TM_AVST_RX_ERR_ADDR            = 64'h0000_0000_0000_0107;

   `ifdef ETH_10_OR_25G 
   parameter TM_START_TS_ADDR               = 64'h0000_0000_0000_010B;
   parameter TM_END_TS_ADDR                 = 64'h0000_0000_0000_010C;
   `elsif ETH_100G
   parameter TM_START_TS_ADDR               = 64'h0000_0000_0000_0023;
   parameter TM_END_TS_ADDR                 = 64'h0000_0000_0000_0025;
   `elsif ETH_200G_OR_400G 
   parameter TM_START_TS_ADDR               = 64'h0000_0000_0000_0050;
   parameter TM_END_TS_ADDR                 = 64'h0000_0000_0000_0058;
   `endif

   parameter LOOPBACK_EN_ADDR               = 64'h0000_0000_0000_0200;

   // ******************************************************************************************
   // Mailbox Register CMD Space
   // ******************************************************************************************
   // Mailbox address
   parameter TRAFFIC_CTRL_CMD_ADDR          = 64'h0000_0000_0004_0030;
   // OFFSET address in mailbox
   parameter MB_ADDRESS_OFFSET              = 64'h4;
   parameter MB_RDDATA_OFFSET               = 64'h8;
   parameter MB_WRDATA_OFFSET               = 64'hC;
   // CMD
   parameter MB_NOOP                        = 32'h0;
   parameter MB_RD                          = 32'h1;
   parameter MB_WR                          = 32'h2;
 
   localparam HEH_PF             = 0; 
   localparam HEH_VF             = 1; 
   localparam HEH_VA             = 1; 
   // typedef enum logic [5:0] {
   //    400GAUI_8  = 6'b100000,
   //    400GAUI_4  = 6'b011111, 
   //    200GAUI_8  = 6'b011110, 
   //    200GAUI_4  = 6'b011101, 
   //    200GAUI_2  = 6'b011100, 
   //    100GCAUI_4 = 6'b011011, 
   //    100GAUI_2  = 6'b011010, 
   //    100GAUI_1  = 6'b011001, 
   //    50GAUI_1   = 6'b011000, 
   //    50GAUI_2   = 6'b010111, 
   //    40GCAUI_4  = 6'b010110, 
   //    25GbE      = 6'b010101, 
   //    10GbE      = 6'b010100
   // } hssi_port_profile_e;

   // typedef enum logic [4:0] {
   //    24G_PCS  = 5'b01111,
   //    12G_PCS  = 5'b01110,
   //    10G_PCS  = 5'b01101,
   //    9_8G_PMA = 5'b01100,
   //    8_1G_PMA = 5'b01011,
   //    6_1G_PMA = 5'b01010,
   //    4_9G_PMA = 5'b01001,
   //    3_0G_PMA = 5'b01000,
   //    2_4G_PMA = 5'b00111,
   //    1_2G_PMA = 5'b00110,
   //    0_6G_PMA = 5'b00101,
   //    MAC_PCS  = 5'b00100,
   //    PCS      = 5'b00011,
   //    FlexE    = 5'b00010,
   //    OTN      = 5'b00001,
   //    None     = 5'b00000
   // } hssi_port_sub_profile_e
   
   typedef struct packed {
      logic [10:0] rsvd;
      logic [14:0] port_enable;
      logic [4:0]  num_ports;
      logic        error_mask;
   } hssi_feature_t;

   // typedef struct packed {
   //    logic [7:0] rsvd;
   //    logic       ptp_en;
   //    logic       anlt_en;
   //    logic       rsfec_en;
   //    hssi_port_sub_profile_e sub_profile;
   //    logic       drp; // dynamic reconfiguration indicator
   //    logic [1:0] low_speed_param;
   //    logic [2:0] data_bus_width;
   //    logic [4:0] ready_latency;
   //    hssi_port_profile_e profile;       
   // } hssi_port_attr_t;

   typedef struct packed {
      logic [5:0] rsvd;
      logic [1:0] hip_pll_locked;
      logic       tx_pll_locked;
      logic       rx_pcs_ready;
      logic       tx_lanes_stable;
      logic       cal_error;
      logic       load_error;
      logic       eth_mode;
      logic       ena_10;
      logic       set_1000;
      logic       set_10;
      logic [1:0] mac_eccstatus;
      logic [1:0] pcs_eccstatus;
      logic       unidirectional_remote_fault_dis;
      logic       unidirectional_force_remote_fault;
      logic       remote_fault_status;
      logic       local_fault_status;
      logic       unidirectional_en;
      logic       link_fault_gen_en;
      logic       rx_block_lock;
      logic       rx_am_lock;
      logic       cdr_lock;
      logic       rx_hi_ber;
      logic       ehip_ready;
   } hssi_port_status_t;

endpackage

`endif
