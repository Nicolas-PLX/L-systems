<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs">
    <xsl:output method="xml" indent="yes"/>
    
    <!--les méthodes-->
    <!-- Modèle de correspondance pour l'élément racine -->    <xsl:template match="/turtle-script">
        <tracer-script>
            <instructions>
                <!-- Application du premier template aux commandes -->
                <xsl:apply-templates select="command[1]">
                    <xsl:with-param name="X" select="0"/>
                    <xsl:with-param name="Y" select="0"/>
                </xsl:apply-templates>
            </instructions>
        </tracer-script>
    </xsl:template>

    <!-- Modèle de correspondance pour les élément 'command' -->
    <xsl:template match="command">
        <xsl:param name="X"/>
        <xsl:param name="Y"/>
        <xsl:choose>
            <!-- 'LINE' -->
            <xsl:when test="contains(., 'LINE')">
                <xsl:call-template name="convertLine">
                    <xsl:with-param name="X" select="$X"/>
                    <xsl:with-param name="Y" select="$Y"/>
                </xsl:call-template>
            </xsl:when>
            <!-- 'MOVE' -->
            <xsl:when test="contains(., 'MOVE')">
                <xsl:call-template name="convertMove">
                    <xsl:with-param name="X" select="$X"/>
                    <xsl:with-param name="Y" select="$Y"/>
                </xsl:call-template>
            </xsl:when>
            <!-- 'TURN' -->
            <xsl:when test="contains(., 'TURN')">
                <xsl:call-template name="convertTurn">
                    <xsl:with-param name="X" select="$X"/>
                    <xsl:with-param name="Y" select="$Y"/>
                </xsl:call-template>
            </xsl:when>
            <!--TODO il reste encore store et restore-->
        </xsl:choose>
    </xsl:template>

    <!--conversion des 'LINE' en 'LINETO'-->
    <xsl:template name="convertLine">
        <xsl:param name="X"/>
        <xsl:param name="Y"/>
        <xsl:variable name="arg" select="number(substring-after(., 'LINE '))"/>
        <command>
            <!-- Calcul des coordonnées pour LINETO -->
            <xsl:text>LINETO </xsl:text>
            <xsl:value-of select="$X + $arg"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="$Y"/>
        </command>
        <!-- Appel récursif pour la prochaine commande -->
        <xsl:apply-templates select="following-sibling::command[1]">
            <xsl:with-param name="X" select="$X + $arg"/>
            <xsl:with-param name="Y" select="$Y"/>
        </xsl:apply-templates>
    </xsl:template>

    <!--conversion des 'MOVE' en 'MOVETO'-->
    <xsl:template name="convertMove">
        <xsl:param name="X"/>
        <xsl:param name="Y"/>
        <xsl:variable name="arg" select="number(substring-after(., 'MOVE '))"/>
        <command>
            <!-- Calcul des coordonnées pour LINETO -->
            <xsl:text>MOVETO </xsl:text>
            <xsl:value-of select="$X + $arg"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="$Y"/>
        </command>
        <!-- Appel récursif pour la prochaine commande -->
        <xsl:apply-templates select="following-sibling::command[1]">
            <xsl:with-param name="X" select="$X + $arg"/>
            <xsl:with-param name="Y" select="$Y"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <!--conversion des 'TURN' en modifiant les coordonées-->
    <xsl:template name="convertTurn">
        <xsl:param name="X"/>
        <xsl:param name="Y"/>
        <xsl:variable name="theta" select="number(substring-after(., 'TURN '))"/>
        <!-- Mise à jour des coordonnées pour la prochaine commande LINE -->
        <!--TODO à trouver les expressions pour les calculs-->
        <xsl:variable name="newX" select="$X "/>
        <xsl:variable name="newY" select="$Y"/>
        <!-- Appel récursif pour la prochaine commande -->
        <xsl:apply-templates select="following-sibling::command[1]">
            <xsl:with-param name="X" select="$newX"/>
            <xsl:with-param name="Y" select="$newY"/>
        </xsl:apply-templates>
    </xsl:template>
</xsl:stylesheet>
