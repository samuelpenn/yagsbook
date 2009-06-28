<?xml version="1.0"?>

<!--
    Stylesheet transform for Yagsbook to HTML.

    This file handles basic paragraphs, and inline styles such as
    bold and italic.

    Author:  Samuel Penn
    Version: $Revision: 1.7 $
    Date:    $Date: 2007/02/25 13:20:56 $

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

    <xsl:template match="yb:para">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="yb:para" mode="plain">
        <p>
            <xsl:apply-templates mode="plain"/>
        </p>
    </xsl:template>

    <xsl:template match="yb:para" mode="raw">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="yb:e">
        <em><xsl:apply-templates/></em>
    </xsl:template>

    <xsl:template match="yb:e" mode="plain">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="yb:s">
        <strong><xsl:apply-templates/></strong>
    </xsl:template>

    <xsl:template match="yb:s" mode="plain">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="yb:br">
        <br />
    </xsl:template>

    <xsl:template match="yb:br" mode="plain">
    </xsl:template>

    <!-- Trademarked or similar name -->
    <xsl:template match="yb:tm">
        <b><i><xsl:apply-templates/></i></b>
    </xsl:template>

    <xsl:template match="yb:tm" mode="plain">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- This text is an important note which needs to stand out -->
    <xsl:template match="yb:para/yb:note">
        <span class="note"><xsl:apply-templates/></span>
    </xsl:template>

    <xsl:template match="yb:para/yb:note" mode="plain">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="yb:note">
        <div class="note">
            <xsl:if test="@title">
                <h6><xsl:value-of select="@title"/></h6>
            </xsl:if>

            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!-- This text is a warning, and must stand out in a very obvious way -->
    <xsl:template match="yb:warning">
        <span class="warning"><xsl:apply-templates/></span>
    </xsl:template>

    <xsl:template match="yb:warning" mode="plain">
        <xsl:apply-templates/>
    </xsl:template>

    <!--
        Generic hypertext link, to a fixed external document.
        Used in much the same way as an <a href=""></a> in HTML.
        e.g. <url href="foo.html">see foo</url>
     -->
    <xsl:template match="yb:url">
        <a href="{@href}"><xsl:value-of select="."/></a>
    </xsl:template>

    <xsl:template match="yb:url" mode="plain">
        <xsl:apply-templates/>
    </xsl:template>

    <!--
        See also. Used by encyclopedia entries to reference
        other encyclopedia entries. Different from an <url>
        because the link is calculated at rendering time,
        not at authoring time.
        e.g. <qv uri="foo">Foo</qv>
        Note that the .html extension is left out. This would
        generate HTML as follows:
            <a href="../f/foo.html">Foo</a>
     -->
    <xsl:template match="yb:qv">
        <xsl:variable name="first">
            <xsl:value-of select="substring(@uri, 1, 1)"/>
        </xsl:variable>
        <a href="../{$first}/{@uri}.html"><xsl:value-of select="."/></a>
    </xsl:template>

    <xsl:template match="yb:qv" mode="plain">
        <xsl:apply-templates/>
    </xsl:template>

    <!--
        An aside is a note which should be displayed seperate from the
        main text, possibly to the side, and in a smaller font.
     -->
    <xsl:template match="yb:aside">
        <div class="aside">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="yb:aside" mode="plain">
    </xsl:template>

    <!--
        An annotation is an inline markup which displays the text on
        mouse hover over the marked up area.
     -->
    <xsl:template match="yb:ano">
        <span class="annotation" title="{@label}"><xsl:value-of select="."/></span>
    </xsl:template>

    <xsl:template match="yb:ano" mode="plain">
        <xsl:apply-templates/>
    </xsl:template>

    <!--
        Trait
        A trait is a generic game system ability, attribute or trait,
        which is formatted in a particular way to stand out from the
        surrounding text.

        Traits are displayed as italic.
        -->
    <xsl:template match="yb:t">
        <i><xsl:apply-templates/></i>
    </xsl:template>

    <xsl:template match="yb:example">
        <div class="example">
            <xsl:choose>
                <xsl:when test="@title">
                    <h5><xsl:value-of select="@title"/></h5>
                </xsl:when>
                <xsl:otherwise>
                    <h5>Example</h5>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="yb:quote">
        <div class="quote">
            <p style="text-align: center">
                <xsl:value-of select="."/>
            </p>

            <xsl:if test="@signature">
                <p style="text-align: right">
                    -- <xsl:value-of select="@signature"/>
                </p>
            </xsl:if>
        </div>
    </xsl:template>


</xsl:transform>
