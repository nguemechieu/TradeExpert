package com.tradeexperts.tradeexperts;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;

@Path("/hello-world")
public class TradExpResource {
    @GET
    @Produces("text/plain")
    public String hello() {
        return "Hello world, Welcome to TradeExperts!";
    }
}