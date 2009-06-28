<?xml version="1.0"?>

<!--
    Stylesheet transform for Yagsbook to PDF.

    This is the top level stylesheet, which includes all the other
    stylesheet files, and handles the header and top level body
    parts of the document.

    All global variables should also be defined in this file.

    Author:  Samuel Penn
    Version: $Revision: 1.12 $
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
                xmlns:y="http://yagsbook.sourceforge.net/xml/yags"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">


    <!--
        skill-list

        An inline list of skill descriptions. Just list them out in
        alphabetical order.
    -->
    <xsl:template match="y:skill-list">
        <xsl:apply-templates select="y:skill">
            <xsl:sort select="name" data-type="text"/>
        </xsl:apply-templates>
    </xsl:template>

    <!--
        Importing a list of skill descriptions from an external file.
    -->
    <xsl:template match="y:import-skills">
        <xsl:variable name="href" select="@href"/>
        <xsl:variable name="maxTech">
            <xsl:choose>
                <xsl:when test="@maxTech">
                    <xsl:value-of select="@maxTech"/>
                </xsl:when>
                <xsl:otherwise>20</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="minTech">
            <xsl:choose>
                <xsl:when test="@minTech">
                    <xsl:value-of select="@minTech"/>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="skills" select="document(y:skills)/y:skill-list"/>
        <xsl:variable name="techniques" select="document(y:techniques)/y:advantages"/>

        <xsl:choose>
            <xsl:when test="@type">
                <xsl:variable name="type" select="@type"/>
                <xsl:apply-templates select="$skills/y:skill[@type=$type]">
                    <xsl:sort select="@name" data-type="text"/>

                    <xsl:with-param name="techniques" select="$techniques"/>
                    <xsl:with-param name="minTech" select="$minTech"/>
                    <xsl:with-param name="maxTech" select="$maxTech"/>
                </xsl:apply-templates>
            </xsl:when>

            <xsl:when test="@group">
                <xsl:variable name="group" select="@group"/>
                <xsl:apply-templates select="$skills/y:skill[y:group=$group]">
                    <xsl:sort select="@name" data-type="text"/>

                    <xsl:with-param name="techniques" select="$techniques"/>
                    <xsl:with-param name="minTech" select="$minTech"/>
                    <xsl:with-param name="maxTech" select="$maxTech"/>
                </xsl:apply-templates>
            </xsl:when>

            <xsl:otherwise>
                <xsl:apply-templates select="$skills/y:skill">
                    <xsl:sort select="@name" data-type="text"/>

                    <xsl:with-param name="techniques" select="$techniques"/>
                    <xsl:with-param name="minTech" select="$minTech"/>
                    <xsl:with-param name="maxTech" select="$maxTech"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>



    <!--
        list-skills

        Import a list of skills from a external resource. Simply list the
        skills according to their groups, don't actually output any
        information beyond a short description.
        -->
    <xsl:template match="y:list-skills">
        <xsl:variable name="href" select="@href"/>
        <xsl:variable name="maxTech">
            <xsl:choose>
                <xsl:when test="@maxTech">
                    <xsl:value-of select="@maxTech"/>
                </xsl:when>
                <xsl:otherwise>20</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="minTech">
            <xsl:choose>
                <xsl:when test="@minTech">
                    <xsl:value-of select="@minTech"/>
                </xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="allSkills" select="document(y:skills)/y:skill-list"/>

        <xsl:for-each select="document(y:skills[1])/y:skill-list/y:groups/y:group[not(@parent)]">
            <xsl:sort select="." data-type="text"/>

            <xsl:variable name="group" select="."/>

            <fo:block font-size="{$font-medium}"
                      font-family="{$font-body}"
                      font-weight="bold"
                      color="{$colour}"
                      space-after.optimum="{$font-medium}">

                <xsl:value-of select="$group"/>
            </fo:block>

            <fo:block space-after.optimum="{$font-medium}">
                <xsl:apply-templates select="$allSkills/y:skill[y:group=$group]"
                                     mode="list">
                    <xsl:sort select="@name" data-type="text"/>
                    <xsl:with-param name="minTech" select="$minTech"/>
                    <xsl:with-param name="maxTech" select="$maxTech"/>
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
        <xsl:param name="minTech" select="0"/>
        <xsl:param name="maxTech" select="20"/>

        <xsl:choose>
            <xsl:when test="y:techRange and (y:techRange/@min &gt; $maxTech)"></xsl:when>
            <xsl:when test="y:techRange and (y:techRange/@max &lt; $minTech)"></xsl:when>
            <xsl:otherwise>
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
                        (<xsl:apply-templates select="." mode="list-defaults"/>)
                    </xsl:if>
                    <xsl:if test="y:short">
                        <xsl:text> - </xsl:text>
                        <fo:inline font-style="italic">
                            <xsl:value-of select="y:short"/>
                        </fo:inline>
                    </xsl:if>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="y:skill" mode="list-defaults">
        <xsl:for-each select="y:default">
            <xsl:choose>
                <xsl:when test="position() &gt; 1">
                    <xsl:text>, </xsl:text><xsl:value-of select="."/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="y:skill" mode="list-prerequisites">
        <xsl:for-each select="y:prerequisite">
            <xsl:variable name="score">
                <xsl:choose>
                    <xsl:when test="@score">
                        <xsl:value-of select="@score"/>
                    </xsl:when>
                    <xsl:otherwise>2</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:choose>
                <xsl:when test="position() &gt; 1">
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="."/>-<xsl:value-of select="$score"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>-<xsl:value-of select="$score"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
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
        <xsl:param name="techniques" select="../y:techniques"/>
        <xsl:param name="minTech" select="0"/>
        <xsl:param name="maxTech" select="20"/>

        <xsl:choose>
            <xsl:when test="y:techRange and (y:techRange/@min &gt; $maxTech)"></xsl:when>
            <xsl:when test="y:techRange and (y:techRange/@max &lt; $minTech)"></xsl:when>
            <xsl:otherwise>
                <fo:block font-size="{$font-medium}"
                        font-family="{$font-body}"
                        space-after="0pt">


                    <fo:block color="{$colour}"
                            font-weight="bold"
                            space-after="0pt"
                            space-before="0pt"
                            keep-with-next="always">
                        <xsl:value-of select="@name"/>

                        <xsl:if test="y:genre">
                            <xsl:text>/</xsl:text>
                            <fo:inline font-size="{$font-small}">
                                <xsl:value-of select="y:genre"/>
                            </fo:inline>
                        </xsl:if>

                        <xsl:choose>
                            <xsl:when test="@type='talent'"> (Talent)</xsl:when>
                            <xsl:when test="@type='knowledge'"> (Knowledge)</xsl:when>
                            <xsl:when test="@type='language'"> (Language)</xsl:when>
                        </xsl:choose>
                    </fo:block>

                    <xsl:if test="y:group">
                        <fo:block font-variant="small-caps"
                                space-after="0pt" keep-with-next="always">
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

                    <xsl:if test="y:limited">
                        <fo:block space-after="0pt" keep-with-next="always">
                            <fo:inline font-weight="bold">
                                Limited by:
                            </fo:inline>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="y:limited"/>
                        </fo:block>
                    </xsl:if>

                    <xsl:if test="y:default">
                        <fo:block space-after="0pt" keep-with-next="always">
                            <fo:inline font-weight="bold">
                                Defaults to:
                            </fo:inline>
                            <xsl:text> </xsl:text>
                            <xsl:apply-templates select="." mode="list-defaults"/>
                            <xsl:text> </xsl:text>
                        </fo:block>
                    </xsl:if>

                    <xsl:if test="y:prerequisite">
                        <fo:block space-after="0pt" keep-with-next="always">
                            <fo:inline font-weight="bold">
                                Requires:
                            </fo:inline>
                            <xsl:text> </xsl:text>
                            <xsl:apply-templates select="." mode="list-prerequisites"/>
                        </fo:block>
                    </xsl:if>

                    <xsl:if test="y:techRange">
                        <xsl:variable name="min" select="y:techRange/@min"/>
                        <xsl:variable name="max" select="y:techRange/@max"/>

                        <fo:block space-after="0pt">
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

                    <xsl:if test="$techniques">
                        <xsl:variable name="us" select="@name"/>
                        <xsl:variable name="groups" select="y:group"/>

                        <xsl:if test="$techniques/y:advantage/y:skill/@name=$us or  $techniques/y:advantage/y:skill/@name=$groups">
                            <fo:block font-size="{$font-medium}" font-family="{$font-body}"
                                    font-style="italic"
                                    space-after="0pt" keep-with-next="always">
                                <fo:inline font-weight="bold" font-style="normal">
                                    Techniques:
                                </fo:inline>
                                <xsl:for-each select="$techniques/y:advantage[y:skill/@name=$us
                                            or y:skill/@name=$groups]">
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
            </xsl:otherwise>
        </xsl:choose>
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


    <xsl:template match="yb:para/y:skeq">
        <fo:inline font-weight="bold">
            <xsl:for-each select="y:attr">
                <fo:inline font-style="italic">
                    <xsl:value-of select="."/>
                </fo:inline>
                <xsl:if test="position() &lt; last()">|</xsl:if>
            </xsl:for-each>
        </fo:inline>

        <xsl:text> x </xsl:text>

        <fo:inline font-weight="bold">
            <xsl:choose>
                <xsl:when test="y:sk">
                    <xsl:for-each select="y:sk">
                        <fo:inline font-style="italic">
                            <xsl:value-of select="."/>
                        </fo:inline>
                        <xsl:if test="position() &lt; last()">|</xsl:if>
                    </xsl:for-each>
                </xsl:when>

                <xsl:when test="y:const">
                    <xsl:value-of select="y:const"/>
                </xsl:when>
            </xsl:choose>
        </fo:inline>

        <xsl:if test="y:bonus">
            <xsl:text> + </xsl:text>
            <fo:inline font-weight="bold">
                <xsl:value-of select="y:bonus"/>
            </fo:inline>
        </xsl:if>

        <xsl:if test="y:penalty">
            <xsl:text> - </xsl:text>
            <fo:inline font-weight="bold">
                <xsl:value-of select="y:penalty"/>
            </fo:inline>
        </xsl:if>

        <xsl:if test="y:die">
            <xsl:text> + d20</xsl:text>
        </xsl:if>

    </xsl:template>

    <xsl:template match="y:skeq">
        <fo:block
            font-size="8pt"
            font-family="{$font-body}"
            font-style="italic"
            line-height="12pt"
            space-after.optimum="12pt"
            margin-left="1cm"
            margin-right="1cm"
            background-color="{$lightcolour}">

            <xsl:if test="y:title">
                <fo:block font-weight="bold">
                    <xsl:value-of select="title"/>
                </fo:block>
            </xsl:if>

            <xsl:value-of select="y:attr"/>
            <xsl:text> x </xsl:text>
            <xsl:choose>
                <xsl:when test="y:sk">
                    <xsl:value-of select="y:sk"/>
                </xsl:when>
                <xsl:when test="y:const">
                    <xsl:value-of select="y:const"/>
                </xsl:when>
            </xsl:choose>
            <xsl:if test="y:bonus">
                <xsl:text> + </xsl:text>
                <xsl:value-of select="y:bonus"/>
            </xsl:if>
            <xsl:if test="y:penalty">
                <xsl:text> - </xsl:text>
                <xsl:value-of select="y:penalty"/>
            </xsl:if>
            <xsl:if test="y:die">
                <xsl:text> + d20</xsl:text>
            </xsl:if>
        </fo:block>
    </xsl:template>

    <xsl:template match="y:*" mode="attributeSkill">
        <xsl:param name="attribute" select="'strength'"/>

        <xsl:variable name="skill">
            <xsl:choose>
                <xsl:when test=". = ''">4</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <fo:inline font-style="italic">
            <xsl:value-of select="$attribute"/> x <xsl:value-of select="$skill"/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="y:strength">
        <xsl:apply-templates select="." mode="attributeSkill">
            <xsl:with-param name="attribute" select="'Strength'"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="y:health">
        <xsl:apply-templates select="." mode="attributeSkill">
            <xsl:with-param name="attribute" select="'Health'"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="y:agility">
        <xsl:apply-templates select="." mode="attributeSkill">
            <xsl:with-param name="attribute" select="'Agility'"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="y:dexterity">
        <xsl:apply-templates select="." mode="attributeSkill">
            <xsl:with-param name="attribute" select="'Dexterity'"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="y:perception">
        <xsl:apply-templates select="." mode="attributeSkill">
            <xsl:with-param name="attribute" select="'Perception'"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="y:intelligence">
        <xsl:apply-templates select="." mode="attributeSkill">
            <xsl:with-param name="attribute" select="'Intelligence'"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="y:empathy">
        <xsl:apply-templates select="." mode="attributeSkill">
            <xsl:with-param name="attribute" select="'Empathy'"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="y:will">
        <xsl:apply-templates select="." mode="attributeSkill">
            <xsl:with-param name="attribute" select="'Will'"/>
        </xsl:apply-templates>
    </xsl:template>

</xsl:stylesheet>

