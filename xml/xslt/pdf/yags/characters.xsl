<?xml version="1.0"?>

<!--
    Stylesheet transform for Yagsbook to PDF.

    These templates are for inline character descriptions, and
    character templates. In theory, they should also work for
    character sheets, where there is a single character description
    across two pages. Currently, this latter format isn't yet
    fully supported.

    Author:  Samuel Penn
    Version: $Revision: 1.14 $
    Date:    $Date: 2007/03/24 22:21:02 $

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

<xsl:stylesheet xmlns:yb="http://yagsbook.sourceforge.net/xml"
                xmlns:y="http://yagsbook.sourceforge.net/xml/yags"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">

    <xsl:include href="../../share/yags/combat.xsl"/>
    <xsl:include href="../../share/yags/characters.xsl"/>

    <xsl:variable name="armsUrl"
         select="'http://yagsbook.sourceforge.net/xml/yags/equipment/arms.yags'"/>


    <xsl:template match="y:statistics">
        <xsl:apply-templates select="y:attributes"/>
        <xsl:apply-templates select="y:traits"/>
        <xsl:apply-templates select="y:skills"/>
        <xsl:apply-templates select="y:advantages"/>
        <xsl:apply-templates select="y:combat"/>
    </xsl:template>



    <!-- Display character attributes -->
    <xsl:template match="y:attributes">
        <fo:table table-layout="fixed">
            <fo:table-column column-width="1cm"/>
            <fo:table-column column-width="1cm"/>
            <fo:table-column column-width="1cm"/>
            <fo:table-column column-width="1cm"/>
            <fo:table-column column-width="1cm"/>
            <fo:table-column column-width="1cm"/>
            <fo:table-column column-width="1cm"/>
            <fo:table-column column-width="1cm"/>

            <fo:table-header>
                <fo:table-row font-size="10pt" font-weight="bold">
                    <fo:table-cell><fo:block>Str</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>Hea</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>Agi</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>Dex</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>Per</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>Int</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>Emp</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>Wil</fo:block></fo:table-cell>
                </fo:table-row>
            </fo:table-header>

            <fo:table-body font-size="10pt" font-family="Times">
                <fo:table-row>
                    <fo:table-cell><fo:block>
                    <xsl:value-of select="y:attribute[@name='strength']/@score"/>
                    </fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>
                    <xsl:value-of select="y:attribute[@name='health']/@score"/>
                    </fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>
                    <xsl:value-of select="y:attribute[@name='agility']/@score"/>
                    </fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>
                    <xsl:value-of select="y:attribute[@name='dexterity']/@score"/>
                    </fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>
                    <xsl:value-of select="y:attribute[@name='perception']/@score"/>
                    </fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>
                    <xsl:value-of select="y:attribute[@name='intelligence']/@score"/>
                    </fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>
                    <xsl:value-of select="y:attribute[@name='empathy']/@score"/>
                    </fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>
                    <xsl:value-of select="y:attribute[@name='will']/@score"/>
                    </fo:block></fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>

    <!-- Output character's traits -->
    <xsl:template match="y:traits">
        <fo:block font-size="8pt">
            <xsl:apply-templates select="y:trait"/>
        </fo:block>
    </xsl:template>

    <xsl:template match="y:traits/y:trait">
        <xsl:variable name="name" select="@name"/>
        <xsl:variable name="score" select="@score"/>

        <xsl:choose>
            <xsl:when test="position()=last()">
                <fo:inline font-weight="bold" font-size="8pt">
                    <xsl:value-of select="$name"/>:
                    <xsl:text> </xsl:text>
                </fo:inline>
                <xsl:value-of select="$score"/>
            </xsl:when>
            <xsl:otherwise>
                <fo:inline font-weight="bold" font-size="8pt">
                    <xsl:value-of select="$name"/>:
                    <xsl:text> </xsl:text>
                </fo:inline>
                <xsl:value-of select="$score"/>
                <xsl:text>; </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="y:skills">
        <xsl:apply-templates select="y:group"/>
    </xsl:template>

    <!-- Output skill groups for the character -->
    <xsl:template match="y:skills/y:group">
        <fo:block font-size="8pt" line-height="10pt" font-family="Times"
                space-after.optimum="0pt" text-align="start">

            <fo:inline font-weight="bold" font-style="italic" color="{$colour}">
                <xsl:value-of select="@name"/><xsl:text>: </xsl:text>
            </fo:inline>
            <xsl:apply-templates select="y:skill">
                <xsl:sort select="@name" data-type="text"/>
            </xsl:apply-templates>
        </fo:block>
    </xsl:template>

    <!-- Output skills within the skill group -->
    <xsl:template match="y:skills/y:group/y:skill">
        <xsl:if test="@score &gt; 0">
            <xsl:value-of select="@name"/>
            <xsl:text>- </xsl:text>
            <xsl:value-of select="@score"/>;
        </xsl:if>
    </xsl:template>

    <!--
        advantages

        List all the advantages the character has.
    -->

    <xsl:template match="y:statistics/y:advantages">
        <xsl:if test="y:advantage[@skill]">
            <fo:block font-weight="bold" font-size="{$font-small}" color="black">
                Techniques
            </fo:block>

            <fo:block font-size="{$font-small}" font-family="Times">
                <xsl:apply-templates select="y:advantage[@skill]"/>
            </fo:block>
        </xsl:if>

        <xsl:if test="y:advantage[not(@skill)]">
            <fo:block font-weight="bold" font-size="{$font-small}" color="black">
                Advantages
            </fo:block>

            <fo:block font-size="{$font-small}" font-family="Times">
                <xsl:apply-templates select="y:advantage[not(@skill)]"/>
            </fo:block>
        </xsl:if>
    </xsl:template>

    <xsl:template match="y:statistics/y:advantages/y:advantage">
        <xsl:if test="position() &gt; 1">
            <xsl:text>, </xsl:text>
        </xsl:if>

        <xsl:value-of select="@name"/>
        <xsl:if test="@skill">
            <xsl:text>[</xsl:text>
            <fo:inline font-style="italic">
                <xsl:value-of select="@skill"/>
            </fo:inline>
            <xsl:text>]</xsl:text>
        </xsl:if>

        <xsl:if test="@cost">
            (<xsl:value-of select="@cost"/>)
        </xsl:if>

        <xsl:if test="position() = last()">
            <xsl:text>.</xsl:text>
        </xsl:if>
    </xsl:template>

    <!-- Build up the table displaying combat statistics -->
    <xsl:template match="y:combat">
        <xsl:variable name="wpnList" select="y:weaponlist/@href"/>
        <xsl:variable name="armList" select="y:armourlist/@href"/>

        <fo:table table-layout="fixed">
            <fo:table-column column-width="4.5cm"/>
            <fo:table-column column-width="1cm"/>
            <fo:table-column column-width="1cm"/>
            <fo:table-column column-width="1.5cm"/>

            <fo:table-header font-size="10pt" font-family="Helvetica">
                <fo:table-row color="white" background-color="black">
                    <fo:table-cell>
                        <fo:block font-weight="bold">Weapon</fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block font-weight="bold">Atk</fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block font-weight="bold">Dfn</fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block font-weight="bold">Damage</fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-header>

            <fo:table-body font-size="8pt" font-family="Times">
                <xsl:apply-templates select="y:combatstyle" mode="inline"/>
            </fo:table-body>
        </fo:table>

        <xsl:apply-templates select="y:armourstyle" mode="inline"/>
    </xsl:template>

    <!-- For each combat style, work out the numbers -->
    <xsl:template match="y:combatstyle" mode="inline">
        <xsl:variable name="wpnList" select="../weaponlist/@href"/>
        <xsl:variable name="armList" select="../armourlist/@href"/>

        <xsl:variable name="styleName" select="@style"/>
        <xsl:variable name="skillName" select="@skill"/>
        <xsl:variable name="skillScore" select="../../skills/group/skill[@name=$skillName]/@score"/>
        <xsl:variable name="primaryName" select="primary"/>
        <xsl:variable name="secondaryName" select="secondary"/>
        <xsl:variable name="shieldName" select="shield"/>

        <fo:table-row>
            <fo:table-cell>
                <fo:block><xsl:value-of select="$styleName"/></fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block>
                    <xsl:apply-templates select="attack"/>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block>
                    <xsl:apply-templates select="defence"/>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell>
                 <fo:block>
                    <xsl:apply-templates select="damage"/>
                </fo:block>
           </fo:table-cell>
        </fo:table-row>
    </xsl:template>

    <xsl:template match="y:armourstyle" mode="inline">
        <fo:block font-size="8pt">
            <fo:inline font-weight="bold">Soak (<xsl:value-of select="@style"/>):</fo:inline>
            <xsl:apply-templates select="." mode="count">
                <xsl:with-param name="base" select="../../y:attributes/@soak"/>
            </xsl:apply-templates>
            (load:
            <xsl:apply-templates select="../y:armourstyle" mode="load">
                <xsl:with-param name="base" select="0"/>
            </xsl:apply-templates>)
        </fo:block>
        <xsl:if test="y:armour">
            <fo:block font-size="8pt">
                (<xsl:apply-templates select="." mode="list"/>)
            </fo:block>
        </xsl:if>
    </xsl:template>

    <!--
        Display character's wound, stun and fatigue levels.
        Listed in "OK / 0 / -1 / -3 / -6 / -10 / Fatal" style.
    -->
    <xsl:template match="y:attributes" mode="wounds">
        <fo:block space-after.optimum="0pt" font-size="8pt">
            <fo:inline font-weight="bold">Wounds: </fo:inline>
            <xsl:call-template name="y:output-wound-levels">
                <xsl:with-param name="size" select="@size"/>
                <xsl:with-param name="okay">OK</xsl:with-param>
                <xsl:with-param name="fatal">Fatal</xsl:with-param>
            </xsl:call-template>
        </fo:block>
        <fo:block space-after.optimum="0pt" font-size="8pt">
            <fo:inline font-weight="bold">Stuns: </fo:inline>
            <xsl:call-template name="y:output-wound-levels">
                <xsl:with-param name="size" select="@size"/>
                <xsl:with-param name="okay">OK</xsl:with-param>
                <xsl:with-param name="fatal">Oblivious</xsl:with-param>
            </xsl:call-template>
        </fo:block>
        <fo:block space-after.optimum="0pt" font-size="8pt">
            <fo:inline font-weight="bold">Fatigue: </fo:inline>
            <xsl:call-template name="y:output-wound-levels">
                <xsl:with-param name="size" select="2 + attribute[@name='health']/@score"/>
                <xsl:with-param name="okay">OK</xsl:with-param>
                <xsl:with-param name="fatal">Exhausted</xsl:with-param>
            </xsl:call-template>
        </fo:block>
    </xsl:template>

    <!-- Import a character into a yagsbook document, displaying it inline -->
    <xsl:template match="character" mode="oldstyle">


        <fo:block space-after.optimum="0pt">
            <fo:inline font-weight="bold">Soak: </fo:inline>
            <xsl:call-template name="character-soak"/>
        </fo:block>


        <xsl:if test="description/physical">
            <fo:block font-weight="bold" color="#00bb00">
            Physical Description
            </fo:block>

            <xsl:apply-templates select="description/physical"/>
        </xsl:if>

        <xsl:if test="description/background">
            <fo:block font-weight="bold" color="#00bb00">
            Background
            </fo:block>

            <xsl:apply-templates select="description/background"/>
        </xsl:if>

        <!-- Make sure we have a blank line after the character. Needed
             when displaying multiple characters.
          -->
        <fo:block space-after.optimum="10pt">
            <xsl:text></xsl:text>
        </fo:block>

    </xsl:template>



    <!--
      The following templates work out what a character's soak is, taking
      into account basic soak, plus any armour that is worn.
     -->
    <xsl:template name="armour-count2">
        <xsl:param name="index" select="0"/>
        <xsl:param name="total" select="0"/>

        <xsl:choose>
            <xsl:when test="$index = 0">
                +<xsl:value-of select="$total"/>
            </xsl:when>

            <xsl:when test="combat/armourstyle/armour[$index]/@protection">
                <xsl:call-template name="armour-count2">
                    <xsl:with-param name="index" select="$index - 1"/>
                    <xsl:with-param name="total" select="combat/armourstyle/armour[$index]/@protection + $total"/>
                </xsl:call-template>
            </xsl:when>

            <xsl:when test="combat/armourstyle/armour[$index]/@name">
                <xsl:variable name="href" select="combat/armourlist/@href"/>
                <xsl:variable name="name" select="combat/armourstyle/armour[$index]/@name"/>

                <xsl:variable name="soak">
                    <xsl:value-of select="document($href)//armour[@name=$name]/protection"/>
                </xsl:variable>
                <xsl:call-template name="armour-count2">
                    <xsl:with-param name="index" select="$index - 1"/>
                    <xsl:with-param name="total" select="$soak + $total"/>
                </xsl:call-template>
            </xsl:when>

            <xsl:otherwise>
                <xsl:call-template name="armour-count2">
                    <xsl:with-param name="index" select="$index - 1"/>
                    <xsl:with-param name="total" select="$total"/>
                </xsl:call-template>
            </xsl:otherwise>

        </xsl:choose>
    </xsl:template>

    <xsl:template name="armour-list2">
        <xsl:param name="index" select="0"/>
        <xsl:param name="list" select="m"/>

        <xsl:choose>
            <xsl:when test="$index = 1">
                <xsl:if test="string-length($list) &gt; 0">
                    <xsl:value-of select="$list"/>,
                </xsl:if>
                <xsl:value-of select="combat/armourstyle/armour[$index]/@name"/>
            </xsl:when>

            <xsl:otherwise>
                <xsl:variable name="all">
                    <xsl:if test="string-length($list) &gt; 0">
                        <xsl:value-of select="$list"/>,
                    </xsl:if>
                    <xsl:value-of select="combat/armourstyle/armour[$index]/@name"/>
                </xsl:variable>
                <xsl:call-template name="armour-list2">
                    <xsl:with-param name="index" select="$index - 1"/>
                    <xsl:with-param name="list" select="$all"/>
                </xsl:call-template>
            </xsl:otherwise>

        </xsl:choose>
    </xsl:template>


    <xsl:template name="character-soak">
        <xsl:variable name="baseSoak" select="attributes/@soak"/>

        <xsl:variable name="numItems" select="count(combat/armourstyle/armour)"/>

        <xsl:variable name="armourSoak">
            <xsl:if test="combat/armourstyle/armour">
                <xsl:call-template name="armour-count2">
                    <xsl:with-param name="index" select="$numItems"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="not(combat/armourstyle/armour)">0</xsl:if>
        </xsl:variable>

        <xsl:variable name="armourList">
            <xsl:if test="combat/armourstyle/armour">
                <xsl:call-template name="armour-list2">
                    <xsl:with-param name="index" select="$numItems"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:variable>

        <xsl:value-of select="$baseSoak + $armourSoak"/>
        <xsl:text> </xsl:text>
        (<xsl:value-of select="$armourList"/><xsl:text> </xsl:text>
        <xsl:value-of select="$armourSoak"/>)

    </xsl:template>








    <!--
      The following templates are all for rendering character templates.
      Character templates are examples of starting characters, with skills
      listed for different possible starting ages, as well as typical
      advantages and attributes.
     -->


    <!-- Display a character stored in an external file. -->
    <xsl:template match="import-character-template">
        <xsl:variable name="href" select="@href"/>

        <xsl:choose>
            <xsl:when test="@name">
                <xsl:variable name="tmpl" select="@name"/>
                <xsl:apply-templates select="document($href)//character-template[@name=$tmpl]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="document($href)//character-template">
                    <xsl:sort select="@name" data-type="text"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Render a character template -->
    <xsl:template match="character-template">
        <fo:block
                font-weight="bold"
                font-style="italic"
                color="{$colour}"
                font-size="12pt"
                font-family="sans-serif"
                line-height="12pt"
                space-after.optimum="0pt"
                space-before.optimum="12pt"
                text-align="start">

            <xsl:value-of select="@name"/>
        </fo:block>

        <fo:block
            font-size="10pt"
            font-family="Times"
            line-height="12pt"
            space-after.optimum="0pt">

            <xsl:apply-templates select="description/background"/>
        </fo:block>

        <xsl:apply-templates select="attributes"/>

        <xsl:apply-templates select="skills[1]/group[@type='talents']" mode="talents"/>

        <xsl:if test="advantages">
            <fo:block font-weight="bold" font-style="italic" color="{$colour}"
                    font-size="10pt" line-height="12pt" space-after.optimum="0pt"
                    text-align="start">
                <xsl:text>Advantages and Disadvantages</xsl:text>
            </fo:block>

            <fo:block>
                <xsl:for-each select="advantages/advantage">
                    <xsl:value-of select="@name"/>
                    <xsl:value-of select="@cost"/>
                    <xsl:text>; </xsl:text>
                </xsl:for-each>
            </fo:block>
        </xsl:if>

        <xsl:apply-templates select="skills[1]/group[@type='knowledges']"/>

        <xsl:apply-templates select="skills[@age]" mode="byage">
            <xsl:sort select="@age" data-type="number"/>
        </xsl:apply-templates>

        <xsl:if test="equipment">
            <fo:block font-weight="bold" font-style="italic" color="{$colour}"
                    font-size="10pt" line-height="12pt" space-after.optimum="0pt"
                    text-align="start">
                Equipment
            </fo:block>
            <fo:block>
                <xsl:for-each select="equipment/item">
                    <xsl:sort select="@name" data-type="text"/>
                    <xsl:value-of select="@name"/>;<xsl:text> </xsl:text>
                </xsl:for-each>
            </fo:block>
        </xsl:if>

    </xsl:template>



    <xsl:template match="attributes">
       <fo:table space-before.optimum="0pt" table-layout="fixed">
            <fo:table-column column-width="1cm"/>
            <fo:table-column column-width="1cm"/>
            <fo:table-column column-width="1cm"/>
            <fo:table-column column-width="1cm"/>
            <fo:table-column column-width="1cm"/>
            <fo:table-column column-width="1cm"/>
            <fo:table-column column-width="1cm"/>
            <fo:table-column column-width="1cm"/>

            <fo:table-header>
                <fo:table-row color="black" background-color="{$darkcolour}" font-weight="bold">
                    <fo:table-cell><fo:block>Str</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>Hea</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>Agi</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>Dex</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>Per</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>Int</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>Emp</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>Wil</fo:block></fo:table-cell>
                </fo:table-row>
            </fo:table-header>

            <fo:table-body font-size="10pt" font-family="Times">
                <fo:table-row>
                    <fo:table-cell><fo:block>
                    <xsl:value-of select="attribute[@name='strength']/@score"/>
                    </fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>
                    <xsl:value-of select="attribute[@name='health']/@score"/>
                    </fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>
                    <xsl:value-of select="attribute[@name='agility']/@score"/>
                    </fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>
                    <xsl:value-of select="attribute[@name='dexterity']/@score"/>
                    </fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>
                    <xsl:value-of select="attribute[@name='perception']/@score"/>
                    </fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>
                    <xsl:value-of select="attribute[@name='intelligence']/@score"/>
                    </fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>
                    <xsl:value-of select="attribute[@name='empathy']/@score"/>
                    </fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>
                    <xsl:value-of select="attribute[@name='will']/@score"/>
                    </fo:block></fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>


    <xsl:template match="skills/group" mode="talents">
        <fo:table table-layout="fixed">
            <fo:table-column column-width="1cm"/>
            <fo:table-column column-width="1cm"/>
            <fo:table-column column-width="1cm"/>
            <fo:table-column column-width="1cm"/>
            <fo:table-column column-width="1cm"/>
            <fo:table-column column-width="1cm"/>
            <fo:table-column column-width="1cm"/>
            <fo:table-column column-width="1cm"/>

            <fo:table-header>
                <fo:table-row color="black" background-color="{$darkcolour}" font-weight="bold">
                    <fo:table-cell><fo:block>At</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>Aw</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>Br</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>Ch</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>Gu</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>Sl</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>St</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>Th</fo:block></fo:table-cell>
                </fo:table-row>
            </fo:table-header>

            <fo:table-body font-size="10pt" font-family="Times">
                <fo:table-row>
                    <fo:table-cell><fo:block>
                    <xsl:value-of select="skill[@name='Athletics']/@score"/>
                    </fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>
                    <xsl:value-of select="skill[@name='Awareness']/@score"/>
                    </fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>
                    <xsl:value-of select="skill[@name='Brawl']/@score"/>
                    </fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>
                    <xsl:value-of select="skill[@name='Charm']/@score"/>
                    </fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>
                    <xsl:value-of select="skill[@name='Guile']/@score"/>
                    </fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>
                    <xsl:value-of select="skill[@name='Sleight']/@score"/>
                    </fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>
                    <xsl:value-of select="skill[@name='Stealth']/@score"/>
                    </fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>
                    <xsl:value-of select="skill[@name='Throw']/@score"/>
                    </fo:block></fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>


</xsl:stylesheet>

