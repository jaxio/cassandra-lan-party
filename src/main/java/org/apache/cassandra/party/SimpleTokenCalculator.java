package org.apache.cassandra.party;

import static com.google.common.collect.Lists.newArrayList;

import java.math.BigInteger;
import java.util.List;

public class SimpleTokenCalculator {

    public static List<DataCenter> calculate(int nbDataCenter, int nbRackPerDataCenter, int nbParticipantPerRack) {
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
                    p.setNodeIndexInDataCenter(rack + (positionInRack - 1) * nbRackPerDataCenter);
                    setParticipantToken(nbParticipantPerDataCenter, p);
                    dataCenter.getParticipants().add(p);
                }
            }
            dataCenters.add(dataCenter);
        }
        return dataCenters;
    }

    private static void setParticipantToken(int nbParticipantPerDataCenter, Participant p) {
        BigInteger token = new BigInteger("2");
        token = token.pow(127);
        token = token.multiply(new BigInteger("" + (p.getNodeIndexInDataCenter() - 1)));
        token = token.divide(new BigInteger("" + nbParticipantPerDataCenter));
        p.token = token.add(new BigInteger("" + (p.getDc() - 1))).toString();
    }
}
