<?xml version="1.0"?>

<!-- These templates are for inline bestiary descriptions -->

<xsl:stylesheet version="1.0"
    xmlns:yb="http://yagsbook.sourceforge.net/xml"
    xmlns:y="http://yagsbook.sourceforge.net/xml/yags"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format">


    <xsl:template match="yb:beast/y:statistics" mode="inline">
        <fo:block padding="1mm"
                  space-after="{$font-medium}">

            <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="10mm"/>
                <fo:table-column column-width="12mm"/>
                <fo:table-column column-width="8mm"/>
                <fo:table-column column-width="8mm"/>
                <fo:table-column column-width="8mm"/>
                <fo:table-column column-width="8mm"/>
                <fo:table-column column-width="8mm"/>
                <fo:table-column column-width="8mm"/>
                <fo:table-column column-width="8mm"/>

                <fo:table-header>
                    <fo:table-row font-size="{$font-small}" font-weight="bold">
                        <fo:table-cell><fo:block>Size</fo:block></fo:table-cell>
                        <fo:table-cell><fo:block>Str</fo:block></fo:table-cell>
                        <fo:table-cell><fo:block>Hea</fo:block></fo:table-cell>
                        <fo:table-cell><fo:block>Agi</fo:block></fo:table-cell>
                        <fo:table-cell><fo:block>Dex</fo:block></fo:table-cell>
                        <fo:table-cell><fo:block>Per</fo:block></fo:table-cell>
                        <fo:table-cell><fo:block>Int</fo:block></fo:table-cell>
                        <fo:table-cell><fo:block>Cha</fo:block></fo:table-cell>
                        <fo:table-cell><fo:block>Wil</fo:block></fo:table-cell>
                    </fo:table-row>
                </fo:table-header>

                <fo:table-body font-size="{$font-small}" font-family="{$font-body}">
                    <fo:table-row>
                        <fo:table-cell><fo:block>
                        <xsl:value-of select="y:attributes/@size"/>
                        </fo:block></fo:table-cell>
                        <fo:table-cell><fo:block>
                        <xsl:value-of select="y:attributes/y:attribute[@name='strength']/@score"/>
                        <xsl:if test="y:attributes/y:attribute[@name='strength']/@half">
                            /<xsl:value-of select="y:attributes/y:attribute[@name='strength']/@half"/>
                        </xsl:if>
                        </fo:block></fo:table-cell>
                        <fo:table-cell><fo:block>
                        <xsl:value-of select="y:attributes/y:attribute[@name='health']/@score"/>
                        </fo:block></fo:table-cell>
                        <fo:table-cell><fo:block>
                        <xsl:value-of select="y:attributes/y:attribute[@name='agility']/@score"/>
                        </fo:block></fo:table-cell>
                        <fo:table-cell><fo:block>
                        <xsl:value-of select="y:attributes/y:attribute[@name='dexterity']/@score"/>
                        </fo:block></fo:table-cell>
                        <fo:table-cell><fo:block>
                        <xsl:value-of select="y:attributes/y:attribute[@name='perception']/@score"/>
                        </fo:block></fo:table-cell>
                        <fo:table-cell><fo:block>
                        <xsl:value-of select="y:attributes/y:attribute[@name='intelligence']/@score"/>
                        </fo:block></fo:table-cell>
                        <fo:table-cell><fo:block>
                        <xsl:value-of select="y:attributes/y:attribute[@name='empathy']/@score"/>
                        </fo:block></fo:table-cell>
                        <fo:table-cell><fo:block>
                        <xsl:value-of select="y:attributes/y:attribute[@name='will']/@score"/>
                        </fo:block></fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>

            <xsl:if test="y:advantages">
                <fo:block font-weight="bold" color="black" font-size="{$font-medium}" font-style="italic">
                    Advantages
                </fo:block>
                <fo:block font-size="{$font-small}">
                    <xsl:for-each select="y:advantages/y:advantage">
                        <xsl:value-of select="@name"/>
                        <xsl:if test="@target">
                            (<xsl:value-of select="@target"/>)
                        </xsl:if>
                        <xsl:if test="@score">
                            (<xsl:value-of select="@score"/>)
                        </xsl:if>
                        <xsl:value-of select="@cost"/>
                        <xsl:text>; </xsl:text>
                    </xsl:for-each>
                </fo:block>
            </xsl:if>

            <xsl:if test="y:passions">
                <fo:block font-size="{$font-medium}" font-style="italic"
                          font-weight="bold" color="black">
                    Passions
                </fo:block>

                <fo:block font-size="{$font-small}">
                    <xsl:for-each select="y:passions/y:passion">
                        <xsl:value-of select="@name"/>
                        <xsl:if test="@target">
                            (<xsl:value-of select="@target"/>)
                        </xsl:if>
                        <xsl:if test="@score">
                            (<xsl:value-of select="@score"/>)
                        </xsl:if>
                        <xsl:text>; </xsl:text>
                    </xsl:for-each>
                </fo:block>
            </xsl:if>

            <fo:block font-weight="bold" color="black" font-size="{$font-medium}" font-style="italic">
                Skills
            </fo:block>
            <xsl:apply-templates select="y:skills/y:group[@type='talents']" mode="beast-inline"/>
            <xsl:apply-templates select="y:skills/y:group[@type='languages']" mode="beast-inline"/>
            <xsl:apply-templates select="y:skills/y:group[@type='skills']" mode="beast-inline"/>

            <xsl:if test="combat">
                <fo:table table-layout="fixed">
                    <fo:table-column column-width="3.5cm"/>
                    <fo:table-column column-width="1cm"/>
                    <fo:table-column column-width="1cm"/>
                    <fo:table-column column-width="1cm"/>
                    <fo:table-column column-width="1.8cm"/>

                    <fo:table-body font-size="10pt" font-family="{$font-body}">
                        <fo:table-row>
                            <fo:table-cell>
                                <fo:block font-weight="bold">Weapon</fo:block>
                            </fo:table-cell>
                            <fo:table-cell>
                                <fo:block font-weight="bold">Init</fo:block>
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
                    </fo:table-body>
                </fo:table>
                <xsl:apply-templates select="combat/combatstyle"/>
            </xsl:if>

            <xsl:apply-templates select="combat/armourstyle" mode="inline"/>
            <!--
            <xsl:if test="attributes/@soak">
                <fo:block space-after="0pt" font-size="{$font-small}">
                    <fo:inline font-weight="bold">Soak: </fo:inline>
                    <xsl:call-template name="character-soak"/>
                </fo:block>
            </xsl:if>
-->
            <xsl:if test="attributes/@size">
                <fo:block space-after="0pt" font-size="{$font-small}">
                    <fo:inline font-weight="bold">Wounds: </fo:inline>
                    <xsl:call-template name="y:output-wound-levels">
                        <xsl:with-param name="size" select="attributes/@size"/>
                        <xsl:with-param name="okay">OK</xsl:with-param>
                        <xsl:with-param name="fatal">Fatal</xsl:with-param>
                    </xsl:call-template>
                </fo:block>
                <fo:block space-after="0pt" font-size="{$font-small}">
                    <fo:inline font-weight="bold">Stuns: </fo:inline>
                    <xsl:call-template name="y:output-wound-levels">
                        <xsl:with-param name="size" select="attributes/@size"/>
                        <xsl:with-param name="okay">OK</xsl:with-param>
                        <xsl:with-param name="fatal">Out</xsl:with-param>
                    </xsl:call-template>
                </fo:block>
            </xsl:if>

            <fo:block space-after="0pt" font-size="{$font-small}">
                <fo:inline font-weight="bold">Fatigue: </fo:inline>
                <xsl:call-template name="y:output-wound-levels">
                    <xsl:with-param name="size" select="2 + attributes/attribute[@name='health']/@score"/>
                    <xsl:with-param name="okay">OK</xsl:with-param>
                    <xsl:with-param name="fatal">Sleep</xsl:with-param>
                </xsl:call-template>
            </fo:block>

            <xsl:if test="description/physical">
                <fo:block font-weight="bold" color="{$colour}" font-size="{$font-medium}">
                    Physical Description
                </fo:block>

                <xsl:apply-templates select="description/physical"/>
            </xsl:if>

            <xsl:if test="description/powers">
                <fo:block font-weight="bold" color="{$colour}" font-size="{$font-medium}">
                    Powers
                </fo:block>

                <xsl:apply-templates select="description/powers"/>
            </xsl:if>

            <xsl:if test="description/social">
                <fo:block font-weight="bold" color="{$colour}" font-size="{$font-medium}">
                    Society
                </fo:block>

                <xsl:apply-templates select="description/social"/>
            </xsl:if>

            <xsl:if test="description/legends">
                <fo:block font-weight="bold" color="{$colour}" font-size="{$font-medium}">
                    Legends
                </fo:block>

                <xsl:apply-templates select="description/legends"/>
            </xsl:if>

            <xsl:if test="description/tactics">
                <fo:block font-weight="bold" color="{$colour}" font-size="{$font-medium}">
                    Tactics
                </fo:block>

                <xsl:apply-templates select="description/tactics"/>
            </xsl:if>


        </fo:block>
    </xsl:template>


    <xsl:template match="y:skills/y:group" mode="beast-inline">
        <fo:block font-size="{$font-small}">
            <fo:inline font-weight="bold"><xsl:value-of select="@name"/>: </fo:inline>
            <xsl:for-each select="y:skill">
                <xsl:value-of select="@name"/> (<xsl:value-of select="@score"/>);
            </xsl:for-each>
        </fo:block>
    </xsl:template>





<!--
    <xsl:template match="beast/combat/combatstyle">
        <xsl:variable name="skillName" select="@skill"/>
        <xsl:variable name="skillScore" select="../../skills/group/skill[@name=$skillName]/@score"/>
        <xsl:variable name="primaryName" select="primary"/>
        <xsl:variable name="secondaryName" select="secondary"/>
        <xsl:variable name="shieldName" select="shield"/>

        <xsl:variable name="iniAttr">
            <xsl:variable name="attrName" select="initiative/@attribute"/>
            <xsl:variable name="attrScore" select="../../attributes/attribute[@name=$attrName]/@score"/>
            <xsl:value-of select="$attrScore * $skillScore"/>
        </xsl:variable>

        <xsl:variable name="atkAttr">
            <xsl:variable name="attrName" select="attack/@attribute"/>
            <xsl:variable name="attrScore" select="../../attributes/attribute[@name=$attrName]/@score"/>
            <xsl:value-of select="$attrScore * $skillScore"/>
        </xsl:variable>

        <xsl:variable name="dfnAttr">
            <xsl:variable name="attrName" select="defence/@attribute"/>
            <xsl:variable name="attrScore" select="../../attributes/attribute[@name=$attrName]/@score"/>
            <xsl:value-of select="$attrScore * $skillScore"/>
        </xsl:variable>

        <xsl:variable name="dmgAttr">
            <xsl:variable name="attrScore">
                <xsl:choose>
                    <xsl:when test="../../attributes/attribute[@name='strength']/@half">
                        <xsl:value-of select="../../attributes/attribute[@name='strength']/@half"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="../../attributes/attribute[@name='strength']/@score"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:value-of select="$attrScore * 4"/>
        </xsl:variable>

        <xsl:variable name="iniBonus">
             <xsl:choose>
                <xsl:when test="initiative/@bonus">
                    <xsl:value-of select="initiative/@bonus"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="y:weapon-bonus">
                        <xsl:with-param name="href" select="../weaponlist/@href"/>
                        <xsl:with-param name="primary" select="$primaryName"/>
                        <xsl:with-param name="secondary" select="$secondaryName"/>
                        <xsl:with-param name="shield" select="$shieldName"/>
                        <xsl:with-param name="attribute" select="'initiative'"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="atkBonus">
             <xsl:choose>
                <xsl:when test="attack/@bonus">
                    <xsl:value-of select="attack/@bonus"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="weapon-bonus">
                        <xsl:with-param name="href" select="../weaponlist/@href"/>
                        <xsl:with-param name="primary" select="$primaryName"/>
                        <xsl:with-param name="secondary" select="$secondaryName"/>
                        <xsl:with-param name="shield" select="$shieldName"/>
                        <xsl:with-param name="attribute" select="'attack'"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="dfnBonus">
             <xsl:choose>
                <xsl:when test="defence/@bonus">
                    <xsl:value-of select="defence/@bonus"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="weapon-bonus">
                        <xsl:with-param name="href" select="../weaponlist/@href"/>
                        <xsl:with-param name="primary" select="$primaryName"/>
                        <xsl:with-param name="secondary" select="$secondaryName"/>
                        <xsl:with-param name="shield" select="$shieldName"/>
                        <xsl:with-param name="attribute" select="'defence'"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="dmgBonus">
             <xsl:choose>
                <xsl:when test="damage/@bonus">
                    <xsl:value-of select="damage/@bonus"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="weapon-bonus">
                        <xsl:with-param name="href" select="../weaponlist/@href"/>
                        <xsl:with-param name="primary" select="$primaryName"/>
                        <xsl:with-param name="secondary" select="$secondaryName"/>
                        <xsl:with-param name="shield" select="$shieldName"/>
                        <xsl:with-param name="attribute" select="'damage'"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <fo:table table-layout="fixed">
            <fo:table-column column-width="3.5cm"/>
            <fo:table-column column-width="1cm"/>
            <fo:table-column column-width="1cm"/>
            <fo:table-column column-width="1cm"/>
            <fo:table-column column-width="1.8cm"/>

            <fo:table-body font-size="10pt" font-family="{$font-body}">
                <fo:table-row>
                    <fo:table-cell>
                        <fo:block font-weight="bold"><xsl:value-of select="@style"/></fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block><xsl:value-of select="$iniAttr + $iniBonus"/></fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block><xsl:value-of select="$atkAttr + $atkBonus"/></fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block><xsl:value-of select="$dfnAttr + $dfnBonus"/></fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block>
                            <xsl:value-of select="$dmgAttr + $dmgBonus"/>
                            <xsl:if test="damage/@type">
                                (<xsl:value-of select="damage/@type"/>)
                            </xsl:if>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        <xsl:value-of select="@style"/>
        <xsl:value-of select="$iniBonus"/>
        </fo:table>
    </xsl:template>
-->
</xsl:stylesheet>

