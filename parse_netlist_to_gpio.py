#!/usr/bin/env python3
"""
Parse the netlist file and generate GPIO XML entries for the Efinix peri.xml.
This script:
1. Parses the netlist to find all U100 (FPGA) pin connections
2. Maps BGA pins to Efinix gpio_def names using the pinout CSV
3. Sanitizes net names (replaces special chars with underscore)
4. Generates properly formatted GPIO XML entries
"""

import re
import csv
from pathlib import Path

# Configuration
NETLIST_FILE = "Netlist_top_level_2026-01-02.asc"
PINOUT_CSV = "outflow/T120F324_A.pinout.csv"
OUTPUT_FILE = "gpio_mappings.txt"

# Lists of pins/nets to skip
SKIP_NETS = {
    'GND', '3.3V', '1.2V', '1.8V', '2.5V', '5.0V', '0.95V', '36V',
    '+2.5VREF', 'VCC', 'VCCIO', 
}

# Skip pins that start with these prefixes (dedicated functions)
SKIP_PIN_PREFIXES = ['DDR_', 'MIPI', 'VCC', 'GND', 'VCCA', 'GNDA', 'REF_RES', 'CRESET_N', 'CDONE', 'TMS', 'TDO', 'TDI', 'TCK']

# Skip gpio_def names containing these (reserved/dedicated)
SKIP_GPIO_CONTAINS = ['PLLIN', 'MREFCLK']

def sanitize_name(name):
    """Replace special characters with underscore, ensure valid identifier."""
    # Remove $ and backslash prefixes like $1I301734\
    name = re.sub(r'\$\d+I\d+\\', '', name)
    name = re.sub(r'\$\d+N\d+', 'NET_', name)
    
    # Replace all non-alphanumeric characters with underscore
    sanitized = re.sub(r'[^a-zA-Z0-9]', '_', name)
    
    # Remove leading numbers/underscores
    sanitized = re.sub(r'^[0-9_]+', '', sanitized)
    
    # Remove trailing underscores and collapse multiple underscores
    sanitized = re.sub(r'_+', '_', sanitized)
    sanitized = sanitized.strip('_')
    
    # Ensure it starts with a letter
    if sanitized and not sanitized[0].isalpha():
        sanitized = 'IO_' + sanitized
    
    return sanitized if sanitized else None


def parse_pinout_csv(filepath):
    """Parse the Efinix pinout CSV to create BGA-to-GPIO mapping."""
    pin_to_gpio = {}
    
    with open(filepath, 'r') as f:
        # Skip comment lines at the start
        lines = f.readlines()
        
    # Find header line
    header_idx = None
    for i, line in enumerate(lines):
        if line.startswith('Pin Number,'):
            header_idx = i
            break
    
    if header_idx is None:
        print("ERROR: Could not find header in pinout CSV")
        return pin_to_gpio
    
    # Parse CSV starting from header
    csv_content = ''.join(lines[header_idx:])
    reader = csv.DictReader(csv_content.splitlines())
    
    for row in reader:
        pin_num = row.get('Pin Number', '').strip()
        pin_name = row.get('Pin Name', '').strip()
        function = row.get('Function', '').strip()
        
        if not pin_num or not pin_name:
            continue
            
        # Only include User IO pins
        if 'User IO' in function or function == '':
            # Check if this is a GPIO pin
            if pin_name.startswith('GPIO'):
                pin_to_gpio[pin_num] = pin_name
    
    return pin_to_gpio


def parse_netlist(filepath):
    """Parse the netlist file and extract U100 pin connections."""
    u100_connections = {}  # pin -> net_name
    
    with open(filepath, 'r') as f:
        content = f.read()
    
    # Find the *NET* section
    net_section_match = re.search(r'\*NET\*(.+?)(?:\*END\*|$)', content, re.DOTALL)
    if not net_section_match:
        print("ERROR: Could not find *NET* section")
        return u100_connections
    
    net_section = net_section_match.group(1)
    
    # Split into individual signals
    signals = re.split(r'\*SIGNAL\*\s+', net_section)
    
    for signal in signals:
        if not signal.strip():
            continue
        
        lines = signal.strip().split('\n')
        if not lines:
            continue
        
        # First line is the net name
        net_name = lines[0].strip()
        
        # Rest are component connections
        connections = ' '.join(lines[1:])
        
        # Find all U100.xxx references
        u100_pins = re.findall(r'U100\.([A-V]\d+)', connections)
        
        for pin in u100_pins:
            u100_connections[pin] = net_name
    
    return u100_connections


def should_skip_net(net_name):
    """Check if this net should be skipped (power, etc)."""
    if not net_name:
        return True
    
    # Skip power nets
    if net_name in SKIP_NETS:
        return True
    
    # Skip internal nets (start with $)
    if net_name.startswith('$'):
        return True
        
    return False


def should_skip_gpio(gpio_def):
    """Check if this GPIO def should be skipped."""
    if not gpio_def:
        return True
    
    for skip in SKIP_GPIO_CONTAINS:
        if skip in gpio_def:
            return True
    return False


def main():
    base_path = Path(__file__).parent
    
    # Parse pinout CSV
    print(f"Parsing pinout CSV: {PINOUT_CSV}")
    pin_to_gpio = parse_pinout_csv(base_path / PINOUT_CSV)
    print(f"  Found {len(pin_to_gpio)} GPIO pins")
    
    # Parse netlist
    print(f"\nParsing netlist: {NETLIST_FILE}")
    u100_connections = parse_netlist(base_path / NETLIST_FILE)
    print(f"  Found {len(u100_connections)} U100 pin connections")
    
    # Generate GPIO mappings
    gpio_entries = []
    skipped = []
    no_gpio = []
    
    for bga_pin, net_name in sorted(u100_connections.items()):
        # Skip power and ground nets
        if should_skip_net(net_name):
            skipped.append((bga_pin, net_name, "power/internal net"))
            continue
        
        # Get GPIO def for this BGA pin
        gpio_def = pin_to_gpio.get(bga_pin)
        if not gpio_def:
            no_gpio.append((bga_pin, net_name, "no GPIO mapping"))
            continue
        
        # Check if this GPIO should be skipped
        if should_skip_gpio(gpio_def):
            skipped.append((bga_pin, net_name, f"reserved GPIO: {gpio_def}"))
            continue
        
        # Sanitize net name
        sanitized_name = sanitize_name(net_name)
        if not sanitized_name:
            skipped.append((bga_pin, net_name, "invalid name after sanitization"))
            continue
        
        gpio_entries.append({
            'name': sanitized_name,
            'original_name': net_name,
            'gpio_def': gpio_def,
            'bga_pin': bga_pin,
        })
    
    # Remove duplicates (same gpio_def)
    seen_gpio_defs = set()
    unique_entries = []
    for entry in gpio_entries:
        if entry['gpio_def'] not in seen_gpio_defs:
            seen_gpio_defs.add(entry['gpio_def'])
            unique_entries.append(entry)
        else:
            skipped.append((entry['bga_pin'], entry['original_name'], f"duplicate gpio_def: {entry['gpio_def']}"))
    
    gpio_entries = unique_entries
    
    # Sort by GPIO def name for organized output
    gpio_entries.sort(key=lambda x: x['gpio_def'])
    
    # Separate DDRAM-related entries
    ddram_entries = [e for e in gpio_entries if 'DDR' in e['original_name'].upper()]
    non_ddram_entries = [e for e in gpio_entries if 'DDR' not in e['original_name'].upper()]
    
    print(f"\n=== RESULTS ===")
    print(f"Total valid GPIO entries: {len(gpio_entries)}")
    print(f"  - Non-DDRAM entries: {len(non_ddram_entries)}")
    print(f"  - DDRAM entries: {len(ddram_entries)}")
    print(f"Skipped: {len(skipped)}")
    print(f"No GPIO mapping: {len(no_gpio)}")
    
    # Write output file
    with open(base_path / OUTPUT_FILE, 'w') as f:
        f.write("=" * 80 + "\n")
        f.write("GPIO MAPPINGS FOR T120F324_A.peri.xml\n")
        f.write("=" * 80 + "\n\n")
        
        f.write("NON-DDRAM GPIO ENTRIES (add these first):\n")
        f.write("-" * 40 + "\n\n")
        
        for i, entry in enumerate(non_ddram_entries):
            f.write(f"{i+1}. {entry['name']}\n")
            f.write(f"   Original: {entry['original_name']}\n")
            f.write(f"   GPIO: {entry['gpio_def']}\n")
            f.write(f"   BGA Pin: {entry['bga_pin']}\n\n")
        
        f.write("\n" + "=" * 80 + "\n")
        f.write("DDRAM GPIO ENTRIES (add these last):\n")
        f.write("-" * 40 + "\n\n")
        
        for i, entry in enumerate(ddram_entries):
            f.write(f"{i+1}. {entry['name']}\n")
            f.write(f"   Original: {entry['original_name']}\n")
            f.write(f"   GPIO: {entry['gpio_def']}\n")
            f.write(f"   BGA Pin: {entry['bga_pin']}\n\n")
        
        f.write("\n" + "=" * 80 + "\n")
        f.write("SKIPPED PINS:\n")
        f.write("-" * 40 + "\n\n")
        for pin, net, reason in skipped:
            f.write(f"  {pin}: {net} - {reason}\n")
        
        f.write("\n" + "=" * 80 + "\n")
        f.write("PINS WITHOUT GPIO MAPPING:\n")
        f.write("-" * 40 + "\n\n")
        for pin, net, reason in no_gpio:
            f.write(f"  {pin}: {net}\n")
    
    print(f"\nOutput written to: {OUTPUT_FILE}")
    
    # Generate XML snippets for first 10 non-DDRAM entries
    print("\n" + "=" * 80)
    print("FIRST 10 GPIO XML ENTRIES (ready to add to peri.xml):")
    print("=" * 80 + "\n")
    
    for entry in non_ddram_entries[:10]:
        xml = f'''        <efxpt:gpio name="{entry['name']}"
                gpio_def="{entry['gpio_def']}"
                mode="input"
                bus_name=""
                is_lvds_gpio="false"
                io_standard="3.3 V LVTTL / LVCMOS">
            <efxpt:input_config name="{entry['name']}"
                    d_in_reg="false"
                    reg_init_value="0"
                    reg_clk_signal="default"
                    reg_clk_pin=""
                    clk_inverted="false"
                    clock_route_style="default"/>
        </efxpt:gpio>'''
        print(xml)
        print()
    
    return gpio_entries


if __name__ == '__main__':
    main()
