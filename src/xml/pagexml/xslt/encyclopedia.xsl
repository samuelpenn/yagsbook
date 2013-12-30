<?xml version="1.0"?>

<xsl:transform
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0"
    xmlns:xalan="http://xml.apache.org/xalan"
    xmlns:java="http://xml.apache.org/xalan"
    xmlns:yagsenc="net.sourceforge.yagsbook.pagexml.YagsEncyclopedia"
    extension-element-prefixes="yagsenc">

    <xsl:param name="ant-target-dir"/>
    <xsl:param name="ant-tmp-dir"/>

    <xalan:component prefix="yagsenc">
        <xalan:script lang="javaclass"
                      src="xalan://net.sourceforge.yagsbook.pagexml.YagsEncyclopedia"/>
    </xalan:component>

    <xsl:template match="import-encyclopedia">
        <xsl:variable name="src" select="@src"/>
        <xsl:variable name="dest" select="@dest"/>
        <xsl:variable name="cvsroot" select="cvsroot"/>
        <xsl:variable name="basedir" select="basedir"/>
        <xsl:variable name="config" select="config"/>
        <xsl:variable name="repository" select="repository"/>

        <xsl:value-of select="yagsenc:setTargetDir($ant-target-dir)"/>
        <xsl:value-of select="yagsenc:setTmpDir($ant-tmp-dir)"/>

        <xsl:value-of select="yagsenc:setModule($src)"/>
        <xsl:value-of select="yagsenc:setBaseDir($basedir)"/>
        <xsl:value-of select="yagsenc:setConfigFile($config)"/>
        <xsl:value-of select="yagsenc:setRepository($repository)"/>
        <xsl:value-of select="yagsenc:setCvsRoot($cvsroot)"/>


        <xsl:value-of select="yagsenc:importEncyclopedia($dest)"
                        disable-output-escaping="yes"/>
    </xsl:template>

</xsl:transform>
