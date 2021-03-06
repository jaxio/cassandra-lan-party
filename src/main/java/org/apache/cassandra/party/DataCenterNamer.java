package org.apache.cassandra.party;

import static com.google.common.base.Preconditions.checkState;

public class DataCenterNamer {

    private static final String[] towns = { "Dunkerque", "Lille", "Paris", "Ajaccio", //
            "New-York", "Tokyo", "Sidney", "Moscow", //
            "Seoul", "Mumbai", "Delhi", "Shanghai", //
            "Lagos", "Chicago", "Beijing", "Houston" };

    public static String getNicerDataCenterName(String dc) {
        try {
            return getNicerDataCenterName(Integer.parseInt(dc));
        } catch (Exception e) {
            // already nice
            return dc;
        }
    }

    public static String getNicerDataCenterName(int dc) {
        checkState(dc < towns.length, "I need a town name for %s", dc);
        return towns[dc] + " (DC" + dc + ")";
    }
}
