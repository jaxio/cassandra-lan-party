package org.apache.cassandra.party.service;

import java.util.ArrayList;
import java.util.List;

public class Cluster {    
    public List<Dc> children = new ArrayList<Dc>();
    
    public Dc getDc(String id) {        
        for (Dc dc : children) {
            if (dc.id.equals(id)) {
                return dc;
            }
        }        
        return null;
    }
    
    public static Cluster buildCluster(List<NodeInfo> nodes) {
        Cluster cluster = new Cluster();
        
        for (NodeInfo node : nodes) {
            Dc dc = cluster.getDc(node.dc);
            
            if (dc == null) {
                dc = new Dc();
                dc.id = node.dc;
                dc.name = node.dc; // todo city name
                dc.data.area = 1; // todo ?
                dc.data.$color = "yellow"; // todo ?
                cluster.children.add(dc);
            }
            
            Rack rack = dc.getRack(node.rack);
            
            if (rack == null) {
                rack = new Rack();
                rack.id = node.rack;
                rack.name = "Rack " + node.rack;
                rack.data.area = 1; // todo ?
                rack.data.color = "blue"; // todo ?
                dc.children.add(rack);
            }
            
            Host h = new Host();
            h.id = node.ip;
            h.name = node.ip;
            h.data = node;
            h.data.color = node.state.equals("Up") ? "green" : "red";
            rack.children.add(h);
        }
        
        return cluster;
    }
}
