<#ftl ns_prefixes={"D":"http://yagsbook.sourceforge.net/xml", "y":"http://yagsbook.sourceforge.net/xml/yags"}>
<#assign article=document.xmlNodeModel.article>
<#assign script="/alfresco/wcservice/yagsbook/encyclopedia/article"/>

<#macro link node>
    <a href="${script}/${encyclopediaUri}/${node.name?replace(".yags", "")}">${node.properties["cm:title"]}</a>
</#macro>

<html>
    <head>
        <title>${article.header.title}</title>
        <link href="/alfresco/css/yagsbook/article.css" type="text/css" media="screen" rel="STYLESHEET"/>
        <!--
        <link href="http://www.glendale.org.uk/usr/share/css/default.css"
              type="text/css" media="screen" rel="STYLESHEET" />
        <link href="http://www.glendale.org.uk/usr/share/xml/yagsbook/article/css/encyclopedia.css"
              type="text/css" media="screen" rel="STYLESHEET" />
        -->
    </head>

    <script language="javascript">
        function show(id) {
            var     e = document.getElementById(id);

            if (e != null) {
                if (e.style["display"] == "none") {
                    e.style["display"] = "inline";
                } else {
                    e.style["display"] = "none";
                }
            }
        }
    </script>

    <body>
        <div class="header">
            <h1>${encyclopediaTitle}: <small>${article.header.title}</small></h1>
        </div>

        <div class="breadcrumb">
            ${breadcrumb}
        </div>

        <#if topics?exists>
            <div class="topicbar">
                <h4>Topics</h4>
                <ul>
                    <#list topics as topic>
                        <li><@link topic /></li>
                    </#list>
                </ul>
            </div>
        </#if>

        <#if children?exists>
            <div class="topicbar">
                <h4>Sub Articles</h4>
                <ul>
                    <#list children as child>
                        <li><@link child /></li>
                    </#list>
                </ul>
            </div>
        </#if>

        <#if members?exists>
            <div class="topicbar">
                <h4>Topic Members</h4>
                <ul>
                    <#if members?size &gt; 20>
                        <#assign lastLetter="0"/>
                        <#assign id=0 />
                        <#list members as child>
                            <#if child.properties["cm:title"]?starts_with(lastLetter)>
                                <li><@link child/></li>
                            <#else>
                                <#if lastLetter != "0"></ul></#if>
                                <#assign lastLetter=child.properties["cm:title"]?substring(0,1) />
                                <li><b onclick="show('ul_${id}')">${lastLetter}</b></li>
                                <ul id="ul_${id}" style="display: none">
                                <#assign id=id+1 />
                                <li><@link child/></li>
                            </#if>
                        </#list>
                    <#else>
                        <#list members as child>
                            <li><@link child /></li>
                        </#list>
                    </#if>
                </ul>
            </div>
        </#if>

        <div class="bodytext">
            <#recurse article.body />
        </div>
    </body>
</html>

<#macro sect1>
    <div class="sect">
        <h1>${.node.title}</h1>
        <#recurse>
    </div>
</#macro>

<#macro sect2>
    <div class="sect2">
        <h2>${.node.title}</h2>
        <#recurse>
    </div>
</#macro>

<#macro sect3>
    <div class="sect3">
        <h3>${.node.title}</h3>
        <#recurse>
    </div>
</#macro>

<#macro sect4>
    <div class="sect4">
        <h4>${.node.title}</h4>
        <#recurse>
    </div>
</#macro>

<#macro sect5>
    <div class="sect5">
        <h5>${.node.title}</h5>
        <#recurse>
    </div>
</#macro>

<#macro title>
</#macro>

<#macro para>
    <p>
        <#recurse />
    </p>
</#macro>

<#macro qv><a href="${script}/${encyclopediaUri}/${.node.@uri}">${.node}</a></#macro>

<#macro e><em>${.node}</em></#macro>

<#macro s><strong>${.node}</strong></#macro>

<#macro image>
    <strong>${.node}</strong>
</#macro>

<#macro "import-map">
</#macro>

<#macro "targetlist">
</#macro>

<#macro characters>
</#macro>

<#macro character>
    <div class="character">
        <h4>${.node.@name}</h4>

        <#recurse>
    </div>
</#macro>

<#macro description>
    <p>
        ${.node.gender}, ${.node.race}, ${.node.age}
    </p>
    <p>
        ${.node.short}
    </p>
</#macro>

<#macro "y:statistics">
    <div>
        <div style="float: left; margin-right: 2em">
            <table>
                <#list .node["y:attributes"]["y:attribute"] as a>
                    <tr><th align="left">${a.@name?cap_first}</th><td>${a.@score}</td></tr>
                </#list>
            </table>
        </div>

        <div>
            <#list .node["y:skills"]["y:group"] as group>
                <p>
                    <b>${group.@name}: </b>
                    <#list group["y:skill"] as skill>
                        ${skill.@name} [${skill.@score}]<#if skill_has_next>,</#if>
                    </#list>
                </p>
            </#list>
        </div>
    </div>
</#macro>
