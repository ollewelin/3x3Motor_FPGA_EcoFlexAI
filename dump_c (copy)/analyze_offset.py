#!/usr/bin/env python3
"""
Visualize the pixel offset in the first line to find where real data starts.
"""
import sys

# First line hex data (from first_line_analysis.txt)
first_line_hex = bytes.fromhex(
    "4B 98 4D 93 4A 91 46 98 47 8A 4D 91 4B 9C 47 9B "
    "47 93 4A 9B 4C 99 4E 9B 45 8B 45 91 43 9A 4B 92 "
    "42 91 42 94 46 95 4C 9B 47 96 4D 99 48 98 4A 91 "
    "4F 9B 4F 9F 4B 97 48 97 4D A2 43 95 47 9A 48 92 "
    "41 98 48 95 4F A0 49 9E 4C 9A 49 95 47 9B 51 97 "
    "47 93 4A 9B 4C 99 4E 9B 45 8B 45 91 43 9A 4B 92 "
    "42 91 42 94 46 95 4C 9B 47 96 4D 99 48 98 4A 91 "
    "4F 9B 4F 9F 4B 97 48 97 4D A2 43 95 47 9A 48 92 "
    "41 98 48 95 4F A0 49 9E 4C 9A 49 95 47 9B 51 97 "
    "40 97 4B 91 49 9B 4A 98 48 90 47 91 4F 9A 48 96 "
    "46 92 41 85 3D 64 23 3D 1C 2B 1A 29 11 29 16 2C "
    "11 28 14 27 13 27 16 2B 13 2D 15 2B 13 26 14 29"
)

print("=" * 90)
print("FIRST LINE OFFSET ANALYSIS - Find where real data starts")
print("=" * 90)
print()

# Statistics by region
regions = [
    ("Pixels 0-31 (Garbage?)", 0, 32),
    ("Pixels 32-63", 32, 64),
    ("Pixels 64-95", 64, 96),
    ("Pixels 96-127", 96, 128),
    ("Pixels 128-159", 128, 160),
    ("Pixels 160-175 (Real data?)", 160, 176),
    ("Pixels 176-191 (Dark edge?)", 176, 192),
]

print("[REGION STATISTICS]")
print()
for label, start, end in regions:
    region = first_line_hex[start:end]
    vals = list(region)
    mean = sum(vals) / len(vals)
    std = (sum((v - mean)**2 for v in vals) / len(vals)) ** 0.5
    vrange = max(vals) - min(vals)
    
    print(f"{label:40s}  mean={mean:6.1f}  std={std:5.1f}  range={vrange:3d}  ({min(vals):3d}-{max(vals):3d})")

print()
print("[OFFSET DETECTION]")
print()

# Find the sharpest transition
transitions = []
for i in range(1, len(first_line_hex)):
    delta = abs(int(first_line_hex[i]) - int(first_line_hex[i-1]))
    transitions.append((i, delta))

# Top transitions
top_10 = sorted(transitions, key=lambda x: x[1], reverse=True)[:10]
print("Top 10 largest value changes:")
for idx, (pos, delta) in enumerate(top_10, 1):
    print(f"  {idx}. Pixel {pos-1:3d}→{pos:3d}: Δ {delta:3d}  ({first_line_hex[pos-1]:3d} → {first_line_hex[pos]:3d})")

print()
print("[LIKELY OFFSET CANDIDATES]")
print()

# Check for repeating patterns
print("Checking for pattern repetition...")
pattern_found = None
for pat_len in [16, 32, 48, 64]:
    pattern = first_line_hex[:pat_len]
    matches = 0
    for start in range(pat_len, 160, pat_len):
        if first_line_hex[start:start+pat_len] == pattern:
            matches += 1
    if matches >= 2:
        print(f"  Pattern of {pat_len} bytes repeats {matches} times at offset {pat_len}")
        pattern_found = pat_len

print()
if pattern_found or len(top_10) > 0:
    largest_drop = top_10[0][0]
    print(f"⚠️  LIKELY OFFSET: Around pixel {largest_drop}")
    print(f"    Pixels 0-{largest_drop-1}: Garbage/test pattern")
    print(f"    Pixels {largest_drop}-191: Real video data")
    print()
    print(f"    OFFSET AMOUNT: {largest_drop} pixels = {largest_drop // 8} beats")
else:
    print("No obvious offset detected - data may be valid or corrupted")

print()
print("=" * 90)
