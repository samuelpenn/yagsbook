<?xml version="1.0" ?>

<!--
    Revision: $Revision: 1.5 $
    Date:     $Date: 2005/08/13 14:47:16 $
 -->

<xsl:transform
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        version="1.0"
        >

    <xsl:template name="sidebar-license">
        <div class="sidebar">
            <div class="title">
                <h6>Copyright</h6>
            </div>

            <div class="column">
                <xsl:apply-templates select="/page/header/license"/>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="/page/sidebar">
        <xsl:variable name="pos" select="position()"/>

        <!--
        <div class="sidebar" id="sb-{$pos}"
             onmouseover="showSidebar('sb-{$pos}')"
             onmouseout="hideSidebar('sb-{$pos}')">
            <h6><xsl:value-of select="title"/></h6>

            <xsl:apply-templates/>
        </div>
        -->
        <div class="sidebar">
            <div class="title">
                <h6><xsl:value-of select="title"/></h6>
            </div>

            <div class="column">
                <xsl:apply-templates/>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="sidebar/title"/>

    <xsl:template match="/page/sidebar/p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="/page/sidebar" mode="links">
        <a href="#" onmouseover="" onmouseoff=""><xsl:value-of select="title"/></a>
    </xsl:template>

    <xsl:template name="sidebarlinks">
        <xsl:param name="idx" select="1"/>

        <xsl:if test="not($idx &gt; count(/page/sidebar))">
            <a href="#" onmouseover="showSidebar('sb-{$idx}')"
                        onmouseout="hideSidebar('sb-{$idx}')">
                <xsl:value-of select="/page/sidebar[$idx]/title"/>
            </a>

            <xsl:call-template name="sidebarlinks">
                <xsl:with-param name="idx" select="$idx + 1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="sidebarcontents">
        <xsl:param name="idx" select="1"/>

        <xsl:if test="not($idx &gt; count(/page/sidebar))">
            <xsl:apply-templates select="/page/sidebar[$idx]"/>

            <xsl:call-template name="sidebarcontents">
                <xsl:with-param name="idx" select="$idx + 1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>


</xsl:transform>
