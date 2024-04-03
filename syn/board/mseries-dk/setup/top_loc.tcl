# Copyright (C) 2020 Intel Corporation.
# SPDX-License-Identifier: MIT

#
# Description
#-----------------------------------------------------------------------------
#
# Pin and location assignments
#
#-----------------------------------------------------------------------------


set_location_assignment PIN_G30 -to SYS_REFCLK
set_location_assignment PIN_H31 -to "SYS_REFCLK(n)"
set_instance_assignment -name IO_STANDARD "1.2V TRUE DIFFERENTIAL SIGNALING" -to SYS_REFCLK
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to SYS_REFCLK

set_global_assignment -name PRESERVE_UNUSED_XCVR_CHANNEL ON

# set_location_assignment PIN_ -to qsfp_ref_clk
# set_location_assignment PIN_ -to "qsfp_ref_clk(n)"

# set_instance_assignment -name IO_STANDARD    "DIFFERENTIAL LVPECL"                           -to qsfp_ref_clk
# set_instance_assignment -name HSSI_PARAMETER "refclk_divider_enable_termination=enable_term" -to qsfp_ref_clk
# set_instance_assignment -name HSSI_PARAMETER "refclk_divider_enable_3p3v=disable_3p3v_tol"   -to qsfp_ref_clk
# set_instance_assignment -name HSSI_PARAMETER "refclk_divider_disable_hysteresis=enable_hyst" -to qsfp_ref_clk
# set_instance_assignment -name HSSI_PARAMETER "refclk_divider_powerdown_mode=false"           -to qsfp_ref_clk
