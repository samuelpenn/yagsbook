<?xml version="1.0"?>

<!--
    Stylesheet transform for Yagsbook to HTML.
    Displays the contents sidebar, auto-generated from the
    section headings within the document.

    Author:  Samuel Penn
    Version: $Revision: 1.5 $
    Date:    $Date: 2006/01/01 23:00:44 $

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
               version="1.0">

    <xsl:template name="make-contents">
        <h2>Contents</h2>
        <p class="contents">
            <xsl:apply-templates select="/yb:article/yb:body/yb:sect1"
                                mode="contents"/>
        </p>
    </xsl:template>

    <xsl:template name="h-name">
        <xsl:param name="string" select="f"/>

        <xsl:variable name="url">
            <xsl:value-of select="translate($string, &quot;&#x20;'&quot;, '')"/>
        </xsl:variable>

        <a name="{$url}"><xsl:value-of select="$string"/></a>
    </xsl:template>

    <xsl:template name="h-ref">
        <xsl:param name="string" select="'f'"/>
        <xsl:param name="link" select="'f'"/>
        <xsl:param name="level" select="'c1'"/>

        <xsl:variable name="url">
            <xsl:value-of select="translate($string, &quot;&#x20;'&quot;, '')"/>
        </xsl:variable>

        <a class="{$level}" href="#{$url}"><xsl:value-of select="$link"/></a>
    </xsl:template>

    <xsl:template match="yb:sect1[@href]" mode="contents">
        <xsl:choose>
            <xsl:when test="@name">
                <xsl:variable name="name" select="@name"/>
                <xsl:apply-templates
                        select="document(@href)//yb:sect1[@id=$name]"
                        mode="contents"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates
                        select="document(@href)//yb:sect1"
                        mode="contents"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="yb:sect1" mode="contents">
        <b>
            <xsl:call-template name="h-ref">
                <xsl:with-param name="string" select="./yb:title"/>
                <xsl:with-param name="link" select="./yb:title"/>
            </xsl:call-template>
        </b>
        <br />
        <xsl:apply-templates select="yb:sect2" mode="contents"/>
    </xsl:template>

    <xsl:template match="yb:sect2" mode="contents">
        <xsl:call-template name="h-ref">
            <xsl:with-param name="string" select="./yb:title"/>
            <xsl:with-param name="link" select="./yb:title"/>
            <xsl:with-param name="level" select="'c2'"/>
        </xsl:call-template>
        <br />
    </xsl:template>

</xsl:transform>
