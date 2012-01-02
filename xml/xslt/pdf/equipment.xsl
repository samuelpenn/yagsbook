<?xml version="1.0"?>
<!--
    Version: $Revision: 1.22 $
 -->

<xsl:stylesheet xmlns:yb="http://yagsbook.sourceforge.net/xml"
                xmlns:y="http://yagsbook.sourceforge.net/xml/yags"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">

    <xsl:include href="../share/yags/equipment.xsl"/>
    <xsl:include href="yags/vehicles.xsl"/>

    <xsl:template match="y:import-weaponlist">
        <xsl:variable name="filter">
            <xsl:choose>
                <xsl:when test="@importance">
                    <xsl:value-of select="@importance"/>
                </xsl:when>
                <xsl:otherwise>2</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="href" select="@href"/>

        <xsl:variable name="items" select="document(y:list)/yb:equipment/yb:item"/>

        <!--
            If we are part of a wide section (i.e. one column page rather
            than two column pages) then note this, since we can include
            more information in the table.
        -->

        <xsl:variable name="wide">
            <xsl:choose>
                <xsl:when test="ancestor::yb:sect1/@format='wide'">true</xsl:when>
                <xsl:otherwise>false</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:for-each select="y:category">
            <xsl:variable name="category" select="."/>

            <xsl:choose>
                <xsl:when test="$wide='true'">
                    <fo:table table-layout="fixed" space-after="{$font-small}">
                        <fo:table-column column-width="30mm"/>
                        <fo:table-column column-width="7mm"/>
                        <fo:table-column column-width="7mm"/>
                        <fo:table-column column-width="10mm"/>
                        <fo:table-column column-width="7mm"/> <!-- Load -->
                        <fo:table-column column-width="6mm"/>
                        <fo:table-column column-width="6mm"/>
                        <fo:table-column column-width="6mm"/> <!-- RoF -->
                        <fo:table-column column-width="6mm"/> <!-- Rounds -->
                        <fo:table-column column-width="7mm"/> <!-- Recoil -->
                        <fo:table-column column-width="7mm"/> <!-- Inc -->
                        <fo:table-column column-width="8mm"/> <!-- Short -->
                        <fo:table-column column-width="8mm"/> <!-- Medium -->
                        <fo:table-column column-width="8mm"/> <!-- Long -->
                        <fo:table-column column-width="16mm"/> <!-- Class -->
                        <fo:table-column column-width="5mm"/> <!-- TL -->
                        <fo:table-column column-width="5mm"/> <!-- LC -->
                        <fo:table-column column-width="25mm"/> <!-- Notes -->

                        <fo:table-header font-size="{$font-small}" font-family="{$font-heading}">
                            <fo:table-row>
                                <fo:table-cell>
                                    <fo:block color="white"
                                              background-color="black">
                                        <xsl:value-of select="$category"/>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block color="white"
                                              background-color="black">Atk</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block color="white"
                                              background-color="black">Dfn</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block color="white"
                                              background-color="black">Dmg</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block color="white"
                                              background-color="black">Load</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block color="white"
                                              background-color="black">Str</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block color="white"
                                              background-color="black">Rch</fo:block>
                                </fo:table-cell>

                                <fo:table-cell>
                                    <fo:block color="white"
                                              background-color="black">RoF</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block color="white"
                                              background-color="black">Cap</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block color="white"
                                              background-color="black">Rcl</fo:block>
                                </fo:table-cell>

                                <fo:table-cell>
                                    <fo:block color="white"
                                              background-color="black">Inc</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block color="white"
                                              background-color="black">Sh</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block color="white"
                                              background-color="black">Md</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block color="white"
                                              background-color="black">Lg</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block color="white"
                                              background-color="black">Class</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block color="white"
                                              background-color="black">TL</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block color="white"
                                              background-color="black">LC</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block color="white"
                                              background-color="black">Notes</fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </fo:table-header>

                        <fo:table-body font-size="{$font-small}" font-family="{$font-body}">
                            <xsl:apply-templates select="$items/y:weapon[y:category=$category]" mode="wide">
                                <xsl:sort select="../@name" data-type="text"/>
                            </xsl:apply-templates>
                        </fo:table-body>
                    </fo:table>
                </xsl:when>

                <xsl:otherwise>
                    <fo:table table-layout="fixed" space-after="{$font-small}">
                        <fo:table-column column-width="30mm"/>
                        <fo:table-column column-width="7mm"/>
                        <fo:table-column column-width="7mm"/>
                        <fo:table-column column-width="10mm"/>
                        <fo:table-column column-width="7mm"/>
                        <fo:table-column column-width="7mm"/>
                        <fo:table-column column-width="10mm"/>

                        <fo:table-header font-size="{$font-small}" font-family="{$font-heading}">
                            <fo:table-row>
                                <fo:table-cell>
                                    <fo:block color="white"
                                              background-color="black">
                                        <xsl:value-of select="$category"/>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block color="white"
                                              background-color="black">Atk</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block color="white"
                                              background-color="black">Dfn</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block color="white"
                                              background-color="black">Dmg</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block color="white"
                                                background-color="black">Load</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block color="white"
                                                background-color="black">Str</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block color="white"
                                                background-color="black">Reach</fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </fo:table-header>

                        <fo:table-body font-size="{$font-small}" font-family="{$font-body}">
                            <xsl:apply-templates select="$items/y:weapon[y:category=$category]" mode="brief">
                                <xsl:sort select="../@name" data-type="text"/>
                            </xsl:apply-templates>
                        </fo:table-body>
                    </fo:table>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="yb:item/y:weapon" mode="brief">
        <xsl:variable name="bgcolour">
            <xsl:choose>
                <xsl:when test="position() mod 2 = 1">
                    <xsl:value-of select="$darkcolour"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$lightcolour"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <fo:table-row background-color="{$bgcolour}" font-size="{$font-small}">
            <fo:table-cell>
                <fo:block text-align="left">
                    <xsl:value-of select="../@name"/>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block><xsl:value-of select="y:combat/y:attack"/></fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block><xsl:value-of select="y:combat/y:defence"/></fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block>
                    <xsl:value-of select="y:combat/y:damage"/>
                    <xsl:if test="y:combat/y:damage[@type='stun']">s</xsl:if>
                    <xsl:if test="y:combat/y:damage[@type='mixed']">m</xsl:if>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block><xsl:value-of select="y:load"/></fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block><xsl:value-of select="y:strength"/></fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block><xsl:value-of select="y:reach"/></fo:block>
            </fo:table-cell>
        </fo:table-row>
        <xsl:if test="y:range">
            <fo:table-row background-color="{$bgcolour}" font-size="{$font-small}">
                <fo:table-cell>
                    <fo:block></fo:block>
                </fo:table-cell>
                <fo:table-cell number-columns-spanned="6">
                    <fo:block>
                        Inc: <xsl:value-of select="y:range/y:increment"/>
                        Ranges:
                        <xsl:value-of select="y:range/y:short"/> /
                        <xsl:value-of select="y:range/y:medium"/> /
                        <xsl:value-of select="y:range/y:long"/>
                    </fo:block>
                </fo:table-cell>
            </fo:table-row>
        </xsl:if>
    </xsl:template>

    <!--
        Display a weapon chart on a double width column - i.e. across full
        spread of page. This means we can display all available information.
    -->
    <xsl:template match="yb:item/y:weapon" mode="wide">
        <xsl:variable name="bgcolour">
            <xsl:choose>
                <xsl:when test="position() mod 2 = 1">
                    <xsl:value-of select="$darkcolour"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$lightcolour"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <fo:table-row background-color="{$bgcolour}" font-size="{$font-small}">
            <fo:table-cell>
                <fo:block text-align="left">
                    <xsl:value-of select="../@name"/>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block><xsl:value-of select="y:combat/y:attack"/></fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block><xsl:value-of select="y:combat/y:defence"/></fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block>
                    <xsl:value-of select="y:combat/y:damage"/>
                    <xsl:if test="y:combat/y:damage[@type='stun']">s</xsl:if>
                    <xsl:if test="y:combat/y:damage[@type='mixed']">m</xsl:if>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block><xsl:value-of select="y:load"/></fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block><xsl:value-of select="y:strength"/></fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block><xsl:value-of select="y:reach"/></fo:block>
            </fo:table-cell>

            <fo:table-cell>
                <fo:block><xsl:value-of select="y:rof"/></fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block><xsl:value-of select="y:capacity"/></fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block><xsl:value-of select="y:recoil"/></fo:block>
            </fo:table-cell>


            <fo:table-cell>
                <fo:block>
                    <xsl:variable name="range" select="y:combat/y:range/y:increment"/>
                    <xsl:choose>
                        <xsl:when test="$range mod 1000 = 0">
                            <xsl:value-of select="$range div 1000"/>
                            <xsl:text>km</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$range"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block>
                    <xsl:variable name="range" select="y:combat/y:range/y:short"/>
                    <xsl:choose>
                        <xsl:when test="$range mod 1000 = 0">
                            <xsl:value-of select="$range div 1000"/>
                            <xsl:text>km</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$range"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block>
                    <xsl:variable name="range" select="y:combat/y:range/y:medium"/>
                    <xsl:choose>
                        <xsl:when test="$range mod 1000 = 0">
                            <xsl:value-of select="$range div 1000"/>
                            <xsl:text>km</xsl:text>
                        </xsl:when>
                        <xsl:when test="not($range)">
                            <xsl:text>-</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$range"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block>
                    <xsl:variable name="range" select="y:combat/y:range/y:long"/>
                    <xsl:choose>
                        <xsl:when test="$range mod 1000 = 0">
                            <xsl:value-of select="$range div 1000"/>
                            <xsl:text>km</xsl:text>
                        </xsl:when>
                        <xsl:when test="not($range)">
                            <xsl:text>-</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$range"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </fo:block>
            </fo:table-cell>

            <fo:table-cell>
                <fo:block>
                    <xsl:apply-templates select="y:class"/>
                </fo:block>
            </fo:table-cell>

            <fo:table-cell>
                <fo:block>
                    <xsl:apply-templates select="../yb:techLevel"/>
                </fo:block>
            </fo:table-cell>

            <fo:table-cell>
                <fo:block>
                    <xsl:apply-templates select="../yb:legality"/>
                </fo:block>
            </fo:table-cell>

            <fo:table-cell>
                <fo:block>
                    <xsl:apply-templates select="y:properties"/>
                </fo:block>
            </fo:table-cell>

        </fo:table-row>
    </xsl:template>

    <xsl:template match="yb:item/y:weapon/y:class">
        <xsl:variable name="comma">
            <xsl:if test="position() != 1">, </xsl:if>
        </xsl:variable>

        <xsl:value-of select="$comma"/><xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="y:import-armourlist">
        <xsl:variable name="wide">
            <xsl:choose>
                <xsl:when test="ancestor::yb:sect1/@format='wide'">true</xsl:when>
                <xsl:otherwise>false</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$wide='true'">
                <xsl:apply-templates select="document(@href)//yb:equipment"
                                     mode="armour-wide"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="document(@href)//yb:equipment"
                                     mode="armour-brief"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="yb:equipment" mode="armour-brief">
        <fo:table table-layout="fixed" space-after="10pt" span="all">
            <fo:table-column column-width="25mm"/>
            <fo:table-column column-width="10mm"/>
            <fo:table-column column-width="10mm"/>
            <fo:table-column column-width="35mm"/>

            <fo:table-header font-size="{$font-medium}" font-family="{$font-heading}">
                <fo:table-row>
                    <fo:table-cell>
                        <fo:block color="white" background-color="black">Armour</fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block color="white" background-color="black">Soak</fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block color="white" background-color="black">Load</fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block color="white" background-color="black">Notes</fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-header>

            <fo:table-body font-size="{$font-small}" font-family="{$font-body}">
                <xsl:apply-templates select="yb:item/y:armour" mode="brief">
                    <xsl:sort select="../@name" data-type="text"/>
                </xsl:apply-templates>
            </fo:table-body>
        </fo:table>
    </xsl:template>

    <xsl:template match="yb:equipment" mode="armour-wide">
        <fo:table table-layout="fixed" space-after="10pt" span="all">
            <fo:table-column column-width="25mm"/>
            <fo:table-column column-width="10mm"/>
            <fo:table-column column-width="10mm"/>
            <fo:table-column column-width="40mm"/>
            <fo:table-column column-width="30mm"/>
            <fo:table-column column-width="55mm"/>

            <fo:table-header font-size="{$font-medium}" font-family="{$font-heading}">
                <fo:table-row>
                    <fo:table-cell>
                        <fo:block color="white" background-color="black">Armour</fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block color="white" background-color="black">Soak</fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block color="white" background-color="black">Load</fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block color="white" background-color="black">Location</fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block color="white" background-color="black">Notes</fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block color="white" background-color="black">Comments</fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-header>

            <fo:table-body font-size="{$font-small}" font-family="{$font-body}">
                <xsl:apply-templates select="yb:item/y:armour" mode="wide">
                    <xsl:sort select="../@name" data-type="text"/>
                </xsl:apply-templates>
            </fo:table-body>
        </fo:table>
    </xsl:template>

    <xsl:template match="yb:item/y:armour" mode="brief">
        <xsl:variable name="bgcolour">
            <xsl:choose>
                <xsl:when test="position() mod 2 = 1">
                    <xsl:value-of select="$darkcolour"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$lightcolour"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <fo:table-row background-color="{$bgcolour}" font-size="{$font-small}">
            <fo:table-cell>
                <fo:block text-align="left">
                    <xsl:value-of select="../@name"/>
                </fo:block>
            </fo:table-cell>

            <fo:table-cell>
                <fo:block><xsl:value-of select="y:protection"/></fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block><xsl:value-of select="y:load"/></fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block>
                    <xsl:apply-templates select="y:properties"/>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
        <xsl:if test="y:notes">
            <fo:table-row background-color="{$bgcolour}" font-size="{$font-small}">
                <fo:table-cell number-columns-spanned="3">
                    <fo:block font-style="italic" text-align="left">
                        <xsl:value-of select="y:notes"/>
                    </fo:block>
                </fo:table-cell>
            </fo:table-row>
        </xsl:if>
    </xsl:template>

    <xsl:template match="yb:item/y:armour" mode="wide">
        <xsl:variable name="bgcolour">
            <xsl:choose>
                <xsl:when test="position() mod 2 = 1">
                    <xsl:value-of select="$darkcolour"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$lightcolour"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <fo:table-row background-color="{$bgcolour}" font-size="{$font-small}">
            <fo:table-cell>
                <fo:block text-align="left">
                    <xsl:value-of select="../@name"/>
                </fo:block>
            </fo:table-cell>

            <fo:table-cell>
                <fo:block><xsl:value-of select="y:protection"/></fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block><xsl:value-of select="y:load"/></fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block>
                    <xsl:apply-templates select="y:covers"/>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block>
                    <xsl:apply-templates select="y:properties"/>
                </fo:block>
            </fo:table-cell>

            <fo:table-cell>
                <fo:block font-style="italic" text-align="left">
                    <xsl:value-of select="y:notes"/>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>

    <xsl:template match="yb:import-equipment[not(@style='full')]">
        <xsl:variable name="wide">
            <xsl:choose>
                <xsl:when test="ancestor::yb:sect1/@format='wide'">true</xsl:when>
                <xsl:otherwise>false</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="href" select="@href"/>

        <xsl:for-each select="yb:category">
            <xsl:variable name="category" select="."/>

            <xsl:choose>
                <xsl:when test="$wide='true'">
                    <fo:table table-layout="fixed" space-after="{$font-small}">
                        <fo:table-column column-width="40mm"/>      <!-- Item name -->
                        <fo:table-column column-width="10mm"/>      <!-- Availability -->
                        <fo:table-column column-width="10mm"/>      <!-- Weight -->
                        <fo:table-column column-width="10mm"/>       <!-- Cost -->
                        <fo:table-column column-width="10mm"/>      <!-- Notes -->
                        <fo:table-column column-width="15mm"/>      <!-- Size -->
                        <fo:table-column column-width="75mm"/>      <!-- Description -->

                        <fo:table-header font-size="{$font-small}" font-family="{$font-heading}">
                            <fo:table-row>
                                <fo:table-cell>
                                    <fo:block color="white"
                                              background-color="black">
                                        <xsl:value-of select="$category"/>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block color="white"
                                              background-color="black">Avail.</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block color="white"
                                              background-color="black">Weight</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block color="white"
                                              background-color="black">Cost</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block color="white"
                                              background-color="black">Notes</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block color="white"
                                              background-color="black">Size</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block color="white"
                                              background-color="black">Description</fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </fo:table-header>

                        <fo:table-body font-size="{$font-small}" font-family="{$font-body}">
                            <xsl:apply-templates
                                select="document($href)/yb:equipment/yb:item[yb:category=$category]"
                                  mode="wide">
                                <xsl:sort select="@name" data-type="text"/>
                            </xsl:apply-templates>
                        </fo:table-body>
                    </fo:table>
                </xsl:when>

                <xsl:otherwise>
                    <fo:table table-layout="fixed" space-after="{$font-small}">
                        <fo:table-column column-width="35mm"/>      <!-- Item name -->
                        <fo:table-column column-width="7mm"/>       <!-- Availability -->
                        <fo:table-column column-width="7mm"/>       <!-- Weight -->
                        <fo:table-column column-width="7mm"/>       <!-- Cost -->
                        <fo:table-column column-width="10mm"/>      <!-- Notes -->

                        <fo:table-header font-size="{$font-small}" font-family="{$font-heading}">
                            <fo:table-row>
                                <fo:table-cell>
                                    <fo:block color="white"
                                              background-color="black">
                                        <xsl:value-of select="$category"/>
                                    </fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block color="white"
                                              background-color="black">Avail.</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block color="white"
                                              background-color="black">Weight</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block color="white"
                                              background-color="black">Cost</fo:block>
                                </fo:table-cell>
                                <fo:table-cell>
                                    <fo:block color="white"
                                              background-color="black">Notes</fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </fo:table-header>

                        <fo:table-body font-size="{$font-small}" font-family="{$font-body}">
                            <xsl:apply-templates
                                select="document(@href)/yb:equipment/yb:item[yb:category=$category]"
                                  mode="brief">
                                <xsl:sort select="@name" data-type="text"/>
                                <xsl:sort select="@quality" data-type="number"/>
                            </xsl:apply-templates>
                        </fo:table-body>
                    </fo:table>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="yb:equipment/yb:item" mode="brief">
        <xsl:variable name="bgcolour">
            <xsl:choose>
                <xsl:when test="position() mod 2 = 1">
                    <xsl:value-of select="$darkcolour"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$lightcolour"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <fo:table-row background-color="{$bgcolour}" font-size="{$font-small}">
            <fo:table-cell>
                <fo:block text-align="left">
                    <xsl:value-of select="@name"/>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>

    <xsl:template match="yb:equipment/yb:item" mode="wide">
        <xsl:variable name="bgcolour">
            <xsl:choose>
                <xsl:when test="position() mod 2 = 1">
                    <xsl:value-of select="$darkcolour"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$lightcolour"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <fo:table-row background-color="{$bgcolour}" font-size="{$font-small}">
            <fo:table-cell>
                <fo:block text-align="left">
                    <xsl:value-of select="@name"/>
                    <xsl:if test="@quality">
                        <xsl:choose>
                            <xsl:when test="@quality='1'"> (Poor)</xsl:when>
                            <xsl:when test="@quality='2'"> (Average)</xsl:when>
                            <xsl:when test="@quality='3'"> (Good)</xsl:when>
                            <xsl:when test="@quality='4'"> (Exceptional)</xsl:when>
                            <xsl:when test="@quality='5'"> (Superb)</xsl:when>
                        </xsl:choose>
                    </xsl:if>
                </fo:block>
            </fo:table-cell>

            <fo:table-cell>
                <fo:block text-align="center">
                    <xsl:value-of select="yb:availability"/>
                </fo:block>
            </fo:table-cell>

            <fo:table-cell>
                <fo:block text-align="right">
                    <xsl:apply-templates select="yb:weight" mode="metric"/>
                </fo:block>
            </fo:table-cell>

            <fo:table-cell>
                <fo:block text-align="right">
                    <xsl:apply-templates select="yb:cost" mode="saxon"/>
                </fo:block>
            </fo:table-cell>

            <fo:table-cell>
                <fo:block text-align="left">
                    <xsl:if test="yb:properties/yb:special">Sp </xsl:if>
                    <xsl:if test="yb:properties/yb:illegal">Il </xsl:if>
                    <xsl:if test="yb:properties/yb:shady">Sh </xsl:if>
                    <xsl:if test="yb:properties/yb:luxury">Lu </xsl:if>
                    <xsl:if test="yb:properties/yb:restricted">Re </xsl:if>
                </fo:block>
            </fo:table-cell>

            <fo:table-cell>
                <fo:block text-align="center">
                    <xsl:if test="yb:dimensions">
                        <xsl:value-of select="yb:dimensions/yb:length"/>
                        <xsl:text> x </xsl:text>
                        <xsl:value-of select="yb:dimensions/yb:width"/>
                        <xsl:text> x </xsl:text>
                        <xsl:value-of select="yb:dimensions/yb:height"/>
                    </xsl:if>
                </fo:block>
            </fo:table-cell>

            <fo:table-cell>
                <fo:block text-align="left">
                    <xsl:value-of select="yb:short"/>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>

    <xsl:template match="yb:weight" mode="metric">
        <xsl:variable name="grammes" select="."/>

        <xsl:choose>
            <xsl:when test="$grammes &gt; 900000">
                <xsl:value-of select="$grammes div 1000000"/>t
            </xsl:when>
            <xsl:when test="$grammes &gt; 900">
                <xsl:value-of select="$grammes div 1000"/>kg
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$grammes"/>g
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="yb:cost">
        <xsl:choose>
            <xsl:when test="@units='saxon'">
                <xsl:apply-templates select="." mode="saxon"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="cost" select="."/>
                <xsl:choose>
                    <xsl:when test="@units='usd'">$</xsl:when>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="$cost &gt; 900000000">
                        <xsl:value-of select="format-number($cost div 1000000000, '#,###.##')"/> B
                    </xsl:when>
                    <xsl:when test="$cost &gt; 900000">
                        <xsl:value-of select="format-number($cost div 1000000, '#,###.##')"/> M
                    </xsl:when>
                    <xsl:when test="$cost &gt; 90000">
                        <xsl:value-of select="format-number($cost div 1000, '#,###.##')"/> K
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="format-number($cost, '#,###.##')"/>
                    </xsl:otherwise>
                </xsl:choose>

                <xsl:choose>
                    <xsl:when test="@units='credits'"> Cr</xsl:when>
                    <xsl:when test="not(@units)"> Cr</xsl:when> <!-- HACK -->
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="yb:cost" mode="saxon">
        <xsl:variable name="bits" select="."/>

        <xsl:choose>
            <xsl:when test="$bits &gt; 400">
                <xsl:value-of select="$bits div 400"/>l
            </xsl:when>
            <xsl:when test="$bits &gt; 20">
                <xsl:value-of select="$bits div 20"/>s
            </xsl:when>
            <xsl:when test="$bits &gt; 3">
                <xsl:value-of select="$bits div 4"/>d
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$bits"/>f
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="yb:import-equipment[@style='full']">
        <xsl:apply-templates select="document(yb:list)/yb:equipment/yb:item" mode="full">
            <xsl:sort select="@name" data-type="text"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="yb:item" mode="full">
        <fo:block keep-together.within-column="always" space-after="{$font-medium}" font-size="{$font-medium}" font-family="{$font-body}">
            <fo:block font-weight="bold" color="{$colour}" font-family="{$font-heading}">
                <xsl:value-of select="@name"/>
            </fo:block>

            <xsl:if test="yb:short">
                <fo:block font-style="italic">
                    <xsl:value-of select="yb:short"/>
                </fo:block>
            </xsl:if>

            <fo:block>
                <xsl:if test="yb:legality">
                    <fo:inline font-weight="bold">Legality: </fo:inline>
                    <xsl:value-of select="yb:legality"/>
                    <xsl:text>; </xsl:text>
                </xsl:if>

                <xsl:if test="yb:techLevel">
                    <fo:inline font-weight="bold">TL: </fo:inline>
                    <xsl:value-of select="yb:techLevel"/>
                    <xsl:text>; </xsl:text>
                </xsl:if>

                <xsl:choose>
                    <xsl:when test="yb:weight">
                        <fo:inline font-weight="bold">Mass: </fo:inline>
                        <xsl:apply-templates select="yb:weight" mode="metric"/>
                        <xsl:text>; </xsl:text>
                    </xsl:when>
                </xsl:choose>

                <fo:inline font-weight="bold">Cost: </fo:inline>
                <xsl:apply-templates select="yb:cost"/>
            </fo:block>

            <xsl:if test="yb:dtonnes">
                <fo:block>
                    <fo:inline font-weight="bold">Size: </fo:inline>
                    <xsl:value-of select="yb:size"/>
                    <xsl:text>; </xsl:text>
                    <fo:inline font-weight="bold">Volume: </fo:inline>
                    <xsl:value-of select="yb:dtonnes"/>
                    <xsl:text>dt; </xsl:text>
                    <fo:inline font-weight="bold">Surface Area: </fo:inline>
                    <xsl:value-of select="yb:sa"/>
                    <xsl:text>; </xsl:text>
                </fo:block>
            </xsl:if>

            <!-- Any extra information that may be available. -->
            <xsl:apply-templates select="yb:construction"/>
            <xsl:apply-templates select="yb:performance"/>

            <xsl:apply-templates select="y:weapon" mode="full"/>
            <xsl:apply-templates select="y:armour" mode="full"/>
            <xsl:apply-templates select="y:tool" mode="full"/>
            <xsl:apply-templates select="y:task" mode="full"/>
            <xsl:apply-templates select="y:vehicle" mode="full"/>
            <xsl:apply-templates select="y:drug" mode="full"/>
        </fo:block>

        <xsl:apply-templates select="yb:description"/>
    </xsl:template>

    <!--
        Display information on who builds it, and when it first became
        available.
    -->
    <xsl:template match="yb:item/yb:construction">
        <fo:block>
            <fo:inline font-weight="bold">Manufacturer: </fo:inline>
            <xsl:value-of select="yb:manufacturer"/>
            <xsl:text>; </xsl:text>

            <fo:inline font-weight="bold">In-Service: </fo:inline>
            <xsl:value-of select="yb:year"/>
        </fo:block>
    </xsl:template>

    <!--
        Vehicles should have system neutral performance details defined.
        These specify how fast it is, it's durability etc. By default we
        assume ground performance, for other realms see the other templates.
    -->
    <xsl:template match="yb:item/yb:performance">
        <fo:block>
            <fo:inline font-weight="bold">Speed: </fo:inline>
            <xsl:value-of select="yb:speed"/>
            <xsl:text> km/h; </xsl:text>
            <fo:inline font-weight="bold">Accl: </fo:inline>
            <xsl:value-of select="yb:acceleration"/>
            <xsl:text> km/h/s; </xsl:text>
            <fo:inline font-weight="bold">Range: </fo:inline>
            <xsl:value-of select="yb:range"/> km
        </fo:block>
    </xsl:template>

    <!--
        Water performance of vehicle. We use metric, not knots.
    -->
    <xsl:template match="yb:item/yb:performance[@realm='Water']">
        <fo:block>
            <fo:inline font-weight="bold">Water Speed: </fo:inline>
            <xsl:value-of select="yb:speed"/>
            <xsl:text>km/h; </xsl:text>
            <fo:inline font-weight="bold">W Accl: </fo:inline>
            <xsl:value-of select="yb:acceleration"/>
            <xsl:text>km/h/s; </xsl:text>
            <fo:inline font-weight="bold">W Range: </fo:inline>
            <xsl:value-of select="yb:range"/> km
        </fo:block>
    </xsl:template>

    <xsl:template match="yb:item/yb:performance[@realm='Air']">
        <fo:block>
            <fo:inline font-weight="bold">Air Speed: </fo:inline>
            <xsl:value-of select="yb:speed"/>
            <xsl:text>km/h; </xsl:text>
            <fo:inline font-weight="bold">A Accl: </fo:inline>
            <xsl:value-of select="yb:acceleration"/>
            <xsl:text>km/h/s; </xsl:text>
            <fo:inline font-weight="bold">A Range: </fo:inline>
            <xsl:value-of select="yb:range"/>
            <xsl:text>km; </xsl:text>
            <fo:inline font-weight="bold">Alt: </fo:inline>
            <xsl:value-of select="yb:altitude"/> m
        </fo:block>
    </xsl:template>

    <xsl:template match="yb:item/yb:performance[@realm='Space']">
        <fo:block>
            <fo:inline font-weight="bold">Acceleration: </fo:inline>
            <xsl:value-of select="yb:acceleration"/>
            <xsl:if test="yb:maxaccel">
                <xsl:text> - </xsl:text>
                <xsl:value-of select="yb:maxaccel"/>
            </xsl:if>
            <xsl:text>m/s/s; </xsl:text>
            <xsl:if test="yb:deltavee">
                <fo:inline font-weight="bold">Delta-v: </fo:inline>
                <xsl:value-of select="yb:deltavee"/>
                <xsl:text>km/s; </xsl:text>
            </xsl:if>
            <xsl:if test="yb:jump">
                <fo:inline font-weight="bold">Jump: </fo:inline>
                <xsl:value-of select="yb:jump"/>;
            </xsl:if>
        </fo:block>
    </xsl:template>

    <xsl:template match="yb:item/y:armour" mode="full">
        <fo:block>
            <fo:inline font-weight="bold">Load: </fo:inline>
            <xsl:value-of select="y:load"/>
            <xsl:text>; </xsl:text>
            <fo:inline font-weight="bold">Soak: </fo:inline>
            <xsl:value-of select="y:protection"/>
            <xsl:text>; </xsl:text>
            <xsl:apply-templates select="y:covers"/>
        </fo:block>

        <fo:block>
            <xsl:apply-templates select="y:properties"/>
        </fo:block>
    </xsl:template>

    <xsl:template match="yb:item/y:weapon" mode="full">
        <fo:block>
            <xsl:if test="y:load">
                <fo:inline font-weight="bold">Load: </fo:inline>
                <xsl:value-of select="y:load"/>
                <xsl:text>; </xsl:text>
            </xsl:if>

            <xsl:if test="y:strength">
                <fo:inline font-weight="bold">Str: </fo:inline>
                <xsl:value-of select="y:strength"/>
                <xsl:text>; </xsl:text>
            </xsl:if>

            <xsl:if test="y:reach">
                <fo:inline font-weight="bold">Reach: </fo:inline>
                <xsl:value-of select="y:reach"/>
                <xsl:text>; </xsl:text>
            </xsl:if>

            <fo:inline font-weight="bold">Atk: </fo:inline>
            <xsl:value-of select="y:combat/y:attack"/>
            <xsl:text>; </xsl:text>

            <xsl:if test="y:combat/y:defence">
                <fo:inline font-weight="bold">Dfn: </fo:inline>
                <xsl:value-of select="y:combat/y:defence"/>
                <xsl:text>; </xsl:text>
            </xsl:if>

            <fo:inline font-weight="bold">Dmg: </fo:inline>
            <xsl:value-of select="y:combat/y:damage"/>
        </fo:block>

        <xsl:if test="y:combat/y:range">
            <fo:block>
                <fo:inline font-weight="bold">Increment: </fo:inline>
                <xsl:variable name="inc" select="y:combat/y:range/y:increment"/>
                <xsl:choose>
                    <xsl:when test="$inc mod 1000 = 0">
                        <xsl:value-of select="$inc div 1000"/>
                        <xsl:text>km; </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$inc"/>
                        <xsl:text>m; </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>

                <xsl:choose>
                    <xsl:when test="y:combat/y:range/y:medium">
                        <fo:inline font-weight="bold">Range bands: </fo:inline>
                        <xsl:variable name="short" select="y:combat/y:range/y:short"/>
                        <xsl:variable name="medium" select="y:combat/y:range/y:medium"/>
                        <xsl:variable name="long" select="y:combat/y:range/y:long"/>

                        <!-- Short range -->
                        <xsl:choose>
                            <xsl:when test="$short &gt; 1000">
                                <xsl:value-of select="$short div 1000"/>
                                <xsl:text>km / </xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$short"/>
                                <xsl:text>m / </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!-- Medium range -->
                        <xsl:choose>
                            <xsl:when test="$medium &gt; 1000">
                                <xsl:value-of select="$medium div 1000"/>
                                <xsl:text>km / </xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$medium"/>
                                <xsl:text>m / </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!-- Long range -->
                        <xsl:choose>
                            <xsl:when test="$long &gt; 1000">
                                <xsl:value-of select="$long div 1000"/>
                                <xsl:text>km</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$long"/>
                                <xsl:text>m</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="y:combat/y:range/y:short">
                        <!-- Assume spacecraft -->
                        <fo:inline font-weight="bold">Short range: </fo:inline>
                        <xsl:variable name="short" select="y:combat/y:range/y:short"/>
                        <xsl:choose>
                            <xsl:when test="$short mod 1000 = 0">
                                <xsl:value-of select="$short div 1000"/>
                                <xsl:text>km</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$short"/>
                                <xsl:text>m</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Nothing to show -->
                    </xsl:otherwise>
                </xsl:choose>
            </fo:block>

            <fo:block>
                <xsl:apply-templates select="y:capacity" mode="full"/>
                <xsl:apply-templates select="y:rof" mode="full"/>
                <xsl:apply-templates select="y:recoil" mode="full"/>
            </fo:block>
        </xsl:if>

        <fo:block>
            <xsl:apply-templates select="y:properties"/>
        </fo:block>
    </xsl:template>

    <xsl:template match="y:capacity" mode="full">
        <fo:inline font-weight="bold">Capacity: </fo:inline>
        <xsl:value-of select="."/>
        <xsl:text>; </xsl:text>
    </xsl:template>

    <xsl:template match="y:rof" mode="full">
        <fo:inline font-weight="bold">RoF: </fo:inline>
        <xsl:value-of select="."/>
        <xsl:text>; </xsl:text>
    </xsl:template>

    <xsl:template match="y:recoil" mode="full">
        <fo:inline font-weight="bold">Recoil: </fo:inline>
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="yb:item/y:tool" mode="full">
        <fo:block>
            <xsl:if test="y:load">
                <fo:inline font-weight="bold">Load: </fo:inline>
                <xsl:value-of select="y:load"/>
            </xsl:if>

            <xsl:if test="y:uses">
                <xsl:text>; </xsl:text>
                <fo:inline font-weight="bold">Uses: </fo:inline>
                <xsl:value-of select="y:uses"/>
            </xsl:if>
        </fo:block>

        <xsl:if test="y:modifier">
            <fo:block>
                <fo:inline font-weight="bold">Modifier: </fo:inline>
                <xsl:value-of select="y:modifier/@name"/>
                <xsl:text> (</xsl:text>
                <xsl:value-of select="y:modifier/@score"/>
                <xsl:text>)</xsl:text>
            </fo:block>
        </xsl:if>

        <xsl:if test="y:skill">
            <fo:block>
                <xsl:choose>
                    <xsl:when test="y:skill/@bonus">
                        <fo:inline font-weight="bold">Skill bonus: </fo:inline>
                        <xsl:value-of select="y:skill/@name"/>
                        <xsl:text> (</xsl:text>
                        <xsl:value-of select="y:skill/@bonus"/>
                        <xsl:text>)</xsl:text>
                    </xsl:when>

                    <xsl:when test="y:skill/@attribute">
                        <fo:inline font-weight="bold">Attribute bonus for skill: </fo:inline>
                        <xsl:value-of select="y:skill/@name"/>
                        <xsl:text> (</xsl:text>
                        <xsl:value-of select="y:skill/@attribute"/>
                        <xsl:text>)</xsl:text>
                    </xsl:when>

                    <xsl:when test="y:skill/@level">
                        <fo:inline font-weight="bold">Skill provided: </fo:inline>
                        <xsl:value-of select="y:skill/@name"/>
                        <xsl:text> (</xsl:text>
                        <xsl:value-of select="y:skill/@level"/>
                        <xsl:text>)</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </fo:block>
        </xsl:if>
    </xsl:template>

    <xsl:template match="yb:item/y:task" mode="full">
        <xsl:for-each select="y:skill">
            <fo:block>
                <fo:inline font-weight="bold"><xsl:value-of select="@name"/></fo:inline>
                <xsl:text> (</xsl:text><xsl:value-of select="@score"/><xsl:text>): </xsl:text>
                <fo:inline font-style="italic">
                    <xsl:value-of select="."/>
                </fo:inline>
            </fo:block>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="yb:item/y:drug" mode="full">
        <fo:block>
            <xsl:if test="y:strength">
                <fo:inline font-weight="bold">Strength: </fo:inline>
                <xsl:value-of select="y:strength"/>
            </xsl:if>

            <xsl:apply-templates select="y:addictive"/>
            <xsl:apply-templates select="y:generic"/>
            <xsl:apply-templates select="y:adder"/>
            <xsl:apply-templates select="y:offsetter"/>
            <xsl:apply-templates select="y:helper"/>
        </fo:block>
    </xsl:template>

    <xsl:template match="yb:item/y:drug/y:addictive">
    </xsl:template>
</xsl:stylesheet>
