package org.apache.cassandra.party.service;

import static org.apache.commons.lang.StringUtils.substringBefore;

import org.apache.commons.lang.builder.CompareToBuilder;

import lombok.ToString;

@ToString
public class NodeInfo implements Comparable<NodeInfo> {
    public String ip;
    public String dc;
    public String rack;
    public NodeStatus status;
    public NodeState state;
    public String load;
    public String owns;
    public String token;

    public int $area = 1;
    public String $color = "#2d6987";

    public int owns() {
        String val = substringBefore(owns, ",");
        val = substringBefore(val, "%");
        return Integer.valueOf(val);

    }

    public static enum NodeState {
        joining("#49AFCD"), leaving("#FAA732"), moving("whiteSmoke"), normal("#5BB75B");
        private String color;

        NodeState(String color) {
            this.color = color;
        }

        public String color() {
            return color;
        }

    }

    public static enum NodeStatus {
        up("#5BB75B"), down("#DA4F49"), unknown("#414141");
        private String color;

        NodeStatus(String color) {
            this.color = color;
        }

        public String color() {
            return color;
        }
    }

    @Override
    public int compareTo(NodeInfo o) {
       return toString().compareTo(o.toString());
    }
}
