<?xml version="1.0"?>

<!--
    Stylesheet transform for Yagsbook to HTML.

    This file handles basic paragraphs, and inline styles such as
    bold and italic.

    Author:  Samuel Penn
    Version: $Revision: 1.2 $
    Date:    $Date: 2005/11/12 22:01:55 $

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

    <xsl:template match="yb:para/yb:svg">
        <xsl:variable name="src" select="@src"/>
        <xsl:variable name="width" select="@width"/>
        <xsl:variable name="height" select="@height"/>
        <xsl:variable name="name" select="@name"/>

        <object data="{$src}" type="image/svg+xml" name="{$name}"
                width="{$width}" height="{$height}">
            [SVG Image]
        </object>
    </xsl:template>

    <xsl:template match="yb:svg">
        <xsl:variable name="src" select="@src"/>
        <xsl:variable name="width" select="@width"/>
        <xsl:variable name="height" select="@height"/>
        <xsl:variable name="name" select="@name"/>

        <div style="text-align: center;">
            <object data="{$src}" type="image/svg+xml" name="{$name}"
                    width="{$width}" height="{$height}">
                [SVG Image]
            </object>
        </div>
    </xsl:template>
</xsl:transform>
