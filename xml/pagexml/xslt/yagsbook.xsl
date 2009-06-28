<?xml version="1.0"?>

<xsl:transform
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0"
    xmlns:xalan="http://xml.apache.org/xalan"
    xmlns:java="http://xml.apache.org/xalan"
    xmlns:yagsbook="net.sourceforge.yagsbook.pagexml.Yagsbook"
    extension-element-prefixes="yagsbook">

    <xsl:param name="ant-target-dir"/>
    <xsl:param name="ant-tmp-dir"/>

    <xalan:component prefix="yagsbook">
        <xalan:script lang="javaclass"
                      src="xalan://net.sourceforge.yagsbook.pagexml.Yagsbook"/>
    </xalan:component>

    <xsl:template match="import-yagsbook">
        <xsl:variable name="src" select="@src"/>
        <xsl:variable name="dest" select="@dest"/>
        <xsl:variable name="cvsroot" select="cvsroot"/>
        <xsl:variable name="basedir" select="basedir"/>

        <xsl:value-of select="yagsbook:setTargetDir($ant-target-dir)"/>
        <xsl:value-of select="yagsbook:setTmpDir($ant-tmp-dir)"/>

        <xsl:value-of select="yagsbook:importBooks($src, $dest, $cvsroot, $basedir)"
                        disable-output-escaping="yes"/>
    </xsl:template>

</xsl:transform>
