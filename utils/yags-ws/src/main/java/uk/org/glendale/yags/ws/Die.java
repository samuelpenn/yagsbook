package uk.org.glendale.yags.ws;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * Random number generation as a web service.
 * 
 * @author Samuel Penn
 */
@Controller
public class Die {
	
	@RequestMapping(value="/die/{size}", method=RequestMethod.GET)
    public String die(@PathVariable("size") int size) {
        return ""+size;
    }
}
