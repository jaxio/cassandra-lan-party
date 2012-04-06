package org.apache.cassandra.party;

import lombok.Data;

@Data
public class Participant {
    private boolean currentUser = false;
    private int dc = -1;
    private int rack = -1;
    private int positionInRack = -1;
    private int nodeIndexInDataCenter = -1;

    public String token;

    public String getIp() {
        return "10." + dc + "." + rack + "." + positionInRack;
    }

    public int getTokenIndexInDataCenter() {
        return positionInRack + rack;
    }

    @Override
    public String toString() {
        return getIp() + "=DC" + dc + ":RACK" + rack + " (" + nodeIndexInDataCenter + ") initial_token=" + token;
    }
}
