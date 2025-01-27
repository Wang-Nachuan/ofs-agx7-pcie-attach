// Copyright (C) 2021 Intel Corporation.
// SPDX-License-Identifier: MIT

//
// Description
//-----------------------------------------------------------------------------
// AFU module instantiates User Logic
//-----------------------------------------------------------------------------
`ifdef INCLUDE_HSSI
   `include "ofs_fim_eth_plat_defines.svh"
`endif

module afu_top
#(
   parameter PCIE_NUM_LINKS = 1,
   parameter AFU_MEM_CHANNEL = 1
)(
   input wire                            SYS_REFCLK,
   input wire                            clk,
   input wire [PCIE_NUM_LINKS-1:0]       rst_n,
   input wire                            clk_div2,
   input wire                            clk_div4,

   input wire                            clk_csr,
   input wire [PCIE_NUM_LINKS-1:0]       rst_n_csr,
   input wire                            pwr_good_csr_clk_n,
   input wire                            clk_50m,
   input wire [PCIE_NUM_LINKS-1:0]       rst_n_50m,

   input wire                            cpri_refclk_184_32m, // CPRI reference clock 184.32 MHz
   input wire                            cpri_refclk_153_6m , // CPRI reference clock 153.6 MHz

   // FLR
   input  pcie_ss_axis_pkg::t_axis_pcie_flr pcie_flr_req [PCIE_NUM_LINKS-1:0],
   output pcie_ss_axis_pkg::t_axis_pcie_flr pcie_flr_rsp [PCIE_NUM_LINKS-1:0],
   output logic                          pr_parity_error,
   input  pcie_ss_axis_pkg::t_pcie_tag_mode tag_mode [PCIE_NUM_LINKS-1:0],

   ofs_fim_axi_lite_if.master            apf_bpf_slv_if,
   ofs_fim_axi_lite_if.slave             apf_bpf_mst_if,

`ifdef INCLUDE_UART
   // UART
   ofs_uart_if.source	host_uart_if,
`endif

`ifdef INCLUDE_LOCAL_MEM
   ofs_fim_emif_axi_mm_if.user         ext_mem_if [AFU_MEM_CHANNEL-1:0],
`endif

`ifdef INCLUDE_HPS
   //HPS Interfaces
   ofs_fim_axi_mmio_if.slave            hps_axi4_mm_if ,
   ofs_fim_ace_lite_if.master           hps_ace_lite_if,
   input                                h2f_reset,
`endif

`ifdef INCLUDE_HSSI
   ofs_fim_hssi_ss_tx_axis_if.client      hssi_ss_st_tx [ofs_fim_eth_if_pkg::MAX_NUM_ETH_CHANNELS-1:0],
   ofs_fim_hssi_ss_rx_axis_if.client      hssi_ss_st_rx [ofs_fim_eth_if_pkg::MAX_NUM_ETH_CHANNELS-1:0],
   ofs_fim_hssi_fc_if.client              hssi_fc [ofs_fim_eth_if_pkg::MAX_NUM_ETH_CHANNELS-1:0],
   input logic [ofs_fim_eth_if_pkg::MAX_NUM_ETH_CHANNELS-1:0] i_hssi_clk_pll,
`endif

   // PCIE AXI-S interfaces
   pcie_ss_axis_if.sink                  pcie_ss_axis_rxreq [PCIE_NUM_LINKS-1:0],
   pcie_ss_axis_if.sink                  pcie_ss_axis_rx    [PCIE_NUM_LINKS-1:0],
   pcie_ss_axis_if.source                pcie_ss_axis_tx    [PCIE_NUM_LINKS-1:0],
   pcie_ss_axis_if.source                pcie_ss_axis_txreq [PCIE_NUM_LINKS-1:0]
);

//-----------------------------------------------------------------------------------------------
// Local configuration
//-----------------------------------------------------------------------------------------------
import ofs_fim_cfg_pkg::*;
import top_cfg_pkg::*;
import pcie_ss_axis_pkg::*;

localparam MM_ADDR_WIDTH        = ofs_fim_cfg_pkg::MMIO_ADDR_WIDTH;
localparam MM_DATA_WIDTH        = ofs_fim_cfg_pkg::MMIO_DATA_WIDTH;
localparam NONPF0_MM_ADDR_WIDTH = ofs_fim_cfg_pkg::NONPF0_MMIO_ADDR_WIDTH;

localparam PCIE_TDATA_WIDTH     = ofs_fim_cfg_pkg::PCIE_TDATA_WIDTH;
localparam PCIE_TUSER_WIDTH     = ofs_fim_cfg_pkg::PCIE_TUSER_WIDTH;

localparam NUM_MUX_PORTS        = top_cfg_pkg::NUM_TOP_PORTS;
localparam NUM_RTABLE_ENTRIES   = top_cfg_pkg::NUM_TOP_RTABLE_ENTRIES;
localparam t_top_pf_vf_entry_info PFVF_ROUTING_TABLE = top_cfg_pkg::TOP_PF_VF_RTABLE;

// Link 0 PF0 is the management function
localparam LINK_0 = 0;

//-----------------------------------------------------------------------------------------------
// Internal signals
//-----------------------------------------------------------------------------------------------
// AXI-ST TLP interfaces
pcie_ss_axis_if #(
   .DATA_W (PCIE_TDATA_WIDTH),
   .USER_W (PCIE_TUSER_WIDTH))
   // Host channel transformation interface
   mx2ho_tx_port     [PCIE_NUM_LINKS-1:0]                    (.clk(clk)),
   ho2mx_rxreq_port  [PCIE_NUM_LINKS-1:0]                    (.clk(clk));

// TX request interface (only DMRd, DMIntr)
pcie_ss_axis_if #(
   .DATA_W (pcie_ss_hdr_pkg::HDR_WIDTH),
   .USER_W (PCIE_TUSER_WIDTH))
   mx2ho_txreq_port [PCIE_NUM_LINKS-1:0] (.clk (clk));


// PCIe routing destinations
pcie_ss_axis_if #(.DATA_W(PCIE_TDATA_WIDTH),
                  .USER_W(PCIE_TUSER_WIDTH))
   // Static region AFU interfaces
   pf0_tx_a [PCIE_NUM_LINKS-1:0] (.clk),
   pf0_rx_a [PCIE_NUM_LINKS-1:0] (.clk),
   pf0_tx_b [PCIE_NUM_LINKS-1:0] (.clk),
   pf0_rx_b [PCIE_NUM_LINKS-1:0] (.clk),

   sr_tx_a  [PCIE_NUM_LINKS-1:0] (.clk),
   sr_rx_a  [PCIE_NUM_LINKS-1:0] (.clk),
   sr_tx_b  [PCIE_NUM_LINKS-1:0] (.clk),
   sr_rx_b  [PCIE_NUM_LINKS-1:0] (.clk),
   // PR region AFU interfaces
   pg_tx_a  [PCIE_NUM_LINKS-1:0] (.clk),
   pg_rx_a  [PCIE_NUM_LINKS-1:0] (.clk),
   pg_tx_b  [PCIE_NUM_LINKS-1:0] (.clk),
   pg_rx_b  [PCIE_NUM_LINKS-1:0] (.clk);

   t_axis_pcie_flr pf0_flr_req [PCIE_NUM_LINKS-1:0];
   t_axis_pcie_flr pf0_flr_rsp [PCIE_NUM_LINKS-1:0];

   t_axis_pcie_flr sr_flr_req  [PCIE_NUM_LINKS-1:0];
   t_axis_pcie_flr sr_flr_rsp  [PCIE_NUM_LINKS-1:0];

   t_axis_pcie_flr pg_flr_req  [PCIE_NUM_LINKS-1:0];
   t_axis_pcie_flr pg_flr_rsp  [PCIE_NUM_LINKS-1:0];


generate for (genvar l = 0; l < PCIE_NUM_LINKS; l++) begin : pcie_rst
      assign mx2ho_tx_port[l].rst_n    = rst_n[l];
      assign ho2mx_rxreq_port[l].rst_n = rst_n[l];
      assign mx2ho_txreq_port[l].rst_n = rst_n[l];
      assign pf0_tx_a[l].rst_n         = rst_n[l];
      assign pf0_rx_a[l].rst_n         = rst_n[l];
      assign pf0_tx_b[l].rst_n         = rst_n[l];
      assign pf0_rx_b[l].rst_n         = rst_n[l];
      assign sr_tx_a[l].rst_n          = rst_n[l];
      assign sr_rx_a[l].rst_n          = rst_n[l];
      assign sr_tx_b[l].rst_n          = rst_n[l];
      assign sr_rx_b[l].rst_n          = rst_n[l];
      assign pg_tx_a[l].rst_n          = rst_n[l];
      assign pg_rx_a[l].rst_n          = rst_n[l];
      assign pg_tx_b[l].rst_n          = rst_n[l];
      assign pg_rx_b[l].rst_n          = rst_n[l];
end
endgenerate

// AXI4-lite interfaces
ofs_fim_axi_lite_if #(.AWADDR_WIDTH(MM_ADDR_WIDTH), .ARADDR_WIDTH(MM_ADDR_WIDTH)) apf_st2mm_mst_if (.clk(clk), .rst_n(rst_n[LINK_0]));
ofs_fim_axi_lite_if #(.AWADDR_WIDTH(16), .ARADDR_WIDTH(16))                       apf_st2mm_slv_if (.clk(clk), .rst_n(rst_n[LINK_0]));
ofs_fim_axi_lite_if #(.AWADDR_WIDTH(16), .ARADDR_WIDTH(16))                       apf_pgsk_slv_if  (.clk(clk), .rst_n(rst_n[LINK_0]));
ofs_fim_axi_lite_if #(.AWADDR_WIDTH(MM_ADDR_WIDTH), .ARADDR_WIDTH(MM_ADDR_WIDTH)) apf_mctp_mst_if  (.clk(clk), .rst_n(rst_n[LINK_0]));
ofs_fim_axi_lite_if #(.AWADDR_WIDTH(MM_ADDR_WIDTH), .ARADDR_WIDTH(MM_ADDR_WIDTH)) apf_uart_mst_if  (.clk(clk), .rst_n(rst_n[LINK_0]));
ofs_fim_axi_lite_if #(.AWADDR_WIDTH(12), .ARADDR_WIDTH(12))                       apf_uart_slv_if  (.clk(clk), .rst_n(rst_n[LINK_0]));
ofs_fim_axi_lite_if #(.AWADDR_WIDTH(16), .ARADDR_WIDTH(16))                       apf_achk_slv_if  (.clk(clk), .rst_n(rst_n[LINK_0]));
ofs_fim_axi_lite_if #(.AWADDR_WIDTH(16), .ARADDR_WIDTH(16))                       apf_tod_slv_if   (.clk(clk), .rst_n(rst_n[LINK_0]));

// Parity for PF/VF mux
logic [1:0] pf_vf_fifo_err;
logic [1:0] pf_vf_fifo_perr;

// Protocol checker signals
logic       sel_mmio_rsp;
logic       read_flush_done;
logic       afu_softreset;

//-----------------------------------------------------------------------------------------------
// Preserve clocks
//-----------------------------------------------------------------------------------------------
// Make sure all clocks are consumed, in case AFUs don't use them,
// to avoid Quartus problems.
(* noprune *) logic clk_div2_q1, clk_div2_q2;

always_ff @(posedge clk_div2) begin
   clk_div2_q1 <= clk_div2_q2;
   clk_div2_q2 <= !clk_div2_q1;
end

//-----------------------------------------------------------------------------------------------
//                                  Modules instances
//-----------------------------------------------------------------------------------------------
// PF/VF Top-level routing Table
//
//    +---------------------------------+
//    + Module          | PF/VF         +
//    +---------------------------------+
//    | ST2MM           | PF0           |
//    | PG-AFU          | PF0-VF0-2     |
//    |    HE-MEM       |    -VF0       |
//    |    HE-HSSI      |    -VF1       |
//    |    HE-MEM_TG    |    -VF2       |
//    | SR-AFU          | PF1-4+        |
//    |    HE-NULL      |    -PF1       |
//    |    HE-LB        |    -PF2       |
//    |    VIO-Stub     |    -PF3       |
//    |    Copy Engine  |    -PF4       |
//    |    HE-NULL      |    -PF5+      |
//    +---------------------------------+
//
//-------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------
// FLR routing
//-----------------------------------------------------------------------------------------------
// Route FLR requests to their respective PF/VF ports.
//-----------------------------------------------------------------------------------------------
t_axis_pcie_flr afu_flr_req [PCIE_NUM_LINKS-1:0][NUM_MUX_PORTS-1:0];
t_axis_pcie_flr afu_flr_rsp [PCIE_NUM_LINKS-1:0][NUM_MUX_PORTS-1:0];

generate for (genvar l = 0; l < PCIE_NUM_LINKS; l++) begin : afu_pcie_flr
t_axis_pcie_flr afu_flr_req [NUM_MUX_PORTS-1:0];
t_axis_pcie_flr afu_flr_rsp [NUM_MUX_PORTS-1:0];
flr_mux #(
   .NUM_PORT           (NUM_MUX_PORTS),
   .NUM_RTABLE_ENTRIES (NUM_RTABLE_ENTRIES),
   .PFVF_ROUTING_TABLE (PFVF_ROUTING_TABLE)
) flr_mux_inst (
   .clk       (clk_csr),
   .rst_n     (rst_n_csr    [l]),
   .h_flr_req (pcie_flr_req [l]),
   .h_flr_rsp (pcie_flr_rsp [l]),
   .a_flr_req (afu_flr_req     ),
   .a_flr_rsp (afu_flr_rsp     )
);
// Connect static region AFU FLR
assign pf0_flr_req[l] = afu_flr_req[PF0_MGMT_PID];
assign afu_flr_rsp[PF0_MGMT_PID] = pf0_flr_rsp[l];

if (top_cfg_pkg::NUM_SR_PORTS > 0) begin : sr_port
   assign sr_flr_req[l] = afu_flr_req[SR_SHARED_PFVF_PID];
   assign afu_flr_rsp[SR_SHARED_PFVF_PID] = sr_flr_rsp[l];
end

// Connect PR region AFU FLR
if (top_cfg_pkg::PG_AFU_NUM_PORTS > 0) begin : pg_port
   assign pg_flr_req[l] = afu_flr_req[PG_SHARED_VF_PID];
   assign afu_flr_rsp[PG_SHARED_VF_PID] = pg_flr_rsp[l];
end

end : afu_pcie_flr
endgenerate

//-----------------------------------------------------------------------------------------------
// PCIe ATS (address translation service) default invalidation handler
//-----------------------------------------------------------------------------------------------
// When ATS is enabled on a function, the host will send invalidation requests
// whenever a portion of the address space changes. ATS invalidation responses
// are required or the host may crash. After reset, the default module instantiated
// here responds to ATS invalidations on all functions. If an ATS request from
// the FPGA is seen on the AFU to host i_tx_if, the ats_inval module here stops
// responding for the function until the next function-level reset. As soon as
// a function requests a translation it becomes responsible for responding to
// ATS invalidations.
//
// When ATS is not enabled in the design the module just wires together the tx
// and rxreq interfaces.
//
// The module is instantiated very close to the PCIe device to ensure that ATS
// invalidations are generated even when the FIM is in an error state.
//-----------------------------------------------------------------------------------------------
pcie_ss_axis_if#(.DATA_W(PCIE_TDATA_WIDTH),
                 .USER_W(PCIE_TUSER_WIDTH)) intf2ats_tx [PCIE_NUM_LINKS-1:0] (.clk);
pcie_ss_axis_if#(.DATA_W(PCIE_TDATA_WIDTH),
                 .USER_W(PCIE_TUSER_WIDTH)) ats2intf_rx [PCIE_NUM_LINKS-1:0] (.clk);

generate for (genvar l = 0; l < PCIE_NUM_LINKS; l++) begin : afu_pcie_ats_inval

   assign intf2ats_tx[l].rst_n = rst_n[l];
   assign ats2intf_rx[l].rst_n = rst_n[l];

ofs_fim_pcie_ats_inval_cpl ats_inval
  (
   .clk          (clk),
   .rst_n        (rst_n[l]),
   // Clocks for pcie_flr_req
   .clk_csr      (clk_csr),
   .rst_n_csr    (rst_n_csr[l]),

   // Function-level reset requests, used to reenable ATS invalidation responses
   // until an ATS request is seen from an AFU. No FLR response is generated
   // here.
   .pcie_flr_req (pcie_flr_req[l]),

   // PCIe SS connections -- only those needed for PU-encoded ATS messages
   .o_tx_if      (pcie_ss_axis_tx[l]),
   .i_rxreq_if   (pcie_ss_axis_rxreq[l]),
   // FIM connections
   .i_tx_if      (intf2ats_tx[l]),
   .o_rxreq_if   (ats2intf_rx[l])
   );
end // block: afu_pcie_ats_inval
endgenerate
//-----------------------------------------------------------------------------------------------
// AFU Interface and Protocol Checker
//-----------------------------------------------------------------------------------------------
// Provides protection to the host PCIe channel from erroneous downstream behavior including:
//    - Malformed requests
//    - Data overrun/underrun
//    - Unsolicited completions
//    - Completion timeouts
//-----------------------------------------------------------------------------------------------

afu_intf #(
   .ENABLE (1'b1),
   // The tag mapper is free to use all available tags in the
   // PCIe SS, independent of the limit imposed on AFUs by
   // ofs_pcie_ss_cfg_pkg::PCIE_EP_MAX_TAGS. The maximum tag
   // value has to take into account that 10 bit mode tags
   // shift to 256 and above.
   .PCIE_EP_MAX_TAGS (ofs_pcie_ss_cfg_pkg::PCIE_TILE_MAX_TAGS + 256)
) afu_intf_inst (
   .clk                (clk),
   /* .rst_n              (rst_n[LINK0]), */
   .rst_n              (rst_n[LINK_0]),

   .clk_csr            (clk_csr), // Clock 100 MHz
   .rst_n_csr          (rst_n_csr[LINK_0]),
   .pwr_good_csr_clk_n (pwr_good_csr_clk_n),

   .i_afu_softreset    (afu_softreset),

   .o_sel_mmio_rsp     ( sel_mmio_rsp    ),
   .o_read_flush_done  ( read_flush_done ),

   // MMIO req
   .h2a_axis_rx        ( ats2intf_rx        [LINK_0] ),
   .a2h_axis_tx        ( intf2ats_tx        [LINK_0] ),
   .a2h_axis_txreq     ( pcie_ss_axis_txreq [LINK_0] ),

   .afu_axis_rx        ( ho2mx_rxreq_port   [LINK_0] ),
   .afu_axis_tx        ( mx2ho_tx_port      [LINK_0] ),
   .afu_axis_txreq     ( mx2ho_txreq_port   [LINK_0] ),

   .csr_if             ( apf_achk_slv_if )
);


   // TODO: This bypasses the protocol checker for physical interfaces > 1. The protocol checker does not support multi-link configurations.

generate for(genvar l = 1; l < PCIE_NUM_LINKS; l++) begin : chkr_bypass
   ofs_fim_axis_pipeline #(.PL_DEPTH(0)) rxreq (.clk, .rst_n(rst_n[l]), .axis_s(ats2intf_rx      [l]), .axis_m(ho2mx_rxreq_port   [l]));
   ofs_fim_axis_pipeline #(.PL_DEPTH(0)) tx    (.clk, .rst_n(rst_n[l]), .axis_s(mx2ho_tx_port    [l]), .axis_m(intf2ats_tx        [l]));
   ofs_fim_axis_pipeline #(.PL_DEPTH(0)) txreq (.clk, .rst_n(rst_n[l]), .axis_s(mx2ho_txreq_port [l]), .axis_m(pcie_ss_axis_txreq [l]));
end : chkr_bypass
endgenerate

//-----------------------------------------------------------------------------------------------
// AFU host fabric
//-----------------------------------------------------------------------------------------------
//    - Host channel interface transformations
//    - PF/VF Routing
//-----------------------------------------------------------------------------------------------

// Transformations required by the host PCIe interface:
//    - Tag remapping: remap posted transaction tags to a unique tag from a shared tag pool.
//
//    - routing & arbitration: Route DMRd from "B" Port to TXREQ
//                             arbitrate other traffic channels to TX
generate for (genvar l = 0; l < PCIE_NUM_LINKS; l++) begin : afu_pcie_routing
pcie_ss_axis_if#(.DATA_W(PCIE_TDATA_WIDTH),
                 .USER_W(PCIE_TUSER_WIDTH))
   // Tag remapper
   ho2mx_rx_remap                        (.clk(clk), .rst_n(rst_n[l])),
   ho2mx_rxreq_remap                     (.clk(clk), .rst_n(rst_n[l])),
   mx2ho_tx_remap[2]                     (.clk(clk), .rst_n(rst_n[l])),
   // PF/VF Mux "A" ports
   mx2fn_rx_a_port   [NUM_MUX_PORTS-1:0] (.clk(clk), .rst_n(rst_n[l])),
   fn2mx_tx_a_port   [NUM_MUX_PORTS-1:0] (.clk(clk), .rst_n(rst_n[l])),
   // PF/VF Mux "B" ports
   mx2fn_rx_b_port   [NUM_MUX_PORTS-1:0] (.clk(clk), .rst_n(rst_n[l])),
   fn2mx_tx_b_port   [NUM_MUX_PORTS-1:0] (.clk(clk), .rst_n(rst_n[l]));


afu_host_channel afu_host_channel_inst (
   .clk               (clk),
   .rst_n             (rst_n             [l]),
   .ho2mx_rx_port     (pcie_ss_axis_rx   [l]),
   .mx2ho_tx_port     (mx2ho_tx_port     [l]),
   .mx2ho_txreq_port  (mx2ho_txreq_port  [l]),
   .ho2mx_rxreq_port  (ho2mx_rxreq_port  [l]),
   .tag_mode          (tag_mode          [l]),
   .ho2mx_rx_remap    (ho2mx_rx_remap       ),
   .ho2mx_rxreq_remap (ho2mx_rxreq_remap    ),
   .mx2ho_tx_remap    (mx2ho_tx_remap       )
);

// Primary PF/VF MUX ("A" ports). Map individual TX A ports from
// AFUs down to a single, merged A channel. The RX port from host
// to FPGA is demultiplexed and individual connections are forwarded
// to AFUs.
pf_vf_mux_tree #(
   .MUX_NAME("A"),
   .NUM_PORT(NUM_MUX_PORTS),
   .NUM_RTABLE_ENTRIES(NUM_RTABLE_ENTRIES),
   .PFVF_ROUTING_TABLE(PFVF_ROUTING_TABLE)
) pf_vf_mux_a (
   .clk             (clk               ),
   .rst_n           (rst_n[l]          ),
   .ho2mx_rx_port   (ho2mx_rxreq_remap ),
   .mx2ho_tx_port   (mx2ho_tx_remap[0] ),
   .mx2fn_rx_port   (mx2fn_rx_a_port   ),
   .fn2mx_tx_port   (fn2mx_tx_a_port   ),
   .out_fifo_err    ( ),
   .out_fifo_perr   ( )
);

// Secondary PF/VF MUX ("B" ports). Only TX is implemented, since a
// single RX stream is sufficient. The RX input to the MUX is tied off.
// AFU B TX ports are multiplexed into a single TX B channel that is
// passed to the A/B MUX above.
pf_vf_mux_tree #(
   .MUX_NAME ("B"),
   .NUM_PORT(NUM_MUX_PORTS),
   .NUM_RTABLE_ENTRIES(NUM_RTABLE_ENTRIES),
   .PFVF_ROUTING_TABLE(PFVF_ROUTING_TABLE)
) pf_vf_mux_b (
   .clk             (clk               ),
   .rst_n           (rst_n[l]          ),
   .ho2mx_rx_port   (ho2mx_rx_remap    ),
   .mx2ho_tx_port   (mx2ho_tx_remap[1] ),
   .mx2fn_rx_port   (mx2fn_rx_b_port   ),
   .fn2mx_tx_port   (fn2mx_tx_b_port   ),
   .out_fifo_err    ( ),
   .out_fifo_perr   ( )
);

// Connect the PF0 port
   ofs_fim_axis_pipeline #(.PL_DEPTH(0)) conn_pf0_rx_a (.clk, .rst_n(rst_n[l]), .axis_s(mx2fn_rx_a_port[PF0_MGMT_PID]), .axis_m(pf0_rx_a[l]));
   ofs_fim_axis_pipeline #(.PL_DEPTH(0)) conn_pf0_rx_b (.clk, .rst_n(rst_n[l]), .axis_s(mx2fn_rx_b_port[PF0_MGMT_PID]), .axis_m(pf0_rx_b[l]));
   ofs_fim_axis_pipeline #(.PL_DEPTH(0)) conn_pf0_tx_a (.clk, .rst_n(rst_n[l]), .axis_s(pf0_tx_a[l]), .axis_m(fn2mx_tx_a_port[PF0_MGMT_PID]));
   ofs_fim_axis_pipeline #(.PL_DEPTH(0)) conn_pf0_tx_b (.clk, .rst_n(rst_n[l]), .axis_s(pf0_tx_b[l]), .axis_m(fn2mx_tx_b_port[PF0_MGMT_PID]));

// Connect the generated routing to the static region port
if (top_cfg_pkg::NUM_SR_PORTS > 0) begin : sr_port
   ofs_fim_axis_pipeline #(.PL_DEPTH(1)) conn_sr_rx_a (.clk, .rst_n(rst_n[l]), .axis_s(mx2fn_rx_a_port[SR_SHARED_PFVF_PID]), .axis_m(sr_rx_a[l]));
   ofs_fim_axis_pipeline #(.PL_DEPTH(1)) conn_sr_rx_b (.clk, .rst_n(rst_n[l]), .axis_s(mx2fn_rx_b_port[SR_SHARED_PFVF_PID]), .axis_m(sr_rx_b[l]));
   ofs_fim_axis_pipeline #(.PL_DEPTH(1)) conn_sr_tx_a (.clk, .rst_n(rst_n[l]), .axis_s(sr_tx_a[l]), .axis_m(fn2mx_tx_a_port[SR_SHARED_PFVF_PID]));
   ofs_fim_axis_pipeline #(.PL_DEPTH(1)) conn_sr_tx_b (.clk, .rst_n(rst_n[l]), .axis_s(sr_tx_b[l]), .axis_m(fn2mx_tx_b_port[SR_SHARED_PFVF_PID]));
end else begin
   // Tie-off
   assign sr_tx_a[l].tvalid = '0;
   assign sr_tx_b[l].tvalid = '0;
   assign sr_rx_a[l].tvalid = '0;
   assign sr_rx_b[l].tvalid = '0;
   assign sr_tx_a[l].tready = '1;
   assign sr_tx_b[l].tready = '1;
   assign sr_rx_a[l].tready = '1;
   assign sr_rx_b[l].tready = '1;
end

// Connect the generated routing to the PR region port
if (top_cfg_pkg::PG_AFU_NUM_PORTS > 0) begin : pg_port
   ofs_fim_axis_pipeline #(.PL_DEPTH(1)) conn_pg_rx_a (.clk, .rst_n(rst_n[l]), .axis_s(mx2fn_rx_a_port[PG_SHARED_VF_PID]), .axis_m(pg_rx_a[l]));
   ofs_fim_axis_pipeline #(.PL_DEPTH(1)) conn_pg_rx_b (.clk, .rst_n(rst_n[l]), .axis_s(mx2fn_rx_b_port[PG_SHARED_VF_PID]), .axis_m(pg_rx_b[l]));
   ofs_fim_axis_pipeline #(.PL_DEPTH(1)) conn_pg_tx_a (.clk, .rst_n(rst_n[l]), .axis_s(pg_tx_a[l]), .axis_m(fn2mx_tx_a_port[PG_SHARED_VF_PID]));
   ofs_fim_axis_pipeline #(.PL_DEPTH(1)) conn_pg_tx_b (.clk, .rst_n(rst_n[l]), .axis_s(pg_tx_b[l]), .axis_m(fn2mx_tx_b_port[PG_SHARED_VF_PID]));
end else begin
   assign pg_tx_a[l].tvalid = '0;
   assign pg_tx_b[l].tvalid = '0;
   assign pg_rx_a[l].tvalid = '0;
   assign pg_rx_b[l].tvalid = '0;
   assign pg_tx_a[l].tready = '1;
   assign pg_tx_b[l].tready = '1;
   assign pg_rx_a[l].tready = '1;
   assign pg_rx_b[l].tready = '1;
end

end : afu_pcie_routing
endgenerate

//-----------------------------------------------------------------------------------------------
// PCIe Streaming-to-AXI-Lite (ST2MM)
//-----------------------------------------------------------------------------------------------
// ST2MM translates the PCIe Subsystem TLP-over-AXI-ST channel to AXI-Lite transfers. This feature
// is required to be routed to PF0 on Link 0, which is reflected in the default routing configuration:
// top_cfg_pkg::TOP_PF_VF_RTABLE
//
// This block maps all MMIO transfers to the `axi_m_if` port which manages device features connected
// to APF/BPF. Management Component Transport Protocol (MCTP) messages are mapped to the
// `axi_m_pmci_vdm_if` port and routed through the peripheral fabric components to the PMCI feature
// VDM_OFFSET address region.
//-----------------------------------------------------------------------------------------------
st2mm #(
   .PF_NUM          (0),
   .VF_NUM          (0),
   .VF_ACTIVE       (0),
   .MM_ADDR_WIDTH   (MM_ADDR_WIDTH),
   .MM_DATA_WIDTH   (MM_DATA_WIDTH),
   .PMCI_BASEADDR   (fabric_width_pkg::bpf_pmci_slv_baseaddress),
   .TX_VDM_OFFSET   (16'h2000),
   .RX_VDM_OFFSET   (16'h2000),
   .READ_ALLOWANCE  (1),
   .WRITE_ALLOWANCE (1),
   .FEAT_ID         (12'h14),
   .FEAT_VER        (4'h0),
   .END_OF_LIST     (fabric_width_pkg::apf_st2mm_slv_eol),
   .NEXT_DFH_OFFSET (fabric_width_pkg::apf_st2mm_slv_next_dfh_offset)
) st2mm (
   .clk               (clk               ),
   .rst_n             (rst_n     [LINK_0]),
   .clk_csr           (clk_csr           ),
   .rst_n_csr         (rst_n_csr [LINK_0]),
   .axis_rx_if        (pf0_rx_a  [LINK_0]),
   .axis_tx_if        (pf0_tx_a  [LINK_0]),
   .axi_m_pmci_vdm_if (apf_mctp_mst_if   ),
   .axi_m_if          (apf_st2mm_mst_if  ),
   .axi_s_if          (apf_st2mm_slv_if  )
);
// Tie-off TX/RX B port
assign pf0_tx_b[LINK_0].tvalid = 1'b0;
assign pf0_rx_b[LINK_0].tready = 1'b1;

// FLR has no meaning for PCIe link 0 PF0 management, but must propagate to VFs in pg_afu
logic pf0_flr_rst_n [PCIE_NUM_LINKS-1:0];
logic pg_flr_rst_n  [PCIE_NUM_LINKS-1:0];

generate for (genvar l = 1; l < PCIE_NUM_LINKS; l++) begin : pcie_pf0_null
   // Attach a null component to each PCIe Link PF0. VF creation requires the driver to bind,
   // which requires a discoverable feature
   he_null #(
      .PF_ID     (0),
      .VF_ID     (0),
      .VF_ACTIVE (0)
   ) he_null_pf0 (
      .clk     (clk),
      .rst_n   (pf0_flr_rst_n   [l]),
      .i_rx_if (pf0_rx_a        [l]),
      .o_tx_if (pf0_tx_a        [l])
   );
   // AFU does not have TX/RX B port
   assign pf0_tx_b[l].tvalid = 1'b0;
   assign pf0_rx_b[l].tready = 1'b1;
end : pcie_pf0_null
endgenerate

generate for(genvar l = 0; l < PCIE_NUM_LINKS; l++) begin : pcie_pf0_flr
flr_rst_mgr #(
   .NUM_PF (1),
   .NUM_VF (0),
   .MAX_NUM_VF (0)
) pf0_flr (
   .clk_sys      (clk),
   .rst_n_sys    (rst_n         [l]),
   .clk_csr      (clk_csr),
   .rst_n_csr    (rst_n_csr     [l]),
   .pcie_flr_req (pf0_flr_req   [l]),
   .pcie_flr_rsp (pf0_flr_rsp   [l]),
   .pf_flr_rst_n (pf0_flr_rst_n [l])
);
assign pg_flr_rst_n[l] = (top_cfg_pkg::PG_VFS > 0) ? pf0_flr_rst_n[l] : 1'b1;
end : pcie_pf0_flr
endgenerate

//-----------------------------------------------------------------------------------------------
// Static Region (SR) AFU (fim_afu_instances)
//-----------------------------------------------------------------------------------------------
// This block implements the static region AFU. In the reference implementation separate
// physical interfaces are created for each function mapped to this region. They are ST2MM (PF0)
// and HE-LB (PF1). For the SoC attach design the host attached side only implements static region
// logic.
//-----------------------------------------------------------------------------------------------
generate if(top_cfg_pkg::NUM_SR_PORTS > 0) begin : sr_afu
   fim_afu_instances #(
      .NUM_PF             (top_cfg_pkg::FIM_NUM_PF),
      .NUM_VF             (top_cfg_pkg::FIM_NUM_VF),
      .MAX_NUM_VF         (top_cfg_pkg::FIM_MAX_NUM_VF),
      .NUM_MUX_PORTS      (top_cfg_pkg::NUM_SR_RTABLE_ENTRIES),
      .PFVF_ROUTING_TABLE (top_cfg_pkg::SR_PF_VF_RTABLE),
      .PCIE_NUM_LINKS     (PCIE_NUM_LINKS)
   ) fim_afu_instances (
      .clk               (clk),
      .rst_n             (rst_n),

      .flr_req           (sr_flr_req),
      .flr_rsp           (sr_flr_rsp),

      .clk_csr           (clk_csr),
      .rst_n_csr         (rst_n_csr),

`ifdef INCLUDE_HPS
      .hps_axi4_mm_if    (hps_axi4_mm_if),
      .hps_ace_lite_if   (hps_ace_lite_if),
      .h2f_reset         (h2f_reset),
`endif
      .afu_axi_rx_a_if     (sr_rx_a),
      .afu_axi_tx_a_if     (sr_tx_a),
      .afu_axi_rx_b_if     (sr_rx_b),
      .afu_axi_tx_b_if     (sr_tx_b)
   );
end : sr_afu
endgenerate

//-----------------------------------------------------------------------------------------------
// Port Gasket (PG) AFU
//-----------------------------------------------------------------------------------------------
// The port gasket implements the Partial Reconfiguration (PR) region AFU and supporting
// infrastucture including freeze bridges, the PR controller feature, user clock feature, and remote
// signal tap feature. The reference implementation connects a single physical interface routed to
// 3VFs on PF0. In the PR region the VFs are then routed to HE-MEM (PF0-VF0), HE-HSSI(PF0-VF1),
// and MEM-TG (PF0-VF2). The reference routing table is provided in $OFS_ROOTDIR/afu_top/mux/top_cfg_pkg.sv
//-----------------------------------------------------------------------------------------------
localparam PG_NUM_RTABLE_ENTRIES = top_cfg_pkg::PG_NUM_RTABLE_ENTRIES;
localparam t_prr_pf_vf_entry_info PG_PFVF_ROUTING_TABLE = top_cfg_pkg::PG_PF_VF_RTABLE;

typedef pcie_ss_hdr_pkg::ReqHdr_pf_vf_info_t[PG_AFU_NUM_PORTS-1:0] t_afu_prr_pf_vf_map;
function automatic t_afu_prr_pf_vf_map gen_prr_pf_vf_map();
   t_afu_prr_pf_vf_map map;
   for (int p = 0; p < PG_AFU_NUM_PORTS; p = p + 1) begin
      map[p].pf_num = PG_PFVF_ROUTING_TABLE[p].pf;
      map[p].vf_num = PG_PFVF_ROUTING_TABLE[p].vf;
      map[p].vf_active = PG_PFVF_ROUTING_TABLE[p].vf_active;
      map[p].link_num = 0;
   end
   return map;
endfunction // gen_pf_vf_map

localparam pcie_ss_hdr_pkg::ReqHdr_pf_vf_info_t[PG_AFU_NUM_PORTS-1:0] PG_PF_VF_INFO =
   gen_prr_pf_vf_map();


generate if (PG_AFU_NUM_PORTS > 0) begin : pg_afu
port_gasket #(
   .PG_NUM_LINKS(PCIE_NUM_LINKS),
   .PG_NUM_PORTS(PG_AFU_NUM_PORTS),              // Number of PCIe ports to PR region
   .PORT_PF_VF_INFO(PG_PF_VF_INFO),              // PCIe port data
   .NUM_MEM_CH(AFU_MEM_CHANNEL),                 // Number of Memory Porst to PR region
   .END_OF_LIST    (fabric_width_pkg::apf_pr_slv_eol),                       // port_gasket DFH end of list field
   .NEXT_DFH_OFFSET(fabric_width_pkg::apf_pr_slv_next_dfh_offset),                   // Next offset in OFS management DFH
   .PG_NUM_RTABLE_ENTRIES (PG_NUM_RTABLE_ENTRIES),
   .PG_PFVF_ROUTING_TABLE (PG_PFVF_ROUTING_TABLE)
) port_gasket (
   .refclk             (SYS_REFCLK),            // 100 MHz refclk for user clk pll
   .clk,                                        // PCIe Clk
   .clk_div2,                                   // Half frequency of PCIe clk
   .clk_div4,                                   // Quarter frequency of PCIe clk
   .clk_100            (clk_csr),               // 100 MHz for user clk logic
   .clk_csr            (clk_csr),               // 100 MHz CSR interface clock

   .rst_n              (rst_n     [LINK_0]),    // Reset from hip
   .rst_n_100          (rst_n_csr [LINK_0]),    // Reset from hip on csr clk
   .rst_n_csr          (rst_n_csr [LINK_0]),    // Reset from hip on csr clk

   // FLR interface
   .pg_pf_flr_rst_n    (pg_flr_rst_n),
   .flr_req            (pg_flr_req),
   .flr_rsp            (pg_flr_rsp),

`ifdef INCLUDE_LOCAL_MEM
   .afu_mem_if         (ext_mem_if),             // Memory interface
`endif

`ifdef INCLUDE_HSSI                               // Instantiates HE-HSSI in PR region
   .hssi_ss_st_tx      (hssi_ss_st_tx),           // HSSI Tx
   .hssi_ss_st_rx      (hssi_ss_st_rx),           // HSSI Rx
   .hssi_fc            (hssi_fc),                 // Flow control interface
   .i_hssi_clk_pll     (i_hssi_clk_pll),          // HSSI clocks
`endif

   .i_sel_mmio_rsp     (sel_mmio_rsp),
   .i_read_flush_done  (read_flush_done),
   .o_afu_softreset    (afu_softreset),
   .o_pr_parity_error  (pr_parity_error),          // Partial Reconfiguration FIFO Parity Error Indication from PR Controller.

   .axi_rx_a_if        (pg_rx_a),
   .axi_tx_a_if        (pg_tx_a),
   .axi_rx_b_if        (pg_rx_b),
   .axi_tx_b_if        (pg_tx_b),

   .axi_s_if           (apf_pgsk_slv_if)        // CSR interface from APF
);
end : pg_afu
else begin
   dummy_csr #(
      .NEXT_DFH_OFFSET  (fabric_width_pkg::apf_pr_slv_next_dfh_offset),
      .END_OF_LIST      (fabric_width_pkg::apf_pr_slv_eol)
   ) emif_dummy_csr (
      .clk         (clk_csr),
      .rst_n       (rst_n_csr[LINK_0]),
      .csr_lite_if (apf_pgsk_slv_if)
   );
end // else: !if(PG_AFU_NUM_PORTS > 0)
endgenerate

//----------------------------------------------------------------
// MCTP management interface
//----------------------------------------------------------------
always_comb
begin
   apf_mctp_mst_if.bready  = 1'b1;
   apf_mctp_mst_if.rready  = 1'b1;
end

//----------------------------------------------------------------
// vUART interface
//----------------------------------------------------------------
`ifdef INCLUDE_UART

   vuart_top # (
                              .ST2MM_DFH_MSIX_ADDR (20'h40000)
   ) vuart_top (
                              .clk_csr       (clk_csr),
                              .rst_n_csr     (rst_n_csr[LINK_0]),
                              .clk_50m       (clk_50m),
                              .rst_n_50m     (rst_n_50m[LINK_0]),
                              .pwr_good_csr_clk_n (pwr_good_csr_clk_n),

                              .csr_lite_m_if (apf_uart_mst_if),
                              .csr_lite_if   (apf_uart_slv_if),
                              .host_uart_if  (host_uart_if)
                              );

`else
dummy_csr #(
   .FEAT_ID          (12'h24),
   .FEAT_VER         (4'h0),
   .NEXT_DFH_OFFSET  (fabric_width_pkg::apf_uart_slv_next_dfh_offset),
   .END_OF_LIST      (fabric_width_pkg::apf_uart_slv_eol)
) uart_dummy_csr (
   .clk         (clk_csr),
   .rst_n       (rst_n_csr[LINK_0]),
   .csr_lite_if (apf_uart_slv_if)
);

always_comb
begin
  apf_uart_mst_if.awaddr   = 21'h0;
  apf_uart_mst_if.awprot   = 3'h0;
  apf_uart_mst_if.awvalid  = 1'b0;
  apf_uart_mst_if.wdata    = 32'h0;
  apf_uart_mst_if.wstrb    = 4'h0;
  apf_uart_mst_if.wvalid   = 1'b0;
  apf_uart_mst_if.bready   = 1'b0;
  apf_uart_mst_if.araddr   = 21'h0;
  apf_uart_mst_if.arprot   = 3'h0;
  apf_uart_mst_if.arvalid  = 1'b0;
  apf_uart_mst_if.rready   = 1'b0;
end


`endif


//-----------------------------------------------------------------------------------------------
// AFU Peripheral Fabric (APF)
//-----------------------------------------------------------------------------------------------
// This is the AXI-Lite interconnect fabric associated with PF0. It contains AFU feature interfaces
// local to this hierarchy (protocol checker, port gasket, etc.) that are part of the device feature
// list (DFL), A board peripheral fabric (BPF) interface that exposes board (top) level features in
// a separate memory map partition (FME, HSSI, Memory, etc.), and services the interconnect
// requirements of the OFS FIM (BPF to PF0 MSIX mailbox, Management Component Transport Protocol
// (MCTP) messages to board management, etc.)
//
// The fabrics are generated using scripts with a text file, with the components and the address
// map, as the input. Please refer to the README in $OFS_ROOTDIR/src/pd_qsys for more details. This
// script also generates the fabric_width_pkg used below so that the widths of address busses are
// consistent with the input specified.
// In order to remove/add components to the DFL list, modify the qsys fabric in
// src/pd_qsys to add/delete the component and then edit the list below to add/remove the interface.
// If adding a component connect up the port to the new instance.
//-----------------------------------------------------------------------------------------------
apf apf(
   .clk_clk               (clk_csr     ),
   .rst_n_reset_n         (rst_n_csr[LINK_0]),

   .apf_bpf_slv_awaddr    (apf_bpf_slv_if.awaddr   ),
   .apf_bpf_slv_awprot    (apf_bpf_slv_if.awprot   ),
   .apf_bpf_slv_awvalid   (apf_bpf_slv_if.awvalid  ),
   .apf_bpf_slv_awready   (apf_bpf_slv_if.awready  ),
   .apf_bpf_slv_wdata     (apf_bpf_slv_if.wdata    ),
   .apf_bpf_slv_wstrb     (apf_bpf_slv_if.wstrb    ),
   .apf_bpf_slv_wvalid    (apf_bpf_slv_if.wvalid   ),
   .apf_bpf_slv_wready    (apf_bpf_slv_if.wready   ),
   .apf_bpf_slv_bresp     (apf_bpf_slv_if.bresp    ),
   .apf_bpf_slv_bvalid    (apf_bpf_slv_if.bvalid   ),
   .apf_bpf_slv_bready    (apf_bpf_slv_if.bready   ),
   .apf_bpf_slv_araddr    (apf_bpf_slv_if.araddr   ),
   .apf_bpf_slv_arprot    (apf_bpf_slv_if.arprot   ),
   .apf_bpf_slv_arvalid   (apf_bpf_slv_if.arvalid  ),
   .apf_bpf_slv_arready   (apf_bpf_slv_if.arready  ),
   .apf_bpf_slv_rdata     (apf_bpf_slv_if.rdata    ),
   .apf_bpf_slv_rresp     (apf_bpf_slv_if.rresp    ),
   .apf_bpf_slv_rvalid    (apf_bpf_slv_if.rvalid   ),
   .apf_bpf_slv_rready    (apf_bpf_slv_if.rready   ),

   .apf_bpf_mst_awaddr    (apf_bpf_mst_if.awaddr   ),
   .apf_bpf_mst_awprot    (apf_bpf_mst_if.awprot   ),
   .apf_bpf_mst_awvalid   (apf_bpf_mst_if.awvalid  ),
   .apf_bpf_mst_awready   (apf_bpf_mst_if.awready  ),
   .apf_bpf_mst_wdata     (apf_bpf_mst_if.wdata    ),
   .apf_bpf_mst_wstrb     (apf_bpf_mst_if.wstrb    ),
   .apf_bpf_mst_wvalid    (apf_bpf_mst_if.wvalid   ),
   .apf_bpf_mst_wready    (apf_bpf_mst_if.wready   ),
   .apf_bpf_mst_bresp     (apf_bpf_mst_if.bresp    ),
   .apf_bpf_mst_bvalid    (apf_bpf_mst_if.bvalid   ),
   .apf_bpf_mst_bready    (apf_bpf_mst_if.bready   ),
   .apf_bpf_mst_araddr    (apf_bpf_mst_if.araddr   ),
   .apf_bpf_mst_arprot    (apf_bpf_mst_if.arprot   ),
   .apf_bpf_mst_arvalid   (apf_bpf_mst_if.arvalid  ),
   .apf_bpf_mst_arready   (apf_bpf_mst_if.arready  ),
   .apf_bpf_mst_rdata     (apf_bpf_mst_if.rdata    ),
   .apf_bpf_mst_rresp     (apf_bpf_mst_if.rresp    ),
   .apf_bpf_mst_rvalid    (apf_bpf_mst_if.rvalid   ),
   .apf_bpf_mst_rready    (apf_bpf_mst_if.rready   ),

   .apf_mctp_mst_awaddr   (apf_mctp_mst_if.awaddr  ),
   .apf_mctp_mst_awprot   (apf_mctp_mst_if.awprot  ),
   .apf_mctp_mst_awvalid  (apf_mctp_mst_if.awvalid ),
   .apf_mctp_mst_awready  (apf_mctp_mst_if.awready ),
   .apf_mctp_mst_wdata    (apf_mctp_mst_if.wdata   ),
   .apf_mctp_mst_wstrb    (apf_mctp_mst_if.wstrb   ),
   .apf_mctp_mst_wvalid   (apf_mctp_mst_if.wvalid  ),
   .apf_mctp_mst_wready   (apf_mctp_mst_if.wready  ),
   .apf_mctp_mst_bresp    (apf_mctp_mst_if.bresp   ),
   .apf_mctp_mst_bvalid   (apf_mctp_mst_if.bvalid  ),
   .apf_mctp_mst_bready   (apf_mctp_mst_if.bready  ),
   .apf_mctp_mst_araddr   (apf_mctp_mst_if.araddr  ),
   .apf_mctp_mst_arprot   (apf_mctp_mst_if.arprot  ),
   .apf_mctp_mst_arvalid  (apf_mctp_mst_if.arvalid ),
   .apf_mctp_mst_arready  (apf_mctp_mst_if.arready ),
   .apf_mctp_mst_rdata    (apf_mctp_mst_if.rdata   ),
   .apf_mctp_mst_rresp    (apf_mctp_mst_if.rresp   ),
   .apf_mctp_mst_rvalid   (apf_mctp_mst_if.rvalid  ),
   .apf_mctp_mst_rready   (apf_mctp_mst_if.rready  ),

   .apf_pr_slv_awaddr     (apf_pgsk_slv_if.awaddr    ),
   .apf_pr_slv_awprot     (apf_pgsk_slv_if.awprot    ),
   .apf_pr_slv_awvalid    (apf_pgsk_slv_if.awvalid   ),
   .apf_pr_slv_awready    (apf_pgsk_slv_if.awready   ),
   .apf_pr_slv_wdata      (apf_pgsk_slv_if.wdata     ),
   .apf_pr_slv_wstrb      (apf_pgsk_slv_if.wstrb     ),
   .apf_pr_slv_wvalid     (apf_pgsk_slv_if.wvalid    ),
   .apf_pr_slv_wready     (apf_pgsk_slv_if.wready    ),
   .apf_pr_slv_bresp      (apf_pgsk_slv_if.bresp     ),
   .apf_pr_slv_bvalid     (apf_pgsk_slv_if.bvalid    ),
   .apf_pr_slv_bready     (apf_pgsk_slv_if.bready    ),
   .apf_pr_slv_araddr     (apf_pgsk_slv_if.araddr    ),
   .apf_pr_slv_arprot     (apf_pgsk_slv_if.arprot    ),
   .apf_pr_slv_arvalid    (apf_pgsk_slv_if.arvalid   ),
   .apf_pr_slv_arready    (apf_pgsk_slv_if.arready   ),
   .apf_pr_slv_rdata      (apf_pgsk_slv_if.rdata     ),
   .apf_pr_slv_rresp      (apf_pgsk_slv_if.rresp     ),
   .apf_pr_slv_rvalid     (apf_pgsk_slv_if.rvalid    ),
   .apf_pr_slv_rready     (apf_pgsk_slv_if.rready    ),

   .apf_uart_mst_awaddr   (apf_uart_mst_if.awaddr  ),
   .apf_uart_mst_awprot   (apf_uart_mst_if.awprot  ),
   .apf_uart_mst_awvalid  (apf_uart_mst_if.awvalid ),
   .apf_uart_mst_awready  (apf_uart_mst_if.awready ),
   .apf_uart_mst_wdata    (apf_uart_mst_if.wdata   ),
   .apf_uart_mst_wstrb    (apf_uart_mst_if.wstrb   ),
   .apf_uart_mst_wvalid   (apf_uart_mst_if.wvalid  ),
   .apf_uart_mst_wready   (apf_uart_mst_if.wready  ),
   .apf_uart_mst_bresp    (apf_uart_mst_if.bresp   ),
   .apf_uart_mst_bvalid   (apf_uart_mst_if.bvalid  ),
   .apf_uart_mst_bready   (apf_uart_mst_if.bready  ),
   .apf_uart_mst_araddr   (apf_uart_mst_if.araddr  ),
   .apf_uart_mst_arprot   (apf_uart_mst_if.arprot  ),
   .apf_uart_mst_arvalid  (apf_uart_mst_if.arvalid ),
   .apf_uart_mst_arready  (apf_uart_mst_if.arready ),
   .apf_uart_mst_rdata    (apf_uart_mst_if.rdata   ),
   .apf_uart_mst_rresp    (apf_uart_mst_if.rresp   ),
   .apf_uart_mst_rvalid   (apf_uart_mst_if.rvalid  ),
   .apf_uart_mst_rready   (apf_uart_mst_if.rready  ),


   .apf_uart_slv_awaddr   (apf_uart_slv_if.awaddr    ),
   .apf_uart_slv_awprot   (apf_uart_slv_if.awprot    ),
   .apf_uart_slv_awvalid  (apf_uart_slv_if.awvalid   ),
   .apf_uart_slv_awready  (apf_uart_slv_if.awready   ),
   .apf_uart_slv_wdata    (apf_uart_slv_if.wdata     ),
   .apf_uart_slv_wstrb    (apf_uart_slv_if.wstrb     ),
   .apf_uart_slv_wvalid   (apf_uart_slv_if.wvalid    ),
   .apf_uart_slv_wready   (apf_uart_slv_if.wready    ),
   .apf_uart_slv_bresp    (apf_uart_slv_if.bresp     ),
   .apf_uart_slv_bvalid   (apf_uart_slv_if.bvalid    ),
   .apf_uart_slv_bready   (apf_uart_slv_if.bready    ),
   .apf_uart_slv_araddr   (apf_uart_slv_if.araddr    ),
   .apf_uart_slv_arprot   (apf_uart_slv_if.arprot    ),
   .apf_uart_slv_arvalid  (apf_uart_slv_if.arvalid   ),
   .apf_uart_slv_arready  (apf_uart_slv_if.arready   ),
   .apf_uart_slv_rdata    (apf_uart_slv_if.rdata     ),
   .apf_uart_slv_rresp    (apf_uart_slv_if.rresp     ),
   .apf_uart_slv_rvalid   (apf_uart_slv_if.rvalid    ),
   .apf_uart_slv_rready   (apf_uart_slv_if.rready    ),

   .apf_st2mm_mst_awaddr  (apf_st2mm_mst_if.awaddr ),
   .apf_st2mm_mst_awprot  (apf_st2mm_mst_if.awprot ),
   .apf_st2mm_mst_awvalid (apf_st2mm_mst_if.awvalid),
   .apf_st2mm_mst_awready (apf_st2mm_mst_if.awready),
   .apf_st2mm_mst_wdata   (apf_st2mm_mst_if.wdata  ),
   .apf_st2mm_mst_wstrb   (apf_st2mm_mst_if.wstrb  ),
   .apf_st2mm_mst_wvalid  (apf_st2mm_mst_if.wvalid ),
   .apf_st2mm_mst_wready  (apf_st2mm_mst_if.wready ),
   .apf_st2mm_mst_bresp   (apf_st2mm_mst_if.bresp  ),
   .apf_st2mm_mst_bvalid  (apf_st2mm_mst_if.bvalid ),
   .apf_st2mm_mst_bready  (apf_st2mm_mst_if.bready ),
   .apf_st2mm_mst_araddr  (apf_st2mm_mst_if.araddr ),
   .apf_st2mm_mst_arprot  (apf_st2mm_mst_if.arprot ),
   .apf_st2mm_mst_arvalid (apf_st2mm_mst_if.arvalid),
   .apf_st2mm_mst_arready (apf_st2mm_mst_if.arready),
   .apf_st2mm_mst_rdata   (apf_st2mm_mst_if.rdata  ),
   .apf_st2mm_mst_rresp   (apf_st2mm_mst_if.rresp  ),
   .apf_st2mm_mst_rvalid  (apf_st2mm_mst_if.rvalid ),
   .apf_st2mm_mst_rready  (apf_st2mm_mst_if.rready ),

   .apf_st2mm_slv_awaddr  (apf_st2mm_slv_if.awaddr ),
   .apf_st2mm_slv_awprot  (apf_st2mm_slv_if.awprot ),
   .apf_st2mm_slv_awvalid (apf_st2mm_slv_if.awvalid),
   .apf_st2mm_slv_awready (apf_st2mm_slv_if.awready),
   .apf_st2mm_slv_wdata   (apf_st2mm_slv_if.wdata  ),
   .apf_st2mm_slv_wstrb   (apf_st2mm_slv_if.wstrb  ),
   .apf_st2mm_slv_wvalid  (apf_st2mm_slv_if.wvalid ),
   .apf_st2mm_slv_wready  (apf_st2mm_slv_if.wready ),
   .apf_st2mm_slv_bresp   (apf_st2mm_slv_if.bresp  ),
   .apf_st2mm_slv_bvalid  (apf_st2mm_slv_if.bvalid ),
   .apf_st2mm_slv_bready  (apf_st2mm_slv_if.bready ),
   .apf_st2mm_slv_araddr  (apf_st2mm_slv_if.araddr ),
   .apf_st2mm_slv_arprot  (apf_st2mm_slv_if.arprot ),
   .apf_st2mm_slv_arvalid (apf_st2mm_slv_if.arvalid),
   .apf_st2mm_slv_arready (apf_st2mm_slv_if.arready),
   .apf_st2mm_slv_rdata   (apf_st2mm_slv_if.rdata  ),
   .apf_st2mm_slv_rresp   (apf_st2mm_slv_if.rresp  ),
   .apf_st2mm_slv_rvalid  (apf_st2mm_slv_if.rvalid ),
   .apf_st2mm_slv_rready  (apf_st2mm_slv_if.rready ),

   .apf_achk_slv_awaddr   (apf_achk_slv_if.awaddr  ),
   .apf_achk_slv_awprot   (apf_achk_slv_if.awprot  ),
   .apf_achk_slv_awvalid  (apf_achk_slv_if.awvalid ),
   .apf_achk_slv_awready  (apf_achk_slv_if.awready ),
   .apf_achk_slv_wdata    (apf_achk_slv_if.wdata   ),
   .apf_achk_slv_wstrb    (apf_achk_slv_if.wstrb   ),
   .apf_achk_slv_wvalid   (apf_achk_slv_if.wvalid  ),
   .apf_achk_slv_wready   (apf_achk_slv_if.wready  ),
   .apf_achk_slv_bresp    (apf_achk_slv_if.bresp   ),
   .apf_achk_slv_bvalid   (apf_achk_slv_if.bvalid  ),
   .apf_achk_slv_bready   (apf_achk_slv_if.bready  ),
   .apf_achk_slv_araddr   (apf_achk_slv_if.araddr  ),
   .apf_achk_slv_arprot   (apf_achk_slv_if.arprot  ),
   .apf_achk_slv_arvalid  (apf_achk_slv_if.arvalid ),
   .apf_achk_slv_arready  (apf_achk_slv_if.arready ),
   .apf_achk_slv_rdata    (apf_achk_slv_if.rdata   ),
   .apf_achk_slv_rresp    (apf_achk_slv_if.rresp   ),
   .apf_achk_slv_rvalid   (apf_achk_slv_if.rvalid  ),
   .apf_achk_slv_rready   (apf_achk_slv_if.rready  )
);

endmodule
