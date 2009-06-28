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
    xmlns:a="http://yagsbook.sourceforge.net/xml/arsmagica"
    version="1.0">
    

    <!--
        Simple statistics shows all the basic character abilities,
        but does not work out combat statistics and the like.
    -->
    <xsl:template match="a:statistics">
        <xsl:apply-templates select="a:attributes"/>
        <xsl:apply-templates select="a:abilities"/>
        <xsl:apply-templates select="a:virtues"/>
    </xsl:template>

    
    <!--
        attributes
        
        Display the character's attributes.
    -->
    <xsl:template match="a:attributes">
        <table class="attributes">
            <tr>
                <th>Size</th>
                <th>Int</th>
                <th>Per</th>
                <th>Str</th>
                <th>Sta</th>
                <th>Pre</th>
                <th>Com</th>
                <th>Dex</th>
                <th>Qui</th>
            </tr>

            <tr>
                <td><xsl:value-of select="@size"/></td>

                <xsl:apply-templates select="a:attribute[@name='intelligence']"/>
                <xsl:apply-templates select="a:attribute[@name='perception']"/>
                
                <xsl:apply-templates select="a:attribute[@name='strength']"/>
                <xsl:apply-templates select="a:attribute[@name='stamina']"/>
                
                <xsl:apply-templates select="a:attribute[@name='presence']"/>
                <xsl:apply-templates select="a:attribute[@name='communication']"/>
                
                <xsl:apply-templates select="a:attribute[@name='dexterity']"/>
                <xsl:apply-templates select="a:attribute[@name='quickness']"/>
            </tr>
            
       </table>
    </xsl:template>

    <!--
        attribute
        
        Display the value for a single attribute. Take into account special
        rules for strength and intelligence.
     -->
    <xsl:template match="a:attribute">
        <td>
            <xsl:value-of select="@score"/>
        </td>
    </xsl:template>
    
    

    <xsl:template match="a:abilities">
        <h5>Skills</h5>
        <xsl:apply-templates select="a:group"/>
    </xsl:template>
    
    <xsl:template match="a:abilities/a:group">
        <p>
            <b><i><xsl:value-of select="@name"/>: </i></b>
            <xsl:apply-templates select="a:ability">
                <xsl:sort select="@name" data-type="text"/>
            </xsl:apply-templates>
        </p>
    </xsl:template>
    
    <xsl:template match="a:abilities/a:group/a:ability">
        <xsl:if test="@score &gt; 0">
            <xsl:value-of select="@name"/>
            <xsl:if test="a:speciality">
                (<xsl:value-of select="a:speciality"/>)
            </xsl:if>
            <xsl:text>-</xsl:text>
            <xsl:value-of select="@score"/>;
        </xsl:if>
    </xsl:template>

    <xsl:template match="a:virtues">
        <h5>Virtues</h5>
        <p>
            <xsl:apply-templates select="a:virtue"/>
        </p>
    </xsl:template>
    
    <xsl:template match="a:virtue">
        <xsl:variable name="string" select="@name"/>
        
        <xsl:value-of select="$string"/>
    </xsl:template>


</xsl:stylesheet>
