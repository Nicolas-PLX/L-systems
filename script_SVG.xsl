<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns="http://www.w3.org/2000/svg" xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs">
    <xsl:output method="xml" indent="yes"/>

     <!-- Paramètres pour les dimensions du SVG -->
    <xsl:param name="width" select="940"/>
    <xsl:param name="height" select="700"/>

     <!-- Template pour la racine -->
    <xsl:template match="/">
        <svg xmlns="http://www.w3.org/2000/svg" width="{$width}" height="{$height}">
            <!--TODO a faire-->
        </svg>
    </xsl:template>
</xsl:stylesheet>
