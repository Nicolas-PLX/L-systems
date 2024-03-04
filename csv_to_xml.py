import csv
import xml.etree.ElementTree as ET
import xml.dom.minidom
import sys


# Fonction qui trouve le premier index des interprétations
def first_index_of_param(row):
    actions = ["MOVE","TURN","LINE"]
    res = -1
    for action in actions:
        for index,element in enumerate(row):
            if action in element:
                if res != -1 and res > index:
                    res = index
                elif res == -1:
                    res = index
    return res


def csv_to_xml(csv_file, xml_file):
    # Créer l'élément racine du fichier XML
    root = ET.Element("L-systems")

    # Lire le fichier CSV et créer les éléments XML pour chaque L-système
    with open(csv_file, "r") as csvfile:
        reader = csv.reader(csvfile)
        for row in reader:
            index_action = first_index_of_param(row)
            if index_action == -1:
                print("Erreur : mauvais format de fichier csv.")
                exit()
            lsystem = ET.SubElement(root, "L-system", name=row[0])
            symbols = ET.SubElement(lsystem, "symbols").text = row[1]
            axiom = ET.SubElement(lsystem, "axiom").text = row[2]
            substitution = ET.SubElement(lsystem, "substitution")
            rules = row[3:index_action]
 
            for i in range(len(rules)):
                rule = ET.SubElement(substitution, "rule", symbol=symbols[i]).text = rules[i]
            interpretation = ET.SubElement(lsystem, "interpretation")
            params = row[index_action:]
            for i in range(len(params)):
                action = params[i].split(" ")
                symbol = ET.SubElement(interpretation, "symbol", action=action[0]).text = symbols[i]
                param = ET.SubElement(interpretation, "param", value=action[1])
    # Création du fichier XML
    tree = ET.ElementTree(root)
    tree.write(xml_file, xml_declaration=True, encoding='utf-8', method="xml")
    




arguments = sys.argv
if len(arguments)!= 3:
    print("Format incorrect.\n Utilisation : python csv_to_xml.py <csv_file> <xml_file>")
    exit()

if arguments[1][-4:] != ".csv" or arguments[2][-4:] != ".xml":
    print("Format incorrect de fichier.\n Utilisation : python csv_to_xml.py <csv_file> <xml_file>")
    exit()





# Appeler la fonction avec les noms des fichiers CSV et XML en entrée et sortie
csv_to_xml(arguments[1], arguments[2])
dom = xml.dom.minidom.parse(arguments[2])
indentage = dom.toprettyxml()
with open(arguments[2],'w') as file:
    file.write(indentage)
    file.close()
    print(f"Création du fichier {arguments[2]} réussi.")
