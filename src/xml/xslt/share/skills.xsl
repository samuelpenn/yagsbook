<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format">


    <!--
        skill-list

        An inline list of skill descriptions. Just list them out in
        alphabetical order.
    -->
    <xsl:template match="skill-list">
        <xsl:apply-templates select="skill">
            <xsl:sort select="name" data-type="text"/>
        </xsl:apply-templates>
    </xsl:template>

    <!--
        Importing a list of skill descriptions from an external file.
    -->
    <xsl:template match="import-skills">
        <xsl:variable name="href" select="@href"/>

        <xsl:choose>
            <xsl:when test="@type">
                <xsl:variable name="type" select="@type"/>
                <xsl:apply-templates
                                    select="document($href)/skill-list/skill[@type=$type]">
                    <xsl:sort select="@name" data-type="text"/>
                </xsl:apply-templates>
            </xsl:when>

            <xsl:when test="@group">
                <xsl:variable name="group" select="@group"/>
                <xsl:apply-templates
                                    select="document($href)/skill-list/skill[group=$group]">
                    <xsl:sort select="@name" data-type="text"/>
                </xsl:apply-templates>
            </xsl:when>

            <xsl:otherwise>
                <xsl:apply-templates select="document($href)/skill-list/skill">
                    <xsl:sort select="@name" data-type="text"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
