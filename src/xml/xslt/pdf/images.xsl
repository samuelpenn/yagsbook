<?xml version="1.0"?>

<!--
    Stylesheet transform for Yagsbook to PDF.

    This file handles basic paragraphs, and inline styles such as
    bold and italic.

    Author:  Samuel Penn
    Version: $Revision: 1.3 $
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

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:fo="http://www.w3.org/1999/XSL/Format"
               xmlns:yb="http://yagsbook.sourceforge.net/xml"
               version="1.0">

    <xsl:template match="yb:span">
        <xsl:variable name="src" select="@src"/>
        <fo:block-container span="all" background-color="white">
            <fo:block>
                <fo:external-graphic src="{$src}" width="auto" height="auto"/>
            </fo:block>
        </fo:block-container>
    </xsl:template>

    <xsl:template match="yb:para/yb:svg">
        <xsl:variable name="src" select="@src"/>
        <xsl:variable name="width" select="@width"/>
        <xsl:variable name="height" select="@height"/>
        <xsl:variable name="name" select="@name"/>

        <fo:external-graphic
            src="{$src}" width="{$width}" height="{$height}"
            content-width="{$width}" content-height="{$height}"/>
    </xsl:template>

    <xsl:template match="yb:svg">
        <xsl:variable name="src" select="@src"/>
        <xsl:variable name="width" select="@width"/>
        <xsl:variable name="height" select="@height"/>
        <xsl:variable name="name" select="@name"/>

        <xsl:choose>
            <xsl:when test="@align='center'">
                <fo:block space-after="0pt" space-before="0px" text-align="center">
                    <fo:external-graphic
                        src="{$src}" width="{$width}" height="{$height}"
                        content-width="{$width}" content-height="{$height}"/>
                </fo:block>
            </xsl:when>
            <xsl:otherwise>
                <fo:external-graphic
                    src="{$src}" width="{$width}" height="{$height}"
                    content-width="{$width}" content-height="{$height}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="yb:para/yb:image">
        <xsl:variable name="src" select="@src"/>
        <xsl:variable name="width" select="@width"/>
        <xsl:variable name="height" select="@height"/>
        <xsl:variable name="name" select="@name"/>

        <fo:external-graphic src="{$src}" content-width="{$width}" />
    </xsl:template>

    <xsl:template match="yb:image">
        <xsl:variable name="src" select="@src"/>
        <xsl:variable name="width" select="@width"/>
        <xsl:variable name="height" select="@height"/>
        <xsl:variable name="name" select="@name"/>

        <xsl:choose>
            <xsl:when test="@align">
                <fo:block space-after="0pt" space-before="0px" text-align="center">
                    <fo:external-graphic src="{$src}" display-align="center" content-width="{$width}" />
                </fo:block>
            </xsl:when>
            <xsl:otherwise>
                <fo:block space-after="0pt">
                    <fo:external-graphic src="{$src}" content-width="{$width}" />
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:transform>
