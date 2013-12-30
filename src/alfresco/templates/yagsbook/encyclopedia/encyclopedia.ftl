

<#macro link node>
    <#assign script="/alfresco/wcservice/yagsbook/encyclopedia/article" />
    <#assign uri=node.name?replace(".yags", "") />

    <a href="${script}/${rootUri}/${uri}">${node.properties["cm:title"]}</a>
</#macro>

<h1 style="color:white; background-color: green; width: 100%">${space.properties["cm:title"]}</h1>

<p style="font-weight: bold">${space.properties["cm:description"]}</p>

<#assign styleOne="color: white; background-color: green;" />
<#assign styleTwo="color: green; border-bottom: 1px solid green; width: 100%;" />
<#assign styleThree="margin-bottom: 0px" />


<#assign cats=classification.getRootCategories("cm:generalclassifiable") />

<#list cats as cat>
    <#if cat.name = "Encyclopedia">
        <#assign catRoot=cat />
    </#if>
</#list>

<#assign catName=space.name />
<#assign rootUri=space.properties["yb:rooturi"] />

<#list catRoot.immediateSubCategories as cat>
    <#if cat.name = catName>
        <#assign categoryRoot=cat />
    </#if>
</#list>

<#list categoryRoot.immediateSubCategories as level1>
    <h2 style="${styleOne}">${level1.properties["cm:description"]}</h2>

    <#list space.childrenByLuceneSearch["@yb\\:category:"+level1.name] as node>
        <@link node />
    </#list>

    <div>
        <#list level1.immediateSubCategories as level2>
            <h3 style="${styleTwo}">${level2.properties["cm:description"]}</h3>

            <#list space.childrenByLuceneSearch["@yb\\:category:"+level2.name] as node>
                <@link node />
            </#list>

            <div style="margin-left: 25px;">
                <#list level2.immediateSubCategories as level3>
                    <h4 style="${styleThree}">${level3.properties["cm:description"]}</h4>

                    <#list space.childrenByLuceneSearch["@yb\\:category:"+level3.name] as node>
                        <@link node />
                    </#list>
                </#list>
            </div>
        </#list>
    </div>
</#list>
