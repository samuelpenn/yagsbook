<?xml version="1.0"?>

<!--
    Yagsbook stylesheet for Family trees and the like

    Author:  Samuel Penn
    Version: $Revision: 1.7 $
    Date:    $Date: 2006/07/15 20:14:11 $

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

    <xsl:template match="yb:familyTree">
        <div class="familyTree">
            <h4>
                <xsl:value-of select="@title"/>
                <xsl:if test="@year">
                    (as of year <xsl:value-of select="@year"/>)
                </xsl:if>

            </h4>

            <xsl:apply-templates select="yb:person" mode="validate"/>

            <xsl:variable name="root" select="yb:root"/>
            <xsl:apply-templates select="yb:family[@parent=$root]"/>
        </div>
    </xsl:template>

    <xsl:template match="yb:person" mode="validate">
        <xsl:variable name="name" select="@name"/>
        <xsl:if test="count(../yb:person[@name=$name]) &gt; 1">
            <span style="color: red;"><xsl:value-of select="$name"/></span><br/>
        </xsl:if>
    </xsl:template>

    <!--
        A 'family' is an individual node in the family tree. It is
        identified by its mother, and contains one or more sets of
        children, each by a father.
    -->
    <xsl:template match="yb:familyTree/yb:family">
        <xsl:apply-templates select="yb:children"/>
    </xsl:template>

    <xsl:template match="yb:familyTree/yb:family/yb:children">
        <div>
            <xsl:variable name="parent1" select="../@parent"/>
            <xsl:variable name="parent2" select="@parent"/>

            <xsl:choose>
                <xsl:when test="@parent">
                    <xsl:choose>
                        <xsl:when test="position() = 1">
                            ----
                            <xsl:apply-templates select="../../yb:person[@name=$parent1]"
                                                mode="inline"/>
                            ==
                        </xsl:when>
                        <xsl:otherwise>
                            <span style="margin-left: 2em">
                                <xsl:text> == </xsl:text>
                            </span>
                        </xsl:otherwise>
                    </xsl:choose>

                    <xsl:apply-templates select="../../yb:person[@name=$parent2]"
                                         mode="inline"/>
                    <br/>
                    <div style="margin: 0mm; margin-left: 10mm; margin-bottom: 3mm;
                                border-left: 1pt solid black; padding-left: 0mm;">
                        <xsl:apply-templates select="yb:child"/>
                    </div>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="../../yb:person[@name=$parent1]"/>
                    <div style="margin: 0mm; margin-left: 10mm; margin-bottom: 3mm;
                                border-left: 1pt solid black; padding-left: 0mm;">
                        <xsl:apply-templates select="yb:child"/>
                    </div>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>

    <xsl:template match="yb:familyTree/yb:family/yb:children/yb:child">
        <xsl:variable name="name" select="."/>

        <xsl:choose>
            <xsl:when test="../../../yb:family[@parent=$name]">
                <xsl:apply-templates select="../../../yb:family[@parent=$name]"/>
            </xsl:when>
            <xsl:when test="not(../../../yb:person[@name=$name])">
                <i>----<xsl:value-of select="$name"/>
                <span style="color: red;">?</span></i><br/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="../../../yb:person[@name=$name]"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="yb:familyTree/yb:person" mode="inline">
        <xsl:variable name="colour">
            <xsl:choose>
                <xsl:when test="yb:died">#777777</xsl:when>
                <xsl:otherwise>black</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <span style="color: {$colour}"><xsl:value-of select="@name"/></span>

        <xsl:if test="yb:short">
            <span style="color: blue" title="{yb:short}"> +</span>
        </xsl:if>

        <xsl:choose>
            <xsl:when test="yb:male"> (m)</xsl:when>
            <xsl:otherwise> (f)</xsl:otherwise>
        </xsl:choose>

        <xsl:if test="yb:born or yb:died">
            (
            <xsl:if test="yb:born">
                b. <xsl:value-of select="yb:born"/>
            </xsl:if>
            <xsl:if test="yb:died">
                d. <xsl:value-of select="yb:died"/>
            </xsl:if>
            )
        </xsl:if>
    </xsl:template>

    <xsl:template match="yb:familyTree/yb:person">
        ----<xsl:apply-templates select="." mode="inline"/>
        <br/>
    </xsl:template>
</xsl:transform>
