package org.apache.cassandra.party.web;

import static org.apache.cassandra.party.SimpleTokenCalculator.buildDataCenters;
import static org.springframework.http.HttpStatus.BAD_REQUEST;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class IndexController {
    @RequestMapping("/index")
    public String index() {
        return "index";
    }

    @RequestMapping("/configuration")
    public ModelAndView configuration( //
            @RequestParam(value = "nbDataCenter", defaultValue = "4") int nbDataCenter, //
            @RequestParam(value = "nbRackPerDataCenter", defaultValue = "2") int nbRackPerDataCenter, //
            @RequestParam(value = "nbParticipantPerRack", defaultValue = "5") int nbParticipantPerRack) {
        return new ModelAndView("configuration") //
                .addObject("nbDataCenter", nbDataCenter) //
                .addObject("nbRackPerDataCenter", nbRackPerDataCenter) //
                .addObject("nbParticipantPerRack", nbParticipantPerRack) //
                .addObject("dataCenters", buildDataCenters(nbDataCenter, nbRackPerDataCenter, nbParticipantPerRack));
    }

    @ExceptionHandler
    @ResponseStatus(BAD_REQUEST)
    public ModelAndView exception(Exception e) {
        return new ModelAndView("error") //
                .addObject("error", e.getMessage());
    }
}
