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
    Version: $Revision: 1.21 $
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

    <xsl:param name="counterHref" select="null"/>

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
    <xsl:include href="mapcraft.xsl"/>
    <xsl:include href="vehicles.xsl"/>
    <!--
        <xsl:include href="advantages.xsl"/>
        <xsl:include href="skills.xsl"/>
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
        <xsl:variable name="title" select="/yb:article/yb:header/yb:title"/>
        <xsl:variable name="tagline">
            <xsl:choose>
                <xsl:when test="not($displayTagline = '')">
                    <xsl:value-of select="$displayTagline"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="/yb:article/yb:header/yb:tagline"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <html lang="en" xml:lang="en">
            <head>
                <title>
                    <xsl:value-of select="$tagline"/>
                    <xsl:text> : </xsl:text>
                    <xsl:value-of select="$title"/>
                </title>
                <meta name="title" content="{$title}" />

                <!-- Dublin Core tags -->

                <xsl:variable name="abstract">
                    <xsl:choose>
                        <xsl:when test="/yb:article/yb:header/yb:summary">
                            <xsl:value-of select="/yb:article/yb:header/yb:summary"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="/yb:article/yb:body/yb:sect1[1]/yb:para[1]"
                                                 mode="plain"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <meta name="DCTERMS.abstract" content="{normalize-space($abstract)}"/>
                <meta name="DC.creator" content="{/yb:article/yb:header/yb:author/yb:fullname}"/>


                <xsl:variable name="d" select="/yb:article/yb:header/yb:cvsinfo/yb:date"/>
                <xsl:variable name="date">
                    <xsl:value-of select="substring($d, 8, 19)"/>
                </xsl:variable>

                <!--
                <xsl:variable name="d2">
                    <xsl:value-of select="translate($d, &quot;$Date:&quot;, '')"/>
                </xsl:variable>

                <xsl:variable name="date">
                    <xsl:value-of select="translate($d2, '/', '-')"/>
                </xsl:variable>
                -->

                <meta name="DCTERMS.modified" content="{$date}"/>

                <link rel="STYLESHEET" media="screen" type="text/css"
                    href="/usr/share/css/default.css" />

                <link rel="STYLESHEET" media="screen" type="text/css"
                    href="/usr/share/xml/yagsbook/article/css/encyclopedia.css" />
            </head>

            <body>
                <div class="header">
                    <table width="100%">
                        <tr>
                            <td class="title" rowspan="2">
                                <h1>
                                    <xsl:value-of select="/yb:article/yb:header/yb:title"/>
                                </h1>
                            </td>

                            <td class="version">
                                <xsl:apply-templates
                                        select="/yb:article/yb:header/yb:cvsinfo"/>
                            </td>
                        </tr>
                        <tr>
                        <!--
                            <td class="title">
                                <h1><xsl:value-of select="$title"/></h1>
                            </td>
                            -->
                            <td class="subject">
                                <xsl:apply-templates
                                    select="/yb:article/yb:header/yb:topics/yb:subject"/>
                            </td>
                        </tr>
                    </table>
                </div>

                <div class="links">
                    <a href="../index.html">Main page</a>
                    <xsl:apply-templates
                            select="/yb:article/yb:header/yb:topics/yb:topic"
                            mode="links"/>
                </div>

                <xsl:if test="/yb:article">
                    <xsl:apply-templates select="/yb:article/yb:body"/>
                </xsl:if>

                <xsl:if test="$counterHref != 'null'">
                    <img src="{$counterHref}" width="0" height="0"/>
                </xsl:if>
            </body>
        </html>

        <xsl:text>
        </xsl:text>
    </xsl:template>

    <xsl:template match="/yb:article/yb:body">
        <div class="metadata">
            <xsl:apply-templates select="/yb:article/yb:header/yb:references"/>
        </div>

        <div class="bodytext">
            <xsl:apply-templates select="/yb:article/yb:body/yb:sect1"/>
        </div>

        <div class="license">
            <xsl:apply-templates select="/yb:article/yb:header/yb:license"/>
        </div>
    </xsl:template>

    <xsl:template match="yb:header/yb:topics">
        <xsl:if test="subject">
            <h2>Subject</h2>

            <p>
                <xsl:apply-templates select="yb:subject"/>
            </p>
        </xsl:if>
    </xsl:template>

    <xsl:template match="yb:header/yb:references">
        <xsl:if test="yb:see">
            <h2>See also</h2>

            <p>
                <xsl:apply-templates select="yb:see"/>
            </p>
        </xsl:if>
    </xsl:template>

    <xsl:template match="yb:topics/yb:subject">
        <xsl:variable name="first" select="substring(@uri, 1, 1)"/>
        <a href="../{$first}/{@uri}.html"><xsl:value-of select="."/></a><br/>
    </xsl:template>

    <xsl:template match="yb:references/yb:see">
        <xsl:variable name="first" select="substring(@uri, 1, 1)"/>
        <xsl:choose>
            <xsl:when test="position()=last()">
                <a href="../{$first}/{@uri}.html"><xsl:value-of select="."/></a>.
            </xsl:when>
            <xsl:otherwise>
                <a href="../{$first}/{@uri}.html"><xsl:value-of select="."/></a>,
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="yb:topics/yb:topic" mode="links">
        <a href="../{@uri}.html"><xsl:value-of select="."/></a>
    </xsl:template>

    <xsl:template match="yb:image">
        <img class="inline" src="../../images/{@uri}.png" align="left"/>
    </xsl:template>

    <xsl:template match="yb:image" mode="block">
        <td>
            <xsl:if test="@text">
                <img src="../../images/{@uri}.png"  alt="{@text}"/>
            </xsl:if>
            <xsl:if test="not(@text)">
                <img src="../../images/{@uri}.png"/>
            </xsl:if>
        </td>
    </xsl:template>

    <xsl:template match="yb:imageblock">
        <table class="imageblock">
            <tr>
                <xsl:apply-templates select="yb:image" mode="block"/>
            </tr>
        </table>
    </xsl:template>

    <xsl:template match="/yb:article/yb:header/yb:license">
        <p>
            Copyright (c)
            <xsl:value-of select="/yb:article/yb:header/yb:license/yb:year"/>,
            <xsl:value-of select="/yb:article/yb:header/yb:license/yb:holder"/>.
        </p>

        <xsl:choose>
            <xsl:when test="@type='GPL'">
                <p>
                    This document can be redistributed and/or modified
                    under the terms of the GNU Public License as published
                    by the Free Software Foundation, version 2 or any
                    later version.
                </p>

                <p>
                    <a href="http://www.gnu.org/licenses/gpl.html">
                        <img src="/images/button-gpl.png"
                             width="80" height="15" border="0"/>
                    </a>
                </p>
            </xsl:when>

            <xsl:when test="@type='GPL2'">
                <p>
                    This document can be redistributed and/or modified
                    under the terms of the GNU Public License as published
                    by the Free Software Foundation version 2.
                </p>

                <p>
                    <a href="http://www.gnu.org/licenses/gpl.html">
                        <img src="/images/button-gpl.png"
                             width="80" height="15" border="0"/>
                    </a>
                </p>
            </xsl:when>

            <xsl:when test="@type='FDL1.1'">
                <p>
                    Permission is granted to copy, distribute and/or
                    modify this document under the terms of the GNU
                    Free Documentation License, Version 1.1; with no
                    invariant sections, no Front-Cover Texts, and with
                    no Back-Cover Texts.
                </p>

                <p>
                    <a href="http://www.gnu.org/licenses/fdl.html">
                        <img src="/images/button-fdl.png"
                             width="80" height="15" border="0"/>
                    </a>
                </p>
            </xsl:when>

            <xsl:when test="@type='Yags'">
                <p>
                    This document can be redistributed and/or modified
                    under the terms of the GNU Public License as published
                    by the Free Software Foundation version 2.
                </p>

                <p>
                    <a href="http://www.gnu.org/licenses/gpl.html">
                        <img src="/images/button-gpl.png"
                             width="80" height="15" border="0"/>
                    </a>
                </p>
            </xsl:when>

            <xsl:otherwise>
                <p>
                    <xsl:value-of select="/yb:article/yb:header/yb:license/yb:text"/>
                    <br/>
                    <a href="{/yb:article/yb:header/yb:license/yb:url}">
                        See the license document for a
                        full copy of the license
                    </a>.
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="/yb:article/yb:header/yb:cvsinfo">
        <!-- Get the version, without the cvs tag -->
        <xsl:variable name="v" select="/yb:article/yb:header/yb:cvsinfo/yb:version"/>
        <xsl:variable name="version">
            <xsl:value-of select="translate($v, &quot;$Revision:&quot;, '')"/>
        </xsl:variable>

        <!-- Get the date, without the cvs tag -->
        <xsl:variable name="d" select="/yb:article/yb:header/yb:cvsinfo/yb:date"/>
        <xsl:variable name="date">
            <xsl:value-of select="translate($d, &quot;$Date:&quot;, '')"/>
        </xsl:variable>

        Version <xsl:value-of select="$version"/>
        (<xsl:value-of select="substring($date,1, 12)"/>)
    </xsl:template>

</xsl:transform>
