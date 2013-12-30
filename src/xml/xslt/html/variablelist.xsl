<?xml version="1.0"?>

<!--
    Stylesheet transform for Yagsbook to HTML.

    Defines the various list types, including variablelist,
    targetlist etc.

    Author:  Samuel Penn
    Version: $Revision: 1.3 $
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

    <!--
        itemlist

        An <itemlist> is a generic list of items. How the list is displayed
        depends on the @order attribute.
     -->
    <xsl:template match="yb:itemlist">
        <xsl:variable name="order" select="@order"/>

        <xsl:choose>
            <xsl:when test="$order = 'strict'">
                <dl>
                    <xsl:apply-templates select="yb:item" mode="strict"/>
                </dl>
            </xsl:when>

            <xsl:when test="$order = 'sort'">
                <dl>
                    <xsl:apply-templates select="yb:item" mode="strict">
                        <xsl:sort select="@name" data-type="text"/>
                    </xsl:apply-templates>
                </dl>
            </xsl:when>

            <xsl:when test="$order = 'unordered'">
                <ul>
                    <xsl:apply-templates select="yb:item" mode="ordered"/>
                </ul>
            </xsl:when>

            <xsl:when test="$order = '1'">
                <ol type="1">
                    <xsl:apply-templates select="yb:item" mode="ordered"/>
                </ol>
            </xsl:when>

            <xsl:when test="$order = 'i'">
                <ol type="i">
                    <xsl:apply-templates select="yb:item" mode="ordered"/>
                </ol>
            </xsl:when>

            <xsl:when test="$order = 'I'">
                <ol type="I">
                    <xsl:apply-templates select="yb:item" mode="ordered"/>
                </ol>
            </xsl:when>

            <xsl:when test="$order = 'a'">
                <ol type="a">
                    <xsl:apply-templates select="yb:item" mode="ordered"/>
                </ol>
            </xsl:when>

            <xsl:otherwise>
                <p>Illegal list</p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="yb:itemlist/yb:item" mode="strict">
        <dt><xsl:value-of select="@name"/></dt>
        <dd><xsl:apply-templates/></dd>
    </xsl:template>


    <xsl:template match="yb:itemlist/yb:item" mode="ordered">
        <li>
            <xsl:if test="@name">
                <em><xsl:value-of select="@name"/>:</em>
            </xsl:if>
            <xsl:apply-templates/>
        </li>
    </xsl:template>


    <!--
        A target list consists of one or more target, description pairs,
        where the target is a numeric. The description may consist of
        extra paragraphs of text.

        A target list may be reversed, but the normal order is for the
        numeric target to appear on the right, with the description on
        the left.
    -->
    <xsl:template name="targetlist" match="yb:targetlist">
        <table class="targetlist" width="80%">
            <caption><xsl:value-of select="yb:title"/></caption>
            <thead>
                <tr>
                    <xsl:choose>
                        <xsl:when test="@targetFirst='true'">
                            <th align="center" valign="top">
                                <xsl:value-of select="yb:targetLabel"/>
                            </th>
                            <th align="left" valign="top">
                                <xsl:value-of select="yb:valueLabel"/>
                            </th>
                        </xsl:when>
                        <xsl:otherwise>
                            <th align="left" valign="top">
                                <xsl:value-of select="yb:valueLabel"/>
                            </th>
                            <th align="center" valign="top">
                                <xsl:value-of select="yb:targetLabel"/>
                            </th>
                        </xsl:otherwise>
                    </xsl:choose>
                </tr>
            </thead>

            <tbody>
                <xsl:apply-templates select="yb:item"/>
            </tbody>

        </table>
    </xsl:template>

    <!-- As for a standard table, use dark/light shading -->
    <xsl:template match="yb:targetlist/yb:item">
        <xsl:variable name="oddeven">
            <xsl:choose>
                <xsl:when test="position() mod 2 = 0">dark</xsl:when>
                <xsl:otherwise>light</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <tr class="{$oddeven}" valign="top" align="left">
            <xsl:choose>
                <xsl:when test="../@targetFirst='true'">
                    <td align="center">
                        <xsl:value-of select="@target"/>
                    </td>
                    <td>
                        <xsl:choose>
                            <xsl:when test="../@bold='true'">
                                <b><xsl:value-of select="@value"/></b>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@value"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:value-of select="."/>
                    </td>
                </xsl:when>
                <xsl:otherwise>
                    <td>
                        <xsl:choose>
                            <xsl:when test="../@bold='true'">
                                <b><xsl:value-of select="@value"/></b>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@value"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:value-of select="."/>
                    </td>
                    <td align="center">
                        <xsl:value-of select="@target"/>
                    </td>
                </xsl:otherwise>
            </xsl:choose>
        </tr>
    </xsl:template>






    <xsl:template match="yb:events">
        <xsl:apply-templates select="yb:event">
            <xsl:sort data-type="number" select="yb:startdate/@year"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="yb:events/yb:event">
        <h6>
            <xsl:value-of select="yb:startdate/@year"/>
            <xsl:if test="yb:enddate/@year">
                - <xsl:value-of select="yb:enddate/@year"/>
            </xsl:if>
            <xsl:if test="@title">
                : <xsl:value-of select="@title"/>
            </xsl:if>
        </h6>
        <xsl:apply-templates/>
    </xsl:template>

</xsl:transform>
