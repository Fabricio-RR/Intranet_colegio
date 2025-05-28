package com.intranet_escolar.controller;

import com.intranet_escolar.dao.UsuarioDAO;
import com.intranet_escolar.model.entity.Permiso;
import com.intranet_escolar.model.entity.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/views/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String dni = request.getParameter("dni");
        String clave = request.getParameter("password"); // Asegúrate que el input se llama "password" en el JSP

        try {
            UsuarioDAO usuarioDAO = new UsuarioDAO();
            Usuario usuario = usuarioDAO.login(dni, clave);

            if (usuario != null) {
                // Si existe y la clave es válida
                List<Permiso> permisos = usuarioDAO.obtenerPermisos(usuario.getRoles());

                HttpSession session = request.getSession();
                session.setAttribute("usuario", usuario);
                session.setAttribute("permisos", permisos);

                response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp");
            } else {
                // Usuario no existe o clave incorrecta
                request.setAttribute("error", "DNI o contraseña incorrectos.");
                request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace(); // Para depuración
            request.setAttribute("error", "Error del sistema: " + e.getMessage());
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet para autenticación de usuarios";
    }
}
