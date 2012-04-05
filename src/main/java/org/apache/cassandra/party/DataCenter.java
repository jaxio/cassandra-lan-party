package org.apache.cassandra.party;

import java.util.ArrayList;
import java.util.List;

public class DataCenter {

	private int number = -1;

	private List<Participant> participants = new ArrayList<Participant>();

	public DataCenter(int number) {
		this.setNumber(number);
	}

	public String getName() {
		switch (getNumber()) {
		case 1:
			return "Lille";
		case 2:
			return "Paris";
		case 3:
			return "Ajaccio";
		default:
			throw new IllegalStateException("ooohh");
		}
	}

	public List<Participant> getParticipants() {
		return participants;
	}

	public void setParticipants(List<Participant> participants) {
		this.participants = participants;
	}

	public int getNumber() {
		return number;
	}

	public void setNumber(int number) {
		this.number = number;
	}

}
