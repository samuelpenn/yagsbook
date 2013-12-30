<?xml version="1.0"?>

<!--
    Stylesheet transform for Yagsbook to PDF.

    These templates are for inline character descriptions, and
    character templates. In theory, they should also work for
    character sheets, where there is a single character description
    across two pages. Currently, this latter format isn't yet
    fully supported.

    Author:  Samuel Penn
    Version: $Revision: 1.4 $
    Date:    $Date: 2007/03/25 19:32:46 $
-->


<xsl:stylesheet version="1.0"
    xmlns:yb="http://yagsbook.sourceforge.net/xml"
    xmlns:yags="http://yagsbook.sourceforge.net/xml/yags"
    xmlns:ars="http://yagsbook.sourceforge.net/xml/arsmagica"
    xmlns:d20="http://yagsbook.sourceforge.net/xml/d20"
    xmlns:gurps="http://yagsbook.sourceforge.net/xml/gurps"
    xmlns:ds="http://yagsbook.sourceforge.net/xml/dirtside"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format">

    <!-- Import templates for Yags specific rules
    <xsl:include href="yags/vehicles.xsl"/>
    -->

    <xsl:template match="yb:import-vehicles">
        <xsl:variable name="href" select="@href"/>

        <xsl:apply-templates select="document($href)/yb:equipment/yb:item[yb:category='Vehicle']">
            <xsl:sort select="@name" data-type="text"/>
        </xsl:apply-templates>
    </xsl:template>


    <!--
        An inline vehicle description.

    <xsl:template match="yb:item[yb:category='Vehicle']">
        <fo:block
            border-color="black"
            border-style="solid"
            space-after="{$font-medium}">

            <fo:block color="white" background-color="black">
                <xsl:value-of select="@name"/>
            </fo:block>

            <fo:block start-indent="2pt" space-before="2pt" font-size="{$font-medium}">
                <xsl:if test="yb:short">
                    <fo:block  font-style="italic">
                        <xsl:value-of select="yb:short"/>
                    </fo:block>
                </xsl:if>

                <fo:block>
                    <fo:inline font-weight="bold">Production:</fo:inline>
                    <xsl:value-of select="yb:year"/>;

                    <fo:inline font-weight="bold">TL:</fo:inline>
                    <xsl:value-of select="yb:techLevel"/>;

                    <fo:inline font-weight="bold">Cost:</fo:inline>
                    <xsl:value-of select="yb:cost"/>;
                </fo:block>
            </fo:block>

            <xsl:apply-templates select="yags:vehicle"/>

            <xsl:apply-templates select="attributes" mode="inline"/>

            <xsl:if test="yb:description">
                <fo:block font-size="{$font-small}" font-family="{$font-body}" space-before="3pt">
                    <fo:inline font-weight="bold">Description: </fo:inline>
                    <xsl:apply-templates select="yb:description"/>
                </fo:block>
            </xsl:if>

        </fo:block>
    </xsl:template>
    -->

</xsl:stylesheet>

