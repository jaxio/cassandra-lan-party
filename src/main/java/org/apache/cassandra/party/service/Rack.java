package org.apache.cassandra.party.service;

import java.util.ArrayList;
import java.util.List;

public class Rack {

    public String id;
    public String name;
    public RackData data = new RackData(this);
    public List<Host> children = new ArrayList<Host>();
    
    public static class RackData {
        private Rack parent; 
        public RackData(Rack parent) {
            this.parent = parent;
        }
        
        public String get$NbMachines() {
            return ""+parent.children.size();
        }
        public String color;
        public int area;
    }

}
