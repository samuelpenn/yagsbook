<?xml version="1.0" ?>

<xsl:transform
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        version="1.0"
        >

    <!--
        cmd
        
        Denotes a command that should be typed at a command prompt.
        Normally displayed as a fixed font, such as courier.
     -->
    <xsl:template match="cmd">
        <span class="fixed"><xsl:value-of select="."/></span>
    </xsl:template>
    
    <!--
        menu
        
        Denotes a GUI menu entry. Displayed as inline boxed text on the
        page. If the menu option has sub options, then these should be
        nested as <sub/> elements of the <menu/>, e.g.:
            <menu>File<sub>Export</sub><sub>SVG</sub></menu>
     -->
    <xsl:template match="menu">
        <span class="menu">
            <xsl:for-each select="i">
                <xsl:if test="position() > 1">
                    &#x00bb;
                </xsl:if>
                <xsl:value-of select="."/>
            </xsl:for-each>
        </span>
    </xsl:template>
    
    <xsl:template match="script">
        <div class="script">
            <xsl:for-each select="cmd">
                <xsl:value-of select="../@prompt"/>
                <xsl:apply-templates select="."/>
                <br/>
            </xsl:for-each>
        </div>
    </xsl:template>
    
    <xsl:template match="script/cmd">
        <xsl:value-of select="@command"/>
        
        <xsl:for-each select="option">
            <xsl:text> </xsl:text>
            <xsl:if test="@optional='true'">
                <xsl:text>[</xsl:text>
            </xsl:if>
            <xsl:value-of select="@name"/>
            <xsl:text> </xsl:text>
            <xsl:choose>
                <xsl:when test="@parameter">
                    &lt;<xsl:value-of select="@parameter"/>&gt;
                </xsl:when>
                <xsl:when test="@value">
                    <xsl:value-of select="@value"/>
                </xsl:when>
            </xsl:choose>
            <xsl:if test="@optional='true'">
                <xsl:text>]</xsl:text>
            </xsl:if>
        </xsl:for-each>
        
        <xsl:for-each select="argument">
            <xsl:text> </xsl:text>
            <xsl:if test="@optional='true'">
                <xsl:text>[</xsl:text>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="@parameter">
                    &lt;<xsl:value-of select="@parameter"/>&gt;
                </xsl:when>
                <xsl:when test="@value">
                    <xsl:value-of select="@value"/>
                </xsl:when>
            </xsl:choose>
            <xsl:if test="@optional='true'">
                <xsl:text>]</xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <!--
        output
        
        A block of output is displayed much like a script, but just consists
        of plain lines of text. It is normally used to display file contents
        or example fixed font output.
        
        If @numbered='true' then each line is preceeded by its line number.
        
        The output element may have a @ref attribute. This allows it to be
        referenced by an external entity to find a line number. Each line
        to be referenced should have its own @ref attribute as well.
     -->
    <xsl:template match="output">
        <div class="script">
            <xsl:for-each select="line">
                <xsl:if test="../@numbered='true'">
                    <xsl:value-of select="position()"/><xsl:text>. </xsl:text>
                </xsl:if>
                <xsl:apply-templates select="."/>
                <br/>
            </xsl:for-each>
        </div>
    </xsl:template>
    
    <!--
        ref
        
        Reference a line in a block of output.
        <ref output="outputref" ref="lineref"/>
        This outputs the line number of the line which has a ref of 'lineref'
        in the output block 'outputref'.
     -->
    <xsl:template match="p/ref">
        <xsl:choose>
            <xsl:when test="@output">
                <xsl:variable name="title" select="@output"/>
                <xsl:variable name="ref" select="@ref"/>
                
                <xsl:if test="//output[@ref=$title]/line[@ref=$ref]">
                    <xsl:for-each select="//output[@ref=$title]/line">
                        <xsl:if test="@ref=$ref">
                            <xsl:value-of select="position()"/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

</xsl:transform>
