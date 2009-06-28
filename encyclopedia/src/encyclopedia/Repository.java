/*
 * Copyright (C) 2002 Samuel Penn, sam@glendale.org.uk
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation version 2.
 * See the file COPYING.
 *
 * $Revision: 1.10 $
 * $Date: 2005/08/04 19:01:22 $
 */

package net.sourceforge.yagsbook.encyclopedia;


import java.util.*;
import java.io.*;

import net.sourceforge.yagsbook.encyclopedia.articles.FileSystemSource;
import net.sourceforge.yagsbook.encyclopedia.indexing.Topic;
import net.sourceforge.yagsbook.encyclopedia.interfaces.*;

/**
 * A Repository represents directories containing one or more source
 * files which will be used to build the Encyclopedia. Multiple source
 * directories can be added to the Repository, and all will be used to
 * build the Encyclopedia.
 * <br/>
 * A Repository should contain Yagsbook articles (identified by a '.yags'
 * filename extension, map files ('.map') and PNG image files ('.png').
 * All other files will be ignored.
 * <br/>
 * All suitable files will be read, and an Entry created for them. Files
 * may be organised underneath the Repository root in any way that is
 * useful to the author. All sub directories are searched recursively.
 * <br/>
 * As articles are added, a list of Indices are built up which organise
 * the Entries according to topic.
 *
 * @see Entry
 * @see Index
 * @see Source
 */
public class Repository {
    File            destination = null;
    Hashtable       indices;
    Vector          images;

    /**
     * Create a new, empty, repository at the specified directory. The
     * directory will be created if it does not exist.
     *
     * @param destination       Location of the repository.
     */
    public
    Repository(File destination) throws IOException {
        this.destination = destination;

        if (!destination.isDirectory() && !destination.mkdirs()) {
            throw new IOException("Unable to create repository directory");
        }

        File    entriesDir = new File(destination.getPath()+"/entries");
        if (!entriesDir.isDirectory() && !entriesDir.mkdirs()) {
            throw new IOException("Unable to create entries directory ["+
                entriesDir.getPath()+"]");
        }

        indices = new Hashtable();
        images = new Vector();

        // Set up extensions class. This is used when creating map images.
        Extensions.setSourceDir(new File(destination.getPath()+"/source"));
        Extensions.setImageDir(new File(destination.getPath()+"/images"));
    }

    /**
     * Add a source to this repository. Sources of different types can be
     * added to the same repository if required. If more than one entry has
     * the same URI, then only the first is added.
     *
     * @param source    Source of entries to be added.
     */
    public void
    add(ISource source) throws BuildException {
        // Add all the entries into the repository.
        Iterator        iter = source.iterator();
        while (iter.hasNext()) {
            IEntry      entry = (IEntry)iter.next();
            process(entry);
        }

        try {
            File    srcDir = new File(destination.getPath()+"/source");
            if (!srcDir.isDirectory()) {
                if (!srcDir.mkdir()) {
                    throw new BuildException("Unable to add source");
                }
            }
            source.copySourceFiles(srcDir);
            source.copySupportFiles(destination);
        } catch (IOException e) {
            Log.warn("Unable to copy files ("+e.getMessage()+")");
        }
    }

    private void
    process(IEntry entry) {
        Iterator    iter = entry.getTopics();

        Log.info("Processing entry ["+entry.getUri()+"/"+entry.getTitle()+"]");

        while (iter.hasNext()) {
            Topic      topic = (Topic)iter.next();
            Index      idx = (Index)indices.get(topic.getUri());

            if (idx == null) {
                idx = new Index(topic.getUri(), topic.getName());
                indices.put(topic.getUri(), idx);
            }
            idx.add(entry);
        }

        Index       all = (Index)indices.get("all");
        if (all == null) {
            all = new Index("all", "All Entries");
            indices.put("all", all);
        }
        all.add(entry);

    }


    /**
     * Get an iterator over all indices in this repository. An Index will have
     * been created for every Topic in the imported articles, plus one for the
     * 'All' topic which all articles automatically belong to.
     *
     * @return      Iterator over Index objects.
     */
    public Iterator
    indexIterator() {
        Collection      col = indices.values();

        return col.iterator();
    }

    /**
     * Get an iterator over all images in this repository.
     *
     * @return      Iterator over images.
     */
    public Iterator
    imageIterator() {
        return  images.iterator();
    }

    public File
    getOutputFile(IEntry entry) {
        File        file = null;
        String      path = null;

        path = entry.getUri().substring(0, 1).toLowerCase();
        path += "/"+entry.getUri()+".html";

        file = new File(destination.getPath()+"/entries/"+path);

        return file;
    }

    /**
     * Print out the contents of all the indices. Used for debugging purposes
     * only.
     */
    public void
    dump() {
        Enumeration    iter = indices.elements();

        while (iter.hasMoreElements()) {
            Index index = (Index)iter.nextElement();
            index.dump();
        }
    }

    public static void
    main(String args[]) throws Exception {
        Repository rep = new Repository(new File("/tmp/repository"));

        try {
            rep.add(new FileSystemSource(
                        new File("/home/sam/rpg/arsmagica/encyclopedia/src")));

            rep.dump();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
