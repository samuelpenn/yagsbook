<?xml version="1.0"?>

<!--
    Stylesheet transform for Yagsbook to HTML.

    These templates are for vehicle descriptions and statistics
    for the Dirtside II wargame.

    Author:  Samuel Penn
    Version: $Revision: 1.12 $
    Date:    $Date: 2005/10/24 14:13:27 $
-->

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ds="http://yagsbook.sourceforge.net/xml/dirtside"
    xmlns:yb="http://yagsbook.sourceforge.net/xml"
    version="1.0">

    <xsl:variable name="data" select="'http://yagsbook.sourceforge.net/xml/dirtside/dirtside.xml'"/>

    <!--
        An inline vehicle description.
    -->
    <xsl:template match="ds:statistics">
        <table class="dirtside">
            <tr>
                <td class="head">Size class</td>
                <td class="value"><xsl:value-of select="ds:size"/></td>

                <td class="head">Basic signature</td>
                <td class="value">
                    <xsl:choose>
                        <xsl:when test="ds:signature">
                            <xsl:value-of select="ds:signature"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="ds:size"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </td>

                <td class="head">Stealth level</td>
                <td class="value"><xsl:value-of select="ds:stealth"/></td>

                <td class="head">Effective target die</td>
                <td class="value">
                    <xsl:variable name="eff" select="ds:signature - ds:stealth"/>

                    <xsl:choose>
                        <xsl:when test="$eff = 1">D12</xsl:when>
                        <xsl:when test="$eff = 2">D10</xsl:when>
                        <xsl:when test="$eff = 3">D8</xsl:when>
                        <xsl:when test="$eff = 4">D6</xsl:when>
                        <xsl:when test="$eff = 5">D4</xsl:when>
                    </xsl:choose>
                </td>
            </tr>

            <xsl:variable name="power" select="ds:power/@type"/>
            <xsl:variable name="powerType"
                          select="document($data)/dirtside/power/type[@name=$power]/description"/>

            <xsl:variable name="mobility" select="ds:mobility/@type"/>
            <xsl:variable name="mobilityType"
                          select="document($data)/dirtside/mobility/type[@name=$mobility]/description"/>

            <xsl:variable name="basicMove"
                          select="document($data)/dirtside/mobility/type[@name=$mobility]/speed"/>

            <tr>
                <td class="head">Mobility type</td>
                <td class="text" colspan="3">
                    <xsl:value-of select="$powerType"/>
                    <xsl:text> / </xsl:text>
                    <xsl:value-of select="$mobilityType"/>
                </td>
                <td class="head">Basic move</td>
                <td class="value">
                    <xsl:value-of select="$basicMove"/>
                </td>

                <td class="head">Points value</td>
                <td class="value">
                    <!-- <xsl:value-of select="ds:points"/> -->
                    <xsl:apply-templates select="." mode="points"/>
                </td>
            </tr>

            <tr>
                <td class="head">FireCon</td>
                <td class="text">
                    <xsl:choose>
                        <xsl:when test="ds:elint/ds:firecon">
                            <xsl:variable name="quality" select="ds:elint/ds:firecon/@quality"/>
                            D<xsl:value-of select="document($data)/dirtside/firecon/type[@name=$quality]/die"/>
                        </xsl:when>
                        <xsl:otherwise>-</xsl:otherwise>
                    </xsl:choose>
                </td>

                <td class="head">ECM</td>
                <td class="value">
                    <xsl:choose>
                        <xsl:when test="ds:elint/ds:ecm">
                            <xsl:variable name="quality" select="ds:elint/ds:ecm/@quality"/>
                            D<xsl:value-of select="document($data)/dirtside/ecm/type[@name=$quality]/die"/>
                        </xsl:when>
                        <xsl:otherwise>D4</xsl:otherwise>
                    </xsl:choose>
                </td>

                <td class="head">Armour</td>
                <td class="text" colspan="3">
                    <xsl:if test="ds:armour">
                        Front <xsl:value-of select="ds:armour/@front"/>
                        <xsl:text>    </xsl:text>
                        Side
                        <xsl:choose>
                            <xsl:when test="ds:armour/@side">
                                <xsl:value-of select="ds:armour/@side"/>
                            </xsl:when>
                            <xsl:when test="ds:armour/@front='0'">
                                0
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="ds:armour/@front - 1"/>
                            </xsl:otherwise>
                        </xsl:choose>

                        <xsl:choose>
                            <xsl:when test="ds:armour/ds:reactive">
                                (Reactive)
                            </xsl:when>
                            <xsl:when test="ds:armour/ds:ablative">
                                (Ablative)
                            </xsl:when>
                        </xsl:choose>
                    </xsl:if>
                </td>
            </tr>
        </table>

        <xsl:apply-templates select="ds:weapons"/>

        <xsl:apply-templates select="ds:equipment"/>
    </xsl:template>

    <xsl:variable name="styleClose" select="'background-color: #ddffdd'"/>
    <xsl:variable name="styleMedium" select="'background-color: #ffffdd'"/>
    <xsl:variable name="styleLong" select="'background-color: #ffdddd'"/>
    <xsl:variable name="styleInfantry" select="'background-color: #ffffff'"/>


    <xsl:template match="ds:statistics/ds:weapons">
        <table class="dirtside">
            <tr>
                <td class="text" style="border: none;"/>
                <td class="text" style="border: none;"/>
                <td class="centre" colspan="3" style="{$styleClose}; text-align: center;">Close Range</td>
                <td class="centre" colspan="3" style="{$styleMedium}; text-align: center;">Medium Range</td>
                <td class="centre" colspan="3" style="{$styleLong}; text-align: center;">Long Range</td>
                <td class="centre" style="{$styleInfantry}; text-align: center;">Infantry</td>
            </tr>

            <tr>
                <td class="head" style="width: 40mm;">Type/Class</td>
                <td class="head" style="text-align: center;">Mount</td>

                <td class="head" style="width: 5mm; text-align: center;">Upto</td>
                <td class="head" style="width: 5mm; text-align: center;">Die</td>
                <td class="head" style="text-align: center;">Valid hits</td>

                <td class="head" style="width: 5mm; text-align: center;">Upto</td>
                <td class="head" style="width: 5mm; text-align: center;">Die</td>
                <td class="head" style="text-align: center;">Valid hits</td>

                <td class="head" style="width: 5mm; text-align: center;">Upto</td>
                <td class="head" style="width: 5mm; text-align: center;">Die</td>
                <td class="head" style="text-align: center;">Valid hits</td>

                <td class="head" style="text-align: center;">Valid hits</td>
            </tr>

            <xsl:apply-templates select="ds:weapon"/>
        </table>
    </xsl:template>

    <xsl:template match="ds:weapons/ds:weapon">
        <xsl:variable name="href" select="'http://yagsbook.sourceforge.net/xml/dirtside/dirtside.xml'"/>

        <xsl:variable name="type" select="@type"/>
        <xsl:variable name="class">
            <xsl:choose>
                <xsl:when test="@class"><xsl:value-of select="@class"/></xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>


        <tr>
            <td class="text">
                <xsl:choose>
                    <xsl:when test="@class">
                        <xsl:value-of select="$type"/>/<xsl:value-of select="$class"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$type"/>
                    </xsl:otherwise>
                </xsl:choose>

                <xsl:if test="@quality">
                    (<xsl:value-of select="substring(@quality, 1, 3)"/>)
                </xsl:if>

                <xsl:if test="@number">
                    x <xsl:value-of select="@number"/>
                </xsl:if>
            </td>

            <td>
                <xsl:if test="ds:turret">Turret</xsl:if>
            </td>

            <xsl:variable name="fcq">
                <xsl:choose>
                    <xsl:when test="@quality"><xsl:value-of select="@quality"/></xsl:when>
                    <xsl:when test="../../ds:elint/ds:firecon">
                        <xsl:value-of select="../../ds:elint/ds:firecon/@quality"/>
                    </xsl:when>
                    <xsl:otherwise>basic</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="firecon"
                          select="document($data)/dirtside/firecon/type[@name=$fcq]/die"/>

            <xsl:choose>
                <xsl:when test="document($href)//weapon[@name=$type]/range[@class=$class]/@close">
                    <td style="{$styleClose}">
                        <xsl:value-of select="document($href)//weapon[@name=$type]/range[@class=$class]/@close"/>"
                    </td>
                    <td style="{$styleClose}">
                        <!-- GMS don't shift die type at close range -->
                        <xsl:choose>
                            <xsl:when test="@quality">
                                D<xsl:value-of select="$firecon"/>
                            </xsl:when>
                            <xsl:otherwise>
                                D<xsl:value-of select="$firecon + 2"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </td>
                    <td style="{$styleClose}">
                        <xsl:apply-templates select="document($href)//weapon[@name=$type]/damage/any"/>
                        <xsl:apply-templates select="document($href)//weapon[@name=$type]/damage/close"/>
                    </td>
                </xsl:when>
                <xsl:otherwise>
                    <td style="{$styleClose}">-</td>
                    <td style="{$styleClose}">-</td>
                    <td style="{$styleClose}">-</td>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:choose>
                <xsl:when test="document($href)//weapon[@name=$type]/range[@class=$class]/@medium">
                    <td style="{$styleMedium}">
                        <xsl:value-of select="document($href)//weapon[@name=$type]/range[@class=$class]/@medium"/>"
                    </td>
                    <td style="{$styleMedium}">D<xsl:value-of select="$firecon"/></td>
                    <td style="{$styleMedium}">
                        <xsl:apply-templates select="document($href)//weapon[@name=$type]/damage/any"/>
                        <xsl:apply-templates select="document($href)//weapon[@name=$type]/damage/medium"/>
                    </td>
                </xsl:when>
                <xsl:otherwise>
                    <td style="{$styleMedium}">-</td>
                    <td style="{$styleMedium}">-</td>
                    <td style="{$styleMedium}">-</td>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:choose>
                <xsl:when test="document($href)//weapon[@name=$type]/range[@class=$class]/@long">
                    <td style="{$styleLong}">
                        <xsl:value-of select="document($href)//weapon[@name=$type]/range[@class=$class]/@long"/>"
                    </td>
                    <td style="{$styleLong}">D<xsl:value-of select="$firecon - 2"/></td>
                    <td style="{$styleLong}">
                        <xsl:apply-templates select="document($href)//weapon[@name=$type]/damage/any"/>
                        <xsl:apply-templates select="document($href)//weapon[@name=$type]/damage/long"/>
                    </td>
                </xsl:when>
                <xsl:otherwise>
                    <td style="{$styleLong}">-</td>
                    <td style="{$styleLong}">-</td>
                    <td style="{$styleLong}">-</td>
                </xsl:otherwise>
            </xsl:choose>

            <td style="{$styleInfantry}">
                <xsl:if test="not(document($href)//weapon[@name=$type]/damage/infantry)">
                    -
                </xsl:if>
                <xsl:apply-templates select="document($href)//weapon[@name=$type]/damage/infantry"/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="dirtside/weapons/weapon/damage/*">
        <xsl:if test="not(@armour)">
            <xsl:if test="red">R</xsl:if>
            <xsl:if test="yellow">Y</xsl:if>
            <xsl:if test="green">G</xsl:if>
            <xsl:text> </xsl:text><xsl:value-of select="@comment"/>
        </xsl:if>

        <xsl:if test="@armour='ablative'">
            <xsl:text>a{</xsl:text>
            <xsl:if test="red">R</xsl:if>
            <xsl:if test="yellow">Y</xsl:if>
            <xsl:if test="green">G</xsl:if>
            <xsl:text> </xsl:text><xsl:value-of select="@comment"/>
            <xsl:text>}</xsl:text>
        </xsl:if>

        <xsl:if test="@armour='reactive'">
            <xsl:text>r{</xsl:text>
            <xsl:if test="red">R</xsl:if>
            <xsl:if test="yellow">Y</xsl:if>
            <xsl:if test="green">G</xsl:if>
            <xsl:if test="@comment">
                <xsl:text> </xsl:text><xsl:value-of select="@comment"/>
            </xsl:if>
            <xsl:text>}</xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="ds:equipment">
        <table class="dirtside">
            <tr>
                <td class="text">
                    <xsl:apply-templates select="ds:item"/>
                    <xsl:if test="ds:commandSystems">Command Systems<br/></xsl:if>
                    <xsl:if test="ds:counterBatteryRadar">Counter Battery Radar<br/></xsl:if>
                    <xsl:if test="ds:lad">Local Air Defence<br/></xsl:if>
                    <xsl:if test="ds:ads">
                        Area Defence System
                        <xsl:choose>
                            <xsl:when test="ds:ads/@quality='enhanced'">(Enhanced/D8)</xsl:when>
                            <xsl:when test="ds:ads/@quality='superior'">(Superior/D10)</xsl:when>
                            <xsl:otherwise>(Basic/D6)</xsl:otherwise>
                        </xsl:choose>
                        <br/>
                    </xsl:if>
                    <xsl:if test="ds:pds">
                        Point Defence System
                        <xsl:choose>
                            <xsl:when test="ds:pds/@quality='enhanced'">(Enhanced/D8)</xsl:when>
                            <xsl:when test="ds:pds/@quality='superior'">(Superior/D10)</xsl:when>
                            <xsl:otherwise>(Basic/D6)</xsl:otherwise>
                        </xsl:choose>
                        <br/>
                    </xsl:if>
                    <xsl:if test="ds:apfc">APFC Belt<br/></xsl:if>
                    <xsl:if test="ds:cbr">Counter-Battery radar<br/></xsl:if>

                    <xsl:apply-templates select="ds:artillery"/>

                    <xsl:apply-templates select="ds:infantry"/>
                </td>
            </tr>
        </table>
    </xsl:template>

    <xsl:template match="ds:equipment/ds:item">
        <xsl:variable name="type" select="@name"/>
        <xsl:variable name="quality" select="@quality"/>

        <xsl:choose>
            <xsl:when test="document($data)/dirtside/equipment/type[@name=$type]">
                <xsl:variable name="name"
                              select="document($data)/dirtside/equipment/type[@name=$type]/description"/>
                <xsl:value-of select="$name"/>
                <xsl:if test="@quality">
                    (<xsl:value-of select="$quality"/>)
                </xsl:if>
                <br/>
            </xsl:when>
            <xsl:otherwise>
                Unknown item <xsl:value-of select="$type"/><br/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ds:equipment/ds:artillery">
        <xsl:variable name="class">
            <xsl:choose>
                <xsl:when test="@class='2'">Light</xsl:when>
                <xsl:when test="@class='4'">Medium</xsl:when>
                <xsl:when test="@class='6'">Heavy</xsl:when>
                <xsl:otherwise>Unknown</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:value-of select="$class"/><xsl:text> Artillery</xsl:text><br/>
        <xsl:if test="*">
            Ammunition:
            <xsl:if test="ds:standard">Standard x <xsl:value-of select="ds:standard/@rounds"/>;</xsl:if>
            <xsl:if test="ds:smoke">Smoke x <xsl:value-of select="ds:smoke/@rounds"/>;</xsl:if>
            <xsl:if test="ds:mines">Mines x <xsl:value-of select="ds:mines/@rounds"/>;</xsl:if>
            <xsl:if test="ds:biochem">Biochem x <xsl:value-of select="ds:biochem/@rounds"/>;</xsl:if>
            <xsl:if test="ds:nuclear">Nuclear x <xsl:value-of select="ds:nuclear/@rounds"/>;</xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template match="ds:equipment/ds:infantry">
        <xsl:variable name="type">
            <xsl:choose>
                <xsl:when test="@type='militia'">Militia</xsl:when>
                <xsl:when test="@type='line'">Line</xsl:when>
                <xsl:when test="@type='power'">Powered</xsl:when>
            </xsl:choose>
        </xsl:variable>

        <xsl:value-of select="$type"/><xsl:text> Infantry</xsl:text>
        <xsl:if test="@number">
            <xsl:text> x </xsl:text><xsl:value-of select="@number"/>
        </xsl:if>
        <xsl:if test="*">
            <xsl:text> (</xsl:text>
            <xsl:if test="ds:assualt">Assualt</xsl:if>
            <xsl:if test="ds:gmsl">
                GMS/L -
                <xsl:choose>
                    <xsl:when test="ds:gmsl/@guidance='basic'">Basic</xsl:when>
                    <xsl:when test="ds:gmsl/@guidance='enhanced'">Enhanced</xsl:when>
                    <xsl:when test="ds:gmsl/@guidance='superior'">Superior</xsl:when>
                </xsl:choose>
            </xsl:if>
            <xsl:if test="ds:apsw">APSW</xsl:if>
            <xsl:if test="ds:engineer">Engineering equipment</xsl:if>
            <xsl:if test="ds:lad">LAD system</xsl:if>
            <xsl:if test="ds:observer">Artillery observer</xsl:if>
            <xsl:if test="ds:cavalry">Cavalry</xsl:if>
            <xsl:text> )</xsl:text>
        </xsl:if>
        <br/>
    </xsl:template>

    <xsl:template match="ds:statistics" mode="points">
        <xsl:variable name="href" select="'http://yagsbook.sourceforge.net/xml/dirtside/dirtside.xml'"/>

        <xsl:variable name="vsp" select="ds:size * 5"/>
        <xsl:variable name="armourMult">
            <xsl:choose>
                <xsl:when test="ds:armour/ds:reactive">30</xsl:when>
                <xsl:when test="ds:armour/ds:ablative">30</xsl:when>
                <xsl:otherwise>20</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="armour">
            <xsl:choose>
                <xsl:when test="ds:armour/@front">
                    <xsl:value-of select="(ds:armour/@front * $vsp * $armourMult) div 100"/>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- The BVP is the base from which lots of other things are calculated -->
        <xsl:variable name="bvp" select="round($vsp + $armour)"/>

        <xsl:variable name="powerType" select="ds:power/@type"/>
        <xsl:variable name="mobilityType" select="ds:mobility/@type"/>

        <xsl:variable name="power"
                      select="document($href)/dirtside/power/type[@name=$powerType]/cost"/>
        <xsl:variable name="mobility"
                      select="document($href)/dirtside/mobility/type[@name=$mobilityType]/cost"/>

        <xsl:variable name="stealth" select="ds:size * ds:stealth * 20"/>

        <!-- Basic chassis subtotal -->
        <xsl:variable name="hullCost" select="round(($bvp * ($power + $mobility)) div 100) + $stealth"/>

        <!-- Now for the direct fire weapon costs -->
        <xsl:variable name="directCost">
            <xsl:call-template name="directFireCost"/>
        </xsl:variable>

        <!-- ELINT Systems -->
        <xsl:variable name="DS" select="document($data)/dirtside"/>

        <xsl:variable name="fcq">
            <xsl:choose>
                <xsl:when test="ds:elint/ds:firecon">
                    <xsl:value-of select="ds:elint/ds:firecon/@quality"/>
                </xsl:when>
                <xsl:otherwise>none</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="max">
            <xsl:call-template name="maxWeaponClass"/>
        </xsl:variable>
        <xsl:variable name="fc" select="$DS/firecon/type[@name=$fcq]/cost * $max"/>

        <xsl:variable name="ecmq">
            <xsl:choose>
                <xsl:when test="ds:elint/ds:ecm">
                    <xsl:value-of select="ds:elint/ds:ecm/@quality"/>
                </xsl:when>
                <xsl:otherwise>none</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ecm" select="$DS/ecm/type[@name=$ecmq]/cost"/>

        <xsl:variable name="elintCost" select="$fc + $ecm"/>

        <!-- Equipment -->
        <xsl:variable name="equipCost">
            <xsl:call-template name="equipmentPoints"/>
        </xsl:variable>

        <xsl:variable name="total" select="$bvp + $hullCost + $directCost + $elintCost + $equipCost"/>
        <xsl:value-of select="$total"/>
        <!--
        bvp = <xsl:value-of select="$bvp"/>;
        hull = <xsl:value-of select="$hullCost"/>;
        direct = <xsl:value-of select="$directCost"/>;
        elint = <xsl:value-of select="$elintCost"/>;
        equip = <xsl:value-of select="$equipCost"/>
        -->
    </xsl:template>

    <xsl:template name="directFireCost">
        <xsl:param name="idx" select="1"/>
        <xsl:param name="total" select="0"/>

        <xsl:choose>
            <xsl:when test="ds:weapons/ds:weapon[$idx]">
                <xsl:variable name="cost">
                    <xsl:apply-templates select="ds:weapons/ds:weapon[$idx]" mode="points"/>
                </xsl:variable>
                <xsl:call-template name="directFireCost">
                    <xsl:with-param name="idx" select="$idx + 1"/>
                    <xsl:with-param name="total" select="$total + $cost"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$total"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ds:weapon" mode="points">
        <xsl:variable name="type" select="@type"/>
        <xsl:variable name="class" select="@class"/>
        <xsl:variable name="quality" select="@quality"/>

        <xsl:variable name="number">
            <xsl:choose>
                <!-- Account for one free APSW -->
                <xsl:when test="$type='APSW' and @number">
                    <xsl:value-of select="@number - 1"/>
                </xsl:when>
                <xsl:when test="$type='APSW'">0</xsl:when>
                <xsl:when test="@number"><xsl:value-of select="@number"/></xsl:when>
                <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="node" select="document($data)/dirtside/weapons"/>

        <xsl:choose>
            <xsl:when test="@class">
                <xsl:variable name="base"
                              select="$node/weapon[@name=$type]/cost"/>
                <xsl:value-of select="$base * $class * $number"/>
            </xsl:when>
            <xsl:when test="@quality">
                <xsl:variable name="base"
                  select="$node/weapon[@name=$type]/cost[@quality=$quality]"/>
                <xsl:value-of select="$base * $number"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="base"
                              select="$node/weapon[@name=$type]/cost"/>
                <xsl:value-of select="$base * $number"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
        Return the maximum size of weapon class on this vehicle.
    -->
    <xsl:template name="maxWeaponClass">
        <xsl:param name="max" select="0"/>
        <xsl:param name="idx" select="1"/>

        <xsl:choose>
            <xsl:when test="ds:weapons/ds:weapon[$idx]">
                <xsl:variable name="WPN" select="ds:weapons/ds:weapon[$idx]"/>
                <xsl:choose>
                    <xsl:when test="$WPN/@class and $WPN/@class &gt; $max">
                        <xsl:call-template name="maxWeaponClass">
                            <xsl:with-param name="max" select="$WPN/@class"/>
                            <xsl:with-param name="idx" select="$idx + 1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="maxWeaponClass">
                            <xsl:with-param name="max" select="$max"/>
                            <xsl:with-param name="idx" select="$idx + 1"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$max"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="equipmentPoints">
        <xsl:param name="idx" select="1"/>
        <xsl:param name="total" select="0"/>

        <xsl:variable name="EQP" select="document($data)/dirtside/equipment"/>

        <xsl:choose>
            <xsl:when test="ds:equipment/ds:item[$idx]/@quality">
                <xsl:variable name="name" select="ds:equipment/ds:item[$idx]/@name"/>
                <xsl:variable name="quality" select="ds:equipment/ds:item[$idx]/@quality"/>

                <xsl:variable name="cost">
                    <xsl:choose>
                        <xsl:when test="$EQP/type[@name=$name]/cost[@quality=$quality]">
                            <xsl:value-of select="$EQP/type[@name=$name]/cost[@quality=$quality]"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$EQP/type[@name=$name]/cost"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:call-template name="equipmentPoints">
                    <xsl:with-param name="idx" select="$idx + 1"/>
                    <xsl:with-param name="total" select="$total + $cost"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="ds:equipment/ds:item[$idx]">
                <xsl:variable name="name" select="ds:equipment/ds:item[$idx]/@name"/>

                <xsl:variable name="cost">
                    <xsl:choose>
                        <xsl:when test="$EQP/type[@name=$name]/cost[@size]">
                            <xsl:variable name="size" select="ds:size"/>
                            <xsl:value-of select="$EQP/type[@name=$name]/cost/@size * $size"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$EQP/type[@name=$name]/cost"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:call-template name="equipmentPoints">
                    <xsl:with-param name="idx" select="$idx + 1"/>
                    <xsl:with-param name="total" select="$total + $cost"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$total"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ds:import-army-list">
        <xsl:variable name="VL" select="document(@href)//vehicles"/>

        <xsl:apply-templates select="ds:unit"/>

        <p>
            <b>
                Total cost:
                <xsl:call-template name="totalArmourCost">
                    <xsl:with-param name="href" select="@href"/>
                </xsl:call-template>
            </b>
        </p>
    </xsl:template>

    <xsl:template match="ds:import-army-list/ds:unit">
        <xsl:variable name="unitName" select="@name"/>

        <table>
            <tr style="background-color: black; color: white;">
                <th width="300" align="left"><xsl:value-of select="$unitName"/></th>
                <th width="50">#</th>
                <th width="50" align="right">Cost</th>
            </tr>
            <xsl:apply-templates select="ds:element"/>
        </table>
    </xsl:template>

    <xsl:template match="ds:element">
        <xsl:variable name="VL" select="document(../../@href)//yb:vehicles"/>
        <xsl:variable name="name" select="."/>
        <xsl:variable name="number">
            <xsl:choose>
                <xsl:when test="@number">
                    <xsl:value-of select="@number"/>
                </xsl:when>
                <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="elementCost">
            <xsl:choose>
                <xsl:when test="@cost">
                    <xsl:value-of select="@cost"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates
                            select="$VL/yb:vehicle[@name=$name]/ds:statistics"
                            mode="points"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="cost" select="$elementCost * $number"/>
        <tr>
            <td><xsl:value-of select="$name"/></td>
            <td align="center"><xsl:value-of select="$number"/></td>
            <td align="right"><xsl:value-of select="$cost"/></td>
        </tr>
    </xsl:template>

    <xsl:template name="totalUnitCost">
        <xsl:param name="href" select="0"/>
        <xsl:param name="idx" select="1"/>
        <xsl:param name="total" select="0"/>

        <xsl:variable name="VL" select="document($href)//yb:vehicles"/>
        <xsl:choose>
            <xsl:when test="ds:element[$idx]">
                <xsl:variable name="name" select="ds:element[$idx]"/>
                <xsl:variable name="number">
                    <xsl:choose>
                        <xsl:when test="ds:element[$idx]/@number">
                            <xsl:value-of select="ds:element[$idx]/@number"/>
                        </xsl:when>
                        <xsl:otherwise>1</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:variable name="cost">
                    <xsl:choose>
                        <xsl:when test="ds:element[$idx]/@cost">
                            <xsl:value-of select="ds:element[$idx]/@cost"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates
                                select="$VL/yb:vehicle[@name=$name]/ds:statistics"
                                mode="points"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:call-template name="totalUnitCost">
                    <xsl:with-param name="href" select="$href"/>
                    <xsl:with-param name="idx" select="$idx + 1"/>
                    <xsl:with-param name="total" select="$total + $cost * $number"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$total"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ds:unit" mode="unitCost">
        <xsl:call-template name="totalUnitCost">
            <xsl:with-param name="href" select="../@href"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="totalArmourCost">
        <xsl:param name="href" select="0"/>
        <xsl:param name="idx" select="1"/>
        <xsl:param name="total" select="0"/>

        <xsl:variable name="VL" select="document($href)//vehicles"/>
        <xsl:choose>
            <xsl:when test="ds:unit[$idx]">
                <xsl:variable name="cost">
                    <xsl:apply-templates select="ds:unit[$idx]" mode="unitCost"/>
                </xsl:variable>

                <xsl:call-template name="totalArmourCost">
                    <xsl:with-param name="href" select="$href"/>
                    <xsl:with-param name="idx" select="$idx + 1"/>
                    <xsl:with-param name="total" select="$total + $cost"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$total"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
