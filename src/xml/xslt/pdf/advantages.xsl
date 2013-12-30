<?xml version="1.0"?>
<!--
    Stylesheet transform for Yagsbook to PDF.

    Handles all advantage/disadvantage styles.

    Author:  Samuel Penn
    Version: $Revision: 1.7 $
    Date:    $Date: 2007/02/24 23:22:04 $
-->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format">


    <!-- Import advantages from external document -->
    <xsl:template match="import-advantages">
        <xsl:variable name="href" select="@href"/>

        <xsl:choose>
            <xsl:when test="@source">
                <xsl:variable name="source" select="@source"/>
                <xsl:variable name="topic" select="@topic"/>
                <xsl:variable name="role" select="@role"/>

                <xsl:variable name="index"
                              select="concat($source, '/index.xml')"/>

                <xsl:for-each select="document($index)/index/article">
                    <xsl:variable name="file" select="."/>
                    <xsl:variable name="path"
                                  select="concat($source, '/', $file)"/>

                    <xsl:if test="document($path)/article/header/topics/topic/@uri=$topic">
                        <xsl:if test="document($path)/article/body//advantages[@role=$role]/advantage">
                            <fo:block
                                font-size="{$font-large}"
                                font-family="{$font-family}"
                                line-height="{$font-large}"
                                font-weight="bold"
                                font-style="normal">

                                <xsl:value-of select="document($path)/article/header/title"/>
                            </fo:block>
                            <xsl:apply-templates
                                select="document($path)/article/body//advantages[@role=$role]/advantage">
                                <xsl:sort select="@name" data-type="text"/>
                            </xsl:apply-templates>
                        </xsl:if>
                    </xsl:if>

                </xsl:for-each>
            </xsl:when>

            <xsl:when test="@type">
                <xsl:variable name="type" select="@type"/>
                <xsl:apply-templates select="document($href)//advantage[@type=$type]">
                    <xsl:sort select="@name" data-type="text"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="document($href)//advantage">
                    <xsl:sort select="@name" data-type="text"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="advantage">
        <xsl:choose>
            <xsl:when test="@type='edge'">
                <xsl:apply-templates select="." mode="basic"/>
            </xsl:when>
            <xsl:when test="@type='flaw'">
                <xsl:apply-templates select="." mode="basic"/>
            </xsl:when>
            <xsl:when test="@type='advantage'">
                <xsl:apply-templates select="." mode="basic"/>
            </xsl:when>
            <xsl:when test="@type='technique'">
                <xsl:apply-templates select="." mode="technique"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="basic"/>
            </xsl:otherwise>
       </xsl:choose>
    </xsl:template>

    <!--
        Advantage

        Standard advantage template. The advantage has a name and a cost,
        followed by one or more paragraph blocks of description.
     -->
    <xsl:template match="advantage" mode="basic">
        <fo:block
            font-size="{$font-medium}"
            font-family="{$font-family}"
            line-height="{$font-large}"
            font-style="normal">

            <xsl:choose>
                <!-- Cost per level -->
                <xsl:when test="cost/@levels">
                    <fo:inline font-weight="bold"><xsl:value-of select="@name"/>
                        (<xsl:value-of select="cost/@points"/>/<xsl:value-of
                         select="cost/@levels"/> levels):
                    </fo:inline>
                </xsl:when>

                <!-- Fixed/multiple cost advantages -->
                <xsl:otherwise>
                    <fo:inline font-weight="bold"><xsl:value-of select="@name"/>
                        (<xsl:for-each select="cost/@points">
                            <xsl:if test="position()=last()">
                                <xsl:value-of select="."/>
                            </xsl:if>
                            <xsl:if test="not(position()=last())">
                                <xsl:value-of select="."/>,
                            </xsl:if>
                        </xsl:for-each>):
                    </fo:inline>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:apply-templates select="description"/>

        </fo:block>
    </xsl:template>

    <xsl:template match="advantage/description" mode="advantage">
        <xsl:apply-templates/>
    </xsl:template>


    <xsl:template match="advantage" mode="technique">
        <fo:block
            font-size="{$font-medium}"
            font-family="{$font-family}"
            line-height="{$font-large}"
            font-style="normal"
            space-after="0pt">

            <fo:inline font-weight="bold">
                <xsl:value-of select="@name"/>
                (Cost <xsl:value-of select="cost/@points"/>):
            </fo:inline>

            <xsl:apply-templates select="skill"/>
        </fo:block>

        <xsl:if test="prerequisite">
            <fo:block
                font-size="{$font-medium}"
                font-family="{$font-family}"
                line-height="{$font-large}"
                font-style="italic"
                space-after="0pt">

                Prerequisites:
                <xsl:apply-templates select="prerequisite"/>
            </fo:block>
        </xsl:if>
        <xsl:apply-templates select="description"/>
    </xsl:template>

    <xsl:template match="advantage/skill">
        <xsl:if test="position() &lt; last()">
            <fo:inline font-style="italic">
                <xsl:value-of select="@name"/>,
            </fo:inline>
        </xsl:if>
        <xsl:if test="position() = last()">
            <fo:inline font-style="italic">
                <xsl:value-of select="@name"/>.
            </fo:inline>
        </xsl:if>
    </xsl:template>

    <xsl:template match="advantage/prerequisite">
        <xsl:if test="position() &lt; last()">
            <xsl:value-of select="."/>,
        </xsl:if>
        <xsl:if test="position() = last()">
            <xsl:value-of select="."/>.
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
