#!/usr/bin/env python3
"""
Add new GPIO entries to peri.xml from the netlist-parsed mappings.
This script properly inserts GPIOs BEFORE the global_unused_config tag.
"""

import re
from pathlib import Path

# GPIO entries from netlist parsing (non-DDRAM, filtered to exclude existing)
# Format: (name, gpio_def, original_net_name)
NEW_GPIO_ENTRIES = [
    # GPIOB pins (Bottom I/O)
    ("ADC_2_DIN", "GPIOB_TXN00"),
    ("ADC_3_DIN", "GPIOB_TXN02"),
    ("M1_SSCS", "GPIOB_TXN10"),
    ("M3_SSCS", "GPIOB_TXN11"),
    ("MX_SCLK", "GPIOB_TXN12"),
    ("MX_MISO_SDO", "GPIOB_TXN19"),
    ("M2_SSCS", "GPIOB_TXP10"),
    ("MX_ENABLE", "GPIOB_TXP11"),
    ("MX_MOSI_SDI", "GPIOB_TXP12"),
    ("MX_NFAULT", "GPIOB_TXP19"),
    
    # GPIOL pins (Left I/O)
    ("DC_M1_IN1", "GPIOL_17_EXTFB0"),
    ("ADC_3_DOUT", "GPIOL_62_CTRL0"),
    ("ADC_1_DIN", "GPIOL_63_CTRL1"),
    ("ENC1A", "GPIOL_75_CTRL5"),
    
    # GPIOR pins (Right I/O)
    ("ENC1B", "GPIOR_173_CTRL12"),
    ("ENC2A", "GPIOR_183_CTRL10"),
    
    # GPIOT pins (Top I/O) - additional ones not in current peri.xml
    ("M2_INHC", "GPIOT_RXN01"),
    ("M2_INHB", "GPIOT_RXN02"),
    ("M2_INHA", "GPIOT_RXN03"),
    ("M1_INHC", "GPIOT_RXN04"),
    ("M1_INHB", "GPIOT_RXN05"),
    ("XB25", "GPIOT_RXN06"),
    ("DC_M2_IN1", "GPIOT_RXN07"),
    ("DC_M3_IN1", "GPIOT_RXN08_EXTFB0"),
    ("DC_M4_IN1", "GPIOT_RXN09_CLKN0"),
    ("M1_INHA", "GPIOT_RXN11"),
    ("ADC_SHDN", "GPIOT_RXN12"),
    ("ADC_2_DOUT", "GPIOT_RXN13"),
    ("XB24", "GPIOT_RXN14"),
    ("M3_INLB", "GPIOT_RXN15"),
    ("M3_INHB", "GPIOT_RXN16"),
    ("M3_INHA", "GPIOT_RXN17"),
    ("M2_INLC", "GPIOT_RXP01"),
    ("M2_INLB", "GPIOT_RXP02"),
    ("M2_INLA", "GPIOT_RXP03"),
    ("M1_INLC", "GPIOT_RXP04"),
    ("M1_INLB", "GPIOT_RXP05"),
    ("DC_M1_IN2", "GPIOT_RXP06"),
    ("DC_M2_IN2", "GPIOT_RXP07"),
    ("DC_M3_IN2", "GPIOT_RXP08_EXTFB0"),
    ("DC_M4_IN2", "GPIOT_RXP09_CLKP0"),
    ("M1_INLA", "GPIOT_RXP11"),
    ("ADC_CLK", "GPIOT_RXP12"),
    ("ADC_1_DOUT", "GPIOT_RXP13"),
    ("XB23", "GPIOT_RXP14"),
    ("M3_INLA", "GPIOT_RXP17"),
]

# Existing GPIO names/defs in the current peri.xml (to skip)
EXISTING_GPIO_DEFS = {
    "GPIOL_66",  # T120_GCLK
    "GPIOT_RXP28_EXTFB2",  # GYRO_CS_1
    "GPIOT_RXP27",  # M3_HALL_B
    "GPIOT_RXP24",  # M2_HALL_C
    "GPIOT_RXN23",  # M2_HALL_B
    "GPIOT_RXN22",  # M1_HALL_C
    "GPIOT_RXN21",  # M1_HALL_A
    "GPIOT_RXN20",  # ENC3A
    "GPIOT_RXP19_CLKP1",  # RXP19_CLK_P
    "GPIOT_RXN29_CLKN2",  # CAM3_EN
    "GPIOT_RXN28_EXTFB2",  # GYRO_CS_2
    "GPIOT_RXN27",  # M3_HALL_C
    "GPIOT_RXN24",  # M3_HALL_A
    "GPIOT_RXP23",  # M2_HALL_A
    "GPIOT_RXP22",  # M1_HALL_B
    "GPIOT_RXP21",  # ENC3B
    "GPIOT_RXP20",  # ENC2B
    "GPIOT_RXN19_CLKN1",  # RXP19_CLK_N
    "GPIOT_RXP29_CLKP2",  # GYRO_CS_3
}


def generate_gpio_xml(name, gpio_def, is_lvds=False):
    """Generate a properly formatted GPIO XML entry."""
    lvds_str = "true" if is_lvds else "false"
    return f'''        <efxpt:gpio name="{name}" gpio_def="{gpio_def}" mode="input" bus_name="" is_lvds_gpio="{lvds_str}" io_standard="3.3 V LVTTL / LVCMOS">
            <efxpt:input_config name="{name}" name_ddio_lo="" conn_type="normal" is_register="false" clock_name="" is_clock_inverted="false" pull_option="none" is_schmitt_trigger="false" ddio_type="none" />
        </efxpt:gpio>'''


def main():
    peri_file = Path(__file__).parent / "T120F324_A.peri.xml"
    
    # Read current file
    with open(peri_file, 'r') as f:
        content = f.read()
    
    # Filter to only new GPIOs (not in existing set)
    new_gpios = [(name, gpio_def) for name, gpio_def in NEW_GPIO_ENTRIES 
                 if gpio_def not in EXISTING_GPIO_DEFS]
    
    print(f"Total new GPIOs to add: {len(new_gpios)}")
    
    # Get batch size from command line or default to 10
    import sys
    batch_num = int(sys.argv[1]) if len(sys.argv) > 1 else 0
    batch_size = 10
    
    start_idx = batch_num * batch_size
    end_idx = start_idx + batch_size
    batch = new_gpios[start_idx:end_idx]
    
    if not batch:
        print(f"No more GPIOs to add (batch {batch_num} is empty)")
        print(f"Total new GPIOs: {len(new_gpios)}")
        return
    
    print(f"Adding batch {batch_num}: GPIOs {start_idx+1} to {min(end_idx, len(new_gpios))} of {len(new_gpios)}")
    for name, gpio_def in batch:
        print(f"  - {name} ({gpio_def})")
    
    # Generate XML for the batch
    gpio_xml_entries = []
    for name, gpio_def in batch:
        # Determine if this is an LVDS GPIO (RXP/RXN pairs on GPIOT)
        is_lvds = "GPIOT_RX" in gpio_def
        gpio_xml_entries.append(generate_gpio_xml(name, gpio_def, is_lvds))
    
    new_gpios_xml = '\n'.join(gpio_xml_entries)
    
    # Find the global_unused_config tag and insert before it
    pattern = r'(\s*)(<efxpt:global_unused_config)'
    match = re.search(pattern, content)
    
    if not match:
        print("ERROR: Could not find global_unused_config tag")
        return
    
    # Insert the new GPIOs before global_unused_config
    insertion_point = match.start()
    whitespace = match.group(1)
    
    new_content = content[:insertion_point] + '\n' + new_gpios_xml + whitespace + content[insertion_point:]
    
    # Write the updated file
    with open(peri_file, 'w') as f:
        f.write(new_content)
    
    print(f"\nUpdated {peri_file}")
    print("Please test with Efinix Interface Designer before adding more GPIOs.")


if __name__ == '__main__':
    main()
