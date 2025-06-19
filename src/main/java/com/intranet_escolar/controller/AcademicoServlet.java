package com.intranet_escolar.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.intranet_escolar.config.DatabaseConfig;
import com.intranet_escolar.model.entity.Grado;
import com.intranet_escolar.model.entity.Seccion;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/carga-academica")
public class AcademicoServlet extends HttpServlet {
    
    private final ObjectMapper objectMapper = new ObjectMapper(); // Jackson

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String tipo = request.getParameter("tipo");
        String id = request.getParameter("id"); // puede ser id_nivel o id_grado

        if (tipo == null || id == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Faltan parámetros.");
            return;
        }

        Object resultado = null;

        try (Connection con = DatabaseConfig.getConnection()) {
            switch (tipo) {
                case "cargar-grados":
                    resultado = obtenerGrados(con, Integer.parseInt(id));
                    break;
                case "cargar-secciones":
                    resultado = obtenerSecciones(con, Integer.parseInt(id));
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Tipo inválido.");
                    return;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error de base de datos.");
            return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        objectMapper.writeValue(response.getWriter(), resultado);
    }

    private List<Grado> obtenerGrados(Connection con, int idNivel) throws SQLException {
        List<Grado> grados = new ArrayList<>();
        String sql = "SELECT id_grado, nombre FROM grado WHERE id_nivel = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idNivel);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Grado g = new Grado();
                g.setIdGrado(rs.getInt("id_grado"));
                g.setNombre(rs.getString("nombre"));
                grados.add(g);
            }
        }
        return grados;
    }

    private List<Seccion> obtenerSecciones(Connection con, int idGrado) throws SQLException {
        List<Seccion> secciones = new ArrayList<>();
        String sql = "SELECT DISTINCT s.id_seccion, s.nombre " +
                 "FROM apertura_seccion aps " +
                 "INNER JOIN seccion s ON aps.id_seccion = s.id_seccion " +
                 "WHERE aps.id_grado = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idGrado);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Seccion s = new Seccion();
                s.setIdSeccion(rs.getInt("id_seccion"));
                s.setNombre(rs.getString("nombre"));
                secciones.add(s);
            }
        }
        return secciones;
    }
}
