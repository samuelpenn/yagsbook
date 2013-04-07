<?xml version="1.0"?>
<!--
    Stylesheet transform for Yagsbook to PDF.

    Handles all advantage/disadvantage styles.

    Author:  Samuel Penn
    Version: $Revision: 1.11 $
    Date:    $Date: 2007/08/29 19:28:21 $

    Copyright 2012 Samuel Penn, http://yagsbook.sourceforge.net.
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
                xmlns:y="http://yagsbook.sourceforge.net/xml/yags"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">

    <!-- Import advantages from external document -->
    <xsl:template match="y:import-advantages[@source]">
        <xsl:variable name="href" select="@href"/>

        <xsl:variable name="source" select="@source"/>
        <xsl:variable name="topic" select="@topic"/>
        <xsl:variable name="role" select="@role"/>

        <xsl:variable name="index"
                        select="concat($source, '/index.xml')"/>

        <xsl:for-each select="document($index)/yb:index/yb:article">
            <xsl:variable name="file" select="."/>
            <xsl:variable name="path"
                            select="concat($source, '/', $file)"/>

            <xsl:if test="document($path)/yb:article/yb:header/yb:topics/yb:topic/@uri=$topic">
                <xsl:if test="document($path)/yb:article/yb:body//y:advantages[@role=$role]/y:advantage">
                    <fo:block
                        font-size="{$font-large}"
                        font-family="{$font-body}"
                        line-height="{$font-large}"
                        font-weight="bold"
                        font-style="normal">

                        <xsl:value-of select="document($path)/yb:article/yb:header/yb:title"/>
                    </fo:block>
                    <xsl:apply-templates
                        select="document($path)/yb:article/yb:body//y:advantages[@role=$role]/y:advantage">
                        <xsl:sort select="@name" data-type="text"/>
                    </xsl:apply-templates>
                </xsl:if>
            </xsl:if>

        </xsl:for-each>
    </xsl:template>

    <xsl:template match="y:advantage" mode="tree">
        <xsl:param name="docs" select="0"/>
        <xsl:param name="indent" select="0"/>
        <xsl:variable name="advName" select="@name"/>

        <fo:block margin-left="{$indent}mm">
            <fo:inline font-weight="bold">
                <xsl:value-of select="@name"/>
            </fo:inline>
            <xsl:if test="not(y:skill) and y:cost/@points">
                (<xsl:value-of select="y:cost/@points"/>)
            </xsl:if>
            <xsl:if test="y:skill">
                (<xsl:value-of select="y:cost/@points"/>
                <xsl:text>; </xsl:text>
                <xsl:value-of select="y:skill/@name"/>)
            </xsl:if>

            <xsl:if test="y:short">
                <fo:inline font-style="italic">
                        <xsl:text>- </xsl:text>
                        <xsl:value-of select="y:short"/>
                </fo:inline>
            </xsl:if>
            <xsl:apply-templates select="document($docs)/y:advantages/y:advantage[y:prerequisite=$advName]" mode="tree">
                <xsl:with-param name="docs" select="$docs"/>
                <xsl:with-param name="indent" select="3 + $indent"/>
            </xsl:apply-templates>
        </fo:block>
    </xsl:template>

    <!--
        Catches techniques which have a prerequisite for the root
        of the tree. These should not be displayed.
    -->
    <xsl:template match="y:advantage[y:prerequisite]" mode="root">
        <xsl:param name="docs" select="0"/>
        <xsl:variable name="p" select="y:prerequisite"/>

        <xsl:if test="not(document($docs)/y:advantages/y:advantage[@name=$p])">
            <fo:block font-size="{$font-small}">
                <xsl:apply-templates select="." mode="tree">
                    <xsl:with-param name="docs" select="$docs"/>
                </xsl:apply-templates>
            </fo:block>
        </xsl:if>
    </xsl:template>

    <!--
        Root nodes of the technique list. Only those techniques which
        do not have any prerequisites are displayed.
    -->
    <xsl:template match="y:advantage" mode="root">
        <xsl:param name="docs" select="0"/>
        <fo:block font-size="{$font-small}">
            <xsl:apply-templates select="." mode="tree">
                <xsl:with-param name="docs" select="$docs"/>
            </xsl:apply-templates>
        </fo:block>
    </xsl:template>

    <xsl:template match="y:import-advantages[y:adv]">
        <xsl:variable name="type" select="@type"/>
	<xsl:variable name="list" select="document(y:adv)/y:advantages/y:advantage[@type=$type]"/>
        <!--
            <xsl:choose>
                <xsl:when test="@type"><xsl:value-of select="$all/y:advantage[@type=$type]"/></xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="document(y:adv)/y:advantages/y:advantage"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        -->

        <xsl:if test="@tree='true'">
            <fo:block font-weight="bold" font-size="{$font-large}"
                      font-family="{$font-body}"
                      color="{$colour}"
                      space-after="{$font-large}"
                      space-before="{$font-large}">
                Summary
            </fo:block>

            <xsl:apply-templates select="$list" mode="root">
                <xsl:sort select="@name" data-type="text"/>
                <xsl:with-param name="docs" select="y:adv"/>
            </xsl:apply-templates>

            <fo:block font-weight="bold" font-size="{$font-large}"
                      font-family="{$font-body}"
                      color="{$colour}"
                      space-after="{$font-large}"
                      space-before="{$font-large}">
                Descriptions
            </fo:block>
        </xsl:if>

        <xsl:apply-templates select="$list">
            <xsl:sort select="@name" data-type="text"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="y:import-advantages">
        <xsl:variable name="href" select="@href"/>

        <xsl:choose>
            <xsl:when test="@type">
                <xsl:variable name="type" select="@type"/>
                <xsl:apply-templates select="document($href)//y:advantage[@type=$type]">
                    <xsl:sort select="@name" data-type="text"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="document($href)//y:advantage">
                    <xsl:sort select="@name" data-type="text"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>



    <xsl:template match="y:advantages">
        <fo:block
            font-size="{$font-medium}"
            font-family="{$font-body}"
            line-height="{$font-large}">

            <xsl:value-of select="@title"/>
        </fo:block>
        <xsl:apply-templates select="yb:description"/>
        <xsl:apply-templates select="y:advantage"/>
    </xsl:template>


    <!--
        Advantage

        Standard advantage template. The advantage has a name and a cost,
        followed by one or more paragraph blocks of description.
     -->
    <xsl:template match="y:advantage">
        <fo:block
            font-size="{$font-medium}"
            font-family="{$font-body}"
            line-height="{$font-large}"
            font-style="normal">

            <xsl:choose>
                <!-- Cost per level -->
                <xsl:when test="y:cost/@levels">
                    <fo:inline font-weight="bold"><xsl:value-of select="@name"/>
                        (<xsl:value-of select="y:cost/@points"/>/<xsl:value-of
                            select="y:cost/@levels"/> levels):
                    </fo:inline>
                </xsl:when>
		<xsl:when test="not(y:cost)">
                    <fo:inline font-weight="bold"><xsl:value-of select="@name"/>:</fo:inline>
		</xsl:when>

                <!-- Fixed/multiple cost advantages -->
                <xsl:otherwise>
                    <fo:inline font-weight="bold"><xsl:value-of select="@name"/>
                        (<xsl:for-each select="y:cost/@points">
                            <xsl:if test="position()=last()">
                                <xsl:value-of select="."/>
                            </xsl:if>
                            <xsl:if test="not(position()=last())">
                                <xsl:value-of select="."/>,
                            </xsl:if>
                        </xsl:for-each>):
                    </fo:inline>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:if test="y:prerequisite">
                <fo:block
                         font-size="{$font-medium}"
                         font-family="{$font-body}"
                         line-height="{$font-large}"
                         font-style="italic"
                         space-after.optimum="0pt">

                    <xsl:text>Prerequisites: </xsl:text>
                    <xsl:apply-templates select="y:prerequisite"/>
                </fo:block>
            </xsl:if>

            <xsl:if test="y:forbiddon">
                <fo:block
                         font-size="{$font-medium}"
                         font-family="{$font-body}"
                         line-height="{$font-large}"
                         font-style="italic"
                         space-after.optimum="0pt">

                    <xsl:text>Cannot take: </xsl:text>
                    <xsl:apply-templates select="y:forbiddon"/>
                </fo:block>
            </xsl:if>

            <xsl:apply-templates select="yb:description"/>

        </fo:block>
    </xsl:template>

    <xsl:template match="y:advantage/yb:description" mode="advantage">
        <xsl:apply-templates/>
    </xsl:template>


    <xsl:template match="y:advantage[y:skill]">
        <fo:block
            font-size="{$font-medium}"
            font-family="{$font-body}"
            line-height="{$font-large}"
            font-style="normal"
            space-after.optimum="0pt">

	    <xsl:choose>
                <xsl:when test="y:cost/@mastery='true'">
	            <fo:inline font-weight="bold">
                        <xsl:value-of select="@name"/>
                        (Cost <xsl:value-of select="y:cost/@points"/>+):
	    	    </fo:inline>
	        </xsl:when>

	        <xsl:otherwise>
                    <fo:inline font-weight="bold">
                        <xsl:value-of select="@name"/>
                        (Cost <xsl:value-of select="y:cost/@points"/>):
                    </fo:inline>
	        </xsl:otherwise>
            </xsl:choose>

            <xsl:apply-templates select="y:skill"/>
        </fo:block>

        <xsl:if test="y:prerequisite">
            <fo:block
                font-size="{$font-medium}"
                font-family="{$font-body}"
                line-height="{$font-large}"
                font-style="italic"
                space-after.optimum="0pt">

                Prerequisites:
                <xsl:apply-templates select="y:prerequisite"/>
            </fo:block>
        </xsl:if>
        <xsl:apply-templates select="yb:description"/>
    </xsl:template>

    <xsl:template match="y:advantage/y:skill">
        <xsl:if test="position() &lt; last()">
            <fo:inline font-style="italic">
                <xsl:value-of select="@name"/>,
            </fo:inline>
        </xsl:if>
        <xsl:if test="position() = last()">
            <fo:inline font-style="italic">
                <xsl:value-of select="@name"/>.
            </fo:inline>
        </xsl:if>
    </xsl:template>

    <xsl:template match="y:advantage/y:prerequisite">
        <xsl:if test="position() &lt; last()">
            <xsl:value-of select="."/>,
        </xsl:if>
        <xsl:if test="position() = last()">
            <xsl:value-of select="."/>.
        </xsl:if>
    </xsl:template>

    <xsl:template match="y:advantage/y:forbiddon">
        <xsl:if test="position() &lt; last()">
            <xsl:value-of select="."/>,
        </xsl:if>
        <xsl:if test="position() = last()">
            <xsl:value-of select="."/>.
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
