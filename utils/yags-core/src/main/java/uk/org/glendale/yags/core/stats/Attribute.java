package uk.org.glendale.yags.core.stats;

public enum Attribute {
	SIZE("Sz"),
	STRENGTH, HEALTH, AGILITY, DEXTERITY, PERCEPTION, INTELLIGENCE, EMPATHY, WILL,
	MOVE("Mv"),
	SOAK("Sk"),
	LUCK("Lk");
	
	private String shortName=null;
	
	private Attribute() {
	}
	
	private Attribute(String shortName) {
		this.shortName = shortName;
	}
	
	public String getShortName() {
		if (shortName == null) {
			shortName = name().substring(0, 1);
		}
		return shortName;
	}
	
	public String toString() {
		return name().substring(0, 1) + name().substring(1).toLowerCase();
	}
}
