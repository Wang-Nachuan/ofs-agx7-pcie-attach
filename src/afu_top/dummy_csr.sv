// Copyright (C) 2021 Intel Corporation.
// SPDX-License-Identifier: MIT

//
// Description
//-----------------------------------------------------------------------------
//
//   Dummy AXI-lite CSR module 
//
//-----------------------------------------------------------------------------

module dummy_csr #(
   parameter bit [3:0]  FEAT_TYPE = 4'h3,
   parameter bit [11:0] FEAT_ID = 12'h0,
   parameter bit [3:0]  FEAT_VER = 4'h0,
   parameter bit [23:0] NEXT_DFH_OFFSET = 24'h1000,
   parameter bit END_OF_LIST = 1'b0
)(
   input wire clk,
   input wire rst_n,

   ofs_fim_axi_lite_if.slave   csr_lite_if
);

import ofs_fim_cfg_pkg::*;
import ofs_csr_pkg::*;

localparam DATA_WIDTH   = ofs_fim_cfg_pkg::MMIO_DATA_WIDTH;
localparam WSTRB_WIDTH  = (DATA_WIDTH/8);

//-------------------------------------
// Number of feature and register
//-------------------------------------

// To add a register, append a new register ID to e_csr_offset
// The register address offset is calculated in CALC_CSR_OFFSET() in 8 bytes increment
//    based on the position of the register ID in e_csr_offset. 
// The calculated offset is stored in CSR_OFFSET and can be indexed using the register ID 
enum {
   DFH,        // 'h0
   SCRATCHPAD, // 'h8
   TESTPAD_0, 
   TESTPAD_1,
   TESTPAD_2,
   TESTPAD_3,
   TESTPAD_4,
   TESTPAD_5,
   TESTPAD_6,
   TESTPAD_7,
   TESTPAD_8,
   TESTPAD_9,
   TESTPAD_10,
   TESTPAD_11,
   TESTPAD_12,
   TESTPAD_13,
   TESTPAD_14,
   TESTPAD_15,
   MAX_OFFSET
} e_csr_id;

localparam CSR_NUM_REG        = MAX_OFFSET; 
localparam CSR_REG_ADDR_WIDTH = $clog2(CSR_NUM_REG) + 3;

localparam MAX_CSR_REG_NUM    = 512; // 4KB address space - 512 x 8B register
localparam CSR_ADDR_WIDTH     = $clog2(MAX_CSR_REG_NUM) + 3;
localparam ADDR_WIDTH         = ofs_fim_cfg_pkg::MMIO_ADDR_WIDTH;

//-------------------------------------
// Register address
//-------------------------------------
function automatic bit [CSR_NUM_REG-1:0][ADDR_WIDTH-1:0] CALC_CSR_OFFSET ();
   bit [31:0] offset;
   for (int i=0; i<CSR_NUM_REG; ++i) begin
      offset = i*8;
      CALC_CSR_OFFSET[i] = offset[ADDR_WIDTH-1:0];
   end
endfunction

localparam bit [CSR_NUM_REG-1:0][ADDR_WIDTH-1:0] CSR_OFFSET = CALC_CSR_OFFSET();

//-------------------------------------
// Signals
//-------------------------------------
logic [ADDR_WIDTH-1:0]  csr_waddr;
logic [DATA_WIDTH-1:0]  csr_wdata;
logic [WSTRB_WIDTH-1:0] csr_wstrb;
logic                   csr_write;
csr_access_type_t       csr_write_type;

logic [ADDR_WIDTH-1:0]  csr_raddr;
logic                   csr_read;
logic                   csr_read_32b;
logic [DATA_WIDTH-1:0]  csr_readdata;
logic                   csr_readdata_valid;

//--------------------------------------------------------------

// AXI-M CSR interfaces
ofs_fim_axi_mmio_if #(
   .AWID_WIDTH   (ofs_fim_cfg_pkg::MMIO_TID_WIDTH),
   .AWADDR_WIDTH (ofs_fim_cfg_pkg::MMIO_ADDR_WIDTH),
   .WDATA_WIDTH  (ofs_fim_cfg_pkg::MMIO_DATA_WIDTH),
   .ARID_WIDTH   (ofs_fim_cfg_pkg::MMIO_TID_WIDTH),
   .ARADDR_WIDTH (ofs_fim_cfg_pkg::MMIO_ADDR_WIDTH),
   .RDATA_WIDTH  (ofs_fim_cfg_pkg::MMIO_DATA_WIDTH)
) csr_if();

// AXI4-lite to AXI-M adapter
axi_lite2mmio axi_lite2mmio (
   .clk       (clk),
   .rst_n     (rst_n),
   .lite_if   (csr_lite_if),
   .mmio_if   (csr_if)
);

//---------------------------------
// Map AXI write/read request to CSR write/read,
// and send the write/read response back
//---------------------------------
ofs_fim_axi_csr_slave csr_slave (
   .csr_if             (csr_if),

   .csr_write          (csr_write),
   .csr_waddr          (csr_waddr),
   .csr_write_type     (csr_write_type),
   .csr_wdata          (csr_wdata),
   .csr_wstrb          (csr_wstrb),

   .csr_read           (csr_read),
   .csr_raddr          (csr_raddr),
   .csr_read_32b       (csr_read_32b),
   .csr_readdata       (csr_readdata),
   .csr_readdata_valid (csr_readdata_valid)
);

//---------------------------------
// CSR Registers
//---------------------------------
ofs_csr_hw_state_t     hw_state;
logic                  range_valid;
logic                  csr_read_reg;
logic [ADDR_WIDTH-1:0] csr_raddr_reg;
logic                  csr_read_32b_reg;

logic [DATA_WIDTH-1:0] csr_reg [CSR_NUM_REG-1:0];

//-------------------
// CSR read interface
//-------------------
// Register read control signals to spare 1 clock cycle 
// for address range checking
always_ff @(posedge clk) begin
   csr_read_reg  <= csr_read;
   csr_raddr_reg <= csr_raddr;
   csr_read_32b_reg <= csr_read_32b;

   if (~rst_n) begin
      csr_read_reg <= 1'b0;
   end
end

// CSR address range check 
always_ff @(posedge clk) begin
   range_valid <= (csr_raddr[CSR_ADDR_WIDTH-1:3] < CSR_NUM_REG) ? 1'b1 : 1'b0; 
end

// CSR readdata
always_ff @(posedge clk) begin
   csr_readdata <= '0;

   if (csr_read_reg && range_valid) begin
      if (csr_read_32b_reg) begin
         if (csr_raddr_reg[2]) begin
            csr_readdata[63:32] <= csr_reg[csr_raddr_reg[CSR_REG_ADDR_WIDTH-1:3]][63:32];
         end else begin
            csr_readdata[31:0] <= csr_reg[csr_raddr_reg[CSR_REG_ADDR_WIDTH-1:3]][31:0];
         end
      end else begin
         csr_readdata <= csr_reg[csr_raddr_reg[CSR_REG_ADDR_WIDTH-1:3]];
      end
   end
end

// CSR readatavalid
always_ff @(posedge clk) begin
   csr_readdata_valid <= csr_read_reg;
end

//-------------------
// CSR Definition 
//-------------------
assign hw_state.reset_n    = rst_n;
assign hw_state.pwr_good_n = rst_n;
assign hw_state.wr_data    = csr_wdata;
assign hw_state.write_type = csr_write_type; 

always_ff @(posedge clk) begin
   def_reg (CSR_OFFSET[DFH],
               {64{RO}},
                /* 
                   [63:60]: Feature Type
                   [59:52]: Reserved
                   [51:48]: If AFU - AFU Minor Revision Number (else, reserved)
                   [47:41]: Reserved
                   [40   ]: EOL (End of DFH list)
                   [39:16]: Next DFH Byte Offset
                   [15:12]: If AfU, AFU Major version number (else feature #)
                   [11:0 ]: Feature ID
                */
               {FEAT_TYPE, 8'h0, 4'h0, 7'h0, END_OF_LIST, NEXT_DFH_OFFSET, FEAT_VER, FEAT_ID},
               {FEAT_TYPE, 8'h0, 4'h0, 7'h0, END_OF_LIST, NEXT_DFH_OFFSET, FEAT_VER, FEAT_ID}
   );

   def_reg (CSR_OFFSET[SCRATCHPAD],
               {64{RW}},
               64'h0,
               64'h0
   );
    
   for (int i=TESTPAD_0; i<=TESTPAD_15; i=i+1) begin
      def_reg (CSR_OFFSET[i],
               {64{RW}},
               64'h0,
               64'h0
      );
   end
end

//--------------------------------
// Function & Task
//--------------------------------
// Check if address matches
function automatic bit f_addr_hit (
   input logic [ADDR_WIDTH-1:0] csr_addr, 
   input logic [ADDR_WIDTH-1:0] ref_addr
);
   return (csr_addr[CSR_ADDR_WIDTH-1:3] == ref_addr[CSR_ADDR_WIDTH-1:3]);
endfunction

// Task to update CSR register bit based on bit attribute
task def_reg;
   input logic [ADDR_WIDTH-1:0] addr;
   input csr_bit_attr_t [63:0]  attr;
   input logic [63:0]           reset_val;
   input logic [63:0]           update_val;
begin
   csr_reg[addr[CSR_REG_ADDR_WIDTH-1:3]] <= ofs_csr_pkg::update_reg (
      attr,
      reset_val,
      update_val,
      csr_reg[addr[CSR_REG_ADDR_WIDTH-1:3]],
      (csr_write && f_addr_hit(csr_waddr, addr)),
      hw_state
   );
end
endtask

// This task defines a Readable/Write-1-to-Clear, Sticky register (RW1CS)
// It is intended mainly for Error Status Registers that capture 1-cycle active error signals
task def_err_reg;
   input logic [ADDR_WIDTH-1:0] addr;
   input logic [ADDR_WIDTH-1:0] mask_addr;
   input logic [63:0]           reset_val;
   input logic [63:0]           update_val;
begin
   for(int i=0; i<64; i=i+1) begin
      if(~rst_n) begin
         csr_reg[addr[CSR_REG_ADDR_WIDTH-1:3]][i] <= reset_val[i];
      end else begin
         // Clear when SW writes 1
         if (csr_write && f_addr_hit(csr_waddr, addr) && csr_wdata[i])
         begin
            // 64b access
            if (csr_write_type == ofs_csr_pkg::FULL64) begin
               csr_reg[addr[CSR_REG_ADDR_WIDTH-1:3]][i] <= 1'b0;
            end else begin
              // 32b access
              if (csr_write_type == ofs_csr_pkg::UPPER32) begin
                 // update 32 MSBs
                 if (i >= 32) csr_reg[addr[CSR_REG_ADDR_WIDTH-1:3]][i-32] <= 1'b0;
              end else begin
                 // update 32 LSBs
                 if (i < 32) csr_reg[addr[CSR_REG_ADDR_WIDTH-1:3]][i] <= 1'b0;
              end    
            end
         end 
         else begin
            // HW updates (set) only for active-high level
            if (~csr_reg[mask_addr[CSR_REG_ADDR_WIDTH-1:3]][i] & update_val[i]) begin
               csr_reg[addr[CSR_REG_ADDR_WIDTH-1:3]][i] <= 1'b1;
            end
         end
      end
   end
end
endtask

endmodule
