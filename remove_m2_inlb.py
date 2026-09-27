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
    gpios_to_remove = []
    for gpio in gpio_info.findall('efxpt:gpio', ns):
        if gpio.get('name') == "M2_INLB":
            gpios_to_remove.append(gpio)
    
    for gpio in gpios_to_remove:
        gpio_info.remove(gpio)
        print(f"Removed: {gpio.get('name')}")

    tree.write(file_path, encoding='UTF-8', xml_declaration=True)
    print("File updated successfully.")
else:
    print("efxpt:gpio_info not found.")
