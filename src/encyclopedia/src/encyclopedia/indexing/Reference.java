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
package net.sourceforge.yagsbook.encyclopedia.indexing;

/**
 * A reference is an index from this document to another. References
 * provide a link to further information. Unlike Topics, which link
 * together related documents, a reference is more like a hyperlink which
 * links to an unrelated document which may be of interest to the reader.
 * <br/>
 * A reference can be hard or soft. A hard reference is one defined in the
 * header of the document, and relates to the document as a whole A soft
 * reference comes from the body of a document, and relates to a minor
 * part of the document.
 */
public class Reference extends Index {
    private boolean    hard = false;
    
    /**
     * Create a new soft reference.
     * 
     * @param uri       URI of this reference.
     * @param name      Descriptive name of this reference.
     */
    public
    Reference(String uri, String name) {
        super(uri, name);
        this.hard = false;
    }
    
    /**
     * Create a new reference, defining it as either soft or hard. A hard
     * reference is specifically defined in the header of the document.
     * 
     * @param uri       URI of this reference.
     * @param name      Descriptive name of this reference.
     * @param hard      If true, this reference is defined in the header
     *                  of the document.
     */
    public
    Reference(String uri, String name, boolean hard) {
        super(uri, name);
        this.hard = hard;
    }
    
    /**
     * True if this is a hard reference.
     * 
     * @return      True if hard, false otherwise.
     */
    public boolean
    isHard() {
        return hard;
    }
}
