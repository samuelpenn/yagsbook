<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format">


    <xsl:template match="import-invocations">
        <xsl:variable name="rel" select="@religion"/>
        <xsl:apply-templates select="document(@href)//invocation[@religion=$rel]">
            <xsl:sort select="@rank" data-type="number"/>
            <xsl:sort select="name" data-type="text"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="invocation">
        <fo:block
                font-weight="bold"
                font-style="italic"
                color="{$colour}"
                font-size="10pt"
                font-family="sans-serif"
                line-height="12pt"
                space-after="0pt"
                text-align="start">

            <xsl:value-of select="name"/>
        </fo:block>

        <fo:table background-color="{$lightcolour}">
            <fo:table-column column-width="4cm"/>
            <fo:table-column column-width="4.5cm"/>

            <fo:table-body font-size="10pt" font-family="{$font-body}">
                <fo:table-row>
                    <fo:table-cell>
                        <fo:block font-family="{$font-body}">
                            <fo:inline font-weight="bold">Time:</fo:inline>
                            <xsl:value-of select="time"/>
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
                            <fo:inline font-weight="bold">Difficulty: </fo:inline>
                            <xsl:value-of select="difficulty"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block font-family="{$font-body}">
                            <fo:inline font-weight="bold">Cost: </fo:inline>
                            <xsl:value-of select="cost"/>
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

                <xsl:for-each select="boost">
                    <xsl:sort select="@difficulty" data-type="number"/>
                    <fo:table-row>
                        <fo:table-cell number-columns-spanned="2">
                            <fo:block font-family="{$font-body}">
                                <fo:inline font-weight="bold">
                                    Boost (<xsl:value-of select="@difficulty"/>
                                    <xsl:if test="@cost">
                                        /<xsl:value-of select="@cost"/>
                                    </xsl:if>
                                    <xsl:text>): </xsl:text>
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
            space-after="12pt">

            <xsl:apply-templates select="description"/>
        </fo:block>


    </xsl:template>


</xsl:stylesheet>

