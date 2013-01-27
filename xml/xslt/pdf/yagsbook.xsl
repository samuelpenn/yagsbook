<?xml version="1.0"?>

<!--
    Stylesheet transform for Yagsbook to PDF.

    This is the top level stylesheet, which includes all the other
    stylesheet files, and handles the header and top level body
    parts of the document.

    All global variables should also be defined in this file.

    Author:  Samuel Penn

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
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">

    <!-- Global static variables -->
    <xsl:variable name="font-xx-small">6pt</xsl:variable>
    <xsl:variable name="font-x-small">7pt</xsl:variable>
    <xsl:variable name="font-small">8pt</xsl:variable>
    <xsl:variable name="font-medium">10pt</xsl:variable>
    <xsl:variable name="font-large">12pt</xsl:variable>
    <xsl:variable name="font-x-large">14pt</xsl:variable>
    <xsl:variable name="font-xx-large">16pt</xsl:variable>

    <xsl:variable name="font-body">Helvetica</xsl:variable>
    <xsl:variable name="font-heading">sans-serif</xsl:variable>

    <xsl:variable name="svgImageBase">../icons/</xsl:variable>


    <xsl:variable name="article-style"
                  select="/yb:article/yb:header/yb:style/@name"/>

    <xsl:variable name="tagLine"
                  select="/yb:article/yb:header/yb:tagline"/>

    <!-- Set up the colours based on the style. -->
    <xsl:variable name="colour">
        <xsl:choose>
            <xsl:when test="$article-style='core'">orange</xsl:when>
            <xsl:when test="$article-style='combat'">red</xsl:when>
            <xsl:when test="$article-style='character'">green</xsl:when>
            <xsl:when test="$article-style='catalogue'">black</xsl:when>
            <xsl:when test="$article-style='magic'">#00eeff</xsl:when>

            <xsl:when test="$article-style='religion'">blue</xsl:when>
            <xsl:when test="$article-style='module'">black</xsl:when>
            <xsl:when test="$article-style='equipment'">#ff00bb</xsl:when>
            <xsl:otherwise>black</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="lightcolour">
        <xsl:choose>
            <xsl:when test="$article-style='core'">#ffeecc</xsl:when>
            <xsl:when test="$article-style='core'">#ffddbb</xsl:when>
            <xsl:when test="$article-style='character'">#aaffaa</xsl:when>
            <xsl:when test="$article-style='combat'">#ffeeee</xsl:when>
            <xsl:when test="$article-style='magic'">#aaddff</xsl:when>

            <xsl:when test="$article-style='religion'">#aaddff</xsl:when>
            <xsl:when test="$article-style='module'">#fafafa</xsl:when>
            <xsl:when test="$article-style='equipment'">#faf0fa</xsl:when>
            <xsl:otherwise>#fafafa</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="darkcolour">
        <xsl:choose>
            <xsl:when test="$article-style='core'">#ffdd99</xsl:when>
            <xsl:when test="$article-style='core'">#ffbb77</xsl:when>
            <xsl:when test="$article-style='character'">#ddffdd</xsl:when>
            <xsl:when test="$article-style='combat'">#ffdddd</xsl:when>
            <xsl:when test="$article-style='catalogue'">#eeeeee</xsl:when>
            <xsl:when test="$article-style='magic'">#5555ff</xsl:when>

            <xsl:when test="$article-style='religion'">#5555ff</xsl:when>
            <xsl:when test="$article-style='module'">#eeeeee</xsl:when>
            <xsl:when test="$article-style='equipment'">#eeccee</xsl:when>
            <xsl:otherwise>#eeeeee</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="headerImage">
        <xsl:choose>
            <xsl:when test="$article-style='core'">header-core</xsl:when>
            <xsl:when test="$article-style='character'">header-character</xsl:when>
            <xsl:when test="$article-style='combat'">header-combat</xsl:when>
            <xsl:when test="$article-style='catalogue'">header</xsl:when>
            <xsl:when test="$article-style='magic'">header</xsl:when>

            <xsl:when test="$article-style='religion'">header</xsl:when>
            <xsl:when test="$article-style='module'">header</xsl:when>
            <xsl:otherwise>#eeeeee</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <!-- Pull out version information -->
    <xsl:variable name="versionNumber">
        <xsl:variable name="cvsvtag"
                      select="/yb:article/yb:header/yb:cvsinfo/yb:version"/>
        <xsl:variable name="temp" select="substring-after($cvsvtag, ' ')"/>
        <xsl:value-of select="substring-before($temp, ' ')"/>
    </xsl:variable>


    <!-- Generic elements (mostly DocBook compatible) -->
    <xsl:include href="../html/globals.xsl"/>

    <xsl:include href="contents.xsl"/>
    <xsl:include href="headings.xsl"/>
    <xsl:include href="tables.xsl"/>
    <xsl:include href="variablelist.xsl"/>
    <xsl:include href="para.xsl"/>
    <xsl:include href="images.xsl"/>

    <!-- Gaming specific elements -->
    <xsl:include href="bestiary.xsl"/>
    <xsl:include href="characters.xsl"/>
    <xsl:include href="equipment.xsl"/>
    <xsl:include href="library.xsl"/>

    <xsl:include href="yags/yags.xsl"/>

    <!-- Rendition neutral elements
    <xsl:include href="../share/combat.xsl"/>
    -->



    <xsl:template match="/yb:article">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
            <xsl:call-template name="masterpages"/>
            <xsl:call-template name="document"/>
        </fo:root>
    </xsl:template>

    <xsl:template match="/yb:bestiary">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
            <xsl:call-template name="bestiary-masterpages"/>
            <xsl:apply-templates select="yb:beast" mode="document"/>
        </fo:root>
    </xsl:template>

    <xsl:template match="/yb:bestiary/yb:beast" mode="document">
        <xsl:call-template name="bestiary-document"/>
    </xsl:template>

    <!-- ************************************************************** -->
    <!-- Template for the masterpages for this document.                -->
    <!-- ************************************************************** -->
    <xsl:template name="masterpages">
        <fo:layout-master-set>
            <!-- Left master page -->

            <fo:simple-page-master master-name="leftPage"
                                    page-height="297mm"
                                    page-width="210mm"
                                    margin-top="15mm"
                                    margin-bottom="15mm"
                                    margin-left="0mm"
                                    margin-right="10mm"
                                    padding="0mm">

                <fo:region-body
                    column-count="2"
                    margin-left="10mm"
                    margin-right="10mm"
                    margin-top="15mm"
                    margin-bottom="11mm" />

                <fo:region-before extent="15mm"
                    region-name="region-before-left"/>
                <fo:region-after extent="10mm"
                    region-name="region-after-left"/>
                <fo:region-start extent="10mm"/>
                <fo:region-end extent="10mm"/>
            </fo:simple-page-master>

            <!-- Right master page -->
            <fo:simple-page-master master-name="rightPage"
                                    page-height="297mm"
                                    page-width="210mm"
                                    margin-top="15mm"
                                    margin-bottom="15mm"
                                    margin-left="10mm"
                                    margin-right="0mm"
                                    padding="0mm">

                <fo:region-body
                    column-count="2"
                    margin-right="10mm"
                    margin-left="10mm"
                    margin-top="15mm"
                    margin-bottom="11mm" />

                <fo:region-before extent="15mm"
                    region-name="region-before-right"/>

                <fo:region-after extent="10mm"
                    region-name="region-after-right"/>

                <fo:region-start extent="10mm"/>
                <fo:region-end extent="10mm"/>

            </fo:simple-page-master>

            <!-- Left master page single column -->
            <fo:simple-page-master master-name="leftPage1"
                                   page-height="297mm"
                                   page-width="210mm"
                                   margin-top="10mm"
                                   margin-bottom="5mm"
                                   margin-left="0mm"
                                   margin-right="10mm">

                <fo:region-body
                               column-count="1"
                               margin-left="10mm"
                               margin-right="10mm"
                               margin-top="11mm"
                               margin-bottom="11mm" />

                <fo:region-before extent="15mm"
                                  region-name="region-before-left"/>
                <fo:region-after extent="10mm"
                                 region-name="region-after-left"/>
                <fo:region-start extent="10mm"/>
                <fo:region-end extent="10mm"/>
            </fo:simple-page-master>

            <!-- Right master page single column -->
            <fo:simple-page-master master-name="rightPage1"
                                   page-height="297mm"
                                   page-width="210mm"
                                   margin-top="10mm"
                                   margin-bottom="5mm"
                                   margin-left="10mm"
                                   margin-right="0mm">

                <fo:region-body
                               column-count="1"
                               margin-right="10mm"
                               margin-left="10mm"
                               margin-top="11mm"
                               margin-bottom="11mm" />

                <fo:region-before extent="15mm"
                                  region-name="region-before-right"/>

                <fo:region-after extent="10mm"
                                 region-name="region-after-right"/>

                <fo:region-start extent="10mm"/>
                <fo:region-end extent="10mm"/>

            </fo:simple-page-master>

            <fo:simple-page-master master-name="frontPage"
                                   page-height="297mm"
                                   page-width="210mm"
                                   margin-top="10mm"
                                   margin-bottom="5mm"
                                   margin-left="10mm"
                                   margin-right="0mm">

                <fo:region-body
                               column-count="1"
                               margin-right="0mm"
                               margin-left="0mm"
                               margin-top="0mm"
                               margin-bottom="0mm" />
            </fo:simple-page-master>

            <!-- Sequence for the whole document -->
            <fo:page-sequence-master master-name="document">
                <fo:repeatable-page-master-alternatives>
                    <fo:conditional-page-master-reference
                        master-reference="leftPage" odd-or-even="even"/>
                    <fo:conditional-page-master-reference
                        master-reference="rightPage" odd-or-even="odd"/>
                </fo:repeatable-page-master-alternatives>
            </fo:page-sequence-master>

            <fo:page-sequence-master master-name="document1">
                <fo:repeatable-page-master-alternatives>
                    <fo:conditional-page-master-reference
                           master-reference="leftPage1" odd-or-even="even"/>
                    <fo:conditional-page-master-reference
                           master-reference="rightPage1" odd-or-even="odd"/>
                </fo:repeatable-page-master-alternatives>
            </fo:page-sequence-master>

            <fo:page-sequence-master master-name="cover">
                <fo:repeatable-page-master-alternatives>
                    <fo:conditional-page-master-reference
                        master-reference="frontPage" odd-or-even="even"/>
                    <fo:conditional-page-master-reference
                        master-reference="frontPage" odd-or-even="odd"/>
                </fo:repeatable-page-master-alternatives>
            </fo:page-sequence-master>
        </fo:layout-master-set>
    </xsl:template>

    <xsl:template name="copyright-and-version">
        <xsl:value-of select="$tagLine"/>
        <xsl:text> </xsl:text>
        (<xsl:value-of select="/yb:article/yb:header/yb:title"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$versionNumber"/>)
        <xsl:text> </xsl:text>
        <xsl:value-of select="/yb:article/yb:header/yb:license/yb:holder"/>
        (c) <xsl:value-of select="/yb:article/yb:header/yb:license/yb:year"/>
    </xsl:template>

    <!-- ************************************************************** -->
    <!-- Template for the document itself.                              -->
    <!-- ************************************************************** -->

    <xsl:template name="document">
        <xsl:if test="/yb:article/yb:front">
            <fo:page-sequence master-reference="cover" initial-page-number="1" force-page-count="no-force">
                <fo:flow flow-name="xsl-region-body" text-align="justify">
                    <fo:block>
                        <fo:external-graphic src="{/yb:article/yb:front/@href}" content-width="200mm"/>
                    </fo:block>
                </fo:flow>
            </fo:page-sequence>
            <fo:page-sequence master-reference="cover">
                <fo:flow flow-name="xsl-region-body" text-align="justify">
                    <fo:block>
                    </fo:block>
                </fo:flow>
            </fo:page-sequence>
        </xsl:if>

        <xsl:apply-templates select="/yb:article/yb:body/yb:sect1[1]">
            <xsl:with-param name="documentTitle">
                <xsl:value-of select="/yb:article/yb:header/yb:title"/>
            </xsl:with-param>
            <xsl:with-param name="pageNumber">1</xsl:with-param>
        </xsl:apply-templates>

        <xsl:apply-templates select="/yb:article/yb:body/yb:sect1[not(position()=1)]">
            <xsl:with-param name="documentTitle">
                <xsl:value-of select="/yb:article/yb:header/yb:title"/>
            </xsl:with-param>
            <xsl:with-param name="pageNumber">auto</xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>

    <!--
        Import a section1 heading in from an external document.

        This allows a book to be built up from several different articles.
    -->
    <xsl:template match="/yb:article/yb:body/yb:sect1[@href]">
        <xsl:param name="documentTitle" select="yb:article/yb:header/yb:title"/>
        <xsl:param name="pageNumber" select="auto"/>

        <xsl:variable name="body" select="document(@href)/yb:article/yb:body"/>
        <xsl:variable name="name" select="@name"/>

        <xsl:choose>
            <xsl:when test="@name">
                <xsl:apply-templates select="$body/yb:sect1[@id=$name]">
                    <xsl:with-param name="documentTitle" select="$documentTitle"/>
                </xsl:apply-templates>
            </xsl:when>

            <xsl:otherwise>
                <xsl:apply-templates select="$body/yb:sect1">
                    <xsl:with-param name="documentTitle" select="$documentTitle"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="yb:sect1">
        <xsl:param name="documentTitle" select="yb:article/yb:header/yb:title"/>
        <xsl:param name="pageNumber" select="auto"/>

        <xsl:choose>
            <xsl:when test="@format='wide'">
                <xsl:apply-templates select="." mode="wide">
                    <xsl:with-param name="documentTitle" select="$documentTitle"/>
                    <xsl:with-param name="pageNumber" select="$pageNumber"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="columns">
                    <xsl:with-param name="documentTitle" select="$documentTitle"/>
                    <xsl:with-param name="pageNumber" select="$pageNumber"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="yb:sect1" mode="columns">
        <xsl:param name="documentTitle" select="/yb:article/yb:header/yb:title"/>
        <xsl:param name="pageNumber" select="auto"/>

        <fo:page-sequence master-reference="document" initial-page-number="{$pageNumber}">
            <fo:static-content flow-name="region-before-right">
                <fo:block font-family="Helvetica" font-size="24pt"
                          text-align="end"
                          font-weight="bold"
                          color="white"
                          keep-with-next="always"
                          background-image="{$svgImageBase}{$headerImage}-right.svg"
                          background-repeat="no-repeat"
                          background-color="{$colour}">
                    <xsl:value-of select="$documentTitle"/>
                    <xsl:text> </xsl:text><fo:page-number/>
                    <xsl:text> </xsl:text>
                </fo:block>
            </fo:static-content>

            <fo:static-content flow-name="region-after-right">
                <fo:block font-family="{$font-body}" font-size="12pt"
                          text-align="end"
                          font-weight="bold"
                          font-style="italic"
                          border-before-width="2px"
                          border-before-color="black"
                          border-before-style="solid">
                    <xsl:call-template name="copyright-and-version"/>
                </fo:block>
            </fo:static-content>

            <fo:static-content flow-name="region-before-left">
                <fo:block font-family="Helvetica" font-size="24pt"
                          text-align="start"
                          font-weight="bold"
                          color="white"
                          background-image="{$svgImageBase}{$headerImage}-left.svg"
                          background-repeat="no-repeat"
                          background-position-horizontal="right"
                          background-color="{$colour}">
                    <xsl:text> </xsl:text>
                    <fo:page-number/><xsl:text> </xsl:text>
                    <xsl:value-of select="$documentTitle"/>
                </fo:block>
            </fo:static-content>

            <fo:static-content flow-name="region-after-left">
                <fo:block font-family="{$font-body}" font-size="12pt"
                          text-align="start"
                          font-weight="bold"
                          font-style="italic"
                          border-before-width="2px"
                          border-before-color="black"
                          border-before-style="solid">
                    <xsl:call-template name="copyright-and-version"/>
                </fo:block>
            </fo:static-content>

            <fo:flow flow-name="xsl-region-body" text-align="justify">
                <xsl:if test="yb:title">
                    <fo:block
                             font-weight="bold"
                             color="{$colour}"
                             font-size="20pt"
                             font-family="sans-serif"
                             line-height="24pt"
                             space-after="12pt"
                             text-align="start">

                        <!--
                        <xsl:number level="multiple" format="1"/>
                        <xsl:text> </xsl:text>
                        -->
                        <xsl:value-of select="yb:title"/>
                    </fo:block>
                </xsl:if>

                <!--
                    Now find all the children. The numbering only applies
                    to elements which make use of it, so we can happily pass
                    it down to <para> and <table> elements without worry, as
                    long as we don't use the 'prefix' parameter for anything
                    else on other templates.
                 -->
                <xsl:apply-templates>
                    <xsl:with-param name="prefix">
                        <xsl:number level="multiple" format="1"/>
                    </xsl:with-param>
                </xsl:apply-templates>
            </fo:flow>

        </fo:page-sequence>
    </xsl:template>

    <xsl:template match="yb:sect1" mode="wide">
        <xsl:param name="documentTitle" select="/yb:article/yb:header/yb:title"/>
        <xsl:param name="pageNumber" select="auto"/>

        <fo:page-sequence master-reference="document1" initial-page-number="{$pageNumber}">
            <fo:static-content flow-name="region-before-right">
                <fo:block font-family="Helvetica" font-size="24pt"
                          text-align="end"
                          font-weight="bold"
                          color="white"
                          background-color="{$colour}">
                    <xsl:value-of select="$documentTitle"/>
                    <xsl:text> </xsl:text><fo:page-number/>
                    <xsl:text> </xsl:text>
                </fo:block>
            </fo:static-content>

            <fo:static-content flow-name="region-after-right">
                <fo:block font-family="{$font-body}" font-size="12pt"
                          text-align="end"
                          font-weight="bold"
                          font-style="italic"
                          border-before-width="2px"
                          border-before-color="black"
                          border-before-style="solid">
                    <xsl:call-template name="copyright-and-version"/>
                </fo:block>
            </fo:static-content>

            <fo:static-content flow-name="region-before-left">
                <fo:block font-family="Helvetica" font-size="24pt"
                          text-align="start"
                          font-weight="bold"
                          color="white"
                          background-color="{$colour}">
                    <xsl:text> </xsl:text>
                    <fo:page-number/><xsl:text> </xsl:text>
                    <xsl:value-of select="$documentTitle"/>
                </fo:block>
            </fo:static-content>

            <fo:static-content flow-name="region-after-left">
                <fo:block font-family="{$font-body}" font-size="12pt"
                          text-align="start"
                          font-weight="bold"
                          font-style="italic"
                          border-before-width="2px"
                          border-before-color="black"
                          border-before-style="solid">
                    <xsl:call-template name="copyright-and-version"/>
                </fo:block>
            </fo:static-content>

            <fo:flow flow-name="xsl-region-body" text-align="justify">
                <xsl:if test="title">
                    <fo:block
                             font-weight="bold"
                             color="{$colour}"
                             font-size="20pt"
                             font-family="sans-serif"
                             line-height="24pt"
                             space-after="12pt"
                             text-align="start">

                        <!--
                        <xsl:number level="multiple" format="1"/>
                        <xsl:text> </xsl:text>
                        -->
                        <xsl:value-of select="yb:title"/>
                    </fo:block>
                </xsl:if>

                <!--
                    Now find all the children. The numbering only applies
                    to elements which make use of it, so we can happily pass
                    it down to <para> and <table> elements without worry, as
                    long as we don't use the 'prefix' parameter for anything
                    else on other templates.
                -->
                <xsl:apply-templates>
                    <xsl:with-param name="prefix">
                        <xsl:number level="multiple" format="1"/>
                    </xsl:with-param>
                </xsl:apply-templates>
            </fo:flow>

        </fo:page-sequence>
    </xsl:template>

    <!-- Bestiary stuff -->

    <xsl:template name="bestiary-masterpages">
        <fo:layout-master-set>

            <!-- Right master page -->
            <fo:simple-page-master master-name="rightPage"
                page-height="297mm"
                page-width="210mm"
                margin-top="10mm"
                margin-bottom="5mm"
                margin-left="25mm"
                margin-right="10mm">

                <fo:region-before extent="15mm"
                    region-name="region-before-right"/>
                <fo:region-after extent="10mm"
                    region-name="region-after-right"/>
                <fo:region-start extent="10mm"/>
                <fo:region-end extent="20mm"/>
                <fo:region-body
                    column-count="1"
                    margin-top="11mm"
                    margin-bottom="11mm" />
            </fo:simple-page-master>


            <!-- Sequence for the whole document -->
            <fo:page-sequence-master master-name="bestiary-document">
                <fo:repeatable-page-master-alternatives>
                    <fo:conditional-page-master-reference
                        master-reference="rightPage" odd-or-even="even"/>
                    <fo:conditional-page-master-reference
                        master-reference="rightPage" odd-or-even="odd"/>
                </fo:repeatable-page-master-alternatives>
            </fo:page-sequence-master>

        </fo:layout-master-set>
    </xsl:template>

    <xsl:template name="bestiary-document">
        <fo:page-sequence master-reference="bestiary-document">
            <fo:static-content flow-name="region-before-right">
                <fo:block font-family="Helvetica" font-size="24pt"
                    text-align="end"
                    font-weight="bold"
                    color="white"
                    background-color="{$colour}">
                    <xsl:value-of select="@name"/>
                </fo:block>
            </fo:static-content>

            <fo:static-content flow-name="region-after-right">
                <fo:block font-family="{$font-body}" font-size="12pt"
                    text-align="end"
                    font-weight="bold"
                    font-style="italic"
                    border-before-width="2px"
                    border-before-color="black"
                    border-before-style="solid">
                    <xsl:call-template name="copyright-and-version"/>
                </fo:block>
            </fo:static-content>

            <fo:flow flow-name="xsl-region-body" text-align="justify">
                <xsl:apply-templates select="." mode="fullpage"/>
            </fo:flow>

        </fo:page-sequence>
    </xsl:template>


</xsl:stylesheet>
