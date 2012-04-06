package org.apache.cassandra.party.service;

import static java.util.UUID.randomUUID;
import lombok.Data;

@Data
public class Host {
    private String id = randomUUID().toString();;
    private String name;
    private NodeInfo data;

    public Host(NodeInfo node) {
        this.name = node.ip;
        this.data = node;
        this.data.$color = node.status.color();
        this.data.$area = node.owns();
    }
}
