package org.apache.cassandra.party.service;

import static com.google.common.collect.Lists.newArrayList;
import static org.apache.cassandra.party.service.NodeInfo.NodeState.joining;
import static org.apache.cassandra.party.service.NodeInfo.NodeState.leaving;
import static org.apache.cassandra.party.service.NodeInfo.NodeState.moving;
import static org.apache.cassandra.party.service.NodeInfo.NodeState.normal;
import static org.apache.cassandra.party.service.NodeInfo.NodeStatus.down;
import static org.apache.cassandra.party.service.NodeInfo.NodeStatus.unknown;
import static org.apache.cassandra.party.service.NodeInfo.NodeStatus.up;

import java.io.IOException;
import java.net.UnknownHostException;
import java.text.DecimalFormat;
import java.util.List;
import java.util.Map;

import org.apache.cassandra.dht.Token;
import org.apache.cassandra.party.service.NodeInfo.NodeState;
import org.apache.cassandra.party.service.NodeInfo.NodeStatus;
import org.apache.cassandra.tools.NodeProbe;
import org.springframework.stereotype.Service;

@Service
public class RingService {

    @SuppressWarnings("rawtypes")
    public List<NodeInfo> loadNodeInfos(String hostIp, String keyspace) {
        if (hostIp == null || hostIp.isEmpty()) {
            hostIp = "127.0.0.1";
        }

        List<NodeInfo> results = newArrayList();
        NodeProbe probe;

        try {
            probe = new NodeProbe(hostIp);
        } catch (IOException e) {
           return results;
        } catch (InterruptedException e) {
            return results;
        }
    		
		Map<Token, String> tokenToEndpoint = probe.getTokenToEndpointMap();
		
		for (Token token : newArrayList(tokenToEndpoint.keySet())) {
			NodeInfo nodeInfo = new NodeInfo();
			nodeInfo.token = token.toString();
			nodeInfo.ip = tokenToEndpoint.get(token);
			nodeInfo.dc = getDc(probe, nodeInfo);
			nodeInfo.rack = getRack(probe, nodeInfo);
			nodeInfo.status = getStatus(probe, nodeInfo);
			nodeInfo.state = getState(probe, nodeInfo);
			nodeInfo.load = getLoad(probe, nodeInfo);
			nodeInfo.owns = getOwns(probe, token);
			
			results.add(nodeInfo);
		}
    	
    	try {
    	    return results;
    	} finally {
    	    try {
    	        probe.close();
    	    } catch (IOException ioe) {    	        
    	    }
    	}
    }

    private String getDc(NodeProbe probe, NodeInfo nodeInfo) {
        try {
            return probe.getEndpointSnitchInfoProxy().getDatacenter(nodeInfo.ip);
        } catch (UnknownHostException e) {
            return "Unknown";
        }
    }

    private String getRack(NodeProbe probe, NodeInfo nodeInfo) {
        try {
            return probe.getEndpointSnitchInfoProxy().getRack(nodeInfo.ip);
        } catch (UnknownHostException e) {
            return "Unknown";
        }
    }

    private NodeStatus getStatus(NodeProbe probe, NodeInfo nodeInfo) {
        if (probe.getLiveNodes().contains(nodeInfo.ip)) {
            return up;
        } else if (probe.getUnreachableNodes().contains(nodeInfo.ip)) {
            return down;
        } else {
            return unknown;
        }
    }

    private NodeState getState(NodeProbe probe, NodeInfo nodeInfo) {
        if (probe.getJoiningNodes().contains(nodeInfo.ip)) {
            return joining;
        } else if (probe.getLeavingNodes().contains(nodeInfo.ip)) {
            return leaving;
        } else if (probe.getMovingNodes().contains(nodeInfo.ip)) {
            return moving;
        } else {
            return normal;
        }
    }

    private String getLoad(NodeProbe probe, NodeInfo nodeInfo) {
        if (probe.getLoadMap().containsKey(nodeInfo.ip)) {
            return probe.getLoadMap().get(nodeInfo.ip);
        } else {
            return "?";
        }
    }

    @SuppressWarnings("rawtypes")
    private String getOwns(NodeProbe probe, Token token) {
        Map<Token, Float> ownerships = probe.getOwnership();
        return new DecimalFormat("##0.00%").format(ownerships.get(token) == null ? 0.0F : ownerships.get(token));
    }
}
