package org.apache.cassandra.party.service;

import java.util.ArrayList;
import java.util.List;

public class Dc {
    public String id;
    public String name;
    public DcData data = new DcData(this);

    public List<Rack> children = new ArrayList<Rack>();

    public Rack getRack(String id) {
        for (Rack rack : children) {
            if (rack.id.equals(id)) {
                return rack;
            }
        }
        return null;
    }

    public class DcData {
        Dc parent;
        public DcData(Dc parent) {
            this.parent = parent;
        }
        
        public String get$nbMachines() {
            return "" + parent.children.size();
        }
        public String $color;
        public int area;
    }
}
