package org.apache.cassandra.party;

import static com.google.common.base.Preconditions.checkState;
import static com.google.common.collect.Lists.newArrayList;

import java.util.List;

import lombok.Data;

@Data
public class DataCenter {
    private List<Participant> participants = newArrayList();
    private final String name;

    public DataCenter(int number) {
        checkState(number < towns.length, "I need a town name for %s", number);
        this.name = towns[number];
    }

    private static final String[] towns = { "Dunkerque", "Paris", "Lille", "Ajaccio", //
            "New-York", "Tokyo", "Sidney", "Moscow", //
            "Seoul", "Mumbai", "Delhi", "Shanghai", //
            "Lagos", "Chicago", "Beijing", "Houston" };
}
