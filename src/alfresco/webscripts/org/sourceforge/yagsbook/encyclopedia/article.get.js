/**
 * Get content of an Encyclopedia article.
 */
script: {
    var     fullpath = url.extension.split("/");
    model.encyclopediaUri = fullpath[0];
    model.uri = (""+fullpath[1]).split(".")[0];

    // Constants
    model.articleScript = url.serviceContext+"/yagsbook/encyclopedia/article/"+model.encyclopediaUri+"/";
    model.indexScript = url.serviceContext+"/yagsbook/encyclopedia/index/"+model.encyclopediaUri+"/";

    /**
     * Get the node for a given uri in this Encyclopedia. Returns either
     * exactly one node, or null.
     */
    function findByUri(uri) {
        var     nodes = search.luceneSearch("@yb\\:parent:"+model.encyclopediaUri+" AND @yb\\:uri:"+uri);

        if (nodes != null && nodes.length == 1) {
            return nodes[0];
        }

        return null;
    }

    function findBySubject(subject) {
        var     nodes = search.luceneSearch("@yb\\:parent:"+model.encyclopediaUri+" AND @yb\\:subject:"+subject+" AND NOT @yb\\:uri:"+model.uri);

        if (nodes != null && nodes.length > 0) {
            return nodes;
        }

        return null;
    }

    function findByTopic(topic) {
        var     query = "@yb\\:parent:"+model.encyclopediaUri+" AND @yb\\:topic:"+topic+" AND NOT @yb\\:uri:"+model.uri;
        var     nodes = search.luceneSearch(query);//, "@cm:title", true);

        if (nodes != null && nodes.length > 0) {
            return nodes.sort(function(alpha, beta) {
                if (alpha.properties["cm:title"] < beta.properties["cm:title"]) {
                    return -1;
                } else if (alpha.properties["cm:title"] > beta.properties["cm:title"]) {
                    return +1;
                }
                return 0;
            });
        }

        return null;
    }

    function buildBreadcrumb(path, name, node) {
        var children = node.immediateSubCategories;
        var uri = model.indexScript;

        if (path.length == 0) {
            path = node.name+" &gt; ";
        } else if (node.parent.name == "Encyclopedia") {
            path += "<a href='"+model.indexScript+"'>"+node.name+"</a> &gt; ";
        } else if (node.name == name) {
            path += "<a href='"+model.indexScript+node.name+"'>"+node.name+"</a>";
        } else {
            path += "<a href='"+model.indexScript+node.name+"'>"+node.name+"</a> &gt; ";
        }

        if (node.name == name) {
            return path;
        }

        for (var i=0; i < children.length; i++) {
            var p = buildBreadcrumb(path, name, children[i]);
            if (p != null) {
                return p;
            }
        }

        return null;
    }

    function getBreadcrumb(categoryName) {
        var     roots = classification.getRootCategories("cm:generalclassifiable");
        var     trail = "";

        for (var i=0; i < roots.length; i++) {
            if (roots[i].name == "Encyclopedia") {
                trail = buildBreadcrumb("", categoryName, roots[i]);
            }
        }

        return trail;
    }


    var     roots = search.luceneSearch("@yb\\:rooturi:"+model.encyclopediaUri);

    model.encyclopediaTitle = roots[0].properties["cm:title"];

    var     document = findByUri(model.uri);//search.luceneSearch("@yb\\:uri:"+model.uri);

    if (document != null) {
        var     content = ""+document.content;
        if (content.substr(0,5).indexOf("?xml") != -1) {
            positionRootElement = content.indexOf("<", 10);
            content = content.substr(positionRootElement, content.length-1);
        }
        default xml namespace = "http://yagsbook.sourceforge.net/xml";
        model.article = new XML();
        model.article = <article></article>;
        var article = new XML(content);
        model.article.article = article;

        model.test = model.article.article.header.title.toString();
        model.document = document;

        var     category = document.properties["yb:category"];
        var     topics = document.properties["yb:topic"];
        var     subject = document.properties["yb:subject"];

        model.isTopicHeader = false;

        model.topics = null;
        if (topics.length > 0) {
            model.topics = new Array();
            for (var i=0; i < topics.length; i++) {
                model.topics.push(findByUri(topics[i]));
                if (topics[i] == model.uri) {
                    model.isTopicHeader = true;
                    model.members = findByTopic(topics[i]);
                }
            }
        }

        if (subject != model.uri) {
        } else {
            var childNodes = findBySubject(subject);
            model.children = childNodes;
        }

        model.breadcrumb = getBreadcrumb(category);

    } else {
        model.document = null;
    }

    model.debug = roots.length;
}
