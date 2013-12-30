/*
 * Copyright (C) 2004 Samuel Penn, sam@glendale.org.uk
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation version 2.
 * See the file COPYING.
 *
 * $Revision: 1.4 $
 * $Date: 2006/02/05 17:22:56 $
 */
package net.sourceforge.yagsbook.encyclopedia.articles;

import java.io.*;
import java.util.*;

import net.sourceforge.yagsbook.encyclopedia.Log;
import net.sourceforge.yagsbook.encyclopedia.interfaces.ISource;

/**
 * Creates an encyclopedia source from a set of Yagsbook articles
 * found on a filesystem.
 */
public class FileSystemSource implements ISource {
    private File        directory = null;
    private String      name = null;

    private Vector      sources = new Vector();
    private Vector      articles = new Vector();
    private Hashtable   exceptions = new Hashtable();

    /**
     * Filter on yags articles. Articles are identified by having a .yags
     * extension. Sub directories are recursively searched, unless they
     * are CVS or hidden directories, which are ignored.
     */
    private class ArticleFilter implements FilenameFilter {
        public boolean
        accept(File dir, String file) {

            if (file.equals("CVS")) {
                return false;
            }
            if (file.startsWith(".")) {
                return false;
            }

            File f = new File(dir.getPath()+"/"+file);
            if (f.isDirectory()) {
                return true;
            }

            if (file.endsWith(".yags")) {
                return true;
            }

            return false;
        }
    }

    private class SupportFilter implements FilenameFilter {
        public boolean
        accept(File dir, String file) {
            if (file.equals("CVS")) {
                return false;
            }
            if (file.startsWith(".")) {
                return false;
            }

            File f = new File(dir.getPath()+"/"+file);
            if (f.isDirectory()) {
                return true;
            }

            if (file.endsWith(".png")) {
                return true;
            }
            if (file.endsWith(".map")) {
                return true;
            }
            return false;
        }
    }

    /**
     * Throw an exception if the provided directory cannot be used
     * to create the Source from.
     *
     * @param directory         Directory to be checked.
     * @throws IOException
     */
    private void
    checkDirectory(File directory) throws IOException {
        if (!directory.exists()) {
            throw new IOException("Directory ["+
                    directory.getAbsolutePath()+"] does not exist");
        }

        if (!directory.isDirectory()) {
            throw new IOException("Path to ["+
                    directory.getAbsolutePath()+"] is not a directory");
        }
    }

    private void
    traverse(File f) {
        File[]      files = f.listFiles((FilenameFilter)new ArticleFilter());
        int         i = 0;

        for (i=0; (files != null) && (i < files.length); i++) {
            if (files[i].isDirectory()) {
                traverse(files[i]);
            } else {
                try {
                    articles.add(new Article(files[i]));
                } catch (IOException e) {
                }
            }
        }
    }

    /**
     * Build up a list of all articles found in the base directory.
     * Directory is searched recursively for any .yags files.
     * @param file
     */
    private void
    findArticles(File file) {
        if (file == null) {
            findArticles(directory);
        } else {
            File[]      files = null;

            files = file.listFiles((FilenameFilter)new ArticleFilter());

            for (int i=0; i < files.length; i++) {
                if (files[i].isDirectory()) {
                    findArticles(files[i]);
                } else {
                    try {
                        //Log.info("Adding article ["+files[i].getPath()+"]");
                        sources.add(files[i]);
                        articles.add(new Article(files[i]));
                    } catch (IOException e) {
                        exceptions.put(files[i].getName(), e.getMessage());
                    }
                }
            }
        }
    }

    /**
     * Create a new FileSystemSource from the given directory. If the
     * provided File is not a directory, then an exception will be
     * thrown. This source will be given a name equal to the path of
     * the provided directory.
     *
     * @param directory     Directory containing articles.
     * @throws IOException
     */
    public
    FileSystemSource(File directory) throws IOException {
        checkDirectory(directory);

        this.directory = directory;
        this.name = directory.getAbsolutePath();

        findArticles(null);
    }

    /**
     * Create a new FileSystemSource from the given directory. If the
     * provided File is not a directory, then an exception will be
     * thrown.
     *
     * @param directory     Directory containing articles.
     * @param name          Name to use for this source.
     *
     * @throws IOException
     */
    public
    FileSystemSource(File directory, String name) throws IOException {
        checkDirectory(directory);

        this.directory = directory;
        this.name = name;

        findArticles(null);
    }

    /**
     * Return the name of this source.
     * @see net.sourceforge.yagsbook.encyclopedia.interfaces.ISource#getName()
     */
    public String
    getName() {
        return name;
    }

    /**
     * Get the number of articles found in this source.
     * @see net.sourceforge.yagsbook.encyclopedia.interfaces.ISource#getSize()
     */
    public int
    size() {
        return articles.size();
    }

    /**
     * Return an iterator over all the articles in this source.
     */
    public Iterator
    iterator() {
        return articles.iterator();
    }

    /**
     * Searches for all support files and adds them to the provided list.
     * The list is populated with File objects of all supported image and
     * data files which need to be copied across to the repository.
     *
     * @param list      List of File objects.
     * @param file      Directory to start searching from, or null if this
     *                  is the first call.
     */
    private void
    findSupportFiles(Vector list, File file) {
        if (file == null) {
            findSupportFiles(list, directory);
        } else {
            File[]      files = null;

            files = file.listFiles((FilenameFilter)new SupportFilter());

            for (int i=0; i < files.length; i++) {
                if (files[i].isDirectory()) {
                    findSupportFiles(list, files[i]);
                } else {
                    list.add(files[i]);
                }
            }
        }
    }

    /**
     * Copy the given file into the specified directory. The name of
     * the file is always preserved.
     *
     * @param file      The file to be copied.
     * @param path      The path to the destination directory.
     */
    private void
    copyFile(File file, File destination) throws IOException {
        String  outpath  =  destination.getPath()+"/"+file.getName();
        byte[]  data  = new byte[65536];
        int     len = 0;

        FileInputStream  fis = new FileInputStream(file);
        FileOutputStream fos = new FileOutputStream(outpath);

        while ((len = fis.read(data)) >= 0) {
            fos.write(data, 0, len);
        }

        fis.close();
        fos.close();
    }

    /**
     * Copy source XML files into the destination directory.
     *
     * @param destination       Directory to copy files into.
     * @throws IOException
     */
    public void
    copySourceFiles(File destination) throws IOException {
        checkDirectory(destination);

        for (int i=0; i < sources.size(); i++) {
            File        file = (File)sources.elementAt(i);

            copyFile(file, destination);
        }
    }

    /**
     * Copy image and map files across to the destination ready for
     * building the encyclopedia. Images go into the 'images' sub
     * directory, and maps go into the 'maps' sub directory.
     */
    public void
    copySupportFiles(File destination) throws IOException {
        checkDirectory(destination);

        Vector      list = new Vector();
        findSupportFiles(list, null);

        File    images = new File(destination.getPath()+"/images");
        images.mkdirs();
        File    source = new File(destination.getPath()+"/source");
        source.mkdirs();

        for (int i=0; i < list.size(); i++) {
            File        file = (File)list.elementAt(i);
            String      name = file.getName();

            if (name.endsWith(".png")) {
                copyFile(file, images);
            } else if (name.endsWith(".map")) {
                copyFile(file, source);
            }
        }

        return;
    }

    /**
     * Copy all temporary files across. Doesn't actually do anything.
     */
    public void
    copyTemporaryFiles(File destination) throws IOException {
        checkDirectory(destination);

        return;
    }
}
