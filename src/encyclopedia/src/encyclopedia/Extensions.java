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

import java.io.File;
import java.util.*;

import org.apache.xalan.templates.ElemExtensionCall;

import net.sourceforge.mapcraft.editor.MapImage;
import net.sourceforge.yagsbook.xml.*;

/**
 * Class to provide XSLT extensions.
 */
public class Extensions {
    private String      uri;
    private String      href;
    private int         scale;
    private int         mapType;
    private int         thumbWidth;

    // Cropping.
    private int         x, y, width, height;
    // Area
    private String      area;
    private String      thing;
    private String      river;
    private int         margin;

    static private File     imageDir = null;
    static private File     sourceDir = null;

    static final int    NORMAL = 0;
    static final int    CROP = 1;
    static final int    AREA = 2;
    static final int    THING = 3;
    static final int    RIVER = 4;

    /**
     * Set directory where output images should be written to.
     * 
     * @param directory     Directory to place images.
     */
    static void
    setImageDir(File directory) {
        imageDir = directory;
    }

    /**
     * Set directory where source map files can be found.
     * 
     * @param directory     Directory to read map files from.
     */
    static void
    setSourceDir(File directory) {
        sourceDir = directory;
    }

    Extensions(String uri, int scale) {
        this.uri = uri;
        this.href = uriToHref(uri);
        this.scale = scale;
        mapType = NORMAL;
    }

    public void
    setThumbWidth(int thumbWidth) {
        this.thumbWidth = thumbWidth;
    }

    void
    setCrop(int x, int y, int width, int height) {
        mapType = CROP;
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }

    void
    setArea(String area, int margin) {
        mapType = AREA;
        this.area = area;
        this.margin = margin;
    }

    void
    setThing(String thing, int radius) {
        mapType = THING;
        this.thing = thing;
        this.margin = radius;
    }

    void
    setRiver(String river, int margin) {
        mapType = RIVER;
        this.river = river;
        this.margin = margin;
    }

    /**
     * Try to ensure that the map name is filename safe. Change the most
     * common unsafe characters into something else.
     */
    private String
    safeFilename(String name) {
        String      filename;

        filename = name.replaceAll(" ", "_");
        filename = filename.replaceAll("/", "_");
        filename = filename.replaceAll("\\\\", "_");

        return filename;
    }

    private String
    processMap(MapImage map) {
        String      path = null;

        switch (mapType) {
        case NORMAL:
            path = uri+"-"+scale;
            break;
        case CROP:
            map.crop(x, y, width, height);
            path = uri+"-"+x+"-"+y+"-"+width+"-"+height+"-"+scale;
            break;
        case AREA:
            map.cropToArea(area, margin);
            path = uri+"-area-"+safeFilename(area)+"-"+margin+"-"+scale;
            break;
        case THING:
            map.cropToThing(thing, margin);
            path = uri+"-thing-"+safeFilename(thing)+"-"+margin+"-"+scale;
            break;
        }

        return path+".jpg";
    }

    /**
     * Create the map, and return a path to its location.
     * 
     * @return      Path to the generated map image.
     */
    String
    generateMap() {
        String      path = null;

        try {
            Properties      props = new Properties();
            props.setProperty("path.run", System.getProperty("user.dir"));
            props.setProperty("path.images", "");

            MapImage    map = new MapImage(props, href);

            path = processMap(map);
            map.setThumbnail(thumbWidth);
            map.setShowLargeGrid(false);
            map.setShowThings(true);
            map.setShowAreas(true);
            map.setShowFeatures(true);
            map.saveImage(imageDir.getPath()+"/"+path, scale, false);
        } catch  (Exception e) {
            e.printStackTrace();
        }

        return "../../images/"+path;
    }



    public static String
    test(String name) {
        return "Hello "+name;
    }

    public String
    generateMap(ElemExtensionCall call) {
        //ImportMap map = new ImportMap(call);

        return "hello";
    }


    private static String
    uriToHref(String uri) {
        String  href;

        href = sourceDir.getPath()+"/"+uri+".map";

        return href;
    }

    public static String
    importAreaMap(String uri, int scale, int thumb, String area, int margin) {
        Extensions  ext = null;
        String      path = "";

        try {
            ext = new Extensions(uri, scale);
            ext.setArea(area, margin);
            if (thumb > 0) {
                ext.setThumbWidth(thumb);
            }
            path = ext.generateMap();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return path;
    }

    public static String
    importThingMap(String uri, int scale, int thumb, String thing, int radius) {
        Extensions  ext = null;
        String      path = "";

        try {
            ext = new Extensions(uri, scale);
            ext.setThing(thing, radius);
            if (thumb > 0) {
                ext.setThumbWidth(thumb);
            }
            path = ext.generateMap();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return path;
    }

    public static String
    importMap(String uri, int scale, int thumb) {
        Extensions  ext = null;
        String      path = "";

        try {
            ext = new Extensions(uri, scale);
            if (thumb > 0) {
                ext.setThumbWidth(thumb);
            }
            path = ext.generateMap();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return path;
    }

    /**
     * Get the path to the generated thumbnail for the map image.
     * The thumbnail has a '-t' suffix on the end of the filename before
     * the JPEG extension.
     * 
     * @param  path     Pathname to the main image.
     * @return          Pathname to the thumbnail image.
     */
    public static String
    getThumbPath(String path) {
        return path.replaceAll("\\.jpg", "-t.jpg");
    }

    public static void
    main(String[] args) {
        System.out.println("XSLT Xalan test");

        try {
            XMLDocument     doc = new XMLDocument(new File("foo.xml"));
            doc.setStylesheet("foo.xslt");
            System.out.println(doc.stylesheet());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
