# Copyright 2023 Intel Corporation
# SPDX-License-Identifier: MIT

DEFINES="+define+SIM_MODE \
 +define+VCD_ON \
+define+INCLUDE_PCIE_BFM \
 +define+SIM_USE_PCIE_GEN3X16_BFM \
 +define+SIM_PCIE_CPL_TIMEOUT \
 +define+SIM_PCIE_CPL_TIMEOUT_CYCLES=\"26'd12500000\" \
 +define+INCLUDE_UART \
 +define+BASE_AFU=\"dummy_afu\" \
 +define+RP_MAX_TAGS=64"

VLOG_SUPPRESS="8386,7033,7061,2244,12003,2388"
