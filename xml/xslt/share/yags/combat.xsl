<?xml version="1.0"?>

<!--
    Stylesheet transform for Yagsbook to HTML or PDF.

    Handles the calculation of combat statistics for characters
    and beasts. Output neutral, so should only return data back
    to callers rather than writing data to output.

    Author:  Samuel Penn
    Version: $Revision: 1.10 $
    Date:    $Date: 2007/03/27 20:44:08 $
-->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:yb="http://yagsbook.sourceforge.net/xml"
    xmlns:y="http://yagsbook.sourceforge.net/xml/yags"
    xmlns:fo="http://www.w3.org/1999/XSL/Format">

    <xsl:template match="y:combat/y:combatstyle/y:reach">
        <xsl:variable name="primaryName" select="../y:primary"/>

        <xsl:variable name="base">
            <xsl:choose>
                <xsl:when test="@bonus">
                    <xsl:value-of select="@bonus"/>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="bonus">
            <xsl:choose>
                <xsl:when test="../y:primary">
                    <xsl:call-template name="y:get-weapon-stat">
                        <xsl:with-param name="weapon" select="$primaryName"/>
                        <xsl:with-param name="attribute" select="'reach'"/>
                    </xsl:call-template>
                </xsl:when>

                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="total" select="$base + $bonus"/>

        <xsl:value-of select="$total"/>
    </xsl:template>

    <!--
        Calculate value for the given combat statistic - either initiative,
        attack, defence or damage. We dynamically determine which element
        we have been called for, and do the right thing.
     -->
    <xsl:template match="y:combat/y:combatstyle/y:*">

        <xsl:variable name="skillName" select="../@skill"/>
        <xsl:variable name="primaryName" select="../y:primary"/>
        <xsl:variable name="secondaryName" select="../y:secondary"/>
        <xsl:variable name="shieldName" select="../y:shield"/>
        <xsl:variable name="mode" select="../y:mode"/>

        <xsl:variable name="mountedBonus">
            <xsl:variable name="rideSkill" select="../y:mounted/@skill"/>
            <xsl:choose>
                <xsl:when test="not(../y:mounted)">0</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="../../../y:skills/y:group/y:skill[@name=$rideSkill]/@score"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- Damage always has a multiplier of 4, otherwise use the skill -->
        <xsl:variable name="skillScore">
            <xsl:if test="local-name()='damage'">4</xsl:if>
            <xsl:if test="not(local-name()='damage')">
                <xsl:value-of select="../../../y:skills/y:group/y:skill[@name=$skillName]/@score"/>
            </xsl:if>
        </xsl:variable>

        <!-- Damage doesn't give an attribute, since it is always strength -->
        <xsl:variable name="attr">
            <xsl:choose>
                <xsl:when test="@attribute">
                    <xsl:value-of select="@attribute"/>
                </xsl:when>

                <xsl:when test="local-name()='initiative'">agility</xsl:when>
                <xsl:when test="local-name()='damage'">strength</xsl:when>
                <xsl:otherwise>dexterity</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- Work out what attribute x skill is -->
        <xsl:variable name="ability">
            <xsl:variable name="attrScore">
                <xsl:choose>
                    <xsl:when test="../../../y:attributes/y:attribute[@name=$attr]/@half">
                        <xsl:value-of select="../../../y:attributes/y:attribute[@name=$attr]/@half"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="../../../y:attributes/y:attribute[@name=$attr]/@score"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:value-of select="$attrScore * $skillScore"/>
        </xsl:variable>

        <!-- Get the bonus for this type of weapon -->
        <xsl:variable name="bonus">
            <xsl:choose>
                <xsl:when test="@bonus">
                    <!--
                        For some reason, on some computers, a plus
                        sign in front of a number makes it NaN. On
                        other computers, it works fine either way.
                        Get rid of + signs just in case.
                     -->
                    <xsl:value-of select="translate(@bonus, '+', '')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="y:weapon-bonus">
                        <xsl:with-param name="mode" select="$mode"/>
                        <xsl:with-param name="primary" select="$primaryName"/>
                        <xsl:with-param name="secondary" select="$secondaryName"/>
                        <xsl:with-param name="shield" select="$shieldName"/>
                        <xsl:with-param name="attribute" select="local-name()"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- Multiply and return -->
        <xsl:variable name="total">
            <xsl:value-of select="$ability + $bonus + $mountedBonus"/>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$total='NaN'">--</xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$total"/>
                <xsl:if test="@type">
                    (<xsl:value-of select="@type"/>)
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>



    <!--
        Returns the value of the requested attribute for the
        given weapon. Possible attributes are initiative,
        attack, defence and damage.

        The href should be a pointer to a file containing
        weapon statistics.
    -->
    <xsl:template name="y:get-weapon-stat">
        <xsl:param name="weapon" select="'none'"/>
        <xsl:param name="attribute" select="'attack'"/>

        <!--
            <xsl:when test="../../../../yb:equipment/yb:item[@name=$weapon]">
                <xsl:value-of select="../../../../yb:equipment/yb:item[@name=$weapon]"/>
            </xsl:when>
            -->

        <xsl:choose>
            <xsl:when test="$weapon='none'">
                <xsl:text>0</xsl:text>
            </xsl:when>
            <xsl:when test="$weapon=''">
                <xsl:text>0</xsl:text>
            </xsl:when>
            <xsl:when test="../../../../yb:equipment/yb:item[@name=$weapon]">
                <xsl:apply-templates select="../../../../yb:equipment/yb:item[@name=$weapon]"
                                     mode="yags-get-weapon-stat">
                    <xsl:with-param name="weapon" select="$weapon"/>
                    <xsl:with-param name="attribute" select="$attribute"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="document($armsUrl)/yb:equipment/yb:item[@name=$weapon]">
                <xsl:apply-templates select="document($armsUrl)/yb:equipment/yb:item[@name=$weapon]"
                                     mode="yags-get-weapon-stat">
                    <xsl:with-param name="weapon" select="$weapon"/>
                    <xsl:with-param name="attribute" select="$attribute"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="yb:item" mode="yags-get-weapon-stat">
        <xsl:param name="weapon" select="'none'"/>
        <xsl:param name="attribute" select="'attack'"/>

        <xsl:variable name="tmp">
            <xsl:choose>
                <xsl:when test="$attribute='attack'">
                    <xsl:value-of select="y:weapon/y:combat/y:attack"/>
                </xsl:when>
                <xsl:when test="$attribute='defence'">
                    <xsl:value-of select="y:weapon/y:combat/y:defence"/>
                </xsl:when>
                <xsl:when test="$attribute='damage'">
                    <xsl:value-of select="y:weapon/y:combat/y:damage"/>
                </xsl:when>
                <xsl:when test="$attribute='reach'">
                    <xsl:value-of select="y:weapon/y:reach"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="translate($tmp, '+', '')"/>
    </xsl:template>

    <!--
        Work out the total bonus for the given combat attribute.
        This adds primary, secondary and shield weapon stats together.
    -->
    <xsl:template name="y:weapon-bonus">
        <xsl:param name="primary" select="'none'"/>
        <xsl:param name="secondary" select="'none'"/>
        <xsl:param name="shield" select="'none'"/>
        <xsl:param name="attribute" select="'attack'"/>

        <xsl:variable name="pBonus">
            <xsl:call-template name="y:get-weapon-stat">
                <xsl:with-param name="weapon" select="$primary"/>
                <xsl:with-param name="attribute" select="$attribute"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="sBonus">
            <xsl:choose>
                <xsl:when test="$secondary!='none'">
                    <xsl:call-template name="y:get-weapon-stat">
                        <xsl:with-param name="weapon" select="$secondary"/>
                        <xsl:with-param name="attribute" select="$attribute"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    0
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="shBonus">
            <xsl:choose>
                <xsl:when test="$shield!='none'">
                    <xsl:call-template name="y:get-weapon-stat">
                        <xsl:with-param name="weapon" select="$shield"/>
                        <xsl:with-param name="attribute" select="$attribute"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    0
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="total" select="$pBonus + $shBonus + floor($sBonus div 2)"/>

        <xsl:value-of select="$total"/>

    </xsl:template>



    <!--
        Work out what the wound penalty levels are for the character,
        given the total number of levels. 'size' may actually be health
        if we are working out fatigue levels, but the logic is the same.

        Result is passed back as a string, in "OK/-6/-10/Fatal" format.
    -->
    <xsl:template name="y:output-wound-levels">
        <xsl:param name="size" select="5"/>
        <xsl:param name="okay" select="OK"/>
        <xsl:param name="fatal" select="Fatal"/>

        <xsl:value-of select="$okay"/> /
        <xsl:choose>
            <xsl:when test="$size='0'"></xsl:when>
            <xsl:when test="$size='1'">-25 /</xsl:when>
            <xsl:when test="$size='2'">-15 / -25 /</xsl:when>
            <xsl:when test="$size='3'">-10 / -15 / -25 /</xsl:when>
            <xsl:when test="$size='4'">-5 / -10 / -15 / -25 /</xsl:when>
            <xsl:when test="$size='5'">0 / -5 / -10 / -15 / -25 /</xsl:when>
            <xsl:when test="$size>'5'">
                <xsl:variable name="_level0">
                <xsl:value-of select="ceiling($size div 5)" />
                </xsl:variable>
                <xsl:variable name="_level1">
                <xsl:value-of select="ceiling(($size -1) div 5)" />
                </xsl:variable>
                <xsl:variable name="_level3">
                <xsl:value-of select="ceiling(($size -2) div 5)" />
                </xsl:variable>
                <xsl:variable name="_level6">
                <xsl:value-of select="ceiling(($size -3) div 5)" />
                </xsl:variable>
                <xsl:variable name="_level10">
                <xsl:value-of select="ceiling(($size -4) div 5)" />
                </xsl:variable>

                <xsl:call-template name="y:output-soak">
                    <xsl:with-param name="num" select="$_level0"/>
                    <xsl:with-param name="what" select="0"/>
                </xsl:call-template>
                <xsl:call-template name="y:output-soak">
                    <xsl:with-param name="num" select="$_level1"/>
                    <xsl:with-param name="what" select="-5"/>
                </xsl:call-template>
                <xsl:call-template name="y:output-soak">
                    <xsl:with-param name="num" select="$_level3"/>
                    <xsl:with-param name="what" select="-10"/>
                </xsl:call-template>
                <xsl:call-template name="y:output-soak">
                    <xsl:with-param name="num" select="$_level6"/>
                    <xsl:with-param name="what" select="-15"/>
                </xsl:call-template>
                <xsl:call-template name="y:output-soak">
                    <xsl:with-param name="num" select="$_level10"/>
                    <xsl:with-param name="what" select="-25"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$fatal"/>
    </xsl:template>


    <xsl:template name="y:output-damage-levels">
        <xsl:param name="size" select="10"/>
        <xsl:param name="okay" select="OK"/>
        <xsl:param name="fatal" select="Destroyed"/>

        <xsl:value-of select="$okay"/> /
        <xsl:choose>
            <xsl:when test="$size='0'"></xsl:when>
            <xsl:when test="$size='1'">-20 /</xsl:when>
            <xsl:when test="$size='2'">-10 / -20 /</xsl:when>
            <xsl:when test="$size='3'">-0 / -10 / -20 /</xsl:when>
            <xsl:when test="$size > '3'">
                <xsl:variable name="_level0">
                    <xsl:value-of select="ceiling($size div 3)" />
                </xsl:variable>
                <xsl:variable name="_level1">
                    <xsl:value-of select="ceiling(($size -1) div 3)" />
                </xsl:variable>
                <xsl:variable name="_level3">
                    <xsl:value-of select="ceiling(($size -2) div 3)" />
                </xsl:variable>

                <xsl:call-template name="y:output-soak">
                    <xsl:with-param name="num" select="$_level0"/>
                    <xsl:with-param name="what" select="0"/>
                </xsl:call-template>
                <xsl:call-template name="y:output-soak">
                    <xsl:with-param name="num" select="$_level1"/>
                    <xsl:with-param name="what" select="-10"/>
                </xsl:call-template>
                <xsl:call-template name="y:output-soak">
                    <xsl:with-param name="num" select="$_level3"/>
                    <xsl:with-param name="what" select="-20"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$fatal"/>
    </xsl:template>


    <!-- Recurse 'num' times to get a for loop -->
    <xsl:template name="y:output-soak">
        <xsl:param name="num" select="1"/>
        <xsl:param name="what" select="0"/>
        <xsl:value-of select="$what"/> /
        <xsl:if test="$num != 1">
            <xsl:call-template name="y:output-soak">
                <xsl:with-param name="num" select="$num - 1"/>
                <xsl:with-param name="what" select="$what"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>


    <!--
        ARMOUR

        The following templates work out total soak values, by iterating
        over the armour the character/creature has.
    -->
    <xsl:template match="y:armourstyle" mode="count">
        <xsl:param name="base" select="0"/>

        <xsl:variable name="bonus">
            <xsl:call-template name="y:armour-count">
                <xsl:with-param name="index" select="count(y:armour)"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:value-of select="$base + $bonus"/>
    </xsl:template>


    <!-- Count up the total soak bonus from armour -->
    <xsl:template name="y:armour-count">
        <xsl:param name="index" select="0"/>
        <xsl:param name="total" select="0"/>

        <xsl:variable name="name" select="y:armour[$index]/@name"/>

        <xsl:choose>
            <!-- Finished counting -->
            <xsl:when test="$index = 0">
                <xsl:value-of select="$total"/>
            </xsl:when>

            <!-- Armour gives soak bonus locally -->
            <xsl:when test="y:armour[$index]/@protection">
                <xsl:call-template name="y:armour-count">
                    <xsl:with-param name="index" select="$index - 1"/>
                    <xsl:with-param name="total" select="translate(y:armour[$index]/@protection, '+', '') + $total"/>
                </xsl:call-template>
            </xsl:when>

            <xsl:when test="../../../yb:equipment/yb:item[@name=$name]/y:armour/y:protection">
                <xsl:variable name="prot"
                              select="../../../yb:equipment/yb:item[@name=$name]/y:armour/y:protection"/>
                <xsl:call-template name="y:armour-count">
                    <xsl:with-param name="index" select="$index - 1"/>
                    <xsl:with-param name="total" select="translate($prot, '+', '') + $total"/>
                </xsl:call-template>
            </xsl:when>

            <xsl:when test="document($armsUrl)/yb:equipment/yb:item[@name=$name]/y:armour/y:protection">
                <xsl:variable name="prot"
                              select="document($armsUrl)/yb:equipment/yb:item[@name=$name]/y:armour/y:protection"/>
                <xsl:call-template name="y:armour-count">
                    <xsl:with-param name="index" select="$index - 1"/>
                    <xsl:with-param name="total" select="translate($prot, '+', '') + $total"/>
                </xsl:call-template>
            </xsl:when>

            <!-- Nothing useful, just skip onwards -->
            <xsl:otherwise>
                <xsl:call-template name="y:armour-count">
                    <xsl:with-param name="index" select="$index - 1"/>
                    <xsl:with-param name="total" select="$total"/>
                </xsl:call-template>
            </xsl:otherwise>

        </xsl:choose>
    </xsl:template>

    <!-- List all the armour for this armour style -->
    <xsl:template match="y:armourstyle" mode="list">
        <xsl:call-template name="y:armour-list">
            <xsl:with-param name="index" select="count(y:armour)"/>
        </xsl:call-template>
    </xsl:template>

    <!-- List all the armour for this armour style -->
    <xsl:template name="y:armour-list">
        <xsl:param name="index" select="0"/>
        <xsl:param name="list" select="m"/>

        <xsl:choose>
            <xsl:when test="$index = 1">
                <xsl:if test="string-length($list) &gt; 0">
                    <xsl:value-of select="$list"/>,
                </xsl:if>
                <xsl:value-of select="y:armour[$index]/@name"/>
            </xsl:when>

            <xsl:otherwise>
                <xsl:variable name="all">
                    <xsl:if test="string-length($list) &gt; 0">
                        <xsl:value-of select="$list"/>,
                    </xsl:if>
                    <xsl:value-of select="y:armour[$index]/@name"/>
                </xsl:variable>
                <xsl:call-template name="y:armour-list">
                    <xsl:with-param name="index" select="$index - 1"/>
                    <xsl:with-param name="list" select="$all"/>
                </xsl:call-template>
            </xsl:otherwise>

        </xsl:choose>
    </xsl:template>


    <!--
        Calculate the total load of a set of armour.
     -->
    <xsl:template match="y:armourstyle" mode="load">
        <xsl:param name="base" select="0"/>

        <xsl:variable name="load">
            <xsl:call-template name="y:armour-load">
                <xsl:with-param name="index" select="count(armour)"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:value-of select="$base + $load"/>
    </xsl:template>


    <!-- Count up the total soak bonus from armour -->
    <xsl:template name="y:armour-load">
        <xsl:param name="index" select="0"/>
        <xsl:param name="total" select="0"/>

        <xsl:choose>
            <!-- Finished counting -->
            <xsl:when test="$index = 0">
                <xsl:value-of select="$total"/>
            </xsl:when>

            <!-- Armour gives soak bonus locally -->
            <xsl:when test="armour[$index]/@load">
                <xsl:call-template name="y:armour-load">
                    <xsl:with-param name="index" select="$index - 1"/>
                    <xsl:with-param name="total" select="armour[$index]/@load + $total"/>
                </xsl:call-template>
            </xsl:when>

            <!-- Retrieve soak bonus from external file -->
            <xsl:when test="armour[$index]/@name">
                <xsl:variable name="name" select="armour[$index]/@name"/>

                <xsl:variable name="soak">
                    <xsl:value-of select="document($armsUrl)//armour[@name=$name]/load"/>
                </xsl:variable>
                <xsl:call-template name="y:armour-load">
                    <xsl:with-param name="index" select="$index - 1"/>
                    <xsl:with-param name="total" select="$soak + $total"/>
                </xsl:call-template>
            </xsl:when>

            <!-- Nothing useful, just skip onwards -->
            <xsl:otherwise>
                <xsl:call-template name="y:armour-load">
                    <xsl:with-param name="index" select="$index - 1"/>
                    <xsl:with-param name="total" select="$total"/>
                </xsl:call-template>
            </xsl:otherwise>

        </xsl:choose>

    </xsl:template>

    <!--
        Output vehicle damage tracks.
    -->
    <xsl:template name="output-track">
        <xsl:param name="count" select="0"/>

        <xsl:if test="$count &gt; 0">
            <xsl:text>O </xsl:text>
            <xsl:call-template name="output-track">
                <xsl:with-param name="count" select="$count - 1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
