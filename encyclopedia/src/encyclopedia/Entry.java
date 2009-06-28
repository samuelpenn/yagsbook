/*
 * Copyright (C) 2002 Samuel Penn, sam@glendale.org.uk
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation version 2.
 * See the file COPYING.
 *
 * $Revision: 1.15 $
 * $Date: 2005/08/04 19:01:22 $
 */

package net.sourceforge.yagsbook.encyclopedia;

import java.util.*;
import java.io.*;

import org.w3c.dom.*;

import net.sourceforge.yagsbook.xml.*;

/**
 * An Entry is a single text Yagsbook article within the encyclopedia.
 * It wraps up the XML content of the article, and provides an abstracted
 * interface to access meta data about the article.
 *
 * Each Entry is uniquely identified by its URI. For a given Encyclopedia,
 * URIs are flat - their is no heirachical structure available. The hyphen
 * is often used, e.g. 'london', 'london-history', 'london-culture' though
 * this is not enforced.
 *
 * @see XMLDocument
 */
class Entry extends XMLDocument {
    private String      uri;
    private String      title;
    private String      slugline;
    private Vector      topics;
    private Hashtable   topicsUri;
    private Vector      categories;
    private Vector      links;
    private Vector      see;
    private Vector      seeUri;
    private String      subject;
    private String      subjectUri;

    private String      path;


    public String
    toString() {
        return uri;
    }


    public
    Entry(String path) throws XMLException {
        super(new File(path));
        this.path = path;
        setup(new File(path));
        readDOM();
    }

    public
    Entry(File file) throws XMLException {
        super(file);

        this.path = file.getPath();

        setup(file);
        readDOM();
    }

    private void
    setup(File file) {
        uri = file.getName();
        uri = uri.replaceAll("\\.yags", "").toLowerCase();
    }

    private void
    processTopics() throws XMLException {
        topicsUri = new Hashtable();

        for (int i=0; i < topics.size(); i++) {
            String  uri = (String)topics.elementAt(i);
            String  name = getTextNode("//topics/topic[@uri='"+uri+"']");
            topicsUri.put(uri, name);
        }
    }

    private void
    readDOM() {

        try {
            title = getTextNode("/article/header/title");
            slugline = getTextNode("/article/header/slugline");

            // Get list of topic sets
            topics = getList("/article/header/topics/topic/@uri");
            processTopics();
            topics.add("all");

            see = getList("/article/header/references/see");
            links = new Vector(see);
            links = getList(links, "//qv/@uri");

            subject = getTextNode("/article/header/topics/subject");
            subjectUri = getTextNode("/article/header/topics/subject/@uri");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Vector
    getList(String xpath) {
        Vector  vector = new Vector();

        return getList(vector, xpath);
    }

    private Vector
    getList(Vector vector, String xpath) {
        NodeList    list;
        int         i;

        try {
            list = getNodeList(xpath);
            for (i=0; i < list.getLength(); i++) {
                Node    item = list.item(i);

                if (item.getNodeType() == Node.ATTRIBUTE_NODE) {
                    vector.add(item.getNodeValue());
                } else {
                    vector.add(getTextNode(item));
                }
            }
        } catch (Exception e) {

        }

        return vector;
    }

    public String
    getUri() { return uri; }

    public String
    getUriIndex() {
        return uri.substring(0, 1);
    }

    /**
     * Get the index we should be sorting on. This is normally the first
     * character of the entry's title, forced to upper case.
     *
     * @return  Index string.
     */
    public String
    getIndex() {
        return title.substring(0, 1).toUpperCase();
    }

    public String
    getFilename() {
        return getUriIndex()+"/"+getUri()+".html";
    }

    public String
    getTitle() { return title; }

    public String
    getSlugline() { return slugline; }

    public String
    getSubject() {
        return subject;
    }

    public String
    getSubjectUri() {
        return subjectUri;
    }

    /**
     * Return a list of all uri's which are referenced by this document.
     * This list can be used to check for missing/broken links.
     */
    public Vector
    getAllLinks() {
        Vector      vector = new Vector();

        vector = getList(vector, "//qv/@uri");
        vector = getList(vector, "//see/@uri");
        vector = getList(vector, "//topic/@uri");

        return vector;
    }

    public Iterator
    getTopics() {
        return topics.iterator();
    }

    public String
    getTopicName(String uri) {
        return (String)topicsUri.get(uri);
    }

    public Iterator
    getLinks() {
        return links.iterator();
    }

    public Iterator
    getSee() {
        return see.iterator();
    }

    /**
     * Returns true if this is the top level parent entry.
     * The entry is considered to be a child if the subject is different
     * from the uri. Children are always displayed beneath the parent
     * entry in the index, rather than in their normal 'alphabetical'
     * location.
     *
     * @return      true if this is the top level parent.
     */
    public boolean
    isParent() {
        if (subjectUri.equals(uri)) {
            return true;
        }

        return false;
    }

    public String
    getHref(String path, String name) {
        return "<a href=\""+path+getUriIndex()+"/"+getUri()+".html\">"+name+"</a>";
    }

    public String
    getHref(String path) {
        return getHref(path, title);
    }

}
