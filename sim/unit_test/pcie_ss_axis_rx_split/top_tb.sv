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

    always #1064 clk = ~clk;   // 470MHz
    always #5000 csr_clk = ~csr_clk;   // 100MHz

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        csr_clk = 1'b0;
        csr_rst_n = 1'b0;

        async_rst_n = 1'b0;
        #1us;
        async_rst_n = 1'b1;
    end

    always @(posedge clk) rst_n <= async_rst_n;
    always @(posedge csr_clk) csr_rst_n <= async_rst_n;

    initial begin
        fork begin : timeout_thread
            // timeout thread, wait for TIMEOUT period to pass
            #(`TIMEOUT);

            // The test hasn't finished within TIMEOUT Period
            @(posedge csr_clk);
            $fatal(1, "TIMEOUT!");

            disable timeout_thread;
        end
        join
    end

    test test(.clk, .rst_n, .csr_clk, .csr_rst_n);

endmodule
