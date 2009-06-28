/*
 * Copyright (C) 2002 Samuel Penn, sam@glendale.org.uk
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation version 2.
 * See the file COPYING.
 *
 * $Revision: 1.26 $
 * $Date: 2006/02/07 19:14:28 $
 */

package net.sourceforge.yagsbook.encyclopedia;

import java.util.*;

import java.io.*;

import net.sourceforge.yagsbook.xml.*;
import net.sourceforge.yagsbook.encyclopedia.articles.FileSystemSource;
import net.sourceforge.yagsbook.encyclopedia.indexing.Reference;
import net.sourceforge.yagsbook.encyclopedia.interfaces.*;
import net.sourceforge.yagsbook.utils.Options;

/**
 * The Encyclopedia class pulls together one or more document sources, and
 * builds a Repository of entries which are used to build the web based
 * encyclopedia.
 * <br/>
 * Any number of ISource objects may be added to the encyclopedia, mixing
 * different source and document types as desired.
 *
 * @author      Samuel Penn.
 */
public class Encyclopedia {
    private Repository      repository;
    private MainPage        mainPage;
    private String          destination = "entries";
    private Vector          missing = new Vector();
    private String          stylesheet = null;
    private String          counter = null;
    private Hashtable       subjectLists = null;
    private Properties      properties = new Properties();
    private static boolean  debug = false;

    /**
     * Create a new Encyclopedia at the specified destination. A new
     * Repository will be created and configured at the destination.
     */
    public
    Encyclopedia(File destination) throws IOException {
        repository = new Repository(destination);
        this.destination = destination.getPath()+"/entries";
        stylesheet = "/usr/share/xml/yagsbook/article/xslt/html/encyclopedia.xsl";
    }

    private static void setDebug(boolean enableDebug) {
        Encyclopedia.debug = enableDebug;
    }

    private static void debug(String message) {
        if (Encyclopedia.debug) {
            System.out.println(message);
        }
    }

    /**
     * Set list of properties to pass to XSLT processing.
     *
     * @param   p   Properties to set. If null, then unset all properties.
     */
    public void setProperties(Properties p) {
        if (p != null) {
            this.properties = p;
        } else {
            this.properties = new Properties();
        }
    }

    /**
     * Set a single property to be passed to XSLT processing.
     */
    public void setProperty(String name, String value) {
        properties.setProperty(name, value);
    }

    /**
     * Add a document source to the encyclopedia. Multiple sources may be
     * added, and the full contents of each will be used to build the final
     * encyclopedia. If documents are found with the same URI, then only the
     * first document found will be used.
     *
     * @param source        Source of documents to add.
     */
    public void
    add(ISource source) throws BuildException {
        debug("Adding repository ["+source.getName()+"]");
        debug("    Document count: "+source.size());
        repository.add(source);
    }

    /**
     * Configuration file which describes properties about the site.
     */
    public void
    setConfiguration(File filename) {
        try {
            mainPage = new MainPage(filename);
        } catch (XMLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Copy the given file into the specified directory. The name of
     * the file is always preserved.
     *
     * @param file      The file to be copied.
     * @param path      The path to the destination directory.
     */
    private void
    copyFile(File file, String path) throws IOException {
        String  outpath  =  path+"/"+file.getName();
        byte[]  data  = new byte[65536];
        int     len = 0;

        FileInputStream  fis = new FileInputStream(file);
        FileOutputStream fos = new FileOutputStream(outpath);

        while ((len = fis.read(data)) >= 0) {
            fos.write(data, 0, len);
        }

        fis.close();
        fos.close();
    }

    /**
     * Build the encyclopedia, generating the HTML renditions of all the
     * entries, as well as the index files.
     */
    public void
    build() throws IOException {
        // Get the list of all indices.
        Iterator    iter = null;
        String      dirs = "abcdefghijklmnopqrstuvwxyz";
        int         i = 0;

        // Make a directory for each of the letters.
        for (i = 0; i < dirs.length(); i++) {
            String  dirpath = destination+"/"+dirs.substring(i, i+1);

            try {
                File    dir = new File(dirpath);
                dir.mkdir();
            } catch (Exception ioe) {
                System.out.println("Cannot make "+dirpath);
            }
        }
        try {
            mainPage.setRepository(repository);
            mainPage.createFrontPage(new File(destination));
        } catch (XMLException e) {
            throw new IOException(e.getMessage());
        }
        // Now process all the articles.
        iter= repository.indexIterator();
        while (iter.hasNext()) {
            Index   index = (Index)iter.next();

            if (index.toString().equals("all")) {
                buildArticles(index);
            }

            mainPage.setTitle(index.getTitle());
            mainPage.open(destination+"/"+index+".html");
            try {
                stylesheet = mainPage.getTextNode("//stylesheets/stylesheet[@name='entry']/@location");
                counter = mainPage.getCounterHref();
            } catch (XMLException e) {
                System.out.println("Unable to load stylesheet, using default");
            }
            System.out.println("Using stylesheet ["+stylesheet+"]");
            build(index);
        }
    }

    /**
     * Build an index page for the encyclopedia. The index passed in
     * should contain a list of all the articles to be listed.
     *
     * @param index     Index of all articles for this index page.
     */
    private void
    build(Index index) {
        Iterator        iter;
        IEntry          entry;
        String          lastIndex = "";
        long            start = 0, end = 0;

        Log.info("Building index ["+index.getTitle()+"]");
        start = System.currentTimeMillis();
        try {
            mainPage.writeHeader();

            iter = index.iterator();
            boolean     first = true;
            while (iter.hasNext()) {
                FileWriter      entryWriter;

                entry = (IEntry) iter.next();
                if (!entry.isParent()) {
                    continue;
                }

                if (!entry.getIndex().equals(lastIndex)) {
                    if (!first) {
                        mainPage.write("</div>");
                    }
                    first = false;
                    mainPage.write("<div class=\"index\">");
                    mainPage.write("<h2>"+entry.getIndex().toUpperCase()+"</h2>\n");
                    lastIndex = entry.getIndex();
                }

                mainPage.writeEntry(entry, false);

                Iterator    list = index.getBySubject(entry.getSubject(), false);
                while (list.hasNext()) {
                    IEntry   child = (IEntry) list.next();
                    mainPage.writeEntry(child, true);
                }

            }
            mainPage.write("</div>");
            mainPage.write("</div>\n</body>\n</html>\n");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                mainPage.close();
            } catch (IOException ioe) {
                ioe.printStackTrace();
            }
            end = System.currentTimeMillis();
            System.out.println("Time taken: "+(end - start)+"ms");
        }
    }

    public Hashtable
    buildSubjectIndex(Iterator iter) {
        Hashtable       table = new Hashtable();

        while (iter.hasNext()) {
            IEntry      entry = (IEntry) iter.next();

        }
        return table;
    }

    /**
     * Get a list of all entries which match a given subject.
     *
     * @param subject   URI of the subject to be matched on.
     */
    public Iterator
    getBySubject(String subject) {
        Vector      list = (Vector)subjectLists.get(subject);

        if (list == null) {
            return null;
        }

        return null;
    }

    /**
     * Check all the links in the article, and add any missing links into
     * our global list of missing links. These can be added to the main
     * index page as a 'to do' list.
     */
    public void
    validate(Index index, IEntry entry) {
        String      subject = entry.getSubject().getUri();
        Iterator    links = entry.getReferences();
        TreeSet     set = new TreeSet();

        // Build up alphabetical list of all articles by uri.
        Iterator    iter = index.iterator();
        while (iter.hasNext()) {
            IEntry      e = (IEntry)iter.next();
            String      uri = e.getUri();
            set.add(uri);
        }

        while (links.hasNext()) {
            Reference   reference = (Reference)links.next();
            String      uri = reference.getUri();
            if (!set.contains(uri)) {
                String  warning = entry.getSubject().getUri() + " references <i>"+uri+"</i>";
                missing.add(warning);
            }
        }

    }

    /**
     * Generate all the HTML articles for each entry. This should only
     * be called once, on the Index "all".
     */
    private void
    buildArticles(Index index) {
        Iterator        iter;
        IEntry          entry;

        subjectLists = new Hashtable();

        try {
            iter = index.iterator();
            while (iter.hasNext()) {
                FileWriter      entryWriter = null;

                entry = (IEntry) iter.next();
                System.out.println(entry.getUri()+": "+entry.getTitle());
                validate(index, entry);

                entry.setStylesheet(stylesheet);
                entry.setProperties(properties);
                entry.setProperty("counterHref", mainPage.getCounterHref());

                entryWriter = new FileWriter(repository.getOutputFile(entry));

                entryWriter.write(entry.toHTML());
                entryWriter.close();
                entryWriter = null;
            }
            mainPage.setStatistic("Total articles", index.size());
            mainPage.setStatistic("Missing articles", missing.size());

            mainPage.setTitle("Missing articles");
            mainPage.open(destination+"/missingLinks.html");
            mainPage.writeHeader();
            mainPage.writeln("<h1>Missing articles</h1>");
            mainPage.writeln("<p>");
            for (int i=0; i < missing.size(); i++) {
                String  line = (String)missing.elementAt(i);
                mainPage.writeln(line+"<br/>");
            }
            mainPage.writeln("</p>");
            mainPage.writeln("</div>");
            mainPage.writeln("</body>");
            mainPage.writeln("</html>");
            mainPage.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    private static void usage(String message) {
        System.out.println(message);
    }

    private static void usage() {
        usage("Yagsbook Encyclopedia:");
        usage("    -config <filename>     Configuration file to use.");
        usage("    -src <dir1> <dir2> ... Directory to add as source.");
        usage("    -dest <path>           Path to output directory.");
    }

    public static void
    main(String args[]) throws Exception {
        Options     options = new Options(args);
        String      configFilename = "config.xml";
        String      destPath = "/tmp/repository";
        String[]    src = null;

        if (options.isOption("-help")) {
            usage();
            return;
        }

        // This is for testing, though I can't remember what.
        if (options.isOption("-xslt")) {
            Extensions.main(args);
            System.exit(0);
        }

        if (options.isOption("-debug")) {
            setDebug(true);
        }

        if (options.isOption("-config")) {
            configFilename = options.getString("-config");
        }

        if (options.isOption("-dest")) {
            destPath = options.getString("-dest");
        }

        if (options.isOption("-src")) {
            src = options.getAllStrings("-src");
        } else {
            usage("No source repositories defined. Try -help for info.");
            return;
        }

        Encyclopedia    enc = new Encyclopedia(new File(destPath));
        for (int s=0; s < src.length; s++) {
            enc.add(new FileSystemSource(new File(src[s])));
        }
        enc.setConfiguration(new File(configFilename));
        debug("Building encyclopedia");
        enc.build();
    }
}
