package org.apache.cassandra.party;

import static com.google.common.collect.Lists.newArrayList;

import java.util.List;

import lombok.Data;

@Data
public class DataCenter {
    private int number = -1;
    private List<Participant> participants = newArrayList();

    public DataCenter(int number) {
        this.number = number;
    }

    public String getName() {
        switch (number) {
        case 1:
            return "Lille";
        case 2:
            return "Paris";
        case 3:
            return "Ajaccio";
        default:
            throw new IllegalStateException("Unknown datacenter " + number);
        }
    }
}
