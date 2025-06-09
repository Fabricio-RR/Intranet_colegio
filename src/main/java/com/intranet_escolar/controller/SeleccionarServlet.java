package com.intranet_escolar.controller;

import com.intranet_escolar.dao.UsuarioDAO;
import com.intranet_escolar.model.entity.MenuItem;
import com.intranet_escolar.model.entity.Permiso;
import com.intranet_escolar.model.entity.Usuario;
import com.intranet_escolar.service.MenuService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "SeleccionarRolServlet", urlPatterns = {"/selec-rol"})
public class SeleccionarServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String rol = request.getParameter("rol");
        HttpSession session = request.getSession();

        if (rol != null && session.getAttribute("usuario") != null) {
            session.setAttribute("rolActivo", rol.toLowerCase());

            Usuario usuario = (Usuario) session.getAttribute("usuario");

            // Convertir roles a nombre y filtrar solo el seleccionado
            List<String> nombresRoles = usuario.getRoles().stream()
                .map(r -> r.getNombre().toLowerCase())
                .collect(Collectors.toList());

            if (nombresRoles.contains(rol.toLowerCase())) {
                // Regenerar permisos y menú solo para ese rol
                UsuarioDAO dao = new UsuarioDAO();
                List<Permiso> permisos = dao.obtenerPermisos(Collections.singletonList(rol));
                List<MenuItem> menu = MenuService.generarMenuPorRoles(Collections.singletonList(rol));

                session.setAttribute("permisos", permisos);
                session.setAttribute("menuItems", menu);

                response.sendRedirect(request.getContextPath() + "/dashboard/" + rol.toLowerCase());
                return;
            }
        }

        // Fallback
        response.sendRedirect(request.getContextPath() + "/views/login.jsp");
    }
}

