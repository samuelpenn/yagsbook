<?xml version="1.0"?>

<!--
    Stylesheet transform for Yagsbook to HTML.

    These templates are for advantages.

    Author:  Samuel Penn
    Version: $Revision: 1.9 $
    Date:    $Date: 2006/12/17 14:17:10 $

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
        List advantages as a tree.

        Following templates will print out a summary of the advantages in
        tree format, giving a one line overview of each, nested so that it
        is easy to read the prerequisite chains.

        Only really works for techniques.
    -->
    <xsl:template match="y:import-advantages-tree">
        <xsl:apply-templates select="document(@href)/y:advantages" mode="tree"/>
    </xsl:template>

    <xsl:template match="y:advantages" mode="tree">
        <xsl:apply-templates select="y:advantage[not(y:prerequisite)]" mode="tree">
            <xsl:sort data-type="text" select="@name"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="y:advantages">
        <xsl:apply-templates select="y:advantage">
            <xsl:sort data-type="text" select="@name"/>
        </xsl:apply-templates>
    </xsl:template>

    <!--
        Technically we shouldn't output a technique at the root level if it
        has any prerequisites. However, sometimes a prerequisite is missing
        from the list, so in this case we do print it so it doesn't get missed.
        This is valid if a prerequisite happens to be part of some other list
        elsewhere and this is just a specialist list.
    -->
    <xsl:template match="y:advantage[y:prerequisite]" mode="root">
        <xsl:variable name="p" select="y:prerequisite"/>

        <xsl:if test="not(../y:advantage[@name=$p])">
            <xsl:apply-templates select="." mode="tree"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="y:advantage" mode="root">
        <xsl:apply-templates select="." mode="tree"/>
    </xsl:template>

    <xsl:template match="y:advantage" mode="tree">
        <xsl:variable name="advName" select="@name"/>

        <div style="margin-left: 7mm;">
            <p style="margin: 0mm; margin-left: 10mm; font-size: small;">
                <b><xsl:value-of select="$advName"/></b>
                <xsl:if test="not(y:skill) and y:cost/@points">
                    (<xsl:value-of select="y:cost/@points"/>)
                </xsl:if>
                <xsl:if test="y:skill">
                    (<xsl:value-of select="y:cost/@points"/>; <xsl:value-of select="y:skill/@name"/>)
                </xsl:if>
                <xsl:if test="y:short">
                    <i>- <xsl:value-of select="y:short"/></i>
                </xsl:if>
            </p>
            <xsl:apply-templates select="../y:advantage[y:prerequisite=$advName]" mode="tree"/>
        </div>
    </xsl:template>


    <xsl:template match="y:import-advantages">
        <xsl:choose>
            <xsl:when test="@source">
                <xsl:variable name="source" select="@source"/>
                <xsl:variable name="topic" select="@topic"/>
                <xsl:variable name="role" select="@role"/>

                <xsl:variable name="index"
                              select="concat($source, '/index.xml')"/>

                <xsl:choose>
                    <xsl:when test="@topic">
                        <xsl:for-each select="document($index)/yb:index/yb:article">
                            <xsl:variable name="file" select="."/>
                            <xsl:variable name="path"
                                        select="concat($source, '/', $file)"/>

                            <xsl:if test="document($path)/yb:article/yb:header/yb:topics/yb:topic/@uri=$topic">
                                <xsl:apply-templates
                                    select="document($path)/yb:article/yb:body//y:advantages[@role=$role]"
                                    mode="importByRole"/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:for-each select="document($index)/yb:index/yb:article">
                            <xsl:variable name="file" select="."/>
                            <xsl:variable name="path"
                                        select="concat($source, '/', $file)"/>

                            <xsl:apply-templates
                                select="document($path)/yb:article/yb:body//y:advantages[@role=$role]"
                                mode="importByRole"/>

                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>

            <xsl:when test="y:adv">
                <xsl:variable name="type" select="@type"/>
                <xsl:variable name="list" select="document(y:adv)/y:advantages/y:advantage"/>

                <xsl:if test="@tree='true'">
                    <h5>Summary</h5>
                    <xsl:apply-templates select="$list" mode="root">
                        <xsl:sort select="@name" data-type="text"/>
                    </xsl:apply-templates>
                    <h5>Descriptions</h5>
                </xsl:if>

                <xsl:apply-templates select="document(y:adv)//y:advantage[@type=$type]">
                    <xsl:sort select="@name" data-type="text"/>
                </xsl:apply-templates>

            </xsl:when>

            <xsl:when test="@href">
                <xsl:variable name="href" select="@href"/>
                <xsl:variable name="type" select="@type"/>

                <xsl:if test="@tree='true'">
                    <h5>Summary</h5>
                    <xsl:apply-templates select="document($href)//y:advantages" mode="tree"/>
                    <h5>Descriptions</h5>
                </xsl:if>

                <xsl:apply-templates
                        select="document($href)//y:advantage[@type=$type]">
                    <xsl:sort select="@name" data-type="text"/>
                </xsl:apply-templates>
            </xsl:when>

            <xsl:otherwise>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="y:advantages" mode="importByRole">
        <xsl:if test="y:advantage">
            <h4><xsl:value-of select="@title"/></h4>

            <xsl:apply-templates select="yb:description"/>

            <xsl:apply-templates select="y:advantage">
                <xsl:sort select="@name" data-type="text"/>
            </xsl:apply-templates>
        </xsl:if>
    </xsl:template>


    <xsl:template match="y:advantage">
        <xsl:choose>
            <xsl:when test="@type='edge'">
                <xsl:apply-templates select="." mode="basic"/>
            </xsl:when>
            <xsl:when test="@type='flaw'">
                <xsl:apply-templates select="." mode="basic"/>
            </xsl:when>
            <xsl:when test="@type='advantage'">
                <xsl:apply-templates select="." mode="basic"/>
            </xsl:when>
            <xsl:when test="@type='passion'">
                <p class="advantage">
                    <xsl:apply-templates select="." mode="passion"/>
                </p>
            </xsl:when>
            <xsl:when test="@type='technique'">
                <xsl:apply-templates select="." mode="technique"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="basic"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
        Try and replace all the advantage types with a single generic
        templates. This will makes things a lot easier.
    -->
    <xsl:template match="y:advantage" mode="basic">
        <p class="advantage">
            <xsl:choose>
                <xsl:when test="y:cost/@levels">
                    <b><xsl:value-of select="@name"/>
                        (<xsl:value-of select="y:cost/@points"/>/<xsl:value-of select="y:cost/@levels"/> levels):
                    </b>
                </xsl:when>
                <xsl:otherwise>
                    <b><xsl:value-of select="@name"/>
                        <xsl:if test="y:cost/@points">
                        (<xsl:for-each select="y:cost/@points">
                        <xsl:if test="position()=last()">
                            <xsl:value-of select="."/>
                        </xsl:if>
                        <xsl:if test="not(position()=last())">
                            <xsl:value-of select="."/>,
                        </xsl:if>
                    </xsl:for-each>)</xsl:if>:
                    </b>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:if test="y:prerequisite">
                <br/>
                <i><xsl:text>Prerequisites: </xsl:text></i>
                <xsl:apply-templates select="y:prerequisite"/>
            </xsl:if>

            <xsl:if test="y:forbiddon">
                <br/>
                <i><xsl:text>Cannot take: </xsl:text></i>
                <xsl:apply-templates select="y:forbiddon"/>
            </xsl:if>

            <xsl:if test="y:restriction">
                <br/>
                <i><xsl:text>Restricted to: </xsl:text></i>
                <xsl:apply-templates select="y:restriction"/>
            </xsl:if>
        </p>

        <xsl:apply-templates select="yb:description"/>
    </xsl:template>

    <xsl:template match="y:advantage/y:prerequisite">
        <xsl:if test="position() &lt; last()">
            <xsl:value-of select="."/><xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:if test="position() = last()">
            <xsl:value-of select="."/>.
        </xsl:if>
    </xsl:template>

    <xsl:template match="y:advantage/y:forbiddon">
        <xsl:if test="position() &lt; last()">
            <xsl:value-of select="."/><xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:if test="position() = last()">
            <xsl:value-of select="."/>.
        </xsl:if>
    </xsl:template>

    <xsl:template match="y:advantage/y:restriction">
        <xsl:if test="position() &lt; last()">
            <xsl:value-of select="."/><xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:if test="position() = last()">
            <xsl:value-of select="."/>.
        </xsl:if>
    </xsl:template>

    <!--
        Techniques are special combat advantages. Need to list which skills
        they can be used with. The cost is also the minimum skill level.
    -->
    <xsl:template match="y:advantage" mode="technique">
        <p class="advantage">
            <b><xsl:value-of select="@name"/>
            (Cost <xsl:value-of select="y:cost/@points"/>): </b>
            <xsl:apply-templates select="./y:skill">
                <xsl:sort select="@name" data-type="text"/>
            </xsl:apply-templates>
            <xsl:if test="y:prerequisite">
                <br/>
                <i>Prerequisites: </i>
                <xsl:apply-templates select="y:prerequisite"/>
                <br/>
            </xsl:if>
            <xsl:if test="y:restriction">
                <br/>
                <i>Restrictions: </i>
                <xsl:apply-templates select="y:restriction"/>
                <br/>
            </xsl:if>
        </p>

        <xsl:apply-templates select="yb:description"/>
    </xsl:template>

    <xsl:template match="y:advantage/y:skill">
        <xsl:if test="position() &lt; last()">
            <i><xsl:value-of select="@name"/>, </i>
        </xsl:if>

        <xsl:if test="position() = last()">
            <i><xsl:value-of select="@name"/>.</i>
        </xsl:if>
    </xsl:template>
</xsl:transform>
