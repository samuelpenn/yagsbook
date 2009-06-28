<?xml version="1.0"?>

<!--
    Stylesheet transform for Yagsbook to PDF. This file handles tables.

    Author:  Samuel Penn
    Version: $Revision: 1.5 $
    Date:    $Date: 2008/07/14 06:14:35 $

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


    <!-- ************************************************************** -->
    <!-- Template for table elements.                                   -->
    <!-- ************************************************************** -->
    <xsl:template match="yb:table">
        <xsl:variable name="numColumns"
                      select="count(yb:tbody/yb:row[1]/yb:entry)"/>
        <fo:table table-layout="fixed" space-after="{$font-small}" width="82mm">
            <xsl:apply-templates select="yb:colspec"/>
            <xsl:apply-templates select="yb:thead"/>
            <fo:table-body font-size="10pt" font-family="sans-serif">
                <xsl:apply-templates select="yb:tbody/yb:row"/>
            </fo:table-body>
        </fo:table>
    </xsl:template>

    <xsl:template match="yb:table/yb:colspec">
        <fo:table-column column-width="{@colwidth}"/>
    </xsl:template>

    <xsl:template match="yb:table/yb:thead">
        <fo:table-header>
            <fo:table-row>
                <xsl:apply-templates select="yb:row/yb:entry"/>
            </fo:table-row>
        </fo:table-header>
    </xsl:template>

    <xsl:template name="table-header-columns">
        <xsl:param name="count"/>
        <xsl:if test="$count > 0">
            <fo:table-column column-width="5cm"/>
            <xsl:call-template name="table-header-columns">
                <xsl:with-param name="count" select="$count - 1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template match="yb:table//yb:row">
        <xsl:variable name="bgcolour">
            <xsl:choose>
                <xsl:when test="position() mod 2 = 0">
                    <xsl:value-of select="$darkcolour"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$lightcolour"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <fo:table-row background-color="{$bgcolour}">
            <xsl:apply-templates select="yb:entry"/>
        </fo:table-row>
    </xsl:template>

    <xsl:template match="yb:table/yb:thead/yb:row/yb:entry">
        <fo:table-cell font-size="{$font-small}">
            <fo:block color="white" background-color="black">
                <xsl:value-of select="."/>
            </fo:block>
        </fo:table-cell>
    </xsl:template>

    <xsl:template match="yb:table/yb:tbody/yb:row/yb:entry">
        <fo:table-cell>
            <fo:block font-family="{$font-body}" text-align="start">
                <xsl:value-of select="."/>
            </fo:block>
        </fo:table-cell>
    </xsl:template>

</xsl:stylesheet>

