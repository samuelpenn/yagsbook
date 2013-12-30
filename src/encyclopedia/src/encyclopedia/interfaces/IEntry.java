/*
 * Copyright (C) 2004 Samuel Penn, sam@glendale.org.uk
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation version 2.
 * See the file COPYING.
 *
 * $Revision: 1.5 $
 * $Date: 2006/02/07 19:14:42 $
 */
package net.sourceforge.yagsbook.encyclopedia.interfaces;

import java.util.Iterator;
import java.util.Properties;

import net.sourceforge.yagsbook.encyclopedia.indexing.*;

/**
 * Interface which defines an entry in the Encyclopedia. An IEntry is
 * a wrapper to any format of document which may be inserted into the
 * Encyclopedia. The IEntry provides an interface onto the document's
 * meta data, without having to worry about the implementation details.
 *
 * @author Samuel Penn
 */
public interface IEntry {
    /**
     * The URI must be unique across the Encyclopedia. Duplicate entries
     * will be ignored. The URI consists of lowercase letters 'a-z' plus
     * the hyphen '-'. No spaces, digits or other characters.
     *
     * @return      Unique URI of this entry.
     */
    public String getUri();

    /**
     * The title of the document. This is the human readable name of the
     * document, which will be displayed in the index.
     *
     * @return      Document's title.
     */
    public String getTitle();

    /**
     * Get the slugline of the document. This is a short sentence describing
     * the entry in more detail than the title gives. It is normally listed
     * in the index page when there is space. For example, the article for
     * 'London' might have a slugline of 'Capital city of England'.
     *
     * @return      Document's slugline.
     */
    public String getSlugline();

    /**
     * Get a short paragraph of text describing this entry. The summary may
     * be defined in the entry's header, or may be automatically generated
     * from the body text of the article.
     *
     * @return      Document summary.
     */
    public String getSummary();

    /**
     * Get the name of the document's author. The fullname of the author
     * is returned.
     *
     * @return      Author's name.
     */
    public String getAuthor();

    /**
     * Get the version number as a dotted decimal string.
     *
     * @return      Version of this document.
     */
    public String getVersion();

    /**
     * Get the date that this document was last edited. The date will be in
     * the format yyyy/mm/dd hh:mi:ss.
     *
     * @return      Last modified date of the document.
     */
    public String getDate();

    /**
     * Get the subject of this entry. This may be self-referential if this is
     * the root of the subject. Sub-entries will refer to their parent.
     *
     * @return      Topic describing the subject of this entry.
     */
    public Topic getSubject();

    /**
     * Get the category this entry belongs to. An entry belongs only to a
     * single category, but categories are arranged in a nested heirarchy.
     *
     * @return      Category of this entry.
     */
    public String getCategory();

    /**
     * Get list of all topics for this document.
     * @return      Iterator over the topics.
     */
    public Iterator getTopics();

    /**
     * Get list of all references for this document. References are divided
     * into hard and soft references. Hard references are defined in the header
     * of the entry, whilst soft references are defined in the body.
     *
     * @return      Iterator over the references.
     */
    public Iterator getReferences();

    /**
     * Checks if this entry is a parent entry. Child entries have a subject
     * which points to another entry, whilst a parent's subject always points
     * to itself.
     *
     * @return      True if this entry has no parents of its own.
     */
    public boolean isParent();

    /**
     * Get the character to use as an index for this entry. Normally this
     * will be the first letter of the entry's title.
     *
     * @return      Index to use when grouping entries.
     */
    public String getIndex();

    /**
     * Get the character from the URI to use as a filesystem index for
     * this entry. Pages will normally be written into a directory named
     * for the first letter of the URI of the entry.
     *
     * @return      Index to use when writing files to website.
     */
    public String getUriIndex();

    /**
     * Get the HTML rendition of this entry. The entry should apply its own
     * stylesheet, and return itself as an HTML document.
     *
     * @return      String containing an HTML document.
     */
    public String toHTML();

    public void setStylesheet(String stylesheet);

    public void setProperty(String name, String value);

    public void setProperties(Properties props);

}
