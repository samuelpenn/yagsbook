
import java.util.Properties;
import java.io.*;

public class Release {
	private static String FILE = "yagsbook.properties";
	private static String MAJOR = "version.major";
	private static String MINOR = "version.minor";
	private static String PATCH = "version.patch";

	public static void main(String[] args) throws Exception {

		Properties	p = new Properties();

		p.load(new FileInputStream(new File(FILE)));

		int major = Integer.parseInt(p.getProperty(MAJOR));
		int minor = Integer.parseInt(p.getProperty(MINOR));
		int patch = Integer.parseInt(p.getProperty(PATCH));

		if (args.length > 0) {
			if (args[0].equals("-major")) {
				major ++;
				minor = 0;
				patch = 0;
			} else if (args[0].equals("-minor")) {
				minor++;
				patch = 0;
			} else if (args[0].equals("-patch")) {
				patch++;
			}
		}

		p.setProperty(MAJOR, ""+major);
		p.setProperty(MINOR, ""+minor);
		p.setProperty(PATCH, ""+patch);

		p.store(new FileOutputStream(new File(FILE)),
				"Yagsbook release information");
	}
}
