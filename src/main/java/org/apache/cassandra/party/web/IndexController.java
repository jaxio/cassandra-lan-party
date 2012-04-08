package org.apache.cassandra.party.web;

import static org.apache.cassandra.party.SimpleTokenCalculator.buildDataCenters;

import javax.servlet.ServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class IndexController {
    @RequestMapping("/")
    public String indexEmpty() {
        return "redirect:/index";
    }

    @RequestMapping("/index")
    public ModelAndView index(ServletRequest req) {
        int nbDataCenter = 3;
        int nbRackPerDataCenter = 2;
        int nbParticipantPerRack = 8;

        ModelAndView model = new ModelAndView("index");
        model.addObject("currentIp", req.getRemoteAddr());
        model.addObject("nbDataCenter", nbDataCenter);
        model.addObject("nbRackPerDataCenter", nbRackPerDataCenter);
        model.addObject("nbParticipantPerRack", nbParticipantPerRack);
        model.addObject("dataCenters", buildDataCenters(nbDataCenter, nbRackPerDataCenter, nbParticipantPerRack));
        return model;
    }
}
