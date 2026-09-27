import xml.etree.ElementTree as ET
import re

def validate_xml(filepath):
    try:
        tree = ET.parse(filepath)
        root = tree.getroot()
        
        # Namespaces
        ns = {'efxpt': 'http://www.efinixinc.com/peri_design_db'}
        
        gpios = root.findall('.//efxpt:gpio', ns)
        
        names = {}
        defs = {}
        
        print(f"Found {len(gpios)} GPIO definitions.")
        
        for gpio in gpios:
            name = gpio.get('name')
            gpio_def = gpio.get('gpio_def')
            
            # Check name validity
            if not re.match(r'^[a-zA-Z_][a-zA-Z0-9_-]*$', name):
                print(f"WARNING: Invalid name format: '{name}' on pin {gpio_def}")
            
            # Check duplicates
            if name in names:
                print(f"ERROR: Duplicate name '{name}' on pins {names[name]} and {gpio_def}")
            else:
                names[name] = gpio_def
                
            if gpio_def in defs:
                print(f"ERROR: Duplicate pin definition '{gpio_def}' used by names {defs[gpio_def]} and {name}")
            else:
                defs[gpio_def] = name
                
    except ET.ParseError as e:
        print(f"XML Parse Error: {e}")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    validate_xml("/home/olle/efinity_p2/BRAM/T120F324_A/T120F324_A.peri.xml")
