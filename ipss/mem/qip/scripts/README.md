# Memory system scripts directory

This directory contains the OFS Agilex 7 memory subsystem system scripts. For now, only M-Series devices have scripted support.

## Subsystem
* HBM
   - Running `make` will build a 4 channel HBM system with 8 AXI channels and full crossbar support. The configuration can be modified by setting `ch` and `xbar` variables.
    ```bash
        make ch=<num> xbar=<bool>
    ```
