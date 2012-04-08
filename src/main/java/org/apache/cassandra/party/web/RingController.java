package org.apache.cassandra.party.web;

import static org.apache.cassandra.party.service.Cluster.buildCluster;
import static org.springframework.http.HttpStatus.BAD_REQUEST;
import static org.springframework.web.bind.annotation.RequestMethod.GET;

import org.apache.cassandra.party.service.Cluster;
import org.apache.cassandra.party.service.RingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

@Controller
public class RingController {

    @Autowired
    private RingService ringService;

    @RequestMapping(value = "/rest/ring", method = GET, produces = "application/json")
    @ResponseBody
    public Cluster jsonRing() {
        return buildCluster(ringService.loadNodeInfos("ks"));
    }

    @RequestMapping(value = "/rest/updateProbe", method = GET, produces = "application/json")
    @ResponseBody
    public String updateProbe(@RequestParam String probeHost) {
        ringService.updateProbe(probeHost);
        ringService.loadNodeInfos("ks");
        return "{\"host\":\"" + ringService.getHost() + "\"}";
    }

    @ExceptionHandler
    @ResponseBody
    @ResponseStatus(BAD_REQUEST)
    public String exception(Exception e) {
        return "{\"error\":\"" + e.getMessage() + "\"}";
    }
}
