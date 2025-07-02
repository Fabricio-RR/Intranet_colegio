package com.intranet_escolar.dao;

import com.intranet_escolar.config.DatabaseConfig;
import com.intranet_escolar.model.entity.Alumno;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

public class AlumnoDAO {

    // Llama al SP para insertar alumno si no existe
    public String insertarAlumnoSiNoExiste(int idAlumno, int idAperturaSeccion, int anio) {
        String codigoMatricula = null;
        String call = "{CALL sp_insertar_alumno_si_no_existe(?, ?, ?)}";
        String select = "SELECT codigo_matricula FROM alumno WHERE id_alumno = ?";
        try (Connection conn = DatabaseConfig.getConnection()) {
            // Ejecuta el SP
            try (CallableStatement cs = conn.prepareCall(call)) {
                cs.setInt(1, idAlumno);
                cs.setInt(2, idAperturaSeccion);
                cs.setInt(3, anio);
                cs.execute();
            }
            // Consulta el código de matrícula
            try (PreparedStatement ps = conn.prepareStatement(select)) {
                ps.setInt(1, idAlumno);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        codigoMatricula = rs.getString("codigo_matricula");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return codigoMatricula;
    }
    // Lista alumnos matriculados en la sección y año lectivo (no retirados)
    public List<Alumno> obtenerMatriculadosPorSeccion(int idSeccion, int idAnioLectivo) {
        List<Alumno> lista = new ArrayList<>();
        String sql =
            "SELECT a.id_alumno, u.nombres, u.apellidos, m.estado AS estado_matricula " +
            "FROM alumno a " +
            "INNER JOIN usuario u ON a.id_alumno = u.id_usuario " +
            "INNER JOIN matricula m ON a.id_alumno = m.id_alumno " +
            "INNER JOIN apertura_seccion aps ON m.id_apertura_seccion = aps.id_apertura_seccion " +
            "WHERE aps.id_seccion = ? " +
            "  AND aps.id_anio_lectivo = ? " +
            "  AND m.estado IN ('regular','condicional') ";

        try (Connection con = DatabaseConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idSeccion);
            ps.setInt(2, idAnioLectivo);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Alumno a = new Alumno();
                    a.setIdAlumno(rs.getInt("id_alumno"));
                    a.setNombres(rs.getString("nombres"));
                    a.setApellidos(rs.getString("apellidos"));
                    a.setEstadoMatricula(rs.getString("estado_matricula"));
                    lista.add(a);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return lista;
    }


    // Si necesitas también mostrar retirados/egresados (solo lectura), puedes hacer un método similar
    public List<Alumno> obtenerTodosPorSeccion(int idSeccion, int idAnioLectivo) {
        List<Alumno> lista = new ArrayList<>();
        String sql =
            "SELECT a.id_alumno, u.nombres, u.apellidos, m.estado AS estado_matricula " +
            "FROM alumno a " +
            "INNER JOIN usuario u ON a.id_alumno = u.id_usuario " +
            "INNER JOIN matricula m ON a.id_alumno = m.id_alumno " +
            "INNER JOIN apertura_seccion aps ON m.id_apertura_seccion = aps.id_apertura_seccion " +
            "WHERE aps.id_seccion = ? " +
            "  AND aps.id_anio_lectivo = ? ";
        try (Connection con = DatabaseConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idSeccion);
            ps.setInt(2, idAnioLectivo);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Alumno a = new Alumno();
                    a.setIdAlumno(rs.getInt("id_alumno"));
                    a.setNombres(rs.getString("nombres"));
                    a.setApellidos(rs.getString("apellidos"));
                    a.setEstadoMatricula(rs.getString("estado_matricula"));
                    lista.add(a);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return lista;
    }
}
