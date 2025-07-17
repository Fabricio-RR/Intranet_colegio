package com.intranet_escolar.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/*") // Aplica a todas las rutas
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String path = request.getRequestURI();
        HttpSession session = request.getSession(false);

        boolean isLoginRequest = path.endsWith("login") || path.endsWith("login.jsp");
        boolean isRecuperarRequest = path.contains("recuperar-password");
        boolean isPublicAsset = path.contains("/assets/") || path.endsWith(".css") || path.endsWith(".js") || path.endsWith(".png") || path.endsWith(".jpg");

        boolean loggedIn = session != null && session.getAttribute("usuario") != null;

        if (loggedIn || isLoginRequest || isRecuperarRequest || isPublicAsset) {
            chain.doFilter(req, res); // Permitir acceso
        } else {
            response.sendRedirect(request.getContextPath() + "/login"); // Redirigir a login
        }
    }

    @Override
    public void init(FilterConfig filterConfig) {}

    @Override
    public void destroy() {}
}
