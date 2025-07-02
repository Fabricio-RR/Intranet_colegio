package com.intranet_escolar.dao;

import com.intranet_escolar.config.DatabaseConfig;
import com.intranet_escolar.model.entity.Curso;
import java.sql.*;
import java.util.*;

public class CursoDAO {
    public List<Curso> listarTodos() {
        List<Curso> lista = new ArrayList<>();
        String sql = "SELECT id_curso, nombre FROM curso WHERE activo=1 ORDER BY nombre";
        try (Connection con = DatabaseConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Curso c = new Curso();
                c.setIdCurso(rs.getInt("id_curso"));
                c.setNombreCurso(rs.getString("nombre"));
                lista.add(c);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return lista;
    }   

    // Lista cursos asignados al usuario (docente o admin) en el año lectivo
    public List<Curso> listarCursosPorUsuarioYAnio(int idUsuario, int idAnioLectivo, String rol) {
        List<Curso> lista = new ArrayList<>();
        String sql;
        if ("administrador".equalsIgnoreCase(rol)) {
            sql = "SELECT c.id_curso, c.nombre " +
                  "FROM curso c " +
                  "INNER JOIN malla_curricular mc ON c.id_curso = mc.id_curso " +
                  "INNER JOIN apertura_seccion aps ON mc.id_apertura_seccion = aps.id_apertura_seccion " +
                  "WHERE aps.id_anio_lectivo = ? AND c.activo=1 " +
                  "GROUP BY c.id_curso, c.nombre ORDER BY c.nombre";
        } else {
            // Solo los cursos que dicta ese docente en el año lectivo
            sql = "SELECT c.id_curso, c.nombre " +
                  "FROM curso c " +
                  "INNER JOIN malla_curricular mc ON c.id_curso = mc.id_curso " +
                  "INNER JOIN apertura_seccion aps ON mc.id_apertura_seccion = aps.id_apertura_seccion " +
                  "WHERE mc.id_docente = ? AND aps.id_anio_lectivo = ? AND c.activo=1 " +
                  "GROUP BY c.id_curso, c.nombre ORDER BY c.nombre";
        }

        try (Connection con = DatabaseConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            if ("administrador".equalsIgnoreCase(rol)) {
                ps.setInt(1, idAnioLectivo);
            } else {
                ps.setInt(1, idUsuario);
                ps.setInt(2, idAnioLectivo);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Curso c = new Curso();
                    c.setIdCurso(rs.getInt("id_curso"));
                    c.setNombreCurso(rs.getString("nombre"));
                    lista.add(c);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return lista;
    }
}
