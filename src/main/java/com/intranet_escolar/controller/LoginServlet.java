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
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String dni = request.getParameter("dni");
        String clave = request.getParameter("clave");

        try {
            UsuarioDAO usuarioDAO = new UsuarioDAO();
            Usuario usuario = usuarioDAO.login(dni, clave); // usa tu SP

            if (usuario != null) {
                // Si la clave fue verificada, cargamos los permisos
                List<Permiso> permisos = usuarioDAO.obtenerPermisos(usuario.getRoles());
                
                // Usuario encontrado, establecer sesión
                HttpSession session = request.getSession();
                session.setAttribute("usuario", usuario); // datos del usuario
                session.setAttribute("permisos", permisos); // permisos dinámicos

                response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp"); // página principal
            } else {
                // Usuario no encontrado o clave incorrecta
                request.setAttribute("error", "DNI o contraseña incorrectos.");
                request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error del sistema: " + e.getMessage());
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet para autenticar usuarios en el sistema escolar.";
    }// </editor-fold>

}
