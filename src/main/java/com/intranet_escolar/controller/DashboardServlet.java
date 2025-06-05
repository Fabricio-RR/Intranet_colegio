package com.intranet_escolar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard/*"})
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String rolActivo = (String) session.getAttribute("rolActivo");

        if (rolActivo == null || rolActivo.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/views/selec-rol.jsp");
            return;
        }

        // Construimos la ruta del JSP según el rol
        String rutaJSP = "/views/dashboard/" + rolActivo + ".jsp";
        request.getRequestDispatcher(rutaJSP).forward(request, response);
    }
}
