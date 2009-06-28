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
 * An index is a means of referencing documents. An index at the very least
 * consists of an URI and a descriptive name. An index should not be used
 * directly, but should be subclassed to a particular type of index.
 * 
 * @see Topic
 * @see Reference
 */
public abstract class Index {
    private String      uri;
    private String      name;

    /**
     * Define a single index, specifying the URI and the name.
     * 
     * @param uri       Unique URI for this topic.
     * @param name      Descriptive name for this topic.
     */
    public
    Index(String uri, String name) {
        this.uri = uri;
        this.name = name;
    }

    /**
     * Get the unique URI for this index. The URI should consist only of
     * the lowercase letters a-z plus a hyphen. Other characters are not
     * allowed in an URI.
     * 
     * @return  URI of this index.
     */
    public String
    getUri() {
        return uri;
    }

    /**
     * Get the full descriptive name of this index. An index is an
     * unformatted string, and is used for display and ordering purposes
     * only.
     * 
     * @return  Descriptive name of this index.
     */
    public String
    getName() {
        return name;
    }
    
    /**
     * Compare this index with the provided index. The URIs of the two indexes
     * are compared, and if they are the same, then they are considered to
     * match. Other attributes of the index are ignored.
     * 
     * @param index     Index to compare.
     * @return          True if both are the same.
     */
    public boolean
    equals(Index index) {
        return (index != null) && (uri.equals(index.getUri()));
    }
    
    /**
     * Compare this index with the provided URI. If the URI matches the URI
     * of this index, then the index is considered to match.
     * 
     * @param uri       URI to compare this index against.
     * @return          True if the URI matches the URI of this index.
     */
    public boolean
    equals(String uri) {
        return (uri != null) && (uri.equals(this.uri));
    }
}
