import xml.etree.ElementTree as ET

file_path = '/home/olle/efinity_p2/BRAM/T120F324_A/T120F324_A.peri.xml'

# Register namespaces
ET.register_namespace('efxpt', "http://www.efinixinc.com/peri_design_db")
ET.register_namespace('xsi', "http://www.w3.org/2001/XMLSchema-instance")

tree = ET.parse(file_path)
root = tree.getroot()

ns = {'efxpt': 'http://www.efinixinc.com/peri_design_db'}

gpio_info = root.find('efxpt:gpio_info', ns)

if gpio_info is not None:
    # List of GPIOs to add back (Higher numbered GPIOT pins)
    gpios_to_add = [
        {"name": "CAM2_EN", "gpio_def": "GPIOT_RXP15", "mode": "input", "bus_name": "", "is_lvds_gpio": "true", "io_standard": "3.3 V LVTTL / LVCMOS", "input_config": {"name": "CAM2_EN", "name_ddio_lo": "", "conn_type": "normal", "is_register": "false", "clock_name": "", "is_clock_inverted": "false", "pull_option": "none", "is_schmitt_trigger": "false", "ddio_type": "none"}},
        {"name": "DDR3_PGOOD", "gpio_def": "GPIOT_RXP16", "mode": "input", "bus_name": "", "is_lvds_gpio": "true", "io_standard": "3.3 V LVTTL / LVCMOS", "input_config": {"name": "DDR3_PGOOD", "name_ddio_lo": "", "conn_type": "normal", "is_register": "false", "clock_name": "", "is_clock_inverted": "false", "pull_option": "none", "is_schmitt_trigger": "false", "ddio_type": "none"}}
    ]

    for data in gpios_to_add:
        gpio = ET.SubElement(gpio_info, 'efxpt:gpio')
        gpio.set('name', data['name'])
        gpio.set('gpio_def', data['gpio_def'])
        gpio.set('mode', data['mode'])
        gpio.set('bus_name', data['bus_name'])
        gpio.set('is_lvds_gpio', data['is_lvds_gpio'])
        gpio.set('io_standard', data['io_standard'])
        
        input_config = ET.SubElement(gpio, 'efxpt:input_config')
        for key, value in data['input_config'].items():
            input_config.set(key, value)
            
        print(f"Added: {data['name']}")

    tree.write(file_path, encoding='UTF-8', xml_declaration=True)
    print("File updated successfully.")
else:
    print("efxpt:gpio_info not found.")
