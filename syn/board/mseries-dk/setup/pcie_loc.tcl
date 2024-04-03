# Copyright (C) 2024 Intel Corporation.
# SPDX-License-Identifier: MIT

#
# Description
#-----------------------------------------------------------------------------
#
# Pin and location assignments
#
#-----------------------------------------------------------------------------
# PCIe location
set_location_assignment PIN_CH69 -to PCIE_RX_P[0]
set_location_assignment PIN_CD69 -to PCIE_RX_P[1]
set_location_assignment PIN_BY69 -to PCIE_RX_P[2]
set_location_assignment PIN_BU66 -to PCIE_RX_P[3]
set_location_assignment PIN_BT69 -to PCIE_RX_P[4]
set_location_assignment PIN_BN66 -to PCIE_RX_P[5]
set_location_assignment PIN_BM69 -to PCIE_RX_P[6]
set_location_assignment PIN_BJ66 -to PCIE_RX_P[7]
set_location_assignment PIN_BH69 -to PCIE_RX_P[8]
set_location_assignment PIN_BE66 -to PCIE_RX_P[9]
set_location_assignment PIN_BD69 -to PCIE_RX_P[10]
set_location_assignment PIN_BA66 -to PCIE_RX_P[11]
set_location_assignment PIN_AY69 -to PCIE_RX_P[12]
set_location_assignment PIN_AU66 -to PCIE_RX_P[13]
set_location_assignment PIN_AT69 -to PCIE_RX_P[14]
set_location_assignment PIN_AN66 -to PCIE_RX_P[15]
set_location_assignment PIN_CG68 -to PCIE_RX_N[0]
set_location_assignment PIN_CC68 -to PCIE_RX_N[1]
set_location_assignment PIN_BW68 -to PCIE_RX_N[2]
set_location_assignment PIN_BV65 -to PCIE_RX_N[3]
set_location_assignment PIN_BR68 -to PCIE_RX_N[4]
set_location_assignment PIN_BP65 -to PCIE_RX_N[5]
set_location_assignment PIN_BL68 -to PCIE_RX_N[6]
set_location_assignment PIN_BK65 -to PCIE_RX_N[7]
set_location_assignment PIN_BG68 -to PCIE_RX_N[8]
set_location_assignment PIN_BF65 -to PCIE_RX_N[9]
set_location_assignment PIN_BC68 -to PCIE_RX_N[10]
set_location_assignment PIN_BB65 -to PCIE_RX_N[11]
set_location_assignment PIN_AW68 -to PCIE_RX_N[12]
set_location_assignment PIN_AV65 -to PCIE_RX_N[13]
set_location_assignment PIN_AR68 -to PCIE_RX_N[14]
set_location_assignment PIN_AP65 -to PCIE_RX_N[15]

set_location_assignment PIN_CJ66 -to PCIE_TX_P[0]
set_location_assignment PIN_CH63 -to PCIE_TX_P[1]
set_location_assignment PIN_CE66 -to PCIE_TX_P[2]
set_location_assignment PIN_CD63 -to PCIE_TX_P[3]
set_location_assignment PIN_CA66 -to PCIE_TX_P[4]
set_location_assignment PIN_BY63 -to PCIE_TX_P[5]
set_location_assignment PIN_BT63 -to PCIE_TX_P[6]
set_location_assignment PIN_BM63 -to PCIE_TX_P[7]
set_location_assignment PIN_BH63 -to PCIE_TX_P[8]
set_location_assignment PIN_BE60 -to PCIE_TX_P[9]
set_location_assignment PIN_BD63 -to PCIE_TX_P[10]
set_location_assignment PIN_BA60 -to PCIE_TX_P[11]
set_location_assignment PIN_AY63 -to PCIE_TX_P[12]
set_location_assignment PIN_AU60 -to PCIE_TX_P[13]
set_location_assignment PIN_AT63 -to PCIE_TX_P[14]
set_location_assignment PIN_AN60 -to PCIE_TX_P[15]
set_location_assignment PIN_CK65 -to PCIE_TX_N[0]
set_location_assignment PIN_CG62 -to PCIE_TX_N[1]
set_location_assignment PIN_CF65 -to PCIE_TX_N[2]
set_location_assignment PIN_CC62 -to PCIE_TX_N[3]
set_location_assignment PIN_CB65 -to PCIE_TX_N[4]
set_location_assignment PIN_BW62 -to PCIE_TX_N[5]
set_location_assignment PIN_BR62 -to PCIE_TX_N[6]
set_location_assignment PIN_BL62 -to PCIE_TX_N[7]
set_location_assignment PIN_BG62 -to PCIE_TX_N[8]
set_location_assignment PIN_BF59 -to PCIE_TX_N[9]
set_location_assignment PIN_BC62 -to PCIE_TX_N[10]
set_location_assignment PIN_BB59 -to PCIE_TX_N[11]
set_location_assignment PIN_AW62 -to PCIE_TX_N[12]
set_location_assignment PIN_AV59 -to PCIE_TX_N[13]
set_location_assignment PIN_AR62 -to PCIE_TX_N[14]
set_location_assignment PIN_AP59 -to PCIE_TX_N[15]

set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to PCIE_RX_P
set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to PCIE_TX_P

set_location_assignment PIN_BY59 -to PCIE_REFCLK0
set_location_assignment PIN_CA60 -to "PCIE_REFCLK0(n)"

set_location_assignment PIN_BU60 -to PCIE_REFCLK1
set_location_assignment PIN_BT59 -to "PCIE_REFCLK1(n)"

set_location_assignment PIN_AP53 -to PCIE_RESET_N

set_instance_assignment -name IO_STANDARD HCSL -to PCIE_REFCLK0
set_instance_assignment -name IO_STANDARD HCSL -to PCIE_REFCLK1
set_instance_assignment -name IO_STANDARD "1.0 V" -to PCIE_RESET_N
