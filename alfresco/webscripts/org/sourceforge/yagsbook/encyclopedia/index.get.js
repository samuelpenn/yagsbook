/**
 * Get the index page of an encyclopedia.
 * The first element of the path is the URI of the encyclopedia to display.
 * If there are subsequent paths, then this is a category name.
 */
script: {
    var     fullpath = url.extension.split("/");
    model.encyclopediaUri = fullpath[0];
    model.categoryName = null;

    if (fullpath.length > 1) {
        model.categoryName = fullpath[1];
    }


    function findByUri(uri) {
        var     nodes = search.luceneSearch("@yb\\:parent:"+model.encyclopediaUri+" AND @yb\\:uri:"+uri);

        if (nodes != null && nodes.length == 1) {
            return nodes[0];
        }

        return null;
    }

    model.space = search.luceneSearch("@yb\\:rooturi:"+model.encyclopediaUri)[0];

}