package com.intranet_escolar.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebFilter(urlPatterns = {"/dashboard/*"})
public class AccessFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        String rolActivo = (session != null) ? (String) session.getAttribute("rolActivo") : null;
        String uri = req.getRequestURI(); // Ej: /Intranet_colegio/views/dashboard/administrador.jsp

        if (rolActivo == null || !uri.contains("/" + rolActivo)) {
            res.sendRedirect(req.getContextPath() + "/error/403"); // Página de acceso denegado
        } else {
            chain.doFilter(request, response); // Rol válido, continuar
        }
    }
}
