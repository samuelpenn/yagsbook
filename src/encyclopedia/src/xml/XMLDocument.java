/*
 * Copyright (C) 2002 Samuel Penn, sam@glendale.org.uk
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation version 2.
 * See the file COPYING.
 *
 * $Revision: 1.8 $
 * $Date: 2009/06/28 09:43:08 $
 */

package net.sourceforge.yagsbook.xml;


import java.io.*;
import java.util.Enumeration;
import java.util.Properties;

import org.apache.xpath.XPathAPI;
import org.w3c.dom.*;
import org.xml.sax.InputSource;

import javax.xml.parsers.*;
import javax.xml.transform.*;
import javax.xml.transform.stream.*;
import javax.xml.transform.dom.*;


public class XMLDocument {
    private Document    document;
    private String      stylesheet = "/usr/share/xml/yagsbook/article/xslt/html/encyclopedia.xsl";
    private String      documentPath = null;
    private String      documentContent = null;
    private Properties  properties = null;

    public
    XMLDocument(String content) throws XMLException {
        documentPath = "-";
        documentContent = content;
        load(content);
    }

    public
    XMLDocument(File file) throws XMLException {
        documentPath = file.getAbsolutePath();
        load(file);
    }

    /**
     * Initiate a new DOM document from a file, without using
     * namespaces. Namespaces are not used because XPathAPI has
     * some big problems with them. The internal document is
     * internally set equal to the one returned.
     */
    protected Document
    load(File file) throws XMLException {
        document = load(file, false);

        return document;
    }

    /**
     * Initiate a new DOM document from a file. Namespaces are
     * optional. Importantly, this call does not set the document
     * used internally by the class.
     */
    private Document
    load(File file, boolean useNamespace) throws XMLException {
        Document    doc = null;

        try {
            InputSource             in;
            DocumentBuilderFactory  dbf;
            Node                    node;
            NodeList                nodeList;

            in = new InputSource(new FileInputStream(file));
            dbf = DocumentBuilderFactory.newInstance();
            dbf.setNamespaceAware(useNamespace);

            doc = dbf.newDocumentBuilder().parse(in);
        } catch (Exception e) {
            System.out.println("Failed to process document ["+documentPath+"]");
            e.printStackTrace();
        }

        return doc;
    }

    /**
     * Initiate a new DOM document from a string, without using
     * namespaces. Namespaces are not used because XPathAPI has
     * some big problems with them. The internal document is
     * internally set equal to the one returned.
     */
    protected Document
    load(String content) throws XMLException {
        document = load(content, false);

        return document;
    }

    /**
     * Initiate a new DOM document from a string. Namespaces are
     * optional. Importantly, this call does not set the document
     * used internally by the class.
     */
    private Document
    load(String content, boolean useNamespace) throws XMLException {
        Document    doc = null;

        try {
            InputSource             in;
            DocumentBuilderFactory  dbf;
            Node                    node;
            NodeList                nodeList;

            in = new InputSource(new StringReader(content));
            dbf = DocumentBuilderFactory.newInstance();
            dbf.setNamespaceAware(useNamespace);

            doc = dbf.newDocumentBuilder().parse(in);
        } catch (Exception e) {
            System.out.println("Failed to process document ["+documentPath+"]");
            e.printStackTrace();
        }

        return doc;
    }

    private Node
    _getNameSpace() throws TransformerException {
        return XPathAPI.selectNodeList(document, "//namespace::*").item(1);
    }

    /**
     * Return the node of the root document defined by the
     * xpath query. Since this uses the XPathAPI, it is not
     * guaranteed to be efficient.
     *
     * @param xpath     XPath query to requested node.
     * @return          First matching node. May be null.
     */
    protected Node
    getNode(String xpath) throws XMLException {
        return getNode(document, xpath);
    }

    /**
     * Return the descendent of the provided node, described
     * by the xpath query. This uses the XPathAPI, so is not
     * likely to be efficient.
     *
     * @param root      Node to perform the search on.
     * @param xpath     XPath to look for.
     * @return          First matching node. May be null.
     */
    protected Node
    getNode(Node root, String xpath) throws XMLException {
        Node        node = null;
        try {
            node = XPathAPI.selectSingleNode(root, xpath);
        } catch (TransformerException te) {
            throw new XMLException("Cannot find node");
        }

        return node;
    }

    /**
     * Gets a list of nodes from the root document described
     * by the xpath. All matching nodes will be returned. This
     * uses the XPathAPI so isn't necessarily efficient.
     *
     * @param xpath     XPath to search for.
     * @return          List of matching nodes. May be null.
     */
    protected NodeList
    getNodeList(String xpath) throws XMLException {
        return getNodeList(document, xpath);
    }

    /**
     * Gets a list of nodes described by the XPath string,
     * searching down from the supplied node. All matching
     * nodes will be returned. This uses the XPathAPI, so
     * isn't efficient.
     *
     * @param root      Root node to search from.
     * @param xpath     Xpath to search for.
     * @return          List of matching nodes. May be null.
     */
    protected NodeList
    getNodeList(Node root, String xpath) throws XMLException {
        NodeList        list = null;
        try {
            list = XPathAPI.selectNodeList(root, xpath);
        } catch (TransformerException te) {
            throw new XMLException("Cannot find nodelist");
        }

        return list;
    }

    public String
    getTextNode(String xpath) throws XMLException {
        return getTextNode(document, xpath);
    }

    protected String
    getTextNode(Node root, String xpath) throws XMLException {
        Node        node = null;
        String      text = null;

        if (root == null) {
            throw new XMLException("Root node is null");
        }

        try {
            node = XPathAPI.selectSingleNode(root, xpath);
            if (node == null) {
                text = "";
            } else if (node.getNodeType() == Node.TEXT_NODE) {
                text = getTextNode(node);
            } else if (node.getNodeType() == Node.ATTRIBUTE_NODE) {
                Attr    attr = (Attr)node;
                text = attr.getValue();
            } else {
                text = getTextNode(node);
            }
        } catch (TransformerException te) {
            throw new XMLException("Cannot find node \""+xpath+"\"");
        }

        return text;
    }

    protected String
    getTextNode(Node node) throws XMLException {
        String  text = null;

        try {
            if (node.hasChildNodes()) {
                node = node.getFirstChild();
                if (node.getNodeType() == Node.TEXT_NODE) {
                    text = node.getNodeValue();
                } else {
                    text = "";
                }
            } else {
                text = "";
            }
        } catch (Exception e) {
            throw new XMLException("Node does not have text element");
        }

        return text;
    }

    /**
     * Set the path to the stylesheet which sould be used to transform
     * the document. The stylesheet should be a path to a local file.
     *
     * @param stylesheet        Pathname to local stylesheet.
     */
    public void
    setStylesheet(String stylesheet) {
        this.stylesheet = stylesheet;
    }

    public void
    setProperties(Properties properties) {
        this.properties = properties;
    }

    public String
    stylesheet() {
        StringWriter writer = new StringWriter();
        Document     doc = null;

        try {

            if (documentContent != null) {
                doc = load(documentContent, true);
            } else {
                doc = load(new File(documentPath), true);
            }

            File    xsltFile = new File(stylesheet);
            javax.xml.transform.Source  xslt = new StreamSource(xsltFile);

            javax.xml.transform.Source  xml = new DOMSource(doc);
            javax.xml.transform.Result  html = new StreamResult(writer);

            TransformerFactory fact = TransformerFactory.newInstance();
            Transformer trans = fact.newTransformer(xslt);
            if (properties != null) {
                Enumeration e = properties.keys();
                while (e.hasMoreElements()) {
                    String  key = (String)e.nextElement();
                    String  value = properties.getProperty(key);
                    trans.setParameter(key, value);
                }
            }
            trans.transform(xml, html);

        } catch (Exception e) {
            System.out.println("Failed to process document ["+documentPath+"]");
            e.printStackTrace();
        }

        return writer.toString();
    }

    private static String
    getDocument() {
        StringBuffer    buffer = new StringBuffer();

        buffer.append("<?xml version=\"1.0\"?>");
        buffer.append("<yb:root xmlns:yb=\"http://yagsbook.sourceforge.net/test\">");
        buffer.append("<yb:text title=\"greeting\">");
        buffer.append("Hello world");
        buffer.append("</yb:text>");
        buffer.append("</yb:root>");

        return buffer.toString();
    }

    public static void
    main(String[] args) throws Exception {
        XMLDocument doc = new XMLDocument(getDocument());

        NodeList    list = XPathAPI.selectNodeList(doc.document, "//namespace::yb");
        System.out.println(list.getLength());
        for (int i=0; i < list.getLength(); i++) {
            Node n = list.item(i);
            System.out.println("Got "+i+" for "+n.getNodeValue());
        }

        Node node = XPathAPI.selectSingleNode(doc.document, "/yb:root/yb:text", list.item(0));
        if (node != null) {
            System.out.println(node.getNodeValue());
        } else {
            System.out.println("No node found");
        }
        //System.out.println(doc.getTextNode("/yb:root/yb:text"));
    }
}
