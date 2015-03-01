<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
    xmlns:yb="http://yagsbook.sourceforge.net/xml"
    xmlns:y="http://yagsbook.sourceforge.net/xml/yags"
    xmlns:h="http://yagsbook.sourceforge.net/xml/yags/habisfern"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format">


    <xsl:template match="//h:import-spells">
        <xsl:apply-templates select="document(@href)/h:grimoire/yb:description"/>

        <xsl:choose>
            <xsl:when test="@type">
                <xsl:variable name="type" select="@type"/>
                <xsl:apply-templates select="document(@href)/h:grimoire/h:spell[@type=$type]">
                    <xsl:sort select="@level" data-type="number"/>
                    <xsl:sort select="@name" data-type="text"/>
                </xsl:apply-templates>
            </xsl:when>

            <xsl:otherwise>
                <xsl:apply-templates select="document(@href)/h:grimoire/h:spell">
                    <xsl:sort select="@level" data-type="number"/>
                    <xsl:sort select="@name" data-type="text"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="h:spell">
        <fo:block
                font-weight="bold"
                font-style="italic"
                color="{$colour}"
                font-size="10pt"
                font-family="sans-serif"
                line-height="12pt"
                space-after.optimum="0pt"
                text-align="start">

            <xsl:value-of select="@name"/>,
            <xsl:if test="@level='0'">
                Multi-level
            </xsl:if>
            <xsl:if test="@level &gt; 0">
                Level <xsl:value-of select="@level"/>
            </xsl:if>
        </fo:block>

        <fo:table background-color="{$lightcolour}" table-layout="fixed">
            <fo:table-column column-width="4cm"/>
            <fo:table-column column-width="4cm"/>

            <fo:table-body font-size="10pt" font-family="Times">
                <fo:table-row>
                    <fo:table-cell>
                        <fo:block font-family="Times">
                            <fo:inline font-weight="bold">Time: </fo:inline>
                            <xsl:if test="h:time">
                                <xsl:value-of select="h:time"/>
                            </xsl:if>
                            <xsl:if test="not(h:time)">
                                1 round
                            </xsl:if>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block font-family="Times">
                            <fo:inline font-weight="bold">Range: </fo:inline>
                            <xsl:value-of select="h:range"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <fo:table-row>
                    <fo:table-cell>
                        <fo:block font-family="Times">
                            <fo:inline font-weight="bold">Duration: </fo:inline>
                            <xsl:value-of select="h:duration"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block font-family="Times">
                            <fo:inline font-weight="bold">Resist: </fo:inline>
                            <xsl:value-of select="h:resist"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <xsl:if test="h:area">
                    <fo:table-row>
                        <fo:table-cell>
                            <fo:block font-family="Times">
                                <fo:inline font-weight="bold">Area: </fo:inline>
                                <xsl:value-of select="h:area"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </xsl:if>

                <xsl:if test="h:radius">
                    <fo:table-row>
                        <fo:table-cell>
                            <fo:block font-family="Times">
                                <fo:inline font-weight="bold">Radius: </fo:inline>
                                <xsl:value-of select="h:radius"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </xsl:if>

                <xsl:if test="h:prerequisite">
                    <fo:table-row>
                        <fo:table-cell>
                            <fo:block font-family="Times">
                                <fo:inline font-weight="bold">Prerequisites: </fo:inline>
                                <xsl:value-of select="h:prerequisite"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </xsl:if>

            </fo:table-body>
        </fo:table>

        <fo:block
            font-size="10pt"
            font-family="Times"
            line-height="12pt"
            space-after.optimum="0pt">

            <xsl:apply-templates select="yb:description"/>
        </fo:block>


    </xsl:template>

</xsl:stylesheet>

