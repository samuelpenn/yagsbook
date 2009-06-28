/*
 * Copyright (C) 2004 Samuel Penn, sam@glendale.org.uk
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation version 2.
 * See the file COPYING.
 *
 * $Revision: 1.3 $
 * $Date: 2005/04/10 11:43:00 $
 */
package net.sourceforge.yagsbook.encyclopedia.interfaces;

import java.io.*;
import java.util.Iterator;

/**
 * Interface for document sources. A Source is anything which provides
 * articles to an Encyclopedia. A very basic Source might read files
 * from the local filesystem. In theory however, a Source could obtain
 * articles from CVS, WebDav, SOAP or a database for example.
 * 
 * @author Samuel Penn
 */
public interface ISource {
    /**
     * Get a name for the source. May be used for debugging or
     * informational purposes.
     * 
     * @return  Name of this source.
     */
    public String getName();
    
    /**
     * Get a count of the number of articles in this source.
     * @return  Total number of articles.
     */
    public int size();
    
    /**
     * Get an iterator for all the documents in the source.
     * The iterator should return objects of type IEntry.
     * If there are no items in the source, then an empty
     * iterator is returned.
     * 
     * @return  An iterator over all articles. Never null.
     */
    public Iterator iterator();

    /**
     * Copy all supporting files into the specified destination. This is
     * used to copy images, maps and other required files into the target
     * build area. The files are not processed by the Encyclopedia, but
     * entries may reference them.
     * <br/>
     * Files should be copied into sub-directories of the destination.
     * For example, images may be copied into an 'images' sub directory.
     * 
     * @param destination   Destination directory into which files should
     *                      be copied. This must exist before the call is
     *                      made to the method. 
     */
    public void copySupportFiles(File destination) throws IOException;
    
    /**
     * Copy all temporary files into the specified destination. These
     * are files which are needed whilst the encyclopedia is being built,
     * but which will be deleted afterwards.
     * 
     * @param destination   Destination directory into which files should
     *                      be copied. This must exist before the call is
     *                      made to the method. 
     */
    public void copyTemporaryFiles(File destination) throws IOException;

    /**
     * Copy all source files for the entries into the specified destination.
     * 
     * @param destination   Destination to copy files into.
     */
    public void copySourceFiles(File destination) throws IOException;
    
}
