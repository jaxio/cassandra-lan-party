package org.apache.cassandra.party.web;

import java.util.List;

import javax.servlet.ServletRequest;

import org.apache.cassandra.party.DataCenter;
import org.apache.cassandra.party.Participant;
import org.apache.cassandra.party.SimpleTokenCalculator;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class IndexController {
    @RequestMapping("/")
    public String indexEmpty() {
        return "redirect:/index";
    }

    @RequestMapping("/index")
    public String index(Model model, ServletRequest req) {
        int nbDataCenter = 3;
        int nbRackPerDataCenter = 2;
        int nbParticipantPerRack = 8;

        model.addAttribute("nbDataCenter", nbDataCenter);
        model.addAttribute("nbRackPerDataCenter", nbRackPerDataCenter);
        model.addAttribute("nbParticipantPerRack", nbParticipantPerRack);

        List<DataCenter> dataCenters = SimpleTokenCalculator.calculate(nbDataCenter, nbRackPerDataCenter, nbParticipantPerRack);

        for (DataCenter datacenter : dataCenters) {
            System.out.println(datacenter.getName());
            for (Participant participant : datacenter.getParticipants()) {
                System.out.println(participant);
                if (participant.getIp().equals(("" + req.getRemoteAddr()).trim())) {
                    participant.setCurrentUser(true);
                    break;
                }
            }

        }

        model.addAttribute("dataCenters", dataCenters);

        return "index";
    }
}
