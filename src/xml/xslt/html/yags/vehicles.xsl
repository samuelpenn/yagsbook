<?xml version="1.0"?>

<!--
    Yagsbook stylesheet for Skills

    Author:  Samuel Penn
    Version: $Revision: 1.2 $
    Date:    $Date: 2007/03/27 20:44:07 $

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

    <xsl:template match="yb:item/y:vehicle" mode="full">
        <div>
            <xsl:apply-templates select="y:attributes"/>
        </div>

        <xsl:if test="y:combat/y:weapon">
            <xsl:apply-templates select="y:combat/y:weapon"/>
        </xsl:if>
    </xsl:template>

    <!--
        Basic vehicle attributes.
    -->
    <xsl:template match="yb:item/y:vehicle/y:attributes">
        <table style="margin-left: 0mm">
            <tr>
                <td style="padding-right: 10mm">
                    <table class="attributes">
                        <tr>
                            <th>Size</th>
                            <td><xsl:value-of select="@size"/></td>

                            <th>Soak</th>
                            <td><xsl:value-of select="@soak"/></td>
                        </tr>

                        <tr>
                            <th>Strength</th>
                            <td><xsl:value-of select="y:attribute[@name='strength']/@score"/></td>

                            <th>Move</th>
                            <td><xsl:value-of select="@move"/></td>
                        </tr>

                        <tr>
                            <th>Health</th>
                            <td><xsl:value-of select="y:attribute[@name='health']/@score"/></td>

                            <th>Acceleration</th>
                            <td><xsl:value-of select="@acceleration"/></td>
                        </tr>

                        <tr>
                            <th>Agility</th>
                            <td><xsl:value-of select="y:attribute[@name='agility']/@score"/></td>

                            <th>Critical</th>
                            <td><xsl:value-of select="ceiling(@size div 3)"/></td>
                        </tr>
                    </table>
                </td>
                <td style="vertical-align: top; padding-right: 10mm;">
                    <p style="margin: 0pt">
                        <b> +0 : </b>
                        <xsl:call-template name="output-track">
                            <xsl:with-param name="count" select="ceiling(@size div 3)"/>
                        </xsl:call-template>
                    </p>
                    <p style="margin: 0pt">
                        <b>-10: </b>
                        <xsl:call-template name="output-track">
                            <xsl:with-param name="count" select="ceiling((@size - 1) div 3)"/>
                        </xsl:call-template>
                    </p>
                    <p style="margin: 0pt">
                        <b>-25: </b>
                        <xsl:call-template name="output-track">
                            <xsl:with-param name="count" select="ceiling((@size - 2) div 3)"/>
                        </xsl:call-template>
                    </p>
                    <p style="margin: 0pt">
                        <b>-40: </b> O (Disabled)
                    </p>
                </td>
                <td style="vertical-align: top">
                    <xsl:apply-templates select="../y:combat/y:armour"/>
                </td>
            </tr>
        </table>
    </xsl:template>

    <xsl:template match="y:vehicle/y:combat/y:armour">
        <div>
            <xsl:choose>
                <xsl:when test="@location">
                    <b>Armour (<xsl:value-of select="@location"/>): </b>
                </xsl:when>
                <xsl:otherwise>
                    <b>Armour: </b>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:variable name="soak" select="../../y:attributes/@soak"/>
            <xsl:variable name="total" select="$soak + @score"/>
            <xsl:variable name="half">
                <xsl:choose>
                    <xsl:when test="y:heavy">
                        <xsl:value-of select="$total"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$soak + floor(@score div 2)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:value-of select="$total"/>
            <i> (Half: <xsl:value-of select="$half"/>) </i>
            <xsl:apply-templates select="y:properties"/>
        </div>
    </xsl:template>

    <xsl:template match="y:vehicle/y:combat/y:weapon">
        <div class="weapon" style="margin-left: 10mm">
            <h5 style="margin: 0mm; margin-left: 10mm;"><xsl:value-of select="@name"/></h5>

            <p style="margin: 0mm; margin-left: 10mm;">
                <b>Atk: </b><xsl:value-of select="y:attack/@score"/>;
                <b>Dmg: </b><xsl:value-of select="y:damage/@score"/>;
                <xsl:if test="y:properties">
                    (<xsl:apply-templates select="y:properties"/>);
                </xsl:if>

                <b>Inc: </b><xsl:value-of select="y:increment"/>m;
                <b>Ranges: </b>
                <xsl:apply-templates select="y:range/y:short"/><xsl:text> / </xsl:text>
                <xsl:apply-templates select="y:range/y:medium"/><xsl:text> / </xsl:text>
                <xsl:apply-templates select="y:range/y:long"/>
            </p>

            <p style="margin: 0mm; margin-left: 10mm;">
                <b>Capacity: </b> <xsl:value-of select="y:capacity"/>;
                <b>RoF: </b> <xsl:value-of select="y:rof"/>;
                <b>Recoil: </b> <xsl:value-of select="y:recoil"/>
            </p>
        </div>
    </xsl:template>

</xsl:transform>
