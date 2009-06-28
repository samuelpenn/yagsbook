<?xml version="1.0"?>
<!--
    Handle transformation of weapons, armour and equipment lists.

    Author: Samuel Penn
    Version: $Revision: 1.23 $
    Date:    $Date: 2007/06/02 22:14:31 $

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

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:yb="http://yagsbook.sourceforge.net/xml"
               xmlns:y="http://yagsbook.sourceforge.net/xml/yags"
               version="1.0">

    <xsl:include href="../share/yags/equipment.xsl"/>

    <xsl:template match="y:import-weaponinfo">
        <xsl:apply-templates
                select="document(@href)/yb:equipment/yb:item[yb:category='Weapon']"
                mode="full"/>
    </xsl:template>

    <!--
        import-weaponlist

        Display weapons in tabular form. Weapons are listed by category,
        unless the category of 'all' is selected, in which case all weapons
        are displayed.
    -->
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

        <table class="weapons">
            <xsl:for-each select="y:category">
                <xsl:variable name="category" select="."/>

                <xsl:if test="not($category='all')">
                    <tr>
                        <th colspan="18">
                            <xsl:value-of select="$category"/>
                        </th>
                    </tr>
                </xsl:if>

                <tr>
                    <th/>
                    <th colspan="4">Combat</th>
                    <th colspan="6">Attributes</th>
                    <th colspan="3"></th>
                    <th colspan="4">Range</th>
                </tr>
                <tr>
                    <th style="width: 40mm">Weapon name</th>
                    <th>Atk</th>
                    <th>Dfn</th>
                    <th>Dmg</th>
                    <th>Rch</th>
                    <th>Ld</th>
                    <th>Str</th>
                    <th>RoF</th>
                    <th>Cap.</th>
                    <th>Rcl</th>
                    <th>Class</th>
                    <th>TL</th>
                    <th>LC</th>
                    <th>Notes</th>
                    <th style="width: 5mm">Inc</th>
                    <th style="width: 8mm">Sh</th>
                    <th style="width: 8mm">Md</th>
                    <th style="width: 8mm">Lg</th>
                </tr>

                <xsl:choose>
                    <xsl:when test="$category='all'">
                        <xsl:apply-templates select="$items/y:weapon" mode="list">
                            <xsl:sort select="../@name" data-type="text"/>
                        </xsl:apply-templates>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="$items/y:weapon[y:category=$category]" mode="list">
                            <xsl:sort select="../@name" data-type="text"/>
                        </xsl:apply-templates>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </table>
    </xsl:template>

    <xsl:template match="yb:item/y:weapon" mode="list">
        <xsl:variable name="line">
            <xsl:choose>
                <xsl:when test="position() mod 2 = 0">dark</xsl:when>
                <xsl:otherwise>light</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <tr class="{$line}">
            <td><xsl:value-of select="../@name"/></td>
            <td><xsl:value-of select="y:combat/y:attack"/></td>
            <td><xsl:value-of select="y:combat/y:defence"/></td>
            <td>
                <xsl:value-of select="y:combat/y:damage"/>
                <xsl:choose>
                    <xsl:when test="y:combat/y:damage/@type='stun'">s</xsl:when>
                    <xsl:when test="y:combat/y:damage/@type='mixed'">m</xsl:when>
                </xsl:choose>
            </td>
            <td><xsl:value-of select="y:reach"/></td>
            <td>
                <xsl:call-template name="number">
                    <xsl:with-param name="value">
                        <xsl:value-of select="y:load"/>
                    </xsl:with-param>
                </xsl:call-template>
            </td>
            <td><xsl:value-of select="y:strength"/></td>
            <td><xsl:value-of select="y:rof"/></td>
            <td><xsl:value-of select="y:capacity"/></td>
            <td><xsl:value-of select="y:recoil"/></td>
            <td>
                <xsl:for-each select="y:class">
                    <xsl:if test="position()=last()">
                        <xsl:value-of select="."/>
                    </xsl:if>
                    <xsl:if test="position() &lt; last()">
                        <xsl:value-of select="."/><xsl:text>, </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </td>
            <td><xsl:value-of select="../yb:techLevel"/></td>
            <td><xsl:value-of select="../yb:legality"/></td>
            <td>
                <xsl:apply-templates select="y:properties"/>
            </td>
            <xsl:choose>
                <xsl:when test="y:properties/y:missile">
                    <td><xsl:value-of select="y:combat/y:range/y:increment"/></td>
                    <td><xsl:value-of select="y:combat/y:range/y:short"/></td>
                    <td><xsl:value-of select="y:combat/y:range/y:medium"/></td>
                    <td><xsl:value-of select="y:combat/y:range/y:long"/></td>
                </xsl:when>
                <xsl:otherwise>
                    <td>5</td>
                    <td>--</td>
                    <td>--</td>
                    <td>--</td>
                </xsl:otherwise>
            </xsl:choose>
        </tr>
    </xsl:template>

    <xsl:template match="yb:item/y:weapon" mode="full">
        <h5><xsl:value-of select="../@name"/></h5>

        <xsl:apply-templates select="../yb:description"/>

        <xsl:apply-templates select="y:combat" mode="full"/>
    </xsl:template>

    <xsl:template match="y:weapon/y:combat" mode="full">
        <p>
            <b><xsl:value-of select="@mode"/></b>:
            Attack: <xsl:value-of select="y:attack"/>;
            Defence: <xsl:value-of select="y:defence"/>;
            Damage: <xsl:value-of select="y:damage"/>;
        </p>
    </xsl:template>


    <!--
        Import a list of all the armour types.
     -->
    <xsl:template match="y:import-armourlist">
        <table class="armour">
            <tr>
                <th width="50%">Armour</th>
                <th>Soak</th>
                <th>Load</th>
                <th>Notes</th>
                <th>Coverage</th>
            </tr>
            <xsl:apply-templates select="document(@href)/yb:equipment/yb:item/y:armour" mode="list">
                <xsl:sort select="../@name" data-type="text"/>
            </xsl:apply-templates>
        </table>
    </xsl:template>

    <!--
        number

        Take a number, and display it as an integer, or if it is a
        fraction, try to display it as a proper fraction. Only handles
        0.25, 0.5 and 0.75 at the moment.
    -->
    <xsl:template name="number">
        <xsl:param name="value" select="0"/>

        <xsl:choose>
            <xsl:when test="$value='0.25'"><small>1/4</small></xsl:when>
            <xsl:when test="$value='0.5'"><small>1/2</small></xsl:when>
            <xsl:when test="$value='0.75'"><small>3/4</small></xsl:when>
            <xsl:otherwise><xsl:value-of select="$value"/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="yb:item/y:armour" mode="list">
        <xsl:variable name="oddeven">
            <xsl:choose>
                <xsl:when test="position() mod 2 = 0">dark</xsl:when>
                <xsl:otherwise>light</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <tr class="{$oddeven}">
            <td>
                <xsl:value-of select="../@name"/>
                <xsl:if test="y:notes">
                    <br/>
                    <em><xsl:value-of select="y:notes"/></em>
                </xsl:if>
            </td>
            <td align="center">
                <xsl:call-template name="number">
                    <xsl:with-param name="value">
                        <xsl:value-of select="y:protection"/>
                    </xsl:with-param>
                </xsl:call-template>
            </td>
            <td align="center">
                <xsl:call-template name="number">
                    <xsl:with-param name="value">
                        <xsl:value-of select="y:load"/>
                    </xsl:with-param>
                </xsl:call-template>
            </td>
            <td>
                <xsl:apply-templates select="y:properties"/>
            </td>
            <td>
                <xsl:apply-templates select="y:covers"/>
            </td>
        </tr>
    </xsl:template>

    <!--
            <weapon name="Lifesinger">
                <category>Swords</category>
                <importance>3</importance>
                <class>single</class>

                <length>130cm</length>
                <weight>2kg</weight>

                <description>
                    <para>
                        A broad sword, marked with runes.
                    </para>
                </description>

                <statistics xmlns="http://yagsbook.sourceforge.net/xml/yags">
                    <initiative>+5</initiative>
                    <attack>+7</attack>
                    <defence>+5</defence>
                    <damage>+14</damage>

                    <strength>3</strength>
                    <load>4</load>
                    <reach>3</reach>

                    <properties>
                        <exceptional/>
                        <rune name="rune-attack" value="2">
                            <link>Shield Thing</link>
                        </rune>
                        <rune name="rune-damage" value="2"/>
                        <rune name="rune-light"/>
                        <rune name="rune-sharpness"/>
                        <rune name="rune-ghosts">
                            <link>Helm of Light</link>
                        </rune>
                    </properties>
                </statistics>
            </weapon>
    -->

    <!--
        weapon

        A weapon by itself. In this instance, we need a full description
        of the weapon. It is probably magical, or at least special in some
        way. Will need to check to see what type of stats to use for it.
     -->
    <xsl:template match="yb:item/y:weapon">
        <div class="weapon">
            <h5><xsl:value-of select="../@name"/></h5>

            <xsl:apply-templates select="../yb:description"/>
        </div>
    </xsl:template>


    <!--
        import-equipment

        Import a list of items from an external document.
        May contain one or more <category/> elements which define what
        type of items to import.
     -->
    <xsl:template match="yb:import-equipment">
        <xsl:variable name="href" select="@href"/>

        <table class="equipment">
            <xsl:for-each select="yb:category">
                <xsl:variable name="category" select="."/>

                <xsl:if test="not($category='all')">
                    <tr>
                        <th colspan="6">
                            <xsl:value-of select="$category"/>
                        </th>
                    </tr>
                </xsl:if>

                <tr>
                    <th width="50%" align="left">Item</th>
                    <th>Availability</th>
                    <th>Weight</th>
                    <th>Cost</th>
                    <th align="left">Notes</th>
                    <th align="left">Description</th>
                </tr>

                <xsl:choose>
                    <xsl:when test="$category='all'">
                        <xsl:apply-templates
                            select="document(yb:list)/yb:equipment/yb:item"
                            mode="list">

                            <xsl:sort select="@name" data-type="text"/>
                        </xsl:apply-templates>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:apply-templates
                            select="document(yb:list)/yb:equipment/yb:item[yb:category=$category]"
                            mode="list">

                            <xsl:sort select="@name" data-type="text"/>
                        </xsl:apply-templates>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </table>
    </xsl:template>

    <xsl:template match="yb:equipment/yb:item" mode="list">
        <xsl:variable name="oddeven">
            <xsl:choose>
                <xsl:when test="position() mod 2 = 0">dark</xsl:when>
                <xsl:otherwise>light</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tr class="{$oddeven}">
            <td class="name">
                <xsl:value-of select="@name"/>
                <xsl:if test="@quality">
                    <xsl:choose>
                        <xsl:when test="@quality='1'">
                            (Poor)
                        </xsl:when>

                        <xsl:when test="@quality='2'">
                            (Average)
                        </xsl:when>

                        <xsl:when test="@quality='3'">
                            (Good)
                        </xsl:when>

                        <xsl:when test="@quality='4'">
                            (Excellent)
                        </xsl:when>

                        <xsl:when test="@quality='5'">
                            (Superb)
                        </xsl:when>
                    </xsl:choose>
                </xsl:if>
            </td>
            <td><xsl:value-of select="yb:availability"/></td>
            <td align="right"><xsl:apply-templates select="yb:weight" mode="metric"/></td>
            <td align="right"><xsl:apply-templates select="yb:cost" mode="saxon"/></td>
            <td>
                <xsl:if test="yb:properties/yb:special">Sp </xsl:if>
                <xsl:if test="yb:properties/yb:illegal">Il </xsl:if>
                <xsl:if test="yb:properties/yb:shady">Sh </xsl:if>
                <xsl:if test="yb:properties/yb:luxury">Lu </xsl:if>
                <xsl:if test="yb:properties/yb:restricted">Re </xsl:if>
            </td>
            <td><xsl:apply-templates select="yb:short"/></td>
        </tr>
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


    <xsl:template match="y:import-firearms">
        <xsl:variable name="href" select="@href"/>

        <table class="weapons">
            <tr>
                <th>Name</th>
                <th>Atk</th>
                <th>Dmg</th>
                <th>Ld</th>
                <th>Str</th>
                <th>Class</th>
                <th>RoF</th>
                <th>Cap.</th>
                <th>Rcl</th>
                <th>Notes</th>
                <th>Inc</th>
                <th>Sh</th>
                <th>Md</th>
                <th>Lg</th>
            </tr>

            <xsl:apply-templates select="document($href)/yb:equipment/yb:item/y:weapon[y:category='Firearms']"
                                 mode="firearms-list">
                <xsl:sort select="../@name" data-type="text"/>
            </xsl:apply-templates>
        </table>
    </xsl:template>

    <xsl:template match="yb:item/y:weapon" mode="firearms-list">
        <xsl:variable name="line">
            <xsl:choose>
                <xsl:when test="position() mod 2 = 0">dark</xsl:when>
                <xsl:otherwise>light</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <tr class="{$line}">
            <td><xsl:value-of select="../@name"/></td>
            <td><xsl:value-of select="y:combat/y:attack"/></td>
            <td>
                <xsl:value-of select="y:combat/y:damage"/>
                <xsl:choose>
                    <xsl:when test="y:combat/y:damage/@type='stun'">s</xsl:when>
                    <xsl:when test="y:combat/y:damage/@type='mixed'">m</xsl:when>
                </xsl:choose>
            </td>
            <td>
                <xsl:call-template name="number">
                    <xsl:with-param name="value">
                        <xsl:value-of select="y:load"/>
                    </xsl:with-param>
                </xsl:call-template>
            </td>
            <td><xsl:value-of select="y:strength"/></td>
            <td>
                <xsl:for-each select="y:class">
                    <xsl:if test="position()=last()">
                        <xsl:value-of select="."/>
                    </xsl:if>
                    <xsl:if test="position() &lt; last()">
                        <xsl:value-of select="."/><xsl:text>, </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </td>
            <td><xsl:value-of select="y:rof"/></td>
            <td><xsl:value-of select="y:rounds"/></td>
            <td><xsl:value-of select="y:recoil"/></td>
            <td>
                <xsl:apply-templates select="y:properties"/>
            </td>
            <xsl:choose>
                <xsl:when test="y:properties/y:missile">
                    <td><xsl:value-of select="y:combat/y:range/y:increment"/></td>
                    <td><xsl:value-of select="y:combat/y:range/y:short"/></td>
                    <td><xsl:value-of select="y:combat/y:range/y:medium"/></td>
                    <td><xsl:value-of select="y:combat/y:range/y:long"/></td>
                </xsl:when>
                <xsl:otherwise>
                    <td>5</td>
                    <td>--</td>
                    <td>--</td>
                    <td>--</td>
                </xsl:otherwise>
            </xsl:choose>
        </tr>
    </xsl:template>

    <xsl:template match="y:weapon-ranges">
        <table>
            <tr>
                <td>Skill</td>
                <td>Inc</td>
                <td>Snapshot</td>
                <td>Normal</td>
                <td>Careful</td>
                <td>Aimed</td>
            </tr>

            <xsl:for-each select="y:skill">
                <xsl:variable name="skill" select="."/>

                <xsl:for-each select="../y:inc">
                    <xsl:variable name="inc" select="."/>

                    <tr>
                        <td><xsl:value-of select="$skill"/></td>
                        <td><xsl:value-of select="$inc"/></td>
                    </tr>

                </xsl:for-each>
            </xsl:for-each>
        </table>
    </xsl:template>

    <xsl:template match="yb:import-equipment[@style='full']">
        <xsl:apply-templates select="document(yb:list)/yb:equipment/yb:item" mode="full">
            <xsl:sort select="@name" data-type="text"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="yb:item" mode="full">
        <h4 style="margin-bottom: 0mm"><xsl:value-of select="@name"/></h4>

        <xsl:if test="yb:short">
            <p style="margin-top: 0mm; margin-bottom: 0mm">
                <em><xsl:value-of select="yb:short"/></em>
            </p>
        </xsl:if>

        <p style="margin-top: 0mm; margin-bottom: 0mm;">
            <xsl:if test="yb:techLevel">
                <b>TL: </b>
                <xsl:value-of select="yb:techLevel"/>
                <xsl:text>; </xsl:text>
            </xsl:if>

            <b>Mass: </b>
            <xsl:apply-templates select="yb:weight" mode="metric"/>
            <xsl:text>; </xsl:text>

            <b>Cost: </b>
            <xsl:apply-templates select="yb:cost"/>
            <xsl:text> Cr</xsl:text>
        </p>

        <xsl:apply-templates select="yb:construction"/>
        <xsl:apply-templates select="yb:performance"/>

        <xsl:apply-templates select="y:weapon" mode="full"/>
        <xsl:apply-templates select="y:armour" mode="full"/>
        <xsl:apply-templates select="y:tool" mode="full"/>
        <xsl:apply-templates select="y:task" mode="full"/>
        <xsl:apply-templates select="y:vehicle" mode="full"/>

        <xsl:apply-templates select="yb:description"/>
    </xsl:template>

    <xsl:template match="yb:item/yb:construction">
        <p style="margin-top: 0mm; margin-bottom: 0mm">
            <b>Manufacturer: </b><xsl:value-of select="yb:manufacturer"/>
            <xsl:text>; </xsl:text>
            <b>In-Service: </b><xsl:value-of select="yb:year"/>
        </p>
    </xsl:template>


    <xsl:template match="yb:item/yb:performance">
        <p style="margin-top: 0mm; margin-bottom: 0mm">
            <b>Speed: </b><xsl:value-of select="yb:speed"/>
            <xsl:text> km/h; </xsl:text>
            <b>Accl: </b><xsl:value-of select="yb:acceleration"/>
            <xsl:text> km/h/s; </xsl:text>
            <b>Range: </b><xsl:value-of select="yb:range"/> km
        </p>
    </xsl:template>

    <xsl:template match="yb:item/yb:performance[@realm='Water']">
        <p style="margin-top: 0mm; margin-bottom: 0mm">
            <b>Water Speed: </b><xsl:value-of select="yb:speed"/>
            <xsl:text> km/h; </xsl:text>
            <b>W Accl: </b><xsl:value-of select="yb:acceleration"/>
            <xsl:text> km/h/s; </xsl:text>
            <b>W Range: </b><xsl:value-of select="yb:range"/> km
        </p>
    </xsl:template>

    <xsl:template match="yb:item/yb:performance[@realm='Air']">
        <p style="margin-top: 0mm; margin-bottom: 0mm">
            <b>Air Speed: </b><xsl:value-of select="yb:speed"/>
            <xsl:text> km/h; </xsl:text>
            <b>A Accl: </b><xsl:value-of select="yb:acceleration"/>
            <xsl:text> km/h/s; </xsl:text>
            <b>A Range: </b><xsl:value-of select="yb:range"/>
            <xsl:text> km; </xsl:text>
            <b>Alt: </b><xsl:value-of select="yb:altitude"/> m
        </p>
    </xsl:template>

    <xsl:template match="yb:item/yb:performance[@realm='Space']">
        <p style="margin-top: 0mm; margin-bottom: 0mm">
            <b>Acceleration: </b><xsl:value-of select="yb:acceleration"/>
            <xsl:if test="yb:maxaccel">
                <xsl:text> - </xsl:text>
                <xsl:value-of select="yb:maxaccel"/>
            </xsl:if>
            <xsl:text> m/s/s; </xsl:text>
            <b>Delta-v: </b><xsl:value-of select="yb:deltavee"/>
            <xsl:text> km/s; </xsl:text>
            <xsl:if test="yb:jump">
                <b>Jump: </b><xsl:value-of select="yb:jump"/>
            </xsl:if>
        </p>
    </xsl:template>

    <xsl:template match="yb:item/y:armour" mode="full">
        <p style="margin-top: 0mm; margin-bottom: 0mm;">
            <b>Load: </b><xsl:value-of select="y:load"/>
            <xsl:text>; </xsl:text>

            <b>Soak: </b><xsl:value-of select="y:protection"/>
            <xsl:text>; </xsl:text>
            <xsl:apply-templates select="y:covers"/>
        </p>

        <p style="margin-top: 0mm; margin-bottom: 0mm;">
            <xsl:apply-templates select="y:properties"/>
        </p>
    </xsl:template>

    <xsl:template match="yb:item/y:weapon" mode="full">
        <p style="margin-top: 0mm; margin-bottom: 0mm;">
            <b>Load: </b><xsl:value-of select="y:load"/>
            <xsl:text>; </xsl:text>

            <b>Str: </b><xsl:value-of select="y:strength"/>
            <xsl:text>; </xsl:text>

            <b>Reach: </b><xsl:value-of select="y:reach"/>
            <xsl:text>; </xsl:text>

            <b>Atk: </b><xsl:value-of select="y:combat/y:attack"/>
            <xsl:text>; </xsl:text>

            <xsl:if test="y:combat/y:defence">
                <b>Dfn: </b><xsl:value-of select="y:combat/y:defence"/>
                <xsl:text>; </xsl:text>
            </xsl:if>

            <b>Dmg: </b><xsl:value-of select="y:combat/y:damage"/>
            <xsl:text>; </xsl:text>
        </p>

        <xsl:if test="y:combat/y:range">
            <p style="margin-top: 0mm; margin-bottom: 0mm;">
                <b>Increment: </b>
                <xsl:value-of select="y:combat/y:range/y:increment"/>
                <xsl:text>m; </xsl:text>

                <b>Range bands: </b>
                <xsl:value-of select="y:combat/y:range/y:short"/>
                <xsl:text>m / </xsl:text>
                <xsl:value-of select="y:combat/y:range/y:medium"/>
                <xsl:text>m / </xsl:text>
                <xsl:value-of select="y:combat/y:range/y:long"/>
                <xsl:text>m</xsl:text>
            </p>

            <p style="margin-top: 0mm; margin-bottom: 0mm;">
                <xsl:apply-templates select="y:capacity" mode="full"/>
                <xsl:apply-templates select="y:rof" mode="full"/>
                <xsl:apply-templates select="y:recoil" mode="full"/>
            </p>
        </xsl:if>
    </xsl:template>

    <xsl:template match="y:capacity" mode="full">
        <b>Capacity: </b><xsl:value-of select="."/>
        <xsl:text>; </xsl:text>
    </xsl:template>

    <xsl:template match="y:rof" mode="full">
        <b>RoF: </b><xsl:value-of select="."/>
        <xsl:text>; </xsl:text>
    </xsl:template>

    <xsl:template match="y:recoil" mode="full">
        <b>Recoil: </b><xsl:value-of select="."/>
    </xsl:template>


    <xsl:template match="yb:item/y:tool" mode="full">
        <p style="margin-top: 0mm; margin-bottom: 0mm;">
            <xsl:if test="y:load">
                <b>Load: </b><xsl:value-of select="y:load"/>
            </xsl:if>

            <xsl:if test="y:uses">
                <xsl:text>; </xsl:text>
                <b>Uses: </b><xsl:value-of select="y:uses"/>
            </xsl:if>
        </p>

        <xsl:if test="y:skill">
            <p style="margin-top: 0mm; margin-bottom: 0mm;">
                <xsl:choose>
                    <xsl:when test="y:skill/@bonus">
                        <b>Skill bonus: </b>
                        <xsl:value-of select="y:skill/@name"/>
                        <xsl:text> (</xsl:text>
                        <xsl:value-of select="y:skill/@bonus"/>
                        <xsl:text>)</xsl:text>
                    </xsl:when>

                    <xsl:when test="y:skill/@level">
                        <b>Skill provided: </b>
                        <xsl:value-of select="y:skill/@name"/>
                        <xsl:text> (</xsl:text>
                        <xsl:value-of select="y:skill/@level"/>
                        <xsl:text>)</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </p>
        </xsl:if>
    </xsl:template>

    <xsl:template match="yb:item/y:task" mode="full">
        <xsl:for-each select="y:skill">
            <p style="margin-top: 0mm; margin-bottom: 0mm;">
                <b><xsl:value-of select="@name"/></b>
                <xsl:text>( </xsl:text>
                <xsl:value-of select="@score"/>
                <xsl:text>): </xsl:text>
                <xsl:value-of select="."/>
            </p>
        </xsl:for-each>
    </xsl:template>
</xsl:transform>
