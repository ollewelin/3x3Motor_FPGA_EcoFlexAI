PROJ_NAME=mdio_test
STANDALONE = ..

# Default BSP for this workspace (override with `make BSP=...` if needed)
BSP ?= efinix/EfxSapphireSoc


SRCS = 	$(wildcard src/*.c) \
		$(wildcard src/*.cpp) \
		$(wildcard src/*.S) \
		${STANDALONE}/common/start.S


include ${STANDALONE}/common/bsp.mk
include ${STANDALONE}/common/riscv64-unknown-elf.mk
include ${STANDALONE}/common/standalone.mk

LDSCRIPT =  ${BSP_PATH}/linker/default.ld

