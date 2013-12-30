<?xml version="1.0"?>

<!--
    Stylesheet transform for Yagsbook to HTML.

    This is the top level stylesheet, which includes all the other
    stylesheet files, and handles the header and top level body
    parts of the document.

    All global variables should also be defined in this file.

    Author:  Samuel Penn
    Version: $Revision: 1.4 $
    Date:    $Date: 2006/04/16 17:42:43 $

    Copyright 2005 Samuel Penn, http://yagsbook.sourceforge.net.
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

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:yb="http://yagsbook.sourceforge.net/xml"
               version="1.0">

    <!--
        Display properties. Control how some things are
        displayed without affecting the content.
    -->
    <xsl:param name="displayTagline" select="''"/>

    <!--
        Link properties. Control the links given at the
        top of each article. By default, only the mainpage
        link is displayed.
    -->
    <xsl:param name="linkMainPage" select="'../index.html'"/>
    <xsl:param name="linkIndex" select="''"/>

    <!--
        Detail properties. Control how much detail is displayed
        about certain elements, such as characters and items.
    -->
    <xsl:param name="detailCombat" select="'false'"/>
    <xsl:param name="detailCharacters" select="'true'"/>
    <!-- Display point values of characters -->
    <xsl:param name="detailPoints" select="'false'"/>

    <!--
        Show properties. Control which game systems to show
        information on.
    -->
    <xsl:param name="showYags" select="'true'"/>
    <xsl:param name="showWarhammer" select="'true'"/>
    <xsl:param name="showArsMagica" select="'true'"/>
    <xsl:param name="showFiveRings" select="'true'"/>
    <xsl:param name="showGurps" select="'true'"/>
    <xsl:param name="showD20" select="'true'"/>

    <xsl:param name="showMasked" select="'false'"/>

    <xsl:variable name="characterDark" select="'#55ff55'"/>
    <xsl:variable name="characterLight" select="'#ddffdd'"/>
    <xsl:variable name="combatDark" select="'#ff5555'"/>
    <xsl:variable name="combatLight" select="'#ffdddd'"/>


</xsl:transform>
