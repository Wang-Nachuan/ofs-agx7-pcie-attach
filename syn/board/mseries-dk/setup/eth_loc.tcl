# Copyright (C) 2023 Intel Corporation.
# SPDX-License-Identifier: MIT

#
# Description
#-----------------------------------------------------------------------------
#
# Pin and location assignments
#
#-----------------------------------------------------------------------------

# set_location_assignment PIN_BL2 -to qsfpdd0_rx_n[0]
# set_location_assignment PIN_BK1 -to qsfpdd0_rx_p[0]
# set_location_assignment PIN_BG2 -to qsfpdd0_rx_n[1]
# set_location_assignment PIN_BF1 -to qsfpdd0_rx_p[1]
# set_location_assignment PIN_BH5 -to qsfpdd0_rx_n[2]
# set_location_assignment PIN_BJ4 -to qsfpdd0_rx_p[2]
# set_location_assignment PIN_BC2 -to qsfpdd0_rx_n[3]
# set_location_assignment PIN_BB1 -to qsfpdd0_rx_p[3]
# set_location_assignment PIN_BD5 -to qsfpdd0_rx_n[4]
# set_location_assignment PIN_BE4 -to qsfpdd0_rx_p[4]
# set_location_assignment PIN_AW2 -to qsfpdd0_rx_n[5]
# set_location_assignment PIN_AV1 -to qsfpdd0_rx_p[5]
# set_location_assignment PIN_AY5 -to qsfpdd0_rx_n[6]
# set_location_assignment PIN_BA4 -to qsfpdd0_rx_p[6]
# set_location_assignment PIN_AR2 -to qsfpdd0_rx_n[7]
# set_location_assignment PIN_AP1 -to qsfpdd0_rx_p[7]
# set_location_assignment PIN_BR8 -to qsfpdd0_tx_n[0]
# set_location_assignment PIN_BP7 -to qsfpdd0_tx_p[0]
# set_location_assignment PIN_BL8 -to qsfpdd0_tx_n[1]
# set_location_assignment PIN_BK7 -to qsfpdd0_tx_p[1]
# set_location_assignment PIN_BH11 -to qsfpdd0_tx_n[2]
# set_location_assignment PIN_BJ10 -to qsfpdd0_tx_p[2]
# set_location_assignment PIN_BG8 -to qsfpdd0_tx_n[3]
# set_location_assignment PIN_BF7 -to qsfpdd0_tx_p[3]
# set_location_assignment PIN_BD11 -to qsfpdd0_tx_n[4]
# set_location_assignment PIN_BE10 -to qsfpdd0_tx_p[4]
# set_location_assignment PIN_BC8 -to qsfpdd0_tx_n[5]
# set_location_assignment PIN_BB7 -to qsfpdd0_tx_p[5]
# set_location_assignment PIN_AY11 -to qsfpdd0_tx_n[6]
# set_location_assignment PIN_BA10 -to qsfpdd0_tx_p[6]
# set_location_assignment PIN_AW8 -to qsfpdd0_tx_n[7]
# set_location_assignment PIN_AV7 -to qsfpdd0_tx_p[7]

# set_location_assignment PIN_ED5 -to qsfpdd1_rx_n[0]
# set_location_assignment PIN_EC4 -to qsfpdd1_rx_p[0]
# set_location_assignment PIN_EA2 -to qsfpdd1_rx_n[1]
# set_location_assignment PIN_EB1 -to qsfpdd1_rx_p[1]
# set_location_assignment PIN_DY5 -to qsfpdd1_rx_n[2]
# set_location_assignment PIN_DW4 -to qsfpdd1_rx_p[2]
# set_location_assignment PIN_DU2 -to qsfpdd1_rx_n[3]
# set_location_assignment PIN_DV1 -to qsfpdd1_rx_p[3]
# set_location_assignment PIN_DT5 -to qsfpdd1_rx_n[4]
# set_location_assignment PIN_DR4 -to qsfpdd1_rx_p[4]
# set_location_assignment PIN_DN2 -to qsfpdd1_rx_n[5]
# set_location_assignment PIN_DP1 -to qsfpdd1_rx_p[5]
# set_location_assignment PIN_DM5 -to qsfpdd1_rx_n[6]
# set_location_assignment PIN_DL4 -to qsfpdd1_rx_p[6]
# set_location_assignment PIN_DJ2 -to qsfpdd1_rx_n[7]
# set_location_assignment PIN_DK1 -to qsfpdd1_rx_p[7]
# set_location_assignment PIN_EA8 -to qsfpdd1_tx_n[0]
# set_location_assignment PIN_EB7 -to qsfpdd1_tx_p[0]
# set_location_assignment PIN_DY11 -to qsfpdd1_tx_n[1]
# set_location_assignment PIN_DW10 -to qsfpdd1_tx_p[1]
# set_location_assignment PIN_DU8 -to qsfpdd1_tx_n[2]
# set_location_assignment PIN_DV7 -to qsfpdd1_tx_p[2]
# set_location_assignment PIN_DT11 -to qsfpdd1_tx_n[3]
# set_location_assignment PIN_DR10 -to qsfpdd1_tx_p[3]
# set_location_assignment PIN_DN8 -to qsfpdd1_tx_n[4]
# set_location_assignment PIN_DP7 -to qsfpdd1_tx_p[4]
# set_location_assignment PIN_DM11 -to qsfpdd1_tx_n[5]
# set_location_assignment PIN_DL10 -to qsfpdd1_tx_p[5]
# set_location_assignment PIN_DJ8 -to qsfpdd1_tx_n[6]
# set_location_assignment PIN_DK7 -to qsfpdd1_tx_p[6]
# set_location_assignment PIN_DH11 -to qsfpdd1_tx_n[7]
# set_location_assignment PIN_DG10 -to qsfpdd1_tx_p[7]

# set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to hssi_if[*].tx*[*]
# set_instance_assignment -name IO_STANDARD "HIGH SPEED DIFFERENTIAL I/O" -to hssi_if[*].rx*[*]
# set_instance_assignment -name HSSI_PARAMETER "rx_ac_couple_enable=ENABLE" -to hssi_if[*].rx_p
# set_instance_assignment -name HSSI_PARAMETER "rx_onchip_termination=RX_ONCHIP_TERMINATION_R_2" -to hssi_if[*].rx_p


# set_location_assignment PIN_FV3  -to qsfpdd0_modsel_n
# set_location_assignment PIN_FU4  -to qsfpdd0_reset_n
# set_location_assignment PIN_FV5  -to qsfpdd0_modprs_n
# set_location_assignment PIN_GA8  -to qsfpdd0_int_n
# set_location_assignment PIN_FU6  -to qsfpdd0_lpmode
# set_location_assignment PIN_FV9  -to qsfpdd1_modsel_n
# set_location_assignment PIN_FU10 -to qsfpdd1_reset_n
# set_location_assignment PIN_FY7  -to qsfpdd1_modprs_n
# set_location_assignment PIN_FY9  -to qsfpdd1_int_n
# set_location_assignment PIN_GA10 -to qsfpdd1_lpmode
# set_location_assignment PIN_E26 -to fpga_led0
# set_location_assignment PIN_B27 -to fpga_led1
# set_location_assignment PIN_A26 -to fpga_led2
# set_location_assignment PIN_D29 -to fpga_led3
# set_instance_assignment -name IO_STANDARD "1.2 V" -to fpga_led0
# set_instance_assignment -name IO_STANDARD "1.2 V" -to fpga_led1
# set_instance_assignment -name IO_STANDARD "1.2 V" -to fpga_led2
# set_instance_assignment -name IO_STANDARD "1.2 V" -to fpga_led3
# set_location_assignment PIN_E28 -to qsfpdd0_led0
# set_location_assignment PIN_B29 -to qsfpdd0_led1
# set_location_assignment PIN_D31 -to qsfpdd1_led0
# set_location_assignment PIN_E30 -to qsfpdd1_led1
# set_instance_assignment -name IO_STANDARD "1.1 V" -to qsfpdd0_modsel_n
# set_instance_assignment -name IO_STANDARD "1.1 V" -to qsfpdd0_reset_n
# set_instance_assignment -name IO_STANDARD "1.1 V" -to qsfpdd0_modprs_n
# set_instance_assignment -name IO_STANDARD "1.1 V" -to qsfpdd0_int_n
# set_instance_assignment -name IO_STANDARD "1.1 V" -to qsfpdd0_lpmode
# set_instance_assignment -name IO_STANDARD "1.1 V" -to qsfpdd1_modsel_n
# set_instance_assignment -name IO_STANDARD "1.1 V" -to qsfpdd1_reset_n
# set_instance_assignment -name IO_STANDARD "1.1 V" -to qsfpdd1_modprs_n
# set_instance_assignment -name IO_STANDARD "1.1 V" -to qsfpdd1_int_n
# set_instance_assignment -name IO_STANDARD "1.1 V" -to qsfpdd1_lpmode

