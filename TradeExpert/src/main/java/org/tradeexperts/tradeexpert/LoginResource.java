package org.tradeexperts.tradeexpert;

import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;

@Path("/Login")
public class LoginResource {
    @GET
    @Produces("text/plain")
    public String hello() {
        return "Hello, World!";
    }


}
