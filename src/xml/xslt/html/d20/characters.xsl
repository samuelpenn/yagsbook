<?xml version="1.0"?>

<!--
    Stylesheet transform for Yagsbook to HTML.

    These templates support ArsMagica specific character information.

    Author:  Samuel Penn
    Version: $Revision: 1.1 $
    Date:    $Date: 2005/01/16 13:01:15 $
-->


<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://yagsbook.sourceforge.net/xml/d20"
    version="1.0">
    

    <!--
        Simple statistics shows all the basic character abilities,
        but does not work out combat statistics and the like.
    -->
    <xsl:template match="d:statistics">
        <xsl:apply-templates select="d:classes"/>
        <xsl:apply-templates select="d:attributes"/>
    </xsl:template>

    <xsl:template match="d:classes">
        <p>
            Level <xsl:value-of select="@level"/>
            (
                <xsl:for-each select="d:class">
                    <xsl:value-of select="@name"/>-<xsl:value-of select="@level"/>
                </xsl:for-each>
            )
        </p>
    </xsl:template>
    
    <!--
        attributes
        
        Display the character's attributes.
    -->
    <xsl:template match="d:attributes">
        <table class="attributes">
            <tr>
                <th>Str</th>
                <th>Con</th>
                <th>Dex</th>
                <th>Int</th>
                <th>Wis</th>
                <th>Cha</th>
            </tr>

            <tr>
                <xsl:apply-templates select="d:attribute[@name='strength']"/>
                <xsl:apply-templates select="d:attribute[@name='constitution']"/>
                <xsl:apply-templates select="d:attribute[@name='dexterity']"/>
                <xsl:apply-templates select="d:attribute[@name='intelligence']"/>
                <xsl:apply-templates select="d:attribute[@name='wisdom']"/>
                <xsl:apply-templates select="d:attribute[@name='charisma']"/>
            </tr>
            
       </table>
    </xsl:template>

    <!--
        attribute
        
        Display the value for a single attribute. Take into account special
        rules for strength and intelligence.
     -->
    <xsl:template match="d:attribute">
        <td>
            <xsl:value-of select="@score"/>
        </td>
    </xsl:template>
</xsl:stylesheet>
