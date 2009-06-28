<?xml version="1.0"?>

<!--
    Stylesheet transform for Yagsbook to HTML or PDF.

    Lists properties of various equipment types.

    Author:  Samuel Penn
    Version: $Revision: 1.9 $
    Date:    $Date: 2007/06/03 18:46:33 $
-->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:yb="http://yagsbook.sourceforge.net/xml"
    xmlns:y="http://yagsbook.sourceforge.net/xml/yags"
    xmlns:fo="http://www.w3.org/1999/XSL/Format">

    <!--
        Special properties for armour.
    -->
    <xsl:template match="y:armour/y:properties">
        <xsl:if test="y:restrictive/@score">
            Re-<xsl:value-of select="y:restrictive/@score"/>
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:if test="y:noisy/@score">
            No-<xsl:value-of select="y:noisy/@score"/>
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:if test="y:vitals/@score">
            Vi-<xsl:value-of select="y:vitals/@score"/>
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:if test="y:light">Li </xsl:if>
        <xsl:if test="y:heavy">Hv </xsl:if>
        <xsl:if test="y:mail">Ma </xsl:if>
        <xsl:if test="y:soft">So </xsl:if>
        <xsl:if test="y:warm">Wa </xsl:if>
        <xsl:if test="y:bulletproof">BP </xsl:if>
        <xsl:if test="y:nbc">NBC </xsl:if>
        <xsl:if test="y:vacuum">Va </xsl:if>
        <xsl:if test="y:reflective">Rf </xsl:if>
        <xsl:if test="y:vehicle">Vc </xsl:if>
    </xsl:template>

    <!--
        Lists body parts covered by armour.
    -->
    <xsl:template match="y:armour/y:covers">
        <xsl:if test="y:head">head </xsl:if>
        <xsl:if test="y:skull">skull </xsl:if>
        <xsl:if test="y:eyes">eyes </xsl:if>
        <xsl:if test="y:face">face </xsl:if>

        <xsl:if test="y:body">body </xsl:if>
        <xsl:if test="y:neck">neck </xsl:if>
        <xsl:if test="y:torso">torso </xsl:if>
        <xsl:if test="y:groin">groin </xsl:if>
        <xsl:if test="y:front">front </xsl:if>
        <xsl:if test="y:back">back </xsl:if>

        <xsl:if test="y:arms">arms </xsl:if>
        <xsl:if test="y:hands">hands </xsl:if>

        <xsl:if test="y:legs">legs </xsl:if>
        <xsl:if test="y:thighs">thighs </xsl:if>
        <xsl:if test="y:shins">shins </xsl:if>
        <xsl:if test="y:feet">feet </xsl:if>
    </xsl:template>

    <!--
        Lists weapon properties.
    -->
    <xsl:template match="y:weapon/y:properties">
        <xsl:if test="y:twohanded">2H </xsl:if>
        <xsl:if test="y:heavy">Hv </xsl:if>
        <xsl:if test="y:light">Li </xsl:if>
        <xsl:if test="y:impaling">Im </xsl:if>
        <xsl:if test="y:weak">Wk </xsl:if>
        <xsl:if test="y:strong">St </xsl:if>
        <xsl:if test="y:throwable">Th </xsl:if>
        <xsl:if test="y:crushing">Cr </xsl:if>
        <xsl:if test="y:blocking">Bk </xsl:if>
        <xsl:if test="y:thrusting">Ts </xsl:if>
        <xsl:if test="y:defensive">De </xsl:if>
        <xsl:if test="y:firearm">Fi </xsl:if>
        <xsl:if test="y:automatic">
            <xsl:choose>
                <xsl:when test="y:automatic/@score">
                    <xsl:text>Au-</xsl:text>
                    <xsl:value-of select="y:automatic/@score"/>
                    <xsl:text> </xsl:text>
                </xsl:when>
                <xsl:otherwise>Au </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="y:semiauto">SA </xsl:if>
        <xsl:if test="y:tripleauto">TA </xsl:if>
        <xsl:if test="y:armourpiercing">AP </xsl:if>
        <xsl:if test="y:laser">Ls </xsl:if>
        <xsl:if test="y:plasma">Pl </xsl:if>
        <xsl:if test="y:sonic">So </xsl:if>
        <xsl:if test="y:reload/@score">
            Lo-<xsl:value-of select="y:reload/@score"/>
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:if test="y:unreliable/@score">
            Un-<xsl:value-of select="y:unreliable/@score"/>
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:if test="y:explosive">
            Ex-<xsl:value-of select="y:explosive/@score"/>
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:if test="y:vehicle">Vc </xsl:if>
        <xsl:if test="y:guided">
            <xsl:text>Gu</xsl:text>
            <xsl:variable name="skill">
                <xsl:choose>
                    <xsl:when test="y:guided/@skill">
                        <xsl:value-of select="y:guided/@skill"/>
                    </xsl:when>
                    <xsl:otherwise>0</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="y:guided/@type='homing'">(H/<xsl:value-of select="$skill"/>) </xsl:when>
                <xsl:when test="y:guided/@type='smart'">(S/<xsl:value-of select="$skill"/>) </xsl:when>
                <xsl:when test="y:guided/@type='brilliant'">(B/<xsl:value-of select="$skill"/>) </xsl:when>
                <xsl:when test="y:guided/@type='clever'">(C/<xsl:value-of select="$skill"/>) </xsl:when>
                <xsl:when test="y:guided/@type='genius'">(G/<xsl:value-of select="$skill"/>) </xsl:when>
                <xsl:otherwise> </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="y:cone">
            Co-<xsl:value-of select="y:cone/@score"/>
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>

    <!--
        Display weapon ranges in most suitable units.
    -->
    <xsl:template match="y:range/*">
        <xsl:variable name="distance" select="."/>

        <xsl:choose>
            <xsl:when test="$distance &gt; 2000000000">
                <xsl:value-of select="$distance div 1000000"/>Mkm
            </xsl:when>
            <xsl:when test="$distance &gt; 10000">
                <xsl:value-of select="format-number($distance div 1000, '###,###,###')"/>km
            </xsl:when>
            <xsl:when test="$distance &gt; 2000">
                <xsl:value-of select="format-number($distance div 1000, '#,###.#')"/>km
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="format-number($distance, '#,###')"/>m
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
