package org.apache.cassandra.party.web;

import static com.google.common.collect.Lists.newArrayList;
import static org.apache.cassandra.party.service.Cluster.buildCluster;
import static org.springframework.http.HttpStatus.BAD_REQUEST;
import static org.springframework.web.bind.annotation.RequestMethod.GET;

import java.util.List;

import org.apache.cassandra.party.service.Cluster;
import org.apache.cassandra.party.service.NodeInfo;
import org.apache.cassandra.party.service.RingService;
import org.apache.commons.lang.RandomStringUtils;
import org.apache.commons.lang.math.RandomUtils;
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
    public List<NodeInfo> ring( //
            @RequestParam(defaultValue = "127.0.0.1") String probeHost, //
            @RequestParam(defaultValue = "ks") String keyspace, //
            @RequestParam(defaultValue = "false") boolean debug) {
        return loadNodeInfos(probeHost, keyspace, debug);
    }

    @RequestMapping(value = "/rest/treemap", method = GET, produces = "application/json")
    @ResponseBody
    public Cluster treemap( //
            @RequestParam(defaultValue = "127.0.0.1") String probeHost, //
            @RequestParam(defaultValue = "ks") String keyspace, //
            @RequestParam(defaultValue = "false") boolean debug) {
        return buildCluster(loadNodeInfos(probeHost, keyspace, debug));
    }

    @RequestMapping(value = "/rest/checkProbe", method = GET, produces = "application/json")
    @ResponseBody
    public String checkProbe(@RequestParam String probeHost, @RequestParam String keyspace) {
        ringService.loadNodeInfos(probeHost, keyspace);
        return "{\"message\":\"ok\"}";
    }

    @ExceptionHandler
    @ResponseBody
    @ResponseStatus(BAD_REQUEST)
    public String exception(Exception e) {
        e.printStackTrace();
        return "{\"error\":\"" + e.getMessage() + "\"}";
    }

    private List<NodeInfo> loadNodeInfos(String probeHost, String keyspace, boolean debug) {
        System.out.println("loading node infos from " + probeHost + " [" + keyspace + "]");
        if (!debug) {
            return ringService.loadNodeInfos(probeHost, keyspace);
        }
        int maxDc = RandomUtils.nextInt(4) + 1;
        int maxRackPerDc = RandomUtils.nextInt(4) + 1;
        int maxParticipantPerDc = RandomUtils.nextInt(5) + 2;
        List<NodeInfo> results = newArrayList();
        for (int dc = 1; dc <= maxDc; dc++) {
            for (int rack = 1; rack <= maxRackPerDc; rack++) {
                for (int participant = 1; participant <= maxParticipantPerDc; participant++) {
                    NodeInfo nodeInfo = new NodeInfo();
                    nodeInfo.token = RandomStringUtils.randomNumeric(39);
                    nodeInfo.ip = String.format("10.%d.%d.%d", dc, rack, participant);
                    nodeInfo.dc = "datacenter" + dc;
                    nodeInfo.rack = "rack" + rack;
                    nodeInfo.status = NodeInfo.NodeStatus.values()[RandomUtils.nextInt(NodeInfo.NodeStatus.values().length)];
                    nodeInfo.state = NodeInfo.NodeState.values()[RandomUtils.nextInt(NodeInfo.NodeState.values().length)];
                    nodeInfo.load = "" + RandomUtils.nextInt(101);
                    nodeInfo.owns = nodeInfo.load + "%";

                    results.add(nodeInfo);
                }
            }
        }
        return results;
    }
}
