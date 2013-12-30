<?xml version="1.0"?>

<!--
    Stylesheet transform for Yagsbook to HTML.

    These templates support WarHammer Battle specific character information.

    Author:  Samuel Penn
    Version: $Revision: 1.6 $
    Date:    $Date: 2005/11/25 19:48:20 $
-->


<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:yb="http://yagsbook.sourceforge.net/xml"
    xmlns:w="http://yagsbook.sourceforge.net/xml/warhammer"
    version="1.0">

    <!--
        Imports an army from an external document.
    -->
    <xsl:template match="w:import-army">
        <xsl:variable name="href" select="@href"/>

        <h3>Army statistics</h3>

        <table>
            <tr>
                <th align="left">Cost of army:</th>
                <td align="right">
                    <xsl:call-template name="wh-calculate-cost">
                        <xsl:with-param name="href" select="$href"/>
                    </xsl:call-template>
                </td>
            </tr>

            <tr>
                <th align="left">Number of troops:</th>
                <td align="right">
                    <xsl:call-template name="wh-count-troops">
                        <xsl:with-param name="href" select="$href"/>
                    </xsl:call-template>
                </td>
            </tr>
        </table>

        <h3>Army list</h3>

        <xsl:variable name="nodes" select="document($href)//yb:characters"/>
        <xsl:choose>
            <xsl:when test="@display='short'">
                <xsl:apply-templates select="$nodes/yb:character/w:statistics"
                                     mode="short">
                    <xsl:sort select="w:attributes/@points" data-type="number" order="descending"/>
                </xsl:apply-templates>
            </xsl:when>

            <xsl:otherwise>
                <xsl:apply-templates select="$nodes/yb:character/w:statistics"
                                    mode="boxed">
                    <xsl:sort select="w:attributes/@points" data-type="number" order="descending"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="wh-calculate-cost">
        <xsl:param name="href" select="'.'"/>
        <xsl:param name="idx" select="1"/>
        <xsl:param name="total" select="0"/>

        <xsl:choose>
            <xsl:when test="document($href)//yb:characters/yb:character[$idx]/w:statistics">
                <xsl:variable name="stats"
                      select="document($href)//yb:characters/yb:character[$idx]/w:statistics"/>

                <xsl:variable name="units" select="$stats/w:deployment/w:number"/>
                <xsl:variable name="number" select="$stats/w:attributes/@number"/>
                <xsl:variable name="points" select="$stats/w:attributes/@points"/>

                <xsl:call-template name="wh-calculate-cost">
                    <xsl:with-param name="href" select="$href"/>
                    <xsl:with-param name="idx" select="$idx + 1"/>
                    <xsl:with-param name="total" select="$total + $number * $units * $points"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$total"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="wh-count-troops">
        <xsl:param name="href" select="'.'"/>
        <xsl:param name="idx" select="1"/>
        <xsl:param name="total" select="0"/>

        <xsl:choose>
            <xsl:when test="document($href)//yb:characters/yb:character[$idx]/w:statistics">
                <xsl:variable name="stats"
                              select="document($href)//yb:characters/yb:character[$idx]/w:statistics"/>

                <xsl:variable name="units" select="$stats/w:deployment/w:number"/>
                <xsl:variable name="number" select="$stats/w:attributes/@number"/>

                <xsl:call-template name="wh-count-troops">
                    <xsl:with-param name="href" select="$href"/>
                    <xsl:with-param name="idx" select="$idx + 1"/>
                    <xsl:with-param name="total" select="$total + $number * $units"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$total"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
        Simple statistics shows all the basic character abilities,
        but does not work out combat statistics and the like.
    -->
    <xsl:template match="w:statistics">
        <xsl:apply-templates select="w:deployment"/>
        <xsl:apply-templates select="w:attributes"/>
        <xsl:apply-templates select="w:special"/>
        <xsl:apply-templates select="w:options/w:option"/>
        <xsl:apply-templates select="w:equipment"/>
        <br/>
    </xsl:template>

    <xsl:template match="w:statistics" mode="boxed">
        <div style="border-top: 1pt solid green">
            <xsl:apply-templates select="."/>
        </div>
    </xsl:template>

    <xsl:template match="w:statistics" mode="short">
        <div style="border-top: 1pt solid green">
            <xsl:apply-templates select="w:deployment" mode="short"/>
            <xsl:apply-templates select="w:options/w:option"/>
            <xsl:apply-templates select="w:equipment"/>
        </div>
        <br/>
    </xsl:template>

    <xsl:template match="w:deployment">
        <p style="text-transform: uppercase;">
            <b>
                <xsl:if test="w:minimum">
                    <xsl:value-of select="w:minimum"/> -
                    <xsl:value-of select="w:maximum"/>
                    <xml:text>, </xml:text>
                </xsl:if>
                <xsl:value-of select="../../@name"/>
                <xsl:if test="w:number and w:number &gt; 1">
                    (<xsl:value-of select="w:number"/>)
                </xsl:if>
            </b>
            <xsl:if test="w:character">
                (character)
            </xsl:if>

            <xsl:variable name="units">
                <xsl:choose>
                    <xsl:when test="w:number">
                        <xsl:value-of select="w:number"/>
                    </xsl:when>
                    <xsl:otherwise>1</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:variable name="number">
                <xsl:choose>
                    <xsl:when test="../w:attributes/@number">
                        <xsl:value-of select="../w:attributes/@number"/>
                    </xsl:when>
                    <xsl:otherwise>1</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:variable name="points" select="../w:attributes/@points"/>

            - <xsl:value-of select="$units * $number * $points"/> points
        </p>
    </xsl:template>


    <xsl:template match="w:deployment" mode="short">
        <p style="text-transform: uppercase;">
            <xsl:variable name="units">
                <xsl:choose>
                    <xsl:when test="w:number">
                        <xsl:value-of select="w:number"/>
                    </xsl:when>
                    <xsl:otherwise>1</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:variable name="number">
                <xsl:choose>
                    <xsl:when test="../w:attributes/@number">
                        <xsl:value-of select="../w:attributes/@number"/>
                    </xsl:when>
                    <xsl:otherwise>1</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <b>
                <xsl:if test="w:minimum">
                    <xsl:value-of select="w:minimum"/> -
                    <xsl:value-of select="w:maximum"/>
                    <xml:text>, </xml:text>
                </xsl:if>
                <xsl:value-of select="../../@name"/>

                (<xsl:value-of select="$number"/>
                <xsl:if test="$units &gt; 1">
                    <span style="text-transform: lowercase;">x</span>
                    <xsl:value-of select="$units"/>
                </xsl:if>
                <xsl:text>)</xsl:text>
            </b>
            <xsl:if test="w:character">
                (character)
            </xsl:if>


            <xsl:variable name="points" select="../w:attributes/@points"/>

            - <xsl:value-of select="$units * $number * $points"/> points
        </p>
    </xsl:template>

    <!--
        attributes

        Display the character's attributes.
    -->
    <xsl:template match="w:attributes">
        <style>
            table.warhammer {
                margin: 0mm;
            }

            table.warhammer th {
                width: 7mm;
                font-weight: bold;
                color: black;
                background-color: #f7fff7;
            }

            table.warhammer th.name {
                width: 30mm;
            }

            table.warhammer td {
                text-align: center;
            }

            table.warhammer td.name {
                text-align: left;
            }
        </style>
        <table class="warhammer">
            <tr>
                <th class="name"/>
                <th>M</th>
                <th>WS</th>
                <th>BS</th>
                <th>S</th>
                <th>T</th>
                <th>W</th>
                <th>I</th>
                <th>A</th>
                <th>Ld</th>

                <!-- Only used by Warhammer Fantasy -->
                <xsl:if test="w:attribute[@name='int']">
                    <th>Int</th>
                    <th>Cl</th>
                    <th>WP</th>
                </xsl:if>

                <th>Pts</th>
            </tr>

            <tr>
                <td class="name">
                    <b>
                        <xsl:value-of select="@unit"/>
                        <xsl:if test="@number and @number &gt; 1">
                            x<xsl:value-of select="@number"/>
                        </xsl:if>
                    </b>
                </td>
                <xsl:apply-templates select="w:attribute[@name='m']"/>
                <xsl:apply-templates select="w:attribute[@name='ws']"/>
                <xsl:apply-templates select="w:attribute[@name='bs']"/>
                <xsl:apply-templates select="w:attribute[@name='s']"/>
                <xsl:apply-templates select="w:attribute[@name='t']"/>
                <xsl:apply-templates select="w:attribute[@name='w']"/>
                <xsl:apply-templates select="w:attribute[@name='i']"/>
                <xsl:apply-templates select="w:attribute[@name='a']"/>
                <xsl:apply-templates select="w:attribute[@name='ld']"/>
                <xsl:if test="w:attribute[@name='int']">
                    <!-- We either want all of them, or none of them -->
                    <xsl:apply-templates select="w:attribute[@name='int']"/>
                    <xsl:apply-templates select="w:attribute[@name='cl']"/>
                    <xsl:apply-templates select="w:attribute[@name='wp']"/>
                </xsl:if>

                <td><xsl:value-of select="@points"/></td>
            </tr>
       </table>
    </xsl:template>

    <!--
        attribute

        Display the value for a single attribute.
     -->
    <xsl:template match="w:attribute">
        <td><xsl:value-of select="@score"/></td>
    </xsl:template>

    <!--
        properties

        Units and/or characters can have special properties which are
        noted here.
     -->
    <xsl:template match="w:properties">
        <p>
            <xsl:if test="w:warband">* Warband </xsl:if>
            <xsl:if test="w:lightInfantry">* Light Infantry </xsl:if>
            <xsl:if test="w:shieldWall">* Shieldwall </xsl:if>
            <xsl:if test="w:stubborn">* Stubborn </xsl:if>
            <xsl:if test="w:hatred">* Hatred </xsl:if>
            <xsl:if test="w:frenzy">* Frenzy </xsl:if>
            <xsl:if test="w:drilled">* Drilled </xsl:if>
            <xsl:if test="w:twoWeapons">* Two Weapons </xsl:if>
            <xsl:if test="w:terror">* Terror </xsl:if>
            <xsl:if test="w:skirmishers">* Skirmishers </xsl:if>
            <xsl:if test="w:lightCavalry">* Light Cavalry </xsl:if>
            <xsl:if test="w:werod">* Werod </xsl:if>
            <xsl:if test="w:fury">* Fury </xsl:if>
            <xsl:if test="w:differentWeapons">* Different Weapons </xsl:if>
            <xsl:if test="w:furyOfTheNorsemen">* Fury of the Norsemen </xsl:if>
        </p>
    </xsl:template>

    <xsl:template match="w:special">
        <xsl:apply-templates select="w:properties"/>
        <xsl:if test="w:notes">
            <p>
                <xsl:value-of select="."/>
            </p>
        </xsl:if>
    </xsl:template>

    <xsl:template match="w:options/w:option">
        <p>
            <b>Option (<xsl:value-of select="@title"/>):</b>
            <xsl:apply-templates select="w:notes"/>
        </p>
        <xsl:apply-templates select="w:properties"/>
    </xsl:template>

    <xsl:template match="w:equipment">
        <p>
            <b>Equipment:</b>
            <xsl:for-each select="w:item">
                <xsl:choose>
                    <xsl:when test="position()=last()">
                        <xsl:value-of select="@name"/>.
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@name"/>,
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </p>
    </xsl:template>

</xsl:stylesheet>
