<?xml version="1.0"?>

<!--
    Stylesheet transform for Yagsbook to HTML.

    These templates are for vehicle descriptions and statistics.
    Currently only Dirtside vehicles are supported.

    Author:  Samuel Penn
    Version: $Revision: 1.7 $
    Date:    $Date: 2007/03/17 22:05:32 $

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
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ds="http://yagsbook.sourceforge.net/xml/dirtside"
                xmlns:yags="http://yagsbook.sourceforge.net/xml/yags"
                version="1.0">

    <!-- Import templates for game system specific rules -->
    <xsl:include href="dirtside/vehicles.xsl"/>
    <xsl:include href="yags/vehicles.xsl"/>

    <xsl:template match="yb:import-vehicles">
        <xsl:variable name="href" select="@href"/>

        <xsl:apply-templates select="document($href)/yb:vehicles/yb:vehicle">
            <xsl:sort select="@name" data-type="text"/>
        </xsl:apply-templates>
    </xsl:template>

    <!--
        An inline vehicle description.
    -->
    <xsl:template match="yb:vehicle">
        <div class="vehicle">
            <h4>
                <xsl:value-of select="@name"/>
                <xsl:if test="yb:description/yb:short">
                    - <xsl:value-of select="yb:description/yb:short"/>
                </xsl:if>
            </h4>

            <xsl:apply-templates select="yb:description" mode="stats"/>

            <xsl:apply-templates select="ds:statistics"/>
            <xsl:apply-templates select="yags:statistics"/>

            <xsl:apply-templates select="yb:description"/>
        </div>
    </xsl:template>

    <xsl:template match="yb:vehicle/yb:description" mode="stats">
        <p>
            <xsl:if test="yb:type">
                <b>Type: </b> <xsl:value-of select="yb:type"/>;
            </xsl:if>
            <xsl:if test="yb:manufacturer">
                <b>Manufacturer: </b> <xsl:value-of select="yb:manufacturer"/>;
            </xsl:if>
            <xsl:if test="yb:year">
                <b>Production date: </b> <xsl:value-of select="yb:year"/>;
            </xsl:if>
            <xsl:if test="yb:techLevel">
                <b>Tech Level: </b> <xsl:value-of select="yb:techLevel"/>;
            </xsl:if>
        </p>
        <p>
            <xsl:if test="yb:mass">
                <b>Mass: </b> <xsl:value-of select="yb:mass"/>;
            </xsl:if>
            <xsl:if test="yb:topSpeed">
                <b>Top Speed: </b>
                <xsl:value-of select="yb:topSpeed"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="yb:topSpeed/@units"/>;
            </xsl:if>
        </p>
    </xsl:template>

    <xsl:template match="yb:vehicle/yb:description">
        <table>
            <tr>
                <xsl:if test="yb:image">
                    <td>
                        <img src="{yb:image/@href}"/>
                    </td>
                </xsl:if>
                <xsl:if test="yb:physical">
                    <td>
                        <xsl:apply-templates select="yb:physical"/>
                    </td>
                </xsl:if>
            </tr>
        </table>
    </xsl:template>

    <xsl:template match="yb:vehicles">
        <table style="width: 100%;">
            <tr style="background-color: black; color: white;">
                <th align="left">Vehicle</th>
                <th align="center">Size</th>
                <th align="left">Type</th>
                <th align="center">Cost</th>
            </tr>
            <xsl:apply-templates select="yb:vehicle" mode="points">
                <xsl:sort select="@name"/>
            </xsl:apply-templates>
        </table>
        <br/>
        <xsl:apply-templates select="yb:vehicle">
            <xsl:sort select="@name"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="yb:vehicles/yb:vehicle" mode="points">
        <xsl:variable name="colour">
            <xsl:choose>
                <xsl:when test="position() mod 2 = 0">gray80</xsl:when>
                <xsl:otherwise>white</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tr style="background-color:{$colour}">
            <td><xsl:value-of select="@name"/></td>
            <td align="center">
                <xsl:value-of select="ds:statistics/ds:size"/>
            </td>
            <td><xsl:value-of select="yb:description/yb:short"/></td>
            <td align="center">
                <xsl:apply-templates select="ds:statistics" mode="points"/>
            </td>
        </tr>
    </xsl:template>

</xsl:stylesheet>
