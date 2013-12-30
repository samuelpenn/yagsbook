<?xml version="1.0"?>
<!--Namespaces are global if you set them in the stylesheet element-->
<xsl:transform
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0"
    xmlns:xalan="http://xml.apache.org/xalan"
    xmlns:java="http://xml.apache.org/xalan"
    xmlns:mapcraft="uk.co.demon.bifrost.rpg.encyclopedia.Extensions"
    extension-element-prefixes="mapcraft">

    <xalan:component prefix="ext1">
        <xalan:script lang="javaclass"
                      src="xalan://uk.co.demon.bifrost.rpg.encyclopedia.Extensions"/>
    </xalan:component>

    <xsl:template match="//import-map">
        <xsl:choose>
            <xsl:when test="./crop">
            </xsl:when>
            <xsl:when test="./area">
                <xsl:value-of select="mapcraft:areaMap(@href, @scale, area/@name, area/@radius)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="mapcraft:standardMap(@href, @scale)"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>


</xsl:transform>
