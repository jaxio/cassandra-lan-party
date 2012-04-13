package org.apache.cassandra.party.web;

import static org.apache.cassandra.party.SimpleTokenCalculator.buildDataCenters;
import static org.springframework.http.HttpStatus.BAD_REQUEST;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.cassandra.party.DataCenter;
import org.apache.cassandra.party.Participant;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class IndexController {

    private static final String DUMMY_USER_TOKEN = "68056473384187692692674921486353642293";
    private static final String DUMMY_USER_CLUSTER = "dc3";
    private static final String DUMMY_USER_HOST = "10.3.1.2";

    @RequestMapping("/index")
    public ModelAndView index(HttpServletRequest request) {
        return new ModelAndView("index") //
                .addObject("yourIp", yourIp(request));

    }

    @RequestMapping("/configuration")
    public ModelAndView configuration( //
            @RequestParam(value = "nbDataCenter", defaultValue = "3") int nbDataCenter, //
            @RequestParam(value = "nbRackPerDataCenter", defaultValue = "2") int nbRackPerDataCenter, //
            @RequestParam(value = "nbParticipantPerRack", defaultValue = "5") int nbParticipantPerRack, //
            HttpServletRequest request) {
        List<DataCenter> dataCenters = buildDataCenters(nbDataCenter, nbRackPerDataCenter, nbParticipantPerRack);
        String yourIp = yourIp(request);
        return new ModelAndView("configuration") //
                .addObject("nbDataCenter", nbDataCenter) //
                .addObject("nbRackPerDataCenter", nbRackPerDataCenter) //
                .addObject("nbParticipantPerRack", nbParticipantPerRack) //
                .addObject("yourDataCenterId", clientDataCenter(dataCenters, yourIp)) //
                .addObject("yourToken", clientToken(dataCenters, yourIp)) //
                .addObject("yourIp", yourIp) //
                .addObject("dataCenters", dataCenters);
    }

    private String yourIp(HttpServletRequest request) {
        String yourIp = request.getRemoteHost();
        return yourIp.equals("127.0.0.1") || yourIp.endsWith("1%0") ? DUMMY_USER_HOST : yourIp;
    }

    private String clientDataCenter(List<DataCenter> dataCenters, String remoteAddr) {
        for (DataCenter dc : dataCenters) {
            for (Participant p : dc.getParticipants()) {
                if (p.getIp().equals(remoteAddr)) {
                    return dc.getId();
                }
            }
        }
        return DUMMY_USER_CLUSTER;
    }

    private String clientToken(List<DataCenter> dataCenters, String remoteAddr) {
        for (DataCenter dc : dataCenters) {
            for (Participant p : dc.getParticipants()) {
                if (p.getIp().equals(remoteAddr)) {
                    return p.getToken();
                }
            }
        }
        return DUMMY_USER_TOKEN;
    }

    @ExceptionHandler
    @ResponseStatus(BAD_REQUEST)
    public ModelAndView exception(Exception e) {
        return new ModelAndView("error") //
                .addObject("error", e.getMessage());
    }
}
