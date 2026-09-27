# CRITICAL HARDWARE & DEBUG PORT RULE

## UART Debug Port: ALWAYS `/dev/ttyACM0`
- The UART debug output from the FPGA is connected to the Arduino on `/dev/ttyACM0` (115200 baud, 8N1).
- **NEVER touch, open, or read `/dev/ttyUSB0` or `/dev/ttyUSB1`**.
- `/dev/ttyUSB0` and `/dev/ttyUSB1` belong strictly to the FTDI FT2232 chip used for JTAG programming. Opening them in software disrupts JTAG communication!

## UART Pins Driven on FPGA
`top_level.sv` drives `uart_mini_txd` to:
1. `fpga_uart_tx` (P10)
2. `uart_tx_xb3_pin5` (N10)
3. `XB7`
All at 115200 baud.
