package org.apache.cassandra.party;

import static com.google.common.collect.Lists.newArrayList;

import java.math.BigInteger;
import java.util.List;

import org.apache.cassandra.locator.NetworkTopologyStrategy;
import org.apache.cassandra.locator.RackInferringSnitch;

/**
 * Calculates Token values and IP addresses for {@link NetworkTopologyStrategy} and {@link RackInferringSnitch}.
 */
public class SimpleTokenCalculator {

    public static List<DataCenter> buildDataCenters(int nbDataCenter, int nbRackPerDataCenter, int nbParticipantPerRack) {
        List<DataCenter> dataCenters = newArrayList();
        int nbParticipantPerDataCenter = nbRackPerDataCenter * nbParticipantPerRack;
        for (int dc = 1; dc <= nbDataCenter; dc++) {
            DataCenter dataCenter = new DataCenter(dc);

            for (int rack = 1; rack <= nbRackPerDataCenter; rack++) {
                for (int positionInRack = 1; positionInRack <= nbParticipantPerRack; positionInRack++) {
                    Participant p = new Participant();
                    p.setDc(dc);
                    p.setRack(rack);
                    p.setPositionInRack(positionInRack);

                    // we alternate token
                    p.setNodeIndexInDataCenter(rack + (positionInRack - 1) * nbRackPerDataCenter);
                    p.setToken(buildToken(nbParticipantPerDataCenter, p));
                    dataCenter.getParticipants().add(p);
                }
            }
            dataCenters.add(dataCenter);
        }
        return dataCenters;
    }

    private static String buildToken(int nbParticipantPerDataCenter, Participant p) {
        return "" + BigInteger.valueOf(2) //
                .pow(127) //
                .multiply(new BigInteger("" + (p.getNodeIndexInDataCenter() - 1))) //
                .divide(new BigInteger("" + nbParticipantPerDataCenter)) //
                .add(new BigInteger("" + (p.getDc() - 1))); // the DC +1 trick
    }
}
