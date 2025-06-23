/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.intranet_escolar.service;

import com.intranet_escolar.dao.UsuarioDAO;
import com.intranet_escolar.model.entity.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 *
 * @author Hp
 */
@WebServlet(name = "UsuarioBusquedaRest", urlPatterns = {"/usuarios/buscar"})
public class UsuarioBusquedaRest extends HttpServlet {
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String termino = request.getParameter("term");
        String rol = request.getParameter("rol"); // "Alumno", "Apoderado", "Docente", etc.

        response.setContentType("application/json; charset=UTF-8");
        List<Usuario> resultados = usuarioDAO.buscarUsuariosPorTerminoYRol(termino, rol);

        // Serializa a JSON
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < resultados.size(); i++) {
            Usuario u = resultados.get(i);
            json.append("{")
                .append("\"id\":").append(u.getIdUsuario()).append(",")
                .append("\"dni\":\"").append(u.getDni()).append("\",")
                .append("\"nombres\":\"").append(u.getNombres()).append("\",")
                .append("\"apellidos\":\"").append(u.getApellidos()).append("\"")
                .append("}");
            if (i < resultados.size() - 1) json.append(",");
        }
        json.append("]");
        response.getWriter().write(json.toString());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
    
    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
