<?xml version="1.0"?>

<!--
    Stylesheet transform for Yagsbook to PDF.

    This is the top level stylesheet, which includes all the other
    stylesheet files, and handles the header and top level body
    parts of the document.

    All global variables should also be defined in this file.

    Author:  Samuel Penn
    Version: $Revision: 1.7 $
    Date:    $Date: 2008/07/14 06:14:35 $

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
                xmlns:y="http://yagsbook.sourceforge.net/xml/yags"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">

    <!--
        list-skills

        Import a list of skills from a external resource. Simply list the
        skills according to their groups, don't actually output any
        information beyond a short description.
        -->
    <xsl:template match="y:list-skills">
        <xsl:variable name="href" select="@href"/>

        <xsl:for-each select="document($href)/y:skill-list/y:groups/y:group[not(@parent)]">
            <xsl:sort select="." data-type="text"/>

            <xsl:variable name="group" select="."/>

            <fo:block font-size="{$font-medium}"
                      font-family="{$font-body}"
                      font-weight="bold"
                      color="{$colour}"
                      space-after="{$font-medium}">

                <xsl:value-of select="$group"/>
            </fo:block>

            <fo:block space-after="{$font-medium}">
                <xsl:apply-templates select="document($href)/y:skill-list/y:skill[y:group=$group]"
                                     mode="list">
                    <xsl:sort select="@name" data-type="text"/>
                </xsl:apply-templates>
            </fo:block>
        </xsl:for-each>
    </xsl:template>

    <!--
        skill

        Output information on a single skill as a one line brief.
        Uses the short description of the skill, if it exists.
    -->
    <xsl:template match="y:skill" mode="list">
        <fo:block font-size="{$font-small}">
            <fo:inline font-weight="bold">
                <xsl:value-of select="@name"/>
            </fo:inline>
            <xsl:choose>
                <xsl:when test="@type='talent'">(*)</xsl:when>
                <xsl:when test="@type='knowledge'">(K)</xsl:when>
                <xsl:when test="@type='language'">(L)</xsl:when>
            </xsl:choose>
            <xsl:if test="y:default">
                (<xsl:value-of select="y:default"/>)
            </xsl:if>
            <xsl:if test="y:short">
                <xsl:text> - </xsl:text>
                <fo:inline font-style="italic">
                    <xsl:value-of select="y:short"/>
                </fo:inline>
            </xsl:if>
        </fo:block>
    </xsl:template>


    <!--
        skill

        A description of a skill, within a skill-list.

         Skill Name (skill type)
         GROUPS
         Defaults to: default Requires: prerequisite
         Techniques: techniques

         Full text description
         task
         Minor task description
         Example skill difficulties
         examples
         examples

    -->
    <xsl:template match="y:skill-list/y:skill">
        <fo:block font-size="{$font-medium}"
                  font-family="{$font-body}"
                  space-after="0pt">


            <fo:block color="{$colour}"
                      font-weight="bold"
                      space-after="0pt"
                      space-before="0pt">
                <xsl:value-of select="@name"/>

                <xsl:choose>
                    <xsl:when test="@type='talent'"> (Talent)</xsl:when>
                    <xsl:when test="@type='knowledge'"> (Knowledge)</xsl:when>
                    <xsl:when test="@type='language'"> (Language)</xsl:when>
                </xsl:choose>
            </fo:block>

            <xsl:if test="y:group">
                <fo:block font-variant="small-caps"
                          space-after="0pt">
                    <xsl:for-each select="y:group">
                        <xsl:choose>
                            <xsl:when test="position()=last()">
                                <xsl:value-of select="."/>.
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="."/><xsl:text>, </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </fo:block>
            </xsl:if>

            <xsl:if test="y:default">
                <fo:block space-after="0pt">
                    <fo:inline font-weight="bold">
                        Defaults to:
                    </fo:inline>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="y:default"/>
                    <xsl:text> </xsl:text>
                </fo:block>
            </xsl:if>

            <xsl:if test="y:prerequisite">
                <fo:block space-after="0pt">
                    <xsl:variable name="score">
                        <xsl:choose>
                            <xsl:when test="y:prerequisite/@score">
                                <xsl:value-of select="y:prerequisite/@score"/>
                            </xsl:when>
                            <xsl:otherwise>2</xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <fo:inline font-weight="bold">
                        Requires:
                    </fo:inline>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="y:prerequisite"/>-<xsl:value-of select="$score"/>
                </fo:block>
            </xsl:if>

            <xsl:if test="y:techRange">
                <xsl:variable name="min" select="y:techRange/@min"/>
                <xsl:variable name="max" select="y:techRange/@max"/>

                <fo:block: space-after="0pt">
                    <fo:inline font-weight="bold">
                        Tech levels:
                    </fo:inline>
                    <xsl:text> </xsl:text>
                    <xsl:choose>
                        <xsl:when test="$min &lt; 1">
                            Up to TL <xsl:value-of select="$max"/>
                        </xsl:when>
                        <xsl:when test="$max &gt; 19">
                            <xsl:value-of select="$min"/>+
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$min"/>
                            <xsl:text> - </xsl:text>
                            <xsl:value-of select="$max"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </fo:block>
            </xsl:if>

            <xsl:if test="../@techniques">
                <xsl:variable name="us" select="@name"/>
                <xsl:if test="document(../@techniques)/y:advantages/y:advantage/y:skill/@name=@name">
                    <fo:block font-size="{$font-medium}" font-family="{$font-body}"
                              font-style="italic"
                              space-after="0pt">
                        <fo:inline font-weight="bold" font-style="normal">
                            Techniques:
                        </fo:inline>
                        <xsl:for-each select="document(../@techniques)/y:advantages/y:advantage[y:skill/@name=$us]">
                            <xsl:if test="position()=last()">
                                <xsl:value-of select="@name"/>.
                            </xsl:if>
                            <xsl:if test="position() &lt; last()">
                                <xsl:value-of select="@name"/>,
                            </xsl:if>
                        </xsl:for-each>
                    </fo:block>
                </xsl:if>
            </xsl:if>

            <xsl:apply-templates select="yb:description[not(@task)]"/>

            <xsl:for-each select="yb:description[@task]">
                <fo:block margin-left="5mm">
                    <fo:block space-after="0pt" font-style="italic">
                        <xsl:value-of select="@task"/>
                    </fo:block>

                    <xsl:apply-templates select="."/>
                </fo:block>
            </xsl:for-each>
        </fo:block>

        <xsl:apply-templates select="y:examples"/>
    </xsl:template>

    <xsl:template match="y:skill/y:examples">
        <fo:block space-after="{$font-medium}" font-size="{$font-small}">
            <fo:block font-weight="bold">
                Example difficulties
                <xsl:if test="@task">
                    (<xsl:value-of select="@task"/>)
                </xsl:if>
            </fo:block>

            <xsl:apply-templates select="y:example"/>
        </fo:block>
    </xsl:template>

    <xsl:template match="y:skill/y:examples/y:example">
        <fo:block font-style="italic" font-family="{$font-body}">
            <fo:inline font-style="normal" font-weight="bold">
                <xsl:value-of select="@target"/>
                <xsl:text> - </xsl:text>
            </fo:inline>
            <xsl:value-of select="."/>
        </fo:block>
    </xsl:template>

    <xsl:template match="skills" mode="byage">
        <fo:block font-weight="bold" font-style="italic" color="{$colour}"
                font-size="{$font-medium}" line-height="{$font-medium}" space-after="0pt"
                space-before="{$font-medium}" text-align="start">
                Typical skills for age <xsl:value-of select="@age"/>
        </fo:block>
        <xsl:apply-templates select="group"/>
    </xsl:template>

    <xsl:template match="skills/group">
        <fo:block font-weight="bold" font-style="italic" color="{$colour}"
                font-size="{$font-medium}" line-height="{$font-medium}" space-after="0pt"
                text-align="start">
            <xsl:value-of select="@name"/>
        </fo:block>
        <fo:block font-size="{$font-small}">
            <xsl:apply-templates select="skill">
                <xsl:sort select="@name" data-type="text"/>
            </xsl:apply-templates>
        </fo:block>
    </xsl:template>


    <xsl:template match="skills/group/skill">
        <xsl:if test="@score &gt; 0">
            <xsl:value-of select="@name"/>
            <xsl:text> - </xsl:text>
            <xsl:value-of select="@score"/>;
        </xsl:if>
    </xsl:template>

    <xsl:template match="para/skillequation">
        <fo:inline font-weight="bold">
            <xsl:for-each select="attribute">
                <fo:inline font-style="italic">
                    <xsl:value-of select="."/>
                </fo:inline>
                <xsl:if test="position() &lt; last()">|</xsl:if>
            </xsl:for-each>
        </fo:inline>

        <xsl:text> x </xsl:text>

        <fo:inline font-weight="bold">
            <xsl:choose>
                <xsl:when test="skill">
                    <xsl:for-each select="skill">
                        <fo:inline font-style="italic">
                            <xsl:value-of select="."/>
                        </fo:inline>
                        <xsl:if test="position() &lt; last()">|</xsl:if>
                    </xsl:for-each>
                </xsl:when>

                <xsl:when test="constant">
                    <xsl:value-of select="constant"/>
                </xsl:when>
            </xsl:choose>
        </fo:inline>

        <xsl:if test="bonus">
            <xsl:text> + </xsl:text>
            <fo:inline font-weight="bold">
                <xsl:value-of select="bonus"/>
            </fo:inline>
        </xsl:if>

        <xsl:if test="penalty">
            <xsl:text> + </xsl:text>
            <fo:inline font-weight="bold">
                <xsl:value-of select="penalty"/>
            </fo:inline>
        </xsl:if>

        <xsl:if test="die">
            <xsl:text> + d20</xsl:text>
        </xsl:if>

    </xsl:template>

    <xsl:template match="skillequation">
        <fo:block
            font-size="8pt"
            font-family="{$font-body}"
            font-style="italic"
            line-height="12pt"
            space-after="12pt"
            margin-left="1cm"
            margin-right="1cm"
            background-color="{$lightcolour}">

            <xsl:if test="title">
                <fo:block font-weight="bold">
                    <xsl:value-of select="title"/>
                </fo:block>
            </xsl:if>

            <xsl:value-of select="attribute"/>
            <xsl:text> x </xsl:text>
            <xsl:choose>
                <xsl:when test="skill">
                    <xsl:value-of select="skill"/>
                </xsl:when>
                <xsl:when test="constant">
                    <xsl:value-of select="constant"/>
                </xsl:when>
            </xsl:choose>
            <xsl:if test="bonus">
                <xsl:text> + </xsl:text>
                <xsl:value-of select="bonus"/>
            </xsl:if>
            <xsl:if test="die">
                <xsl:text> + d20</xsl:text>
            </xsl:if>
        </fo:block>
    </xsl:template>

</xsl:stylesheet>

