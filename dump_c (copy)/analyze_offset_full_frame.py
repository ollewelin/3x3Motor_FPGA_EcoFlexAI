#!/usr/bin/env python3
"""
Analyze full 192x192 frame for persistent line offset patterns.
Detects where real video data starts on each line and checks for repeating patterns.
Also analyzes Bayer color distribution (RGGB/GRBG).
"""
import sys
import numpy as np
from collections import defaultdict

FRAME_WIDTH = 192
FRAME_HEIGHT = 192
TOTAL_BYTES = FRAME_WIDTH * FRAME_HEIGHT

def find_line_offset(line_data):
    """
    Find where real data likely starts on a line.
    Returns: (offset_pixel, confidence, mean_before, mean_after, transition_magnitude)
    """
    # Look for sharp transitions (large changes in consecutive values)
    line = np.frombuffer(line_data, dtype=np.uint8)
    diffs = np.abs(np.diff(line.astype(np.int16)))
    
    # Find transitions > 50 (significant changes)
    significant_trans = np.where(diffs > 50)[0]
    
    if len(significant_trans) == 0:
        return None  # No clear offset
    
    # Most likely offset is the first significant transition
    offset = significant_trans[0]
    
    before_mean = np.mean(line[:offset+1]) if offset > 0 else 0
    after_mean = np.mean(line[offset+1:])
    transition_mag = diffs[offset]
    
    return {
        'offset': offset,
        'before_mean': before_mean,
        'after_mean': after_mean,
        'transition_mag': transition_mag,
    }

def analyze_bayer_pattern(frame_data):
    """
    Analyze Bayer color pattern in frame.
    Assumes RAW8 Bayer: either RGGB or GRBG pattern
    """
    frame = np.frombuffer(frame_data, dtype=np.uint8).reshape(FRAME_HEIGHT, FRAME_WIDTH)
    
    # Extract Bayer channels (assuming GRBG pattern which is common)
    # GRBG: even rows start with G, odd rows start with R
    # Position: [row, col]
    
    red = []
    green_r = []  # green on red rows
    green_b = []  # green on blue rows
    blue = []
    
    for r in range(FRAME_HEIGHT):
        for c in range(FRAME_WIDTH):
            pixel = frame[r, c]
            if r % 2 == 0:  # Even row
                if c % 2 == 0:  # G
                    green_r.append(pixel)
                else:  # R
                    red.append(pixel)
            else:  # Odd row
                if c % 2 == 0:  # B
                    blue.append(pixel)
                else:  # G
                    green_b.append(pixel)
    
    stats = {
        'red': {
            'mean': np.mean(red) if red else 0,
            'min': np.min(red) if red else 0,
            'max': np.max(red) if red else 0,
            'std': np.std(red) if red else 0,
        },
        'green': {
            'mean': (np.mean(green_r) + np.mean(green_b)) / 2 if (green_r or green_b) else 0,
            'min': min(np.min(green_r) if green_r else 255, np.min(green_b) if green_b else 255),
            'max': max(np.max(green_r) if green_r else 0, np.max(green_b) if green_b else 0),
            'std': (np.std(green_r) + np.std(green_b)) / 2 if (green_r or green_b) else 0,
        },
        'blue': {
            'mean': np.mean(blue) if blue else 0,
            'min': np.min(blue) if blue else 0,
            'max': np.max(blue) if blue else 0,
            'std': np.std(blue) if blue else 0,
        }
    }
    return stats

def main():
    if len(sys.argv) < 2:
        print("Usage: python analyze_offset_full_frame.py <frame_192x192.bin>")
        sys.exit(1)
    
    with open(sys.argv[1], 'rb') as f:
        frame_data = f.read()
    
    if len(frame_data) != TOTAL_BYTES:
        print(f"ERROR: Expected {TOTAL_BYTES} bytes, got {len(frame_data)}")
        sys.exit(1)
    
    print("=" * 96)
    print("FULL FRAME OFFSET ANALYSIS - Line-by-Line Transition Detection")
    print("=" * 96)
    print()
    
    # Analyze each line
    offsets = []
    offset_counts = defaultdict(int)
    
    for line_idx in range(FRAME_HEIGHT):
        line_start = line_idx * FRAME_WIDTH
        line_end = line_start + FRAME_WIDTH
        line_data = frame_data[line_start:line_end]
        
        offset_info = find_line_offset(line_data)
        
        if offset_info:
            offsets.append(offset_info)
            offset_counts[offset_info['offset']] += 1
    
    if offsets:
        print("[LINE OFFSET SUMMARY]")
        print()
        
        offset_vals = [o['offset'] for o in offsets]
        print(f"Lines with detected offset: {len(offsets)} / {FRAME_HEIGHT}")
        print(f"Offset range: {min(offset_vals)} to {max(offset_vals)} pixels")
        print(f"Mean offset: {np.mean(offset_vals):.1f} pixels")
        print(f"Median offset: {np.median(offset_vals):.1f} pixels")
        print(f"Std dev: {np.std(offset_vals):.1f} pixels")
        print()
        
        print("[MOST COMMON OFFSET VALUES]")
        sorted_offsets = sorted(offset_counts.items(), key=lambda x: x[1], reverse=True)
        for offset_px, count in sorted_offsets[:10]:
            pct = 100.0 * count / len(offsets)
            print(f"  {offset_px:3d} pixels: {count:3d} lines ({pct:5.1f}%)")
        print()
        
        # Show first 20 lines detailed
        print("[FIRST 20 LINES - DETAILED OFFSET INFO]")
        print(f"{'Line':>4} {'Offset':>6} {'Before':>7} {'After':>7} {'ΔMag':>6} {'Status':>20}")
        print("-" * 70)
        for i in range(min(20, len(offsets))):
            o = offsets[i]
            status = "✓ Regular" if o['offset'] == offsets[0]['offset'] else "⚠️  CHANGE"
            print(f"{i:4d} {o['offset']:6d} {o['before_mean']:7.1f} {o['after_mean']:7.1f} "
                  f"{o['transition_mag']:6.1f} {status}")
        print()
        
        # Check for consistency
        first_offset = offsets[0]['offset']
        consistent = all(abs(o['offset'] - first_offset) <= 2 for o in offsets)
        
        if consistent:
            print(f"✓ CONSISTENT: All lines have offset ≈ {first_offset} pixels")
            print(f"  This suggests a systematic BRAM/DMA address offset issue")
            print(f"  Real data likely starts {first_offset} pixels into each line")
        else:
            print(f"⚠️  INCONSISTENT: Offset varies across lines!")
            print(f"  This might indicate line sync issues or dynamic corruption")
        print()
    
    # Analyze Bayer color distribution
    print("[BAYER COLOR ANALYSIS (Assuming GRBG pattern)]")
    print()
    bayer_stats = analyze_bayer_pattern(frame_data)
    
    for channel in ['red', 'green', 'blue']:
        stats = bayer_stats[channel]
        print(f"{channel.upper():6s}:  mean={stats['mean']:6.1f}  "
              f"min={stats['min']:3d}  max={stats['max']:3d}  std={stats['std']:6.1f}")
    
    print()
    
    # Detect color imbalance
    red_mean = bayer_stats['red']['mean']
    green_mean = bayer_stats['green']['mean']
    blue_mean = bayer_stats['blue']['mean']
    
    print("[COLOR IMBALANCE DETECTION]")
    print(f"Red vs Green:  {red_mean/green_mean*100:.1f}% (should be ~100%)")
    print(f"Blue vs Green: {blue_mean/green_mean*100:.1f}% (should be ~100%)")
    
    if red_mean < green_mean * 0.6:
        print("🔴 RED CHANNEL CRITICALLY LOW - possible sensor issue or Bayer interpretation error")
    if blue_mean < green_mean * 0.6:
        print("🔵 BLUE CHANNEL CRITICALLY LOW - possible sensor issue or Bayer interpretation error")
    
    print()
    print("=" * 96)
    
    # Generate offset map visualization
    if offsets:
        print("\n[OFFSET SUMMARY MAP - Visual representation]")
        print("Each row = 8 lines of frame, showing offset value\n")
        
        for block_start in range(0, FRAME_HEIGHT, 8):
            block_end = min(block_start + 8, FRAME_HEIGHT)
            block_offsets = [offsets[i]['offset'] if i < len(offsets) else -1 
                            for i in range(block_start, block_end)]
            
            print(f"Lines {block_start:3d}-{block_end-1:3d}: ", end="")
            for offset in block_offsets:
                if offset == -1:
                    print("  -  ", end=" ")
                else:
                    print(f"{offset:3d} ", end=" ")
            print()

if __name__ == "__main__":
    main()
