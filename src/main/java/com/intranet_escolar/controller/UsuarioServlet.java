package com.intranet_escolar.controller;

import com.intranet_escolar.dao.UsuarioDAO;
import com.intranet_escolar.model.entity.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "UsuarioServlet", urlPatterns = {"/usuarios"})
public class UsuarioServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        if (action != null && idParam != null) {
            int id = Integer.parseInt(idParam);
            Usuario usuario = usuarioDAO.obtenerUsuarioCompletoPorId(id); // con roles, alumno, docente, apoderado, etc.

            request.setAttribute("usuario", usuario);

            switch (action) {
                case "ver":
                    request.getRequestDispatcher("/views/usuario/ver.jsp").forward(request, response);
                    return;

                case "editar":
                    request.setAttribute("rolesDisponibles", usuarioDAO.listarTodosLosRoles());
                    request.setAttribute("usuario.rolesAsIds", usuario.getRolesAsIds());
                    request.getRequestDispatcher("/views/usuario/editar.jsp").forward(request, response);
                    return;

                case "bitacora":
                    request.setAttribute("registros", usuarioDAO.obtenerBitacoraPorUsuario(id));
                    request.getRequestDispatcher("/views/usuario/bitacora.jsp").forward(request, response);
                    return;

                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Acción no válida");
                    return;
            }
        }

        // Vista general: listar todos
        List<Usuario> listaUsuarios = usuarioDAO.listarUsuariosCompletos();
        request.setAttribute("usuarios", listaUsuarios);
        request.getRequestDispatcher("/views/usuario/usuarios.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Controlador de gestión de usuarios";
    }
}
