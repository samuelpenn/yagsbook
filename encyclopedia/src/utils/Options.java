/*
 * Copyright (C) 2002 Samuel Penn, sam@bifrost.demon.co.uk
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2,
 * or (at your option) any later version. See the file COPYING.
 */
package net.sourceforge.yagsbook.utils;

import java.util.ArrayList;

/**
 * Provides an API for handling command line options passed
 * to a class. Use as follows:
 *
 * public static void main(String args[]) {
 *     Options options = new Options(args);
 *     if (options.isOption("-version")) {
 *         System.out.println("Version 0.1");
 *     }
 *     if (options.isOption("-echo")) {
 *         System.out.println(options.getString("-echo"));
 *     }
 * }
 */
public class Options {
    private String[]    args = null;
    private int         count = 0;

    public
    Options(String args[]) {
        this.args = args;
        this.count = args.length;
    }

    public int
    getIndex(String option) {
        int     i = 0;

        for (i=0; i < count; i++) {
            if (args[i].compareTo(option)==0) {
                return i;
            }
        }

        return -1;
    }


    public boolean
    isOption(String option) {
        if (getIndex(option) >= 0) {
            return true;
        }

        return false;
    }

    public int count() {
        return count;
    }

    /**
     * Count the number of occurrences of a given option.
     * An option may appear multiple times, each time with a different
     * argument.
     */
    public int count(String option) {
        int     i = 0;
        int     c = 0;

        for (i=0; i < count; i++) {
            if (args[i].compareTo(option)==0) {
                c++;
            }
        }

        return c;
    }


    /**
     * Get the argument for the given option as a string.
     * Returns the argument for the first occurrence of the
     * given option.
     */
    public String getString(String option) {
        int     idx = getIndex(option);

        if (idx < 0) {
            return null;
        }

        if (idx == count-1) {
            return null;
        }

        return args[idx+1];
    }


    public String[] getAllStrings(String option) {
        ArrayList       list = new ArrayList();
        int             idx = getIndex(option);

        if (idx < 0 || idx == count-1) {
            return null;
        }

        for (idx++; idx < count; idx++) {
            if (args[idx].startsWith("-")) {
                // Assume end of arguments.
                break;
            } else {
                list.add(args[idx]);
            }
        }

        return (String[]) list.toArray(new String[1]);
    }

    public int
    getInt(String option) {
        int     idx = getIndex(option);
        int     value = 0;

        if (idx < 0) {
            return 0;
        }

        if (idx == count-1) {
            return 0;
        }

        try {
            value = Integer.parseInt(args[idx+1]);
        } catch (NumberFormatException e) {
            value = 0;
        }

        return value;
    }

}
