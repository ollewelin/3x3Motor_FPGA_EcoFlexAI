import re
import os
import csv

def parse_pinout_csv(csv_path):
    pin_to_resource = {}
    try:
        with open(csv_path, 'r', encoding='utf-8') as f:
            reader = csv.reader(f)
            headers_found = False
            for row in reader:
                if not row: continue
                if "Pin Number" in row and "Pin Name" in row:
                    headers_found = True
                    idx_pin_num = row.index("Pin Number")
                    idx_pin_name = row.index("Pin Name")
                    continue
                if headers_found and len(row) > max(idx_pin_num, idx_pin_name):
                    pin_num = row[idx_pin_num].strip()
                    resource_name = row[idx_pin_name].strip()
                    if pin_num:
                        pin_to_resource[pin_num] = resource_name
    except Exception as e:
        print(f"Error parsing CSV: {e}")
    return pin_to_resource

def parse_netlist(filepath):
    pin_map = {} 
    current_signal = None
    exclude_patterns = [r'^GND', r'^VCC', r'^\+?1V2', r'^\+?3V3', r'^\+?1\.2V', r'^\+?3\.3V', r'^VDD', r'^VSS', r'^P\d+V', r'^AGND', r'^DGND']
    
    net_connections = {}
    
    with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
        lines = f.readlines()
        
    for line in lines:
        line = line.strip()
        if line.startswith('*SIGNAL*'):
            parts = line.split()
            if len(parts) >= 2:
                raw_signal = parts[1]
                current_signal = raw_signal.split('\\')[-1] if '\\' in raw_signal else raw_signal
                if current_signal not in net_connections:
                    net_connections[current_signal] = []
        elif current_signal:
            tokens = line.split()
            for token in tokens:
                net_connections[current_signal].append(token)
                if token.startswith('U100.'):
                    pin = token.split('.')[1]
                    is_excluded = False
                    for pattern in exclude_patterns:
                        if re.match(pattern, current_signal, re.IGNORECASE):
                            is_excluded = True
                            break
                    if not is_excluded:
                        pin_map[pin] = current_signal

    # Rename unnamed nets
    for pin, net_name in pin_map.items():
        if net_name.startswith('$'):
            connections = net_connections.get(net_name, [])
            better_name = None
            for conn in connections:
                if conn.startswith('U100.'): continue
                parts = conn.split('.')
                if len(parts) == 2:
                    comp = parts[0]
                    comp_pin = parts[1]
                    if comp.startswith('U'):
                        better_name = f"{comp}_Pin_{comp_pin}"
                        break
                    elif not better_name:
                        better_name = f"{comp}_Pin_{comp_pin}"
            if better_name:
                pin_map[pin] = better_name
            else:
                pin_map[pin] = f"NC_Pin_{pin}"
    return pin_map

def generate_xml_content(pin_map, resource_map):
    gpio_lines = []
    
    for pin in sorted(pin_map.keys()):
        net_name = pin_map[pin]
        resource_name = resource_map.get(pin)
        
        if not resource_name:
            print(f"Warning: No resource found for pin {pin}. Skipping.")
            continue
            
        if resource_name in ["GND", "VCC", "VCCIO", "VCC_CORE"]:
            continue

        safe_name = re.sub(r'[^a-zA-Z0-9_]', '_', net_name)
        if safe_name[0].isdigit(): safe_name = "Net_" + safe_name

        # Heuristic for LVDS GPIO
        is_lvds = "true" if resource_name.startswith("GPIOT") else "false"
        
        conn_type = "normal"
        if safe_name == "T120_GCLK":
            conn_type = "gclk"
        
        # Use nested structure
        xml_line = f'''        <efxpt:gpio name="{safe_name}" gpio_def="{resource_name}" mode="input" bus_name="" is_lvds_gpio="{is_lvds}" io_standard="3.3 V LVTTL / LVCMOS">
            <efxpt:input_config name="{safe_name}" name_ddio_lo="" conn_type="{conn_type}" is_register="false" clock_name="" is_clock_inverted="false" pull_option="none" is_schmitt_trigger="false" ddio_type="none"/>
        </efxpt:gpio>'''
        gpio_lines.append(xml_line)
    return gpio_lines

def update_peri_xml(xml_path, gpio_lines):
    with open(xml_path, 'r') as f:
        content = f.read()
    
    # Find the start tag
    start_match = re.search(r'<efxpt:gpio_info[^>]*>', content)
    if not start_match:
        print("Error: Could not find gpio_info tag")
        return
    
    start_idx = start_match.end()
    end_idx = content.find('</efxpt:gpio_info>')
    
    if end_idx == -1:
        print("Error: Could not find closing gpio_info tag")
        return
        
    # Extract existing global_unused_config if present
    inner_content = content[start_idx:end_idx]
    global_conf_match = re.search(r'<efxpt:global_unused_config[^>]*/>', inner_content)
    global_conf = '        <efxpt:global_unused_config state="input with weak pullup"/>' # Default
    if global_conf_match:
        global_conf = "        " + global_conf_match.group(0).strip()
        
    # Construct new inner content
    new_inner = "\n" + "\n".join(gpio_lines) + "\n" + global_conf + "\n    "
    
    new_content = content[:start_idx] + new_inner + content[end_idx:]
    
    with open(xml_path, 'w') as f:
        f.write(new_content)

if __name__ == "__main__":
    base_path = "/home/olle/efinity_p2/BRAM/T120F324_A"
    netlist_path = os.path.join(base_path, "Netlist_top_level_2026-01-02.asc")
    xml_path = os.path.join(base_path, "T120F324_A.peri.xml")
    pinout_csv_path = os.path.join(base_path, "outflow/T120F324_A.pinout.csv")
    
    print(f"Parsing Pinout CSV...")
    resource_map = parse_pinout_csv(pinout_csv_path)
    
    print(f"Parsing Netlist...")
    pin_map = parse_netlist(netlist_path)
    print(f"Found {len(pin_map)} user I/O connections.")
    
    print("Generating XML...")
    gpio_lines = generate_xml_content(pin_map, resource_map)
    
    print(f"Updating {xml_path}...")
    update_peri_xml(xml_path, gpio_lines)
    print("Done.")
