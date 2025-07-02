package com.intranet_escolar.dao;

import com.intranet_escolar.config.DatabaseConfig;
import com.intranet_escolar.model.DTO.AlumnoDTO;
import com.intranet_escolar.model.DTO.ClaseDTO;
import com.intranet_escolar.model.DTO.ComunicadoDTO;
import com.intranet_escolar.model.DTO.CursoDTO;
import com.intranet_escolar.model.DTO.ExamenDTO;
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

    public double obtenerPromedioBimestreApoderado(int idHijo) throws SQLException {
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

    public List<NotaDTO> obtenerUltimasCalificacionesApoderado(int idHijo) throws SQLException {
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

    public List<ComunicadoDTO> obtenerComunicadosApoderado() throws SQLException {
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

    public List<String> obtenerPeriodosApoderado(int idHijo) throws SQLException {
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

    public List<String> obtenerNombresCursosApoderado(int idHijo) throws SQLException {
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

    public List<Double> obtenerPromediosCursosApoderado(int idHijo) throws SQLException {
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

    public int contarDiasAsistidosApoderado(int idHijo) throws SQLException {
        String sql = "{CALL sp_dashboard_asistencias(?)}";
        try (CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setInt(1, idHijo);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    public int contarTotalDiasApoderado(int idHijo) throws SQLException {
        String sql = "{CALL sp_dashboard_asistencias_totales(?)}";
        try (CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setInt(1, idHijo);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    public int contarMeritosTotalesApoderado(int idHijo) throws SQLException {
        String sql = "{CALL sp_dashboard_meritos_totales(?)}";
        try (CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setInt(1, idHijo);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    public int contarMeritosRecientesApoderado(int idHijo) throws SQLException {
        String sql = "{CALL sp_dashboard_meritos_recientes(?)}";
        try (CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setInt(1, idHijo);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    public int obtenerTotalEstudiantesEnSeccionApoderado(int idHijo) throws SQLException {
        String sql = "{CALL sp_dashboard_total_estudiantes_seccion(?)}";
        try (CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setInt(1, idHijo);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    public int obtenerPosicionActualApoderado(int idHijo) throws SQLException {
    String sql = "{CALL sp_dashboard_posicion_actual(?)}";
    try (CallableStatement stmt = conn.prepareCall(sql)) {
        stmt.setInt(1, idHijo);
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt("posicion");
        }
    }
    return 0;
}

 // -------- Métodos para Docente --------
    // 1. Total de cursos asignados al docente
    public int contarCursosAsignadosDocente(int idDocente) throws SQLException {
        String sql = "{CALL sp_dashboard_docente_total_cursos(?)}";
        try (CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setInt(1, idDocente);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    // 2. Total de estudiantes de todos sus cursos
    public int contarEstudiantesAsignadosDocente(int idDocente) throws SQLException {
        String sql = "{CALL sp_dashboard_docente_total_estudiantes(?)}";
        try (CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setInt(1, idDocente);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    // 3. Total de evaluaciones pendientes (por corregir/calificar)
    /*
    public int contarEvaluacionesPendientesDocente(int idDocente) throws SQLException {
        String sql = "{CALL sp_dashboard_docente_evaluaciones_pendientes(?)}";
        try (CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setInt(1, idDocente);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    obtenerEvaluacionesPendientesDocente
    }*/
    public int contarEvaluacionesPendientesDocente(int idDocente, int idAnioLectivo) {
    String sql = "{CALL sp_dashboard_docente_evaluaciones_pendientes(?, ?)}";
    try (Connection con = DatabaseConfig.getConnection();
         CallableStatement cs = con.prepareCall(sql)) {
        cs.setInt(1, idDocente);
        cs.setInt(2, idAnioLectivo);
        try (ResultSet rs = cs.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("evaluaciones_pendientes");
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return 0;
}


    // 4. Total de clases programadas para hoy
    public int contarClasesHoyDocente(int idDocente) throws SQLException {
        String sql = "{CALL sp_dashboard_docente_clases_hoy(?)}";
        try (CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setInt(1, idDocente);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    // 5. Lista de clases programadas para hoy (detalle)
    public List<ClaseDTO> obtenerHorarioHoyDocente(int idDocente) throws SQLException {
        List<ClaseDTO> lista = new ArrayList<>();
        String sql = "{CALL sp_dashboard_docente_horario_hoy(?)}";
        try (CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setInt(1, idDocente);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ClaseDTO clase = new ClaseDTO();
                    clase.setHoraInicio(rs.getString("hora_inicio"));
                    clase.setHoraFin(rs.getString("hora_fin"));
                    clase.setNombreCurso(rs.getString("nombre_curso"));
                    clase.setNivel(rs.getString("nivel"));     
                    clase.setGrado(rs.getString("grado"));
                    clase.setSeccion(rs.getString("seccion"));
                    clase.setEstado(rs.getString("estado"));
                    lista.add(clase);
                }
            }
        }
        return lista;
    }

    // 6. Próximos exámenes programados por el docente
    public List<ExamenDTO> obtenerProximosExamenesDocente(int idDocente, int idAnioLectivo) throws SQLException {
        List<ExamenDTO> lista = new ArrayList<>();
        String sql = "{CALL sp_dashboard_docente_proximos_examenes(?, ?)}";
        try (CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setInt(1, idDocente);
            stmt.setInt(2, idAnioLectivo);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ExamenDTO ex = new ExamenDTO();
                    ex.setCurso(rs.getString("nombre_curso"));
                    ex.setSeccion(rs.getString("seccion"));
                    ex.setFecha(rs.getDate("fecha"));
                    ex.setTipo(rs.getString("tipo"));
                    lista.add(ex);
                }
            }
        }
        return lista;
    }

    // 7. Cursos asignados al docente con detalle (para la tabla “Mis Cursos”)
    public List<CursoDTO> obtenerMisCursosDocente(int idDocente, int idAnioLectivo) throws SQLException {
        List<CursoDTO> lista = new ArrayList<>();
        String sql = "{CALL sp_dashboard_docente_mis_cursos(?, ?)}";
        try (CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setInt(1, idDocente);
            stmt.setInt(2, idAnioLectivo);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    CursoDTO curso = new CursoDTO();
                    curso.setId(rs.getInt("id_curso"));
                    curso.setNombre(rs.getString("nombre_curso"));
                    curso.setNivel(rs.getString("nivel"));
                    curso.setGrado(rs.getString("grado"));
                    curso.setSeccion(rs.getString("seccion"));
                    curso.setTotalEstudiantes(rs.getInt("total_estudiantes"));
                    curso.setPromedio(rs.getDouble("promedio"));
                    curso.setUltimaEvaluacion(rs.getDate("ultima_evaluacion"));
                    lista.add(curso);
                }
            }
        }
        return lista;
    }
    
    // -------- Métodos para Alummno --------
    // 1. Resumen académico
    public AlumnoDTO obtenerResumenAlumno(int idAlumno) throws SQLException {
        String sql = "{CALL sp_dashboard_resumen_alumno(?)}";
        AlumnoDTO resumen = new AlumnoDTO();

        try (CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setInt(1, idAlumno);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    resumen.setPromedioGeneral(rs.getDouble("promedio_general"));
                    resumen.setCambioPromedio(rs.getDouble("cambio_promedio"));
                    resumen.setPorcentajeAsistencia(rs.getDouble("porcentaje_asistencia"));
                    resumen.setDiasAsistidos(rs.getInt("dias_asistidos"));
                    resumen.setPuntajeConducta(rs.getDouble("puntaje_conducta"));
                    resumen.setMeritos(rs.getInt("meritos"));
                    resumen.setTotalCursos(rs.getInt("total_cursos"));
                    resumen.setCursosAprobados(rs.getInt("cursos_aprobados"));
                }
            }
        }
        return resumen;
    }

    // 2. Notas por curso para gráfico
    public List<String> obtenerNombresCursosAlumno(int idAlumno) throws SQLException {
        List<String> cursos = new ArrayList<>();
        String sql = "{CALL sp_dashboard_cursos_alumno(?)}";
        try (CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setInt(1, idAlumno);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    cursos.add(rs.getString("nombre"));
                }
            }
        }
        return cursos;
    }

    public List<Double> obtenerNotasCursosAlumno(int idAlumno) throws SQLException {
        List<Double> notas = new ArrayList<>();
        String sql = "{CALL sp_dashboard_notas_cursos_alumno(?)}";
        try (CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setInt(1, idAlumno);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    notas.add(rs.getDouble("nota"));
                }
            }
        }
        return notas;
    }

    // 3. Horario de hoy
    public List<ClaseDTO> obtenerHorarioHoyAlumno(int idAlumno) throws SQLException {
        List<ClaseDTO> lista = new ArrayList<>();
        String sql = "{CALL sp_dashboard_horario_hoy_alumno(?)}";
        try (CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setInt(1, idAlumno);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ClaseDTO clase = new ClaseDTO();
                    clase.setHoraInicio(rs.getString("hora_inicio"));
                    clase.setHoraFin(rs.getString("hora_fin"));
                    clase.setNombreCurso(rs.getString("nombre_curso"));
                    clase.setSeccion(rs.getString("seccion"));
                    clase.setNivel(rs.getString("nivel"));
                    clase.setGrado(rs.getString("grado"));
                    clase.setEstado(rs.getString("estado"));
                    lista.add(clase);
                }
            }
        }
        return lista;
    }

    // 4. Últimas calificaciones
    public List<NotaDTO> obtenerUltimasCalificacionesAlumno(int idAlumno) throws SQLException {
        List<NotaDTO> lista = new ArrayList<>();
        String sql = "{CALL sp_dashboard_ultimas_calificaciones_alumno(?)}";
        try (CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setInt(1, idAlumno);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    NotaDTO nota = new NotaDTO();
                    nota.setCurso(rs.getString("curso"));
                    nota.setTipoEvaluacion(rs.getString("tipo_evaluacion"));
                    nota.setCalificacion(rs.getDouble("calificacion"));
                    nota.setFecha(rs.getDate("fecha"));
                    nota.setDocente(rs.getString("docente"));
                    nota.setObservaciones(rs.getString("observaciones"));
                    lista.add(nota);
                }
            }
        }
        return lista;
    }

    // 5. Próximos exámenes
    public List<ExamenDTO> obtenerProximosExamenesAlumno(int idAlumno) throws SQLException {
        List<ExamenDTO> lista = new ArrayList<>();
        String sql = "{CALL sp_dashboard_proximos_examenes_alumno(?)}";
        try (CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setInt(1, idAlumno);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ExamenDTO examen = new ExamenDTO();
                    examen.setCurso(rs.getString("curso"));
                    examen.setSeccion(rs.getString("seccion"));
                    examen.setFecha(rs.getDate("fecha"));
                    examen.setTipo(rs.getString("tipo"));
                    lista.add(examen);
                }
            }
        }
        return lista;
    }
    public Map<String, Object> obtenerResumenAcademico(int idAlumno) throws SQLException {
    Map<String, Object> resumen = new HashMap<>();
    String sql = "{CALL sp_dashboard_resumen_academico(?)}";
    try (CallableStatement stmt = conn.prepareCall(sql)) {
        stmt.setInt(1, idAlumno);
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                resumen.put("promedio_general", rs.getDouble("promedio_general"));
                resumen.put("porcentaje_asistencia", rs.getDouble("porcentaje_asistencia"));
                resumen.put("dias_asistidos", rs.getInt("dias_asistidos"));
                resumen.put("puntaje_conducta", rs.getInt("puntaje_conducta"));
                resumen.put("meritos", rs.getInt("meritos"));
                resumen.put("total_cursos", rs.getInt("total_cursos"));
                resumen.put("cursos_aprobados", rs.getInt("cursos_aprobados"));
            }
        }
    }
    return resumen;
}

}
