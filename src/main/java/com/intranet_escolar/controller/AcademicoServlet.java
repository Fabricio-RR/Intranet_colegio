package com.intranet_escolar.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.intranet_escolar.config.DatabaseConfig;
import com.intranet_escolar.model.entity.Alumno;
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
        String id = request.getParameter("id"); // id_nivel o id_grado
        String anio = request.getParameter("anio"); // id_anio_lectivo

        // Asegura que todos los parámetros requeridos estén presentes
        if (tipo == null || id == null || anio == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Faltan parámetros.");
            return;
        }

        Object resultado = null;

        try (Connection con = DatabaseConfig.getConnection()) {
            switch (tipo) {
                case "cargar-grados":
                    resultado = obtenerGradosPorNivelYAnio(con, Integer.parseInt(id), Integer.parseInt(anio));
                    break;
                case "cargar-secciones":
                    resultado = obtenerSeccionesPorGradoYAnio(con, Integer.parseInt(id), Integer.parseInt(anio));
                    break;
                // Si deseas: case "cargar-alumnos": resultado = ... break;
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

    // -------- Métodos filtrados por año lectivo --------
    private List<Grado> obtenerGradosPorNivelYAnio(Connection con, int idNivel, int idAnio) throws SQLException {
        List<Grado> grados = new ArrayList<>();
        String sql = "SELECT DISTINCT g.id_grado, g.nombre " +
                     "FROM apertura_seccion aps " +
                     "INNER JOIN grado g ON aps.id_grado = g.id_grado " +
                     "WHERE g.id_nivel = ? AND aps.id_anio_lectivo = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idNivel);
            ps.setInt(2, idAnio);
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

    private List<Seccion> obtenerSeccionesPorGradoYAnio(Connection con, int idGrado, int idAnio) throws SQLException {
        List<Seccion> secciones = new ArrayList<>();
        String sql = "SELECT DISTINCT s.id_seccion, s.nombre " +
                     "FROM apertura_seccion aps " +
                     "INNER JOIN seccion s ON aps.id_seccion = s.id_seccion " +
                     "WHERE aps.id_grado = ? AND aps.id_anio_lectivo = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idGrado);
            ps.setInt(2, idAnio);
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


    private List<Alumno> obtenerAlumnosPorSeccionYAnio(Connection con, int idSeccion, int idAnio) throws SQLException {
        List<Alumno> alumnos = new ArrayList<>();
        String sql = "SELECT a.id_alumno, u.nombres, u.apellidos " +
                     "FROM alumno a " +
                     "INNER JOIN usuario u ON a.id_alumno = u.id_usuario " +
                     "INNER JOIN matricula m ON a.id_alumno = m.id_alumno " +
                     "INNER JOIN apertura_seccion aps ON m.id_apertura_seccion = aps.id_apertura_seccion " +
                     "WHERE aps.id_seccion = ? AND aps.id_anio_lectivo = ? AND m.estado IN ('regular','condicional')";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idSeccion);
            ps.setInt(2, idAnio);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Alumno a = new Alumno();
                a.setIdAlumno(rs.getInt("id_alumno"));
                a.setNombres(rs.getString("nombres"));
                a.setApellidos(rs.getString("apellidos"));
                alumnos.add(a);
            }
        }
        return alumnos;
    }

}
