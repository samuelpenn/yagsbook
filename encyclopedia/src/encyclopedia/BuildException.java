/*
 * Copyright (C) 2002 Samuel Penn, sam@glendale.org.uk
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation version 2.
 * See the file COPYING.
 *
 * $Revision: 1.4 $
 * $Date: 2005/04/10 11:42:56 $
 */

package net.sourceforge.yagsbook.encyclopedia;

/**
* Exception class, raised when an error occurs during
* processing of an XML document. Used as a generic
* exception, to make things easier to catch.
*/
public class BuildException extends Exception {
    public
    BuildException() {
        super();
    }

    public
    BuildException(String msg) {
        super(msg);
    }
}
