# Copyright (C) 2020 Intel Corporation.
# SPDX-License-Identifier: MIT

#
# Description
#-----------------------------------------------------------------------------
#
#   Platform specific SDC 
#
#-----------------------------------------------------------------------------

# The following constraints are a result of incorrect timing cuts applied to
# the DCFIFO IP (found in fim_resync.sv).  The path is ignored with the NOCUT
# option, and can be fixed with the DISABLE_EMBEDDED_TIMING_CONSTRAINT QSF 
# assignment.  However, this disbaled the timing constraint across all
# instances of fim_resync.  Therefore, the following constraints are 
# explicitely applied here.
add_reset_sync_sdc {afu_top|*|*|*|*|*he_hssi_inst|GenCPR[*].hssi_data_sync|fifo|dcfifo|dcfifo_component|auto_generated|rdaclr|*|clrn}
add_reset_sync_sdc {afu_top|*|*|*|*|*he_hssi_inst|GenCPR[*].hssi_data_sync|fifo|rst_rclk_resync|resync_chains[*].*|*|clrn}

