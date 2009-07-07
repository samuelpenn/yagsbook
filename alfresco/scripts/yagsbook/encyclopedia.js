/**
 * Called when something is added to a encyclopedia.
 */

function log(msg) {
    var debug = space.childByNamePath("debug.txt");
    if (debug == null) {
        debug = space.createFile("debug.txt");
    }
    debug.content = debug.content + msg+"\n";
    debug.save();
}

// Root of the encyclopedia.
var     encyclopediaRoot = space;
// Node being added/updated.
var     articleNode = document;

articleNode.mimetype="text/xml";
articleNode.specializeType("yb:article");

var xml = new XML();
xml = <article></article>
var content = ""+articleNode.content;

if (content.substr(0, 5).indexOf("?xml") != -1) {
    positionRootElement = content.indexOf("<", 10);
    content = content.substr(positionRootElement, content.length-1);
}

// Read content into XML
default xml namespace = "http://yagsbook.sourceforge.net/xml";
var article = new XML(content);
xml.article = article;

var title = xml.article.header.title;
var description = xml.article.header.slugline;
var subject = xml.article.header.topics.subject.@uri;
var category = xml.article.header.topics.category;

var topics = xml.article.header.topics.topic.@uri;

log(title+" ["+topics.length()+"]");

articleNode.properties["yb:uri"] = (""+articleNode.name).replace(/\.yags/, "");

if (title != null) articleNode.properties["cm:title"] = title.toString();

if (description != null) articleNode.properties["cm:description"] = description.toString();

if (subject != null) articleNode.properties["yb:subject"] = subject.toString();

if (category != null) articleNode.properties["yb:category"] = category.toString();

articleNode.properties["yb:parent"] = encyclopediaRoot.properties["yb:rooturi"];

if (topics != null) {
    var     t = new Array();
    for (var i=0; i < topics.length(); i++) {
        t[i] = topics[i].toString();
        log(""+i+": "+t[i]);
    }
    articleNode.properties["yb:topic"] = t;
}

articleNode.save();
