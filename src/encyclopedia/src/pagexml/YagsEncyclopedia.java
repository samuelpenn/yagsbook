/*
 * Copyright (C) 2004 Samuel Penn, sam@glendale.org.uk
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation version 2.
 * See the file COPYING.
 *
 * $Revision: 1.7 $
 * $Date: 2005/08/13 12:39:31 $
 */
package net.sourceforge.yagsbook.pagexml;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.Target;

import org.apache.tools.ant.taskdefs.Cvs;

import java.io.*;

import javax.xml.transform.*;
import javax.xml.transform.stream.*;

import net.sourceforge.yagsbook.encyclopedia.*;
import net.sourceforge.yagsbook.encyclopedia.articles.FileSystemSource;

/**
 * @author sam
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class YagsEncyclopedia extends Cvs {
    private String      localRepository;
    private String      destination;
    private String      relativePath;

    private String      targetDir = "run/html";
    private String      tmpDir = "run/tmp";
    private String      statsFile = null;

    private String      cvsRoot;
    private String      module;
    private String      baseDir;
    private String      repository;
    private String      configFile;

    /**
     * Resolve links to external documents so that relative files are found.
     */
    public class LocalResolver implements URIResolver {
        private String  baseDir;

        LocalResolver(String baseDir) {
            this.baseDir = baseDir;
        }

        public Source
        resolve(String href, String base) {
            File    file = new File(href);
            String  fullPath = null;
            Source  src = null;

            try {
                if (file.isAbsolute()) {
                    fullPath = href;
                } else {
                    fullPath = baseDir+"/"+href;
                }

                file = new File(fullPath);
                src = new StreamSource(file);
            } catch (Exception e) {
                System.out.println("resolve: "+e.getMessage());
            }

            return src;
        }
    }

    public YagsEncyclopedia() {
        setProject(new Project());
        getProject().init();

        setTaskType("cvs");
        setTaskName("cvs");
        setOwningTarget(new Target());
    }

    public void
    setTargetDir(String targetDir) {
        this.targetDir = targetDir;
    }

    public void
    setTmpDir(String tmpDir) {
        this.tmpDir = tmpDir;
    }

    public void
    setCvsRoot(String cvsRoot) {
        this.cvsRoot = cvsRoot;
    }

    public void
    setBaseDir(String baseDir) {
        this.baseDir = baseDir;
    }

    public void
    setModule(String module) {
        this.module = module;
    }

    public void
    setRepository(String repository) {
        this.repository = repository;
    }

    public void
    setConfigFile(String configFile) {
        this.configFile = configFile;
    }

    public void
    setStatsFile(String statsFile) {
        this.baseDir = statsFile;
    }


    public String
    importEncyclopedia(String destdir) {
        localRepository = tmpDir+"/"+module;
        destination = targetDir+"/"+baseDir+"/"+destdir;
        relativePath = destdir;

        try {
            new File(destination).mkdirs();
            new File(tmpDir).mkdirs();
        } catch (Exception e) {
        }
        if (!export(module, tmpDir+"/", cvsRoot)) {
            return null;
        }

        String      output = null;
        try {
            Encyclopedia    encyclopedia = new Encyclopedia(new File(destination));
            encyclopedia.setConfiguration(new File(localRepository+"/"+configFile));
            encyclopedia.add(new FileSystemSource(new File(localRepository+"/"+repository)));

            encyclopedia.build();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return output;
    }

    private void
    deleteDir(File dir) {
        try {
            File[]    list = dir.listFiles();
            for (int i=0; i < list.length; i++) {
                if (list[i].isDirectory()) {
                    deleteDir(list[i]);
                } else {
                    list[i].delete();
                }
            }
            dir.delete();
        } catch (Exception e) {
        }
    }


    boolean
    export(String srcdir, String destdir, String cvsroot) {
        try {
            setFailOnError(true);
            setCvsRoot(cvsroot);
            setCommand("export");
            setDest(new File(destdir));
            setDate("TODAY");
            setPackage(srcdir);
            //setPassfile(new File("/home/sam/.cvspass"));
            System.out.println("Exporting ["+cvsroot+"//"+srcdir+"] to ["+destdir+"]");
            execute();
        } catch (Exception e) {
            System.out.println("Failed to checkout from CVS");
            e.printStackTrace();
            return false;
        }

        return true;
    }

    public static void
    main(String[] args) {
        YagsEncyclopedia    ye = new YagsEncyclopedia();

        ye.setModule("habisfern/encyclopedia");
        ye.setBaseDir("/home/sam/tmp/yb/html");
        ye.setTmpDir("/home/sam/tmp/yb/tmp");
        ye.setCvsRoot(":pserver:anonymous@cvshost:2401/var/cvs/rpg");

        ye.setConfigFile("config.xml");
        ye.setRepository("src");

        ye.importEncyclopedia("entries");
    }
}
