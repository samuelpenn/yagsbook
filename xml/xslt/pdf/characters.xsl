<?xml version="1.0"?>

<!--
    Stylesheet transform for Yagsbook to PDF.

    These templates are for inline character descriptions, and
    character templates. In theory, they should also work for
    character sheets, where there is a single character description
    across two pages. Currently, this latter format isn't yet
    fully supported.

    Author:  Samuel Penn
    Version: $Revision: 1.15 $
    Date:    $Date: 2007/09/09 10:32:55 $
-->


<xsl:stylesheet version="1.0"
    xmlns:yb="http://yagsbook.sourceforge.net/xml"
    xmlns:yags="http://yagsbook.sourceforge.net/xml/yags"
    xmlns:ars="http://yagsbook.sourceforge.net/xml/arsmagica"
    xmlns:d20="http://yagsbook.sourceforge.net/xml/d20"
    xmlns:gurps="http://yagsbook.sourceforge.net/xml/gurps"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format">

    <!-- Import templates for Yags specific rules -->
    <xsl:include href="yags/characters.xsl"/>

    <!--
        import-characters

        Generic character import element. Imports a set of characters from
        either a file or an encyclopedia. Possible formats are:

        Import all characters from the given file:
        <import-characters href="filename"/>

        Import matching characters from the given file:
        <import-characters href="filename" name="name"/>
    -->
    <xsl:template match="yb:import-characters">
        <xsl:choose>
            <xsl:when test="@source">
                <!-- Import characters from an Encyclopedia -->
                <xsl:apply-templates select="." mode="encyclopedia"/>
            </xsl:when>

            <xsl:when test="@href">
                <xsl:apply-templates select="." mode="file"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>


    <!--
        Import a set of character packages from an encyclopedia.
        Searches the entire encyclopedia for any packages matching the
        given topic.

        @source     Should be set to the root of the encyclopedia.
        @topic      Should be set to the topic to filter on.
        @display    Should be set to 'package', 'stock' or 'character'.

        An index of the encyclopedia is expected to be at <source>/index.xml
     -->
     <xsl:template match="yb:import-characters" mode="encyclopedia">
        <xsl:variable name="base" select="@source"/>
        <xsl:variable name="topic" select="@topic"/>
        <xsl:variable name="display" select="@display"/>

        <xsl:variable name="index" select="concat($base, '/index.xml')"/>

        <xsl:for-each select="document($index)/yb:index/yb:article">
            <xsl:variable name="file" select="."/>
            <xsl:variable name="path" select="concat($base, '/', $file)"/>


            <xsl:if test="document($path)/yb:article/yb:header/yb:topics/yb:topic/@uri=$topic">
                <!--
                <fo:block
                    font-size="{$font-large}"
                    font-family="{$font-family}"
                    line-height="{$font-large}"
                    font-weight="bold"
                    font-style="normal">

                    <xsl:value-of
                        select="document($path)/yb:article/yb:body//yb:characters[@role=$display]/@title"/>
                </fo:block>
-->
                <xsl:apply-templates
                    select="document($path)/yb:article/yb:body//yb:characters[@role=$display]/yb:character">
                    <xsl:sort select="@name" data-type="text"/>
                </xsl:apply-templates>
            </xsl:if>
        </xsl:for-each>

    </xsl:template>


    <!--
        import-characters

        Display a character stored in an external file.
    -->
    <xsl:template match="yb:import-characters" mode="file">
        <xsl:variable name="href" select="@href"/>
        <xsl:variable name="name" select="@name"/>
        <xsl:variable name="display" select="@display"/>

        <xsl:choose>
            <xsl:when test="@name">
                <xsl:apply-templates select="document($href)//yb:character[@name=$name]">
                    <xsl:sort select="@name" data-type="text"/>
                    <xsl:sort select="@quality" data-type="number"/>
                </xsl:apply-templates>
            </xsl:when>

            <xsl:otherwise>
                <xsl:apply-templates select="document($href)//yb:character">
                    <xsl:sort select="@name" data-type="text"/>
                    <xsl:sort select="@quality" data-type="number"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
        character

        Display an inline character description. The amount of detail
        available determines what is displayed, and also the type of
        formatting to use.

        If the character has a @quality attribute, it is assumed to be a
        stock character.

        If the character has no statistics/attributes element, then it
        is assumed to be a package.

        Display modes (denoted by the @display attribute) are:
            brief - Name, race etc and a short description.
            long - As brief, plus full textual description.
            combat - As brief, plus skills and combat stats.
            full - As combat, plus full textual description.
    -->

    <xsl:template match="yb:character">
        <xsl:choose>
            <xsl:when test="@display='brief'">
                <xsl:apply-templates select="." mode="brief"/>
            </xsl:when>
            <xsl:when test="@display='long'">
                <xsl:apply-templates select="." mode="long"/>
            </xsl:when>
            <xsl:when test="@display='stats'">
                <xsl:apply-templates select="." mode="stats"/>
            </xsl:when>
            <xsl:when test="@display='full'">
                <xsl:apply-templates select="." mode="full"/>
            </xsl:when>
            <xsl:otherwise>
                 <xsl:apply-templates select="." mode="full"/>
           </xsl:otherwise>
        </xsl:choose>
    </xsl:template>



  <!--
        Display brief information about the character. No game stats
        are given, just the shortest useful summary of the person.
    -->
  <xsl:template match="yb:character" mode="brief">
        <fo:block
            border-color="green"
            border-style="dashed"
            padding="5pt"
            space-after="12pt">

            <fo:block font-weight="bold" font-size="12pt">
                <xsl:apply-templates select="." mode="title"/>
            </fo:block>

            <xsl:apply-templates select="yb:description"/>
        </fo:block>
    </xsl:template>

    <!--
        Display short information about the character. Game stats
        are included, but full background and description are
        omitted.
    -->
    <xsl:template match="yb:character" mode="stats">
        <fo:block
            border-color="green"
            border-style="solid"
            padding="5pt"
            space-after="12pt">

            <fo:block font-weight="bold" font-size="12pt">
                <xsl:apply-templates select="." mode="title"/>
            </fo:block>

            <xsl:apply-templates select="yb:description"/>

            <xsl:apply-templates select="attributes" mode="inline"/>
            <xsl:apply-templates select="passions" mode="inline"/>
            <xsl:apply-templates select="skills/group" mode="inline"/>
            <xsl:apply-templates select="combat" mode="inline"/>
            <xsl:apply-templates select="attributes" mode="wounds"/>
        </fo:block>
    </xsl:template>



    <!--
        Display short information about the character. Game stats
        are included, but full background and description are
        omitted.
    -->
    <xsl:template match="yb:character" mode="short">
        <fo:block
            border-color="green"
            border-style="solid"
            padding="5pt"
            space-after="12pt">

            <fo:block font-weight="bold" font-size="12pt">
                <xsl:apply-templates select="." mode="title"/>
            </fo:block>

            <xsl:apply-templates select="yb:description"/>

            <xsl:apply-templates select="attributes" mode="inline"/>
            <xsl:apply-templates select="passions" mode="inline"/>
            <xsl:apply-templates select="skills/group" mode="inline"/>
            <xsl:apply-templates select="combat" mode="inline"/>
            <xsl:apply-templates select="attributes" mode="wounds"/>
        </fo:block>
    </xsl:template>



    <xsl:template match="yb:character" mode="full">
        <fo:block
	    keep-together.within-column="always"
            border-color="green"
            border-style="solid"
            padding="5pt"
            space-after="{$font-medium}">

            <xsl:apply-templates select="." mode="title"/>

            <xsl:apply-templates select="yb:description"/>

            <xsl:apply-templates select="." mode="statistics"/>

            <xsl:apply-templates select="attributes" mode="inline"/>
            <xsl:apply-templates select="passions" mode="inline"/>
            <xsl:apply-templates select="skills/group" mode="inline"/>
            <xsl:if test="combat">
                <xsl:apply-templates select="combat" mode="inline"/>
                <xsl:apply-templates select="attributes" mode="wounds"/>
            </xsl:if>

            <xsl:if test="yb:description/yb:physical">
                <fo:block font-size="{$font-small}" font-family="{$font-body}" space-before="3pt">
                    <fo:inline font-weight="bold">Description: </fo:inline>
                    <xsl:apply-templates select="yb:description/yb:physical"/>
                </fo:block>
            </xsl:if>

            <xsl:if test="yb:description/yb:background">
                <fo:block font-size="{$font-small}" font-family="{$font-body}" space-before="3pt">
                    <fo:inline font-weight="bold">Background: </fo:inline>
                    <xsl:apply-templates select="yb:description/yb:background" mode="small"/>
                </fo:block>
            </xsl:if>

            <xsl:apply-templates select="yb:equipment"/>
        </fo:block>
    </xsl:template>

    <xsl:template match="yb:character" mode="statistics">
        <xsl:variable name="number"
                      select="count(*)-count(yb:description)-count(yb:equipment)"/>

        <xsl:choose>
            <xsl:when test="$number = 1">
                <!-- Only one set of game rules here. -->
                <xsl:apply-templates select="yags:statistics"/>
                <xsl:apply-templates select="ars:statistics"/>
                <xsl:apply-templates select="d20:statistics"/>
            </xsl:when>

            <xsl:otherwise>
                <!-- More than one set of rules. -->

                <fo:block>
                    <xsl:if test="yags:statistics">
                        <fo:block>Yags</fo:block>
                        <xsl:apply-templates select="yags:statistics"/>
                    </xsl:if>
                    <xsl:if test="d20:statistics">
                        <fo:block>d20</fo:block>>
                        <xsl:apply-templates select="d20:statistics"/>
                    </xsl:if>
                    <xsl:if test="ars:statistics">
                        <fo:block>Ars Magica</fo:block>
                        <xsl:apply-templates select="ars:statistics"/>
                    </xsl:if>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
        Display a title for this character block.
        The title is based on the name of the character, and if this is a
        stock character, then the quality as well. Both stock characters
        and packages also include point values, if available.
    -->
    <xsl:template match="yb:character" mode="title">
        <xsl:variable name="quality">
            <xsl:choose>
                <xsl:when test="@quality='1'">*</xsl:when>
                <xsl:when test="@quality='3'">***</xsl:when>
                <xsl:when test="@quality='4'">****</xsl:when>
                <xsl:when test="@quality='5'">*****</xsl:when>
                <xsl:otherwise>**</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="points">
            <xsl:choose>
                <xsl:when test="@cost"><xsl:value-of select="@cost"/></xsl:when>
                <xsl:when test="../@showPoints='true' or @showPoints='true'">
                    <xsl:call-template name="yags:statistics-sum"/>
                </xsl:when>
                <xsl:when test="$detailPoints='false'">0</xsl:when>
                <xsl:when test="@quality">
                    <xsl:call-template name="yags:statistics-sum"/>
                </xsl:when>
                <xsl:when test="not(yags:statistics/yags:attributes)">
                    <xsl:call-template name="yags:statistics-sum"/>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <fo:block font-weight="bold" font-size="{$font-medium}">
            <xsl:value-of select="@name"/>
            <xsl:choose>
                <xsl:when test="@quality and $points &gt; 0">
                    (<xsl:value-of select="$quality"/>/<xsl:value-of select="$points"/> points)
                </xsl:when>
                <xsl:when test="@quality">
                    (<xsl:value-of select="$quality"/>)
                </xsl:when>
                <xsl:when test="$points &gt; 0">
                    (<xsl:value-of select="$points"/> points)
                </xsl:when>
            </xsl:choose>
        </fo:block>
    </xsl:template>




    <!-- Short character description -->
    <xsl:template match="yb:character/yb:description">
        <fo:block font-size="{$font-small}" font-family="{$font-body}">
            <xsl:if test="yb:race">
                <xsl:value-of select="yb:gender"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="yb:race"/>,
            </xsl:if>
            <xsl:if test="not(yb:race) and yb:gender">
                <xsl:value-of select="yb:gender"/>,
            </xsl:if>
            <xsl:if test="yb:age">
                Age <xsl:value-of select="yb:age"/>
            </xsl:if>
        </fo:block>

        <fo:block font-size="{$font-small}" font-style="italic" font-family="{$font-body}">
            <xsl:value-of select="yb:short"/>
        </fo:block>
    </xsl:template>

    <xsl:template match="yb:character/yb:equipment">
        <fo:block font-size="10pt" font-family="{$font-body}" font-weight="bold">
            Equipment:
        </fo:block>

        <xsl:if test="yb:cash">
            <fo:block font-size="{$font-medium}" font-family="{$font-body}">
                Cash: <xsl:value-of select="yb:cash/@value"/>
            </fo:block>
        </xsl:if>

        <fo:block font-size="{$font-medium}" font-family="{$font-body}">
            <xsl:apply-templates select="yb:item"/>
        </fo:block>
    </xsl:template>

    <xsl:template match="yb:character/yb:equipment/yb:item">
        <xsl:if test="position() &gt; 1">
            <xsl:text>, </xsl:text>
        </xsl:if>

        <xsl:value-of select="@name"/>

        <xsl:if test="position() = last()">
            <xsl:text>.</xsl:text>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>

