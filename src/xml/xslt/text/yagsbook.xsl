<?xml version="1.0"?>

<!--
    Stylesheet transform for Yagsbook to plain text.

    This is the top level stylesheet, which includes all the other
    stylesheet files, and handles the header and top level body
    parts of the document.

    All global variables should also be defined in this file.

    Author:  Samuel Penn
    Version: $Revision: 1.1.1.1 $
    Date:    $Date: 2004/05/13 20:35:28 $
-->

<xsl:transform
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 version="1.0"
>

<!-- Generic elements (mostly DocBook compatible) -->
<!--
<xsl:include href="contents.xsl"/>
<xsl:include href="header.xsl"/>
<xsl:include href="headings.xsl"/>
<xsl:include href="tables.xsl"/>
<xsl:include href="variablelist.xsl"/>
<xsl:include href="para.xsl"/>
-->
<!-- Gaming specific elements -->
<!--
<xsl:include href="advantages.xsl"/>
<xsl:include href="bestiary.xsl"/>
<xsl:include href="characters.xsl"/>
<xsl:include href="equipment.xsl"/>
<xsl:include href="invocations.xsl"/>
<xsl:include href="library.xsl"/>
<xsl:include href="skills.xsl"/>
<xsl:include href="spells.xsl"/>
-->
<!-- Rendition neutral elements -->
<!-- 
<xsl:include href="../share/combat.xsl"/>
-->

<!-- Set variable for the syle of the article -->


    <xsl:template match="/">
        <xsl:value-of select="/article/header/title"/>
        
        <xsl:apply-templates select="/article/body"/>
    </xsl:template>
    
    
    <xsl:template match="/article/body">
        <xsl:apply-templates select="/article/body/sect1"/>
    </xsl:template>
    
    <xsl:template match="para">
        <xsl:value-of select="."/>
    </xsl:template>


</xsl:transform>
