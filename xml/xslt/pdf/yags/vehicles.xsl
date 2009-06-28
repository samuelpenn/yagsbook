<?xml version="1.0"?>

<!--
    Stylesheet transform for Yagsbook to PDF.

    These templates are for inline vehicle descriptions. Vehicles are
    considered to be an item of equipment.

    Author:  Samuel Penn
    Version: $Revision: 1.6 $
    Date:    $Date: 2007/07/29 16:16:58 $

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
                xmlns:y="http://yagsbook.sourceforge.net/xml/yags"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">

    <xsl:template match="y:vehicle" mode="full">
        <fo:block>
            <xsl:apply-templates select="y:attributes"/>
        </fo:block>

        <xsl:if test="y:combat/y:armour">
            <fo:block font-size="{$font-medium}">
                <xsl:apply-templates select="y:combat/y:armour"/>
            </fo:block>
        </xsl:if>

        <xsl:if test="y:combat/y:weapon">
            <fo:block start-indent="2pt" font-size="{$font-medium}" font-family="{$font-body}">
                <xsl:apply-templates select="y:combat/y:weapon"/>
            </fo:block>
        </xsl:if>
    </xsl:template>

    <xsl:template match="y:vehicle/y:combat/y:armour">
        <fo:block>
            <xsl:choose>
                <xsl:when test="@location">
                    <fo:inline font-weight="bold">Armour (<xsl:value-of select="@location"/>): </fo:inline>
                </xsl:when>
                <xsl:otherwise>
                    <fo:inline font-weight="bold">Armour: </fo:inline>
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
            <fo:inline font-style="italic"> (Half: <xsl:value-of select="$half"/>) </fo:inline>
            <xsl:apply-templates select="y:properties"/>
        </fo:block>
    </xsl:template>

    <xsl:template match="y:vehicle/y:combat/y:weapon">
        <fo:block font-weight="bold" font-style="italic" color="red">
            <xsl:value-of select="@name"/>
        </fo:block>

        <fo:block>
            <fo:inline font-weight="bold">Atk: </fo:inline><xsl:value-of select="y:attack/@score"/>;
            <fo:inline font-weight="bold">Dmg: </fo:inline><xsl:value-of select="y:damage/@score"/>
            <xsl:if test="y:properties">
                (<xsl:apply-templates select="y:properties"/>)
            </xsl:if>
        </fo:block>

        <fo:block>
            <fo:inline font-weight="bold">Inc: </fo:inline>
            <xsl:value-of select="y:increment"/>m;
            <fo:inline font-weight="bold">Ranges: </fo:inline>
            <xsl:apply-templates select="y:range/y:short"/><xsl:text> / </xsl:text>
            <xsl:apply-templates select="y:range/y:medium"/><xsl:text> / </xsl:text>
            <xsl:apply-templates select="y:range/y:long"/>
        </fo:block>

        <fo:block>
            <fo:inline font-weight="bold">Capacity: </fo:inline> <xsl:value-of select="y:capacity"/>;
            <fo:inline font-weight="bold">RoF: </fo:inline> <xsl:value-of select="y:rof"/>;
            <fo:inline font-weight="bold">Recoil: </fo:inline> <xsl:value-of select="y:recoil"/>
        </fo:block>
    </xsl:template>

    <!-- Display vehicle attributes -->
    <xsl:template match="y:vehicle/y:attributes">
        <fo:table table-layout="fixed">
            <fo:table-column column-width="12mm"/>
            <fo:table-column column-width="8mm"/>
            <fo:table-column column-width="8mm"/>
            <fo:table-column column-width="8mm"/>
            <fo:table-column column-width="8mm"/>
            <fo:table-column column-width="10mm"/>
            <fo:table-column column-width="12mm"/>
            <fo:table-column column-width="12mm"/>

            <fo:table-header>
                <fo:table-row font-size="10pt" font-weight="bold">
                    <fo:table-cell><fo:block>Siz</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>Str</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>Hea</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>Agi</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>Per</fo:block></fo:table-cell>

                    <fo:table-cell><fo:block>Soak</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>Move</fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>Accl</fo:block></fo:table-cell>
                </fo:table-row>
            </fo:table-header>

            <fo:table-body font-size="10pt" font-family="Times">
                <fo:table-row>
                    <fo:table-cell><fo:block>
                        <xsl:value-of select="@size"/>
                        <xsl:if test="../y:stealth">
                            <xsl:text>/</xsl:text>
                            <xsl:value-of select="@size + ../y:stealth/@signature"/>
                        </xsl:if>
                    </fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>
                        <xsl:value-of select="y:attribute[@name='strength']/@score"/>
                    </fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>
                        <xsl:value-of select="y:attribute[@name='health']/@score"/>
                    </fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>
                        <xsl:value-of select="y:attribute[@name='agility']/@score"/>
                    </fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>
                        <xsl:value-of select="y:attribute[@name='perception']/@score"/>
                    </fo:block></fo:table-cell>

                    <fo:table-cell><fo:block>
                        <xsl:value-of select="@soak"/>
                    </fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>
                        <xsl:value-of select="@move"/>
                    </fo:block></fo:table-cell>
                    <fo:table-cell><fo:block>
                        <xsl:value-of select="@acceleration"/>
                    </fo:block></fo:table-cell>
            </fo:table-row>
            </fo:table-body>
        </fo:table>

        <fo:block space-after="0pt" font-size="{$font-small}">
            <fo:block color="red" font-weight="bold" font-family="{$font-heading}">
                Damage track
            </fo:block>

            <fo:block>
                <fo:inline font-weight="bold"><xsl:text>+0 : </xsl:text></fo:inline>
                <xsl:call-template name="output-track">
                    <xsl:with-param name="count" select="ceiling(@size div 3)"/>
                </xsl:call-template>
            </fo:block>

            <fo:block>
                <fo:inline font-weight="bold">-10: </fo:inline>
                <xsl:call-template name="output-track">
                    <xsl:with-param name="count" select="ceiling((@size - 1) div 3)"/>
                </xsl:call-template>
            </fo:block>

            <fo:block>
                <fo:inline font-weight="bold">-25: </fo:inline>
                <xsl:call-template name="output-track">
                    <xsl:with-param name="count" select="ceiling((@size - 2) div 3)"/>
                </xsl:call-template>
            </fo:block>

            <fo:block>
                <fo:inline font-weight="bold">-40: </fo:inline>O (Disabled)
            </fo:block>
        </fo:block>
    </xsl:template>


</xsl:stylesheet>

