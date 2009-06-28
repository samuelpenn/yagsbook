/*
 * Copyright (C) 2004 Samuel Penn, sam@glendale.org.uk
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation version 2.
 * See the file COPYING.
 *
 * $Revision: 1.2 $
 * $Date: 2005/04/10 11:43:00 $
 */
package net.sourceforge.yagsbook.encyclopedia.tests;

import net.sourceforge.yagsbook.encyclopedia.indexing.Reference;
import net.sourceforge.yagsbook.encyclopedia.indexing.Topic;

/**
 * Create a mock Yagsbook Article for testing purposes.
 */
public class MockArticle {
    private String      title = "Article";
    private String      author = "Samuel Penn";
    private String      authorEmail = "sam@somewhere.org";
    private String      version = "$Revision: 1.2 $";
    private String      date = "$Date: 2004/05/31 22:09:39";
    private String      slugline = "a test article";
    private String      tagline = "Mock article test suite";
    private String      summary = "A mock summary of a mock article.";
    private String      licenseYear = "2004";
    private String      licenseHolder = "Samuel Penn";
    private String      licenseUrl = "http://www.gnu.org";
    private String      licenseText = "Licensed under the FDL";
    private String      style = "module";
    private String      body = "<sect1><title>Hello World</title>"+
                               "<para>This is a test</para></sect1>";
    private String      category = "Test";
    private Topic       subject = new Topic("test", "Test");
    private Reference[] references = null;
    private Topic[]     topics = null;
                               
    MockArticle() {
    }
    
    MockArticle(String title) {
        this.title = title;
    }
    
    void
    setTitle(String title) {
        this.title = title; 
    }
    
    void
    setAuthor(String author) {
        this.author = author;
    }
    
    void
    setAuthorEmail(String authorEmail) {
        this.authorEmail = authorEmail;
    }
    
    void
    setVersion(String version) {
        this.version = version;
    }
    
    void
    setDate(String date) {
        this.date = date;
    }
        
    void
    setSlugline(String slugline) {
        this.slugline = slugline;
    }
    
    void
    setTagline(String tagline) {
        this.tagline = tagline;
    }
    
    void
    setSummary(String summary) {
        this.summary = summary;
    }
    
    void
    setLicenseYear(String year) {
        this.licenseYear = year;
    }
    
    void
    setLicenseHolder(String holder) {
        this.licenseHolder = holder;
    }
    
    void
    setLicenseUrl(String url) {
        this.licenseUrl = url;
    }
    
    void
    setLicenseText(String text) {
        this.licenseText = text;
    }
    
    void
    setStyle(String style) {
        this.style = style;
    }
    
    void
    setCategory(String category) {
        this.category = category;
    }
    
    void
    setSubject(Topic subject) {
        this.subject = subject;
    }
    
    void
    setReferences(Reference[] references) {
        this.references = references;
    }
    
    void
    setTopics(Topic[] topics) {
        this.topics = topics;
    }
    
    void
    setBody(String body) {
        this.body = body;
    }
    
    public String
    toXML() {
        StringBuffer    buffer = new StringBuffer();
        
        buffer.append("<?xml version=\"1.0\"?>");
        
        buffer.append("<article>");
        
        buffer.append("<header>");
        buffer.append("<title>"+title+"</title>");
        buffer.append("<tagline>"+tagline+"</tagline>");
        buffer.append("<slugline>"+slugline+"</slugline>");
        buffer.append("<summary>"+summary+"</summary>");
        
        buffer.append("<author>");
        buffer.append("<fullname>"+author+"</fullname>");
        buffer.append("<email>"+authorEmail+"</email>");
        buffer.append("</author>");
        
        buffer.append("<cvsinfo>");
        buffer.append("<version>"+version+"</version>");
        buffer.append("<date>"+date+"</date>");
        buffer.append("</cvsinfo>");
        
        buffer.append("<license>");
        buffer.append("<year>"+licenseYear+"</year>");
        buffer.append("<holder>"+licenseHolder+"</holder>");
        buffer.append("<url>"+licenseUrl+"</url>");
        buffer.append("<text>"+licenseText+"</text>");
        buffer.append("</license>");
        
        buffer.append("<references>");
        if (references != null) {
            for (int i=0; i < references.length; i++) {
                buffer.append("<see uri=\"");
                buffer.append(references[i].getUri());
                buffer.append("\">");
                buffer.append(references[i].getName());
                buffer.append("</see>");
            }
        }
        buffer.append("</references>");
        
        buffer.append("<topics>");
        buffer.append("<subject uri=\""+subject.getUri()+"\">");
        buffer.append(subject.getName()+"</subject>");
        buffer.append("<category>"+category+"</category>");
        if (topics != null) {
            for (int i=0; i < topics.length; i++) {
                buffer.append("<topic uri=\"");
                buffer.append(topics[i].getUri());
                buffer.append("\">");
                buffer.append(topics[i].getName());
                buffer.append("</topic>");
            }
        }
        buffer.append("</topics>");
        
        buffer.append("<style name=\""+style+"\"/>");
        
        buffer.append("</header>");
        
        buffer.append("<body>");
        buffer.append(body);
        buffer.append("</body>");
        buffer.append("</article>");
        
        return buffer.toString();
    }
}
