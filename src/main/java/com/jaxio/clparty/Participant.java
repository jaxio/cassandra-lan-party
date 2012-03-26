package com.jaxio.clparty;

public class Participant {
    public int dc = -1;
    public int rack = -1;
    public int positionInRack = -1;
    public int nodeIndexInDataCenter = -1;

    public String name;
    public String token;
    
    public String getIp() {
        return "10." + dc + "." + rack + "." + positionInRack;
    }
    
    public int getTokenIndexInDataCenter() {
        return positionInRack + rack ;
    }
    
    @Override
    public String toString() {
        return getIp() +"=DC" + dc + ":RACK" + rack + " ("+ nodeIndexInDataCenter + ") initial_token=" + token + " ==> " + name;  
    }
}