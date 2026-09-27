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
    exclude_patterns = [r'^GND', r'^VCC', r'^\+?1V2', r'^\+?3V3', r'^\+?1\.2V', r'^\+?3\.3V', r'^VDD', r'^VSS']
    
    with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
        lines = f.readlines()
        
    for line in lines:
        line = line.strip()
        if line.startswith('*SIGNAL*'):
            parts = line.split()
            if len(parts) >= 2:
                raw_signal = parts[1]
                current_signal = raw_signal.split('\\')[-1] if '\\' in raw_signal else raw_signal
        elif current_signal:
            tokens = line.split()
            for token in tokens:
                if token.startswith('U100.'):
                    pin = token.split('.')[1]
                    is_excluded = False
                    for pattern in exclude_patterns:
                        if re.match(pattern, current_signal, re.IGNORECASE):
                            is_excluded = True
                            break
                    if not is_excluded:
                        pin_map[pin] = current_signal
    return pin_map

def add_minimal_io(manual_xml_path, output_xml_path, pin_map, resource_map):
    with open(manual_xml_path, 'r') as f:
        content = f.read()
        
    # Find existing GPIOs to avoid duplicates
    existing_gpios = re.findall(r'<efxpt:gpio name="([^"]+)"', content)
    existing_resources = re.findall(r'gpio_def="([^"]+)"', content)
    
    print(f"Existing GPIOs: {existing_gpios}")
    print(f"Existing Resources: {existing_resources}")
    
    added_count = 0
    new_gpio_lines = []
    
    # Pins to skip (already in manual file)
    # K17 (GPIOL_66), H17 (GPIOT_RXN11), A15 (GPIOT_RXN21)
    skip_pins = ['K17', 'H17', 'A15']
    
    for pin in sorted(pin_map.keys()):
        if added_count >= 2:
            break
            
        if pin in skip_pins:
            continue
            
        resource_name = resource_map.get(pin)
        if not resource_name or resource_name in existing_resources:
            continue
            
        net_name = pin_map[pin]
        safe_name = re.sub(r'[^a-zA-Z0-9_]', '_', net_name)
        if safe_name[0].isdigit(): safe_name = "Net_" + safe_name
        
        # Check if name already exists
        if safe_name in existing_gpios:
            continue
            
        print(f"Adding Pin {pin} -> {resource_name} ({safe_name})")
        
        # Use nested structure matching the manual file
        # Assuming input for now to match M1_HALL_A structure which is known to work
        xml_line = f'''        <efxpt:gpio name="{safe_name}" gpio_def="{resource_name}" mode="input" bus_name="" is_lvds_gpio="true" io_standard="3.3 V LVTTL / LVCMOS">
            <efxpt:input_config name="{safe_name}" name_ddio_lo="" conn_type="normal" is_register="false" clock_name="" is_clock_inverted="false" pull_option="none" is_schmitt_trigger="false" ddio_type="none"/>
        </efxpt:gpio>'''
        new_gpio_lines.append(xml_line)
        added_count += 1
        
    if new_gpio_lines:
        # Insert BEFORE the global_unused_config tag
        # The manual file has <efxpt:global_unused_config .../> as the last element in gpio_info
        
        pattern = r'(<efxpt:global_unused_config[^>]*/>)'
        match = re.search(pattern, content)
        
        if match:
            insertion_point = match.start()
            new_content = content[:insertion_point] + "\n".join(new_gpio_lines) + "\n        " + content[insertion_point:]
            
            with open(output_xml_path, 'w') as f:
                f.write(new_content)
            print(f"Successfully created {output_xml_path} with {added_count} new GPIOs.")
        else:
            print("Error: Could not find global_unused_config tag.")
    else:
        print("No new GPIOs found to add.")

if __name__ == "__main__":
    base_path = "/home/olle/efinity_p2/BRAM/T120F324_A"
    manual_xml = os.path.join(base_path, "T120F324_A.peri_copy_manual2.xml")
    output_xml = os.path.join(base_path, "T120F324_A.peri.xml")
    netlist = os.path.join(base_path, "Netlist_top_level_2026-01-02.asc")
    pinout = os.path.join(base_path, "outflow/T120F324_A.pinout.csv")
    
    r_map = parse_pinout_csv(pinout)
    p_map = parse_netlist(netlist)
    add_minimal_io(manual_xml, output_xml, p_map, r_map)
