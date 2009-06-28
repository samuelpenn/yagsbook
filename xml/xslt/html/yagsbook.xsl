<?xml version="1.0"?>

<!--
    Stylesheet transform for Yagsbook to HTML.

    This is the top level stylesheet, which includes all the other
    stylesheet files, and handles the header and top level body
    parts of the document.

    All global variables should also be defined in this file.

    Author:  Samuel Penn
    Version: $Revision: 1.16 $
    Date:    $Date: 2006/09/08 14:29:18 $

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

    <!-- Global constants -->
    <xsl:include href="globals.xsl"/>

    <!-- Generic elements (mostly DocBook compatible) -->
    <xsl:include href="contents.xsl"/>
    <xsl:include href="header.xsl"/>
    <xsl:include href="headings.xsl"/>
    <xsl:include href="tables.xsl"/>
    <xsl:include href="variablelist.xsl"/>
    <xsl:include href="para.xsl"/>
    <xsl:include href="images.xsl"/>

    <!-- Gaming specific elements -->
    <xsl:include href="bestiary.xsl"/>
    <xsl:include href="characters.xsl"/>
    <xsl:include href="equipment.xsl"/>
    <xsl:include href="library.xsl"/>
    <xsl:include href="people.xsl"/>
    <xsl:include href="vehicles.xsl"/>
    <!--
        <xsl:include href="spells.xsl"/>
        <xsl:include href="advantages.xsl"/>
        <xsl:include href="skills.xsl"/>
        <xsl:include href="invocations.xsl"/>
    -->

    <xsl:include href="yags/yags.xsl"/>

    <xsl:output method="xml"
                doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
                doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
    />


    <!-- Set variable for the syle of the article -->

    <xsl:variable name="article-style">
        <xsl:if test="/yb:article">
            <xsl:value-of select="/yb:article/yb:header/yb:style/@name"/>
        </xsl:if>

        <xsl:if test="/yb:bestiary">bestiary</xsl:if>
        <xsl:if test="/yb:characters">character</xsl:if>
    </xsl:variable>

    <xsl:template match="/">
        <html lang="en" xml:lang="en">
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />

                <meta name="DCTERMS.abstract"
                      content="{normalize-space(/yb:article/yb:header/yb:summary)}"/>
                <meta name="DC.creator"
                      content="{/yb:article/yb:header/yb:author/yb:fullname}"/>

                <xsl:variable name="d" select="/yb:article/yb:header/yb:cvsinfo/yb:date"/>
                <xsl:variable name="date">
                    <xsl:value-of select="substring($d, 8, 19)"/>
                </xsl:variable>
                <meta name="DCTERMS.modified" content="{$date}"/>

                <link rel="STYLESHEET" type="text/css" media="screen"
                    href="/usr/share/xml/yagsbook/article/css/screen.css" />
                <link rel="STYLESHEET" type="text/css" media="print"
                    href="/usr/share/xml/yagsbook/article/css/print.css" />
                <link rel="STYLESHEET" type="text/css"
                    href="/usr/share/xml/yagsbook/article/css/{$article-style}.css"/>
                <title>
                    <xsl:choose>
                        <xsl:when test="/yb:article">
                            <xsl:value-of select="/yb:article/yb:header/yb:title"/>
                        </xsl:when>

                        <xsl:when test="/yb:characters">
                            <xsl:value-of select="/yb:characters/yb:character/@name"/>
                        </xsl:when>

                        <xsl:when test="/yb:bestiary">
                            <xsl:value-of select="/yb:bestiary/yb:beast[1]/@name"/>
                        </xsl:when>
                    </xsl:choose>
                </title>
            </head>

            <body>
                <xsl:if test="/yb:article">
                    <xsl:apply-templates select="/yb:article/yb:header"/>
                    <xsl:apply-templates select="/yb:article/yb:body"/>
                </xsl:if>

                <xsl:if test="/yb:bestiary">
                    <xsl:apply-templates select="/yb:bestiary"/>
                </xsl:if>

                <xsl:if test="/yb:characters">
                    <xsl:apply-templates select="/yb:characters"/>
                </xsl:if>
            </body>
        </html>
        <xsl:text>
        </xsl:text>
    </xsl:template>


    <xsl:template match="/yb:article/yb:header">
        <h1 class="header"><xsl:value-of select="yb:title"/></h1>
    </xsl:template>

    <xsl:template match="/yb:article/yb:body">
        <div class="sidebar">
            <xsl:call-template name="make-contents"/>
            <xsl:call-template name="display-header"/>
        </div>

        <div class="bodytext">
            <xsl:apply-templates select="/yb:article/yb:body/yb:sect1"/>
        </div>
    </xsl:template>
</xsl:transform>
