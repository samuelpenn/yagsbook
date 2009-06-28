<?xml version="1.0" ?>

<!--
    Revision: $Revision: 1.15 $
    Date:     $Date: 2007/09/11 19:37:39 $
 -->

<xsl:transform
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        version="1.0"
        >

    <xsl:template match="/page/body">
        <xsl:apply-templates select="sect1"/>
    </xsl:template>

    <xsl:template match="sect1">
        <xsl:choose>
            <!--
                Support for style hints in a top-level sect1 element.
                Lower level elements cannot have style hints.
            -->
            <xsl:when test="@style">
                <div class="sect1" style="{@style}">
                    <xsl:if test="title">
                        <h1><xsl:value-of select="title"/></h1>
                    </xsl:if>

                    <div class="content">
                        <xsl:apply-templates/>
                    </div>
                </div>

            </xsl:when>

            <xsl:otherwise>
                <div class="sect1">
                    <xsl:if test="title">
                        <h1><xsl:value-of select="title"/></h1>
                    </xsl:if>

                    <div class="content">
                        <xsl:apply-templates/>
                    </div>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="sect2">
        <div class="sect2">
            <xsl:if test="title">
                <h2><xsl:value-of select="title"/></h2>
            </xsl:if>

            <div class="content">
                <xsl:apply-templates/>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="sect3">
        <div class="sect3">
            <xsl:if test="title">
                <h3><xsl:value-of select="title"/></h3>
            </xsl:if>

            <div class="content">
                <xsl:apply-templates/>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="sect4">
        <div class="sect4">
            <xsl:if test="title">
                <h4><xsl:value-of select="title"/></h4>
            </xsl:if>

            <div class="content">
                <xsl:apply-templates/>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="sect5">
        <div class="sect5">
            <xsl:if test="title">
                <h5><xsl:value-of select="title"/></h5>
            </xsl:if>

            <div class="content">
                <xsl:apply-templates/>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="sect1/title"/>
    <xsl:template match="sect2/title"/>
    <xsl:template match="sect3/title"/>
    <xsl:template match="sect4/title"/>
    <xsl:template match="sect5/title"/>

    <xsl:template match="p">
        <xsl:choose>
            <xsl:when test="@class">
                <p class="{@class}">
                    <xsl:apply-templates/>
                </p>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    <xsl:apply-templates/>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="p/s">
        <strong><xsl:apply-templates/></strong>
    </xsl:template>

    <xsl:template match="p/e">
        <em><xsl:apply-templates/></em>
    </xsl:template>

    <xsl:template match="p/link">
        <xsl:variable name="url">
            <xsl:choose>
                <xsl:when test="@href">
                    <xsl:value-of select="@href"/>
                </xsl:when>
                <xsl:when test="@uri">
                    <xsl:value-of select="@uri"/>.html
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <a href="{$url}">
            <xsl:choose>
                <xsl:when test="@name">
                    <xsl:value-of select="@name"/>
                </xsl:when>
                <xsl:when test="@icon">
                    <img src="{@icon}" width="{@width}" height="{@height}"
                            alt="{@alt}"/>
                </xsl:when>
            </xsl:choose>
        </a>
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="link">
        <xsl:variable name="url">
            <xsl:choose>
                <xsl:when test="@href"><xsl:value-of select="@href"/></xsl:when>
                <xsl:when test="@uri"><xsl:value-of select="@uri"/>.html</xsl:when>
            </xsl:choose>
        </xsl:variable>

        <p>
            <a href="{$url}">
                <xsl:choose>
                    <xsl:when test="@name">
                        <xsl:value-of select="@name"/>
                    </xsl:when>
                    <xsl:when test="@icon and @inline='true'">
                        <img src="{@icon}" width="{@width}" height="{@height}"
                             alt="{@alt}" align="left" />
                    </xsl:when>
                    <xsl:when test="@icon">
                        <img src="{@icon}" width="{@width}" height="{@height}"
                             alt="{@alt}" />
                    </xsl:when>
                </xsl:choose>
            </a>
            <xsl:value-of select="."/>
        </p>
    </xsl:template>

    <xsl:template match="image">
        <xsl:choose>
            <xsl:when test="@style">
                <img src="{@href}" width="{@width}" height="{@height}"
                    alt="{@alt}" style="{@style}"/>
            </xsl:when>

            <xsl:when test="@inline='false'">
                <img src="{@href}" width="{@width}" height="{@height}"
                    alt="{@alt}"/>
            </xsl:when>

            <xsl:when test="@align">
                <img src="{@href}" width="{@width}" height="{@height}"
                     align="{@align}" alt="{@alt}"/>
            </xsl:when>

            <xsl:when test="@max">
                <img src="{@href}" width="{@width}" height="{@height}"
                    alt="{@alt}" class="inline" style="max-width: {@max}px"/>
            </xsl:when>

            <xsl:otherwise>
                <img src="{@href}" width="{@width}" height="{@height}"
                    alt="{@alt}" class="inline"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="p/svg">
        <xsl:variable name="src" select="@src"/>
        <xsl:variable name="width" select="@width"/>
        <xsl:variable name="height" select="@height"/>
        <xsl:variable name="name" select="@name"/>

        <object data="{$src}" type="image/svg+xml" name="{$name}"
                width="{$width}" height="{$height}">
            This is an SVG image. If you can see this text, then
            you need to upgrade your browser or get a plugin.
        </object>
    </xsl:template>

    <xsl:template match="svg">
        <xsl:variable name="src" select="@src"/>
        <xsl:variable name="width" select="@width"/>
        <xsl:variable name="height" select="@height"/>
        <xsl:variable name="name" select="@name"/>

        <p>
            <object data="{$src}" type="image/svg+xml" name="{$name}"
                    width="{$width}" height="{$height}">
                This is an SVG image. If you can see this text, then
                you need to upgrade your browser or get a plugin.
            </object>
        </p>
    </xsl:template>

    <xsl:template match="applet">
        <xsl:variable name="code" select="@code"/>
        <xsl:variable name="codebase" select="@codebase"/>
        <xsl:variable name="width" select="@width"/>
        <xsl:variable name="height" select="@height"/>

        <applet code="{$code}" codebase="{$codebase}"
                height="{$height}" width="{$width}">
		</applet>
    </xsl:template>

    <xsl:template match="termlist">
        <xsl:apply-templates select="item"/>
    </xsl:template>

    <xsl:template match="termlist/item">
        <p class="termlist">
            <strong><xsl:value-of select="@term"/>:</strong>
            <xsl:apply-templates/>
        </p>
    </xsl:template>


    <!--
        itemlist

        An <itemlist> is a generic list of items. How the list is displayed
        depends on the @order attribute.
     -->
    <xsl:template match="itemlist">
        <xsl:variable name="order" select="@order"/>

        <xsl:choose>
            <xsl:when test="$order = 'strict'">
                <dl>
                    <xsl:apply-templates select="item" mode="strict"/>
                </dl>
            </xsl:when>

            <xsl:when test="$order = 'sort'">
                <dl>
                    <xsl:apply-templates select="item" mode="strict">
                        <xsl:sort select="@name" data-type="text"/>
                    </xsl:apply-templates>
                </dl>
            </xsl:when>

            <xsl:when test="$order = 'unordered'">
                <ul>
                    <xsl:apply-templates select="item" mode="ordered"/>
                </ul>
            </xsl:when>

            <xsl:when test="$order = '1'">
                <ol type="1">
                    <xsl:apply-templates select="item" mode="ordered"/>
                </ol>
            </xsl:when>

            <xsl:when test="$order = 'i'">
                <ol type="i">
                    <xsl:apply-templates select="item" mode="ordered"/>
                </ol>
            </xsl:when>

            <xsl:when test="$order = 'I'">
                <ol type="I">
                    <xsl:apply-templates select="item" mode="ordered"/>
                </ol>
            </xsl:when>

            <xsl:when test="$order = 'a'">
                <ol type="a">
                    <xsl:apply-templates select="item" mode="ordered"/>
                </ol>
            </xsl:when>

            <xsl:otherwise>
                <p>Illegal list</p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="itemlist/item" mode="strict">
        <dt><xsl:value-of select="@name"/></dt>
        <dd><xsl:apply-templates/></dd>
    </xsl:template>


    <xsl:template match="itemlist/item" mode="ordered">
        <li>
            <xsl:if test="@name">
                <em><xsl:value-of select="@name"/>:</em>
            </xsl:if>
            <xsl:apply-templates/>
        </li>
    </xsl:template>

</xsl:transform>
