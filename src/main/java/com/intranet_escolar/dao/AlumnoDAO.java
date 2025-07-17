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
    public List<Alumno> obtenerMatriculadosPorAperturaSeccion(int idAperturaSeccion) {
        List<Alumno> lista = new ArrayList<>();
        String sql =
            "SELECT a.id_alumno, u.nombres, u.apellidos, m.estado AS estado_matricula " +
            "FROM alumno a " +
            "INNER JOIN usuario u ON a.id_alumno = u.id_usuario " +
            "INNER JOIN matricula m ON a.id_alumno = m.id_alumno " +
            "WHERE a.id_apertura_seccion = ? " +
            "  AND m.estado IN ('regular','condicional') ";
        try (Connection con = DatabaseConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idAperturaSeccion);
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
    public List<Alumno> listarMatriculadosPorAnio(int idAnioLectivo) {
        List<Alumno> lista = new ArrayList<>();
        String sql =
            "SELECT DISTINCT a.id_alumno, u.nombres, u.apellidos, m.estado AS estado_matricula " +
            "FROM alumno a " +
            "INNER JOIN usuario u ON a.id_alumno = u.id_usuario " +
            "INNER JOIN matricula m ON a.id_alumno = m.id_alumno " +
            "INNER JOIN apertura_seccion aps ON m.id_apertura_seccion = aps.id_apertura_seccion " +
            "WHERE aps.id_anio_lectivo = ? " +
            "  AND m.estado IN ('regular','condicional')";
        try (Connection con = DatabaseConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idAnioLectivo);
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
    
    public List<Alumno> listarMatriculadosPorFiltros(
        int idAnio, int idNivel, int idGrado, int idSeccion) {
    List<Alumno> lista = new ArrayList<>();
    StringBuilder sql = new StringBuilder(
      "SELECT DISTINCT a.id_alumno, u.nombres, u.apellidos, a.codigo_matricula " +
      "FROM alumno a " +
      "  JOIN usuario u    ON a.id_alumno            = u.id_usuario " +
      "  JOIN matricula m  ON a.id_alumno            = m.id_alumno " +
      "  JOIN apertura_seccion aps ON m.id_apertura_seccion = aps.id_apertura_seccion " +
      "  JOIN anio_lectivo al ON aps.id_anio_lectivo  = al.id_anio_lectivo " +
      "  JOIN grado g      ON aps.id_grado           = g.id_grado " +
      "  JOIN nivel n      ON g.id_nivel             = n.id_nivel " +
      "  JOIN seccion s    ON aps.id_seccion         = s.id_seccion " +
      "WHERE aps.id_anio_lectivo = ? " +
      "  AND m.estado       IN ('regular','condicional') " +
      "  AND aps.activo     = 1 " +
      "  AND al.estado     IN ('activo','cerrado') "
    );
    if (idNivel   > 0) sql.append(" AND n.id_nivel   = ? ");
    if (idGrado   > 0) sql.append(" AND g.id_grado   = ? ");
    if (idSeccion > 0) sql.append(" AND s.id_seccion = ? ");
    sql.append("ORDER BY u.apellidos, u.nombres");

    try (Connection conn = DatabaseConfig.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql.toString())) {
        int idx = 1;
        ps.setInt(idx++, idAnio);
        if (idNivel   > 0) ps.setInt(idx++, idNivel);
        if (idGrado   > 0) ps.setInt(idx++, idGrado);
        if (idSeccion > 0) ps.setInt(idx++, idSeccion);

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Alumno al = new Alumno();
                al.setIdAlumno(rs.getInt("id_alumno"));
                al.setNombres(rs.getString("nombres"));
                al.setApellidos(rs.getString("apellidos"));
                al.setCodigoMatricula(rs.getString("codigo_matricula"));
                lista.add(al);
            }
        }
    } catch (SQLException e) {
        throw new RuntimeException("Error listando alumnos por filtros", e);
    }
    return lista;
}


}

