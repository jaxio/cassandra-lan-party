package org.apache.cassandra.party.service;

import java.net.UnknownHostException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;

import org.apache.cassandra.dht.Token;
import org.apache.cassandra.tools.NodeProbe;
import org.springframework.stereotype.Service;

@Service
public class RingService {
    
    private NodeProbe probe;
    
    public RingService() throws Exception {
        probe = new NodeProbe("127.0.0.1");
    }

    public List<NodeInfo> loadNodeInfos(String keyspace)
    {
        Map<Token, String> tokenToEndpoint = probe.getTokenToEndpointMap();
        List<Token> sortedTokens = new ArrayList<Token>(tokenToEndpoint.keySet());

        Collection<String> liveNodes = probe.getLiveNodes();
        Collection<String> deadNodes = probe.getUnreachableNodes();
        Collection<String> joiningNodes = probe.getJoiningNodes();
        Collection<String> leavingNodes = probe.getLeavingNodes();
        Collection<String> movingNodes = probe.getMovingNodes();
        Map<String, String> loadMap = probe.getLoadMap();

        // Calculate per-token ownership of the ring
        Map<Token, Float> ownerships;
        ownerships = probe.getOwnership();


        List<NodeInfo> results = new ArrayList<NodeInfo>();
        
        for (Token token : sortedTokens)
        {
            NodeInfo nodeInfo = new NodeInfo();
            results.add(nodeInfo);
            
            nodeInfo.token = token.toString();
            
            nodeInfo.ip = tokenToEndpoint.get(token);
            
            try
            {
                nodeInfo.dc = probe.getEndpointSnitchInfoProxy().getDatacenter(nodeInfo.ip);
            }
            catch (UnknownHostException e)
            {
                nodeInfo.dc = "Unknown";
            }
            try
            {
                nodeInfo.rack = probe.getEndpointSnitchInfoProxy().getRack(nodeInfo.ip);
            }
            catch (UnknownHostException e)
            {
                nodeInfo.rack = "Unknown";
            }
            nodeInfo.status= liveNodes.contains(nodeInfo.ip)
                            ? "Up"
                            : deadNodes.contains(nodeInfo.ip)
                              ? "Down"
                              : "?";

            
            nodeInfo.state = "Normal";

            if (joiningNodes.contains(nodeInfo.ip))
                nodeInfo.state = "Joining";
            else if (leavingNodes.contains(nodeInfo.ip))
                nodeInfo.state = "Leaving";
            else if (movingNodes.contains(nodeInfo.ip))
                nodeInfo.state = "Moving";

            nodeInfo.load = loadMap.containsKey(nodeInfo.ip) ? loadMap.get(nodeInfo.ip) : "?";
            nodeInfo.owns= new DecimalFormat("##0.00%").format(ownerships.get(token) == null ? 0.0F : ownerships.get(token));
            
            
        }
        
        return results;
    }
}
