/*
 * Copyright (C) 2004 Samuel Penn, sam@glendale.org.uk
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation version 2.
 * See the file COPYING.
 *
 * $Revision: 1.2 $
 * $Date: 2005/04/10 11:42:56 $
 */
package net.sourceforge.yagsbook.encyclopedia;

/**
 * Provide basic logging functions. Eventually, this should be a wrapper to
 * the Log4J classes.
 * 
 * @author Samuel Penn
 */
public class Log {
    public static final int     ERROR = 0;
    public static final int     WARN = 1;
    public static final int     INFO = 2;
    public static final int     DEBUG = 3;
    
    private static int   level = DEBUG;
    
    /**
     * Set the logging level. The log level should be one of ERROR, WARN,
     * INFO or DEBUG. Messages less important than the current log level
     * will be ignored.
     * 
     * @param level     New logging level to use.
     */
    public static void
    setLogLevel(int level) {
        if (level >= ERROR && level <= DEBUG) {
            Log.level = level;
        }
    }
    
    private static void
    output(String type, String message) {
        System.out.println(message);
    }
    
    /**
     * Output a debug message.
     * 
     * @param message       Message to be written.
     */
    public static void
    debug(String message) {
        output("DEBUG", message);
    }
    
    /**
     * Output an informational message.
     * 
     * @param message       Message to be written.
     */
    public static void
    info(String message) {
        output("INFO", message);
    }
    
    /**
     * Output a warning message.
     * 
     * @param message       Message to be written.
     */
    public static void
    warn(String message) {
        output("WARN", message);
    }
    
    /**
     * Output an error message.
     * 
     * @param message       Message to be written.
     */
    public static void
    error(String message) {
        output("ERROR", message);
    }
}
