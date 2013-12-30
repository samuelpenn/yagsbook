<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format">

    <xsl:template match="library">
        <xsl:for-each select="book">
            <fo:block font-weight="bold" font-size="12pt" space-after="0pt">
                <xsl:value-of select="@name"/>
            </fo:block>

            <fo:block font-style="italic" space-after="0pt">
                <xsl:if test="author">
                    by <xsl:value-of select="author"/>,
                </xsl:if>

                <xsl:choose>
                    <xsl:when test="@type='grimoire'">
                        <xsl:text> Grimoire level </xsl:text>
                        <xsl:value-of select="level"/> at quality
                        <xsl:value-of select="quality"/>
                        <fo:block>
                            <xsl:for-each select="skill">
                                <xsl:if test="position() &gt; 1">
                                    <xsl:text>, </xsl:text>
                                </xsl:if>
                                <xsl:value-of select="."/>
                            </xsl:for-each>
                        </fo:block>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:value-of select="skill"/><xsl:text> </xsl:text>
                        <xsl:value-of select="level"/> at quality
                        <xsl:value-of select="quality"/>
                    </xsl:otherwise>
                </xsl:choose>
            </fo:block>

            <fo:block space-after="12pt">
                <xsl:value-of select="description"/>
            </fo:block>

        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>

