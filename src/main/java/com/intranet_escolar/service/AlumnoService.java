/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.intranet_escolar.service;

import com.intranet_escolar.dao.DashboardDAO;
import com.intranet_escolar.model.DTO.AlumnoDTO;
import com.intranet_escolar.model.DTO.ClaseDTO;
import com.intranet_escolar.model.DTO.ExamenDTO;
import com.intranet_escolar.model.DTO.NotaDTO;
import java.sql.SQLException;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 *
 * @author Hp
 */
public class AlumnoService {
    private final DashboardDAO dao;

    public AlumnoService() throws SQLException {
        this.dao = new DashboardDAO();
    }

    // DTO para el resumen académico
    public AlumnoDTO obtenerResumenAcademico(int idAlumno) throws SQLException {
        AlumnoDTO dto = new AlumnoDTO();
        // SP trae todos los campos base (menos cambioPromedio)
        Map<String, Object> resumen = dao.obtenerResumenAcademico(idAlumno);
        dto.setPromedioGeneral((Double) resumen.getOrDefault("promedio_general", 0.0));
        dto.setPorcentajeAsistencia((Double) resumen.getOrDefault("porcentaje_asistencia", 0.0));
        dto.setDiasAsistidos(((Number) resumen.getOrDefault("dias_asistidos", 0)).intValue());
        dto.setPuntajeConducta(((Number) resumen.getOrDefault("puntaje_conducta", 0)).intValue());
        dto.setMeritos(((Number) resumen.getOrDefault("meritos", 0)).intValue());
        dto.setTotalCursos(((Number) resumen.getOrDefault("total_cursos", 0)).intValue());
        dto.setCursosAprobados(((Number) resumen.getOrDefault("cursos_aprobados", 0)).intValue());
        // Lógica adicional: calcular cambio de promedio
        List<Double> promedios = dao.obtenerPromediosPorPeriodo(idAlumno);
        if (promedios.size() >= 2) {
            double actual = promedios.get(promedios.size() - 1);
            double anterior = promedios.get(promedios.size() - 2);
            dto.setCambioPromedio(actual - anterior);
        } else {
            dto.setCambioPromedio(0);
        }
        return dto;
    }

    public String obtenerNombresCursos(int idAlumno) throws SQLException {
        List<String> lista = dao.obtenerNombresCursosAlumno(idAlumno);
        return String.join(",", lista);
    }
    
    public String obtenerNotasPorCurso(int idAlumno) throws SQLException {
        List<Double> lista = dao.obtenerNotasCursosAlumno(idAlumno);
        return lista.stream()
                .map(String::valueOf)
                .collect(Collectors.joining(","));
    }

    public List<ClaseDTO> obtenerHorarioHoy(int idAlumno) throws SQLException {
        return dao.obtenerHorarioHoyAlumno(idAlumno);
    }

    public List<NotaDTO> obtenerUltimasCalificaciones(int idAlumno) throws SQLException {
        return dao.obtenerUltimasCalificacionesAlumno(idAlumno);
    }

    public List<ExamenDTO> obtenerProximosExamenes(int idAlumno) throws SQLException {
        List<ExamenDTO> lista = dao.obtenerProximosExamenesAlumno(idAlumno);
        // Calcular días restantes en Java (si lo quieres en DTO)
        Date hoy = new Date();
        for (ExamenDTO examen : lista) {
            if (examen.getFecha() != null) {
                long diff = examen.getFecha().getTime() - hoy.getTime();
                int dias = (int) Math.ceil(diff / (1000 * 60 * 60 * 24.0));
                examen.setDiasRestantes(dias);
            }
        }
        return lista;
    }
}
