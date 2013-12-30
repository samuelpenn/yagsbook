/*
 * Copyright (C) 2002 Samuel Penn, sam@glendale.org.uk
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation version 2.
 * See the file COPYING.
 *
 * $Revision: 1.6 $
 * $Date: 2005/04/10 11:43:00 $
 */

package net.sourceforge.yagsbook.encyclopedia.indexing;


/**
 * Describes a single topic for an article. Topics are nested categories
 * which a document belongs to. A single document will likely reference
 * multiple topics. For example, an article on London may belong to the
 * topics of 'England', 'Europe' and 'Earth'.
 * <br/>
 * A topic has both an uri, and a descriptive name. The uri will normally
 * point to another article which describes that topic.
 */
public class Topic extends Index implements Comparable {
    /**
     * Define a single topic.
     * 
     * @param uri       Unique URI for this topic.
     * @param name      Descriptive name for this topic.
     */
    public
    Topic(String uri, String name) {
        super(uri, name);
    }
    
    /**
     * Compare this Topic against another Topic. The titles of each
     * Topic are compared.
     */
    public int
    compareTo(Object o2) {
        Topic   t2 = (Topic)o2;
        
        return getName().compareTo(t2.getName());
    }
}
