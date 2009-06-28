<html>
    <head>
        <title>Pages</title>
    </head>

    <#macro tree parent>
        <ul>
            <#list parent.children as child>
                <#if child.isContainer>
                    <li><b>${child.name}</b></li>
                    <@tree parent=child/>
                <#else>
                    <#if child.name?ends_with("xml")>
                        <#if child.isDocument>
                            <#-- <#assign dom=child.xmlNodeModel> -->
                            <li>${child.name} ${child.mimetype}</li>
                        </#if>
                    </#if>
                </#if>
            </#list>
        </ul>
    </#macro>

    <body>
        <#assign store=avm.lookupStore("yags")>

        <h1>${store.name}</h1>

        <#assign root=store.lookupRoot>

        <@tree parent=root/>
    </body>
</html>

