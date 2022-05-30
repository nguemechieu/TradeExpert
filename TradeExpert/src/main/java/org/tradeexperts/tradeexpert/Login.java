package org.tradeexperts.tradeexpert;

import javax.ws.rs.GET;
import javax.ws.rs.Produces;

public class Login {
    @GET
    @Produces("text/plain")
    public String hello() {
        return "Hello, World!";
    }
}
