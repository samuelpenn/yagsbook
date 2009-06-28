<?xml version="1.0" ?>

<xsl:transform
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        version="1.0"
        >


    <!--
        table

        A table consisting of rows and items.
     -->
    <xsl:template match="table">
        <table style="border: black solid 1pt">
            <xsl:apply-templates select="header"/>
            <xsl:apply-templates select="body"/>
        </table>
    </xsl:template>

    <xsl:template match="table/header">
        <tr style="color: white; background-color: black">
            <xsl:apply-templates select="heading"/>
        </tr>
    </xsl:template>

    <xsl:template match="table/header/heading">
        <xsl:choose>
            <xsl:when test="@colspan">
                <th align="center" colspan="{@colspan}"><xsl:value-of select="."/></th>
            </xsl:when>
            <xsl:otherwise>
                <th align="left"><xsl:value-of select="."/></th>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="table/body">
        <xsl:apply-templates select="row"/>
    </xsl:template>

    <xsl:template match="table/body/row">
        <xsl:variable name="colour">
            <xsl:choose>
                <xsl:when test="position() mod 2 = 0">#aaaaaa</xsl:when>
                <xsl:otherwise>white</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tr style="background-color: {$colour}">
            <xsl:apply-templates/>
        </tr>
    </xsl:template>

    <xsl:template match="table/body/row/item">
        <td style="text-align: left; vertical-align: top; border: black solid 1pt">
            <xsl:apply-templates/>
        </td>
    </xsl:template>

    <xsl:template match="table/body/row/number">
        <td style="text-align: right; vertical-align: top; border: black solid 1pt">
            <xsl:apply-templates/>
        </td>
    </xsl:template>

    <xsl:template match="table/body/row/value">
        <td style="text-align: center; vertical-align: top; border: black solid 1pt">
            <xsl:apply-templates/>
        </td>
    </xsl:template>
</xsl:transform>
