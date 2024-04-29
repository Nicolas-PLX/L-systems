<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs">

    <!--les paramètres-->
    <xsl:param name="x" select="0" />
    <xsl:param name="y" select="0" />
    <xsl:param name="theta" select="0" />

    <!--le sortie-->
    <xsl:output method="xml" indent="yes" />

    <!--les méthodes-->
    <!-- Modèle de correspondance pour l'élément racine -->
    <xsl:template match="/">
        <tracer-script>
            <instructions>
                <xsl:apply-templates select="//command" />
            </instructions>
        </tracer-script>
    </xsl:template>

    <!-- Modèle de correspondance pour les élément 'command' -->
    <xsl:template match="command">
        <xsl:variable name="cmd" select="substring-before(., ' ')" />
        <xsl:variable name="arg" select="substring-after(., ' ')" />
        <xsl:choose>
            <!-- Si la commande est LINE -->
            <xsl:when test="$cmd = 'LINE'">
                <command>
                    <xsl:value-of select="'LINETO '" />
                    <xsl:value-of select="$x + xs:double($arg)" />
                    <xsl:text>,</xsl:text>
                    <xsl:value-of select="$y" />
                </command>
            </xsl:when>
            <!-- Si la commande est MOVE -->
            <xsl:when test="$cmd = 'MOVE'">
                <command>
                    <xsl:value-of select="'MOVETO '" />
                    <xsl:value-of select="$x + xs:double($arg)" />
                    <xsl:text>,</xsl:text>
                    <xsl:value-of select="$y" />
                </command>
            </xsl:when>
            <!-- Si la commande est TURN -->
            <xsl:when test="$cmd = 'TURN'">
                <!-- Calcul des nouvelles coordonnées en fonction de l'angle -->
                <xsl:variable name="newX" select="$x * math:cos($theta)" />
                <xsl:variable name="newY" select="$y * math:sin($theta)" />
                <!--TODO a trouver commment mettre a jour-->
            </xsl:when>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>

