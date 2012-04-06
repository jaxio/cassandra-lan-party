package org.apache.cassandra.party;

public class Participant {
    
    private boolean currentUser = false;
    
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
    
    
    @Override
    public String toString() {
        return getIp() +"=DC" + dc + ":RACK" + rack + " ("+ nodeIndexInDataCenter + ") initial_token=" + token;
    }

	public boolean isCurrentUser() {
		return currentUser;
	}

	public void setCurrentUser(boolean currentUser) {
		this.currentUser = currentUser;
	}
}
