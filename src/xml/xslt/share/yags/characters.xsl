<?xml version="1.0"?>

<!--
    Stylesheet transform for Yagsbook to HTML or PDF.

    Handles the calculation of combat statistics for characters
    and beasts. Output neutral, so should only return data back
    to callers rather than writing data to output.

    Author:  Samuel Penn
    Version: $Revision: 1.5 $
    Date:    $Date: 2007/09/09 10:32:55 $
-->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:y="http://yagsbook.sourceforge.net/xml/yags"
    xmlns:yb="http://yagsbook.sourceforge.net/xml"
    xmlns:fo="http://www.w3.org/1999/XSL/Format">

    <xsl:template name="y:statistics-sum">
        <xsl:variable name="skill">
            <xsl:call-template name="y:sum-skill-points">
                <xsl:with-param name="i" select="1"/>
                <xsl:with-param name="total" select="-44"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="advantages">
            <xsl:call-template name="y:sum-advantage-points">
                <xsl:with-param name="i" select="1"/>
                <xsl:with-param name="total" select="0"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="age">
            <xsl:choose>
                <xsl:when test="yb:description/yb:age">
                    <xsl:value-of select="yb:description/yb:age"/>
                </xsl:when>
                <xsl:otherwise>16</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:value-of select="$skill + $advantages"/>
    </xsl:template>

    <xsl:template name="y:sum-skill-points">
        <xsl:param name="i" select="1"/>
        <xsl:param name="j" select="1"/>
        <xsl:param name="total" select="0"/>

        <xsl:if test="y:statistics/y:skills/y:group[$j]/y:skill[$i]">
	    <xsl:choose>
		<xsl:when test="y:statistics/y:skills/y:group[$j]/y:skill[$i]/@cost">
		    <xsl:variable name="cost" select="y:statistics/y:skills/y:group[$j]/y:skill[$i]/@cost"/>
		    <xsl:call-template name="y:sum-skill-points">
			<xsl:with-param name="i" select="$i + 1"/>
			<xsl:with-param name="j" select="$j"/>
			<xsl:with-param name="total" select="$total + $cost"/>
		    </xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
		    <xsl:variable name="score"
			 select="y:statistics/y:skills/y:group[$j]/y:skill[$i]/@score"/>
		    <xsl:variable name="cost" select="(($score * ($score + 1)) div 2)"/>

		    <xsl:call-template name="y:sum-skill-points">
			<xsl:with-param name="i" select="$i + 1"/>
			<xsl:with-param name="j" select="$j"/>
			<xsl:with-param name="total" select="$total + $cost"/>
		    </xsl:call-template>
		</xsl:otherwise>
	    </xsl:choose>
        </xsl:if>

        <xsl:if test="not(y:statistics/y:skills/y:group[$j]/y:skill[$i])">
            <xsl:if test="y:statistics/y:skills/y:group[$j + 1]">
                <xsl:call-template name="y:sum-skill-points">
                    <xsl:with-param name="i" select="1"/>
                    <xsl:with-param name="j" select="$j + 1"/>
                    <xsl:with-param name="total" select="$total"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="not(y:statistics/y:skills/y:group[$j + 1])">
                <xsl:value-of select="$total"/>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name="y:sum-advantage-points">
        <xsl:param name="i" select="1"/>
        <xsl:param name="total" select="0"/>

        <xsl:if test="y:statistics/y:advantages/y:advantage[$i]">
            <xsl:variable name="cost">
                <xsl:choose>
		    <xsl:when test="not(y:statistics/y:advantages/y:advantage[$i]/@skill)">0</xsl:when>
                    <xsl:when test="y:statistics/y:advantages/y:advantage[$i]/@cost">
                        <xsl:value-of
                            select="y:statistics/y:advantages/y:advantage[$i]/@cost"/>
                    </xsl:when>
                    <xsl:otherwise>0</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:call-template name="y:sum-advantage-points">
                <xsl:with-param name="i" select="$i + 1"/>
                <xsl:with-param name="total" select="$total + $cost"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="not(y:statistics/y:advantages/y:advantage[$i])">
            <xsl:value-of select="$total"/>
        </xsl:if>
    </xsl:template>


</xsl:stylesheet>
