<?xml version="1.0"?>

<!--
    Stylesheet transform for Yagsbook to HTML.

    This file handles everything to do with tables.

    Author:  Samuel Penn
    Version: $Revision: 1.4 $
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

    <xsl:template match="yb:table">
        <center>
            <table>
                <xsl:apply-templates select="yb:thead"/>
                <xsl:apply-templates select="yb:tbody"/>
            </table>
        </center>
    </xsl:template>


    <xsl:template match="yb:thead">
        <tr>
            <xsl:apply-templates select="yb:row/yb:entry"/>
        </tr>
    </xsl:template>

    <xsl:template match="yb:thead/yb:row/yb:entry">
        <th valign="left"><xsl:value-of select="."/></th>
    </xsl:template>


    <xsl:template match="yb:tbody">
        <xsl:apply-templates select="yb:row"/>
    </xsl:template>

    <xsl:template match="yb:tbody/yb:row">
        <xsl:variable name="oddeven">
            <xsl:choose>
                <xsl:when test="position() mod 2 = 0">dark</xsl:when>
                <xsl:otherwise>light</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <tr class="{$oddeven}" valign="top" align="left">
            <xsl:apply-templates select="yb:entry"/>
        </tr>
    </xsl:template>

    <xsl:template match="yb:tbody/yb:row/yb:entry">
        <td valign="left"><xsl:value-of select="."/></td>
    </xsl:template>
</xsl:transform>
