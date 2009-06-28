<?xml version="1.0"?>

<!--
    Stylesheet transform for Yagsbook to HTML.

    Templates for all the section headings, and any children
    thereof.

    Author:  Samuel Penn
    Version: $Revision: 1.5 $
    Date:    $Date: 2006/02/09 18:53:18 $

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

    <xsl:template match="yb:sect2/yb:title"/>
    <xsl:template match="yb:sect3/yb:title"/>
    <xsl:template match="yb:sect4/yb:title"/>
    <xsl:template match="yb:sect5/yb:title"/>

    <!--
        Import a section1 heading in from an external document.

        This allows a book to be built up from several different articles.
    -->
    <xsl:template match="yb:sect1[@href]">
        <xsl:variable name="body" select="document(@href)/yb:article/yb:body"/>
        <xsl:variable name="name" select="@name"/>

        <xsl:if test="not(@masked='true' and not($showMasked='true'))">
            <xsl:choose>
                <xsl:when test="@name">
                    <xsl:apply-templates select="$body/yb:sect1[@id=$name]"/>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:apply-templates select="$body/yb:sect1"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template match="yb:title" mode="link">
        <xsl:variable name="string" select="."/>

        <xsl:variable name="url">
            <xsl:value-of select="translate($string, &quot;&#x20;'&quot;, '')"/>
        </xsl:variable>

        <a name="{$url}"><xsl:value-of select="$string"/></a>
    </xsl:template>

    <xsl:template match="yb:sect1/yb:title">
        <h1><xsl:apply-templates select="." mode="link"/></h1>
    </xsl:template>
    <xsl:template match="yb:sect2/yb:title">
        <h2><xsl:apply-templates select="." mode="link"/></h2>
    </xsl:template>
    <xsl:template match="yb:sect3/yb:title">
        <h3><xsl:apply-templates select="." mode="link"/></h3>
    </xsl:template>
    <xsl:template match="yb:sect4/yb:title">
        <h4><xsl:apply-templates select="." mode="link"/></h4>
    </xsl:template>
    <xsl:template match="yb:sect5/yb:title">
        <h5><xsl:apply-templates select="." mode="link"/></h5>
    </xsl:template>

    <xsl:template match="yb:sect1">
        <xsl:choose>
            <xsl:when test="@masked='true' and $showMasked='true'">
                <div class="masked">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>

            <xsl:when test="@masked='true'">
                <!-- Do not display anything -->
            </xsl:when>

            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="yb:sect2">
        <xsl:choose>
            <xsl:when test="@masked='true' and $showMasked='true'">
                <div class="masked">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>

            <xsl:when test="@masked='true'">
                <!-- Do not display anything -->
            </xsl:when>

            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="yb:sect3">
        <xsl:choose>
            <xsl:when test="@masked='true' and $showMasked='true'">
                <div class="masked">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>

            <xsl:when test="@masked='true'">
                <!-- Do not display anything -->
            </xsl:when>

            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="yb:sect4">
        <xsl:choose>
            <xsl:when test="@masked='true' and $showMasked='true'">
                <div class="masked">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>

            <xsl:when test="@masked='true'">
                <!-- Do not display anything -->
            </xsl:when>

            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="yb:sect5">
        <xsl:choose>
            <xsl:when test="@masked='true' and $showMasked='true'">
                <div class="masked">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>

            <xsl:when test="@masked='true'">
                <!-- Do not display anything -->
            </xsl:when>

            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="yb:taglines">
        <p class="tagline">
            <xsl:for-each select="yb:line">
                <xsl:value-of select="."/><br />
            </xsl:for-each>
        </p>
    </xsl:template>
</xsl:transform>
