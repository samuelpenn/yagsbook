<?xml version="1.0" ?>


<xsl:transform
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        version="1.0"
        >

    <xsl:template match="/page/links">
        <div class="links">
            <xsl:apply-templates select="link"/>
        </div>
    </xsl:template>

    <xsl:template match="/page/links/link">
        <span class="link">
            <xsl:if test="@uri">
                <a href="{@uri}.html"><xsl:value-of select="."/></a>
            </xsl:if>

            <xsl:if test="@href">
                <a href="{@href}"><xsl:value-of select="."/></a>
            </xsl:if>
        </span>
    </xsl:template>

</xsl:transform>