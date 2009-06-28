<?xml version="1.0"?>

<!--
    Stylesheet transform for Yagsbook to HTML.

    These templates are for bestiary entries.

    Author:  Samuel Penn
    Version: $Revision: 1.4 $
    Date:    $Date: 2005/08/10 07:04:59 $

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
    xmlns:war="http://yagsbook.sourceforge.net/xml/warhammer"
    version="1.0">

    <!-- Import templates for game system specific rules -->
    <xsl:include href="yags/bestiary.xsl"/>


    <!--
        Complete Bestiary.
        This template provides top level support for the rendering of
        a bestiary - i.e. a document with root node '/bestiary',
        consisting only of one or more 'beast' entries.

        This type of output is not part of an article.
    -->
    <xsl:template match="/yb:bestiary">
        <xsl:for-each select="yb:beast[@primary='true']">
            <xsl:sort select="@name" data-type="text"/>
            <h1 class="header"><xsl:value-of select="@name"/></h1>

            <div class="bodytext">
                <xsl:apply-templates select="." mode="bestiary"/>
            </div>
        </xsl:for-each>

        <xsl:for-each select="yb:beast[not(@primary='true')]">
            <xsl:sort select="@name" data-type="text"/>
            <h1 class="header"><xsl:value-of select="@name"/></h1>

            <div class="bodytext">
                <xsl:apply-templates select="." mode="bestiary"/>
            </div>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="yb:bestiary">
        <xsl:for-each select="yb:beast[@primary='true']">
            <xsl:sort select="@name" data-type="text"/>
            <h1 class="header"><xsl:value-of select="@name"/></h1>

            <div class="bodytext">
                <xsl:apply-templates select="." mode="full"/>
            </div>
        </xsl:for-each>

        <xsl:for-each select="yb:beast[not(@primary='true')]">
            <xsl:sort select="@name" data-type="text"/>
            <h1 class="header"><xsl:value-of select="@name"/></h1>

            <div class="bodytext">
                <xsl:apply-templates select="." mode="full"/>
            </div>
        </xsl:for-each>
    </xsl:template>


    <!--
        Import a beast description. This automatically uses inline mode
    -->
    <xsl:template match="yb:import-beast">
        <xsl:variable name="href" select="@href"/>

        <xsl:choose>
            <xsl:when test="@name">
                <xsl:variable name="name" select="@name"/>
                <xsl:apply-templates
                        select="document($href)//yb:beast[@name=$name]"
                        mode="full"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="document($href)//yb:beast"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="/yb:article//yb:beast">
        <xsl:choose>
            <xsl:when test="@display='brief'">
                <xsl:apply-templates select="." mode="brief"/>
            </xsl:when>
            <xsl:when test="@display='short'">
                <xsl:apply-templates select="." mode="short"/>
            </xsl:when>
            <xsl:otherwise>
                 <xsl:apply-templates select="." mode="full"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
        beast

        The default beast template. This provides an inline rendition of
        a beast with full information provided.
    -->
    <xsl:template match="yb:beast">
        <div class="beast">
            <h4><xsl:value-of select="@name"/></h4>

            <xsl:apply-templates select="." mode="basicInfo"/>
            <xsl:apply-templates select="yb:information"/>
            <xsl:apply-templates select="." mode="stats"/>
        </div>
    </xsl:template>

    <!--
        A very brief character description, with no game stats
        at all, and only a short physical description.
    -->
    <xsl:template match="yb:beast" mode="brief">
        <div class="beast">
            <h4><xsl:value-of select="@name"/></h4>

            <xsl:apply-templates select="." mode="basicInfo"/>
            <xsl:apply-templates select="yb:description"/>
            <xsl:apply-templates select="yb:information"/>
        </div>
        <br/>
    </xsl:template>


    <!--
        A short character description, missing out the full
        physical description and character background, but
        including all game statistics.
    -->
    <xsl:template match="yb:beast" mode="short">
        <div class="beast">
            <h4><xsl:value-of select="@name"/></h4>

            <xsl:apply-templates select="." mode="basicInfo"/>
            <xsl:apply-templates select="yb:description"/>
            <xsl:apply-templates select="yb:information"/>

            <xsl:apply-templates select="attributes" mode="inline"/>
            <xsl:apply-templates select="passions" mode="inline"/>
            <xsl:apply-templates select="skills/group" mode="inline"/>
            <xsl:apply-templates select="combat" mode="inline"/>
            <xsl:apply-templates select="attributes" mode="wounds"/>
        </div>
        <br/>
    </xsl:template>

    <xsl:template match="yb:beast" mode="full">
         <div class="beast">
            <h4><xsl:value-of select="@name"/></h4>

            <xsl:apply-templates select="." mode="basicInfo"/>
            <xsl:apply-templates select="yb:description"/>
            <xsl:apply-templates select="yb:information"/>

            <xsl:apply-templates select="." mode="statsInline"/>

            <xsl:if test="yb:description/yb:physical">
                <h2>Description</h2>

                <xsl:apply-templates select="yb:description/yb:physical"/>
            </xsl:if>

            <xsl:if test="yb:description/yb:social">
                <h2>Society</h2>

                <xsl:apply-templates select="yb:description/yb:social"/>
            </xsl:if>

            <xsl:if test="yb:description/yb:tactics">
                <h2>Combat Tactics</h2>

                <xsl:apply-templates select="yb:description/yb:tactics"/>
            </xsl:if>

            <xsl:if test="yb:description/yb:legends">
                <h2>Legends and Lore</h2>

                <xsl:apply-templates select="yb:description/yb:legends"/>
            </xsl:if>

            <xsl:if test="yb:description/yb:powers">
                <h2>Powers</h2>

                <xsl:apply-templates select="yb:description/yb:powers"/>
            </xsl:if>
        </div>
        <br/>
    </xsl:template>

    <!--
        Full beast description. This template is reserved for when
        we are rendering a bestiary - i.e. a document which only
        contains beast descriptions.

        Use larger fonts, and a clearer layout since it can be
        assumed we have an entire page for the description.
    -->
    <xsl:template match="/yb:bestiary/yb:beast" mode="bestiary">
        <div class="bestiary">

            <!--
                Format of the information bar the top depends on
                whether he have an image of the beast. If not, use
                two column layout. Otherwise, use one column for
                all the info, and put the image in the right column.
            -->
            <xsl:choose>
                <xsl:when test="yb:description/yb:image">
                    <table width="95%" class="beastInfo">
                        <tr align="left">
                            <td align="left" valign="top">
                                <xsl:apply-templates select="." mode="basicInfo"/>
                                <xsl:apply-templates select="yb:description"/>
                                <xsl:apply-templates select="yb:information"/>
                            </td>
                            <td class="beastImage">
                                <img src="{yb:description/yb:image/@href}"/>
                            </td>
                        </tr>
                    </table>
                </xsl:when>

                <xsl:otherwise>
                    <table width="95%" class="beastInfo">
                        <tr align="left">
                            <td align="left" valign="top">
                                <xsl:apply-templates select="." mode="basicInfo"/>
                                <xsl:apply-templates select="yb:description"/>
                            </td>
                            <td align="left" valign="top">
                                <xsl:apply-templates select="yb:information"/>
                            </td>
                        </tr>
                    </table>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:apply-templates select="." mode="stats"/>

            <xsl:if test="yb:description/yb:physical">
                <h2>Description</h2>

                <xsl:apply-templates select="yb:description/yb:physical"/>
            </xsl:if>

            <xsl:if test="yb:description/yb:social">
                <h2>Society</h2>

                <xsl:apply-templates select="yb:description/yb:social"/>
            </xsl:if>

            <xsl:if test="yb:description/yb:tactics">
                <h2>Combat Tactics</h2>

                <xsl:apply-templates select="yb:description/yb:tactics"/>
            </xsl:if>

            <xsl:if test="yb:description/yb:legends">
                <h2>Legends and Lore</h2>

                <xsl:apply-templates select="yb:description/yb:legends"/>
            </xsl:if>

            <xsl:if test="yb:description/yb:powers">
                <h2>Powers</h2>

                <xsl:apply-templates select="yb:description/yb:powers"/>
            </xsl:if>

            <xsl:if test="yb:description/yb:training">
                <h2>Training</h2>

                <xsl:apply-templates select="yb:description/yb:training"/>
            </xsl:if>

        </div>
        <br/>
    </xsl:template>

    <xsl:template match="yb:beast" mode="stats">
        <xsl:variable name="number" select="count(*)"/>

        <xsl:choose>
            <xsl:when test="$number &lt; 4">
                <!-- Only one set of game rules here. -->
                <xsl:apply-templates select="yags:statistics" mode="full"/>
                <xsl:apply-templates select="ars:statistics"/>
                <xsl:apply-templates select="d20:statistics"/>
                <xsl:apply-templates select="war:statistics"/>
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
                    <xsl:if test="yags:statistics">
                        <h5 style="{$style}">Yags</h5>
                        <xsl:apply-templates select="yags:statistics" mode="full"/>
                    </xsl:if>
                    <xsl:if test="d20:statistics">
                        <h5 style="{$style}">d20</h5>
                        <xsl:apply-templates select="d20:statistics"/>
                    </xsl:if>
                    <xsl:if test="ars:statistics">
                        <h5 style="{$style}">Ars Magica</h5>
                        <xsl:apply-templates select="ars:statistics"/>
                    </xsl:if>
                    <xsl:if test="war:statistics">
                        <h5 style="{$style}">Warhammer</h5>
                        <xsl:apply-templates select="war:statistics"/>
                    </xsl:if>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="yb:beast" mode="statsInline">
        <xsl:variable name="number" select="count(*)"/>

        <xsl:choose>
            <xsl:when test="$number &lt; 4">
                <!-- Only one set of game rules here. -->
                <xsl:apply-templates select="yags:statistics" mode="full"/>
                <xsl:apply-templates select="ars:statistics"/>
                <xsl:apply-templates select="d20:statistics"/>
                <xsl:apply-templates select="war:statistics"/>
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
                    <xsl:if test="yags:statistics">
                        <h5 style="{$style}">Yags</h5>
                        <xsl:apply-templates select="yags:statistics" mode="full"/>
                    </xsl:if>
                    <xsl:if test="d20:statistics">
                        <h5 style="{$style}">d20</h5>
                        <xsl:apply-templates select="d20:statistics"/>
                    </xsl:if>
                    <xsl:if test="ars:statistics">
                        <h5 style="{$style}">Ars Magica</h5>
                        <xsl:apply-templates select="ars:statistics"/>
                    </xsl:if>
                    <xsl:if test="war:statistics">
                        <h5 style="{$style}">Warhammer</h5>
                        <xsl:apply-templates select="war:statistics"/>
                    </xsl:if>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="yb:beast/yb:description/*">
        <xsl:apply-templates/>
        <!--
        <xsl:choose>
            <xsl:when test="para">
                <xsl:apply-templates select="para"/>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    <xsl:value-of select="."/>
                </p>
            </xsl:otherwise>
        </xsl:choose>
        -->
    </xsl:template>

    <!--
        Basic character description, including gender, race, age
        and a short one line description.
    -->
    <xsl:template match="yb:beast" mode="basicInfo">
        <xsl:variable name="size">
            <xsl:choose>
                <xsl:when test="yags:statistics/yags:attributes">
                    <xsl:value-of select="yags:statistics/yags:attributes/@size"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="sizeClass">
            <xsl:choose>
                <xsl:when test="not(number($size))"></xsl:when>
                <xsl:when test="$size &lt; 1">Diminutive </xsl:when>
                <xsl:when test="$size &lt; 2">Tiny </xsl:when>
                <xsl:when test="$size &lt; 4">Small </xsl:when>
                <xsl:when test="$size &lt; 7">Medium </xsl:when>
                <xsl:when test="$size &lt; 13">Large </xsl:when>
                <xsl:when test="$size &lt; 21">Huge </xsl:when>
                <xsl:when test="$size &lt; 31">Enormous </xsl:when>
                <xsl:when test="$size &lt; 51">Gigantic </xsl:when>
                <xsl:when test="$size &lt; 81">Colossal </xsl:when>
                <xsl:otherwise>Titanic </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <p>
            <b><i>
                <xsl:value-of select="$sizeClass"/>
                <xsl:value-of select="yb:information/yb:type"/>
            </i></b>
        </p>

        <p>
            <xsl:if test="yb:description/yb:aka">
                <i>
                    <xsl:for-each select="yb:description/yb:aka">
                        <xsl:choose>
                            <xsl:when test="position()=last()">
                                <xsl:value-of select="."/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="."/>,
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text> </xsl:text>
                    </xsl:for-each>
                </i>
                <br/>
            </xsl:if>
        </p>
    </xsl:template>

    <xsl:template match="yb:beast/yb:description">
        <p>
            <xsl:value-of select="yb:short"/>
        </p>
    </xsl:template>

    <xsl:template match="yb:beast/yb:information">
        <p>
            <xsl:if test="yb:demeanor">
                <b>Demeanor: </b><xsl:value-of select="yb:demeanor"/><br/>
            </xsl:if>

            <xsl:if test="yb:habitat">
                <xsl:apply-templates select="yb:habitat"/>
                <br/>
            </xsl:if>

            <xsl:if test="yb:organisation">
                <xsl:apply-templates select="yb:organisation"/>
                <br/>
            </xsl:if>

            <xsl:if test="yb:genre">
                <b>Origin: </b>
                <xsl:value-of select="yb:genre"/>/<xsl:value-of select="yb:origin"/><br/>
            </xsl:if>
        </p>
    </xsl:template>

    <xsl:template match="yb:beast/yb:information/yb:habitat">
        <xsl:if test="position()=1">
            <b>Habitat: </b>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="position()=last()">
                <xsl:value-of select="@climate"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="@terrain"/>
                <xsl:text> </xsl:text>
                (<xsl:value-of select="@frequency"/>)
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="@climate"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="@terrain"/>
                <xsl:text> </xsl:text>
                (<xsl:value-of select="@frequency"/>)
                <xsl:text>, </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="yb:beast/yb:information/yb:organisation">
        <xsl:if test="position()=1">
            <b>Organisation: </b>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="position()=last()">
                <xsl:value-of select="@group"/> (<xsl:value-of select="@number"/>)
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="@group"/> (<xsl:value-of select="@number"/>)
                <xsl:text>, </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="yb:beast/yb:advantages" mode="open">
        <h2 class="skillsOpen">Advantages/Disadvantages</h2>

        <p class="skillsOpen">
            <xsl:apply-templates select="yb:advantage" mode="inline">
                <xsl:sort select="@name" data-type="text"/>
            </xsl:apply-templates>
        </p>
    </xsl:template>

    <xsl:template match="yb:beast/yb:advantages/yb:advantage" mode="inline">
        <xsl:choose>
            <xsl:when test="@score">
                <xsl:value-of select="@name"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="@score"/>;
                <xsl:text> </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="@name"/>;
                <xsl:text> </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
