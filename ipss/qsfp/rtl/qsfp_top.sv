// Copyright (C) 2021 Intel Corporation.
// SPDX-License-Identifier: MIT

//
// Engineer     : 
// Create Date  : Sept 2020
// Module Name  : qsfp_top.sv
// Project      : IOFS
// -----------------------------------------------------------------------------
//
// Description: 
// qsfp_controller top module instantiates all sub modules
// implementes AVMM address decoding logic


module qsfp_top  #(
   parameter ADDR_WIDTH  = 12, 
   parameter DATA_WIDTH = 64, 
   parameter bit [11:0] FEAT_ID = 12'h001,
   parameter bit [3:0]  FEAT_VER = 4'h1,
   parameter bit [23:0] NEXT_DFH_OFFSET = 24'h1000,
   parameter bit END_OF_LIST = 1'b0
)(
   input  logic    clk,
   input  logic    reset,
   input  wire     modprsl,
   input  wire     int_qsfp,
   input  wire     i2c_0_i2c_serial_sda_in,
   input  wire     i2c_0_i2c_serial_scl_in,
   output wire     i2c_0_i2c_serial_sda_oe,
   output wire     i2c_0_i2c_serial_scl_oe,
   output wire     modesel,
   output wire     lpmode,
   output wire     softresetqsfpm,
// -----------------------------------------------------------
//  AXI4LITE Interface
// -----------------------------------------------------------
   ofs_fim_axi_lite_if.slave   csr_lite_if
);

import ofs_fim_cfg_pkg::*;
import ofs_csr_pkg::*;

//-------------------------------------
// Signals
//-------------------------------------
   logic [ADDR_WIDTH-1:0]              csr_waddr;
   logic [DATA_WIDTH-1:0]              csr_wdata;
   logic [DATA_WIDTH/8-1:0]            csr_wstrb;
   logic                               csr_write;
   logic                               csr_slv_wready;
   csr_access_type_t                   csr_write_type;

   logic [ADDR_WIDTH-1:0]              csr_raddr;
   logic                               csr_read;
   logic                               csr_read_32b;
   logic [DATA_WIDTH-1:0]              csr_readdata;
   logic                               csr_readdata_valid;

   logic [ADDR_WIDTH-1:0]              csr_addr;
   logic [31:0]                        delay_csr_in;
   logic                               src_valid;
   logic [7:0]                         src_data;
   logic                               src_ready;
   logic                               wren_logic;
   logic                               rd_done;
   logic [7:0]                         curr_rd_addr;
   logic [7:0]                         curr_rd_page;
   logic                               rd_done_ack;
   logic                               mem_wren ;
   logic [63:0]                        mem_wdata;
   logic [7:0]                         mem_waddr ;
   logic                               mem_chipsel;
   logic [15:0]                        sink_data ;
   logic                               sink_valid;
   logic                               sink_ready;

   logic                               config_softresetqsfpm;
   logic                               config_softresetqsfpc;
   logic                               config_modesel;
   logic                               config_lpmode;
   logic                               config_poll_en;
   logic                               status_int_i2c_i;
   logic                               tx_err;
   logic                               rx_err;
   logic [63:0]                        com_csr_writedata;
   logic                               com_csr_read;
   logic                               com_csr_write;
   logic [63:0]                        com_csr_readdata;
   logic                               com_csr_readdatavalid;
   logic [5:0]                         com_csr_address;
   logic                               csr_araddr_is_16b;
   logic                               csr_araddr_is_upper32b;

   logic [63:0]                        com_csr_writedata_nxt;
   logic                               com_csr_read_nxt;
   logic                               com_csr_write_nxt;
   logic                               com_csr_readdatavalid_nxt;
   logic [5:0]                         com_csr_address_nxt;
   logic                               fsm_paused;
   logic                               reset_hard_soft;
   
   logic [3:0]                         i2c_0_csr_address;
   logic                               i2c_0_csr_read;
   logic                               i2c_0_csr_write;
   logic                               com_csr_unused;
   logic [31:0]                        i2c_0_csr_writedata;
   logic [31:0]                        i2c_0_csr_readdata;
   logic                               i2c_0_csr_readdata_valid;
   logic                               i2c_0_csr_read_q;
   logic [63:0]                        i2c_0_csr_writedata_64;
   logic [63:0]                        i2c_0_csr_readdata_64;

   logic [7:0]                         onchip_memory2_0_s1_address;       
   logic                               onchip_memory2_0_s1_clken;         
   logic                               onchip_memory2_0_s1_chipselect;    
   logic                               onchip_memory2_0_s1_write;         
   logic [63:0]                        onchip_memory2_0_s1_readdata;      
   logic                               onchip_memory2_0_s1_readdata_valid;


   assign reset_hard_soft = reset || config_softresetqsfpc;
   assign poll_en         = config_poll_en;

   assign modesel        = config_modesel;
   assign lpmode         = config_lpmode;
   assign softresetqsfpm = config_softresetqsfpm;

   assign tx_err         = ~sink_ready && sink_valid;     
   assign rx_err         = ~src_ready & src_valid & sink_data[0] & sink_data[9] ;     





// AXI-M CSR interfaces
ofs_fim_axi_mmio_if #(
   .AWID_WIDTH   (ofs_fim_cfg_pkg::MMIO_TID_WIDTH),
   .AWADDR_WIDTH (ADDR_WIDTH),
   .WDATA_WIDTH  (ofs_fim_cfg_pkg::MMIO_DATA_WIDTH),
   .ARID_WIDTH   (ofs_fim_cfg_pkg::MMIO_TID_WIDTH),
   .ARADDR_WIDTH (ADDR_WIDTH),
   .RDATA_WIDTH  (ofs_fim_cfg_pkg::MMIO_DATA_WIDTH)
) csr_if();

ofs_fim_axi_mmio_if #(
   .AWID_WIDTH   (ofs_fim_cfg_pkg::MMIO_TID_WIDTH),
   .AWADDR_WIDTH (ADDR_WIDTH),
   .WDATA_WIDTH  (ofs_fim_cfg_pkg::MMIO_DATA_WIDTH),
   .ARID_WIDTH   (ofs_fim_cfg_pkg::MMIO_TID_WIDTH),
   .ARADDR_WIDTH (ADDR_WIDTH),
   .RDATA_WIDTH  (ofs_fim_cfg_pkg::MMIO_DATA_WIDTH)
) csr_if_aximm();

// AXI4-lite to AXI-M adapter
axi_lite2mmio axi_lite2mmio (
   .clk       (clk),
   .rst_n     (~reset),
   .lite_if   (csr_lite_if),
   .mmio_if   (csr_if_aximm)
);

//---------------------------------
// The NIOSV in the PMCI SS is doing 16b reads to the QSFP controller.
// The NIOSII bridges converted to 32b but the NIOSV is native AXI and does
// not do this conversion so 16b reads are reaching the QSFP controller
// The code below converts to 32b read since OFS does not allow lower
// than 32b reads
//---------------------------------
assign csr_if_aximm.awready = csr_if.awready;
assign csr_if_aximm.wready  = csr_if.wready; 
assign csr_if_aximm.bvalid  = csr_if.bvalid; 
assign csr_if_aximm.bresp   = csr_if.bresp;  
assign csr_if_aximm.bid     = csr_if.bid;    
assign csr_if_aximm.buser   = csr_if.buser;    // check

assign csr_if_aximm.arready = csr_if.arready;
assign csr_if_aximm.rvalid  = csr_if.rvalid; 
assign csr_if_aximm.rid     = csr_if.rid;    
assign csr_if_aximm.rresp   = csr_if.rresp;  
//assign csr_if_aximm.rdata   = csr_if.rdata;  
assign csr_if_aximm.rlast   = csr_if.rlast;  
assign csr_if_aximm.ruser   = csr_if.ruser; // check  


assign csr_if.clk       = csr_if_aximm.clk;  
assign csr_if.rst_n     = csr_if_aximm.rst_n;  
assign csr_if.awvalid   = csr_if_aximm.awvalid;  
assign csr_if.awid      = csr_if_aximm.awid;  
assign csr_if.awaddr    = csr_if_aximm.awaddr;  
assign csr_if.awlen     = csr_if_aximm.awlen;  
assign csr_if.awsize    = csr_if_aximm.awsize;  
assign csr_if.awburst   = csr_if_aximm.awburst;  
assign csr_if.awlock    = csr_if_aximm.awlock;  
assign csr_if.awcache   = csr_if_aximm.awcache;  
assign csr_if.awprot    = csr_if_aximm.awprot;  
assign csr_if.awqos     = csr_if_aximm.awqos;  
assign csr_if.awuser    = csr_if_aximm.awuser;  
assign csr_if.wvalid    = csr_if_aximm.wvalid;  
assign csr_if.wdata     = csr_if_aximm.wdata;  
assign csr_if.wstrb     = csr_if_aximm.wstrb;  
assign csr_if.wlast     = csr_if_aximm.wlast;  
assign csr_if.wuser     = csr_if_aximm.wuser;  
assign csr_if.bready    = csr_if_aximm.bready;  
assign csr_if.arvalid   = csr_if_aximm.arvalid;  
assign csr_if.arid      = csr_if_aximm.arid;  
assign csr_if.arlen     = csr_if_aximm.arlen;  
assign csr_if.arsize    = csr_if_aximm.arsize;  
assign csr_if.arburst   = csr_if_aximm.arburst;  
assign csr_if.arlock    = csr_if_aximm.arlock;  
assign csr_if.arcache   = csr_if_aximm.arcache;  
assign csr_if.arprot    = csr_if_aximm.arprot;  
assign csr_if.arqos     = csr_if_aximm.arqos;  
assign csr_if.aruser    = csr_if_aximm.aruser;  
assign csr_if.rready    = csr_if_aximm.rready;  



// adjust the araddr to not assert bit 1 
assign csr_if.araddr = csr_if_aximm.araddr & 64'hffff_ffff_ffff_fffd;

//Determine if read is 16b
always @(posedge clk) 
begin
    if (csr_if_aximm.arvalid)
        csr_araddr_is_16b <= csr_if_aximm.araddr[1];
end


always @(posedge clk) 
begin
    if (csr_if_aximm.arvalid)
        csr_araddr_is_upper32b <= csr_if_aximm.araddr[2];
end

// adjust read data based on size of read.
assign csr_if_aximm.rdata = csr_araddr_is_16b? 
                                    (csr_araddr_is_upper32b? 
                                    {csr_if.rdata[63:48],csr_if.rdata[63:48],csr_if.rdata[31:0]} : 
                                    {csr_if.rdata[63:32],csr_if.rdata[31:16],csr_if.rdata[31:16]}) : 
                                    csr_if.rdata;


//---------------------------------
// Map AXI write/read request to CSR write/read,
// and send the write/read response back
//---------------------------------
ofs_fim_axi_csr_slave #(
   .ADDR_WIDTH (ADDR_WIDTH),
   .USE_SLV_READY (1'b1)
   
   ) csr_slave (
   .csr_if             (csr_if),

   .csr_write          (csr_write),
   .csr_waddr          (csr_waddr),
   .csr_write_type     (csr_write_type),
   .csr_wdata          (csr_wdata),
   .csr_wstrb          (csr_wstrb),
   .csr_slv_wready     (csr_slv_wready),
   .csr_read           (csr_read),
   .csr_raddr          (csr_raddr),
   .csr_read_32b       (csr_read_32b),
   .csr_readdata       (csr_readdata),
   .csr_readdata_valid (csr_readdata_valid)
);

// Address mapping
assign csr_addr                     = csr_write ? csr_waddr : csr_raddr;
assign com_csr_address              = csr_addr[5:0];  // byte address
assign i2c_0_csr_address            = csr_addr[5:2];  // 32-bit address
assign onchip_memory2_0_s1_address  = csr_addr[10:3] - 8'h20; //64-bit address

assign csr_slv_wready = (csr_waddr == 12'h040) ? sink_ready : 1'b1; 
// Write data mapping
assign i2c_0_csr_writedata_64  = csr_wdata;
assign com_csr_writedata       = csr_wdata;


// I2C controller 64<->32 mapping
always_comb
begin
   if(i2c_0_csr_address[0]) begin // Upper/Odd
      i2c_0_csr_writedata   = i2c_0_csr_writedata_64[63:32];
      i2c_0_csr_readdata_64 = {i2c_0_csr_readdata,32'h0};
   end
   else begin // Lower/Even
      i2c_0_csr_writedata   = i2c_0_csr_writedata_64[31:0];
      i2c_0_csr_readdata_64 = {32'h0,i2c_0_csr_readdata};
   end
end   


// Read-Write mapping
always_comb
begin
   com_csr_read                     = 1'b0;
   com_csr_write                    = 1'b0;
   onchip_memory2_0_s1_chipselect   = 1'b0;
   onchip_memory2_0_s1_write        = 1'b0;
   i2c_0_csr_read                   = 1'b0;
   i2c_0_csr_write                  = 1'b0;
   com_csr_read                     = 1'b0;
   casez (csr_addr[11:6])
      6'h00 : begin // Common CSR
         com_csr_read                     = csr_read;
         com_csr_write                    = csr_write;
         onchip_memory2_0_s1_chipselect   = 1'b0;
         onchip_memory2_0_s1_write        = 1'b0;
         i2c_0_csr_read                   = 1'b0;
         i2c_0_csr_write                  = 1'b0;
         com_csr_unused                   = 1'b0;
      end   
      6'h01 : begin   // I2C controller CSR
         com_csr_read                     = 1'b0;
         com_csr_write                    = 1'b0;
         onchip_memory2_0_s1_chipselect   = 1'b0;
         onchip_memory2_0_s1_write        = 1'b0;
         i2c_0_csr_read                   = csr_read;
         i2c_0_csr_write                  = csr_write;
         com_csr_unused                   = 1'b0;
      end
      6'b0001??,
      6'b001???: begin // Shadow register memory
         com_csr_read                     = 1'b0;
         com_csr_write                    = 1'b0;
         onchip_memory2_0_s1_chipselect   = csr_read;
         onchip_memory2_0_s1_write        = ~csr_read;
         i2c_0_csr_read                   = 1'b0;
         i2c_0_csr_write                  = 1'b0;
         com_csr_unused                   = 1'b0;
      end
      default: begin
         com_csr_read                     = 1'b0;
         com_csr_write                    = 1'b0;
         onchip_memory2_0_s1_chipselect   = 1'b0;
         onchip_memory2_0_s1_write        = 1'b0;
         i2c_0_csr_read                   = 1'b0;
         i2c_0_csr_write                  = 1'b0;
         com_csr_unused                   = 1'b1;
      end
   endcase
end

//Read Valid generation
always_ff @(posedge clk) begin
   // 2 clk latency for I2C controller read
   i2c_0_csr_read_q                   <= i2c_0_csr_read;
   i2c_0_csr_readdata_valid           <= i2c_0_csr_read_q;
   // 1 clk latency for on-chip mem
   onchip_memory2_0_s1_readdata_valid <= onchip_memory2_0_s1_chipselect 
                                         & (~onchip_memory2_0_s1_write);
end

// Read data mapping
always_comb begin
   if (com_csr_readdatavalid) begin
      csr_readdata       = com_csr_readdata;
      csr_readdata_valid = 1'b1;
   end
   else if (i2c_0_csr_readdata_valid) begin
      csr_readdata       = i2c_0_csr_readdata_64;
      csr_readdata_valid = 1'b1;
   end
   else if (onchip_memory2_0_s1_readdata_valid) begin
      csr_readdata       = onchip_memory2_0_s1_readdata;
      csr_readdata_valid = 1'b1;
   end
   else if (com_csr_unused) begin
      csr_readdata       = '0;
      csr_readdata_valid = 1'b1;
   end
   else begin
      csr_readdata       = '0;
      csr_readdata_valid = 1'b0;
   end
end


poller_fsm poller_fsm_inst(
   .clk           (clk         ),  
   .reset         (reset_hard_soft),  
   .poll_en       (poll_en     ),  
   .sink_data     (sink_data   ),  
   .sink_valid    (sink_valid  ),  
   .sink_ready    (sink_ready  ),  
   .wren_logic    (wren_logic  ),  
   .curr_rd_addr  (curr_rd_addr),  
   .curr_rd_page  (curr_rd_page),  
   .rd_done       (rd_done     ),  
   .rd_done_ack   (rd_done_ack ),  
   .wr_cnt_rst    (wr_cnt_rst  ),
   .csr_wdata     (i2c_0_csr_writedata),
   .csr_write     (csr_write),
   .csr_addr      (csr_addr),
   .delay_csr_in  (delay_csr_in),
   .fsm_paused    (fsm_paused)
);


csr_wr_logic csr_wr_logic_inst (
   .clk           (clk         ),
   .reset         (reset_hard_soft),
   .src_valid     (src_valid   ),
   .src_data      (src_data    ),
   .src_ready     (src_ready   ),
   .wren_logic    (wren_logic  ),
   .curr_rd_addr  (curr_rd_addr),  
   .rd_done       (rd_done     ),
   .poll_en       (poll_en     ),
   .rd_done_ack   (rd_done_ack ),
   .mem_wren      (mem_wren    ),
   .mem_chipsel   (mem_chipsel ),
   .mem_wdata     (mem_wdata   ),
   .mem_waddr     (mem_waddr    ),
   .wr_cnt_rst    (wr_cnt_rst   )
   );

qsfp_ctrl qsfp_ctrl_inst (
   .clk_clk                           (clk),
   .i2c_0_interrupt_sender_irq        (status_int_i2c_i),    // To be connected from output of decoder
   .i2c_0_csr_address                 (i2c_0_csr_address   ),
   .i2c_0_csr_read                    (i2c_0_csr_read      ),
   .i2c_0_csr_write                   (i2c_0_csr_write     ),
   .i2c_0_csr_writedata               (i2c_0_csr_writedata ),
   .i2c_0_csr_readdata                (i2c_0_csr_readdata  ), //Latency 2 clk
   .i2c_0_i2c_serial_sda_in           (i2c_0_i2c_serial_sda_in),
   .i2c_0_i2c_serial_scl_in           (i2c_0_i2c_serial_scl_in),
   .i2c_0_i2c_serial_sda_oe           (i2c_0_i2c_serial_sda_oe),
   .i2c_0_i2c_serial_scl_oe           (i2c_0_i2c_serial_scl_oe),
   .i2c_0_rx_data_source_data         (src_data),
   .i2c_0_rx_data_source_valid        (src_valid),
   .i2c_0_rx_data_source_ready        (src_ready),
   .i2c_0_transfer_command_sink_data  (sink_data),
   .i2c_0_transfer_command_sink_valid (sink_valid),
   .i2c_0_transfer_command_sink_ready (sink_ready),
   .onchip_memory2_0_s1_address       (onchip_memory2_0_s1_address),
   .onchip_memory2_0_s1_clken         (1'b1),
   .onchip_memory2_0_s1_chipselect    (onchip_memory2_0_s1_chipselect),
   .onchip_memory2_0_s1_write         (onchip_memory2_0_s1_write),
   .onchip_memory2_0_s1_readdata      (onchip_memory2_0_s1_readdata), //Latency 1 clk
   .onchip_memory2_0_s1_writedata     (64'b0),
   .onchip_memory2_0_s1_byteenable    (8'hff),    // 
   .onchip_memory2_0_s2_address       (mem_waddr),
   .onchip_memory2_0_s2_chipselect    (mem_chipsel),
   .onchip_memory2_0_s2_clken         (1'b1),
   .onchip_memory2_0_s2_write         (mem_wren),
   .onchip_memory2_0_s2_readdata      (),
   .onchip_memory2_0_s2_writedata     (mem_wdata),
   .onchip_memory2_0_s2_byteenable    (8'hff),    // 
   .reset_reset                       (reset_hard_soft)
   );

qsfp_com  #(
   .FEAT_ID          (FEAT_ID),
   .FEAT_VER         (FEAT_VER),
   .NEXT_DFH_OFFSET  (NEXT_DFH_OFFSET),
   .END_OF_LIST      (END_OF_LIST)
) qsfp_com_inst (
   .config_softresetqsfpm (config_softresetqsfpm   ),
   .config_softresetqsfpc (config_softresetqsfpc   ),
   .config_modesel        (config_modesel          ),
   .config_lpmode         (config_lpmode           ),
   .config_poll_en        (config_poll_en          ),
   .status_modprsl_i      (modprsl                 ),
   .status_int_qsfp_i     (int_qsfp                ),
   .status_int_i2c_i      (status_int_i2c_i        ),
   .status_tx_err_i       (tx_err                  ),
   .status_rx_err_i       (rx_err                  ),
   .status_snk_ready_i    (sink_ready              ),
   .status_src_ready_i    (src_ready               ),
   .status_fsm_paused_i   (fsm_paused              ),
   .status_curr_rd_page_i (curr_rd_page            ),
   .status_curr_rd_addr_i (curr_rd_addr            ),
   .clk                   (clk                     ),
   .reset                 (reset                   ),
   .writedata             (com_csr_writedata       ),
   .delay_csr_in          (delay_csr_in            ),
   .read                  (com_csr_read            ),
   .write                 (com_csr_write           ),
   .byteenable            (4'hF                    ),
   .readdata              (com_csr_readdata        ),
   .readdatavalid         (com_csr_readdatavalid   ),
   .address               (com_csr_address         )
   );

endmodule
