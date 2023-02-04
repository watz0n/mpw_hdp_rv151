# MPW-Precheck on HDP-RV151 Project

* Goal: Generate HDP-RV151 Project GDS from Physical Implementation Flow by OpenLane, then pass MPW-Precheck validations.
* Project Information: [VSD-HDP Walkthrough](https://github.com/watz0n/vsd-hdp)
* Author: Watson Huang (wats0n.edx@gmail.com)

------
### Usage Guide

1. Set-up Environment
    ```
    $ source env_setup.sh
    ```
2. Perform RTL-to-GDS flow
    ```
    $ make user_project_wrapper
    ```
3. MPW-Precheck
    ```
    $ make run-precheck
    ```
4. Behavior/Gate-Level RTL Simulation
    ```
    // Behavior
    $ make verify-rv151_bspi-rtl
    // Gate-Level
    $ make verify-rv151_bspi-gl
    ```

------
### Results

1. RTL-to-GDS Flow
    
    * [1] MPW OpenLane Flow Logs<br />
    ![rtl-to-gds-log](docs/images/prj_mpw_openlane-flow_info-log_230204.png)
    * [2] OpenLane Elasped Time, total >12hrs, critical: Magic SPICE Extraction(8hrs)<br />
    ![rtl-to-gds-time](docs/images/prj_mpw_openlane-flow_elasped-time_230204.png)
    * [3] Post-Routing Layout in OpenRoad-GUI<br />
    ![rtl-to-gds-orgui](docs/images/prj_mpw_openroad_gui_230202.png)
    * [4] Sign-Off Layout in Klayout<br />
    ![rtl-to-gds-klgds](docs/images/prj_mpw_klayout_gds_230202.png)
    * [5] Pass MPW-Precheck, include Magic/Klayout DRC-Checks<br />
    ![rtl-to-gds-prechk](docs/images/prj_mpw_precheck_pass_230202.png)

2. RTL Simulation

    * [1] RTL Behavior Simulation<br />
    ![sim-rtl](docs/images/prj_mpw_sim_rtl_230204.png)
    * [2] RTL Gate-Level Simulation<br />
    ![sim-gl](docs/images/prj_mpw_sim_gl_230204.png)

------
### Work-Around

1. Magic DRC translate to other exchangeable form issue
    * Disable `RUN_MAGIC_DRC` in `openlane\user_project_wrapper\config.json`
    ```
        "RUN_MAGIC_DRC": false,
    ```
    * Check the DRC-Rules in MPW-Precheck flow

------
### Reference
    
* [1]. Sky130 SRAM Macro DRC work-around discussion
    * [efabless/mpw_precheck: Precheck crash with SRAM DRC](https://github.com/efabless/mpw_precheck/issues/180)

------