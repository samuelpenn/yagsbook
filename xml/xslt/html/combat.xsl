<?xml version="1.0"?>

<xsl:transform
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 version="1.0">

    <!-- The following are for working out weapon statistics -->
<!--
    <xsl:template name="get-weapon-stat">
        <xsl:param name="weapon" select="none"/>
        <xsl:param name="mode" select="Melee"/>
        <xsl:param name="attribute" select="attack"/>

        <xsl:variable name="href">
            <xsl:choose>
                <xsl:when test="//resources/weaponlist">
                    <xsl:value-of select="//resources/weaponlist/@href"/>
                </xsl:when>
                <xsl:when test="//character/combat/@href">
                    <xsl:value-of select="//character/combat/@href"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="equipment/weaponlist/@href"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$weapon='none'">
                <xsl:text>0</xsl:text>
            </xsl:when>

            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$attribute='initiative'">
                        <xsl:value-of select="document($href)//weapon[@name=$weapon]/combat[@mode=$mode]/initiative"/>
                    </xsl:when>
                    <xsl:when test="$attribute='attack'">
                        <xsl:value-of select="document($href)//weapon[@name=$weapon]/combat[@mode=$mode]/attack"/>
                    </xsl:when>
                    <xsl:when test="$attribute='defence'">
                        <xsl:value-of select="document($href)//weapon[@name=$weapon]/combat[@mode=$mode]/defence"/>
                    </xsl:when>
                    <xsl:when test="$attribute='damage'">
                        <xsl:value-of select="document($href)//weapon[@name=$weapon]/combat[@mode=$mode]/damage"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>






    <xsl:template name="weapon_bonus">
        <xsl:param name="primary" select="none"/>
        <xsl:param name="secondary" select="none"/>
        <xsl:param name="shield" select="none"/>
        <xsl:param name="attribute" select="attack"/>

        <xsl:variable name="href">
            <xsl:choose>
                <xsl:when test="//resources/weaponlist">
                    <xsl:value-of select="//resources/weaponlist/@href"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="equipment/weaponlist/@href"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="pBonus">
            <xsl:call-template name="get-weapon-stat">
                <xsl:with-param name="weapon" select="$primary"/>
                <xsl:with-param name="attribute" select="$attribute"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="sBonus">
            <xsl:choose>
                <xsl:when test="$secondary!='none'">
                    <xsl:call-template name="get-weapon-stat">
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
                    <xsl:call-template name="get-weapon-stat">
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



    <xsl:template name="armour-count">
        <xsl:param name="index" select="0"/>
        <xsl:param name="total" select="0"/>

        <xsl:choose>
            <xsl:when test="$index = 0">
                +<xsl:value-of select="$total"/>
            </xsl:when>

            <xsl:when test="equipment/armour[$index]/@protection">
                <xsl:call-template name="armour-count">
                    <xsl:with-param name="index" select="$index - 1"/>
                    <xsl:with-param name="total" select="equipment/armour[$index]/@protection + $total"/>
                </xsl:call-template>
            </xsl:when>

            <xsl:when test="equipment/armour[$index]/@name">
                <xsl:variable name="href" select="//resources/armourlist/@href"/>
                <xsl:variable name="name" select="equipment/armour[$index]/@name"/>

                <xsl:variable name="soak">
                    <xsl:value-of select="document($href)//armour[@name=$name]/protection"/>
                </xsl:variable>
                <xsl:call-template name="armour-count">
                    <xsl:with-param name="index" select="$index - 1"/>
                    <xsl:with-param name="total" select="$soak + $total"/>
                </xsl:call-template>
            </xsl:when>

            <xsl:otherwise>
                <xsl:call-template name="armour-count">
                    <xsl:with-param name="index" select="$index - 1"/>
                    <xsl:with-param name="total" select="$total"/>
                </xsl:call-template>
            </xsl:otherwise>

        </xsl:choose>
    </xsl:template>

    <xsl:template name="armour-list">
        <xsl:param name="index" select="0"/>
        <xsl:param name="list" select="m"/>

        <xsl:choose>
            <xsl:when test="$index = 1">
                <xsl:if test="string-length($list) &gt; 0">
                    <xsl:value-of select="$list"/>,
                </xsl:if>
                <xsl:value-of select="equipment/armour[$index]/@name"/>
            </xsl:when>

            <xsl:otherwise>
                <xsl:variable name="all">
                    <xsl:if test="string-length($list) &gt; 0">
                        <xsl:value-of select="$list"/>,
                    </xsl:if>
                    <xsl:value-of select="equipment/armour[$index]/@name"/>
                </xsl:variable>
                <xsl:call-template name="armour-list">
                    <xsl:with-param name="index" select="$index - 1"/>
                    <xsl:with-param name="list" select="$all"/>
                </xsl:call-template>
            </xsl:otherwise>

        </xsl:choose>
    </xsl:template>


    <xsl:template name="soak">
        <xsl:variable name="baseSoak" select="attributes/@soak"/>

        <xsl:variable name="numItems" select="count(equipment/armour)"/>

        <xsl:variable name="armourSoak">
            <xsl:if test="equipment/armour">
                <xsl:call-template name="armour-count">
                    <xsl:with-param name="index" select="$numItems"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="not(equipment/armour)">0</xsl:if>
        </xsl:variable>

        <xsl:variable name="armourList">
            <xsl:if test="equipment/armour">
                <xsl:call-template name="armour-list">
                    <xsl:with-param name="index" select="$numItems"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:variable>

        <xsl:value-of select="$baseSoak + $armourSoak"/>
        <xsl:text> </xsl:text>
        (<xsl:value-of select="$armourList"/><xsl:text> </xsl:text>
        <xsl:value-of select="$armourSoak"/>)

    </xsl:template>

    <xsl:template match="import-weaponlist">
        <h2>Weapon list</h2>
        <xsl:apply-templates select="document($href)//weaponlist" mode="brief"/>
     </xsl:template>

    <xsl:template match="weaponlist" mode="brief">
        <table>
            <tr>
                <th>Weapon</th>
                <th>Ini</th>
                <th>Atk</th>
                <th>Dfn</th>
                <th>Dmg</th>
                <th>Class</th>
            </tr>
            <xsl:apply-templates select="weapon" mode="brief"/>
        </table>
    </xsl:template>

    <xsl:template match="weaponlist/weapon" mode="brief">
        <td><xsl:value-of select="@name"/></td>
        <td><xsl:value-of select="initiative"/></td>
        <td><xsl:value-of select="attack"/></td>
        <td><xsl:value-of select="defence"/></td>
        <td><xsl:value-of select="damage"/></td>
        <td><xsl:value-of select="class"/></td>
    </xsl:template>
-->
</xsl:transform>
