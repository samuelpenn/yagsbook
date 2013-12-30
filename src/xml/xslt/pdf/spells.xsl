<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format">


    <xsl:template match="//import-spells">
        <xsl:variable name="conv" select="@convocation"/>

	<xsl:apply-templates select="document(@href)//preface"/>

        <xsl:apply-templates select="document(@href)//spell[@convocation=$conv]">
            <xsl:sort select="@level" data-type="number"/>
            <xsl:sort select="@name" data-type="text"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="spell">
        <fo:block
                font-weight="bold"
                font-style="italic"
                color="{$colour}"
                font-size="10pt"
                font-family="{$font-heading}"
                line-height="12pt"
                space-after="0pt"
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
            <fo:table-column column-width="4.2cm"/>

            <fo:table-body font-size="10pt" font-family="{$font-body}">
                <fo:table-row>
                    <fo:table-cell>
                        <fo:block font-family="{$font-body}">
                            <fo:inline font-weight="bold">Time:</fo:inline>
                            <xsl:if test="time">
                                <xsl:value-of select="time"/>
                            </xsl:if>
                            <xsl:if test="not(time)">
                                1 round
                            </xsl:if>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block font-family="{$font-body}">
                            <fo:inline font-weight="bold">Range: </fo:inline>
                            <xsl:value-of select="range"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <fo:table-row>
                    <fo:table-cell>
                        <fo:block font-family="{$font-body}">
                            <fo:inline font-weight="bold">Duration: </fo:inline>
                            <xsl:value-of select="duration"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block font-family="{$font-body}">
                            <fo:inline font-weight="bold">Resist: </fo:inline>
                            <xsl:value-of select="resist"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <xsl:if test="area">
                    <fo:table-row>
                        <fo:table-cell>
                            <fo:block font-family="{$font-body}">
                                <fo:inline font-weight="bold">Area: </fo:inline>
                                <xsl:value-of select="area"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </xsl:if>
                <xsl:for-each select="boost">
                    <fo:table-row>
                        <fo:table-cell number-columns-spanned="2">
                            <fo:block font-family="{$font-body}">
                                <fo:inline font-weight="bold">
                                    Boost:
                                </fo:inline>
                                <xsl:value-of select="."/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </xsl:for-each>

            </fo:table-body>
        </fo:table>

         <fo:block
            font-size="10pt"
            font-family="{$font-body}"
            line-height="12pt"
            space-after="0pt">

            <xsl:apply-templates select="description"/>
        </fo:block>


    </xsl:template>

</xsl:stylesheet>

