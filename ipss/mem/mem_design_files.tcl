# Copyright (C) 2023 Intel Corporation.
# SPDX-License-Identifier: MIT

set vlog_macros [get_all_global_assignments -name VERILOG_MACRO]
set include_mss 0
set include_hbm 0

foreach_in_collection assignment [get_all_global_assignments -name DEVICE] {
    set opn [lindex $assignment 2]
}
set part_info    [get_part_info -device $opn]
set base_device  [get_base_device_of $part_info]

foreach_in_collection m $vlog_macros {
    if { [string equal "INCLUDE_DDR4" [lindex $m 2]] } {
        set_global_assignment -name VERILOG_MACRO "INCLUDE_LOCAL_MEM"
        if {[string match *FM* $base_device]} {
            set include_mss 1
        }
    }
    if { [string equal "INCLUDE_HBM" [lindex $m 2]] } {
        # Piggy back on the DDR APP channels for now
        set_global_assignment -name VERILOG_MACRO "INCLUDE_LOCAL_MEM"
        set include_hbm 1
    }
}

if {$include_mss == 1} {
    # MemSS IP
    set_global_assignment -name IP_FILE $::env(BUILD_ROOT_REL)/ipss/mem/qip/mem_ss/mem_ss.ip
    # Used only in simulation. Loading it here adds ed_sim_mem to the simulation environment.
    # It is not instantiated on HW.
    set_global_assignment -name IP_FILE $::env(BUILD_ROOT_REL)/ipss/mem/qip/ed_sim/ed_sim_mem.ip

    # Add the Memory Subsystem to the dictionary of IP files that will be parsed by OFS
    # into the project's ofs_ip_cfg_db directory. Parameters from the configured
    # IP will be turned into Verilog macros.
    dict set ::ofs_ip_cfg_db::ip_db $::env(BUILD_ROOT_REL)/ipss/mem/qip/mem_ss/mem_ss.ip [list local_mem mem_ss_get_cfg.tcl]
}

if {$include_hbm == 1} {
    # HBM Qsys
    set_global_assignment -name QSYS_FILE $::env(BUILD_ROOT_REL)/ipss/mem/qip/hbm_ss/hbm_ss.qsys

    # Qsys IP components
    set_global_assignment -name IP_FILE $::env(BUILD_ROOT_REL)/ipss/mem/qip/hbm_ss/ip/hbm_ss/hbm_ss_hbm_0.ip
    set_global_assignment -name IP_FILE $::env(BUILD_ROOT_REL)/ipss/mem/qip/hbm_ss/ip/hbm_ss/hbm_ss_noc_0.ip
    set_global_assignment -name IP_FILE $::env(BUILD_ROOT_REL)/ipss/mem/qip/hbm_ss/ip/hbm_ss/hbm_ss_noc_0_ctrl.ip

    set_global_assignment -name IP_FILE $::env(BUILD_ROOT_REL)/ipss/mem/qip/hbm_ss/ip/hbm_ss/hbm_ss_hbm_1.ip
    set_global_assignment -name IP_FILE $::env(BUILD_ROOT_REL)/ipss/mem/qip/hbm_ss/ip/hbm_ss/hbm_ss_noc_1.ip
    set_global_assignment -name IP_FILE $::env(BUILD_ROOT_REL)/ipss/mem/qip/hbm_ss/ip/hbm_ss/hbm_ss_noc_1_ctrl.ip

    # Add the HBM Subsystem to the dictionary of system files that will be parsed by OFS
    # into the project's ofs_ip_cfg_db directory. Parameters from the configured
    # IP will be turned into Verilog macros.
    dict set ::ofs_ip_cfg_db::ip_db $::env(BUILD_ROOT_REL)/ipss/mem/qip/hbm_ss/hbm_ss.qsys [list local_mem mem_sys_get_cfg.tcl]
}
