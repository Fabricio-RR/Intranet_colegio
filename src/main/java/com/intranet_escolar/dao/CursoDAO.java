package com.intranet_escolar.dao;

import com.intranet_escolar.config.DatabaseConfig;
import com.intranet_escolar.model.entity.Curso;
import java.sql.*;
import java.util.*;

public class CursoDAO {
    public List<Curso> listarCursosActivos() {
        List<Curso> lista = new ArrayList<>();
        String sql = "SELECT id_curso, nombre, area, orden, activo FROM curso WHERE activo=1 ORDER BY orden ASC, nombre ASC";
        try (Connection con = DatabaseConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Curso c = new Curso();
                c.setIdCurso(rs.getInt("id_curso"));
                c.setNombreCurso(rs.getString("nombre"));
                c.setArea(rs.getString("area"));
                c.setOrden(rs.getInt("orden"));
                c.setActivo(rs.getBoolean("activo")); 
                lista.add(c);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return lista;
    }

    public boolean crearCurso(Curso c) {
        String sql = "INSERT INTO curso(nombre, area, orden, activo) VALUES (?, ?, ?, 1)";
        try (Connection con = DatabaseConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, c.getNombreCurso());
            ps.setString(2, c.getArea());
            ps.setInt(3, c.getOrden());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public boolean editarCurso(Curso c) {
        String sql = "UPDATE curso SET nombre=?, area=?, orden=? WHERE id_curso=?";
        try (Connection con = DatabaseConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, c.getNombreCurso());
            ps.setString(2, c.getArea());
            ps.setInt(3, c.getOrden());
            ps.setInt(4, c.getIdCurso());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public boolean desactivarCurso(int idCurso) {
        String sql = "UPDATE curso SET activo=0 WHERE id_curso=?";
        try (Connection con = DatabaseConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idCurso);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
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
