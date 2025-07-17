package com.intranet_escolar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet({"/error/404", "/error/403", "/error/500"})
public class ErrorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String uri = request.getRequestURI();
        String page = "/error/404.jsp"; 

        if (uri.endsWith("/404")) {
            page = "/error/404.jsp";
        } else if (uri.endsWith("/403")) {
            page = "/error/403.jsp";
        } else if (uri.endsWith("/500")) {
            page = "/error/500.jsp";
        }

        
        request.getRequestDispatcher(page).forward(request, response);
    }
}
