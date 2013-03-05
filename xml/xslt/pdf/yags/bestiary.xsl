<?xml version="1.0"?>

<!-- These templates are for inline bestiary descriptions -->

<xsl:stylesheet version="1.0"
    xmlns:yb="http://yagsbook.sourceforge.net/xml"
    xmlns:y="http://yagsbook.sourceforge.net/xml/yags"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format">


    <xsl:template match="y:attributes" mode="beast-inline">
        <fo:table table-layout="fixed" width="100%" space-after="{$font-medium}">
            <fo:table-column column-width="9mm"/>
            <fo:table-column column-width="9mm"/>
            <fo:table-column column-width="9mm"/>
            <fo:table-column column-width="9mm"/>
            <fo:table-column column-width="9mm"/>
            <fo:table-column column-width="9mm"/>
            <fo:table-column column-width="8mm"/>
            <fo:table-column column-width="9mm"/>
            <fo:table-column column-width="9mm"/>
            <fo:table-column column-width="6mm"/>

            <fo:table-header>
                <fo:table-row font-size="{$font-medium}" font-weight="bold">
                    <fo:table-cell><fo:block>Sz</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>S</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>H</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>A</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>D</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>P</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>I</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>E</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>W</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>Mv</fo:block></fo:table-cell>
                </fo:table-row>
            </fo:table-header>

            <xsl:variable name="size" select="@size"/>
            <xsl:variable name="strength" select="y:attribute[@name='strength']/@score"/>
            <xsl:variable name="health" select="y:attribute[@name='health']/@score"/>
            <xsl:variable name="agility" select="y:attribute[@name='agility']/@score"/>
            <xsl:variable name="dexterity" select="y:attribute[@name='dexterity']/@score"/>
            <xsl:variable name="perception" select="y:attribute[@name='perception']/@score"/>
            <xsl:variable name="intelligence" select="y:attribute[@name='intelligence']/@score"/>
            <xsl:variable name="empathy" select="y:attribute[@name='empathy']/@score"/>
            <xsl:variable name="will" select="y:attribute[@name='will']/@score"/>

            <xsl:variable name="move" select="$size + $strength + $agility + 1"/>

            <fo:table-body font-size="{$font-medium}" font-family="{$font-body}">
                <fo:table-row>
                    <fo:table-cell><fo:block>
                        <xsl:value-of select="$size"/>
                        <xsl:if test="../y:advantages/y:advantage[@name='Tiny']">*</xsl:if>
                    </fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>
                    <xsl:value-of select="$strength"/>
                    <xsl:if test="../y:advantages/y:advantage[@name='Weak']">*</xsl:if>
                    <xsl:if test="y:attribute[@name='strength']/@half">
                        /<xsl:value-of select="y:attribute[@name='strength']/@half"/>
                    </xsl:if>
                    </fo:block></fo:table-cell>
                    <fo:table-cell><fo:block><xsl:value-of select="$health"/></fo:block></fo:table-cell>
                    <fo:table-cell><fo:block><xsl:value-of select="$agility"/></fo:block></fo:table-cell>
                    <fo:table-cell><fo:block><xsl:value-of select="$dexterity"/></fo:block></fo:table-cell>
                    <fo:table-cell><fo:block><xsl:value-of select="$perception"/></fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>
                        <xsl:value-of select="$intelligence"/>
                        <xsl:if test="../y:advantages/y:advantage[@name='Animal']">*</xsl:if>
                    </fo:block></fo:table-cell>
                    <fo:table-cell><fo:block><xsl:value-of select="$empathy"/></fo:block></fo:table-cell>
                    <fo:table-cell><fo:block><xsl:value-of select="$will"/></fo:block></fo:table-cell>
                    <fo:table-cell><fo:block><xsl:value-of select="$move"/></fo:block></fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>


    <xsl:template match="yb:beast/y:statistics" mode="inline">
        <fo:block padding="1mm"
                  space-after="{$font-medium}">

            <xsl:apply-templates select="y:attributes" mode="beast-inline"/>

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

            <xsl:if test="y:traits">
                <fo:block font-size="{$font-medium}" font-style="italic"
                          font-weight="bold" color="black">
                    Traits
                </fo:block>

                <fo:block font-size="{$font-small}">
                    <xsl:for-each select="y:traits/y:trait">
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

            <xsl:if test="y:combat">
                <fo:block  keep-together.within-column="always">
                    <fo:table table-layout="fixed" width="100%" font-size="{$font-small}">
                        <fo:table-column column-width="3.5cm"/>
                        <fo:table-column column-width="1.5cm"/>
                        <fo:table-column column-width="1.5cm"/>
                        <fo:table-column column-width="1.8cm"/>

                        <fo:table-body font-size="10pt" font-family="{$font-body}">
                            <fo:table-row>
                                <fo:table-cell>
                                    <fo:block font-weight="bold" font-size="{$font-small}">Weapon</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block font-weight="bold" font-size="{$font-small}">Attack</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block font-weight="bold" font-size="{$font-small}">Defence</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block font-weight="bold" font-size="{$font-small}">Damage</fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                            <xsl:apply-templates select="y:combat/y:combatstyle" mode="beast-inline"/>
                        </fo:table-body>
                    </fo:table>
                </fo:block>
            </xsl:if>

            <xsl:apply-templates select="y:combat/y:armourstyle" mode="beast-inline"/>
            <!--
            <xsl:if test="attributes/@soak">
                <fo:block space-after="0pt" font-size="{$font-small}">
                    <fo:inline font-weight="bold">Soak: </fo:inline>
                    <xsl:call-template name="character-soak"/>
                </fo:block>
            </xsl:if>
-->
            <xsl:if test="y:attributes/@size">
                <xsl:variable name="woundlevels">
                    <xsl:choose>
                        <xsl:when test="y:advantages/y:advantage[@name='Undead']">
                            <xsl:value-of select="y:attributes/@size * 2"/>
                        </xsl:when>
                        <xsl:otherwise><xsl:value-of select="y:attributes/@size"/></xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <fo:block space-after="0pt" font-size="{$font-small}">
                    <fo:inline font-weight="bold">Wounds: </fo:inline>
                    <xsl:call-template name="y:output-wound-levels">
                        <xsl:with-param name="size" select="$woundlevels"/>
                        <xsl:with-param name="okay">OK</xsl:with-param>
                        <xsl:with-param name="fatal">Fatal</xsl:with-param>
                    </xsl:call-template>
                </fo:block>
                <fo:block space-after="0pt" font-size="{$font-small}">
                    <fo:inline font-weight="bold">Stuns: </fo:inline>
                    <xsl:call-template name="y:output-wound-levels">
                        <xsl:with-param name="size" select="$woundlevels"/>
                        <xsl:with-param name="okay">OK</xsl:with-param>
                        <xsl:with-param name="fatal">Out</xsl:with-param>
                    </xsl:call-template>
                </fo:block>
            </xsl:if>

            <fo:block space-after="0pt" font-size="{$font-small}">
                <fo:inline font-weight="bold">Fatigue: </fo:inline>
                <xsl:call-template name="y:output-wound-levels">
                    <xsl:with-param name="size" select="2 + y:attributes/y:attribute[@name='health']/@score"/>
                    <xsl:with-param name="okay">OK</xsl:with-param>
                    <xsl:with-param name="fatal">Sleep</xsl:with-param>
                </xsl:call-template>
            </fo:block>

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


    <xsl:template match="y:combatstyle" mode="beast-inline">
        <xsl:variable name="skillName" select="@skill"/>
        <xsl:variable name="skillScore" select="../../y:skills/y:group/y:skill[@name=$skillName]/@score"/>

        <xsl:variable name="atkAttr">
            <xsl:variable name="attrName" select="y:attack/@attribute"/>
            <xsl:variable name="attrScore" select="../../y:attributes/y:attribute[@name=$attrName]/@score"/>
            <xsl:value-of select="$attrScore * $skillScore"/>
        </xsl:variable>

        <xsl:variable name="dfnAttr">
            <xsl:variable name="attrName" select="y:defence/@attribute"/>
            <xsl:variable name="attrScore" select="../../y:attributes/y:attribute[@name=$attrName]/@score"/>
            <xsl:value-of select="$attrScore * $skillScore"/>
        </xsl:variable>

        <xsl:variable name="dmgAttr">
            <xsl:variable name="attrScore">
                <xsl:choose>
                    <xsl:when test="../../y:attributes/y:attribute[@name='strength']/@half">
                        <xsl:value-of select="../../y:attributes/y:attribute[@name='strength']/@half"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="../../y:attributes/y:attribute[@name='strength']/@score"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:value-of select="$attrScore * 4"/>
        </xsl:variable>

        <xsl:variable name="atkBonus">
            <xsl:value-of select="translate(y:attack/@bonus, '+', '')"/>
        </xsl:variable>

        <xsl:variable name="dfnBonus">
            <xsl:value-of select="translate(y:defence/@bonus, '+', '')"/>
        </xsl:variable>

        <xsl:variable name="dmgBonus">
            <xsl:value-of select="translate(y:damage/@bonus, '+', '')"/>
        </xsl:variable>

        <fo:table-row>
            <fo:table-cell>
                <fo:block font-weight="bold" font-style="italic" font-size="{$font-small}"><xsl:value-of select="@style"/></fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block font-size="{$font-small}"><xsl:value-of select="number($atkAttr) + number($atkBonus)"/></fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block font-size="{$font-small}"><xsl:value-of select="$dfnAttr + $dfnBonus"/></fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block font-size="{$font-small}">
                    <xsl:value-of select="$dmgAttr + $dmgBonus"/>
                    <xsl:if test="y:damage/@type">
                        (<xsl:value-of select="y:damage/@type"/>)
                    </xsl:if>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>

</xsl:stylesheet>

