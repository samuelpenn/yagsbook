<?xml version="1.0" ?>

<xsl:transform
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        version="1.0"
        >

    <!--
        xml

        The <xml> tag is an inline element used to markup a reference to
        an XML element. It may optionally contain a @uri attribute, which
        generates a hyperlink to the named uri.
     -->
    <xsl:template match="xml">
        <xsl:choose>
            <xsl:when test="@uri">
                <span class="inline">
                    &lt;<a href="{@uri}.html"><xsl:value-of select="."/></a>&gt;
                </span>
            </xsl:when>
            <xsl:when test="@value">
                <span class="inline">
                    &lt;<span class="node"><xsl:value-of select="."/></span>&gt;
                    <xsl:value-of select="@value"/>
                    &lt;/<span class="node"><xsl:value-of select="."/></span>&gt;
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="inline">
                    &lt;<span class="node"><xsl:value-of select="."/></span>&gt;
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="xmlroot" mode="open">
        <xsl:choose>
            <xsl:when test="attribute">
                &lt;<span class="node"><xsl:value-of select="@name"/></span>
                <xsl:apply-templates select="attribute" mode="open"/>&gt;
            </xsl:when>

            <xsl:otherwise>
                &lt;<span class="node"><xsl:value-of select="@name"/></span>&gt;
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="xmlroot">
        <div class="xml">
            <p>
                <xsl:apply-templates select="." mode="open"/>
            </p>

            <xsl:apply-templates/>

            <p>
                &lt;/<span class="node"><xsl:value-of select="@name"/></span>&gt;
            </p>
        </div>
    </xsl:template>

    <xsl:template match="comment">
        <div class="xmlindent">
            <span class="comment">
                &lt;!--
                <div class="xmlindent">
                    <xsl:value-of select="."/>
                </div>
                --&gt;
            </span>
        </div>
    </xsl:template>

    <xsl:template match="attribute" mode="open">
        <xsl:variable name="name" select="@name"/>
        <xsl:variable name="value" select="@value"/>

        <xsl:text> </xsl:text>
        <span class="attribute"><xsl:value-of select="@name"/>=</span><span class="attribute-value">"<xsl:value-of select="@value"/>"</span>
    </xsl:template>

    <xsl:template match="element" mode="open">
        <xsl:choose>
            <xsl:when test="attribute">
                &lt;<span class="node"><xsl:value-of select="@name"/></span>
                <xsl:apply-templates select="attribute" mode="open"/>&gt;
            </xsl:when>

            <xsl:otherwise>
                &lt;<span class="node"><xsl:value-of select="@name"/></span>&gt;
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="element">
        <div class="xmlindent">
            <xsl:choose>
                <xsl:when test="@value">
                    <p>
                        <xsl:apply-templates select="." mode="open"/>
                        <span class="text">
                            <xsl:value-of select="@value"/>
                        </span>
                        &lt;/<span class="node"><xsl:value-of select="@name"/></span>&gt;
                    </p>
                </xsl:when>

                <xsl:when test="count(*) = 0 and . = ''">
                        &lt;<span class="node"><xsl:value-of select="@name"/></span>/&gt;
                </xsl:when>

                <xsl:otherwise>
                    <p>
                        <xsl:apply-templates select="." mode="open"/>
                    </p>

                    <xsl:if test="element">
                        <xsl:apply-templates select="element"/>
                    </xsl:if>

                    <xsl:if test="text">
                        <div class="xmlindent">
                            <span class="text">
                                <xsl:apply-templates select="text" mode="text"/>
                            </span>
                        </div>
                    </xsl:if>

                    <xsl:if test="not(element) and not(text)">
                        <div class="xmlindent">
                            <span class="text">
                                <xsl:apply-templates mode="text"/>
                            </span>
                        </div>
                    </xsl:if>

                    <p>
                        &lt;/<span class="node"><xsl:value-of select="@name"/></span>&gt;
                    </p>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>

    <xsl:template match="element/text" mode="text">
        <xsl:apply-templates mode="text"/>
    </xsl:template>

    <xsl:template match="text/inline" mode="text">
        <span class="inline">
            &lt;<span class="node"><xsl:value-of select="@name"/></span>&gt;
            <span class="text">
                <xsl:value-of select="@value"/>
            </span>
            &lt;/<span class="node"><xsl:value-of select="@name"/></span>&gt;
        </span>
    </xsl:template>

    <xsl:template match="element/inline" mode="text">
        <span class="inline">
            &lt;<span class="node"><xsl:value-of select="@name"/></span>&gt;
            <span class="text">
                <xsl:value-of select="@value"/>
            </span>
            &lt;/<span class="node"><xsl:value-of select="@name"/></span>&gt;
        </span>
    </xsl:template>

</xsl:transform>
