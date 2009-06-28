<?xml version="1.0"?>

<!--
    Stylesheet transform for Yagsbook to PDF.

    Defines the various list types, including variablelist,
    targetlist etc.

    Author:  Samuel Penn
    Version: $Revision: 1.8 $
    Date:    $Date: 2009/06/28 09:44:30 $

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
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">

    <!-- Item list -->
    <xsl:template match="yb:itemlist">
        <xsl:variable name="order" select="@order"/>
        <xsl:variable name="style">
            <xsl:choose>
                <xsl:when test="@style='italic'">italic</xsl:when>
                <xsl:otherwise>bold</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$order = 'strict'">
                <xsl:apply-templates select="yb:item" mode="term">
                    <xsl:with-param name="style" select="$style"/>
                </xsl:apply-templates>
            </xsl:when>

            <xsl:when test="$order = 'sort'">
                <xsl:apply-templates select="yb:item" mode="term">
                    <xsl:sort data-type="text" select="@name"/>
                    <xsl:with-param name="style" select="$style"/>
                </xsl:apply-templates>
            </xsl:when>

            <xsl:when test="$order = 'number'">
                <xsl:apply-templates select="yb:item" mode="term">
                    <xsl:sort data-type="number" select="@name"/>
                    <xsl:with-param name="style" select="$style"/>
                </xsl:apply-templates>
            </xsl:when>

            <xsl:when test="$order = '1'">
                <xsl:apply-templates select="yb:item" mode="list">
                    <xsl:with-param name="style" select="$style"/>
                </xsl:apply-templates>
            </xsl:when>

            <xsl:when test="$order = 'a'">
                <xsl:apply-templates select="yb:item" mode="list">
                    <xsl:with-param name="style" select="$style"/>
                </xsl:apply-templates>
            </xsl:when>

            <xsl:when test="$order = 'A'">
                <xsl:apply-templates select="yb:item" mode="list">
                    <xsl:with-param name="style" select="$style"/>
                </xsl:apply-templates>
            </xsl:when>

            <xsl:when test="$order = 'i'">
                <xsl:apply-templates select="yb:item" mode="list">
                    <xsl:with-param name="style" select="$style"/>
                </xsl:apply-templates>
            </xsl:when>

            <xsl:when test="$order = 'I'">
                <xsl:apply-templates select="yb:item" mode="list">
                    <xsl:with-param name="style" select="$style"/>
                </xsl:apply-templates>
            </xsl:when>

            <xsl:otherwise>
                <!-- 'strict' is the default if not understood -->
                <xsl:apply-templates select="yb:item" mode="list">
                    <xsl:with-param name="style" select="$style"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="yb:itemlist/yb:item" mode="term">
        <xsl:param name="style" select="'bold'"/>

        <xsl:variable name="weight">
            <xsl:choose>
                <xsl:when test="$style='bold'">bold</xsl:when>
                <xsl:otherwise>normal</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="italic">
            <xsl:choose>
                <xsl:when test="$style='italic'">italic</xsl:when>
                <xsl:otherwise>normal</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <fo:block font-size="{$font-medium}" space-after="{$font-medium}"
                  font-family="{$font-body}">
            <fo:inline font-weight="{$weight}" font-style="{$italic}">
                <xsl:value-of select="@name"/>:
            </fo:inline>
            <!-- <xsl:value-of select="."/> -->
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>


    <xsl:template match="yb:itemlist/yb:item" mode="list">
        <xsl:param name="style" select="'bold'"/>

        <xsl:variable name="weight">
            <xsl:choose>
                <xsl:when test="$style='bold'">bold</xsl:when>
                <xsl:otherwise>normal</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="italic">
            <xsl:choose>
                <xsl:when test="$style='italic'">italic</xsl:when>
                <xsl:otherwise>normal</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <fo:block font-size="{$font-medium}" space-after="{$font-medium}"
                  font-family="{$font-body}">
            <fo:inline font-weight="{$weight}" font-style="{$italic}">
                <xsl:value-of select="position()"/>.
            </fo:inline>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <!-- Target list -->
    <xsl:template name="targetlist" match="yb:targetlist">
        <xsl:variable name="targetWidth">
            <xsl:choose>
                <xsl:when test="@width">
                    <xsl:value-of select="@width"/>
                </xsl:when>
                <xsl:otherwise>22</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="valueWidth" select="82-$targetWidth"/>

        <xsl:variable name="align">
            <xsl:choose>
                <xsl:when test="@align">
                    <xsl:value-of select="@align"/>
                </xsl:when>
                <xsl:when test="@targetFirst='true'">left</xsl:when>
                <xsl:otherwise>right</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <fo:table table-layout="fixed" width="82mm" space-after="{$font-medium}">
            <xsl:choose>
                <xsl:when test="@targetFirst='true'">
                    <fo:table-column column-width="{$targetWidth}mm"/>
                    <fo:table-column column-width="{$valueWidth}mm"/>
                    <fo:table-header font-size="{$font-medium}"
                                     font-family="sans-serif">
                        <fo:table-row>
                            <fo:table-cell>
                                <fo:block color="white" background-color="black" text-align="{$align}">
                                    <xsl:value-of select="yb:targetLabel"/>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell>
                                <fo:block color="white" background-color="black">
                                    <xsl:value-of select="yb:valueLabel"/>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-header>
                </xsl:when>
                <xsl:otherwise>
                    <fo:table-column column-width="{$valueWidth}mm"/>
                    <fo:table-column column-width="{$targetWidth}mm"/>
                    <fo:table-header font-size="{$font-medium}"
                                     font-family="sans-serif">
                        <fo:table-row>
                            <fo:table-cell>
                                <fo:block color="white" background-color="black">
                                    <xsl:value-of select="yb:valueLabel"/>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell text-align="right">
                                <fo:block color="white" background-color="black" text-align="{$align}">
                                    <xsl:value-of select="yb:targetLabel"/>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-header>
                </xsl:otherwise>
            </xsl:choose>


            <fo:table-body font-size="10pt" font-family="sans-serif">
                <xsl:apply-templates select="yb:item"/>
            </fo:table-body>
        </fo:table>
    </xsl:template>

    <xsl:template match="yb:targetlist/yb:item">
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

        <fo:table-row background-color="{$bgcolour}" font-size="{$font-medium}">
            <xsl:choose>
                <xsl:when test="../@targetFirst='true'">
                    <xsl:apply-templates select="." mode="target"/>
                    <xsl:apply-templates select="." mode="value"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="." mode="value"/>
                    <xsl:apply-templates select="." mode="target"/>
                </xsl:otherwise>
            </xsl:choose>
        </fo:table-row>
    </xsl:template>

    <xsl:template match="yb:targetlist/yb:item" mode="target">
        <xsl:variable name="align">
            <xsl:choose>
                <xsl:when test="../@align">
                    <xsl:value-of select="../@align"/>
                </xsl:when>
                <xsl:when test="not(../@targetFirst='true')">right</xsl:when>
                <xsl:otherwise>left</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <fo:table-cell text-align="{$align}">
            <fo:block font-size="{$font-small}" font-family="{$font-body}">
                <xsl:value-of select="@target"/>
            </fo:block>
        </fo:table-cell>
    </xsl:template>

    <xsl:template match="yb:targetlist/yb:item" mode="value">
        <xsl:variable name="weight">
            <xsl:choose>
                <xsl:when test="../@bold='true'">bold</xsl:when>
                <xsl:otherwise>normal</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <fo:table-cell>
            <fo:block font-size="{$font-small}" font-family="{$font-body}">
                <xsl:if test="@value">
                    <fo:inline font-weight="{$weight}">
                        <xsl:value-of select="@value"/>
                    </fo:inline>
                </xsl:if>
                <xsl:apply-templates/>
            </fo:block>
        </fo:table-cell>
    </xsl:template>


</xsl:stylesheet>
