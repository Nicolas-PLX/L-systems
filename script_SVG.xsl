<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns="http://www.w3.org/2000/svg" xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs">
    <xsl:output method="xml" indent="yes"/>

    <!-- Paramètres pour les dimensions du SVG -->
    <xsl:param name="width" select="200"/>
    <xsl:param name="height" select="200"/>

    <!-- Template pour la racine -->
    <xsl:template match="/">
        <svg xmlns="http://www.w3.org/2000/svg" width="{$width}" height="{$height}" viewBox="-50 -50 {$width} {$height}">
            <xsl:variable name="pathData">
                <xsl:call-template name="generatePath"/>
            </xsl:variable>
            <path d="{$pathData}" fill="none" stroke="black"/>
        </svg>
    </xsl:template>

    <xsl:template name="generatePath">
    <xsl:variable name="commands" select="/tracer-script/command"/>
    <!-- Commencer par M 0,0 -->
    <xsl:text>M 0,0 </xsl:text>
    <!-- Traiter les commandes -->
    <xsl:apply-templates select="$commands"/>
</xsl:template>

<!-- Template pour traiter chaque commande -->
<xsl:template match="command">
    <!-- Extraire le type de commande (MOVETO ou LINETO) et les coordonnées -->
    <xsl:variable name="type" select="substring-before(normalize-space(.), ' ')"/>
    <xsl:variable name="coords" select="substring-after(normalize-space(.), ' ')"/>
    <!-- Construire la partie correspondante du chemin SVG -->
    <!-- Ajouter un espace avant la commande LINETO (sauf pour la première) -->
    <xsl:if test="position() &gt; 1 and $type = 'LINETO'">
        <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:choose>
        <xsl:when test="$type = 'MOVETO'">
            <xsl:text>M </xsl:text>
        </xsl:when>
        <xsl:when test="$type = 'LINETO'">
            <xsl:text>L </xsl:text>
        </xsl:when>
    </xsl:choose>
    <xsl:value-of select="$coords"/>
    <xsl:text> </xsl:text>
</xsl:template>
</xsl:stylesheet>
