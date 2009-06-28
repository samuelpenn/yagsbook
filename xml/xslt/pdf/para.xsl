<?xml version="1.0"?>
<!--
    Stylesheet transform for Yagsbook to PDF.

    Handles all paragraph styles.

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

    <!-- Paragraph block element -->
    <xsl:template name="para" match="yb:para">
        <fo:block
            font-size="{$font-medium}"
            font-family="{$font-body}"
            line-height="{$font-large}"
            space-after="{$font-medium}">

            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="yb:para[@flag]">
        <fo:block-container keep-together="always"
                            background-image="{$svgImageBase}flag-{@flag}.svg"
                            background-repeat="no-repeat">
            <fo:block
                font-size="{$font-medium}"
                font-family="{$font-body}"
                line-height="{$font-large}"
                space-after="{$font-medium}"
                start-indent="20px">

                <xsl:apply-templates/>
            </fo:block>
        </fo:block-container>
    </xsl:template>

    <xsl:template name="pararaw" match="yb:para" mode="raw">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- Emphasis -->
    <xsl:template match="yb:e">
        <fo:inline font-style="italic">
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <!-- Strong emphasis -->
    <xsl:template match="yb:s">
        <fo:inline font-weight="bold">
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <!-- Trademark -->
    <xsl:template match="yb:tm">
        <fo:inline font-weight="bold" font-style="italic">
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <!-- Note -->
    <xsl:template match="yb:para/yb:note">
        <fo:inline font-style="italic">
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <!-- Warning -->
    <xsl:template match="yb:para/yb:warning">
        <fo:inline font-weight="bold" font-style="italic">
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <!--
        This is a note which stands out from the main text.
    -->
    <xsl:template match="yb:note">
        <fo:block-container keep-together="always">
            <fo:block font-size="{$font-medium}"
                    color="black" background-color="#ffffb4" space-after="{$font-medium}">

                <xsl:if test="@title">
                    <fo:block background-color="white"
                            background-image="{$svgImageBase}designer-notes.svg"
                            background-repeat="no-repeat"

                            padding-top="16px" padding-bottom="4px">

                        <fo:block start-indent="40px" font-family="{$font-heading}"
                                  font-weight="bold">
                            <xsl:value-of select="@title"/>
                        </fo:block>
                    </fo:block>
                </xsl:if>

                <fo:block border-style="solid" border-width="0pt" border-color="black">
                    <fo:block margin="2pt">
                        <xsl:apply-templates/>
                    </fo:block>
                </fo:block>
            </fo:block>
        </fo:block-container>
    </xsl:template>

    <!-- URL -->
    <xsl:template match="yb:url">
        <fo:basic-link external-destination="{@href}"
                       text-decoration="underline" color="blue">
            <xsl:apply-templates/>
        </fo:basic-link>
        [<xsl:value-of select="@href"/>]
    </xsl:template>

    <!--
        Description
     -->
    <xsl:template match="yb:description">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="yb:example">
        <fo:block-container keep-together="always">
            <fo:block font-size="{$font-medium}"
                    color="black" background-color="#d4d4ff" space-after="{$font-medium}">

                <xsl:if test="@title">
                    <fo:block background-color="white"
                            background-image="{$svgImageBase}example.svg"
                            background-repeat="no-repeat"

                            padding-top="16px" padding-bottom="4px">

                        <fo:block start-indent="40px" font-family="{$font-heading}"
                                  font-weight="bold">
                            <xsl:value-of select="@title"/>
                        </fo:block>
                    </fo:block>
                </xsl:if>

                <fo:block border-style="solid" border-width="0pt" border-color="black">
                    <fo:block margin="2pt">
                        <xsl:apply-templates/>
                    </fo:block>
                </fo:block>
            </fo:block>
        </fo:block-container>
    </xsl:template>

    <xsl:template match="yb:quote">
        <fo:block font-style="italic" font-size="9pt"
                  margin-left="10mm"
                  margin-right="5mm"
                  space-after="10pt">

            <fo:block text-align="left">
                <xsl:value-of select="."/>
            </fo:block>

            <xsl:if test="@signature">
                <fo:block text-align="right">
                    -- <xsl:value-of select="@signature"/>
                </fo:block>
            </xsl:if>
        </fo:block>
    </xsl:template>

    <!--
        Trait
        A trait is a generic game system ability, attribute or trait,
        which is formatted in a particular way to stand out from the
        surrounding text.

        Traits are displayed as italic.
    -->
    <xsl:template match="yb:t">
        <fo:inline font-style="italic">
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>
</xsl:stylesheet>
