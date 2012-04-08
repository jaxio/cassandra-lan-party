/*
 * (c) Copyright 2005-2012 JAXIO, www.jaxio.com
 * Source code generated by Celerio, a Jaxio product
 * Want to use Celerio within your company? email us at info@jaxio.com
 * Follow us on twitter: @springfuse
 * Template pack-mvc-3:src/main/java/web/controller/admin/AdminController.p.vm.java
 */
package org.apache.cassandra.party.web;

import static org.apache.cassandra.party.service.Cluster.buildCluster;
import static org.springframework.web.bind.annotation.RequestMethod.GET;

import java.util.List;

import org.apache.cassandra.party.service.Cluster;
import org.apache.cassandra.party.service.NodeInfo;
import org.apache.cassandra.party.service.RingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class RingController {

    @Autowired
    private RingService ringService;

    @RequestMapping("/ring")
    public String ring(Model model) {
        List<NodeInfo> infos = ringService.loadNodeInfos("127.0.0.1", "ks"); // TODO
        for (NodeInfo ni : infos) {
            System.out.println(ni);
        }
        model.addAttribute("nodeInfos", infos);
        return "ring"; // todo
    }

    @RequestMapping(value = "/rest/ring", method = GET, produces = "application/json")
    @ResponseBody
    public Cluster ring() {
        List<NodeInfo> infos = ringService.loadNodeInfos("127.0.0.1", "ks"); // TODO
        for (NodeInfo ni : infos) {
            System.out.println(ni);
        }
        return buildCluster(infos);
    }
}
