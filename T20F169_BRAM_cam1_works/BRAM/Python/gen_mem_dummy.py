DEPTH = 8192            # bytes
with open("filled_0xFF.mem", "w") as f_ff:
    for _ in range(DEPTH):
        f_ff.write("FF\n")

with open("filled_0x00.mem", "w") as f_00:
    for _ in range(DEPTH):
        f_00.write("00\n")