package uk.org.glendale.yags.core;

import uk.org.glendale.yags.core.stats.Attribute;

public interface Yags {
	/**
	 * Gets the current value of the specified attribute.
	 */
	int		getAttribute(Attribute attribute);
	
	/**
	 * Sets the value of the specified attribute.
	 */
	void	setAttribute(Attribute attribute, int value);
	
	int		getSkill(String skillName);
	
	boolean	hasSkill(String skillName);
	boolean	hasTechnique(String techniqueName);
}
