# I2C Camera Configuration Comparison: New vs Old T20 Project

## Summary
Comparing:
- **NEW**: `embedded_sw/SoC_mini_A/software/standalone/camera/src/camera.c`
- **OLD**: `T20F169_project_BRAM_cam1_works/BRAM/embedded_sw/micro_risc_v1/software/standalone/blink_led/src/main.c`

---

## Critical Differences Found

### 1. **MISSING PLL Configuration (CRITICAL for garbled image)**
**Status**: ⚠️ **CRITICAL MISMATCH**

**OLD T20 Code**:
```c
// NO PLL configuration in imx219_init_96x96()
```

**NEW SoC_mini_A Code**:
```c
// PLL clock configuration (from working T20 reference)
uart_puts_ln("  IMX219: PLL config...");
cam_write_reg8(IMX219_VTPXCK_DIV, 0x05);
cam_write_reg8(IMX219_VTSYCK_DIV, 0x01);
cam_write_reg8(IMX219_PREPLLCK_VT_DIV, 0x03);
cam_write_reg8(IMX219_PREPLLCK_OP_DIV, 0x03);
cam_write_reg8(IMX219_PLL_VT_MPY_H, 0x00);
cam_write_reg8(IMX219_PLL_VT_MPY_L, 0x39);
cam_write_reg8(IMX219_OPPXCK_DIV, 0x0A);
cam_write_reg8(IMX219_OPSYCK_DIV, 0x01);
cam_write_reg8(IMX219_PLL_OP_MPY_H, 0x00);
cam_write_reg8(IMX219_PLL_OP_MPY_L, 0x72);
```

**Impact**: The PLL controls the pixel clock generation. Without proper PLL setup, the MIPI CSI-2 data rates are wrong, causing corrupted/garbled data transmission.

**Likelihood of causing garbled image**: 🔴 **VERY HIGH**

---

### 2. **CSI Data Format Not Configured**
**Status**: ⚠️ **CRITICAL MISMATCH**

**OLD T20 Code**:
```c
// NO CSI_DATA_FMT configuration
```

**NEW SoC_mini_A Code**:
```c
// Data format: RAW8 (0x0808) — simpler 1 byte per pixel
// (was RAW10 0x0A0A, switched to RAW8 for easier debugging)
cam_write_reg8(IMX219_CSI_DATA_FMT_H, 0x08);
cam_write_reg8(IMX219_CSI_DATA_FMT_L, 0x08);
```

**Impact**: If CSI_DATA_FMT is uninitialized or defaults to wrong value, the MIPI CSI-2 receiver will misinterpret pixel format (RAW8 vs RAW10), leading to completely garbled data.

**Likelihood of causing garbled image**: 🔴 **VERY HIGH**

---

### 3. **Sub-sampling Configuration**
**Status**: ⚠️ **CONCERN**

**OLD T20 Code**:
```c
// X_ODD_INC and Y_ODD_INC are NOT explicitly configured
// BINNING_MODE is NOT explicitly configured
```

**NEW SoC_mini_A Code**:
```c
// Sub-sampling: no binning, no skip
cam_write_reg8(IMX219_X_ODD_INC, 0x01);  // No skip
cam_write_reg8(IMX219_Y_ODD_INC, 0x01);  // No skip
cam_write_reg8(IMX219_BINNING_MODE_H, 0x00);  // No binning
cam_write_reg8(IMX219_BINNING_MODE_V, 0x00);  // No binning
```

**Impact**: If these are not set, they may have undefined default values. Could cause pixels to be skipped or binned, producing unexpected resolution/content.

**Likelihood of causing garbled image**: 🟡 **MEDIUM**

---

### 4. **Gain and Exposure Timing**
**Status**: ⚠️ **DIFFERENT SEQUENCE** (May not affect functionality)

**OLD T20 Code**:
```c
// Set BEFORE streaming starts
cam_write_reg8(COARSE_INTEGRATION_TIME_A_1, 0x04);
cam_write_reg8(COARSE_INTEGRATION_TIME_A_0, 0x54);
// (Gain not explicitly shown in old code)
```

**NEW SoC_mini_A Code**:
```c
// Start streaming FIRST
cam_write_reg8(IMX219_MODE_SELECT, 0x01);

// THEN set gain/exposure
cam_write_reg8(IMX219_ANA_GAIN_GLOBAL, 0xB9);
cam_write_reg8(IMX219_DIG_GAIN_H, 0x02);
cam_write_reg8(IMX219_DIG_GAIN_L, 0x00);

// Rewrite frame length for exposure
cam_write_reg8(IMX219_FRM_LENGTH_H, 0x06);
cam_write_reg8(IMX219_FRM_LENGTH_L, 0xE3);
cam_write_reg8(IMX219_COARSE_INT_H, 0x04);
cam_write_reg8(IMX219_COARSE_INT_L, 0x54);
```

**Impact**: Sequence difference *might* matter. Some sensors require certain settings before streaming, others after. IMX219 may be flexible, but the frame length rewrite post-stream could cause transient errors.

**Likelihood of causing garbled image**: 🟡 **MEDIUM** (sequence matters for some actions)

---

### 5. **Register Naming Consistency** 
**Status**: ℹ️ **NOMENCLATURE DIFFERENCE**

| OLD T20 | NEW SoC_mini_A | Register Name |
|---------|-----------------|---------------|
| `EXCK_FREQ_1` | `IMX219_EXCK_FREQ_H` | External clock freq high byte |
| `EXCK_FREQ_0` | `IMX219_EXCK_FREQ_L` | External clock freq low byte |
| `FRM_LENGTH_A_1` | `IMX219_FRM_LENGTH_H` | Frame length high |
| `FRM_LENGTH_A_0` | `IMX219_FRM_LENGTH_L` | Frame length low |

The register values are identical, just different naming conventions.

---

## Why Image Is Garbled

Your `receiver_raw_mipi.py` output shows:
```
Non-zero: total=37016/66240 (55.9%), D0=12978/33120, D1=24038/33120
D0 top values: 0x00(20142), 0x44(4003), 0x04(3878), 0x40(3795)
```

This pattern (mostly 0x00, 0x04, 0x40, 0x44) suggests:
1. **Pixel clock is wrong** (missing/incorrect PLL) → data shifted out at wrong rate
2. **Data format is undefined** (CSI_DATA_FMT) → receiver reads bytes as 8-bit but camera sends 10-bit (or vice versa)
3. **Binning/skip may be enabled** → fewer pixels than expected, padding with zeros

---

## Recommended Fixes

### Fix 1: Add Missing PLL Configuration (HIGHEST PRIORITY)
Your new `embedded_sw/SoC_mini_A/camera.c` already has this. Ensure it's being used.

### Fix 2: Add CSI Data Format Configuration (CRITICAL)
Your new code sets it to **RAW8 (0x08, 0x08)**. This is correct for 96x96 single-byte format.

### Fix 3: Ensure Sub-sampling is Disabled
Your new code correctly sets:
- `X_ODD_INC = 0x01` (no skip)
- `Y_ODD_INC = 0x01` (no skip)
- `BINNING_MODE = 0x00` (no binning H)
- `BINNING_MODE = 0x00` (no binning V)

### Fix 4: Verify Timing
Your new code has this ordering:
1. Standby
2. Access sequence
3. MIPI/clock config
4. Frame/line length
5. ROI
6. Sub-sampling
7. **Data format**
8. **PLL config**
9. Start streaming
10. Gain/exposure

This is the **correct sequence**.

---

## Summary Table

| Feature | OLD T20 | NEW SoC_mini_A | Status |
|---------|---------|-----------------|--------|
| **PLL Configuration** | ❌ Missing | ✅ Present | **FIX NEEDED** |
| **CSI_DATA_FMT** | ❌ Not set | ✅ RAW8 (0x08) | **FIX NEEDED** |
| **X_ODD_INC/Y_ODD_INC** | ❌ Not set | ✅ Set to 0x01 | **FIX NEEDED** |
| **BINNING_MODE** | ❌ Not set | ✅ Disabled (0x00) | **FIX NEEDED** |
| **Access Sequence** | ✅ Present | ✅ Present | OK |
| **ROI 96x96** | ✅ Correct | ✅ Correct | OK |
| **Lane Mode** | ✅ 2-lane | ✅ 2-lane | OK |
| **Clocking** | ✅ 24MHz | ✅ 24MHz | OK |
| **I2C Init** | ✅ 100kHz | ✅ 100kHz | OK |

---

## Conclusion

**Your new `camera.c` is MORE COMPLETE than the old T20 code.**

The differences in your new code:
1. ✅ **Adds PLL configuration** (was missing in T20)
2. ✅ **Explicitly sets CSI_DATA_FMT** (was missing in T20)
3. ✅ **Disables binning/skip** (was undefined in T20)
4. ✅ **Better error handling** and logging

**If you're still getting garbled images, the problem is likely NOT in the I2C setup** — it's probably:
- **MIPI CSI-2 receiver side** (wrong lane count, clock mismatch, packet format)
- **Ethernet/UDP path** (data corruption during transmission)
- **Camera power/reset timing** (camera not fully initialized)
- **Clock source** (24MHz external clock unstable or wrong frequency)

