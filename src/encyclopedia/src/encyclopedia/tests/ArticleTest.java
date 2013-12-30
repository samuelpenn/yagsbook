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

import java.io.*;
import java.util.Iterator;

import net.sourceforge.yagsbook.encyclopedia.articles.Article;
import net.sourceforge.yagsbook.encyclopedia.indexing.Reference;
import net.sourceforge.yagsbook.encyclopedia.indexing.Topic;
import junit.framework.TestCase;

/**
 * @author sam
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class ArticleTest extends TestCase {

    /**
     * Constructor for ArticleTest.
     * @param arg0
     */
    public ArticleTest(String arg0) {
        super(arg0);
    }

    /**
     * Very simple test to ensure that a MockArticle can be loaded and parsed.
     *
     */
    public void
    testArticle() {
        MockArticle     mock = new MockArticle();
        
        try {
            Article     article = new Article("test", mock.toXML());        
        } catch (IOException e) {
            fail("Failed to parse article");
        }
    }

    public void
    testGetUri() {
        MockArticle     mock = new MockArticle();
        
        try {
            Article     article = new Article("test", mock.toXML());
            assertEquals("Value of returned URI was unexpected", "test",
                        article.getUri());
        } catch (IOException e) {
            fail("Failed to parse article");
        }
    }

    public void
    testGetTitle() {
        final String    TITLE = "Test Article";
        
        MockArticle     mock = new MockArticle();
        mock.setTitle(TITLE);
        try {
            Article     article = new Article("test", mock.toXML());
            assertEquals("Value of returned title was wrong", TITLE,
                         article.getTitle());
        } catch (IOException e) {
            fail("Failed to parse article");
        }
    }

    public void
    testGetAuthor() {
        final String    AUTHOR = "Some Author";
        
        MockArticle     mock = new MockArticle();
        mock.setAuthor(AUTHOR);
        try {
            Article     article = new Article("test", mock.toXML());
            assertEquals("Value of returned author was wrong", AUTHOR,
                         article.getAuthor());
        } catch (IOException e) {
            fail("Failed to parse article");
        }
    }

    /**
     * Test getting the version. Version strings are stored as CVS revision
     * tags in the XML, but should be returned as a simple dotted decimal
     * version number from the getVersion() call.
     */
    public void
    testGetVersion() {
        final String    VERSION = "1.5";
        
        MockArticle     mock = new MockArticle();
        mock.setVersion("$Revision: 1.2 $");
        
        try {
            Article     article = new Article("test", mock.toXML());
            assertEquals("Value of returned version was wrong", VERSION,
                         article.getVersion());
        } catch (IOException e) {
            fail("Failed to parse article");
        }
    }

    /**
     * Test getting the date. Dates are stored as CVS date tags within the
     * XML, so any getDate() call should strip out the CVS tag and just return
     * a simple date.
     */
    public void
    testGetDate() {
        final String    DATE = "2004/06/01 08:52:48";
        
        MockArticle     mock = new MockArticle();
        mock.setDate("$Date: 2005/04/10 11:43:00 $");
        
        try {
            Article     article = new Article("test", mock.toXML());
            assertEquals("Value of returned version was wrong", DATE,
                         article.getDate());
        } catch (IOException e) {
            fail("Failed to parse article");
        }
    }

    public void
    testGetSubject() {
        final String    URI = "test";
        final String    NAME = "Test Subject";
        
        MockArticle     mock = new MockArticle();
        mock.setSubject(new Topic(URI, NAME));
        
        try {
            Article     article = new Article("test", mock.toXML());
            
            Topic       subject = article.getSubject();
            assertEquals("Subject has wrong uri", URI, subject.getUri());
            assertEquals("Subject has wrong name", NAME, subject.getName());
        } catch (IOException e) {
            fail("Failed to parse article");
        }
    }

    public void
    testGetCategory() {
        final String    CATEGORY = "Unit test";
        
        MockArticle     mock = new MockArticle();
        mock.setCategory(CATEGORY);
        
        try {
            Article     article = new Article("test", mock.toXML());
            assertEquals("Value of returned category was wrong", CATEGORY,
                         article.getCategory());
        } catch (IOException e) {
            fail("Failed to parse article");
        }
    }

    public void
    testGetTopics() {
        final String    URI = "test";
        final String    NAME = "Test Subject ";
        final int       NUMBER = 10;
        
        MockArticle     mock = new MockArticle();
        
        Topic[]         topics = new Topic[NUMBER];
        for (int i=0; i < NUMBER; i++) {
            topics[i] = new Topic(URI+i, NAME+i);
        }
        mock.setTopics(topics);
        
        try {
            Article     article = new Article("test", mock.toXML());
            Iterator    iter = article.getTopics();
            
            int count = 0;
            while (iter.hasNext()) {
                Topic   topic = (Topic) iter.next();
                
                if (count >= NUMBER) {
                    fail("Too many topics returned");
                }
                assertEquals("Topic uri "+count+" was wrong",
                             topics[count].getUri(), topic.getUri());
                assertEquals("Topic name "+count+" was wrong",
                             topics[count].getName(), topic.getName());
                count++;
            }
            assertEquals("Too few topics returned", NUMBER, count);
        } catch (IOException e) {
            fail("Failed to parse article");
        }
    }

    /**
     * Test both hard and soft references. References are inserted into the
     * document header and into the body of the document, and they should be
     * returned correctly in order.
     */
    public void
    testGetReferences() {
        final String    URI = "test";
        final String    NAME = "Test Subject ";
        final int       HARD = 10;
        final int       SOFT = 10;
        final int       NUMBER = HARD + SOFT;
        
        MockArticle     mock = new MockArticle();
        
        Reference[]     hard = new Reference[HARD];
        for (int i=0; i < HARD; i++) {
            hard[i] = new Reference("hard-"+URI+i, NAME+i, true);
        }
        mock.setReferences(hard);
        Reference[]     soft = new Reference[HARD];
        for (int i=0; i < SOFT; i++) {
            soft[i] = new Reference("hard-"+URI+i, NAME+i, false);
        }
        
        StringBuffer    body = new StringBuffer();
        body.append("<sect1><title>Reference test</title>");
        for (int i=0; i < SOFT; i++) {
            body.append("<para>This is a ");
            body.append("<qv uri=\""+soft[i].getUri()+"\">");
            body.append(soft[i].getName()+"</qv>");
            body.append("</para>");
        }
        body.append("</sect1>");
        mock.setBody(body.toString());
        
        try {
            Article     article = new Article("test", mock.toXML());
            Iterator    iter = article.getReferences();
            
            if (!iter.hasNext()) {
                fail("Did not find any references");
            }
            
            for (int i = 0; i < HARD; i++) {
                if (!iter.hasNext()) {
                    fail("Failed to find all hard references");
                }
                Reference   reference = (Reference) iter.next();
                
                assertEquals("Hard reference uri "+i+" was wrong",
                             hard[i].getUri(), reference.getUri());
                assertEquals("Hard reference name "+i+" was wrong",
                             hard[i].getName(), reference.getName());
                assertEquals("Hard reference uri "+i+" was soft",
                             true, reference.isHard());
            }
            
            if (!iter.hasNext()) {
                fail("Did not find any soft references");
            }
            for (int i = 0; i < SOFT; i++) {
                if (!iter.hasNext()) {
                    fail("Failed to find all soft references");
                }
                Reference   reference = (Reference) iter.next();
                
                assertEquals("Soft reference uri "+i+" was wrong",
                             soft[i].getUri(), reference.getUri());
                assertEquals("Soft reference name "+i+" was wrong",
                             soft[i].getName(), reference.getName());
                assertEquals("Soft reference uri "+i+" was hard",
                             false, reference.isHard());
            }
            if (iter.hasNext()) {
                fail("Too many references returned");
            }
        } catch (IOException e) {
            fail("Failed to parse article");
        }
    }

}
