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

import net.sourceforge.yagsbook.encyclopedia.indexing.Topic;
import net.sourceforge.yagsbook.encyclopedia.interfaces.IEntry;

/**
 * An index holds a record of all entries which belong in that index.
 * It can be used to generate an HTML list of all entries, sorted
 * alphabetically.
 * 
 * @author Samuel Penn.
 */
public class Index {
    private String      name;
    private String      title;
    private TreeSet     set;
    
    

    /**
     * Comparator to sort by the URI of an IEntry.
     * 
     * @author Samuel Penn.
     */
    private class FileCompare implements Comparator {
        public int
        compare(Object o1, Object o2) {
            IEntry    e1 = (IEntry)o1;
            IEntry    e2 = (IEntry)o2;

            return e1.getUri().compareTo(e2.getUri());
        }
    }

    /**
     * Comparator to sort by the title of an IEntry.
     * 
     * @author Samuel Penn.
     */
    private class TitleCompare implements Comparator {
        public int
        compare(Object o1, Object o2) {
            IEntry    e1 = (IEntry)o1;
            IEntry    e2 = (IEntry)o2;

            return e1.getTitle().compareTo(e2.getTitle());
        }
    }

    /**
     * Create a new index ready to receive entries.
     * 
     * @param name      Unique name of this index.
     * @param title     Descriptive name of this index.
     */
    public
    Index(String name, String title) {
        this.name = name;
        this.title = title;
        set = new TreeSet(new TitleCompare());
    }

    public String
    toString() {
        return name;
    }

    /**
     * Get the descriptive title of this index.
     * @return      Descriptive title.
     */
    public String
    getTitle() {
        return title;
    }

    /**
     * Add an entry to the index. The entry should be unique according to the
     * URI of the entry. If the entry is not unique, it will be discarded.
     * 
     * @param entry     Entry to be added.
     */
    public void
    add(IEntry entry) {
        if (getEntry(entry.getUri()) == null) {
            set.add(entry);
        }
    }

    public IEntry
    getEntry(String uri) {
        Iterator iter = set.iterator();
        while (iter.hasNext()) {
            IEntry entry = (IEntry)iter.next();
            if (entry.getUri().equals(uri)) {
                return entry;
            }
        }

        return (IEntry)null;
    }

    public Iterator
    iterator() {
        return set.iterator();
    }

    public int
    size() {
        return set.size();
    }

    public void
    dump() {
        System.out.println(name+":");

        Iterator iter = set.iterator();
        while (iter.hasNext()) {
            IEntry entry = (IEntry)iter.next();
            System.out.println("    "+entry.getUri()+" ("+entry.getTitle()+")");
        }
    }
    
    
    private Hashtable       subjectList = null;
    /**
     * Build an index for each subject referenced in the index. Subjects
     * which only appear once (i.e., only the subject article itself)
     * are not included in this index.
     */
    private void
    buildSubjectIndex() {
        Iterator        iter = set.iterator();

        subjectList = new Hashtable();
        
        while (iter.hasNext()) {
            IEntry      entry = (IEntry) iter.next();
            String      subject = entry.getSubject().getUri();
            String      uri = entry.getUri();
            TreeSet     subjectSet = (TreeSet) subjectList.get(subject);
            
            if (subjectSet == null) {
                subjectSet = new TreeSet();
                subjectList.put(subject, subjectSet);
            }
            subjectSet.add(new Topic(uri, entry.getTitle()));
        }
    }

    /**
     * Return all entries in this index which match a given subject.
     */
    public Iterator
    getBySubject(Topic subject, boolean includeParent) {
        Iterator        iter = null;
        
        if (subjectList == null) {
            buildSubjectIndex();
        }

        TreeSet     subjectSet = (TreeSet)subjectList.get(subject.getUri());
        
        if (subjectSet == null) {
            iter = new Vector().iterator();
        } else {
            iter = subjectSet.iterator();
        }
        
        Vector      vector = new Vector();
        while (iter.hasNext()) {
            Topic   topic = (Topic)iter.next();
            IEntry  entry = getEntry(topic.getUri());
            if (!includeParent && entry.getUri().equals(subject.getUri())) {
                continue;
            }
            vector.add(entry);
        }

        return vector.iterator();
    }

    public Iterator
    OLDgetBySubject(Topic subject, boolean includeParent) {
        Vector  vector = new Vector();

        Iterator    iter = set.iterator();
        while (iter.hasNext()) {
            IEntry entry = (IEntry)iter.next();
            if (entry.getSubject().equals(subject)) {
                if (!includeParent && entry.getSubject().equals(entry.getUri())) {
                    continue;
                }
                vector.add(entry);
            }
        }

        return vector.iterator();
    }
    
    public static void
    main(String args[]) {
        TreeSet     set = new TreeSet();
        
        set.add("a");
        set.add("c");
        set.add("e");
        set.add("d");
        set.add("b");
        
        Iterator        i = set.iterator();
        while (i.hasNext()) {
            String  s = (String)i.next();
            System.out.println(s);
        }
    }
}
