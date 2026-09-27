# Sätt BSP_ROOT till den djupa mappen där include/soc.mk faktiskt bor
export BSP_ROOT="/home/olle/efinity_p2/TI60F225_ECO_FLEX_AI_1/embedded_sw/SoC_mini_A/bsp/efinix/EfxSapphireSoc"

# Din PATH (se till att denna stämmer med din efinity-installation)
export EFINITY_HOME="/home/olle/efinix2/efinity-2025.2.288.2.10-linux-x64/efinity/2025.2"
export PATH="$EFINITY_HOME/riscv32-unknown-elf/bin:$EFINITY_HOME/bin:$PATH"

# Skapa ett alias så du slipper skriva -e hela tiden
alias make='make -e BSP_ROOT=$BSP_ROOT'