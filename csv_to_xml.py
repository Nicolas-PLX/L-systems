import csv
import xml.etree.ElementTree as ET

def csv_to_xml(csv_file, xml_file):
    # Créer l'élément racine du fichier XML
    root = ET.Element("L-systems")

    # Lire le fichier CSV et créer les éléments XML pour chaque L-système
    with open(csv_file, "r") as csvfile:
        reader = csv.reader(csvfile)
        header = next(reader)  # Ignorer l'en-tête du fichier CSV
        for row in reader:
            print(row)
            lsystem = ET.SubElement(root, "L-system", name=row[0])
            symbols = ET.SubElement(lsystem, "symbols").text = row[1]
            axiom = ET.SubElement(lsystem, "axiom").text = row[2]
            substitution = ET.SubElement(lsystem, "substitution")
            rules = row[3:len(row):2]
            print("RULES :\n")
            print(rules)
            for i in range(len(rules)):
                rule = ET.SubElement(substitution, "rule", symbol=rules[i])
                rule.text = rules[i]
            interpretation = ET.SubElement(lsystem, "interpretation")
            actions = ["LINE", "TURN", "TURN"]
            params = row[-3:]
            for i in range(len(actions)):
                symbol = ET.SubElement(interpretation, "symbol", action=actions[i]).text = symbols[i]
                param = ET.SubElement(interpretation, "param", value=params[i])

    # Écrire le fichier XML
    tree = ET.ElementTree(root)
    tree.write(xml_file, xml_declaration=True, encoding='utf-8', method="xml")

# Appeler la fonction avec les noms des fichiers CSV et XML en entrée et sortie
csv_to_xml("Resource/l-systems.csv", "l-systems.xml")