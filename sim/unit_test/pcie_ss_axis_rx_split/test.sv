// Copyright (C) 2024 Intel Corporation.
// SPDX-License-Identifier: MIT

//
// Description
//-----------------------------------------------------------------------------
//
//   Test OFS modules used at the end of the PCIe SS AXI-S variant
//
//-----------------------------------------------------------------------------

module test
  #(
    parameter DATA_WIDTH = 512,
    parameter NUM_OF_SEG = 1//DATA_WIDTH / 256
    )
   (
    input bit clk,
    input bit rst_n,
    input bit csr_clk,
    input bit csr_rst_n
    );

    localparam HDR_WIDTH = 256;

    int log_in_fd;
    int log_out_fd;

    rand_tlp_pkg::rand_tlp tlp;
    rand_tlp_pkg::rand_tlp_stream#(.DATA_WIDTH(DATA_WIDTH),
                                   .NUM_OF_SEG(NUM_OF_SEG),
                                   .SB_HEADERS(1),
                                   .MAX_SOP_PER_CYCLE(NUM_OF_SEG)) tlp_stream_in;

    rand_tlp_pkg::rand_tlp tlp_out;
    rand_tlp_pkg::bus_to_tlp#(.DATA_WIDTH(DATA_WIDTH),
                              .NUM_OF_SEG(NUM_OF_SEG),
                              .SB_HEADERS(0)) tlp_stream_out;

    int cnt;
    logic done;

    // Reference queue, used to compare the input stream to the output
    rand_tlp_pkg::rand_tlp tlp_ref_queue[$];
    rand_tlp_pkg::rand_tlp tlp_ref;

    initial begin
        log_in_fd = $fopen("test_tlp_stream_in.tsv", "w");
        log_out_fd = $fopen("test_tlp_stream_out.tsv", "w");

        tlp_stream_in = new();
        tlp_stream_out = new();
    end


    // ====================================================================
    //
    //  Source stream of random TLP packets.
    //
    // ====================================================================

    logic in_tready;
    logic in_tvalid;
    logic [DATA_WIDTH-1:0] in_tdata;
    logic [DATA_WIDTH/8-1:0] in_tkeep;
    logic in_tlast;
    logic [NUM_OF_SEG-1:0] in_tuser_vendor;
    logic [NUM_OF_SEG-1:0] in_tuser_last_segment;
    logic [NUM_OF_SEG-1:0] in_tuser_hvalid;
    logic [NUM_OF_SEG-1:0][HDR_WIDTH-1:0] in_tuser_hdr;

    always_ff @(posedge clk) begin
        if (rst_n && (in_tready || !in_tvalid)) begin
            tlp_stream_in.next_cycle(done);
            in_tvalid <= tlp_stream_in.tvalid;
            in_tdata <= tlp_stream_in.tdata;
            in_tkeep <= tlp_stream_in.tkeep;
            in_tlast <= tlp_stream_in.tlast;
            in_tuser_vendor <= tlp_stream_in.tuser_vendor;
            in_tuser_last_segment <= tlp_stream_in.tuser_last_segment;
            in_tuser_hvalid <= tlp_stream_in.tuser_hvalid;
            in_tuser_hdr <= tlp_stream_in.tuser_hdr;
        end

        if (!rst_n) begin
            in_tvalid <= 1'b0;
        end
    end

    always_ff @(posedge clk) begin
        if (rst_n) begin
            if (in_tvalid && in_tready) begin
                if (|(in_tuser_hvalid)) begin
                    $fwrite(log_in_fd, "%0t: hvalid b%b hdr %h\n", $time,
                            in_tuser_hvalid,
                            in_tuser_hdr);
                end
                $fwrite(log_in_fd, "%0t: last %b last_seg b%b data %h keep %h\n", $time,
                        in_tlast,
                        in_tuser_last_segment,
                        in_tdata,
                        in_tkeep);
            end

            while (tlp_stream_in.tlp_queue.size() > 0) begin
                tlp = tlp_stream_in.tlp_queue.pop_front();
                tlp_ref_queue.push_back(tlp);
                $fwrite(log_in_fd, "\n%0t: %0s\n", $time, tlp.sfmt());

                cnt <= cnt + 1;
                if (cnt == 10000)
                    done <= 1'b1;
            end
        end

        if (!rst_n) begin
            cnt <= 0;
            done <= 1'b0;
        end
    end


    // ====================================================================
    //
    //  DUT
    //
    // ====================================================================

    pcie_ss_axis_if#(.DATA_W(DATA_WIDTH), .USER_W(1+HDR_WIDTH)) axi_in(clk, rst_n);
    pcie_ss_axis_if#(.DATA_W(DATA_WIDTH), .USER_W(1)) out_merged(clk, rst_n);

    assign axi_in.tvalid = in_tvalid;
    assign axi_in.tlast = in_tlast;
    assign axi_in.tuser_vendor = { in_tuser_hdr[0], in_tuser_vendor[0] };
    assign axi_in.tdata = in_tdata;
    assign axi_in.tkeep = in_tkeep;

    ofs_fim_pcie_ss_sb2ib sb2ib
       (
        .stream_in(axi_in),
        .stream_out(out_merged)
        );

    assign in_tready = axi_in.tready;

    always_ff @(posedge clk) begin
        out_merged.tready <= ($urandom() & 4'hf) != 4'hf;
    end


    // ====================================================================
    //
    //  Compare output of the DUT to the source stream
    //
    // ====================================================================

    logic out_sop;

    always_ff @(posedge clk) begin
        if (rst_n && out_merged.tvalid && out_merged.tready) begin
            $fwrite(log_out_fd, "%0t: last %b data %h keep %h tuser %h\n", $time,
                    out_merged.tlast, out_merged.tdata, out_merged.tkeep,
                    out_merged.tuser_vendor);

            tlp_stream_out.push(out_merged.tdata, out_merged.tkeep, out_merged.tlast,
                                out_merged.tuser_vendor, out_merged.tlast,
                                out_sop, '0);

            out_sop <= out_merged.tlast;
        end

        if (!rst_n) begin
            out_sop <= 1'b1;
        end
    end

    always_ff @(posedge clk) begin
        if (rst_n) begin
            while (tlp_stream_out.tlp_queue.size() > 0) begin
                tlp_out = tlp_stream_out.tlp_queue.pop_front();
                $fwrite(log_out_fd, "%0t: %0s\n", $time, tlp_out.sfmt());
                tlp_out.display();

                assert(tlp_ref_queue.size() > 0) else
                    $fatal(1, "Output TLP with no corresponding input!");
                tlp_ref = tlp_ref_queue.pop_front();
                tlp_out.compare(tlp_ref);
            end
        end
    end

    always_ff @(posedge clk) begin
        if (rst_n && done && (tlp_ref_queue.size() == 0)) begin
            $display("\nPass!");
            $finish(0);
        end
    end

endmodule
