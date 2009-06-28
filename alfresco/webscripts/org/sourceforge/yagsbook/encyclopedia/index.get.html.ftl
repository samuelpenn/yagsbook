<html>
    <head>
        <title>Encyclopedia</title>
        <link href="/alfresco/css/yagsbook/article.css" type="text/css" media="screen" rel="STYLESHEET"/>
    </head>

    <#macro link node comma>
        <#assign script="/alfresco/wcservice/yagsbook/encyclopedia/article" />
        <#assign uri=node.name?replace(".yags", "") />
        <a href="${script}/${rootUri}/${uri}">${node.properties["cm:title"]}</a>${comma}
    </#macro>

    <#macro findCategory root name>
        <#if name?length=0>
            <@displayCategory root 1/>
        <#else>
            <#list root.subCategories as sub>
                <#if sub.name = name>
                    <@displayCategory sub 1 />
                </#if>
            </#list>
        </#if>
    </#macro>

    <#macro displayCategory root level>
        <h${level+1}>${root.properties["cm:description"]}</h${level+1}>

        <ul class="category">
            <#list space.childrenByLuceneSearch["@yb\\:category:"+root.name]?sort_by(["properties","cm:title"]) as node>
                <#assign comma=", "/>
                <#if !node_has_next><#assign comma="."/></#if>
                <li><@link node comma/></li>
            </#list>
        </ul>

        <#list root.immediateSubCategories as sub>
            <@displayCategory sub level+1/>
        </#list>
    </#macro>

    <body>
        <div class="header">
            <h1>${space.properties["cm:title"]}</h1>
        </div>

        <div class="breadcrumb">
        </div>

        <p class="description">${space.properties["cm:description"]}</p>

        <#assign styleOne="color: white; background-color: #336633;" />
        <#assign styleTwo="color: green; border-bottom: 1px solid #336633; width: 100%;" />
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

        <#if categoryName?exists>
            <@findCategory categoryRoot categoryName/>
        <#else>
            <@findCategory categoryRoot ""/>
        </#if>
    </body>
</html>