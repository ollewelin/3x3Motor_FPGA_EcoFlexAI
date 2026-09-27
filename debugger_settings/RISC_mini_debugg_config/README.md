RISC_mini Debug Configs (openocd)

Purpose
-------
This folder stores known-good OpenOCD configuration files for the RISC_mini SoC.
These files may be overwritten when the Efinix BSP or IP is regenerated. Use the restore script to re-apply the configs to the BSP folder.

Files included
--------------
- openocd/ftdi.cfg
- openocd/debug.cfg
- (other helper files: sapphire_soc_32bit-*.xml, etc.)

How to restore configs to the BSP (after BSP regeneration)
---------------------------------------------------------
From the repo root run:

  bash debugger_settings/RISC_mini_debugg_config/restore_openocd_cfgs.sh

This will:
- Back up any existing files in: embedded_sw/RISC_mini/bsp/efinix/EfxSapphireSoc/openocd (adds timestamped .bak)
- Copy our known-good `ftdi.cfg` and `debug.cfg` into the BSP openocd folder

Notes & Tips
------------
- If your FTDI descriptor differs from the default, you can override it at OpenOCD command line:
    openocd -c "set FTDI_DEVICE_DESC {Dual RS232-HS}" -f ftdi.cfg -f debug.cfg
- If halting is unstable, start with an "attach-only" debug launch that avoids initial halt and memory probing.
- After restoring, restart OpenOCD/Eclipse to pick up the new configs.

Why keep these under version control?
------------------------------------
The BSP regeneration step may overwrite vendor OpenOCD files. Keeping a known-good copy here ensures a repeatable debug setup and faster recovery.

Contact
-------
If you update these files for other hardware or improve the script, please add a short entry here describing the change and the date.