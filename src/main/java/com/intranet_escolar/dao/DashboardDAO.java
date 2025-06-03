package com.intranet_escolar.dao;

import com.intranet_escolar.config.DatabaseConfig;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DashboardDAO {

    private Connection conn;

    public DashboardDAO() throws SQLException {
        conn = DatabaseConfig.getConnection();
    }

    public Map<String, Object> obtenerEstadisticas() {
        Map<String, Object> stats = new HashMap<>();
        String sql = "{CALL sp_dashboard_estadisticas()}";

        try (CallableStatement stmt = conn.prepareCall(sql)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                stats.put("totalEstudiantes", rs.getInt("total_estudiantes"));
                stats.put("totalDocentes", rs.getInt("total_docentes"));
                stats.put("totalApoderados", rs.getInt("total_apoderados"));
                stats.put("seccionesActivas", rs.getInt("secciones_activas"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return stats;
    }

    public Map<String, Integer> obtenerMatriculaPorNivel() {
        Map<String, Integer> data = new HashMap<>();
        String sql = "{CALL sp_dashboard_matricula_por_nivel()}";

        try (CallableStatement stmt = conn.prepareCall(sql)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                data.put("inicial", rs.getInt("inicial"));
                data.put("primaria", rs.getInt("primaria"));
                data.put("secundaria", rs.getInt("secundaria"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return data;
    }

    public List<Map<String, Object>> obtenerResumenRoles() {
        List<Map<String, Object>> lista = new ArrayList<>();
        String sql = "{CALL sp_dashboard_roles_resumen()}";

        try (CallableStatement stmt = conn.prepareCall(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> rol = new HashMap<>();
                rol.put("nombre", rs.getString("nombre"));
                rol.put("icono", rs.getString("icono"));
                rol.put("codigo", rs.getString("codigo"));
                rol.put("total", rs.getInt("total"));
                rol.put("activos", rs.getInt("activos"));
                rol.put("inactivos", rs.getInt("inactivos"));
                rol.put("ultimoAcceso", rs.getString("ultimo_acceso"));
                lista.add(rol);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }

    public Map<String, Integer> obtenerMetricasSistema() {
        Map<String, Integer> metricas = new HashMap<>();
        String sql = "{CALL sp_dashboard_metrics()}";

        try (CallableStatement stmt = conn.prepareCall(sql)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                metricas.put("totalUsuarios", rs.getInt("total_usuarios"));
                metricas.put("publicacionesActivas", rs.getInt("publicaciones_activas"));
                metricas.put("totalAsistencias", rs.getInt("total_asistencias"));
                metricas.put("totalCalificaciones", rs.getInt("total_calificaciones"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return metricas;
    }
}
