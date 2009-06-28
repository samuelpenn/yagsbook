<?xml version="1.0"?>

<!--
    Stylesheet transform for Yagsbook to PDF.

    This file defines the section headings and numbering system.
    There are five possible levels of numbering, from sect1 down
    to sect5. Each section can contain either block level elements
    (such as <para/> or <table/), or the next section type down.

    <sect1/> cannot directly contain a <sect3/>, but instead must
    nest the <sect3/> within a <sect2/>.

    Auto-numbering is used when displaying the section headings.

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

    <!--
        Section level one. This is the top level part of the body
        text, and is the only element which is a direct child of
        the <body> element.

        Consists of a <title>, and a number of block level elements,
        some of which may be <sect2> elements.
    -->
    <xsl:template match="/yb:article/yb:body/yb:sect1_">
        <xsl:if test="title">
            <fo:block
                font-weight="bold"
                color="{$colour}"
                font-size="{$font-xx-large}"
                font-family="sans-serif"
                line-height="{$font-xx-large}"
                space-after="{$font-medium}"
                text-align="start">

                <xsl:number level="multiple" format="1"/>
                <xsl:text> </xsl:text><xsl:value-of select="yb:title"/>
            </fo:block>
        </xsl:if>

        <!--
            Now find all the children. The numbering only applies
            to elements which make use of it, so we can happily pass
            it down to <para> and <table> elements without worry, as
            long as we don't use the 'prefix' parameter for anything
            else on other templates.
        -->
        <xsl:apply-templates>
            <xsl:with-param name="prefix">
                <xsl:number level="multiple" format="1"/>
            </xsl:with-param>
        </xsl:apply-templates>

    </xsl:template>


    <xsl:template match="/yb:article/yb:body/yb:sect1" mode="newpage">
    </xsl:template>

    <!--
        Section two elements are children of <sect1>.
    -->
    <xsl:template match="yb:sect2">
        <xsl:param name="prefix"/>
        <xsl:if test="yb:title">
            <fo:block
                font-weight="bold"
                color="{$colour}"
                font-size="{$font-x-large}"
                font-family="{$font-heading}"
                line-height="{$font-x-large}"
                space-after="{$font-medium}"
                text-align="start"
                border-after-width="1pt"
                border-after-color="{$colour}"
                border-after-style="solid"
                keep-with-next="always">
                <!--
                <xsl:value-of select="$prefix"/>.<xsl:number level="multiple" format="1"/>
                <xsl:text> </xsl:text>
                -->
                <xsl:value-of select="yb:title"/>
            </fo:block>
        </xsl:if>

        <xsl:apply-templates>
            <xsl:with-param name="prefix">
                <xsl:value-of select="$prefix"/>.<xsl:number level="multiple" format="1"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>

    <!--
        Section three elements are children of <sect2>.
    -->
    <xsl:template match="yb:sect3">
        <xsl:param name="prefix"/>
        <xsl:if test="yb:title">
            <fo:block
                font-weight="bold"
                color="{$colour}"
                font-size="{$font-large}"
                font-family="{$font-heading}"
                line-height="{$font-large}"
                space-after="{$font-medium}"
                text-align="start"
                keep-with-next="always">
                <!--
                <xsl:value-of select="$prefix"/>.<xsl:number level="multiple" format="1"/>
                <xsl:text> </xsl:text>
                -->
                <xsl:value-of select="yb:title"/>
            </fo:block>
        </xsl:if>

        <xsl:apply-templates>
            <xsl:with-param name="prefix">
                <xsl:value-of select="$prefix"/>.<xsl:number level="multiple" format="1"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>

    <!--
        Section four elements are children of <sect3>.
    -->
    <xsl:template match="yb:sect4">
        <xsl:param name="prefix"/>
        <xsl:if test="yb:title">
            <fo:block
                font-weight="bold"
                font-style="italic"
                color="{$colour}"
                font-size="{$font-medium}"
                font-family="{$font-heading}"
                line-height="{$font-large}"
                space-after="{$font-medium}"
                text-align="start">
                <!--
                <xsl:value-of select="$prefix"/>.<xsl:number level="multiple" format="1"/>
                <xsl:text> </xsl:text>
                -->
                <xsl:value-of select="yb:title"/>
            </fo:block>
        </xsl:if>

        <xsl:apply-templates>
            <xsl:with-param name="prefix">
                <xsl:value-of select="$prefix"/>.<xsl:number level="multiple" format="1"/>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>

    <!--
        Section five elements are children of <sect4>.
        <sect5> is the bottom section, no other sections are
        nested within this.
    -->
    <xsl:template match="yb:sect5">
        <xsl:param name="prefix"/>
        <xsl:if test="yb:title">
            <fo:block
                color="{$colour}"
                font-weight="bold"
                font-style="italic"
                font-size="{$font-medium}"
                font-family="{$font-body}"
                line-height="{$font-large}"
                space-after="{$font-medium}"
                text-align="start">
                <!--
                <xsl:value-of select="$prefix"/>.<xsl:number level="multiple" format="1"/>
                <xsl:text> </xsl:text>
                -->
                <xsl:value-of select="yb:title"/>
            </fo:block>
        </xsl:if>

        <!-- No need to pass numbering information down -->
        <xsl:apply-templates/>
    </xsl:template>


</xsl:stylesheet>

