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

import junit.framework.TestCase;
import java.io.*;
import java.util.Hashtable;
import java.util.Iterator;

import net.sourceforge.yagsbook.encyclopedia.articles.FileSystemSource;
import net.sourceforge.yagsbook.encyclopedia.interfaces.IEntry;

/**
 * @author sam
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class FileSystemSourceTest extends TestCase {
    final String[]  ARTICLES = { "Alpha", "Beta", "Gamma", "Delta", "Epsilon" };
    String          sourcePath = null;
    
    /**
     * Constructor for FileSystemSourceTest.
     * @param arg0
     */
    public FileSystemSourceTest(String arg0) {
        super(arg0);
    }

    /**
     * Setup a test environment for testing a FileSystemSource. The test
     * requires a directory filled with a number of test articles.
     */
    protected void
    setUp() throws Exception {
        MockArticle[]       articles = new MockArticle[ARTICLES.length];

        for (int i=0; i < ARTICLES.length; i++) {
            articles[i] = new MockArticle(ARTICLES[i]);
        }

        // Create a temporary file to find the temporary directory.
        File    tempFile = File.createTempFile("yagsbook", "test");
        String  tempDir = tempFile.getParent();
        sourcePath = tempDir+"/yagsbook";

        File    srcDir = new File(tempDir+"/yagsbook");
        srcDir.mkdir();
        for (int i=0; i < articles.length; i++) {
            String      name = sourcePath+"/"+ARTICLES[i].toLowerCase()+".yags";
            FileWriter  writer = new FileWriter(name);
            writer.write(articles[i].toXML()+"\n");
            writer.close();
        }
        
        // Temporary file no longer needed.
        tempFile.delete();
    }

    /*
     * Removes all the temporary files we had created.
     */
    protected void
    tearDown() throws Exception {
        File    sourceDir = new File(sourcePath);
        
        File[]  files = sourceDir.listFiles();
        for (int i=0; i < files.length; i++) {
            if (!files[i].getName().startsWith(".")) {
                files[i].delete();
            }
        }
        sourceDir.delete();
    }
    
    public void
    testLoad() throws Exception {
        FileSystemSource        source = null;

        source = new FileSystemSource(new File(sourcePath));
        assertEquals("File count in source is wrong", ARTICLES.length,
                    source.size());
        
        Hashtable   table = new Hashtable();
        for (int i=0; i < ARTICLES.length; i++) {
            String  uri = ARTICLES[i].toLowerCase();
            String  title = ARTICLES[i];
            
            table.put(uri, title);
        }
        
        Iterator    iter = source.iterator();
        while (iter.hasNext()) {
            IEntry      entry = (IEntry) iter.next();
            String      title = (String)table.get(entry.getUri());
            
            assertNotNull("Could not recognise entry ["+entry.getUri()+"]",
                            title);
            assertEquals("Title is unexpected", title, entry.getTitle());
        }
    }
    

}
