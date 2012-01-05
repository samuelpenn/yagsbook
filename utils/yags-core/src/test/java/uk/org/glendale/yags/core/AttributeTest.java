package uk.org.glendale.yags.core;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import org.junit.Test;

import uk.org.glendale.yags.core.stats.Attribute;

/**
 * Tests the Attribute enumeration.
 * 
 * @author Samuel Penn
 */
public class AttributeTest {
	@Test
	public void testNaming() {
		String		strength = "Strength";		
		Attribute	attribute = Attribute.valueOf(strength.toUpperCase());
		
		assertNotNull(attribute);
		assertEquals(attribute, attribute.STRENGTH);
		assertEquals(strength, attribute.toString());
	}
	
	@Test
	public void testShortName() {
		Attribute	health = Attribute.HEALTH;
		Attribute	move = Attribute.MOVE;
		
		assertEquals("H", health.getShortName());
		assertEquals("Mv", move.getShortName());
	}
	
}
