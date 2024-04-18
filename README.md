PENELOUX Nicolas 22001302  
DJEDOU Iness 22119484


Fonctionnement :

Pour compiler le fichier csv_to_xml.py : 

    python3 csv_to_xml.py <csv_file> <xml_file>
    
    
Pour compiler le fichier script_tortues.xsl :

    java -jar .\saxon-he-10.3.jar -s:<xml_file> -xsl:.\script_tortue.xsl systemName="nom" iteration="n" > <output.xml>
    
Avec "nom" qui correspond au nom du L-système, "n" le nombre d'itérations souhaités, et "output.xml" le nom du fichier de sortie.
    