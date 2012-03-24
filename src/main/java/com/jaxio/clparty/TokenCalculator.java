package com.jaxio.clparty;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

public class TokenCalculator {
    
    
    public static void main(String args[]) {
        calculateToken(60);
    }
    
    
    public static List<String> calculateToken(int nbHost) {
        List<String> result = new ArrayList<String>();
        
        for (int i=0; i < nbHost; i++) {
            
            BigInteger token = new BigInteger("2");
            
            token = token.pow(127);
            token = token.multiply(new BigInteger(""+i));
            token = token.divide(new BigInteger(""+nbHost));
            
            String tokenApprox = token.toString();
            if (tokenApprox.length() > 1) {
                tokenApprox = tokenApprox.substring(0,3) + tokenApprox.substring(3).replaceAll("[0-9]", "0");
                System.out.println(tokenApprox);
                System.out.println(tokenApprox.substring(0,3) + " followed by " + tokenApprox.substring(3).length() + " 0");
            }
        }
        return null;
    }
}
