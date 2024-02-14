// Copyright (C) 2024 Intel Corporation.
// SPDX-License-Identifier: MIT

//
// Description
//-----------------------------------------------------------------------------
//
//   Top level testbench with OFS top level module instantiated as DUT
//
//-----------------------------------------------------------------------------

module top_tb ();

//Timeout in 1ms
`ifdef SIM_TIMEOUT
    `define TIMEOUT `SIM_TIMEOUT
`else
    `define TIMEOUT 1000000000
`endif

    initial begin
`ifdef VCD_ON  
   `ifndef VCD_OFF
        $vcdpluson;
        $vcdplusmemon();
   `endif 
`endif
    end

    logic async_rst_n;
    logic clk, rst_n;
    logic csr_clk, csr_rst_n;

    always #100 clk = ~clk;
    always #500 csr_clk = ~csr_clk;

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        csr_clk = 1'b0;
        csr_rst_n = 1'b0;
        async_rst_n = 1'b0;
    end

    always @(posedge clk) rst_n <= async_rst_n;
    always @(posedge csr_clk) csr_rst_n <= async_rst_n;

    logic test0_en = 1'b0;
    logic test0_done;
    logic test1_en = 1'b0;
    logic test1_done;
    logic test2_en = 1'b0;
    logic test2_done;
    logic test3_en = 1'b0;
    logic test3_done;
    logic test4_en = 1'b0;
    logic test4_done;
    logic test5_en = 1'b0;
    logic test5_done;
    logic test6_en = 1'b0;
    logic test6_done;

`define RUN_TEST(enable_flag, done_flag) \
    enable_flag = 1'b1;                  \
    async_rst_n = 1'b1;                  \
    fork begin                           \
        fork                             \
            wait(done_flag);             \
            begin                        \
                #(`TIMEOUT);             \
                $fatal(1, "TIMEOUT!");   \
            end                          \
        join_any                         \
        disable fork;                    \
    end join                             \
    enable_flag = 1'b0;                  \
    async_rst_n = 1'b0;                  \
    #1us

    initial begin
        `RUN_TEST(test0_en, test0_done);
        `RUN_TEST(test1_en, test1_done);
        `RUN_TEST(test2_en, test2_done);

        `RUN_TEST(test3_en, test3_done);
        `RUN_TEST(test4_en, test4_done);
        `RUN_TEST(test5_en, test5_done);
        `RUN_TEST(test6_en, test6_done);

        $finish;
    end

    // side-band to in-band module test
    test_sb2ib#(.DATA_WIDTH(512))  test0(.clk, .rst_n(rst_n && test0_en), .csr_clk, .csr_rst_n, .done(test0_done));
    test_sb2ib#(.DATA_WIDTH(1024)) test1(.clk, .rst_n(rst_n && test1_en), .csr_clk, .csr_rst_n, .done(test1_done));
    test_sb2ib#(.DATA_WIDTH(2048)) test2(.clk, .rst_n(rst_n && test2_en), .csr_clk, .csr_rst_n, .done(test2_done));

    // multiple headers per cycle to one header realignment test
    test_rx_seg_align#(.DATA_WIDTH(512),  .SB_HEADERS(1)) test3(.clk, .rst_n(rst_n && test3_en), .csr_clk, .csr_rst_n, .done(test3_done));
    test_rx_seg_align#(.DATA_WIDTH(512),  .SB_HEADERS(0)) test4(.clk, .rst_n(rst_n && test4_en), .csr_clk, .csr_rst_n, .done(test4_done));
    test_rx_seg_align#(.DATA_WIDTH(1024), .SB_HEADERS(1)) test5(.clk, .rst_n(rst_n && test5_en), .csr_clk, .csr_rst_n, .done(test5_done));
    test_rx_seg_align#(.DATA_WIDTH(1024), .SB_HEADERS(0)) test6(.clk, .rst_n(rst_n && test6_en), .csr_clk, .csr_rst_n, .done(test6_done));

endmodule
