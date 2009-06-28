<?xml version="1.0"?>

<!--
    Yagsbook stylesheet for Skills

    Author:  Samuel Penn
    Version: $Revision: 1.15 $
    Date:    $Date: 2007/09/09 10:32:55 $

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
                version="1.0">

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

            <h4><xsl:value-of select="$group"/></h4>

            <p>
                <xsl:apply-templates select="$allSkills/y:skill[y:group = $group]" mode="list">
                    <xsl:sort select="@name" data-type="text"/>
                    <xsl:with-param name="minTech" select="$minTech"/>
                    <xsl:with-param name="maxTech" select="$maxTech"/>
                </xsl:apply-templates>
            </p>

        </xsl:for-each>
    </xsl:template>

    <!--
        skill-list

        An inline list of skill descriptions. Just list them out in
        alphabetical order.
        -->
    <xsl:template match="y:skill-list">
        <xsl:variable name="allSkills" select="document(y:skills)/y:skill-list"/>
        <xsl:variable name="allTechniques" select="document(y:techniques)//y:advantage"/>

        <xsl:apply-templates select="y:skill">
            <xsl:sort select="name" data-type="text"/>

            <xsl:with-param name="allSkills" select="$allSkills"/>
            <xsl:with-param name="allTechniques" select="$allSkills"/>
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
                <xsl:apply-templates select="$skills/y:skill[group=$group]">
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
                <b><xsl:value-of select="@name"/></b>
                <xsl:choose>
                    <xsl:when test="@type='talent'">(*)</xsl:when>
                    <xsl:when test="@type='knowledge'">(K)</xsl:when>
                    <xsl:when test="@type='language'">(L)</xsl:when>
                </xsl:choose>
                <xsl:if test="y:default">
                    (<xsl:apply-templates select="." mode="list-defaults"/>)
                </xsl:if>
                <xsl:if test="y:short">
                    <xsl:text> - </xsl:text> <i><xsl:value-of select="y:short"/></i>
                </xsl:if>
                <br/>
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
        A description of a skill. Could include example target numbers.

        Skill Name
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
                <div class="skill">
                    <h6>
                        <xsl:value-of select="@name"/>
                        <xsl:if test="y:genre">
                            <xsl:text>/</xsl:text>
                            <small><xsl:value-of select="y:genre"/></small>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="@type='talent'"> (Talent)</xsl:when>
                            <xsl:when test="@type='knowledge'"> (Knowledge)</xsl:when>
                            <xsl:when test="@type='language'"> (Language)</xsl:when>
                        </xsl:choose>
                    </h6>

                    <xsl:if test="y:group">
                        <p class="skill" style="font-variant: small-caps">
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
                        </p>
                    </xsl:if>

                    <xsl:if test="y:default or y:prerequisite or y:limited">
                        <p class="skill">
                            <xsl:if test="y:limited">
                                <b>Limited by: </b>
                                <xsl:value-of select="y:limited"/>
                                <xsl:text> </xsl:text>
                                <xsl:if test="y:default and y:prerequisite">
                                    <br/>
                                </xsl:if>
                            </xsl:if>
                            <xsl:if test="y:default">
                                <b>Defaults to: </b>
                                <xsl:apply-templates select="." mode="list-defaults"/>
                                <xsl:text> </xsl:text>
                            </xsl:if>

                            <xsl:if test="y:prerequisite">
                                <b>Requires: </b>
                                <xsl:apply-templates select="." mode="list-prerequisites"/>
                            </xsl:if>
                        </p>
                    </xsl:if>


                    <xsl:if test="$techniques">
                        <p class="y:skill">
                            <xsl:variable name="us" select="@name"/>
                            <xsl:variable name="groups" select="y:group"/>

                            <xsl:if test="$techniques/y:advantage/y:skill/@name=$us or $techniques/y:advantage/y:skill/@name=$groups">
                                <i>Techniques: </i>
                                <xsl:for-each select="$techniques/y:advantage[y:skill/@name=$us or y:skill/@name=$groups]">
                                    <xsl:if test="position()=last()">
                                        <xsl:value-of select="@name"/>.
                                    </xsl:if>
                                    <xsl:if test="position() &lt; last()">
                                        <xsl:value-of select="@name"/>,
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:if>
                        </p>
                    </xsl:if>

                    <xsl:apply-templates select="yb:description[not(@task)]"/>

                    <div class="task">
                        <xsl:for-each select="yb:description[@task]">
                            <h6><xsl:value-of select="@task"/></h6>

                            <xsl:apply-templates select="."/>
                        </xsl:for-each>
                    </div>

                    <xsl:apply-templates select="y:examples"/>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="y:skill/y:examples">
        <table class="skillexamples">
            <xsl:choose>
                <xsl:when test="@task">
                    <caption>
                        Example difficulties (<xsl:value-of select="@task"/>)
                    </caption>
                </xsl:when>
                <xsl:otherwise>
                    <caption>Example difficulties</caption>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="y:example"/>
        </table>
    </xsl:template>


    <xsl:template match="y:skill-list/y:skill/y:examples/y:example">
        <tr>
            <td class="target" valign="top"><xsl:value-of select="@target"/></td>
            <td class="value" valign="top"><xsl:value-of select="."/></td>
        </tr>
    </xsl:template>

    <xsl:template match="y:skeq">
        <p>
            <xsl:if test="y:title">
                <b><xsl:value-of select="y:title"/></b><br/>
            </xsl:if>

            <b>
                <xsl:for-each select="y:attr">
                    <i><xsl:value-of select="."/></i>
                    <xsl:if test="position() &lt; last()">|</xsl:if>
                </xsl:for-each>
            </b>

            <xsl:if test="y:sk or y:const">
                <xsl:text> x </xsl:text>

                <b>
                    <xsl:choose>
                        <xsl:when test="y:sk">
                            <xsl:for-each select="y:sk">
                                <i><xsl:value-of select="."/></i>
                                <xsl:if test="position() &lt; last()">|</xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="y:const">
                            <xsl:value-of select="y:const"/>
                        </xsl:when>
                    </xsl:choose>
                </b>
            </xsl:if>

            <xsl:if test="y:bonus">
                <xsl:text> + </xsl:text><b><xsl:value-of select="y:bonus"/></b>
            </xsl:if>

            <xsl:if test="y:penalty">
                <xsl:text> - </xsl:text><b><xsl:value-of select="y:penalty"/></b>
            </xsl:if>

            <xsl:if test="y:die">
                <xsl:text> + d20</xsl:text>
            </xsl:if>
        </p>
    </xsl:template>

    <xsl:template match="yb:para/y:skeq">
        <b>
            <xsl:for-each select="y:attr">
                <i><xsl:value-of select="."/></i>
                <xsl:if test="position() &lt; last()">|</xsl:if>
            </xsl:for-each>
        </b>

        <xsl:if test="y:sk or y:const">
            <xsl:text> x </xsl:text>

            <b>
                <xsl:choose>
                    <xsl:when test="y:sk">
                        <xsl:for-each select="y:sk">
                            <i><xsl:value-of select="."/></i>
                            <xsl:if test="position() &lt; last()">|</xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="y:const">
                        <xsl:value-of select="y:const"/>
                    </xsl:when>
                </xsl:choose>
            </b>
        </xsl:if>

        <xsl:if test="y:bonus">
            <xsl:text> + </xsl:text><b><xsl:value-of select="y:bonus"/></b>
        </xsl:if>

        <xsl:if test="y:penalty">
            <xsl:text> - </xsl:text><b><xsl:value-of select="y:penalty"/></b>
        </xsl:if>

        <xsl:if test="y:die">
            <xsl:text> + d20</xsl:text>
        </xsl:if>
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

        <i><xsl:value-of select="$attribute"/> x <xsl:value-of select="$skill"/></i>
    </xsl:template>

    <xsl:template match="y:strength">
        <xsl:apply-templates select="." mode="attributeSkill">
            <xsl:with-param name="attribute" select="'strength'"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="y:health">
        <xsl:apply-templates select="." mode="attributeSkill">
            <xsl:with-param name="attribute" select="'health'"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="y:agility">
        <xsl:apply-templates select="." mode="attributeSkill">
            <xsl:with-param name="attribute" select="'agility'"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="y:dexterity">
        <xsl:apply-templates select="." mode="attributeSkill">
            <xsl:with-param name="attribute" select="'dexterity'"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="y:perception">
        <xsl:apply-templates select="." mode="attributeSkill">
            <xsl:with-param name="attribute" select="'perception'"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="y:intelligence">
        <xsl:apply-templates select="." mode="attributeSkill">
            <xsl:with-param name="attribute" select="'intelligence'"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="y:empathy">
        <xsl:apply-templates select="." mode="attributeSkill">
            <xsl:with-param name="attribute" select="'empathy'"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="y:will">
        <xsl:apply-templates select="." mode="attributeSkill">
            <xsl:with-param name="attribute" select="'will'"/>
        </xsl:apply-templates>
    </xsl:template>

</xsl:transform>
