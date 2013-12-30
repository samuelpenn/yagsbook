<?xml version="1.0"?>

<xsl:transform
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        version="1.0"
        >
    <xsl:include href="links.xsl"/>
    <xsl:include href="sidebar.xsl"/>
    <xsl:include href="body.xsl"/>

    <xsl:include href="yagsbook.xsl"/>
    <xsl:include href="encyclopedia.xsl"/>
    <xsl:include href="xml.xsl"/>
    <xsl:include href="script.xsl"/>
    <xsl:include href="tables.xsl"/>

    <!-- Reference Yagsbook stylesheets -->
    <xsl:include href="/usr/share/xml/yagsbook/article/xslt/html/globals.xsl"/>
    <xsl:include href="/usr/share/xml/yagsbook/article/xslt/html/para.xsl"/>
    <xsl:include href="/usr/share/xml/yagsbook/article/xslt/html/bestiary.xsl"/>
    <xsl:include href="/usr/share/xml/yagsbook/article/xslt/html/characters.xsl"/>
    <xsl:include href="/usr/share/xml/yagsbook/article/xslt/html/vehicles.xsl"/>
    <xsl:include href="/usr/share/xml/yagsbook/article/xslt/html/equipment.xsl"/>
    <xsl:include href="/usr/share/xml/yagsbook/article/xslt/html/yags/yags.xsl"/>
    <xsl:output method="xml"
                doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
                doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
                encoding="iso-8859-1"
    />

    <xsl:param name="stylesheet1Url" select="''"/>
    <xsl:param name="stylesheet1Name" select="'Alternative 1'"/>
    <xsl:param name="stylesheet2Url" select="''"/>
    <xsl:param name="stylesheet2Name" select="'Alternative 2'"/>
    <xsl:param name="stylesheet3Url" select="''"/>
    <xsl:param name="stylesheet3Name" select="'Alternative 3'"/>

    <xsl:template match="/page">
        <html lang="en" xml:lang="en">
            <head>
                <xsl:apply-templates select="header"/>
            </head>
<xsl:text>
</xsl:text>

            <body>
                <div class="header">
                    <h1><xsl:value-of select="header/title"/></h1>
                </div>

                <xsl:apply-templates select="links"/>
<xsl:text>
</xsl:text>

                <div class="sidebars">
                    <xsl:if test="/page/header/license">
                        <xsl:call-template name="sidebar-license"/>
                    </xsl:if>
                    <!-- <xsl:call-template name="sidebarlinks"/> -->
                    <xsl:apply-templates select="/page/sidebar"/>
                    <!-- <xsl:call-template name="sidebarcontents"/> -->
                </div>

                <xsl:apply-templates select="body"/>

                <xsl:if test="header/footer/@href">
                    <xsl:apply-templates select="document(header/footer/@href)/footer"/>
                </xsl:if>

                <xsl:if test="header/footer/@counter">

                </xsl:if>
                <!-- <xsl:apply-templates select="menus"/> -->
            </body>
        </html>
    </xsl:template>

    <!--
        /page/header

        Process the header information for the page, including any
        meta data - see http://dublincore.org/documents/dcq-html for
        some details on meta tags used.
    -->
    <xsl:template match="/page/header">
        <title><xsl:value-of select="title"/></title>
<xsl:text>
</xsl:text>

        <meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
<xsl:text>
</xsl:text>

        <xsl:if test="author">
            <meta name="DC.creator" content="{author/fullname}"/>
<xsl:text>
</xsl:text>
        </xsl:if>

        <xsl:if test="summary">
            <meta name="DCTERMS.abstract" content="{normalize-space(summary)}"/>
<xsl:text>
</xsl:text>
        </xsl:if>

        <xsl:if test="cvsinfo/date">
            <xsl:variable name="date">
                <xsl:value-of select="substring(cvsinfo/date, 8, 19)"/>
            </xsl:variable>

            <meta name="DCTERMS.modified" content="{$date}"/>
<xsl:text>
</xsl:text>
        </xsl:if>

        <link rel="stylesheet" type="text/css"
              href="/usr/share/css/default.css"
              title="Default" />
<xsl:text>
</xsl:text>

        <xsl:if test="not($stylesheet1Url = '')">
            <link rel="alternative" type="text/css"
                  href="/usr/share/css/{$stylesheet1Url}"
                  title="{$stylesheet1Name}"/>
            <xsl:text>
            </xsl:text>
        </xsl:if>
        <xsl:if test="not($stylesheet2Url = '')">
            <link rel="alternative" type="text/css"
                  href="/usr/share/css/{$stylesheet2Url}"
                  title="{$stylesheet2Name}"/>
            <xsl:text>
            </xsl:text>
        </xsl:if>
        <xsl:if test="not($stylesheet3Url = '')">
            <link rel="alternative" type="text/css"
                  href="/usr/share/css/{$stylesheet3Url}"
                  title="{$stylesheet3Name}"/>
            <xsl:text>
            </xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="footer">
        <xsl:apply-templates/>
    </xsl:template>

    <!--
        menus

        Zero or more menus may be defined, each with an @role attribute.
        An image is located of name menu-{@role}.png and placed in the
        menu location.
     -->
    <xsl:template match="menus">
        <xsl:call-template name="menu"/>
    </xsl:template>

    <xsl:template name="menu">
        <xsl:param name="idx" select="1"/>
        <xsl:variable name="count" select="count(/page/menus/menu)"/>

        <xsl:if test="not($idx &gt; $count)">
            <xsl:variable name="role" select="/page/menus/menu[$idx]/@role"/>
            <xsl:variable name="pos" select="($idx * 40) - 30"/>

            <img id="icon-{$role}" src="/images/menu-{$role}.png"
                 width="32" height="32" alt="{$role}"
                 style="position: fixed; top: 5px; right: {$pos}px;"
                 onmouseover="showMenu('{$role}')"
                 onmouseoff="hideMenu('{$role}')"
                 />

            <xsl:call-template name="menu">
                <xsl:with-param name="idx" select="$idx + 1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template match="license">
        <p>
            Copyright <xsl:value-of select="year"/>,
            <xsl:value-of select="holder"/>.
        </p>

        <xsl:choose>
            <xsl:when test="@type='PD'">
                <p>
                    This document may be re-distributed, modified and
                    published without any restrictions.
                </p>

                <a href="http://www.glendale.org.uk/pd.txt">
                    <img src="/images/button-pd.png" width="80" height="15"
                        alt="Public Domain"/>
                </a>
            </xsl:when>

            <xsl:when test="@type='BSD'">
                <p>
                    Redistribution and use in source, binary and printed
                    forms with or without modification is permitted. See
                    the full license text for details.
                </p>

                <a href="http://www.glendale.org.uk/bsd.txt">
                    <img src="/images/button-bsd.png" width="80" height="15"
                        alt="BSD style license"/>
                </a>
            </xsl:when>

            <xsl:when test="@type='GPL'">
                <p>
                    This document can be redistributed and/or modified
                    under the terms of the GNU Public License as published
                    by the Free Software Foundation, version 2 or any
                    later version.
                </p>

                <a href="http://www.glendale.org.uk/gpl.txt">
                    <img src="/images/button-gpl.png" width="80" height="15"
                         alt="GNU Public License"/>
                </a>
            </xsl:when>

            <xsl:when test="@type='GPL2'">
                <p>
                    This document can be redistributed and/or modified
                    under the terms of the GNU Public License as published
                    by the Free Software Foundation version 2.
                </p>

                <a href="http://www.glendale.org.uk/gpl.txt">
                    <img src="/images/button-gpl.png" width="80" height="15"
                         alt="GNU Public License"/>
                </a>
            </xsl:when>

            <xsl:when test="@type='FDL1.1'">
                <p>
                    Permission is granted to copy, distribute and/or
                    modify this document under the terms of the GNU
                    Free Documentation License, Version 1.1; with no
                    invariant sections, no Front-Cover Texts, and with
                    no Back-Cover Texts.
                </p>

                <a href="http://www.glendale.org.uk/fdl.txt">
                    <img src="/images/button-fdl.png" width="80" height="15"
                         alt="GNU FDL"/>
                </a>
            </xsl:when>

            <xsl:when test="@type='Yags'">
                <p>
                    This document can be redistributed and/or modified
                    under the terms of the GNU Public License as published
                    by the Free Software Foundation version 2.
                </p>

                <a href="http://www.glendale.org.uk/gpl.txt">
                    <img src="/images/button-gpl.png" width="80" height="15"
                         alt="GNU Public License"/>
                </a>
            </xsl:when>

            <xsl:otherwise>
                <p>
                    <xsl:value-of select="text"/>
                </p>

                <xsl:if test="url">
                    <p>
                        <a href="{@url}">License</a>.
                    </p>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:transform>
