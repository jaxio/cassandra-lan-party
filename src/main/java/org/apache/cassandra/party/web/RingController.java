package org.apache.cassandra.party.web;

import static org.apache.cassandra.party.service.Cluster.buildCluster;
import static org.springframework.http.HttpStatus.BAD_REQUEST;
import static org.springframework.web.bind.annotation.RequestMethod.GET;

import java.util.List;

import org.apache.cassandra.party.service.Cluster;
import org.apache.cassandra.party.service.NodeInfo;
import org.apache.cassandra.party.service.RingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

@Controller
public class RingController {

    @Autowired
    private RingService ringService;

    @RequestMapping("/ring")
    public String ring(Model model) {
        List<NodeInfo> infos = ringService.loadNodeInfos("ks"); // TODO
        for (NodeInfo ni : infos) {
            System.out.println(ni);
        }
        model.addAttribute("nodeInfos", infos);
        return "ring"; // todo
    }

    @RequestMapping(value = "/rest/ring", method = GET, produces = "application/json")
    @ResponseBody
    public Cluster ring() {
        List<NodeInfo> infos = ringService.loadNodeInfos("ks"); // TODO
        for (NodeInfo ni : infos) {
            System.out.println(ni);
        }
        return buildCluster(infos);
    }

    @RequestMapping(value = "/rest/updateProbe", method = GET, produces = "application/json")
    @ResponseBody
    public String ring(@RequestParam String probeHost) {
        System.out.println("changing to " + probeHost);
        ringService.updateProbe(probeHost);
        ringService.loadNodeInfos("ks");
        return "{\"host\":\"" + ringService.getHost() + "\"}";
    }

    @ExceptionHandler
    @ResponseBody
    @ResponseStatus(BAD_REQUEST)
    public Exception exception(Exception e) {
        return e;
    }
}
