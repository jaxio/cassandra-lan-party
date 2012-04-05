package org.apache.cassandra.party;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;


public class SimpleTokenCalculator {

    public static List<Participant> calculate(int nbDataCenter, int nbRackPerDataCenter, int nbParticipantPerRack) {
        List<Participant> result = new ArrayList<Participant>();
        
        int nbParticipantPerDataCenter = nbRackPerDataCenter * nbParticipantPerRack;
        
        for (int dc=1; dc <= nbDataCenter; dc++) {
            for (int rack=1; rack <= nbRackPerDataCenter; rack++) {
                for (int positionInRack = 1; positionInRack <= nbParticipantPerRack ; positionInRack++) {                    
                    Participant p = new Participant();
                    p.dc = dc;
                    p.rack = rack;
                    p.positionInRack = positionInRack;                    
                    p.nodeIndexInDataCenter = rack + (positionInRack - 1) * nbRackPerDataCenter;
                    setParticipantToken(nbParticipantPerDataCenter, p);
                    result.add(p);
                }
            }
        }
        
        return result;           
    }
        
    
    public static void setParticipantToken(int nbParticipantPerDataCenter, Participant p) {
        
        BigInteger token = new BigInteger("2");
        
        token = token.pow(127);
        token = token.multiply(new BigInteger("" + (p.nodeIndexInDataCenter -1)));
        token = token.divide(new BigInteger("" + nbParticipantPerDataCenter));        
       
//        // for better readability we round the token
//        String tokenApprox = token.toString();
//        if (tokenApprox.length() > 1) {
//            tokenApprox = tokenApprox.substring(0,3) + tokenApprox.substring(3).replaceAll("[0-9]", "0");
//        }
//        
//        // Do the DC +1 stuff
//        tokenApprox = tokenApprox.substring(0,tokenApprox.length() -1) + (p.dc - 1); 
        
        p.token = token.add(new BigInteger("" + (p.dc - 1))).toString();
    }
}
