# Copyright (C) 2020 Intel Corporation.
# SPDX-License-Identifier: MIT

#
# Description
#-----------------------------------------------------------------------------
#
# Memory pin and location assignments
#
#-----------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# DDR4 Component CH0 3C/3D
#-----------------------------------------------------------------------------
set_location_assignment PIN_AD32 -to "ddr4_mem[0].ref_clk(n)"
set_location_assignment PIN_AA31 -to ddr4_mem[0].ref_clk
set_location_assignment PIN_AV37 -to ddr4_mem[0].bg[1]
set_location_assignment PIN_AK28 -to ddr4_mem[0].bg[0]
set_location_assignment PIN_AN27 -to ddr4_mem[0].ba[1]
set_location_assignment PIN_AD28 -to ddr4_mem[0].ba[0]
set_location_assignment PIN_AA27 -to ddr4_mem[0].alert_n[0]
set_location_assignment PIN_AK30 -to ddr4_mem[0].a[16]
set_location_assignment PIN_AN29 -to ddr4_mem[0].a[15]
set_location_assignment PIN_AD30 -to ddr4_mem[0].a[14]
set_location_assignment PIN_AA29 -to ddr4_mem[0].a[13]
set_location_assignment PIN_AK32 -to ddr4_mem[0].a[12]
set_location_assignment PIN_W30  -to ddr4_mem[0].a[11]
set_location_assignment PIN_U29  -to ddr4_mem[0].a[10]
set_location_assignment PIN_L30  -to ddr4_mem[0].a[9]
set_location_assignment PIN_N29  -to ddr4_mem[0].a[8]
set_location_assignment PIN_W32  -to ddr4_mem[0].a[7]
set_location_assignment PIN_U31  -to ddr4_mem[0].a[6]
set_location_assignment PIN_L32  -to ddr4_mem[0].a[5]
set_location_assignment PIN_N31  -to ddr4_mem[0].a[4]
set_location_assignment PIN_W34  -to ddr4_mem[0].a[3]
set_location_assignment PIN_U33  -to ddr4_mem[0].a[2]
set_location_assignment PIN_L34  -to ddr4_mem[0].a[1]
set_location_assignment PIN_N33  -to ddr4_mem[0].a[0]
set_location_assignment PIN_BF34 -to ddr4_mem[0].par[0]
set_location_assignment PIN_AT34 -to ddr4_mem[0].ck_n[0]
set_location_assignment PIN_AV33 -to ddr4_mem[0].ck[0]
set_location_assignment PIN_BC35 -to ddr4_mem[0].cke[0]
set_location_assignment PIN_AV35 -to ddr4_mem[0].odt[0]
set_location_assignment PIN_BF38 -to ddr4_mem[0].act_n[0]
set_location_assignment PIN_AN31 -to ddr4_mem[0].oct_rzqin
set_location_assignment PIN_BC37 -to ddr4_mem[0].cs_n[0]
set_location_assignment PIN_AT38 -to ddr4_mem[0].reset_n[0]

# CH0 DQS0
set_location_assignment PIN_J13  -to ddr4_mem[0].dbi_n[0]
set_location_assignment PIN_D15  -to ddr4_mem[0].dqs_n[0]
set_location_assignment PIN_B13  -to ddr4_mem[0].dqs[0]
set_location_assignment PIN_H11  -to ddr4_mem[0].dq[0]
set_location_assignment PIN_B17  -to ddr4_mem[0].dq[1]
set_location_assignment PIN_D11  -to ddr4_mem[0].dq[2]
set_location_assignment PIN_H19  -to ddr4_mem[0].dq[3]
set_location_assignment PIN_J9   -to ddr4_mem[0].dq[4]
set_location_assignment PIN_D19  -to ddr4_mem[0].dq[5]
set_location_assignment PIN_H7   -to ddr4_mem[0].dq[6]
set_location_assignment PIN_J17  -to ddr4_mem[0].dq[7]
set_location_assignment PIN_J29  -to ddr4_mem[0].dq[8]

# CH0 DQS1
set_location_assignment PIN_J31  -to ddr4_mem[0].dbi_n[1]
set_location_assignment PIN_D32  -to ddr4_mem[0].dqs_n[1]
set_location_assignment PIN_B31  -to ddr4_mem[0].dqs[1]
set_location_assignment PIN_B33  -to ddr4_mem[0].dq[9]
set_location_assignment PIN_B29  -to ddr4_mem[0].dq[10]
set_location_assignment PIN_D30  -to ddr4_mem[0].dq[11]
set_location_assignment PIN_J33  -to ddr4_mem[0].dq[12]
set_location_assignment PIN_D34  -to ddr4_mem[0].dq[13]
set_location_assignment PIN_H30  -to ddr4_mem[0].dq[14]
set_location_assignment PIN_H34  -to ddr4_mem[0].dq[15]

# CH0 DQS2
set_location_assignment PIN_U37  -to ddr4_mem[0].dbi_n[2]
set_location_assignment PIN_L38  -to ddr4_mem[0].dqs_n[2]
set_location_assignment PIN_N37  -to ddr4_mem[0].dqs[2]
set_location_assignment PIN_L36  -to ddr4_mem[0].dq[16]
set_location_assignment PIN_W40  -to ddr4_mem[0].dq[17]
set_location_assignment PIN_U35  -to ddr4_mem[0].dq[18]
set_location_assignment PIN_U39  -to ddr4_mem[0].dq[19]
set_location_assignment PIN_N35  -to ddr4_mem[0].dq[20]
set_location_assignment PIN_W36  -to ddr4_mem[0].dq[21]
set_location_assignment PIN_N39  -to ddr4_mem[0].dq[22]
set_location_assignment PIN_L40  -to ddr4_mem[0].dq[23]

# CH0 DQS3
set_location_assignment PIN_AN41 -to ddr4_mem[0].dbi_n[3]
set_location_assignment PIN_AD42 -to ddr4_mem[0].dqs_n[3]
set_location_assignment PIN_AA41 -to ddr4_mem[0].dqs[3]
set_location_assignment PIN_AK40 -to ddr4_mem[0].dq[24]
set_location_assignment PIN_AD44 -to ddr4_mem[0].dq[25]
set_location_assignment PIN_AA39 -to ddr4_mem[0].dq[26]
set_location_assignment PIN_AA43 -to ddr4_mem[0].dq[27]
set_location_assignment PIN_AN39 -to ddr4_mem[0].dq[28]
set_location_assignment PIN_AK44 -to ddr4_mem[0].dq[29]
set_location_assignment PIN_AD40 -to ddr4_mem[0].dq[30]
set_location_assignment PIN_AN43 -to ddr4_mem[0].dq[31]

# CH0 DQS4
set_location_assignment PIN_AN35 -to ddr4_mem[0].dbi_n[4]
set_location_assignment PIN_AD36 -to ddr4_mem[0].dqs_n[4]
set_location_assignment PIN_AA35 -to ddr4_mem[0].dqs[4]
set_location_assignment PIN_AD34 -to ddr4_mem[0].dq[32]
set_location_assignment PIN_AD38 -to ddr4_mem[0].dq[33]
set_location_assignment PIN_AA33 -to ddr4_mem[0].dq[34]
set_location_assignment PIN_AA37 -to ddr4_mem[0].dq[35]
set_location_assignment PIN_AN33 -to ddr4_mem[0].dq[36]
set_location_assignment PIN_AK38 -to ddr4_mem[0].dq[37]
set_location_assignment PIN_AN37 -to ddr4_mem[0].dq[38]
set_location_assignment PIN_AK34 -to ddr4_mem[0].dq[39]

# CH0 DQS5
set_location_assignment PIN_U5   -to ddr4_mem[0].dbi_n[5]
set_location_assignment PIN_L7   -to ddr4_mem[0].dqs_n[5]
set_location_assignment PIN_N5   -to ddr4_mem[0].dqs[5]
set_location_assignment PIN_N2   -to ddr4_mem[0].dq[40]
set_location_assignment PIN_N9   -to ddr4_mem[0].dq[41]
set_location_assignment PIN_L4   -to ddr4_mem[0].dq[42]
set_location_assignment PIN_L11  -to ddr4_mem[0].dq[43]
set_location_assignment PIN_U2   -to ddr4_mem[0].dq[44]
set_location_assignment PIN_U9   -to ddr4_mem[0].dq[45]
set_location_assignment PIN_W4   -to ddr4_mem[0].dq[46]
set_location_assignment PIN_W11  -to ddr4_mem[0].dq[47]

# CH0 DQS6
set_location_assignment PIN_J25  -to ddr4_mem[0].dbi_n[6]
set_location_assignment PIN_D26  -to ddr4_mem[0].dqs_n[6]
set_location_assignment PIN_B25  -to ddr4_mem[0].dqs[6]
set_location_assignment PIN_J21  -to ddr4_mem[0].dq[48]
set_location_assignment PIN_J27  -to ddr4_mem[0].dq[49]
set_location_assignment PIN_B27  -to ddr4_mem[0].dq[50]
set_location_assignment PIN_B21  -to ddr4_mem[0].dq[51]
set_location_assignment PIN_D28  -to ddr4_mem[0].dq[52]
set_location_assignment PIN_D23  -to ddr4_mem[0].dq[53]
set_location_assignment PIN_H28  -to ddr4_mem[0].dq[54]
set_location_assignment PIN_H23  -to ddr4_mem[0].dq[55]

# CH0 DQS7
set_location_assignment PIN_BC41 -to ddr4_mem[0].dbi_n[7]
set_location_assignment PIN_AT42 -to ddr4_mem[0].dqs_n[7]
set_location_assignment PIN_AV41 -to ddr4_mem[0].dqs[7]
set_location_assignment PIN_BF44 -to ddr4_mem[0].dq[56]
set_location_assignment PIN_AV43 -to ddr4_mem[0].dq[57]
set_location_assignment PIN_BC39 -to ddr4_mem[0].dq[58]
set_location_assignment PIN_AT40 -to ddr4_mem[0].dq[59]
set_location_assignment PIN_BF40 -to ddr4_mem[0].dq[60]
set_location_assignment PIN_BC43 -to ddr4_mem[0].dq[61]
set_location_assignment PIN_AV39 -to ddr4_mem[0].dq[62]
set_location_assignment PIN_AT44 -to ddr4_mem[0].dq[63]

# # CH0 DQS8
# set_location_assignment PIN_BC29 -to ddr4_mem[0].dbi_n[8]
# set_location_assignment PIN_AT30 -to ddr4_mem[0].dqs_n[8]
# set_location_assignment PIN_AV29 -to ddr4_mem[0].dqs[8]
# set_location_assignment PIN_AT28 -to ddr4_mem[0].dq[64]
# set_location_assignment PIN_AV27 -to ddr4_mem[0].dq[66]
# set_location_assignment PIN_AT32 -to ddr4_mem[0].dq[65]
# set_location_assignment PIN_BC31 -to ddr4_mem[0].dq[67]
# set_location_assignment PIN_BF32 -to ddr4_mem[0].dq[68]
# set_location_assignment PIN_AV31 -to ddr4_mem[0].dq[69]
# set_location_assignment PIN_BC27 -to ddr4_mem[0].dq[70]
# set_location_assignment PIN_BF28 -to ddr4_mem[0].dq[71]

#-----------------------------------------------------------------------------
# DDR4 Component CH1 3A/3B
#-----------------------------------------------------------------------------
set_location_assignment PIN_AK64 -to "ddr4_mem[1].ref_clk(n)"
set_location_assignment PIN_AG63 -to ddr4_mem[1].ref_clk
set_location_assignment PIN_B59  -to ddr4_mem[1].bg[1]
set_location_assignment PIN_AT70 -to ddr4_mem[1].bg[0]
set_location_assignment PIN_AV68 -to ddr4_mem[1].ba[1]
set_location_assignment PIN_AK70 -to ddr4_mem[1].ba[0]
set_location_assignment PIN_AG68 -to ddr4_mem[1].alert_n
set_location_assignment PIN_AV63 -to ddr4_mem[1].oct_rzqin
set_location_assignment PIN_AT66 -to ddr4_mem[1].a[16]
set_location_assignment PIN_AV65 -to ddr4_mem[1].a[15]
set_location_assignment PIN_AK66 -to ddr4_mem[1].a[14]
set_location_assignment PIN_AG65 -to ddr4_mem[1].a[13]
set_location_assignment PIN_AT64 -to ddr4_mem[1].a[12]
set_location_assignment PIN_W64  -to ddr4_mem[1].a[11]
set_location_assignment PIN_U63  -to ddr4_mem[1].a[10]
set_location_assignment PIN_L64  -to ddr4_mem[1].a[9]
set_location_assignment PIN_N63  -to ddr4_mem[1].a[8]
set_location_assignment PIN_W62  -to ddr4_mem[1].a[7]
set_location_assignment PIN_U61  -to ddr4_mem[1].a[6]
set_location_assignment PIN_L62  -to ddr4_mem[1].a[5]
set_location_assignment PIN_N61  -to ddr4_mem[1].a[4]
set_location_assignment PIN_W60  -to ddr4_mem[1].a[3]
set_location_assignment PIN_U59  -to ddr4_mem[1].a[2]
set_location_assignment PIN_L60  -to ddr4_mem[1].a[1]
set_location_assignment PIN_N59  -to ddr4_mem[1].a[0]
set_location_assignment PIN_H64  -to ddr4_mem[1].par[0]
set_location_assignment PIN_D64  -to ddr4_mem[1].ck_n[0]
set_location_assignment PIN_B63  -to ddr4_mem[1].ck[0]
set_location_assignment PIN_J61  -to ddr4_mem[1].cke[0]
set_location_assignment PIN_B61  -to ddr4_mem[1].odt[0]
set_location_assignment PIN_H60  -to ddr4_mem[1].act_n[0]
set_location_assignment PIN_J59  -to ddr4_mem[1].cs_n[0]
set_location_assignment PIN_D60  -to ddr4_mem[1].reset_n[0]

# CH1 DQS0
set_location_assignment PIN_U55  -to ddr4_mem[1].dbi_n[0]
set_location_assignment PIN_L56  -to ddr4_mem[1].dqs_n[0]
set_location_assignment PIN_N55  -to ddr4_mem[1].dqs[0]
set_location_assignment PIN_N57  -to ddr4_mem[1].dq[0]
set_location_assignment PIN_L54  -to ddr4_mem[1].dq[1]
set_location_assignment PIN_W54  -to ddr4_mem[1].dq[2]
set_location_assignment PIN_N53  -to ddr4_mem[1].dq[3]
set_location_assignment PIN_L58  -to ddr4_mem[1].dq[4]
set_location_assignment PIN_U53  -to ddr4_mem[1].dq[5]
set_location_assignment PIN_W58  -to ddr4_mem[1].dq[6]
set_location_assignment PIN_U57  -to ddr4_mem[1].dq[7]

# CH1 DQS1
set_location_assignment PIN_AN59 -to ddr4_mem[1].dbi_n[1]
set_location_assignment PIN_AD60 -to ddr4_mem[1].dqs_n[1]
set_location_assignment PIN_AA59 -to ddr4_mem[1].dqs[1]
set_location_assignment PIN_AN61 -to ddr4_mem[1].dq[8]
set_location_assignment PIN_AN57 -to ddr4_mem[1].dq[9]
set_location_assignment PIN_AD62 -to ddr4_mem[1].dq[10]
set_location_assignment PIN_AD58 -to ddr4_mem[1].dq[11]
set_location_assignment PIN_AK62 -to ddr4_mem[1].dq[12]
set_location_assignment PIN_AA57 -to ddr4_mem[1].dq[13]
set_location_assignment PIN_AK58 -to ddr4_mem[1].dq[14]
set_location_assignment PIN_AA61 -to ddr4_mem[1].dq[15]

# CH1 DQS2
set_location_assignment PIN_BC47 -to ddr4_mem[1].dbi_n[2]
set_location_assignment PIN_AT48 -to ddr4_mem[1].dqs_n[2]
set_location_assignment PIN_AV47 -to ddr4_mem[1].dqs[2]
set_location_assignment PIN_AV49 -to ddr4_mem[1].dq[16]
set_location_assignment PIN_AT46 -to ddr4_mem[1].dq[17]
set_location_assignment PIN_AT50 -to ddr4_mem[1].dq[18]
set_location_assignment PIN_BF46 -to ddr4_mem[1].dq[19]
set_location_assignment PIN_BC49 -to ddr4_mem[1].dq[20]
set_location_assignment PIN_BF50 -to ddr4_mem[1].dq[22]
set_location_assignment PIN_AV45 -to ddr4_mem[1].dq[21]
set_location_assignment PIN_BC45 -to ddr4_mem[1].dq[23]

# CH1 DQS3
set_location_assignment PIN_BC53 -to ddr4_mem[1].dbi_n[3]
set_location_assignment PIN_AT54 -to ddr4_mem[1].dqs_n[3]
set_location_assignment PIN_AV53 -to ddr4_mem[1].dqs[3]
set_location_assignment PIN_AT56 -to ddr4_mem[1].dq[25]
set_location_assignment PIN_AV55 -to ddr4_mem[1].dq[24]
set_location_assignment PIN_BF52 -to ddr4_mem[1].dq[26]
set_location_assignment PIN_AT52 -to ddr4_mem[1].dq[27]
set_location_assignment PIN_BC55 -to ddr4_mem[1].dq[28]
set_location_assignment PIN_AV51 -to ddr4_mem[1].dq[29]
set_location_assignment PIN_BF56 -to ddr4_mem[1].dq[30]
set_location_assignment PIN_BC51 -to ddr4_mem[1].dq[31]

# CH1 DQS4
set_location_assignment PIN_CA59 -to ddr4_mem[1].dbi_n[4]
set_location_assignment PIN_BM60 -to ddr4_mem[1].dqs_n[4]
set_location_assignment PIN_BJ59 -to ddr4_mem[1].dqs[4]
set_location_assignment PIN_BJ57 -to ddr4_mem[1].dq[32]
set_location_assignment PIN_BM62 -to ddr4_mem[1].dq[33]
set_location_assignment PIN_BV58 -to ddr4_mem[1].dq[34]
set_location_assignment PIN_BJ61 -to ddr4_mem[1].dq[35]
set_location_assignment PIN_CA57 -to ddr4_mem[1].dq[36]
set_location_assignment PIN_BV62 -to ddr4_mem[1].dq[37]
set_location_assignment PIN_CA61 -to ddr4_mem[1].dq[38]
set_location_assignment PIN_BM58 -to ddr4_mem[1].dq[39]

# CH1 DQS5
set_location_assignment PIN_BJ65 -to ddr4_mem[1].dbi_n[5]
set_location_assignment PIN_AY66 -to ddr4_mem[1].dqs_n[5]
set_location_assignment PIN_BC65 -to ddr4_mem[1].dqs[5]
set_location_assignment PIN_BM64 -to ddr4_mem[1].dq[46]
set_location_assignment PIN_BJ63 -to ddr4_mem[1].dq[44]
set_location_assignment PIN_AY64 -to ddr4_mem[1].dq[45]
set_location_assignment PIN_BC63 -to ddr4_mem[1].dq[47]
set_location_assignment PIN_BM70 -to ddr4_mem[1].dq[42]
set_location_assignment PIN_BJ68 -to ddr4_mem[1].dq[40]
set_location_assignment PIN_AY70 -to ddr4_mem[1].dq[43]
set_location_assignment PIN_BC68 -to ddr4_mem[1].dq[41]

# CH1 DQS6
set_location_assignment PIN_AN53 -to ddr4_mem[1].dbi_n[6]
set_location_assignment PIN_AD54 -to ddr4_mem[1].dqs_n[6]
set_location_assignment PIN_AA53 -to ddr4_mem[1].dqs[6]
set_location_assignment PIN_AD56 -to ddr4_mem[1].dq[48]
set_location_assignment PIN_AN51 -to ddr4_mem[1].dq[49]
set_location_assignment PIN_AK56 -to ddr4_mem[1].dq[50]
set_location_assignment PIN_AN55 -to ddr4_mem[1].dq[51]
set_location_assignment PIN_AA55 -to ddr4_mem[1].dq[52]
set_location_assignment PIN_AK52 -to ddr4_mem[1].dq[53]
set_location_assignment PIN_AD52 -to ddr4_mem[1].dq[54]
set_location_assignment PIN_AA51 -to ddr4_mem[1].dq[55]

# CH1 DQS7
set_location_assignment PIN_AN47 -to ddr4_mem[1].dbi_n[7]
set_location_assignment PIN_AD48 -to ddr4_mem[1].dqs_n[7]
set_location_assignment PIN_AA47 -to ddr4_mem[1].dqs[7]
set_location_assignment PIN_AK50 -to ddr4_mem[1].dq[56]
set_location_assignment PIN_AD46 -to ddr4_mem[1].dq[57]
set_location_assignment PIN_AD50 -to ddr4_mem[1].dq[58]
set_location_assignment PIN_AK46 -to ddr4_mem[1].dq[59]
set_location_assignment PIN_AN49 -to ddr4_mem[1].dq[60]
set_location_assignment PIN_AA45 -to ddr4_mem[1].dq[61]
set_location_assignment PIN_AA49 -to ddr4_mem[1].dq[62]
set_location_assignment PIN_AN45 -to ddr4_mem[1].dq[63]

# # CH1 DQS8
# set_location_assignment PIN_BC59 -to ddr4_mem[1].dbi_n[8]
# set_location_assignment PIN_AT60 -to ddr4_mem[1].dqs_n[8]
# set_location_assignment PIN_AV59 -to ddr4_mem[1].dqs[8]
# set_location_assignment PIN_BC61 -to ddr4_mem[1].dq[64]
# set_location_assignment PIN_AT62 -to ddr4_mem[1].dq[65]
# set_location_assignment PIN_AV61 -to ddr4_mem[1].dq[66]
# set_location_assignment PIN_BC57 -to ddr4_mem[1].dq[67]
# set_location_assignment PIN_BF62 -to ddr4_mem[1].dq[68]
# set_location_assignment PIN_AT58 -to ddr4_mem[1].dq[69]
# set_location_assignment PIN_BF58 -to ddr4_mem[1].dq[70]
# set_location_assignment PIN_AV57 -to ddr4_mem[1].dq[71]

#-----------------------------------------------------------------------------
# DDR4 DIMM CH2 2C/2F
#-----------------------------------------------------------------------------
set_location_assignment PIN_KR37 -to "ddr4_mem[2].ref_clk(n)"
set_location_assignment PIN_KU36 -to ddr4_mem[2].ref_clk
set_location_assignment PIN_KJ35 -to ddr4_mem[2].a[16]
set_location_assignment PIN_KF34 -to ddr4_mem[2].a[15]
set_location_assignment PIN_KR35 -to ddr4_mem[2].a[14]
set_location_assignment PIN_KU34 -to ddr4_mem[2].a[13]
set_location_assignment PIN_KF36 -to ddr4_mem[2].a[12]
set_location_assignment PIN_LB38 -to ddr4_mem[2].a[11]
set_location_assignment PIN_KW39 -to ddr4_mem[2].a[10]
set_location_assignment PIN_LL39 -to ddr4_mem[2].a[9]
set_location_assignment PIN_LH38 -to ddr4_mem[2].a[8]
set_location_assignment PIN_KW41 -to ddr4_mem[2].a[7]
set_location_assignment PIN_LB40 -to ddr4_mem[2].a[6]
set_location_assignment PIN_LL41 -to ddr4_mem[2].a[5]
set_location_assignment PIN_LH40 -to ddr4_mem[2].a[4]
set_location_assignment PIN_LB42 -to ddr4_mem[2].a[3]
set_location_assignment PIN_KW43 -to ddr4_mem[2].a[2]
set_location_assignment PIN_LL43 -to ddr4_mem[2].a[1]
set_location_assignment PIN_LH42 -to ddr4_mem[2].a[0]
set_location_assignment PIN_KR43 -to ddr4_mem[2].bg[1]
set_location_assignment PIN_KF32 -to ddr4_mem[2].bg[0]
set_location_assignment PIN_KJ33 -to ddr4_mem[2].ba[1]
set_location_assignment PIN_KR33 -to ddr4_mem[2].ba[0]
set_location_assignment PIN_KF42 -to ddr4_mem[2].cs_n[0]
set_location_assignment PIN_KU38 -to ddr4_mem[2].ck_n[0]
set_location_assignment PIN_KR39 -to ddr4_mem[2].ck[0]
set_location_assignment PIN_KF40 -to ddr4_mem[2].cke[0]
set_location_assignment PIN_KU40 -to ddr4_mem[2].odt[0]
set_location_assignment PIN_KJ39 -to ddr4_mem[2].par
set_location_assignment PIN_KJ43 -to ddr4_mem[2].act_n
set_location_assignment PIN_KC33 -to ddr4_mem[2].alert_n
set_location_assignment PIN_KJ37 -to ddr4_mem[2].oct_rzqin
set_location_assignment PIN_KU42 -to ddr4_mem[2].reset_n

# CH2 DQS0
set_location_assignment PIN_LR17 -to ddr4_mem[2].dbi_n[0]
set_location_assignment PIN_MA19 -to ddr4_mem[2].dqs_n[0]
set_location_assignment PIN_LW17 -to ddr4_mem[2].dqs[0]
set_location_assignment PIN_LR21 -to ddr4_mem[2].dq[0]
set_location_assignment PIN_LN23 -to ddr4_mem[2].dq[1]
set_location_assignment PIN_LW21 -to ddr4_mem[2].dq[2]
set_location_assignment PIN_MA23 -to ddr4_mem[2].dq[3]
set_location_assignment PIN_LW13 -to ddr4_mem[2].dq[4]
set_location_assignment PIN_MA15 -to ddr4_mem[2].dq[5]
set_location_assignment PIN_LR13 -to ddr4_mem[2].dq[6]
set_location_assignment PIN_LN15 -to ddr4_mem[2].dq[7]

# CH2 DQS1
set_location_assignment PIN_MD23 -to ddr4_mem[2].dbi_n[1]
set_location_assignment PIN_MK25 -to ddr4_mem[2].dqs_n[1]
set_location_assignment PIN_MH23 -to ddr4_mem[2].dqs[1]
set_location_assignment PIN_MH26 -to ddr4_mem[2].dq[8]
set_location_assignment PIN_MK27 -to ddr4_mem[2].dq[9]
set_location_assignment PIN_MD26 -to ddr4_mem[2].dq[10]
set_location_assignment PIN_MC27 -to ddr4_mem[2].dq[11]
set_location_assignment PIN_MH19 -to ddr4_mem[2].dq[12]
set_location_assignment PIN_MD19 -to ddr4_mem[2].dq[13]
set_location_assignment PIN_MK21 -to ddr4_mem[2].dq[14]
set_location_assignment PIN_MC21 -to ddr4_mem[2].dq[15]

# CH2 DQS2
set_location_assignment PIN_LR5  -to ddr4_mem[2].dbi_n[2]
set_location_assignment PIN_MA7  -to ddr4_mem[2].dqs_n[2]
set_location_assignment PIN_LW5  -to ddr4_mem[2].dqs[2]
set_location_assignment PIN_LR9  -to ddr4_mem[2].dq[16]
set_location_assignment PIN_LW9  -to ddr4_mem[2].dq[17]
set_location_assignment PIN_LN11 -to ddr4_mem[2].dq[18]
set_location_assignment PIN_MA11 -to ddr4_mem[2].dq[19]
set_location_assignment PIN_LU4  -to ddr4_mem[2].dq[20]
set_location_assignment PIN_LW2  -to ddr4_mem[2].dq[21]
set_location_assignment PIN_MA4  -to ddr4_mem[2].dq[22]
set_location_assignment PIN_MC5  -to ddr4_mem[2].dq[23]

# CH2 DQS3
set_location_assignment PIN_MD11 -to ddr4_mem[2].dbi_n[3]
set_location_assignment PIN_MK13 -to ddr4_mem[2].dqs_n[3]
set_location_assignment PIN_MH11 -to ddr4_mem[2].dqs[3]
set_location_assignment PIN_MH15 -to ddr4_mem[2].dq[24]
set_location_assignment PIN_MD15 -to ddr4_mem[2].dq[25]
set_location_assignment PIN_MC17 -to ddr4_mem[2].dq[26]
set_location_assignment PIN_MK17 -to ddr4_mem[2].dq[27]
set_location_assignment PIN_MD7  -to ddr4_mem[2].dq[29]
set_location_assignment PIN_MF5  -to ddr4_mem[2].dq[28]
set_location_assignment PIN_MC9  -to ddr4_mem[2].dq[30]
set_location_assignment PIN_MH7  -to ddr4_mem[2].dq[31]

# CH2 DQS4
set_location_assignment PIN_LR27 -to ddr4_mem[2].dbi_n[4]
set_location_assignment PIN_MA28 -to ddr4_mem[2].dqs_n[4]
set_location_assignment PIN_LW27 -to ddr4_mem[2].dqs[4]
set_location_assignment PIN_LW29 -to ddr4_mem[2].dq[32]
set_location_assignment PIN_LR29 -to ddr4_mem[2].dq[33]
set_location_assignment PIN_LN30 -to ddr4_mem[2].dq[34]
set_location_assignment PIN_MA30 -to ddr4_mem[2].dq[35]
set_location_assignment PIN_LN26 -to ddr4_mem[2].dq[36]
set_location_assignment PIN_MA26 -to ddr4_mem[2].dq[37]
set_location_assignment PIN_LW25 -to ddr4_mem[2].dq[38]
set_location_assignment PIN_LR25 -to ddr4_mem[2].dq[39]

# CH2 DQS5
set_location_assignment PIN_LR33 -to ddr4_mem[2].dbi_n[5]
set_location_assignment PIN_MA34 -to ddr4_mem[2].dqs_n[5]
set_location_assignment PIN_LW33 -to ddr4_mem[2].dqs[5]
set_location_assignment PIN_LW35 -to ddr4_mem[2].dq[40]
set_location_assignment PIN_LR35 -to ddr4_mem[2].dq[41]
set_location_assignment PIN_MA36 -to ddr4_mem[2].dq[42]
set_location_assignment PIN_LN36 -to ddr4_mem[2].dq[43]
set_location_assignment PIN_LR31 -to ddr4_mem[2].dq[44]
set_location_assignment PIN_LW31 -to ddr4_mem[2].dq[45]
set_location_assignment PIN_LN32 -to ddr4_mem[2].dq[46]
set_location_assignment PIN_MA32 -to ddr4_mem[2].dq[47]

# CH2 DQS6
set_location_assignment PIN_LB28 -to ddr4_mem[2].dbi_n[6]
set_location_assignment PIN_LL29 -to ddr4_mem[2].dqs_n[6]
set_location_assignment PIN_LH28 -to ddr4_mem[2].dqs[6]
set_location_assignment PIN_LH30 -to ddr4_mem[2].dq[48]
set_location_assignment PIN_KW31 -to ddr4_mem[2].dq[49]
set_location_assignment PIN_LB30 -to ddr4_mem[2].dq[50]
set_location_assignment PIN_LL31 -to ddr4_mem[2].dq[51]
set_location_assignment PIN_KW27 -to ddr4_mem[2].dq[52]
set_location_assignment PIN_LH26 -to ddr4_mem[2].dq[53]
set_location_assignment PIN_LB26 -to ddr4_mem[2].dq[54]
set_location_assignment PIN_LL27 -to ddr4_mem[2].dq[55]

# CH2 DQS7
set_location_assignment PIN_LB34 -to ddr4_mem[2].dbi_n[7]
set_location_assignment PIN_LL35 -to ddr4_mem[2].dqs_n[7]
set_location_assignment PIN_LH34 -to ddr4_mem[2].dqs[7]
set_location_assignment PIN_LH36 -to ddr4_mem[2].dq[56]
set_location_assignment PIN_LB36 -to ddr4_mem[2].dq[57]
set_location_assignment PIN_LL37 -to ddr4_mem[2].dq[58]
set_location_assignment PIN_KW37 -to ddr4_mem[2].dq[59]
set_location_assignment PIN_LB32 -to ddr4_mem[2].dq[60]
set_location_assignment PIN_LL33 -to ddr4_mem[2].dq[61]
set_location_assignment PIN_LH32 -to ddr4_mem[2].dq[62]
set_location_assignment PIN_KW33 -to ddr4_mem[2].dq[63]

# # CH2 DQS8
# set_location_assignment PIN_MD30 -to ddr4_mem[2].dbi_n[8]
# set_location_assignment PIN_MK31 -to ddr4_mem[2].dqs_n[8]
# set_location_assignment PIN_MH30 -to ddr4_mem[2].dqs[8]
# set_location_assignment PIN_MD32 -to ddr4_mem[2].dq[64]
# set_location_assignment PIN_MH32 -to ddr4_mem[2].dq[65]
# set_location_assignment PIN_MK33 -to ddr4_mem[2].dq[66]
# set_location_assignment PIN_MC33 -to ddr4_mem[2].dq[67]
# set_location_assignment PIN_MD28 -to ddr4_mem[2].dq[68]
# set_location_assignment PIN_MH28 -to ddr4_mem[2].dq[69]
# set_location_assignment PIN_MK29 -to ddr4_mem[2].dq[70]
# set_location_assignment PIN_MC29 -to ddr4_mem[2].dq[71]

#-----------------------------------------------------------------------------
# DDR4 DIMM CH3 2B,2E
#-----------------------------------------------------------------------------
set_location_assignment PIN_LW43 -to "ddr4_mem[3].ref_clk(n)"
set_location_assignment PIN_MA44 -to ddr4_mem[3].ref_clk
set_location_assignment PIN_MA54 -to ddr4_mem[3].alert_n
set_location_assignment PIN_LH44 -to ddr4_mem[3].bg[1]
set_location_assignment PIN_LR47 -to ddr4_mem[3].bg[0]
set_location_assignment PIN_LN48 -to ddr4_mem[3].ba[1]
set_location_assignment PIN_LW47 -to ddr4_mem[3].ba[0]
set_location_assignment PIN_LN44 -to ddr4_mem[3].oct_rzqin
set_location_assignment PIN_MA48 -to ddr4_mem[3].a[17]
set_location_assignment PIN_LN46 -to ddr4_mem[3].a[16]
set_location_assignment PIN_LR45 -to ddr4_mem[3].a[15]
set_location_assignment PIN_MA46 -to ddr4_mem[3].a[14]
set_location_assignment PIN_LW45 -to ddr4_mem[3].a[13]
set_location_assignment PIN_LR43 -to ddr4_mem[3].a[12]
set_location_assignment PIN_KJ49 -to ddr4_mem[3].a[11]
set_location_assignment PIN_KF48 -to ddr4_mem[3].a[10]
set_location_assignment PIN_KU48 -to ddr4_mem[3].a[9]
set_location_assignment PIN_KR49 -to ddr4_mem[3].a[8]
set_location_assignment PIN_KJ47 -to ddr4_mem[3].a[7]
set_location_assignment PIN_KF46 -to ddr4_mem[3].a[6]
set_location_assignment PIN_KR47 -to ddr4_mem[3].a[5]
set_location_assignment PIN_KU46 -to ddr4_mem[3].a[4]
set_location_assignment PIN_KF44 -to ddr4_mem[3].a[3]
set_location_assignment PIN_KJ45 -to ddr4_mem[3].a[2]
set_location_assignment PIN_KU44 -to ddr4_mem[3].a[1]
set_location_assignment PIN_KR45 -to ddr4_mem[3].a[0]
set_location_assignment PIN_LB48 -to ddr4_mem[3].par
set_location_assignment PIN_LL49 -to ddr4_mem[3].ck_n[0]
set_location_assignment PIN_LH48 -to ddr4_mem[3].ck[0]
set_location_assignment PIN_LB46 -to ddr4_mem[3].cke[0]
set_location_assignment PIN_LH46 -to ddr4_mem[3].odt[0]
set_location_assignment PIN_KW45 -to ddr4_mem[3].act_n
set_location_assignment PIN_LB44 -to ddr4_mem[3].cs_n[0]
set_location_assignment PIN_LL45 -to ddr4_mem[3].reset_n

# CH3 DQS0
set_location_assignment PIN_LR57 -to ddr4_mem[3].dbi_n[0]
set_location_assignment PIN_MA58 -to ddr4_mem[3].dqs_n[0]
set_location_assignment PIN_LW57 -to ddr4_mem[3].dqs[0]
set_location_assignment PIN_LN56 -to ddr4_mem[3].dq[0]
set_location_assignment PIN_MA56 -to ddr4_mem[3].dq[1]
set_location_assignment PIN_LW55 -to ddr4_mem[3].dq[2]
set_location_assignment PIN_LR55 -to ddr4_mem[3].dq[3]
set_location_assignment PIN_LN60 -to ddr4_mem[3].dq[4]
set_location_assignment PIN_MA60 -to ddr4_mem[3].dq[5]
set_location_assignment PIN_LW59 -to ddr4_mem[3].dq[6]
set_location_assignment PIN_LR59 -to ddr4_mem[3].dq[7]

# CH3 DQS1
set_location_assignment PIN_LR39 -to ddr4_mem[3].dbi_n[1]
set_location_assignment PIN_MA40 -to ddr4_mem[3].dqs_n[1]
set_location_assignment PIN_LW39 -to ddr4_mem[3].dqs[1]
set_location_assignment PIN_LW37 -to ddr4_mem[3].dq[8]
set_location_assignment PIN_LR37 -to ddr4_mem[3].dq[9]
set_location_assignment PIN_MA38 -to ddr4_mem[3].dq[10]
set_location_assignment PIN_LN38 -to ddr4_mem[3].dq[11]
set_location_assignment PIN_MA42 -to ddr4_mem[3].dq[12]
set_location_assignment PIN_LW41 -to ddr4_mem[3].dq[13]
set_location_assignment PIN_LN42 -to ddr4_mem[3].dq[14]
set_location_assignment PIN_LR41 -to ddr4_mem[3].dq[15]

# CH3 DQS2
set_location_assignment PIN_KF52 -to ddr4_mem[3].dbi_n[2]
set_location_assignment PIN_KR53 -to ddr4_mem[3].dqs_n[2]
set_location_assignment PIN_KU52 -to ddr4_mem[3].dqs[2]
set_location_assignment PIN_KF50 -to ddr4_mem[3].dq[16]
set_location_assignment PIN_KJ51 -to ddr4_mem[3].dq[17]
set_location_assignment PIN_KU50 -to ddr4_mem[3].dq[18]
set_location_assignment PIN_KR51 -to ddr4_mem[3].dq[19]
set_location_assignment PIN_KJ55 -to ddr4_mem[3].dq[20]
set_location_assignment PIN_KR55 -to ddr4_mem[3].dq[21]
set_location_assignment PIN_KU54 -to ddr4_mem[3].dq[22]
set_location_assignment PIN_KF54 -to ddr4_mem[3].dq[23]

# CH3 DQS3
set_location_assignment PIN_MD36 -to ddr4_mem[3].dbi_n[3]
set_location_assignment PIN_MK37 -to ddr4_mem[3].dqs_n[3]
set_location_assignment PIN_MH36 -to ddr4_mem[3].dqs[3]
set_location_assignment PIN_MK35 -to ddr4_mem[3].dq[24]
set_location_assignment PIN_MC35 -to ddr4_mem[3].dq[25]
set_location_assignment PIN_MD34 -to ddr4_mem[3].dq[26]
set_location_assignment PIN_MH34 -to ddr4_mem[3].dq[27]
set_location_assignment PIN_MK39 -to ddr4_mem[3].dq[28]
set_location_assignment PIN_MC39 -to ddr4_mem[3].dq[29]
set_location_assignment PIN_MD38 -to ddr4_mem[3].dq[30]
set_location_assignment PIN_MH38 -to ddr4_mem[3].dq[31]

# CH3 DQS4
set_location_assignment PIN_MD48 -to ddr4_mem[3].dbi_n[4]
set_location_assignment PIN_MK49 -to ddr4_mem[3].dqs_n[4]
set_location_assignment PIN_MH48 -to ddr4_mem[3].dqs[4]
set_location_assignment PIN_MC47 -to ddr4_mem[3].dq[32]
set_location_assignment PIN_MK47 -to ddr4_mem[3].dq[33]
set_location_assignment PIN_MH46 -to ddr4_mem[3].dq[34]
set_location_assignment PIN_MD46 -to ddr4_mem[3].dq[35]
set_location_assignment PIN_MC51 -to ddr4_mem[3].dq[36]
set_location_assignment PIN_MK51 -to ddr4_mem[3].dq[37]
set_location_assignment PIN_MD50 -to ddr4_mem[3].dq[38]
set_location_assignment PIN_MH50 -to ddr4_mem[3].dq[39]

# CH3 DQS5
set_location_assignment PIN_MD60 -to ddr4_mem[3].dbi_n[5]
set_location_assignment PIN_MK61 -to ddr4_mem[3].dqs_n[5]
set_location_assignment PIN_MH60 -to ddr4_mem[3].dqs[5]
set_location_assignment PIN_MK59 -to ddr4_mem[3].dq[40]
set_location_assignment PIN_MH58 -to ddr4_mem[3].dq[41]
set_location_assignment PIN_MC59 -to ddr4_mem[3].dq[42]
set_location_assignment PIN_MD58 -to ddr4_mem[3].dq[43]
set_location_assignment PIN_MK63 -to ddr4_mem[3].dq[44]
set_location_assignment PIN_MC63 -to ddr4_mem[3].dq[45]
set_location_assignment PIN_MH62 -to ddr4_mem[3].dq[46]
set_location_assignment PIN_MD62 -to ddr4_mem[3].dq[47]

# CH3 DQS6
set_location_assignment PIN_MD54 -to ddr4_mem[3].dbi_n[6]
set_location_assignment PIN_MK55 -to ddr4_mem[3].dqs_n[6]
set_location_assignment PIN_MH54 -to ddr4_mem[3].dqs[6]
set_location_assignment PIN_MC53 -to ddr4_mem[3].dq[48]
set_location_assignment PIN_MK53 -to ddr4_mem[3].dq[49]
set_location_assignment PIN_MH52 -to ddr4_mem[3].dq[50]
set_location_assignment PIN_MD52 -to ddr4_mem[3].dq[51]
set_location_assignment PIN_MH56 -to ddr4_mem[3].dq[52]
set_location_assignment PIN_MC57 -to ddr4_mem[3].dq[53]
set_location_assignment PIN_MK57 -to ddr4_mem[3].dq[54]
set_location_assignment PIN_MD56 -to ddr4_mem[3].dq[55]

# CH3 DQS7
set_location_assignment PIN_LB52 -to ddr4_mem[3].dbi_n[7]
set_location_assignment PIN_LL53 -to ddr4_mem[3].dqs_n[7]
set_location_assignment PIN_LH52 -to ddr4_mem[3].dqs[7]
set_location_assignment PIN_LL51 -to ddr4_mem[3].dq[56]
set_location_assignment PIN_KW51 -to ddr4_mem[3].dq[57]
set_location_assignment PIN_LB50 -to ddr4_mem[3].dq[58]
set_location_assignment PIN_LH50 -to ddr4_mem[3].dq[59]
set_location_assignment PIN_LL55 -to ddr4_mem[3].dq[60]
set_location_assignment PIN_KW55 -to ddr4_mem[3].dq[61]
set_location_assignment PIN_LH54 -to ddr4_mem[3].dq[62]
set_location_assignment PIN_LB54 -to ddr4_mem[3].dq[63]

# # CH3 DQS8
# set_location_assignment PIN_MD42 -to ddr4_mem[3].dbi_n[8]
# set_location_assignment PIN_MK43 -to ddr4_mem[3].dqs_n[8]
# set_location_assignment PIN_MH42 -to ddr4_mem[3].dqs[8]
# set_location_assignment PIN_MH40 -to ddr4_mem[3].dq[64]
# set_location_assignment PIN_MD40 -to ddr4_mem[3].dq[65]
# set_location_assignment PIN_MC41 -to ddr4_mem[3].dq[66]
# set_location_assignment PIN_MK41 -to ddr4_mem[3].dq[67]
# set_location_assignment PIN_MH44 -to ddr4_mem[3].dq[68]
# set_location_assignment PIN_MK45 -to ddr4_mem[3].dq[69]
# set_location_assignment PIN_MD44 -to ddr4_mem[3].dq[70]
# set_location_assignment PIN_MC45 -to ddr4_mem[3].dq[71]
