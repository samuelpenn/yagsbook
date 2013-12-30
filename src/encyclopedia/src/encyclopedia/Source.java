/*
 * Copyright (C) 2002 Samuel Penn, sam@glendale.org.uk
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation version 2.
 * See the file COPYING.
 *
 * $Revision: 1.10 $
 * $Date: 2005/04/10 11:42:56 $
 */

package net.sourceforge.yagsbook.encyclopedia;


import java.util.*;
import java.io.*;

/**
 * The source tree for all entries to potentially go into the
 * encyclopedia. Searches for all *.yags files, recursing on
 * sub directories.
 *
 * @deprecated
 */
class Source {
    private String      path;
    private Vector      list;
    
    private class Filter implements FilenameFilter {
        public boolean
        accept(File dir, String file) {

            if (file.equals("CVS")) {
                return false;
            }
            if (file.equals(".")) {
                return false;
            }
            if (file.equals("..")) {
                return false;
            }

            File f = new File(dir.getPath()+"/"+file);
            if (f.isDirectory()) {
                return true;
            }

            if (file.endsWith(".yags")) {
                return true;
            }

            if (file.endsWith(".png")) {
                return true;
            }

            return false;
        }
    }

    public
    Source(String path) throws Exception {
        this.path = path;
        this.list = new Vector();

        buildTree();
    }

    private void
    buildTree() throws Exception {
        File        file = new File(path);

        traverse(file);
        
        for (int i=0; i < list.size(); i++) {
            File f = (File)list.elementAt(i);
            //System.out.println(f.getPath());
        }
    }

    private void
    traverse(File f) {
        File[]      files = f.listFiles((FilenameFilter)new Filter());
        int         i = 0;

        for (i=0; (files != null) && (i < files.length); i++) {
            if (files[i].isDirectory()) {
                traverse(files[i]);
            } else {
                list.add(files[i]);
            }
        }
    }
    
    public Iterator
    iterator() {
        return list.iterator();
    }

    public String
    getPath() {
        return path;
    }


    public static void
    main(String args[]) {
        try {
            Source src = new Source(args[0]);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}

