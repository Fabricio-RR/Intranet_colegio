package com.intranet_escolar.controller;

import com.intranet_escolar.dao.UsuarioDAO;
import com.intranet_escolar.model.entity.Permiso;
import com.intranet_escolar.model.entity.Usuario;
import com.intranet_escolar.model.entity.Rol;
import com.intranet_escolar.model.entity.MenuItem;
import com.intranet_escolar.service.MenuService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

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
                session.setAttribute("usuario", usuario);

                List<Rol> roles = usuario.getRoles();
                session.setAttribute("usuario", usuario);
                session.setAttribute("roles", roles);

                // Convertir los roles a String para los SP de permisos y menú
                List<String> nombresRoles = roles.stream()
                        .map(Rol::getNombre)
                        .collect(Collectors.toList());

                List<Permiso> permisos = usuarioDAO.obtenerPermisos(nombresRoles);
                List<MenuItem> menuItems = MenuService.generarMenuPorRoles(nombresRoles);

                session.setAttribute("permisos", permisos);
                session.setAttribute("menuItems", menuItems);

                if (roles.size() == 1) {
                    String rol = roles.get(0).getNombre().toLowerCase();
                    session.setAttribute("rolActivo", rol);
                    response.sendRedirect(request.getContextPath() + "/dashboard/" + rol);
                } else {
                    response.sendRedirect(request.getContextPath() + "/views/selec-rol.jsp");
                }

            } else {
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
        return "Servlet para autenticación de usuarios con redirección por rol";
    }
}
