package org.apache.cassandra.party.service;


public class NodeInfo {
    
    public String ip;
    public String dc;
    public String rack;
    public String status;
    public String state;
    public String load;
    public String owns;
    public String token;
    
    @Override
    public String toString() {
        return "ip:" + ip + ", dc: " +dc + ", rack: " + rack + ", status: " + status; // todo lombok  :-)
    }
}
