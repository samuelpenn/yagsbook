<?xml version="1.0"?>

<!--
    Stylesheet transform for Yagsbook to HTML.

    Renders Habisfern spells to HTML.

    Author:  Samuel Penn
    Version: $Revision: 1.3 $
    Date:    $Date: 2005/11/12 20:16:06 $

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
               xmlns:y="http://yagsbook.sourceforge.net/xml/yags"
               xmlns:h="http://yagsbook.sourceforge.net/xml/yags/habisfern"
               version="1.0">


    <xsl:template match="h:import-spells">
        <xsl:variable name="href" select="@href"/>
        <xsl:apply-templates select="document(@href)//h:preface"/>
        <xsl:apply-templates select="document(@href)/h:grimoire/yb:description"/>

        <xsl:apply-templates select="document(@href)/h:grimoire" mode="tree"/>

        <xsl:choose>
            <xsl:when test="@type">
                <xsl:variable name="type" select="@type"/>

                <xsl:apply-templates select="document(@href)//h:spell[@type=$type]">
                    <xsl:sort select="@level" data-type="number"/>
                    <xsl:sort select="@name" data-type="text"/>
                </xsl:apply-templates>
            </xsl:when>

            <xsl:otherwise>
                <xsl:apply-templates select="document(@href)//h:spell">
                    <xsl:sort select="@level" data-type="number"/>
                    <xsl:sort select="@name" data-type="text"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="h:grimoire">
        <xsl:apply-templates select="h:spell"/>
    </xsl:template>

    <xsl:template match="h:grimoire" mode="tree">
        <xsl:apply-templates select="h:spell[not(h:prerequisite)]" mode="tree"/>
    </xsl:template>

    <xsl:template match="h:spell" mode="tree">
        <xsl:variable name="spellName" select="@name"/>

        <div style="margin-left: 3mm;">
            <p style="margin: 0mm; margin-left: 10mm; font-size: small;">
                <b><xsl:value-of select="$spellName"/></b> (<xsl:value-of select="@level"/>) -
                <i><xsl:value-of select="h:short"/></i>
            </p>
            <xsl:apply-templates select="../h:spell[h:prerequisite=$spellName]" mode="tree"/>
        </div>
    </xsl:template>


    <xsl:template match="h:spell">
        <div class="spell">
            <h3 class="spell"><xsl:value-of select="@name"/>,
            <xsl:if test="@level='0'">
                0
            </xsl:if>
            <xsl:if test="@level &gt; 0">
                Level <xsl:value-of select="@level"/>
            </xsl:if>
            </h3>

            <table class="spell" width="100%">
                <tr>
                    <td><b>Time: </b>
                        <xsl:if test="h:time">
                            <xsl:value-of select="h:time"/>
                        </xsl:if>
                        <xsl:if test="not(h:time)">
                            1 round
                        </xsl:if>
                    </td>
                    <td><b>Range: </b>
                        <xsl:if test="h:range">
                            <xsl:value-of select="h:range"/>
                        </xsl:if>
                        <xsl:if test="not(h:range)">
                            Self
                        </xsl:if>
                    </td>
                </tr>
                <tr>
                    <xsl:if test="h:duration">
                        <td><b>Duration: </b>
                            <xsl:value-of select="h:duration"/>
                        </td>
                    </xsl:if>
                    <xsl:if test="h:resist">
                        <td><b>Resist: </b>
                            <xsl:value-of select="h:resist"/>
                        </td>
                    </xsl:if>
                </tr>
                <tr>
                    <xsl:if test="h:area">
                        <td><b>Area: </b>
                            <xsl:value-of select="h:area"/>
                        </td>
                    </xsl:if>
                    <xsl:if test="h:radius">
                        <td><b>Radius: </b>
                            <xsl:value-of select="h:radius"/>
                        </td>
                    </xsl:if>
                    <xsl:if test="h:target">
                        <td><b>Target: </b>
                            <xsl:value-of select="h:target"/>
                        </td>
                    </xsl:if>
                </tr>

                <xsl:if test="h:effect">
                    <tr>
                        <td><b>Effect: </b>
                            <xsl:value-of select="h:effect"/>
                        </td>
                    </tr>
                </xsl:if>

                <xsl:if test="h:prerequisite">
                    <xsl:for-each select="h:prerequisite">
                        <tr>
                            <td colspan="2">
                                <b>Prerequisite: </b>
                                <xsl:value-of select="."/>
                            </td>
                        </tr>
                    </xsl:for-each>
                </xsl:if>
            </table>

            <xsl:apply-templates select="yb:description"/>

        </div>
    </xsl:template>

    <xsl:template match="h:spell/yb:description">
        <xsl:apply-templates/>
    </xsl:template>

</xsl:transform>
