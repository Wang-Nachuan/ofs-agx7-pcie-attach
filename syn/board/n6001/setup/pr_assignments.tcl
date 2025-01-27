# Copyright (C) 2020 Intel Corporation.
# SPDX-License-Identifier: MIT

#
# This file contains PR specific Quartus assignments
#------------------------------------

if { [info exist env(OFS_BUILD_TAG_FLAT) ] } { 
    post_message "Compiling Flat design..." 
} else {


    if { [info exist env(OFS_BUILD_TAG_PR_FLOORPLAN) ] } {
        set fp_tcl_file_name  [exec basename $env(OFS_BUILD_TAG_PR_FLOORPLAN)]
        post_message "Compiling User Specified PR Base floorplan $fp_tcl_file_name"
    
        if { [file exists $::env(BUILD_ROOT_REL)/syn/user_settings/$fp_tcl_file_name] == 0} {
            post_message "Warning User PR floorplan not found = /syn/user_settings/$fp_tcl_file_name"
        }
        
        set_global_assignment -name SOURCE_TCL_SCRIPT_FILE $::env(BUILD_ROOT_REL)/syn/user_settings/$fp_tcl_file_name
         
    } else {
        post_message "Compiling PR Base revision..." 
        #-------------------------------
        # Specify PR Partition and turn PR ON for that partition
        #-------------------------------
        set_global_assignment -name REVISION_TYPE PR_BASE
        
        #####################################################
        # Main PR Partition -- green_region
        #####################################################
        set_instance_assignment -name PARTITION green_region -to afu_top|pg_afu.port_gasket|pr_slot|afu_main
        set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to afu_top|pg_afu.port_gasket|pr_slot|afu_main
        set_instance_assignment -name RESERVE_PLACE_REGION ON -to afu_top|pg_afu.port_gasket|pr_slot|afu_main
        set_instance_assignment -name PARTIAL_RECONFIGURATION_PARTITION ON -to afu_top|pg_afu.port_gasket|pr_slot|afu_main

    
        set_instance_assignment -name PLACE_REGION "X90 Y40 X295 Y165; X276 Y140 X344 Y212" -to afu_top|pg_afu.port_gasket|pr_slot|afu_main
        set_instance_assignment -name ROUTE_REGION "X0 Y0 X344 Y212" -to afu_top|pg_afu.port_gasket|pr_slot|afu_main
        
        set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to afu_top|tag_remap
        set_instance_assignment -name PLACE_REGION "X0 Y0 X90 Y212" -to afu_top|tag_remap
        
        set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to afu_top|pf_vf_mux_a
        set_instance_assignment -name PLACE_REGION "X0 Y0 X90 Y212" -to afu_top|pf_vf_mux_a
        
        set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to afu_top|pf_vf_mux_b
        set_instance_assignment -name PLACE_REGION "X0 Y0 X90 Y212" -to afu_top|pf_vf_mux_b
        
        set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to afu_top|mx2ho_tx_ab_mux
        set_instance_assignment -name PLACE_REGION "X0 Y0 X90 Y212" -to afu_top|mx2ho_tx_ab_mux
        
        set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to afu_top|afu_intf_inst
        set_instance_assignment -name PLACE_REGION "X0 Y0 X90 Y212" -to afu_top|afu_intf_inst
        
        set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to afu_top|fim_afu_instances|st2mm
        set_instance_assignment -name PLACE_REGION "X0 Y0 X90 Y212" -to afu_top|fim_afu_instances|st2mm
        
        set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to afu_top|fim_afu_instances|he_lb_top
        set_instance_assignment -name PLACE_REGION "X0 Y165 X275 Y212" -to afu_top|fim_afu_instances|he_lb_top
        
        set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to afu_top|fim_afu_instances|ce_top
        set_instance_assignment -name PLACE_REGION "X0 Y165 X275 Y212" -to afu_top|fim_afu_instances|ce_top
        
        ## memory interface bank #2
        set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to mem_ss_top|mem_ss_fm_inst|mem_ss_fm|intf_2
        set_instance_assignment -name PLACE_REGION "X0 Y165 X275 Y212" -to mem_ss_top|mem_ss_fm_inst|mem_ss_fm|intf_2
        
        set_instance_assignment -name CORE_ONLY_PLACE_REGION ON -to mem_ss_top|mem_ss_fm_inst|mem_ss_fm|msa_2
        set_instance_assignment -name PLACE_REGION "X0 Y165 X275 Y212" -to mem_ss_top|mem_ss_fm_inst|mem_ss_fm|msa_2
    }

}
