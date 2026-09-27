PROJ_NAME=test_b
STANDALONE = ..


# Build camera setup and main program (PHY init included in main.c)
SRCS = 	src/main.c \
		src/t120_camera.c \
		$(wildcard src/*.cpp) \
		$(wildcard src/*.S) \
		${STANDALONE}/common/start.S


include ${STANDALONE}/common/bsp.mk
include ${STANDALONE}/common/riscv64-unknown-elf.mk
include ${STANDALONE}/common/standalone.mk

LDSCRIPT =  ${BSP_PATH}/linker/default.ld

