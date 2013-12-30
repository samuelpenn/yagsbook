<?xml version="1.0"?>
<!--
    Stylesheet transform for Yagsbook to HTML.

    Displays version and author information in the sidebar.

    Author:  Samuel Penn
    Version: $Revision: 1.6 $
    Date:    $Date: 2005/08/10 07:04:59 $

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

    <xsl:template name="display-header">
        <h2>Version</h2>

        <xsl:if test="/yb:article/yb:header/yb:cvsinfo">
            <!-- Get the version, without the cvs tag -->
            <xsl:variable name="v" select="/yb:article/yb:header/yb:cvsinfo/yb:version"/>
            <xsl:variable name="version">
                <xsl:value-of select="translate($v, &quot;$Revision&quot;, '')"/>
            </xsl:variable>

            <!-- Get the date, without the cvs tag -->
            <xsl:variable name="d" select="/yb:article/yb:header/yb:cvsinfo/yb:date"/>
            <xsl:variable name="date">
                <xsl:value-of select="translate($d, &quot;$Date&quot;, '')"/>
            </xsl:variable>

            <p>
                <b>Version</b><xsl:value-of select="$version"/>
                <br />
                <b>Date</b><xsl:value-of select="substring($date,1, 12)"/>
            </p>
        </xsl:if>

        <xsl:if test="/yb:article/yb:header/yb:author">
            <h2>Author</h2>
            <p>
                <xsl:variable name="mailto">
                    <xsl:value-of select="/yb:article/yb:header/yb:author/yb:email"/>
                </xsl:variable>
                <xsl:value-of select="/yb:article/yb:header/yb:author/yb:fullname"/>
            </p>
        </xsl:if>

        <xsl:if test="/yb:article/yb:header/yb:license">
            <h2>Copyright</h2>
            <p class="copyright">
                Copyright (c)
                <xsl:value-of select="/yb:article/yb:header/yb:license/yb:year"/>,
                <xsl:value-of select="/yb:article/yb:header/yb:license/yb:holder"/>.
            </p>

            <xsl:choose>
                <xsl:when test="/yb:article/yb:header/yb:license/@type">
                    <xsl:apply-templates select="/yb:article/yb:header/yb:license"/>
                </xsl:when>

                <xsl:otherwise>
                    <p class="license">
                        <xsl:value-of select="/yb:article/yb:header/yb:license/yb:text"/>
                    </p>

                    <xsl:if test="/yb:article/yb:header/yb:license/yb:url">
                        <p class="license">
                            <a href="{/yb:article/yb:header/yb:license/yb:url}">
                                See the license document for a
                                full copy of the license
                            </a>.
                        </p>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>

    </xsl:template>

    <xsl:template match="yb:license">
        <xsl:choose>
            <xsl:when test="@type='GPL'">
                <p class="license">
                    This document can be redistributed and/or modified
                    under the terms of the GNU Public License as published
                    by the Free Software Foundation, version 2 or any
                    later version.
                </p>

                <p class="license">
                    <a href="http://www.gnu.org/licenses/gpl.html">
                        <img src="/images/button-gpl.png"
                             width="80" height="15" border="0"/>
                    </a>
                </p>
            </xsl:when>

            <xsl:when test="@type='GPL2'">
                <p class="license">
                    This document can be redistributed and/or modified
                    under the terms of the GNU Public License as published
                    by the Free Software Foundation version 2.
                </p>

                <p class="license">
                    <a href="http://www.gnu.org/licenses/gpl.html">
                        <img src="/images/button-gpl.png"
                             width="80" height="15" border="0"/>
                    </a>
                </p>
            </xsl:when>

            <xsl:when test="@type='FDL1.1'">
                <p class="license">
                    Permission is granted to copy, distribute and/or
                    modify this document under the terms of the GNU
                    Free Documentation License, Version 1.1; with no
                    invariant sections, no Front-Cover Texts, and with
                    no Back-Cover Texts.
                </p>

                <p class="license">
                    <a href="http://www.gnu.org/licenses/fdl.html">
                        <img src="/images/button-fdl.png"
                             width="80" height="15" border="0"/>
                    </a>
                </p>
            </xsl:when>

            <xsl:when test="@type='Yags'">
                <p class="license">
                    This document can be redistributed and/or modified
                    under the terms of the GNU Public License as published
                    by the Free Software Foundation version 2.
                </p>

                <p class="license">
                    <a href="http://www.gnu.org/licenses/gpl.html">
                        <img src="/images/button-gpl.png"
                             width="80" height="15" border="0"/>
                    </a>
                </p>
            </xsl:when>

            <xsl:when test="@type='BSD'">
                <p class="license">
                    Redistribution and use in source, binary and printed
                    forms with or without modification is permitted. See
                    the full license text for details.
                </p>

                <p class="license">
                    <a href="http://www.glendale.org.uk/bsd.txt">
                        <img src="http://www.glendale.org.uk/images/button-bsd.png"
                             width="80" height="15" border="0"/>
                    </a>
                </p>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

</xsl:transform>
