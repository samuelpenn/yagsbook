<?xml version="1.0"?>

<!--
    Stylesheet transform for Yagsbook to HTML.

    These templates are for inline character descriptions, and
    character templates. In theory, they should also work for
    character sheets, where there is a single character description
    across two pages. Currently, this latter format isn't yet
    fully supported.

    Author:  Samuel Penn
    Version: $Revision: 1.33 $
    Date:    $Date: 2007/09/09 10:32:54 $

    Copyright 2005 Samuel Penn, http://yagsbook.sourceforge.net.
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions
    are met:
    1. Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.
    2. Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.
    3. The name of the author may not be used to endorse or promote products
    derived from this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
    IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
    OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
    IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
    INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
    NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
    DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
    THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
    THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-->

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:yb="http://yagsbook.sourceforge.net/xml"
    xmlns:yags="http://yagsbook.sourceforge.net/xml/yags"
    xmlns:ars="http://yagsbook.sourceforge.net/xml/arsmagica"
    xmlns:d20="http://yagsbook.sourceforge.net/xml/d20"
    xmlns:gurps="http://yagsbook.sourceforge.net/xml/gurps"
    xmlns:war="http://yagsbook.sourceforge.net/xml/warhammer"
    xmlns:five="http://yagsbook.sourceforge.net/xml/fiverings"
    version="1.0">

    <!-- Import templates for game system specific rules -->
    <xsl:include href="yags/characters.xsl"/>
    <xsl:include href="arsmagica/characters.xsl"/>
    <xsl:include href="d20/characters.xsl"/>
    <xsl:include href="warhammer/characters.xsl"/>
    <xsl:include href="fiverings/characters.xsl"/>

    <!--
        A character sheet.
     -->
    <xsl:template match="/yb:characters">
        <xsl:apply-templates select="yb:character" mode="page">
            <xsl:sort select="@name" data-type="text"/>
        </xsl:apply-templates>
    </xsl:template>


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
        <xsl:variable name="href" select="@href"/>
        <xsl:variable name="display" select="@display"/>
        <xsl:variable name="base" select="@source"/>
        <xsl:variable name="topic" select="@topic"/>
        <xsl:variable name="name" select="@name"/>

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

    <!-- Import characters from an Encyclopedia -->
    <xsl:template match="yb:import-characters" mode="encyclopedia">
        <xsl:variable name="display" select="@display"/>
        <xsl:variable name="base" select="@source"/>
        <xsl:variable name="topic" select="@topic"/>

        <xsl:variable name="index" select="concat($base, '/index.xml')"/>

        <xsl:for-each select="document($index)/yb:index/yb:article">
            <xsl:variable name="file" select="."/>
            <xsl:variable name="path" select="concat($base, '/', $file)"/>

            <xsl:if test="document($path)/yb:article/yb:header/yb:topics/yb:topic/@uri=$topic">
                <h4>
                    <xsl:value-of select="document($path)/yb:article/yb:body//yb:characters[@role='package']/@title"/>
                </h4>
                <xsl:apply-templates select="document($path)/yb:article/yb:body//yb:characters[@role=$display]/yb:character">
                    <xsl:sort select="@name" data-type="text"/>
                </xsl:apply-templates>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="yb:import-packages">
        <xsl:variable name="src" select="@source"/>
        <xsl:variable name="topic" select="@topic"/>

        <!-- This is the file which contains an index of all entries -->
        <xsl:variable name="index" select="concat($src, '/index.xml')"/>

        <xsl:variable name="list" select="concat($src, '/', document($index)/yb:index/yb:article)"/>
        <p>
            <xsl:for-each select="$list">
                <xsl:value-of select="."/>
            </xsl:for-each>
        </p>
        <xsl:apply-templates select="document($list)//yb:character"
                             mode="test"/>

    </xsl:template>

    <xsl:template match="yb:character" mode="test">
        <p>
            <xsl:value-of select="@name"/>
        </p>
    </xsl:template>

    <xsl:template match="yb:import-characters" mode="file">
        <xsl:variable name="href" select="@href"/>
        <xsl:variable name="display" select="@display"/>
        <xsl:variable name="name" select="@name"/>

        <xsl:choose>
            <xsl:when test="@name">
                <xsl:apply-templates select="document($href)/yb:characters/yb:character[@name=$name]">
                    <xsl:sort select="@name" data-type="text"/>
                    <xsl:sort select="@quality" data-type="number"/>
                </xsl:apply-templates>
            </xsl:when>

            <xsl:otherwise>
                <xsl:apply-templates select="document($href)/yb:characters/yb:character">
                    <xsl:sort select="@name" data-type="text"/>
                    <xsl:sort select="@quality" data-type="number"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>






    <xsl:template match="yb:character">
        <xsl:choose>
            <xsl:when test="@display='brief'">
                <xsl:apply-templates select="." mode="brief"/>
            </xsl:when>
            <xsl:when test="@display='short'">
                <xsl:apply-templates select="." mode="short"/>
            </xsl:when>
            <xsl:when test="@display='template'">
                <xsl:apply-templates select="." mode="template">
                    <xsl:sort select="@name" data-type="text"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                 <xsl:apply-templates select="." mode="full"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!--
        A very brief character description, with no game stats
        at all, and only a short physical description.
    -->
    <xsl:template match="yb:character" mode="brief">
        <div class="character">
            <xsl:apply-templates select="." mode="title"/>

            <xsl:apply-templates select="yb:description"/>
        </div>
        <br/>
    </xsl:template>


    <!--
        A short character description, missing out the full
        physical description and character background, but
        including all game statistics.
    -->
    <xsl:template match="yb:character" mode="combat">
        <div class="character">
            <xsl:apply-templates select="." mode="title"/>

            <xsl:apply-templates select="yb:description"/>
            <xsl:apply-templates select="." mode="stats"/>
        </div>
        <br/>
    </xsl:template>


    <xsl:template match="yb:character" mode="stats">
        <xsl:variable name="number" select="count(*)-count(yb:description)-count(yb:equipment)"/>

        <xsl:choose>
            <xsl:when test="not($detailCharacters='true')">
                <!-- Suppress display of character details. -->
            </xsl:when>
            <xsl:when test="$number = 0">
                <!-- Nothing to display -->
            </xsl:when>
            <xsl:when test="$number = 1">
                <!-- Only one set of game rules here. -->
                <xsl:if test="$showYags='true'">
                    <xsl:apply-templates select="yags:statistics" mode="full"/>
                </xsl:if>

                <xsl:if test="$showArsMagica='true'">
                    <xsl:apply-templates select="ars:statistics"/>
                </xsl:if>

                <xsl:if test="$showD20='true'">
                    <xsl:apply-templates select="d20:statistics"/>
                </xsl:if>

                <xsl:if test="$showWarhammer='true'">
                    <xsl:apply-templates select="war:statistics"/>
                </xsl:if>

                <xsl:if test="$showFiveRings='true'">
                    <xsl:apply-templates select="five:statistics"/>
                </xsl:if>
            </xsl:when>

            <xsl:otherwise>
                <!-- More than one set of rules. -->
                <xsl:variable name="style">
                    background-color:green;
                    color:white;
                    font-size: x-small;
                    text-align: center;
                </xsl:variable>

                <div style="border: 1pt dashed green">
                    <xsl:if test="yags:statistics and $showYags='true'">
                        <h5 style="{$style}">Yags</h5>
                        <xsl:apply-templates select="yags:statistics" mode="full"/>
                    </xsl:if>
                    <xsl:if test="d20:statistics and $showD20='true'">
                        <h5 style="{$style}">d20</h5>
                        <xsl:apply-templates select="d20:statistics"/>
                    </xsl:if>
                    <xsl:if test="ars:statistics and $showArsMagica='true'">
                        <h5 style="{$style}">Ars Magica</h5>
                        <xsl:apply-templates select="ars:statistics"/>
                    </xsl:if>
                    <xsl:if test="war:statistics and $showWarhammer='true'">
                        <h5 style="{$style}">Warhammer</h5>
                        <xsl:apply-templates select="war:statistics"/>
                    </xsl:if>
                </div>
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
        <h4>
            <xsl:value-of select="@name"/>
            <xsl:choose>
                <xsl:when test="@quality and $points &gt; 0">
                    (<xsl:value-of select="$quality"/>/<xsl:value-of select="$points"/> points)
                </xsl:when>
                <xsl:when test="@quality">
                    (<xsl:value-of select="$quality"/>)
                </xsl:when>
                <xsl:when test="$points = 1">
                    (<xsl:value-of select="$points"/> point)
                </xsl:when>
                <xsl:when test="$points &gt; 0">
                    (<xsl:value-of select="$points"/> points)
                </xsl:when>
                <xsl:when test="@cost">
                    (free)
                </xsl:when>
            </xsl:choose>
        </h4>
    </xsl:template>







    <!--
        A full character description, including all available
        information.
    -->
    <xsl:template match="yb:character" mode="full">
        <div class="character">
            <xsl:apply-templates select="." mode="title"/>

            <xsl:apply-templates select="yb:description"/>

            <xsl:apply-templates select="." mode="stats"/>

            <xsl:if test="yb:description/yb:physical">
                <h5>Description</h5>
                <div class="paragraphs">
                    <xsl:apply-templates select="yb:description/yb:physical"/>
                </div>
            </xsl:if>

            <xsl:if test="yb:description/yb:background">
                <h5>Background</h5>
                <div class="paragraphs">
                    <xsl:apply-templates select="yb:description/yb:background"/>
                </div>
            </xsl:if>

            <xsl:apply-templates select="yb:equipment"/>
        </div>
        <br/>
    </xsl:template>






    <!--
        Basic character description, including gender, race, age
        and a short one line description.
    -->
    <xsl:template match="yb:character/yb:description">
        <p>
            <xsl:if test="yb:race">
                <xsl:value-of select="yb:gender"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="yb:race"/>,
            </xsl:if>
            <xsl:if test="not(yb:race) and yb:gender">
                <xsl:value-of select="yb:gender"/>,
            </xsl:if>

            <xsl:if test="yb:age">
                age <xsl:value-of select="yb:age"/>
            </xsl:if>
        </p>
        <p>
            <i><xsl:value-of select="yb:short"/></i>
        </p>
    </xsl:template>






    <!--
        Display character's wound, stun and fatigue levels.
        Listed in "OK / 0 / -1 / -3 / -6 / -10 / Fatal" style.

    <xsl:template match="attributes" mode="wounds">
        <xsl:if test="number(@size)">
            <p>
                <b>Wounds: </b>
                <xsl:call-template name="output-levels">
                    <xsl:with-param name="size" select="@size"/>
                    <xsl:with-param name="okay">OK</xsl:with-param>
                    <xsl:with-param name="fatal">Fatal</xsl:with-param>
                </xsl:call-template>
            </p>
            <p>
                <b>Stuns: </b>
                <xsl:call-template name="output-levels">
                    <xsl:with-param name="size" select="@size"/>
                    <xsl:with-param name="okay">OK</xsl:with-param>
                    <xsl:with-param name="fatal">Oblivious</xsl:with-param>
                </xsl:call-template>
            </p>
        </xsl:if>
        <xsl:if test="number(attribute[@name='health']/@score)">
            <p>
                <b>Fatigue: </b>
                <xsl:call-template name="output-levels">
                    <xsl:with-param name="size" select="2 + attribute[@name='health']/@score"/>
                    <xsl:with-param name="okay">OK</xsl:with-param>
                    <xsl:with-param name="fatal">Exhausted</xsl:with-param>
                </xsl:call-template>
            </p>
        </xsl:if>
    </xsl:template>
-->







    <xsl:template match="yb:equipment">
        <h5>Equipment</h5>
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="yb:equipment" mode="inline">
        <p><b>Equipment</b></p>
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="yb:equipment/yb:item">
        <xsl:value-of select="@name"/>;
    </xsl:template>

    <xsl:template match="yb:equipment/yb:cash">
        <xsl:value-of select="@value"/> in coins;
    </xsl:template>


    <!-- Generic utility templates, for outputting common elements -->

    <xsl:template match="yb:character/yb:advantages">
        <xsl:for-each select="yb:advantage">
            <xsl:sort select="@name" data-type="text"/>

            <xsl:value-of select="@name"/>
            <xsl:if test="@target">
                (<xsl:value-of select="@target"/>)
            </xsl:if>
            (<xsl:value-of select="@cost"/>)
            <xsl:if test="not(position()=last())">
                <xsl:text>; </xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="yb:character-template/yb:advantages">
        <xsl:for-each select="yb:advantage">
            <xsl:sort select="@name" data-type="text"/>

            <xsl:value-of select="@name"/>
            <xsl:if test="@target">
                (<xsl:value-of select="@target"/>)
            </xsl:if>
            <xsl:if test="@cost">
                (<xsl:value-of select="@cost"/>)
            </xsl:if>
            <xsl:if test="not(position()=last())">
                <xsl:text>; </xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>


    <xsl:template match="yb:character-info">
        <h4>
            <xsl:value-of select="@name"/>, <xsl:value-of select="@gender"/>
        </h4>

        <xsl:apply-templates select="yb:names"/>
    </xsl:template>

    <xsl:template match="yb:character-info/yb:names">
        <p>
            Common names:
            <i>
                <xsl:for-each select="yb:name">
                    <xsl:choose>
                        <xsl:when test="position() = last()">
                            <xsl:value-of select="."/>.
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="."/>,
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </i>
        </p>
    </xsl:template>

    <!--
        character

        Render this character description as a full page character sheet.
        The format should be suitable for use in a game, and must also be
        able to cope with an 'empty' sheet ready for filling in by hand.
     -->
    <xsl:template match="yb:character" mode="page">
        <div class="character-sheet"
             style="width: 205mm; height: 285mm; border: solid black 1pt;
                    padding: 0mm; font-size: xx-small;">

            <h1 style="font-size: x-small; color: red;
                       background-color: #ffff99; margin: 0mm;">
                Yags Character Sheet
            </h1>

            <div>
                <table style="text-align: left; margin: 0mm;">
                    <tr>
                        <th style="width:30mm; font-size: xx-small;
                                color: black; background-color: white;
                                text-align: left">
                            player
                        </th>
                        <th style="width:73mm; font-size: xx-small;
                                color: black; background-color: white;
                                text-align: left;">
                            character
                        </th>
                    </tr>

                    <tr style="border: solid black 1pt; font-size: medium;">
                        <td style="border: solid black 1pt">
                            <xsl:value-of select="yb:description/yb:player"/>
                        </td>
                        <td style="border: solid black 1pt">
                            <xsl:value-of select="@name"/>
                        </td>
                    </tr>
                </table>
            </div>

            <xsl:choose>
                <xsl:when test="yags:statistics and $showYags='true'">
                    <xsl:apply-templates select="yags:statistics" mode="page"/>
                </xsl:when>
                <xsl:when test="five:statistics and $showFiveRings='true'">
                    <xsl:apply-templates select="five:statistics" mode="page"/>
                </xsl:when>
            </xsl:choose>
        </div>
    </xsl:template>

</xsl:stylesheet>
