# README 

Le sujet du projet se trouve dans la rubrique "Resource".

### Etudiant  

PENELOUX Nicolas 22001302  
DJEDOU Iness 22119484

### Fonctionnement des fichiers 



#### Pour compiler le fichier csv_to_xml.py : 

    python3 csv_to_xml.py <csv_file> <xml_file>
    
    
#### Pour compiler le fichier script_tortues.xsl :

    java -jar .\saxon-he-10.3.jar -s:<xml_file> -xsl:.\script_tortue.xsl systemName="nom" iteration="n" > <output.xml>
    
Avec "nom" qui correspond au nom du L-système, "n" le nombre d'itérations souhaités, et "output.xml" le nom du fichier de sortie.
    

#### Pour compiler le fichier script_traceur.xsl :

    java -jar .\saxon-he-10.3.jar -s:<xml_file> -xsl:.\script_traceur.xsl  > <output.xml>
    
    
#### Pour compiler le fichier script_SVG.xsl :

    java -jar .\saxon-he-10.3.jar -s:<xml_file> -xsl:.\script_SVG.xsl width="l" height="L" > <output.svg>
    
Avec "l" qui correspond à la largeur, "L" qui correspond à la hauteur, et "output.svg" qui correspond au nom du fichier de sortie.
