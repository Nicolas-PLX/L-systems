<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs">

<!--les paramètres-->
  <xsl:param name="systemName"/>
  <xsl:param name="iteration"/>

<!--le sortie-->
  <xsl:output method="xml" indent="yes" />

<!--les méthodes-->
  <!-- Modèle de correspondance pour l'élément racine -->
  <xsl:template match="/">
    <turtle-script>
      <xsl:apply-templates select="//L-system[@name = $systemName]" />
    </turtle-script>
  </xsl:template>

  <!-- Modèle de correspondance pour les éléments 'L-system' -->
  <xsl:template match="L-system">
    <xsl:variable name="currentSystem" select="." />
    <xsl:variable name="axiom" select="axiom" />
    <xsl:variable name="rules" select="substitution/rule_sub" />
    <xsl:variable name="interpretation" select="$currentSystem/interpretation/rule_int" />

    <!--application du modele iterate sur nos parametres-->
    <xsl:variable name="iteratedAxiom">
      <xsl:call-template name="iterate">
          <xsl:with-param name="axiom" select="$axiom" />
          <xsl:with-param name="rules" select="$rules" />
          <xsl:with-param name="iteration" select="$iteration" />
      </xsl:call-template>
    </xsl:variable>
  
  <!--iterpretation du resultat precedent avec le modele interpret-->
    <xsl:call-template name="interpret">
      <xsl:with-param name="string" select="$iteratedAxiom" />
      <xsl:with-param name="interpretation" select="$interpretation" />
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template name="iterate">
    <xsl:param name="axiom" />
    <xsl:param name="rules" />
    <xsl:param name="iteration" />
    <!--application des regles sur l'axiome-->
    <xsl:if test="$iteration > 0">
      <xsl:variable name="newAxiom">
        <xsl:call-template name="applyRules">
          <xsl:with-param name="string" select="$axiom" />
          <xsl:with-param name="rules" select="$rules" />
        </xsl:call-template>
      </xsl:variable>
      <!--appel recursif-->
      <xsl:call-template name="iterate">
        <xsl:with-param name="axiom" select="$newAxiom" />
        <xsl:with-param name="rules" select="$rules" />
        <xsl:with-param name="iteration" select="$iteration - 1" />
      </xsl:call-template>
    </xsl:if>
    <!--fin des iterations-->
    <xsl:if test="$iteration = 0">
      <xsl:copy-of select="$axiom" />
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="applyRules">
    <xsl:param name="string" />
    <xsl:param name="rules" />

    <xsl:if test="string-length($string) > 0">
      <xsl:variable name="char" select="substring($string, 1, 1)" />
      <xsl:variable name="rule" select="$rules[ @symbol = $char ]" />
      <!--verifiction s'il y a une regle pour ce char-->
      <xsl:choose>
        <xsl:when test="$rule">
          <xsl:value-of select="$rule" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$char" />
        </xsl:otherwise>
      </xsl:choose>
      <!--appel recursif sur le reste du string-->
      <xsl:call-template name="applyRules">
        <xsl:with-param name="string" select="substring($string, 2)" />
        <xsl:with-param name="rules" select="$rules" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="interpret">
    <xsl:param name="string" />
    <xsl:param name="interpretation" />

    <xsl:if test="string-length($string) > 0">
      <xsl:variable name="char" select="substring($string, 1, 1)" />
      <xsl:variable name="command" select="$interpretation[ @symbol = $char ]" />
      <!--interpretation du char-->
      <xsl:choose>
        <xsl:when test="$command">
          <command>
            <xsl:value-of select="$command" />
          </command>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$char = '['">
              <store />
            </xsl:when>
            <xsl:otherwise>
              <restore />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
      <!--appel recursif sur le reste du string-->
      <xsl:call-template name="interpret">
        <xsl:with-param name="string" select="substring($string, 2)" />
        <xsl:with-param name="interpretation" select="$interpretation" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>