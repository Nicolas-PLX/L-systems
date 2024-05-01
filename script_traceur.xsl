<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs">
    <xsl:output method="xml" indent="yes"/>
    
    <!--les méthodes-->
    <!-- Modèle de correspondance pour l'élément racine -->    
    <xsl:template match="/turtle-script">
        <tracer-script>
                <!-- Application du premier template aux commandes -->
                <xsl:apply-templates select="*[1]">
                    <xsl:with-param name="X" select="0"/>
                    <xsl:with-param name="Y" select="0"/>
                    <xsl:with-param name="ang" select="0"/>
                </xsl:apply-templates>
        </tracer-script>
    </xsl:template>

    <!-- Modèle de correspondance pour les éléments 'command', 'store' et 'restore' -->
    <xsl:template match="command | store | restore">
        <xsl:param name="X"/>
        <xsl:param name="Y"/>
        <xsl:param name="ang"/>
        <xsl:choose>
            <!-- Si c'est une commande -->
            <xsl:when test="self::command">
                <xsl:call-template name="Commands">
                    <xsl:with-param name="X" select="$X"/>
                    <xsl:with-param name="Y" select="$Y"/>
                    <xsl:with-param name="ang" select="$ang"/>
                </xsl:call-template>
            </xsl:when>
            <!-- Si c'est store ou restore -->
            <xsl:otherwise>
                <xsl:copy/>
                    <xsl:apply-templates select="following-sibling::*[1]">
                        <xsl:with-param name="X" select="$X"/>
                        <xsl:with-param name="Y" select="$Y"/>
                        <xsl:with-param name="ang" select="$ang"/>
                    </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Modèle de correspondance pour les élément 'command' -->
    <xsl:template name="Commands">
        <xsl:param name="X"/>
        <xsl:param name="Y"/>
        <xsl:param name="ang"/>
        <xsl:choose>
            <!-- 'LINE' -->
            <xsl:when test="contains(., 'LINE')">
                <xsl:call-template name="convertLine">
                    <xsl:with-param name="X" select="$X"/>
                    <xsl:with-param name="Y" select="$Y"/>
                    <xsl:with-param name="ang" select="$ang"/>
                </xsl:call-template>
            </xsl:when>
            <!-- 'MOVE' -->
            <xsl:when test="contains(., 'MOVE')">
                <xsl:call-template name="convertMove">
                    <xsl:with-param name="X" select="$X"/>
                    <xsl:with-param name="Y" select="$Y"/>
                    <xsl:with-param name="ang" select="$ang"/>
                </xsl:call-template>
            </xsl:when>
            <!-- 'TURN' -->
            <xsl:when test="contains(., 'TURN')">
                <xsl:call-template name="convertTurn">
                    <xsl:with-param name="X" select="$X"/>
                    <xsl:with-param name="Y" select="$Y"/>
                    <xsl:with-param name="ang" select="$ang"/>                
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!--conversion des 'LINE' en 'LINETO'-->
    <xsl:template name="convertLine">
        <xsl:param name="X"/>
        <xsl:param name="Y"/>
        <xsl:param name="ang"/>
        <xsl:variable name="arg" select="number(substring-after(., 'LINE '))"/>
        <command>
            <!-- Calcul des coordonnées pour LINETO -->
            <xsl:text>LINETO </xsl:text>
            <xsl:value-of select="round((xs:double($X) + xs:double($arg)  * math:cos($ang * math:pi() div 180)),2)" />
            <xsl:text>,</xsl:text>
            <xsl:value-of select="round((xs:double($Y) + xs:double($arg)  * math:sin($ang * math:pi() div 180)),2)"/>
        </command>
        <!-- Appel récursif pour la prochaine commande -->
         <xsl:apply-templates select="following-sibling::*[1]">
            <xsl:with-param name="X" select="round((xs:double($X) + xs:double($arg)  * math:cos($ang * math:pi() div 180)),2)"/>
            <xsl:with-param name="Y" select="round((xs:double($Y) + xs:double($arg)  * math:sin($ang * math:pi() div 180)),2)"/>
            <xsl:with-param name="ang" select="$ang"/>
        </xsl:apply-templates>
    </xsl:template>

    <!--conversion des 'MOVE' en 'MOVETO'-->
    <xsl:template name="convertMove">
        <xsl:param name="X"/>
        <xsl:param name="Y"/>
        <xsl:param name="ang"/>
        <xsl:variable name="arg" select="number(substring-after(., 'MOVE '))"/>
        <command>
            <!-- Calcul des coordonnées pour LINETO -->
            <xsl:text>MOVETO </xsl:text>
            <xsl:value-of select="round((xs:double($X) + xs:double($arg)  * math:cos($ang * math:pi() div 180)),2)" />
            <xsl:text>,</xsl:text>
            <xsl:value-of select="round((xs:double($Y) + xs:double($arg)  * math:sin($ang * math:pi() div 180)),2)"/>
        </command>
        <!-- Appel récursif pour la prochaine commande -->
        <xsl:apply-templates select="following-sibling::*[1]">
            <xsl:with-param name="X" select="round((xs:double($X) + xs:double($arg)  * math:cos($ang * math:pi() div 180)),2)"/>
            <xsl:with-param name="Y" select="round((xs:double($Y) + xs:double($arg)  * math:sin($ang * math:pi() div 180)),2)"/>
            <xsl:with-param name="ang" select="$ang"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <!--conversion des 'TURN' en modifiant les coordonées-->
    <xsl:template name="convertTurn">
        <xsl:param name="X"/>
        <xsl:param name="Y"/>
        <xsl:param name="ang"/>
        <xsl:variable name="theta" select="number(substring-after(., 'TURN '))"/> 
        <xsl:variable name="newAng" select="$ang + $theta"/>
        <!-- Appel récursif pour la prochaine commande -->
        <xsl:apply-templates select="following-sibling::*[1]">
            <xsl:with-param name="X" select="$X"/>
            <xsl:with-param name="Y" select="$Y"/>
            <xsl:with-param name="ang" select="$newAng"/>
        </xsl:apply-templates>
    </xsl:template>
</xsl:stylesheet>
