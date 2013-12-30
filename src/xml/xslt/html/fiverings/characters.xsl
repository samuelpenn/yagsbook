<?xml version="1.0"?>

<!--
    Stylesheet transform for Yagsbook to HTML.

    These templates are for inline character descriptions, and
    character templates. In theory, they should also work for
    character sheets, where there is a single character description
    across two pages. Currently, this latter format isn't yet
    fully supported.

    Author:  Samuel Penn
    Version: $Revision: 1.2 $
    Date:    $Date: 2006/05/18 22:19:34 $

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
    xmlns:f="http://yagsbook.sourceforge.net/xml/fiverings"
    xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
    version="1.0">


    <!--
        Simple statistics shows all the basic character abilities,
        but does not work out combat statistics and the like.
    -->
    <xsl:template match="f:statistics" mode="page">
        <div style="width:100%">
            <xsl:apply-templates select="f:traits" mode="page"/>
        </div>

        <div style="float:left; width: 40%;">
            <xsl:apply-templates select="f:skills" mode="page"/>
        </div>

        <div style="float:right; width: 55%;">
            <xsl:apply-templates select="." mode="insight"/>
        </div>

        <div style="float:right; width: 55%;">
            <xsl:apply-templates select="f:combat" mode="page"/>
            <xsl:apply-templates select="f:combat" mode="wounds"/>
        </div>
    </xsl:template>


    <xsl:template match="f:statistics" mode="insight">
        <xsl:variable name="rings">
            <xsl:apply-templates select="f:traits" mode="insight"/>
        </xsl:variable>

        <xsl:variable name="skills">
            <xsl:apply-templates select="f:skills" mode="insight"/>
        </xsl:variable>

        <table style="margin-left: 0pt; font-size: medium;">
            <tr>
                <td style="background-color: black; color: white">Insight</td>
                <td style="border: 1pt solid black"><xsl:value-of select="$rings * 10 + $skills"/></td>
            </tr>
        </table>
    </xsl:template>

    <xsl:template match="f:traits" mode="insight">
        <xsl:value-of select="@earth + @water + @fire + @air + @void"/>
    </xsl:template>


    <xsl:template match="f:skills" mode="insight">
        <xsl:param name="index" select="1"/>
        <xsl:param name="total" select="0"/>

        <xsl:choose>
            <xsl:when test="f:group[$index]">
                <xsl:variable name="score">
                    <xsl:apply-templates select="f:group[$index]" mode="insight"/>
                </xsl:variable>
                <xsl:apply-templates select="." mode="insight">
                    <xsl:with-param name="index" select="$index + 1"/>
                    <xsl:with-param name="total" select="$total + $score"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="$total"/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="f:group" mode="insight">
        <xsl:param name="index" select="1"/>
        <xsl:param name="total" select="0"/>

        <xsl:choose>
            <xsl:when test="f:skill[$index]">
                <xsl:variable name="score" select="f:skill[$index]/@score"/>
                <xsl:variable name="mastery">
                    <xsl:choose>
                        <xsl:when test="$score &gt; 9">7</xsl:when>
                        <xsl:when test="$score &gt; 4">2</xsl:when>
                        <xsl:otherwise>0</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="insight">
                    <xsl:choose>
                        <xsl:when test="f:skill[$index]/@insight">
                            <xsl:value-of select="f:skill[$index]/@insight"/>
                        </xsl:when>
                        <xsl:otherwise>0</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:apply-templates select="." mode="insight">
                    <xsl:with-param name="index" select="$index + 1"/>
                    <xsl:with-param name="total" select="$total + $score + $mastery + $insight"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="$total"/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="f:traits" mode="page">
        <table style="font-size: medium; margin-left: 0; width:100%">
            <tr style="font-size: large; font-weight: bold; width:100%">
                <td colspan="2" width="20%">
                    Earth <xsl:value-of select="@earth"/>
                </td>
                <td colspan="2" width="20%">
                    Water <xsl:value-of select="@water"/>
                </td>
                <td colspan="2" width="20%">
                    Fire <xsl:value-of select="@fire"/>
                </td>
                <td colspan="2" width="20%">
                    Air <xsl:value-of select="@air"/>
                </td>
                <td colspan="2" width="20%">
                    Void <xsl:value-of select="@void"/>
                </td>
            </tr>

            <tr>
                <td>Stamina</td>
                <td><xsl:value-of select="f:trait[@name='stamina']/@score"/></td>
                <td>Strength</td>
                <td><xsl:value-of select="f:trait[@name='strength']/@score"/></td>
                <td>Agility</td>
                <td><xsl:value-of select="f:trait[@name='agility']/@score"/></td>
                <td>Reflexes</td>
                <td><xsl:value-of select="f:trait[@name='reflexes']/@score"/></td>
                <td/>
            </tr>

            <tr>
                <td>Willpower</td>
                <td><xsl:value-of select="f:trait[@name='willpower']/@score"/></td>
                <td>Perception</td>
                <td><xsl:value-of select="f:trait[@name='perception']/@score"/></td>
                <td>Intelligence</td>
                <td><xsl:value-of select="f:trait[@name='intelligence']/@score"/></td>
                <td>Awareness</td>
                <td><xsl:value-of select="f:trait[@name='awareness']/@score"/></td>
                <td/>
            </tr>
        </table>
    </xsl:template>


    <xsl:template match="f:skills" mode="page">
        <h2>Skills</h2>

        <xsl:apply-templates select="f:group" mode="page"/>
    </xsl:template>

    <xsl:template match="f:skills/f:group" mode="page">
        <table style="margin-left: 0mm; font-size: small; width: 100%;">
            <tr>
                <th style="text-align: left; width: 30%;"><xsl:value-of select="@name"/> Skills</th>
                <th style="text-align: left">Emphasis</th>
                <th style="text-align: center; width: 10%;">Ranks</th>
            </tr>

            <xsl:apply-templates select="f:skill" mode="page"/>
        </table>
    </xsl:template>

    <xsl:template match="f:skills/f:group/f:skill" mode="page">
        <xsl:variable name="colour">
            <xsl:choose>
                <xsl:when test="position() mod 2 = 0">#cccccc</xsl:when>
                <xsl:otherwise>#ffffff</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tr style="background-color: {$colour}">
            <td><xsl:value-of select="@name"/></td>
            <td><xsl:apply-templates select="f:emphasis"/></td>
            <td style="text-align: center"><xsl:value-of select="@score"/></td>
        </tr>
    </xsl:template>

    <xsl:template match="f:skill/f:emphasis">
        <xsl:if test="position() &gt; 1">
            <xsl:text>, </xsl:text>
        </xsl:if>
        <i><xsl:value-of select="."/></i>
        <xsl:if test="position() = last()">
            <xsl:text>.</xsl:text>
        </xsl:if>
    </xsl:template>


    <xsl:template match="f:combat" mode="page">
        <h2>Combat</h2>

        <xsl:variable name="defBonus" select="f:defence/@bonus"/>

        <table style="width: 100%; margin-left: 0mm; font-size: medium;">
            <td style="background-color: black; color: white">Initiative</td>
            <td style="border: 1pt solid black">
                <xsl:call-template name="rollkeep">
                    <xsl:with-param name="trait" select="../f:traits/f:trait[@name='reflexes']/@score"/>
                    <xsl:with-param name="skill" select="../f:ranks/@rank"/>
                </xsl:call-template>
            </td>

            <td style="background-color: black; color: white">TN To Be Hit</td>
            <td style="border: 1pt solid black">
                <xsl:value-of select="../f:traits/f:trait[@name='reflexes']/@score * 5 + $defBonus"/>
            </td>

            <td style="background-color: black; color: white">Experience</td>
            <td style="border: 1pt solid black; width: 20%">
                <xsl:value-of select="../f:traits/@xp"/>
            </td>
        </table>

        <table style="width: 100%; margin-left: 0mm; font-size: medium;">
            <tr>
                <th style="width: 80%; text-align: left;">Type of armour</th>
                <th style="width: 20%; text-align: center;">TN</th>
            </tr>
            <xsl:apply-templates select="f:armour"/>
        </table>

        <table style="width: 100%; margin-left: 0mm; font-size: medium;">
            <tr>
                <th style="width: 32%; text-align: left;">Weapon</th>
                <th style="width: 15%; text-align: center;">Skill</th>
                <th style="width: 10%; text-align: center;">Damage</th>
                <th style="width: 45%; text-align: left;">Notes</th>
            </tr>
            <xsl:apply-templates select="f:style"/>
        </table>
    </xsl:template>

    <xsl:template match="f:armour">
        <xsl:variable name="base" select="../../f:traits/f:trait[@name='reflexes']/@score * 5"/>
        <xsl:variable name="defBonus" select="../f:defence/@bonus"/>

        <tr>
            <td><xsl:value-of select="@name"/></td>
            <td>
                <xsl:value-of select="$base + @bonus + $defBonus"/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="f:style">
        <xsl:variable name="s" select="@skill"/>
        <xsl:variable name="attr" select="f:attribute"/>
        <xsl:variable name="strength" select="../../f:traits/f:trait[@name='strength']/@score"/>
        <xsl:variable name="trait" select="../../f:traits/f:trait[@name=$attr]/@score"/>
        <xsl:variable name="skill" select="../../f:skills/f:group/f:skill[@name=$s]/@score"/>

        <xsl:variable name="emphasisBonus">
            <xsl:choose>
                <xsl:when test="../../f:skills/f:group/f:skill[@name=$s]/f:emphasis = f:emphasis">
                    <xsl:value-of select="../../f:skills/f:group/f:skill[@name=$s]/@score"/>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="generalBonus" select="../f:attack/@bonus"/>

        <tr>
            <td align="left" valign="top"><xsl:value-of select="@name"/></td>
            <td align="left" valign="top">
                <xsl:call-template name="rollkeep">
                    <xsl:with-param name="trait" select="$trait"/>
                    <xsl:with-param name="skill" select="$skill"/>
                    <xsl:with-param name="bonus" select="$emphasisBonus + $generalBonus"/>
                </xsl:call-template>
            </td>
            <td align="left" valign="top">
                <xsl:apply-templates select="." mode="damage"/>
            </td>
            <td style="font-size: xx-small;" align="left" valign="top">
                <xsl:value-of select="f:notes"/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template name="rollkeep">
        <xsl:param name="trait" select="0"/>
        <xsl:param name="skill" select="0"/>
        <xsl:param name="bonus" select="0"/>

        <xsl:variable name="roll" select="$trait + $skill"/>
        <xsl:variable name="keep" select="$trait"/>

        <xsl:value-of select="$roll"/>
        <xsl:text>K</xsl:text>
        <xsl:value-of select="$keep"/>
        <xsl:if test="$bonus &gt; 0">
            <xsl:text> + </xsl:text>
            <xsl:value-of select="$bonus"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="f:style" mode="damage">
        <xsl:variable name="baseRolled" select="f:damage/@roll"/>
        <xsl:variable name="baseKeep" select="f:damage/@keep"/>
        <xsl:variable name="strength" select="../../f:traits/f:trait[@name='strength']/@score"/>

        <xsl:variable name="heavyBonus">
            <xsl:choose>
                <xsl:when test="f:heavy">
                    <xsl:value-of select="floor($strength div 2)"/>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="rollBonus" select="../f:damage/@roll"/>
        <xsl:variable name="keepBonus" select="../f:damage/@keep"/>

        <xsl:variable name="totalRoll" select="$baseRolled + $strength + $heavyBonus + $rollBonus"/>
        <xsl:variable name="totalKeep" select="$baseKeep + $keepBonus"/>

        <xsl:value-of select="$totalRoll"/>
        <xsl:text>K</xsl:text>
        <xsl:value-of select="$totalKeep"/>
    </xsl:template>

    <xsl:template match="f:combat" mode="wounds">
        <table style="margin-left: 0mm; font-size: medium; width: 100%" class="combat">
            <tr>
                <th style="background-color: {$combatDark}; color: white; width: 25%;">Wound level</th>
                <th style="background-color: {$combatDark}; color: white; width: 15%;">Total</th>
                <th style="background-color: {$combatDark}; color: white; width: 60%;">Damage</th>
            </tr>

            <xsl:variable name="earth" select="../f:traits/@earth"/>

            <xsl:call-template name="woundLevels">
                <xsl:with-param name="level"  select="'Healthy (+0)'"/>
                <xsl:with-param name="number" select="$earth * 2"/>
                <xsl:with-param name="total"  select="$earth * 2"/>
            </xsl:call-template>

            <xsl:call-template name="woundLevels">
                <xsl:with-param name="level"  select="'Nicked (+3)'"/>
                <xsl:with-param name="number" select="$earth * 2"/>
                <xsl:with-param name="total"  select="$earth * 4"/>
            </xsl:call-template>

            <xsl:call-template name="woundLevels">
                <xsl:with-param name="level"  select="'Grazed (+5)'"/>
                <xsl:with-param name="number" select="$earth * 2"/>
                <xsl:with-param name="total"  select="$earth * 6"/>
            </xsl:call-template>

            <xsl:call-template name="woundLevels">
                <xsl:with-param name="level"  select="'Hurt (+10)'"/>
                <xsl:with-param name="number" select="$earth * 2"/>
                <xsl:with-param name="total"  select="$earth * 8"/>
            </xsl:call-template>

            <xsl:call-template name="woundLevels">
                <xsl:with-param name="level"  select="'Injured (+15)'"/>
                <xsl:with-param name="number" select="$earth * 2"/>
                <xsl:with-param name="total"  select="$earth * 10"/>
            </xsl:call-template>

            <xsl:call-template name="woundLevels">
                <xsl:with-param name="level"  select="'Crippled (+20)'"/>
                <xsl:with-param name="number" select="$earth * 2"/>
                <xsl:with-param name="total"  select="$earth * 12"/>
            </xsl:call-template>

            <xsl:call-template name="woundLevels">
                <xsl:with-param name="level"  select="'Down (+40)'"/>
                <xsl:with-param name="number" select="$earth * 2"/>
                <xsl:with-param name="total"  select="$earth * 14"/>
            </xsl:call-template>

            <xsl:call-template name="woundLevels">
                <xsl:with-param name="level"  select="'Out'"/>
                <xsl:with-param name="number" select="$earth * 5"/>
                <xsl:with-param name="total"  select="$earth * 19"/>
            </xsl:call-template>
        </table>
    </xsl:template>

    <xsl:template name="woundLevels">
        <xsl:param name="level" select="Healthy"/>
        <xsl:param name="number" select="4"/>
        <xsl:param name="total" select="4"/>

        <tr>
            <td><xsl:value-of select="$level"/></td>
            <td><xsl:value-of select="$total"/></td>
            <td style="font-size: large;">
                <xsl:call-template name="blocks">
                    <xsl:with-param name="count" select="$number"/>
                </xsl:call-template>
            </td>
        </tr>
    </xsl:template>

    <xsl:template name="blocks">
        <xsl:param name="count" select="0"/>
        <xsl:param name="mod" select="0"/>

        <xsl:if test="$count &gt; 0">
            <xsl:if test="$mod mod 5 = 0">
                <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:text>O</xsl:text>
            <xsl:call-template name="blocks">
                <xsl:with-param name="count" select="$count - 1"/>
                <xsl:with-param name="mod" select="$mod + 1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>

