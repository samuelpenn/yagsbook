package uk.org.glendale.yags.core;

import java.util.HashMap;

import uk.org.glendale.yags.core.stats.Attribute;

/**
 * Represents a character in Yags.
 * 
 * @author Samuel Penn
 */
public class Character implements Yags {
	private String		uri;
	private String		name;
	
	HashMap<Attribute,Integer>	attributes;
	
	public int getAttribute(Attribute attribute) {
		if (attributes != null) {
			Integer		score = attributes.get(attribute);
			if (score != null) {
				return score;
			}
		}
		return 0;
	}

	public void setAttribute(Attribute attribute, int value) {
		if (value < 0) {
			throw new IllegalArgumentException("Attribute value must be zero or positive");
		}
		if (attributes == null) {
			attributes = new HashMap<Attribute,Integer>();
		}
		attributes.put(attribute, value);		
	}
	
	public int getSkill(String skillName) {
		// TODO Auto-generated method stub
		return 0;
	}
	
	public boolean hasSkill(String skillName) {
		// TODO Auto-generated method stub
		return false;
	}
	
	public boolean hasTechnique(String techniqueName) {
		// TODO Auto-generated method stub
		return false;
	}
}
