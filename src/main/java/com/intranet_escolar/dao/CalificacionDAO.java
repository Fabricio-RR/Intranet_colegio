package com.intranet_escolar.dao;

import com.intranet_escolar.config.DatabaseConfig;
import com.intranet_escolar.model.entity.Calificacion;
import java.sql.*;
import java.util.*;

public class CalificacionDAO {

    // 1. Listar calificaciones según filtros (para pintar la tabla)
    public List<Calificacion> listarPorFiltros(int idCurso, int idSeccion, int idPeriodo, int idAnioLectivo) {
        List<Calificacion> lista = new ArrayList<>();
        String sql = "{CALL sp_listar_calificaciones(?, ?, ?, ?)}";
        try (Connection con = DatabaseConfig.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {
            cs.setInt(1, idCurso);
            cs.setInt(2, idSeccion);
            cs.setInt(3, idPeriodo);
            cs.setInt(4, idAnioLectivo);
            try (ResultSet rs = cs.executeQuery()) {
                while (rs.next()) {
                    Calificacion cal = new Calificacion();
                    cal.setIdCalificacion(rs.getInt("id_calificacion"));
                    cal.setIdAlumno(rs.getInt("id_alumno"));
                    cal.setIdMallaCriterio(rs.getInt("id_malla_criterio"));
                    cal.setIdAnioLectivo(rs.getInt("id_anio_lectivo"));
                    cal.setNota(rs.getDouble("nota"));
                    cal.setFecha(rs.getDate("fecha"));
                    cal.setObservacion(rs.getString("observacion"));
                    lista.add(cal);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    // 2. Guardar o actualizar una calificación individual
    public void guardarOActualizar(Calificacion calificacion) {
        String sql = "{CALL sp_guardar_actualizar_calificacion(?, ?, ?, ?, ?, ?)}";
        try (Connection con = DatabaseConfig.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {
            cs.setInt(1, calificacion.getIdAlumno());
            cs.setInt(2, calificacion.getIdMallaCriterio());
            cs.setInt(3, calificacion.getIdAnioLectivo());
            cs.setDouble(4, calificacion.getNota());
            cs.setDate(5, new java.sql.Date(calificacion.getFecha().getTime()));
            cs.setString(6, calificacion.getObservacion());
            cs.execute();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    // 3. Obtener una calificación específica (por alumno, criterio y año)
    public Calificacion obtenerPorAlumnoYCriterio(int idAlumno, int idMallaCriterio, int idAnioLectivo) {
        Calificacion cal = null;
        String sql = "SELECT * FROM calificacion WHERE id_alumno = ? AND id_malla_criterio = ? AND id_anio_lectivo = ?";
        try (Connection con = DatabaseConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idAlumno);
            ps.setInt(2, idMallaCriterio);
            ps.setInt(3, idAnioLectivo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    cal = new Calificacion();
                    cal.setIdCalificacion(rs.getInt("id_calificacion"));
                    cal.setIdAlumno(rs.getInt("id_alumno"));
                    cal.setIdMallaCriterio(rs.getInt("id_malla_criterio"));
                    cal.setIdAnioLectivo(rs.getInt("id_anio_lectivo"));
                    cal.setNota(rs.getDouble("nota"));
                    cal.setFecha(rs.getDate("fecha"));
                    cal.setObservacion(rs.getString("observacion"));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return cal;
    }
}
