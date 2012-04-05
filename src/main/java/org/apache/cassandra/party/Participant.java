package org.apache.cassandra.party;

public class Participant {
    
    public boolean currentUser = false;
    
    public int dc = -1;
    public int rack = -1;
    public int positionInRack = -1;
    public int nodeIndexInDataCenter = -1;

    public String token;
    
    public String getIp() {
        return "10." + dc + "." + rack + "." + positionInRack;
    }
    
    public int getTokenIndexInDataCenter() {
        return positionInRack + rack ;
    }
    
    public String getDcName() {
        switch(dc) {
            case 1: return "Lille";
            case 2: return "Paris";
            case 3: return "Ajaccio";
            default: throw new IllegalStateException("ooohh");
        }
    }
    
    public String getStyleClass() {
        return "dc" + dc;
    }
    
    
    @Override
    public String toString() {
        return getIp() +"=DC" + dc + ":RACK" + rack + " ("+ nodeIndexInDataCenter + ") initial_token=" + token;
    }
}
