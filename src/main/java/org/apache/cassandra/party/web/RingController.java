package org.apache.cassandra.party.web;

import static com.google.common.collect.Lists.newArrayList;
import static com.google.common.collect.Sets.newTreeSet;
import static org.springframework.http.HttpStatus.BAD_REQUEST;
import static org.springframework.web.bind.annotation.RequestMethod.GET;

import java.util.List;
import java.util.TreeSet;

import org.apache.cassandra.party.service.NodeInfo;
import org.apache.cassandra.party.service.NodeInfo.NodeState;
import org.apache.cassandra.party.service.NodeInfo.NodeStatus;
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

    private String probeHost = "127.0.0.1";
    private String keyspace = "ks";

    @Autowired
    private RingService ringService;

    @RequestMapping(value = "/rest/ring", method = GET, produces = "application/json")
    @ResponseBody
    public TreeSet<NodeInfo> ring(@RequestParam(defaultValue = "false") boolean debug) {
        return newTreeSet(loadNodeInfos(probeHost, keyspace, debug));
    }

    @ExceptionHandler
    @ResponseBody
    @ResponseStatus(BAD_REQUEST)
    public String exception(Exception e) {
        e.printStackTrace();
        return "{\"error\":\"" + e.getMessage() + "\"}";
    }

    private List<NodeInfo> loadNodeInfos(String probeHost, String keyspace, boolean debug) {
        if (!debug) {
            return ringService.loadNodeInfos(probeHost, keyspace);
        }
        int maxDc = 3;
        int maxRackPerDc = 1;
        int maxParticipantPerDc = RandomUtils.nextInt(6) + 4;
        List<NodeInfo> results = newArrayList();
        for (int dc = 1; dc <= maxDc; dc++) {
            for (int rack = 1; rack <= maxRackPerDc; rack++) {
                for (int participant = 1; participant <= maxParticipantPerDc; participant++) {
                    NodeInfo nodeInfo = new NodeInfo();
                    nodeInfo.token = RandomStringUtils.randomNumeric(39);
                    nodeInfo.ip = String.format("10.%d.%d.%d", dc, rack, participant);
                    nodeInfo.dc = "datacenter" + dc;
                    nodeInfo.rack = "rack" + rack;
                    nodeInfo.status = randomStatus();
                    nodeInfo.state = randomState();
                    nodeInfo.load = "" + RandomUtils.nextInt(101);
                    nodeInfo.owns = nodeInfo.load + "%";
                    results.add(nodeInfo);
                }
            }
        }
        return results;
    }

    private NodeState randomState() {
        return NodeInfo.NodeState.values()[RandomUtils.nextInt(NodeInfo.NodeState.values().length)];
    }

    private NodeStatus randomStatus() {
        NodeStatus ret = NodeInfo.NodeStatus.values()[RandomUtils.nextInt(NodeInfo.NodeStatus.values().length)];
        if (ret == NodeStatus.unknown && RandomUtils.nextInt(10) < 7) { // allow only 30% of generated unknown
            return randomStatus();
        }
        return ret;
    }
}
