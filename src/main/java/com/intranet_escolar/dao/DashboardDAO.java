package com.intranet_escolar.dao;

import com.intranet_escolar.config.DatabaseConfig;
import com.intranet_escolar.model.DTO.ComunicadoDTO;
import com.intranet_escolar.model.DTO.HijoDTO;
import com.intranet_escolar.model.DTO.NotaDTO;

import java.sql.*;
import java.util.*;

public class DashboardDAO {

    private Connection conn;

    public DashboardDAO() throws SQLException {
        conn = DatabaseConfig.getConnection();
    }
    // -------- Métodos para Administrador --------
    public Map<String, Object> obtenerEstadisticas() {
        Map<String, Object> stats = new HashMap<>();
        String sql = "{CALL sp_dashboard_estadisticas()}";

        try (CallableStatement stmt = conn.prepareCall(sql);
             ResultSet rs = stmt.executeQuery()) {
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

        try (CallableStatement stmt = conn.prepareCall(sql);
             ResultSet rs = stmt.executeQuery()) {
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
    
    public Map<String, Integer> obtenerMatriculaPorGrado() {
        Map<String, Integer> datos = new LinkedHashMap<>(); 

        String sql = "{CALL sp_dashboard_matricula_por_grado()}";

        try (CallableStatement stmt = conn.prepareCall(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                String grado = rs.getString("grado");
                int total = rs.getInt("total");
                datos.put(grado, total);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return datos;
    }
    
    public Map<String, Integer> obtenerTendenciaMatricula() {
        Map<String, Integer> data = new LinkedHashMap<>();

        String sql = "{CALL sp_dashboard_tendencia_matricula()}";
        try (CallableStatement stmt = conn.prepareCall(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                String mes = rs.getString("mes");
                int total = rs.getInt("total");
                data.put(mes, total);
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

        try (CallableStatement stmt = conn.prepareCall(sql);
             ResultSet rs = stmt.executeQuery()) {
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
    
    // -------- Métodos para Apoderado --------
    public List<HijoDTO> listarHijos(int idApoderado) throws SQLException {
    List<HijoDTO> lista = new ArrayList<>();
    String sql = "{CALL sp_dashboard_listar_hijos_apoderado(?)}";

    try (CallableStatement stmt = conn.prepareCall(sql)) {
        stmt.setInt(1, idApoderado);
        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                HijoDTO hijo = new HijoDTO();
                hijo.setId(rs.getInt("id_hijo"));
                hijo.setNombres(rs.getString("nombres"));
                hijo.setApellidos(rs.getString("apellidos"));
                hijo.setCodigo(rs.getString("codigo"));
                hijo.setGrado(rs.getString("grado"));
                hijo.setSeccion(rs.getString("seccion"));
                hijo.setFoto(rs.getString("foto"));
                lista.add(hijo);
            }
        }
    }

    return lista;
}

    public HijoDTO obtenerResumenHijo(int idHijo) throws SQLException {
    String sql = "{CALL sp_dashboard_resumen_hijo(?)}";
    HijoDTO hijo = new HijoDTO();

    try (CallableStatement stmt = conn.prepareCall(sql)) {
        stmt.setInt(1, idHijo);
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                hijo.setPromedioGeneral(rs.getDouble("promedio_general"));
                hijo.setPorcentajeAsistencia(rs.getDouble("porcentaje_asistencia"));
                hijo.setPuntajeConducta(rs.getDouble("puntaje_conducta"));
                hijo.setPosicion(rs.getInt("posicion"));
            }
        }
    }

    return hijo;
}

    public double obtenerPromedioBimestre(int idHijo) throws SQLException {
    String sql = "{CALL sp_dashboard_promedio_bimestre(?)}";

    try (CallableStatement stmt = conn.prepareCall(sql)) {
        stmt.setInt(1, idHijo);
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble("promedio");
            }
        }
    }

    return 0;
}

    public List<NotaDTO> obtenerUltimasCalificaciones(int idHijo) throws SQLException {
    List<NotaDTO> lista = new ArrayList<>();
    String sql = "{CALL sp_dashboard_ultimas_calificaciones(?)}";

    try (CallableStatement stmt = conn.prepareCall(sql)) {
        stmt.setInt(1, idHijo);
        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                NotaDTO nota = new NotaDTO();
                nota.setCurso(rs.getString("curso"));
                nota.setTipoEvaluacion(rs.getString("tipo_evaluacion"));
                nota.setCalificacion(rs.getDouble("calificacion"));
                nota.setFecha(rs.getDate("fecha"));
                nota.setDocente(rs.getString("docente"));
                lista.add(nota);
            }
        }
    }

    return lista;
}

    public List<ComunicadoDTO> obtenerComunicadosParaApoderado() throws SQLException {
    List<ComunicadoDTO> lista = new ArrayList<>();
    String sql = "{CALL sp_dashboard_comunicados_apoderado()}";

    try (CallableStatement stmt = conn.prepareCall(sql);
         ResultSet rs = stmt.executeQuery()) {

        while (rs.next()) {
            ComunicadoDTO com = new ComunicadoDTO();
            com.setTitulo(rs.getString("titulo"));
            com.setContenido(rs.getString("contenido"));
            com.setFecha(rs.getDate("fecha"));
            com.setImportante(rs.getBoolean("importante"));
            lista.add(com);
        }
    }

    return lista;
}

    public List<String> obtenerPeriodos(int idHijo) throws SQLException {
        List<String> periodos = new ArrayList<>();
        String sql = "{CALL sp_dashboard_periodos(?)}";

        try (CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setInt(1, idHijo);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    periodos.add(rs.getString("bimestre"));
                }
            }
        }
        return periodos;
    }

    public List<Double> obtenerPromediosPorPeriodo(int idHijo) throws SQLException {
        List<Double> lista = new ArrayList<>();
        String sql = "{CALL sp_dashboard_promedios_por_periodo(?)}";

        try (CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setInt(1, idHijo);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    lista.add(rs.getDouble("promedio"));
                }
            }
        }
        return lista;
    }

    public List<String> obtenerNombresCursos(int idHijo) throws SQLException {
        List<String> cursos = new ArrayList<>();
        String sql = "{CALL sp_dashboard_cursos(?)}";

        try (CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setInt(1, idHijo);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    cursos.add(rs.getString("nombre"));
                }
            }
        }
        return cursos;
    }

    public List<Double> obtenerPromediosCursos(int idHijo) throws SQLException {
        List<Double> promedios = new ArrayList<>();
        String sql = "{CALL sp_dashboard_promedios_por_curso(?)}";

        try (CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setInt(1, idHijo);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    promedios.add(rs.getDouble("promedio"));
                }
            }
        }
        return promedios;
    }

    public int contarDiasAsistidos(int idHijo) throws SQLException {
        String sql = "{CALL sp_dashboard_asistencias(?)}";
        try (CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setInt(1, idHijo);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    public int contarTotalDias(int idHijo) throws SQLException {
        String sql = "{CALL sp_dashboard_asistencias_totales(?)}";
        try (CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setInt(1, idHijo);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    public int contarMeritosTotales(int idHijo) throws SQLException {
        String sql = "{CALL sp_dashboard_meritos_totales(?)}";
        try (CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setInt(1, idHijo);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    public int contarMeritosRecientes(int idHijo) throws SQLException {
        String sql = "{CALL sp_dashboard_meritos_recientes(?)}";
        try (CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setInt(1, idHijo);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    public int obtenerTotalEstudiantesEnSeccion(int idHijo) throws SQLException {
        String sql = "{CALL sp_dashboard_total_estudiantes_seccion(?)}";
        try (CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setInt(1, idHijo);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    public int obtenerPosicionActual(int idHijo) throws SQLException {
    String sql = "{CALL sp_dashboard_posicion_actual(?)}";
    try (CallableStatement stmt = conn.prepareCall(sql)) {
        stmt.setInt(1, idHijo);
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt("posicion");
        }
    }
    return 0;
}


}
