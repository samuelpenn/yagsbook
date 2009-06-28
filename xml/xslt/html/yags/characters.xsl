<?xml version="1.0"?>

<!--
    Stylesheet transform for Yagsbook to HTML.

    These templates are for inline character descriptions, and
    character templates. In theory, they should also work for
    character sheets, where there is a single character description
    across two pages. Currently, this latter format isn't yet
    fully supported.

    Author:  Samuel Penn
    Version: $Revision: 1.19 $
    Date:    $Date: 2006/12/17 14:17:10 $

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
    xmlns:y="http://yagsbook.sourceforge.net/xml/yags"
    version="1.0">

    <xsl:include href="../../share/yags/combat.xsl"/>
    <xsl:include href="../../share/yags/characters.xsl"/>

    <xsl:variable name="armsUrl"
                  select="'http://glendale.org.uk/xml/yags/equipment.yags'"/>

    <xsl:variable name="armsUrl1"
         select="'http://yagsbook.sourceforge.net/examples/yags/core/xml/equipment.yags'"/>

    <xsl:variable name="armsUrl2" select="'/home/sam/rpg/yags/core/xml/equipment.yags'"/>

    <!--
        Simple statistics shows all the basic character abilities,
        but does not work out combat statistics and the like.
    -->
    <xsl:template match="y:statistics" mode="simple">
        <xsl:apply-templates select="y:attributes"/>
        <xsl:apply-templates select="y:skills"/>
    </xsl:template>

    <!--
        Work out everything simple does, plus display derived combat
        statistics such as wounds, weapons stats etc.
    -->
    <xsl:template match="y:statistics" mode="full">
        <xsl:apply-templates select="y:attributes"/>
        <xsl:apply-templates select="y:skills"/>
        <xsl:apply-templates select="y:combat"/>
        <xsl:apply-templates select="y:advantages"/>
    </xsl:template>


    <xsl:variable name="darkCharacterColour" select="'#229922'"/>
    <xsl:variable name="lightCharacterColour" select="'#ddffdd'"/>

    <xsl:variable name="darkCombatColour" select="'#992222'"/>
    <xsl:variable name="lightCombatColour" select="'#ffdddd'"/>


    <!--
        attributes

        Display the character's primary and secondary attributes.
    -->
    <xsl:template match="y:attributes">
        <table class="attributes">
            <tr>
                <th>Size</th>
                <th>Str</th>
                <th>Hea</th>
                <th>Agi</th>
                <th>Dex</th>
                <th>Per</th>
                <th>Int</th>
                <th>Emp</th>
                <th>Wil</th>
                <th> </th>
                <th style="font-style: italic">Soak</th>
                <th style="font-style: italic">Move</th>
            </tr>

            <tr>
                <td><xsl:value-of select="@size"/></td>
                <xsl:apply-templates select="y:attribute[@name='strength']"/>
                <xsl:apply-templates select="y:attribute[@name='health']"/>
                <xsl:apply-templates select="y:attribute[@name='agility']"/>
                <xsl:apply-templates select="y:attribute[@name='dexterity']"/>
                <xsl:apply-templates select="y:attribute[@name='perception']"/>
                <xsl:apply-templates select="y:attribute[@name='intelligence']"/>
                <xsl:apply-templates select="y:attribute[@name='empathy']"/>
                <xsl:apply-templates select="y:attribute[@name='will']"/>
                <td> </td>
                <td><xsl:value-of select="@soak"/></td>
                <td>
                    <xsl:apply-templates select="." mode="move"/>
                </td>
            </tr>

            <tr>
                <td colspan="8" style="text-align: left;">
                    <xsl:apply-templates select="../y:traits"/>
                </td>
            </tr>
       </table>
    </xsl:template>

    <xsl:template match="y:attributes" mode="move">
        <xsl:variable name="size" select="@size"/>
        <xsl:variable name="str" select="y:attribute[@name='strength']/@score"/>
        <xsl:variable name="agi" select="y:attribute[@name='agility']/@score"/>

        <xsl:variable name="move" select="1 + $size + $str + $agi"/>
        <xsl:if test="number($move)">
            <xsl:value-of select="$move"/>
        </xsl:if>
    </xsl:template>

    <!--
        attribute

        Display the value for a single attribute. Take into account special
        rules for strength and intelligence.
     -->
    <xsl:template match="y:attribute">
        <td>
            <xsl:value-of select="@score"/>
            <xsl:choose>
                <xsl:when test="@name='strength'">
                    <xsl:if test="@half">
                        /<xsl:value-of select="@half"/>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="@name='intelligence'">
                    <xsl:if test="../y:advantages/y:advantage[@name='Animal']">
                        *
                    </xsl:if>
                </xsl:when>
            </xsl:choose>
        </td>
    </xsl:template>

    <!--
        traits

        Display all traits as a simple text string. Up to the caller to
        place it in a table or something.
     -->
    <xsl:template match="y:traits">
        <xsl:apply-templates select="y:trait"/>
    </xsl:template>

    <xsl:template match="y:traits/y:trait">
        <xsl:variable name="name" select="@name"/>
        <xsl:variable name="score" select="@score"/>

        <xsl:choose>
            <xsl:when test="position()=last()">
                <b><xsl:value-of select="$name"/>:</b>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$score"/>
            </xsl:when>
            <xsl:otherwise>
                <b><xsl:value-of select="$name"/>:</b>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$score"/>
                <xsl:text>; </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="y:skills">
        <h5>Skills</h5>
        <xsl:apply-templates select="y:group"/>
    </xsl:template>

    <xsl:template match="y:skills/y:group">
        <p>
            <b><i><xsl:value-of select="@name"/>: </i></b>
            <xsl:apply-templates select="y:skill">
                <xsl:sort select="@name" data-type="text"/>
            </xsl:apply-templates>
        </p>
    </xsl:template>

    <xsl:template match="y:skills/y:group/y:skill">
        <xsl:variable name="name">
            <xsl:choose>
                <xsl:when test="../@type = 'talents'">
                    <xsl:value-of select="substring(@name, 1, 3)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@name"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:if test="@score &gt; 0">
            <xsl:value-of select="$name"/>
            <xsl:text>-</xsl:text>
            <xsl:value-of select="@score"/>;
        </xsl:if>
    </xsl:template>



    <xsl:template match="y:combat">

        <table class="combat">
            <tr>
                <th align="left">Weapon</th>
                <th>Atk</th>
                <th>Dfn</th>
                <th>Damage</th>
                <th>Reach</th>
            </tr>

            <xsl:apply-templates select="y:combatstyle"/>
        </table>

        <xsl:if test="not(y:armourstyle)">
            <p>
                <b>Soak: </b> <xsl:value-of select="../y:attributes/@soak"/>
            </p>
        </xsl:if>

        <xsl:if test="y:armourstyle">
            <xsl:apply-templates select="y:armourstyle"/>
        </xsl:if>
    </xsl:template>




    <!-- For each combat style, work out the numbers -->
    <xsl:template match="y:combatstyle">
        <xsl:variable name="styleName" select="@style"/>
        <xsl:variable name="skillName" select="@skill"/>

        <tr>
            <td width="200"><xsl:value-of select="$styleName"/></td>
            <td><xsl:apply-templates select="y:attack"/></td>
            <td><xsl:apply-templates select="y:defence"/></td>
            <td><xsl:apply-templates select="y:damage"/></td>
            <td><xsl:apply-templates select="y:reach"/></td>
        </tr>
    </xsl:template>


    <!-- Armour and soak -->
    <xsl:template match="y:combat/y:armourstyle">
        <p>
            <b>Soak (<xsl:value-of select="@style"/>): </b>

            <xsl:apply-templates select="." mode="count">
                <xsl:with-param name="base" select="../../y:attributes/@soak"/>
            </xsl:apply-templates>
            <br/>
            <xsl:if test="y:armour">
                (<xsl:apply-templates select="." mode="list"/>)
            </xsl:if>
        </p>
    </xsl:template>

    <!--
        Display character's wound, stun and fatigue levels.
        Listed in "OK / 0 / -1 / -3 / -6 / -10 / Fatal" style.
    -->
    <xsl:template match="attributes" mode="wounds">
        <xsl:if test="number(@size)">
            <p>
                <b>Wounds: </b>
                <xsl:call-template name="y:output-wound-levels">
                    <xsl:with-param name="size" select="@size"/>
                    <xsl:with-param name="okay">OK</xsl:with-param>
                    <xsl:with-param name="fatal">Fatal</xsl:with-param>
                </xsl:call-template>
            </p>
            <p>
                <b>Stuns: </b>
                <xsl:call-template name="y:output-wound-levels">
                    <xsl:with-param name="size" select="@size"/>
                    <xsl:with-param name="okay">OK</xsl:with-param>
                    <xsl:with-param name="fatal">Oblivious</xsl:with-param>
                </xsl:call-template>
            </p>
        </xsl:if>
        <xsl:if test="number(attribute[@name='health']/@score)">
            <p>
                <b>Fatigue: </b>
                <xsl:call-template name="y:output-wound-levels">
                    <xsl:with-param name="size"
                            select="2 + attribute[@name='health']/@score"/>
                    <xsl:with-param name="okay">OK</xsl:with-param>
                    <xsl:with-param name="fatal">Exhausted</xsl:with-param>
                </xsl:call-template>
            </p>
        </xsl:if>
    </xsl:template>





    <!-- Generic utility templates, for outputting common elements -->

    <xsl:template match="y:statistics/y:advantages">
        <xsl:if test="y:advantage[@skill]">
            <h5>Techniques</h5>

            <p>
                <xsl:apply-templates select="y:advantage[@skill]"/>
            </p>
        </xsl:if>

        <xsl:if test="y:advantage[not(@skill)]">
            <h5>Advantages</h5>

            <p>
                <xsl:apply-templates select="y:advantage[not(@skill)]"/>
            </p>
        </xsl:if>
    </xsl:template>

    <xsl:template match="y:statistics/y:advantages/y:advantage">
        <xsl:value-of select="@name"/>
        <xsl:if test="@skill">
            [<i><xsl:value-of select="@skill"/></i>]
        </xsl:if>
        <xsl:if test="@cost">
            (<xsl:value-of select="@cost"/>)
        </xsl:if>
        <xsl:if test="not(position()=last())">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>





    <xsl:template match="y:statistics" mode="page">
        <xsl:apply-templates select="y:attributes" mode="page"/>
        <xsl:apply-templates select="y:skills" mode="page"/>
        <xsl:apply-templates select="y:advantages" mode="page"/>
        <xsl:apply-templates select="y:combat" mode="page"/>
    </xsl:template>

    <xsl:template match="y:attributes" mode="page">
        <style>
            table.attributes {
                margin: 0mm;
                position: absolute;
                left: 5mm;
                top: 20mm;
            }

            table.attributes th {
                background-color: <xsl:value-of select="$darkCharacterColour"/>;
                width: 10mm;
            }

            table.attributes th.secondary {
                background-color: <xsl:value-of select="$darkCharacterColour"/>;
                width: 10mm;
                font-style: italic;
            }

            table.attributes td {
                background-color: <xsl:value-of select="$lightCharacterColour"/>;
                width: 10mm;
                height: 5mm;
                border: 1pt solid black;
                text-align: center;
            }

            table.attributes th.blank {
                background-color: white;
                color: white;
                border: 0pt solid white;
                width: 2mm;
            }

            table.attributes td.blank {
                background-color: white;
                color: white;
                border: 0pt solid white;
                width: 2mm;
            }
        </style>

        <table class="attributes">
            <tr>
                <th class="secondary">Size</th>
                <th class="blank"/>

                <th>Str</th>
                <th>Hea</th>
                <th>Agi</th>
                <th>Dex</th>
                <th>Per</th>
                <th>Int</th>
                <th>Emp</th>
                <th>Wil</th>

                <th class="blank"/>

                <th class="secondary">Soak</th>
                <th class="secondary">Move</th>
            </tr>

            <tr>
                <td><xsl:value-of select="@size"/></td>
                <td class="blank"> </td>
                <xsl:apply-templates select="y:attribute[@name='strength']"/>
                <xsl:apply-templates select="y:attribute[@name='health']"/>
                <xsl:apply-templates select="y:attribute[@name='agility']"/>
                <xsl:apply-templates select="y:attribute[@name='dexterity']"/>
                <xsl:apply-templates select="y:attribute[@name='perception']"/>
                <xsl:apply-templates select="y:attribute[@name='intelligence']"/>
                <xsl:apply-templates select="y:attribute[@name='empathy']"/>
                <xsl:apply-templates select="y:attribute[@name='will']"/>
                <td class="blank"> </td>
                <td><xsl:value-of select="@soak"/></td>
                <td>
                    <xsl:apply-templates select="." mode="move"/>
                </td>
            </tr>
        </table>
    </xsl:template>

    <xsl:template match="y:skills" mode="page">
        <style>
            div.skills {
                width: 70mm;
                height: 150mm;
                position: absolute;
                left: 5mm;
                top: 32mm;
            }

            div.skills table {
                margin: 0mm;
            }

            div.skills table tr th {
                background-color: <xsl:value-of select="$darkCharacterColour"/>;
            }

            div.skills table tr td {
                background-color: <xsl:value-of select="$lightCharacterColour"/>;
                border: 1pt solid black;
                height: 5mm;
            }
        </style>

        <div class="skills">
            <table>
                <tr>
                    <th style="width: 50mm; text-align: left;">Skills</th>
                    <th style="width: 10mm">Score</th>
                    <th style="width: 7mm">xp</th>
                </tr>

                <xsl:apply-templates select="y:group[@name='Talents']" mode="page-talents"/>
                <xsl:apply-templates select="y:group[not(@name='Talents')]" mode="page"/>

                <xsl:variable name="numSkills" select="count(y:group/y:skill)"/>
                <xsl:variable name="blankLines" select="25 - $numSkills"/>
                <xsl:call-template name="addBlankLines">
                    <xsl:with-param name="i" select="$blankLines"/>
                </xsl:call-template>
            </table>
        </div>
    </xsl:template>

    <xsl:template name="addBlankLines">
        <xsl:param name="i" select="30"/>
        <xsl:param name="columns" select="3"/>

        <xsl:if test="$i &gt; 0">
            <tr>
                <td/><td/>
                <xsl:if test="$columns &gt; 2">
                    <td/>
                </xsl:if>
            </tr>
            <xsl:call-template name="addBlankLines">
                <xsl:with-param name="i" select="$i - 1"/>
                <xsl:with-param name="columns" select="$columns"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!--
        Ensure that all talents are printed out, regardless of whether
        they actually exist or not. This copes with a blank character
        with no skills defined.
     -->
    <xsl:template match="y:skills/y:group" mode="page-talents">
        <tr>
            <td>Athletics</td>
            <td><xsl:value-of select="y:skill[@name='Athletics']/@score"/></td>
            <td><xsl:value-of select="y:skill[@name='Athletics']/@xp"/></td>
        </tr>
        <tr>
            <td>Awareness</td>
            <td><xsl:value-of select="y:skill[@name='Awareness']/@score"/></td>
            <td><xsl:value-of select="y:skill[@name='Awareness']/@xp"/></td>
        </tr>
        <tr>
            <td>Brawl</td>
            <td><xsl:value-of select="y:skill[@name='Brawl']/@score"/></td>
            <td><xsl:value-of select="y:skill[@name='Brawl']/@xp"/></td>
        </tr>
        <tr>
            <td>Charm</td>
            <td><xsl:value-of select="y:skill[@name='Charm']/@score"/></td>
            <td><xsl:value-of select="y:skill[@name='Charm']/@xp"/></td>
        </tr>
        <tr>
            <td>Guile</td>
            <td><xsl:value-of select="y:skill[@name='Guile']/@score"/></td>
            <td><xsl:value-of select="y:skill[@name='Guile']/@xp"/></td>
        </tr>
        <tr>
            <td>Sleight</td>
            <td><xsl:value-of select="y:skill[@name='Sleight']/@score"/></td>
            <td><xsl:value-of select="y:skill[@name='Sleight']/@xp"/></td>
        </tr>
        <tr>
            <td>Stealth</td>
            <td><xsl:value-of select="y:skill[@name='Stealth']/@score"/></td>
            <td><xsl:value-of select="y:skill[@name='Stealth']/@xp"/></td>
        </tr>
        <tr>
            <td>Throw</td>
            <td><xsl:value-of select="y:skill[@name='Throw']/@score"/></td>
            <td><xsl:value-of select="y:skill[@name='Throw']/@xp"/></td>
        </tr>
    </xsl:template>

    <xsl:template match="y:group" mode="page">
        <xsl:apply-templates select="y:skill" mode="page"/>
    </xsl:template>

    <xsl:template match="y:group/y:skill" mode="page">
        <tr>
            <td><xsl:value-of select="@name"/></td>
            <td><xsl:value-of select="@score"/></td>
            <td><xsl:value-of select="@xp"/></td>
        </tr>
    </xsl:template>



    <!--
        advantages

        Display advantages in a full page character sheet format.
        All advantages, disadvantages and techniques are displayed in a
        single box, though techniques are put in their own section.
     -->
    <xsl:template match="y:advantages" mode="page">
        <style>
            div.advantages {
                height: 150mm;
                position: absolute;
                top: 32mm;
            }

            div.advantages table {
                margin: 0mm;
            }

            div.advantages table tr th {
                background-color: <xsl:value-of select="$darkCharacterColour"/>;
            }

            div.advantages table tr td {
                background-color: <xsl:value-of select="$lightCharacterColour"/>;
                border: 1pt solid black;
                height: 5mm;
            }
        </style>

        <div class="advantages" style="left:76mm; width:70mm">
            <table>
                <tr>
                    <th style="width: 40mm; text-align: left;">Techniques</th>
                    <th style="width: 20mm">Skill</th>
                    <th style="width: 7mm">Score</th>
                </tr>

                <xsl:apply-templates select="y:advantage[@skill]" mode="page"/>

                <xsl:variable name="numTechniques"
                              select="count(y:advantage[@skill])"/>
                <xsl:variable name="blankLines" select="16 - $numTechniques"/>
                <xsl:call-template name="addBlankLines">
                    <xsl:with-param name="i" select="$blankLines"/>
                </xsl:call-template>
            </table>
        </div>

        <div class="advantages" style="left: 147mm;">
            <table>
                <tr>
                    <th style="width: 45mm; text-align: left;">Advantages/Disadvantages</th>
                    <th style="width: 7mm">Cost</th>
                </tr>

                <xsl:apply-templates select="y:advantage[not(@skill)]" mode="page"/>

                <xsl:variable name="numAdvantages"
                              select="count(y:advantage[not(@skill)])"/>
                <xsl:variable name="blankLines2" select="16 - $numAdvantages"/>
                <xsl:call-template name="addBlankLines">
                    <xsl:with-param name="i" select="$blankLines2"/>
                    <xsl:with-param name="columns" select="2"/>
                </xsl:call-template>
            </table>
        </div>
    </xsl:template>

    <xsl:template match="y:advantage[@skill]" mode="page">
        <tr>
            <td><xsl:value-of select="@name"/></td>
            <td><xsl:value-of select="@skill"/></td>
            <td><xsl:value-of select="@score"/></td>
        </tr>
    </xsl:template>

    <xsl:template match="y:advantage[not(@skill)]" mode="page">
        <tr>
            <td>
                <xsl:value-of select="@name"/>
                <xsl:if test="@score">
                    (<xsl:value-of select="@score"/>)
                </xsl:if>
            </td>
            <td><xsl:value-of select="@cost"/></td>
        </tr>
    </xsl:template>

    <!--
        combat

        Display weapon information for a full page character sheet.
     -->

    <xsl:template match="y:combat" mode="page">
        <style>
            table.melee {
                background-color: <xsl:value-of select="$lightCombatColour"/>;
                position: absolute;
                left: 5mm;
                top: 222mm;
                width: 197mm;
                margin: 0mm;
            }

            table.melee th {
                background-color: <xsl:value-of select="$darkCombatColour"/>;
                color: white;
            }

            table.melee td {
                border: black solid 1pt;
                height: 5mm;
            }

            table.melee td.blank {
                border: none;
                height: 5mm;
            }

            table.armour {
                background-color: <xsl:value-of select="$lightCombatColour"/>;
                position: absolute;
                left: 76mm;
                top: 190mm;
                width: 125mm;
                margin: 0mm;
            }

            table.armour th {
                background-color: <xsl:value-of select="$darkCombatColour"/>;
                color: white;
            }

            table.armour td {
                border: black solid 1pt;
                height: 5mm;
            }

            table.armour td.blank {
                border: none;
                height: 5mm;
            }

            table.wounds {
                background-color: <xsl:value-of select="$lightCombatColour"/>;
                position: absolute;
                left: 76mm;
                top: 130mm;
                width: 50mm;
                margin: 0mm;
            }

            table.wounds th {
                background-color: <xsl:value-of select="$darkCombatColour"/>;
                color: white;
            }

            table.wounds td {
                border: black solid 1pt;
                height: 5mm;
                width: 20mm;
                text-align: center;
            }

            table.wounds td.w {
                border: black solid 1pt;
                height: 5mm;
                width: 10mm;
                padding-right: 5mm;
            }

            table.wounds td.s {
                border: black solid 1pt;
                height: 5mm;
                width: 10mm;
                padding-left: 5mm;
            }

            table.wounds td.block {
                border: none;
                height: 5mm;
                background-color: <xsl:value-of select="$darkCombatColour"/>;
            }
        </style>

        <table class="melee">
            <tr>
                <th style="width: 85mm; text-align: left;">Weapon</th>
                <th style="width: 10mm;">Rch</th>
                <th style="width: 10mm;">Atk</th>
                <th style="width: 10mm;">Dfn</th>
                <th style="width: 10mm;">Dmg</th>
                <th style="width: 7mm;">Inc</th>
                <th style="width: 7mm;">Sh</th>
                <th style="width: 7mm;">Md</th>
                <th style="width: 7mm;">Lg</th>
                <th style="text-align: left;">Notes</th>
            </tr>

            <xsl:apply-templates select="y:combatstyle" mode="page"/>

            <xsl:call-template name="blankCombatStyle"/>
            <xsl:call-template name="blankCombatStyle"/>
            <xsl:call-template name="blankCombatStyle"/>
            <xsl:call-template name="blankCombatStyle"/>
        </table>

        <table class="armour">
            <tr>
                <th style="width: 80mm;">Armour</th>
                <th style="width: 10mm;">Load</th>
                <th style="width: 10mm;">Full</th>
                <th style="width: 10mm;">Soft</th>
                <th style="width: 10mm;">Impl</th>
                <th style="width: 10mm;">Half</th>
            </tr>

            <tr>
                <td rowspan="2"/>
                <td/><td/><td/><td/><td/>
            </tr>
            <tr>
                <td class="blank">Total:</td>
                <td/><td/><td/><td/>
            </tr>

            <tr>
                <td rowspan="2"/>
                <td/><td/><td/><td/><td/>
            </tr>
            <tr>
                <td class="blank">Total:</td>
                <td/><td/><td/><td/>
            </tr>
        </table>

        <table class="wounds">
            <tr>
                <th style="width:10mm;">Wounds</th>
                <th>Penalty</th>
                <th style="width:10mm;">Stuns</th>
            </tr>

            <tr>
                <td class="block"/><td>OK</td><td class="block"/>
            </tr>
            <tr><td class="w"/><td>0</td><td class="s"/></tr>
            <tr><td class="w"/><td>-1</td><td class="s"/></tr>
            <tr><td class="w"/><td>-3</td><td class="s"/></tr>
            <tr><td class="w"/><td>-6</td><td class="s"/></tr>
            <tr><td class="w"/><td>-10</td><td class="s"/></tr>
            <tr><td class="w"/><td>-15</td><td class="s"/></tr>
        </table>
    </xsl:template>

    <xsl:template match="y:combatstyle" mode="page">
        <tr>
            <td rowspan="2">
                <xsl:value-of select="@style"/>
                <br/>
                Skill: <i><xsl:value-of select="@skill"/></i>
            </td>
            <td>
                <xsl:call-template name="y:weapon-bonus">
                    <xsl:with-param name="primary" select="y:primary"/>
                    <xsl:with-param name="secondary" select="y:secondary"/>
                    <xsl:with-param name="attribute" select="'reach'"/>
                </xsl:call-template>
            </td>
            <td>
                <xsl:call-template name="y:weapon-bonus">
                    <xsl:with-param name="primary" select="y:primary"/>
                    <xsl:with-param name="secondary" select="y:secondary"/>
                    <xsl:with-param name="attribute" select="'attack'"/>
                </xsl:call-template>
            </td>
            <td>
                <xsl:call-template name="y:weapon-bonus">
                    <xsl:with-param name="primary" select="y:primary"/>
                    <xsl:with-param name="secondary" select="y:secondary"/>
                    <xsl:with-param name="attribute" select="'defence'"/>
                </xsl:call-template>
            </td>
            <td>
                <xsl:call-template name="y:weapon-bonus">
                    <xsl:with-param name="primary" select="y:primary"/>
                    <xsl:with-param name="secondary" select="y:secondary"/>
                    <xsl:with-param name="attribute" select="'damage'"/>
                </xsl:call-template>
            </td>
            <td/><td/><td/><td/>

            <td rowspan="2"/>
        </tr>
        <tr>
            <td class="blank">Total:</td>
            <td><xsl:apply-templates select="y:attack"/></td>
            <td><xsl:apply-templates select="y:defence"/></td>
            <td><xsl:apply-templates select="y:damage"/></td>
            <td/><td/><td/><td/>
        </tr>
    </xsl:template>

    <xsl:template name="blankCombatStyle">
        <tr>
            <td rowspan="2"/>
            <td/> <!-- Reach -->
            <td/> <!-- Attack -->
            <td/> <!-- Defence -->
            <td/> <!-- Damage -->
            <td/><td/><td/><td/>
            <td rowspan="2"/>
        </tr>
        <tr>
            <td class="blank">Total:</td>
            <td/>
            <td/>
            <td/>
            <td/><td/><td/><td/>
        </tr>
    </xsl:template>

</xsl:stylesheet>
