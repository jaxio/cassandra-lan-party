package org.apache.cassandra.party;

import static com.google.common.collect.Lists.newArrayList;

import java.util.List;

import lombok.Data;

@Data
public class DataCenter {
    private List<Participant> participants = newArrayList();
    private final String id;
    private final String name;

    public DataCenter(int number) {
        this.id = "dc" + number;
        this.name = DataCenterNamer.getNicerDataCenterName(number);
    }
}
