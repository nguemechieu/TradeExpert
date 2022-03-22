package com.tradeexperts.Server;

import java.io.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

@WebServlet(name = "Welcome to TradeExpert_Servlet", value = "/hello-servlet")
public class TradExpServlet extends HttpServlet {
    private String message;

    public void init() {
        message = "WELCOME TO TRADE_EXPERT_SERVER!";
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html");

        // Hello
        PrintWriter out = response.getWriter();
        out.println("<html><body>");
        out.println("<h1>" +"WELCOME  "+ message + "</h1>");
        out.println("</body></html>");
    }

    public void destroy() {
    }
}