package com.intranet_escolar.controller;

import com.intranet_escolar.dao.UsuarioDAO;
import com.intranet_escolar.model.entity.Permiso;
import com.intranet_escolar.model.entity.Usuario;
import com.intranet_escolar.model.entity.MenuItem;
import com.intranet_escolar.service.MenuService;

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
        String clave = request.getParameter("password");

        try {
            UsuarioDAO usuarioDAO = new UsuarioDAO();
            Usuario usuario = usuarioDAO.login(dni, clave);

            if (usuario != null) {
                HttpSession session = request.getSession();
                // Si existe y la clave es válida
                // Permisos por rol
                List<Permiso> permisos = usuarioDAO.obtenerPermisos(usuario.getRoles());
                session.setAttribute("permisos", permisos);

                // Menú según roles
                List<MenuItem> menuItems = MenuService.generarMenuPorRoles(usuario.getRoles());
                session.setAttribute("menuItems", menuItems);

                // Usuario en sesión
                session.setAttribute("usuario", usuario);

                // Redirigir al dashboard
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
