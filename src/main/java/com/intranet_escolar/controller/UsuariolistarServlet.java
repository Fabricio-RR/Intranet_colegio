
package com.intranet_escolar.controller;

import com.intranet_escolar.dao.UsuarioDAO;
import com.intranet_escolar.model.entity.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;


@WebServlet(name = "UsuariolistarServlet", urlPatterns = {"/usuario/usuarios"})
public class UsuariolistarServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UsuarioDAO usuarioDAO = new UsuarioDAO();
        List<Usuario> listaUsuarios = usuarioDAO.listarUsuariosCompletos();

        request.setAttribute("usuarios", listaUsuarios);
        request.getRequestDispatcher("/views/usuario/usuarios.jsp").forward(request, response);
    }
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
