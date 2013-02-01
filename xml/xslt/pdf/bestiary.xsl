<?xml version="1.0"?>

<!-- These templates are for inline bestiary descriptions -->

<xsl:stylesheet version="1.0"
    xmlns:yb="http://yagsbook.sourceforge.net/xml"
    xmlns:y="http://yagsbook.sourceforge.net/xml/yags"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format">

    <xsl:include href="yags/bestiary.xsl"/>

    <!--
      - Import all the animals from the named files.
      - Parents are listed in alphabetical order, with child entries immediately
      - following them.
      -->
    <xsl:template match="yb:import-beasts">
        <xsl:variable name="importance" select="@importance"/>

        <xsl:variable name="beasts" select="document(yb:href)/yb:bestiary"/>
        <xsl:apply-templates select="$beasts" mode="parent"/>
    </xsl:template>

    <xsl:template match="yb:beast/y:statistics/y:attributes[@size]">
        <xsl:variable name="size" select="@size"/>
        <xsl:choose>
            <xsl:when test="not(number(@size))"></xsl:when>
            <xsl:when test="@size &lt; 1">Tiny </xsl:when>
            <xsl:when test="@size &lt; 4">Small </xsl:when>
            <xsl:when test="@size &lt; 7">Medium </xsl:when>
            <xsl:when test="@size &lt; 10">Large </xsl:when>
            <xsl:when test="@size &lt; 12">Huge </xsl:when>
            <xsl:when test="@size &lt; 15">Enormous </xsl:when>
            <xsl:when test="@size &lt; 20">Gigantic </xsl:when>
            <xsl:when test="@size &lt; 25">Colossal </xsl:when>
            <xsl:otherwise>Titanic </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="yb:beast/yb:information" mode="inline">
        <fo:block font-size="{$font-small}" text-align="left">
            <xsl:if test="yb:type">
                <fo:block>
                    <fo:inline font-weight="bold">Type: </fo:inline>
                    <xsl:apply-templates select="../y:statistics/y:attributes"/>
                    <xsl:value-of select="yb:type"/>
                </fo:block>
            </xsl:if>
            <xsl:text> </xsl:text>

            <xsl:if test="yb:demeanor">
                <fo:block>
                    <fo:inline font-weight="bold">Demeanor: </fo:inline>
                    <xsl:value-of select="yb:demeanor"/>
                </fo:block>
            </xsl:if>
            <xsl:text> </xsl:text>

            <xsl:if test="yb:origin">
                <fo:block>
                    <fo:inline font-weight="bold">Origin: </fo:inline>
                    <xsl:value-of select="yb:origin"/>
                </fo:block>
            </xsl:if>
            <xsl:text> </xsl:text>

            <xsl:if test="yb:genre">
                <fo:block>
                    <fo:inline font-weight="bold">Genre: </fo:inline>
                    <xsl:value-of select="yb:genre"/>
                </fo:block>
            </xsl:if>
            <xsl:text> </xsl:text>
        </fo:block>

        <xsl:if test="yb:habitat">
            <fo:block font-size="{$font-small}" text-align="left">
                <fo:block font-weight="bold">Habitats: </fo:block>
                <xsl:for-each select="yb:habitat">
                    <fo:block>
                        <xsl:value-of select="@climate"/><xsl:text>/</xsl:text><xsl:value-of select="@terrain"/>
                        (<xsl:value-of select="@frequency"/>)
                    </fo:block>
                </xsl:for-each>
            </fo:block>
        </xsl:if>
        <xsl:if test="yb:organisation">
            <fo:block font-size="{$font-small}" text-align="left">
                <fo:block font-weight="bold">Organisation: </fo:block>
                <xsl:for-each select="yb:organisation">
                    <fo:block>
                        <xsl:value-of select="@group"/>
                        (<xsl:value-of select="@number"/>)
                    </fo:block>
                </xsl:for-each>
            </fo:block>
        </xsl:if>
    </xsl:template>

    <xsl:template match="yb:beast/yb:description" mode="inline">

        <xsl:if test="yb:physical">
            <fo:block space-before="{$font-small}">
                <xsl:apply-templates select="yb:physical"/>
            </fo:block>
        </xsl:if>

        <xsl:if test="yb:social">
            <fo:block font-weight="bold" font-size="{$font-medium}" font-style="italic">
                Social
            </fo:block>
            <xsl:apply-templates select="yb:social"/>
        </xsl:if>

        <xsl:if test="yb:tactics">
            <fo:block font-weight="bold" font-size="{$font-medium}" font-style="italic">
                Tactics
            </fo:block>
            <xsl:apply-templates select="yb:tactics"/>
        </xsl:if>

        <xsl:if test="yb:training">
            <fo:block font-weight="bold" font-size="{$font-medium}" font-style="italic">
                Training
            </fo:block>
            <xsl:apply-templates select="yb:training"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="yb:beast" mode="description">
        <xsl:choose>
            <xsl:when test="yb:description/yb:image">
                <fo:table table-layout="fixed" width="100%">
                    <fo:table-column column-width="50mm"/>
                    <fo:table-column column-width="30mm"/>

                    <fo:table-body>
                        <fo:table-cell>
                            <xsl:apply-templates select="yb:information" mode="inline"/>
                        </fo:table-cell>
                        <fo:table-cell>
                            <fo:block>
                                <fo:external-graphic src="{yb:description/yb:image/@src}" content-width="28mm"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-body>
                </fo:table>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="yb:information" mode="inline"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="yb:description" mode="inline"/>

    </xsl:template>
    <!--
      - Display a parent beast inline in two column format.
      -->
    <xsl:template match="yb:beast[not(@parent)]" mode="parent">
        <xsl:variable name="name" select="@name"/>

        <fo:block border-bottom-width="3px" border-bottom-style="solid" border-bottom-color="black" space-after="3px">
            <fo:block font-weight="bold" font-size="{$font-xx-large}">
                <xsl:value-of select="$name"/>
            </fo:block>
        </fo:block>
        <xsl:if test="yb:description/yb:short">
        <fo:block font-size="{$font-medium}" font-style="italic" space-after="{$font-medium}">
                <xsl:value-of select="yb:description/yb:short"/>
            </fo:block>
        </xsl:if>

        <xsl:apply-templates select="." mode="description"/>

        <!-- YAGS specific statistics -->
        <xsl:apply-templates select="y:statistics" mode="inline"/>

        <!-- Append all the children -->
        <xsl:apply-templates select="../yb:beast[@parent=$name]" mode="child"/>
    </xsl:template>

    <xsl:template match="yb:beast" mode="child">
        <xsl:variable name="name" select="@name"/>

        <fo:block font-weight="bold" font-style="italic" font-size="{$font-x-large}">
            <xsl:value-of select="$name"/>
        </fo:block>
        <xsl:if test="yb:description/yb:short">
        <fo:block font-size="{$font-medium}" font-style="italic" space-after="{$font-medium}">
                <xsl:value-of select="yb:description/yb:short"/>
            </fo:block>
        </xsl:if>

        <xsl:apply-templates select="." mode="description"/>

        <!-- YAGS specific statistics -->
        <xsl:apply-templates select="y:statistics" mode="inline"/>
    </xsl:template>

    <!-- Import one or more beastiary entries into the document -->
    <xsl:template match="yb:import-beast">
        <xsl:variable name="href" select="@href"/>

        <xsl:choose>
            <xsl:when test="@name">
                <xsl:variable name="name" select="@name"/>
                <xsl:apply-templates select="document($href)//yb:beast[@name=$name]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="document($href)//yb:beast"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="/yb:bestiary/yb:beast" mode="fullpage">
        <fo:table table-layout="fixed">
            <fo:table-column column-width="30mm"/>
            <fo:table-column column-width="50mm"/>

            <fo:table-column column-width="30mm"/>
            <fo:table-column column-width="50mm"/>

            <fo:table-body font-size="{$font-large}" font-family="Helvetica">
                <fo:table-row>
                    <fo:table-cell><fo:block font-weight="bold">Type</fo:block></fo:table-cell>
                    <fo:table-cell>
                        <fo:block>
                            <xsl:value-of select="information/type"/>
                        </fo:block>
                    </fo:table-cell>

                    <fo:table-cell><fo:block font-weight="bold">Origin/Genre</fo:block></fo:table-cell>
                    <fo:table-cell>
                        <fo:block>
                            <xsl:value-of select="information/origin"/>/<xsl:value-of select="information/genre"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <fo:table-row>
                    <fo:table-cell><fo:block font-weight="bold">Demeanor</fo:block></fo:table-cell>
                    <fo:table-cell>
                        <fo:block>
                            <xsl:value-of select="information/demeanor"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>

        <xsl:apply-templates select="attributes" mode="fullpage"/>
        <xsl:apply-templates select="combat" mode="fullpage"/>
        <xsl:apply-templates select="advantages" mode="fullpage"/>
    </xsl:template>



</xsl:stylesheet>

