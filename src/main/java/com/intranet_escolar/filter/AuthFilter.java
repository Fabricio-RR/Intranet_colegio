/*
package com.intranet_escolar.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
        throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        String uri = req.getRequestURI();
        HttpSession session = req.getSession(false);

        boolean loggedIn = (session != null && session.getAttribute("usuarioLogueado") != null);
        boolean isLoginPage = uri.endsWith("login.jsp") || uri.endsWith("/login");

        if (!loggedIn && !isLoginPage && !uri.contains("resources")) {
            resp.sendRedirect(req.getContextPath() + "/views/auth/login.jsp");
        } else {
            chain.doFilter(request, response);
        }
    }
}

eliminar*/
