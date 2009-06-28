/*
 * Copyright (C) 2002 Samuel Penn, sam@glendale.org.uk
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation version 2.
 * See the file COPYING.
 *
 * $Revision: 1.13 $
 * $Date: 2005/10/29 11:29:17 $
 */

package net.sourceforge.yagsbook.encyclopedia;

import java.util.*;
import java.io.*;

import org.w3c.dom.*;

import net.sourceforge.yagsbook.encyclopedia.interfaces.IEntry;
import net.sourceforge.yagsbook.xml.*;

/**
 * Class for generating an index page within an Encyclopedia. Generates
 * sidebar text for links to main categories, and also all the index
 * entries for the current index.
 *
 * @author Samuel Penn
 */
public class MainPage extends XMLDocument {
    FileWriter      writer = null;
    String          title = null;
    Properties      stats = new Properties();
    Repository      repository = null;

    public
    MainPage(File configuration) throws XMLException {
        super(configuration);
    }

    /**
     * Set a statistic to be displayed in the sidebar.
     *
     * @param stat      Display name of the statistic.
     * @param value     Value of the statistic.
     */
    public void
    setStatistic(String stat, int value) {
        stats.setProperty(stat, ""+value);
    }

    /**
     * Set the repository of all documents. This is used for
     * building the catalogue on the front page.
     */
    public void
    setRepository(Repository repository) {
        this.repository = repository;
    }

    public void
    open(String pathname) throws IOException {
        writer = new FileWriter(pathname);
    }

    public void
    close() throws IOException {
        writer.close();
    }

    public void
    setTitle(String title) {
        this.title = title;
    }

    public String
    getTitle() throws XMLException {
        String text = getTextNode("/configuration/title");
        if (title != null) {
            text =  text + " ("+title+")";
        }
        return text;
    }

    public String
    getCounterHref() {
        String      text = null;

        try {
            text = getTextNode("/configuration/website/counter/@href");
        } catch (XMLException e) {
            text = null;
        }

        return text;
    }

    public String
    getHomepageHref() {
        String      text = null;

        try {
            text = getTextNode("/configuration/website/homepage/@href");
        } catch (XMLException e) {
            text = null;
        }

        return text;
    }

    private void
    outputTopicLink(String name, String uri) throws IOException {
        String      href = uri + ".html";

        writer.write("<a href=\""+href+"\">"+name+"</a>");
        writer.write("<br/>\n");
    }

    public void
    write(String text) throws IOException {
        writer.write(text);
    }

    public void
    writeln(String text) throws IOException {
        writer.write(text+"\n");
    }

    private void writeMetaTag(String tag, String content) throws IOException {
        writer.write("<meta name=\""+tag+"\" content=\""+content+"\"/>");
    }

    public void
    writeHeader() throws IOException, XMLException {
        if (writer == null) {
            return;
        }

        writer.write("<html>\n<head>\n<title>");
        writer.write(getTitle());
        writer.write("</title>\n");

        writer.write("<meta name=\"title\"");
        writer.write(" content=\"");
        writer.write(getTitle());
        writer.write("\"/>\n");

        writer.write("<link rel=\"stylesheet\" ");
        writer.write("media=\"screen\" ");
        writer.write("type=\"text/css\" ");
        writer.write("href=\"/usr/share/css/default.css\" />\n");

        writer.write("<link rel=\"stylesheet\" ");
        writer.write("media=\"screen\" ");
        writer.write("type=\"text/css\" ");
        writer.write("href=\"/usr/share/css/encyclopedia.css\" />\n");

        writer.write("<!-- ALTERNATIVE_STYLESHEETS -->\n");

        writer.write("</head>\n");
        writer.write("<body>\n");

        writer.write("<div class=\"header\">\n");
        writer.write("<h1>"+getTitle()+"</h1>\n");
        writer.write("</div>\n");

        writer.write("<div class=\"sidebar\">\n");
        writer.write("<h2>Topics</h2>\n");

        NodeList    list = getNodeList("/configuration/topicsets/topicset");
        for (int i=0; i < list.getLength(); i++) {
            Node    node = list.item(i);
            String  name = getTextNode(node, "@name");

            writer.write("<h3>"+name+"</h3>\n");
            writer.write("<p>\n");

            NodeList    topics = getNodeList(node, "./topic");
            for (int t=0; t < topics.getLength(); t++) {
                Node    topic = topics.item(t);
                String  text = getTextNode(topic);
                String  uri = getTextNode(topic, "@uri");

                outputTopicLink(text, uri);
            }

            writer.write("</p>\n");
        }

        writer.write("<h3>Statistics</h3>");
        writer.write("<p>");
        Enumeration     e = stats.propertyNames();
        while (e.hasMoreElements()) {
            String  prop = (String)e.nextElement();
            String  value = stats.getProperty(prop, "0");

            writer.write(prop+": "+value+"<br/>");
        }

        writer.write("<a href=\"missingLinks.html\">Missing articles</a><br/>");
        writer.write("</p>");

        writer.write("</div>\n\n");

        writer.write("<div class=\"bodytext\">\n");

    }

    public String
    getHref(String path, IEntry entry) {
        return "<a href=\""+path+entry.getUriIndex()+"/"+
                entry.getUri()+".html\">"+entry.getTitle()+"</a>";
    }


    public void
    writeEntry(IEntry entry, boolean indent) throws IOException {
        if (indent) {
            writer.write("<p class=\"indent\">");
        } else {
            writer.write("<p>\n");
        }
        writer.write(getHref("", entry));
        if (entry.getSlugline().length()>0) {
            writer.write(", <em>"+entry.getSlugline()+"</em>\n");
        }
        writer.write("</p>\n");
    }

    /**
     * Get the body text for the front page from the configuration file.
     * All paragraph elements are retrieved and returned as an XHTML string.
     *
     * @return      XHTML string of paragraph elements.
     */
    public String
    getBody() {
        StringBuffer        buffer = new StringBuffer();
        NodeList            list = null;

        try {
            list = getNodeList("/configuration/body/p");
            for (int i=0; i < list.getLength(); i++) {
                Node    node = list.item(i);

                buffer.append("<p>");
                buffer.append(getTextNode(node));
                buffer.append("</p>");
            }
        } catch (XMLException e) {
            e.printStackTrace();
        }

        return buffer.toString();
    }

    /**
     * Generate the front page of this encyclopedia. The text for the
     * description of the encyclopedia is taken from the configuration file,
     * the rest of the topics and category information is as for other
     * index pages within the encyclopedia.
     * <br/>
     * The index page is always called 'index.html'.
     */
    public void
    createFrontPage(File directory) throws IOException, XMLException {
        open(directory.getPath()+"/index.html");
        setTitle(null);
        writeHeader();
        writer.write(getBody());

        if (getHomepageHref() != null) {
            writer.write("<p>");
            writer.write("<a href=\""+getHomepageHref()+"\">Back</a>");
            writer.write("</p>");
        }

        listCategories();

        writer.write("</div>");

        if (getCounterHref() != null) {
            writer.write("<img src=\""+getCounterHref()+
                         "\" width=\"0\" height=\"0\"/>");
        }
        writer.write("</body>");
        writer.write("</html>");
        close();
    }

    public void
    listCategories() throws XMLException, IOException {
        if (repository == null) {
            return;
        }

        // Need to build a table of all entries, sorted by category.
        // Find the 'all' index, and pull out a list of all the entries.
        // Then do a bucket sort into our Hashtable.
        Hashtable   table = new Hashtable();
        Iterator    iter = repository.indexIterator();
        Index       index = null;
        while (iter.hasNext()) {
            index = (Index)iter.next();

            if (index.toString().equals("all")) {
                // Have found what we are looking for.
                break;
            }
            index = null;
        }
        if (index == null) {
            // No entries to create categories for. Nothing to do.
            return;
        }
        iter = index.iterator();
        while (iter.hasNext()) {
            IEntry  entry = (IEntry)iter.next();
            Vector  v = (Vector)table.get(entry.getCategory());
            if (v == null) {
                v = new Vector();
                table.put(entry.getCategory(), v);
            }
            v.add(entry);
        }

        writer.write("<div class=\"categories\">\n");
        /*
        writer.write("<h1 class=\"heading\">Articles by Category</h1>\n");
        */

        NodeList    list = getNodeList("/configuration/categories/category[@name]");
        for (int i=0; i < list.getLength(); i++) {
            Node    node = list.item(i);
            String  category = getTextNode(node);

            listCategory(table, node, 1);
        }

        if (!table.isEmpty()) {
            writer.write("<h2>Other</h2>\n");

            Enumeration e = table.keys();
            while (e.hasMoreElements()) {
                String  category = (String)e.nextElement();
                Vector  v = (Vector)table.get(category);

                writer.write("<p>\n");
                writer.write("<b>" + category + "</b>");
                writer.write(" ("+v.size()+"):");

                for (int i=0; i < v.size(); i++) {
                    writeEntry((IEntry)v.elementAt(i));
                    if (i < v.size()-1) {
                        writer.write("; ");
                    }
                }
                writer.write("</p>\n");
            }

        }
        writer.write("</div>\n");
    }

    public void
    listCategory(Hashtable table, Node category, int depth) throws XMLException, IOException {
        if (depth < 1) depth = 1;
        if (depth > 5) depth = 5;

        String name = getTextNode(category, "@name");
        String title = getTextNode(category, "title");

        writer.write("<h"+depth+">"+title+"</h"+depth+">\n");
        writeList(name, table);

        NodeList list = getNodeList(category, "category");

        for (int i=0; i < list.getLength(); i++) {
            Node    node = list.item(i);
            String  child = getTextNode(node);
            listCategory(table, node, depth+1);
        }
    }

    public void writeList(String category, Hashtable table) throws IOException {
        Vector      v = (Vector) table.get(category);
        if (v == null) {
            return;
        }

        writer.write("<p>\n");
        for (int i=0; i < v.size(); i++) {
            IEntry      entry = (IEntry) v.elementAt(i);
            writeEntry(entry);
            //writer.write(entry.getTitle());
            if (i < v.size()-1) {
                writer.write("; ");
            }
        }
        writer.write("</p>\n");

        // We need to know at the end what is left, so remove anything
        // that we've actually used.
        table.remove(category);
    }

    public void writeEntry(IEntry entry) throws IOException {
        String      url = entry.getUri().substring(0, 1)+"/"+entry.getUri()+".html";
        writer.write("<a href=\"");
        writer.write(url);
        writer.write("\">");
        writer.write(entry.getTitle());
        writer.write("</a>");
    }

    public static void
    main(String[] args) {
        try {
            MainPage    page = new MainPage(new File("config.xml"));

            page.open("foo.html");
            page.writeHeader();
            page.listCategories();
            page.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

}
