<?xml version="1.0"?>

<!--
    Stylesheet transform for Yagsbook to HTML.

    This is an alternative top level stylesheet for rendering
    articles to an ecyclopedia format. Such a format is a
    collection of many separate articles in one indexed web
    site. Output is a partial html document, not a full html
    document.

    All global variables should also be defined in this file.

    Author:  Samuel Penn
    Version: $Revision: 1.6 $
    Date:    $Date: 2005/08/13 22:06:46 $

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
<xsl:transform
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0"
    xmlns:yb="http://yagsbook.sourceforge.net/xml"
    xmlns:xalan="http://xml.apache.org/xalan"
    xmlns:java="http://xml.apache.org/xalan"
    xmlns:mapcraft="net.sourceforge.yagsbook.encyclopedia.Extensions"
    extension-element-prefixes="mapcraft">

    <xalan:component prefix="mapcraft">
        <xalan:script lang="javaclass"
                      src="xalan://net.sourceforge.yagsbook.encyclopedia.Extensions"/>
    </xalan:component>

    <xsl:template match="//yb:import-map">
        <xsl:variable name="thumb">
            <xsl:choose>
                <xsl:when test="@thumb">
                    <xsl:value-of select="@thumb"/>
                </xsl:when>
                <xsl:otherwise>
                    0
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="path">
            <xsl:choose>
                <xsl:when test="./yb:crop">
                </xsl:when>
                <xsl:when test="./yb:area">
                    <xsl:value-of select="mapcraft:importAreaMap(@uri, @scale, @thumb,
                                  yb:area/@name, yb:area/@margin)"/>
                </xsl:when>
                <xsl:when test="./yb:thing">
                    <xsl:value-of select="mapcraft:importThingMap(@uri, @scale, @thumb,
                                  yb:thing/@name, yb:thing/@radius)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="mapcraft:importMap(@uri, @scale, @thumb)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="@thumb">
                <xsl:variable name="tpath">
                    <xsl:value-of select="mapcraft:getThumbPath($path)"/>
                </xsl:variable>
                <a href="{$path}">
                    <img class="map" src="{$tpath}" align="right"/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <img class="map" src="{$path}" align="right"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>


</xsl:transform>

