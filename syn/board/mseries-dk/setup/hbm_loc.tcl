# Copyright (C) 2024 Intel Corporation.
# SPDX-License-Identifier: MIT

#
# Description
#-----------------------------------------------------------------------------
#
# HBM/NoC pin and location assignments
#
#-----------------------------------------------------------------------------
set NUM_HBM 1
set NUM_NOC_CHANNELS 8
# BOTTOM
set_location_assignment PIN_EC36 -to uib_refclk[0]
set_location_assignment PIN_EE56 -to noc_ctrl_refclk[0]
# set_location_assignment PIN_EF29 -to core_pll_refclk_clk[0]

# TOP
set_location_assignment PIN_AR36 -to uib_refclk[1]
set_location_assignment PIN_AU52 -to noc_ctrl_refclk[1]

set_instance_assignment -name IO_STANDARD "1.2V TRUE DIFFERENTIAL SIGNALING" -to uib_refclk

# set_instance_assignment -name IO_STANDARD "1.2V TRUE DIFFERENTIAL SIGNALING" -to core_pll_refclk_clk

# NoC settings
set_instance_assignment -name NOC_GROUP NOC_0 -to hbm|*|tniu_ch*|target_0.target_inst_0 -entity hbm_ss
set_instance_assignment -name NOC_GROUP NOC_0 -to noc_ctrl|noc_ctrl|pll_inst -entity hbm_ss
set_instance_assignment -name NOC_GROUP NOC_0 -to noc_ctrl|noc_ctrl|ssm_inst -entity hbm_ss

# set_instance_assignment -name NOC_GROUP NOC_1 -to top|local_mem_wrapper|hbm_ss_top|hbm_ss|hbm_1|tniu_ch*|target_0.target_inst_0

# Pre-selected Top and bottom edge coordinates for NoC channels
set noc_xcoord {{X134 X204 X160 X242 X105 X188 X149 X215 X269 X350 X312 X376 X258 X323 X269 X365}
                {X134 X204 X160 X242 X105 X188 X149 X215 X269 X350 X312 X376 X258 X323 X269 X365}}

set noc_ycoord {Y6 Y417}

# Constraint INIU mapping
for {set device 0} {$device < $NUM_HBM} {incr device} {
    for {set channel 0} {$channel < $NUM_NOC_CHANNELS} {incr channel} {
        set xcoord [lindex $noc_xcoord $device $channel]
        set ycoord [lindex $noc_ycoord $device]
        set ch [expr $channel % ($NUM_NOC_CHANNELS/2)]
        set u  [expr $channel / ($NUM_NOC_CHANNELS/2)]
        set_location_assignment NOCINITIATOR_${xcoord}_${ycoord}_N202 -to top|local_mem_wrapper|hbm_ss_top|hbm_ss|noc_top|noc_initiator_with_wstrb|iniu_${channel}|initiator_inst_0
    }
}
