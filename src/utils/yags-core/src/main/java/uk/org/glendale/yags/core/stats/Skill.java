package uk.org.glendale.yags.core.stats;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

@Entity
public class Skill {
	@Id
	private String		uri;
	private String		name;
	private String		description;
	
	public Skill() {
		
	}
	
	/**
	 * Gets the URI of this skill. This is used to uniquely identify
	 * the skill. An uri will use [a-z] and hyphens only.
	 * 
	 * @return	URI of this skill.
	 */
	public String getUri() {
		return uri;
	}
	
	public void setUri(String uri) {
		this.uri = uri;
	}
	
	public String getName() {
		return name;
	}
	
	public void setName(String name) {
		this.name = name;
	}
	
	public String getDescription() {
		return description;
	}
	
	public void setDescription(String description) {
		this.description = description;
	}
}
