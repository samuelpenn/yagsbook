/*
 * Copyright (C) 2004 Samuel Penn, sam@glendale.org.uk
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation version 2.
 * See the file COPYING.
 *
 * $Revision: 1.5 $
 * $Date: 2006/02/07 19:14:29 $
 */
package net.sourceforge.yagsbook.encyclopedia.articles;

import java.io.*;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Properties;

import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import net.sourceforge.yagsbook.encyclopedia.indexing.Reference;
import net.sourceforge.yagsbook.encyclopedia.indexing.Topic;
import net.sourceforge.yagsbook.encyclopedia.interfaces.*;
import net.sourceforge.yagsbook.xml.*;

/**
 * @author sam
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class Article implements IEntry {
    private File            file = null;
    private ArticleDocument document = null;
    private String          uri = null;
    private String          stylesheet = null;
    private Properties      properties = new Properties();

    private class ArticleDocument extends XMLDocument {
        ArticleDocument(File file) throws XMLException {
            super(file);
        }

        ArticleDocument(String content) throws XMLException {
            super(content);
        }

        ArrayList
        getTopics() {
            ArrayList       topics = new ArrayList();
            NodeList        list = null;

            try {
                list = getNodeList("/article/header/topics/topic");
                for (int i=0; i < list.getLength(); i++) {
                    Node    node = list.item(i);

                    String  uri = getTextNode(node, "@uri");
                    String  name = getTextNode(node);

                    topics.add(new Topic(uri, name));
                }
            } catch (XMLException e) {
            }

            return topics;
        }

        ArrayList
        getReferences() {
            ArrayList       references = new ArrayList();
            NodeList        list = null;

            try {
                // Add all hard references (those found in the header).
                list = getNodeList("/article/header/references/see");
                for (int i=0; i < list.getLength(); i++) {
                    Node    node = list.item(i);

                    String  uri = getTextNode(node, "@uri");
                    String  name = getTextNode(node);

                    references.add(new Reference(uri, name, true));
                }

                // Now add all soft refereces (those in the article body).
                list = getNodeList("/article/body//qv");
                for (int i=0; i < list.getLength(); i++) {
                    Node    node = list.item(i);

                    String  uri = getTextNode(node, "@uri");
                    String  name = getTextNode(node);

                    references.add(new Reference(uri, name, false));
                }
            } catch (XMLException e) {
            }

            return references;
        }
    }

    /**
     * Create a new article from the provided file. The article will be loaded
     * into memory as an XML document.
     *
     * @param file      File to be processed as an article.
     *
     * @throws IOException      An exception is thrown if the file does not
     *                          exist or is not a valid XML document.
     */
    public
    Article(File file) throws IOException {
        this.file = file;

        if (!file.isFile()) {
            throw new IOException("File does not exist or is a directory");
        }

        try {
            document = new ArticleDocument(file);
            uri = file.getName().replaceAll("\\.yags", "").toLowerCase();
        } catch (XMLException e) {
            throw new IOException("Cannot load document ("+e.getMessage()+")");
        }
    }

    public
    Article(String uri, String content) throws IOException {
        this.file= null;
        this.uri = uri;

        try {
            document = new ArticleDocument(content);
        } catch (XMLException e) {
            throw new IOException("Cannot parse document ("+e.getMessage()+")");
        }
    }

    /**
     * @see net.sourceforge.yagsbook.encyclopedia.interfaces.IEntry#getUri()
     */
    public String
    getUri() {
        return uri;
    }

    /**
     * Get the slugline of this article. The slugline is read from the header.
     */
    public String
    getSlugline() {
        return getText("/article/header/slugline");
    }

    public String
    getSummary() {
        return getText("/article/header/summary");
    }

    /**
     * Get the string value of the given node in the XMLDocument.
     *
     * @param xpath     XPath to the node to be retrieved.
     * @return          Text value of the node, or null if not found.
     */
    private String
    getText(String xpath) {
        String      value = null;

        try {
            value = document.getTextNode(xpath);
        } catch (XMLException e) {
            value = null;
        }

        return value;
    }

    /* (non-Javadoc)
     * @see net.sourceforge.yagsbook.encyclopedia.interfaces.IEntry#getTitle()
     */
    public String
    getTitle() {
        return getText("/article/header/title");
    }

    /* (non-Javadoc)
     * @see net.sourceforge.yagsbook.encyclopedia.interfaces.IEntry#getAuthor()
     */
    public String
    getAuthor() {
        return getText("/article/header/author/fullname");
    }

    /* (non-Javadoc)
     * @see net.sourceforge.yagsbook.encyclopedia.interfaces.IEntry#getVersion()
     */
    public String
    getVersion() {
        String      version = getText("/article/header/cvsinfo/version");

        version = version.replaceAll("\\$Revision: ", "");
        version = version.replaceAll(" \\$", "");

        return version;
    }

    /* (non-Javadoc)
     * @see net.sourceforge.yagsbook.encyclopedia.interfaces.IEntry#getDate()
     */
    public String getDate() {
        String      date = getText("/article/header/cvsinfo/date");

        date = date.replaceAll("\\$Date: ", "");
        date = date.replaceAll(" \\$", "");

        return date;
    }

    /* (non-Javadoc)
     * @see net.sourceforge.yagsbook.encyclopedia.interfaces.IEntry#getSubject()
     */
    public Topic
    getSubject() {
        String      subjectUri = getText("/article/header/topics/subject/@uri");
        String      subjectName = getText("/article/header/topics/subject");

        if (subjectUri == null) {
            subjectUri = uri;
        }

        if (subjectName == null) {
            subjectName = getTitle();
        }

        return new Topic(subjectUri, subjectName);
    }

    /* (non-Javadoc)
     * @see net.sourceforge.yagsbook.encyclopedia.interfaces.IEntry#getCategory()
     */
    public String
    getCategory() {
        return getText("/article/header/topics/category");
    }

    /* (non-Javadoc)
     * @see net.sourceforge.yagsbook.encyclopedia.interfaces.IEntry#getTopics()
     */
    public Iterator
    getTopics() {
        ArrayList   topics = document.getTopics();

        return topics.iterator();
    }

    /* (non-Javadoc)
     * @see net.sourceforge.yagsbook.encyclopedia.interfaces.IEntry#getReferences()
     */
    public Iterator
    getReferences() {
        ArrayList   references = document.getReferences();

        return references.iterator();
    }

    /**
     * True if this is the top level parent article of a given subject.
     */
    public boolean
    isParent() {
        return getSubject().equals(getUri());
    }

    /**
     * Return the first character of the title of this article.
     */
    public String
    getIndex() {
        return getTitle().substring(0, 1).toLowerCase();
    }

    /**
     * Return the first character of the URI of this article.
     *
     * @return      One character string to use as an index.
     */
    public String
    getUriIndex() {
        return getUri().substring(0, 1).toLowerCase();
    }

    public String
    toHTML() {
        if (stylesheet != null) {
            document.setStylesheet(stylesheet);
        }
        document.setProperties(properties);
        return document.stylesheet();
    }

    public void
    setStylesheet(String stylesheet) {
        this.stylesheet = stylesheet;
    }

    public void
    setProperty(String name, String value) {
        properties.setProperty(name, value);
    }

    public void setProperties(Properties prop) {
        properties = prop;
    }
}
