/*
 * Copyright (C) 2002 Samuel Penn, sam@glendale.org.uk
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; version 2.
 * See the file COPYING.
 *
 * $Revision: 1.5 $
 * $Date: 2005/04/10 11:43:00 $
 */

package net.sourceforge.yagsbook.encyclopedia.ant;

import org.apache.tools.ant.*;

/**
 * Handles nested repository elements within the Encyclopedia task.
 * Each defines a repository source which is added to the final
 * destination encyclopedia.
 */
public class RepositoryTask extends Task {
    private String      src = null;

    public void
    setSrc(String src) {
        this.src = src;
    }

    public String
    getSrc() {
        return src;
    }
}
