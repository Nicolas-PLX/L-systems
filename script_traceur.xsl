<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs">

<!--le sortie-->
  <xsl:output method="xml" indent="yes" />

    <!--les méthodes-->
    <!-- Modèle de correspondance pour l'élément racine -->
    <xsl:template match="/">
        <tracer-script>
            <instructions>
                <xsl:apply-templates select="turtle-script/command" />
            </instructions>
        </tracer-script>
    </xsl:template>

    <!-- Modèle de correspondance pour les élément 'command' -->
    <xsl:template match="command">
    <xsl:variable name="cmd" select="substring-before(., ' ')" />
    <xsl:variable name="arg" select="substring-after(., ' ')" />
    <!--todo recherche de méthode de conversion en cours-->
    </xsl:template>


</xsl:stylesheet>