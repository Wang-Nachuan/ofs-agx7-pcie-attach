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
    logic test7_en = 1'b0;
    logic test7_done;
    logic test8_en = 1'b0;
    logic test8_done;
    logic test9_en = 1'b0;
    logic test9_done;
    logic test10_en = 1'b0;
    logic test10_done;
    logic test11_en = 1'b0;
    logic test11_done;
    logic test12_en = 1'b0;
    logic test12_done;
    logic test13_en = 1'b0;
    logic test13_done;
    logic test14_en = 1'b0;
    logic test14_done;
    logic test15_en = 1'b0;
    logic test15_done;
    logic test16_en = 1'b0;
    logic test16_done;

`define RUN_TEST(test) \
    $display("Running %0s:", `"test`");  \
    test``_en = 1'b1;                    \
    async_rst_n = 1'b1;                  \
    fork begin                           \
        fork                             \
            wait(test``_done);           \
            begin                        \
                #(`TIMEOUT);             \
                $fatal(1, "TIMEOUT!");   \
            end                          \
        join_any                         \
        disable fork;                    \
    end join                             \
    test``_en = 1'b0;                    \
    async_rst_n = 1'b0;                  \
    #1us

    initial begin
        //
        // Sequencer for all tests. If you are debugging one that fails,
        // earlier tests can be temporarily disabled by commenting out
        // RUN_TEST.
        //

        `RUN_TEST(test0);
        `RUN_TEST(test1);
        `RUN_TEST(test2);

        `RUN_TEST(test3);
        `RUN_TEST(test4);
        `RUN_TEST(test5);
        `RUN_TEST(test6);

        `RUN_TEST(test7);
        `RUN_TEST(test8);
        `RUN_TEST(test9);
        `RUN_TEST(test10);

        `RUN_TEST(test11);
        `RUN_TEST(test12);
        `RUN_TEST(test13);
        `RUN_TEST(test14);
        `RUN_TEST(test15);
        `RUN_TEST(test16);

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

    // in-band to side-band module test
    test_ib2sb#(.DATA_WIDTH(512), .NUM_OF_SEG(1)) test7(.clk, .rst_n(rst_n && test7_en), .csr_clk, .csr_rst_n, .done(test7_done));
    test_ib2sb#(.DATA_WIDTH(512))  test8(.clk, .rst_n(rst_n && test8_en), .csr_clk, .csr_rst_n, .done(test8_done));
    test_ib2sb#(.DATA_WIDTH(1024)) test9(.clk, .rst_n(rst_n && test9_en), .csr_clk, .csr_rst_n, .done(test9_done));
    test_ib2sb#(.DATA_WIDTH(2048)) test10(.clk, .rst_n(rst_n && test10_en), .csr_clk, .csr_rst_n, .done(test10_done));

    test_rx_dual_stream#(.DATA_WIDTH(512), .NUM_OF_SEG(1), .SB_HEADERS(1)) test11(.clk, .rst_n(rst_n && test11_en), .csr_clk, .csr_rst_n, .done(test11_done));
    test_rx_dual_stream#(.DATA_WIDTH(512), .SB_HEADERS(1))  test12(.clk, .rst_n(rst_n && test12_en), .csr_clk, .csr_rst_n, .done(test12_done));
    test_rx_dual_stream#(.DATA_WIDTH(1024), .SB_HEADERS(1)) test13(.clk, .rst_n(rst_n && test13_en), .csr_clk, .csr_rst_n, .done(test13_done));
    test_rx_dual_stream#(.DATA_WIDTH(512), .NUM_OF_SEG(1), .SB_HEADERS(0)) test14(.clk, .rst_n(rst_n && test14_en), .csr_clk, .csr_rst_n, .done(test14_done));
    test_rx_dual_stream#(.DATA_WIDTH(512), .SB_HEADERS(0))  test15(.clk, .rst_n(rst_n && test15_en), .csr_clk, .csr_rst_n, .done(test15_done));
    test_rx_dual_stream#(.DATA_WIDTH(1024), .SB_HEADERS(0)) test16(.clk, .rst_n(rst_n && test16_en), .csr_clk, .csr_rst_n, .done(test16_done));

endmodule
