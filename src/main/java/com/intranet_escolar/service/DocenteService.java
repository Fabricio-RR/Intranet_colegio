package com.intranet_escolar.service;

import com.intranet_escolar.dao.DashboardDAO;
import com.intranet_escolar.model.DTO.ClaseDTO;
import com.intranet_escolar.model.DTO.ExamenDTO;
import com.intranet_escolar.model.DTO.CursoDTO;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DocenteService {

    private final DashboardDAO dao;

    public DocenteService() {
        try {
            this.dao = new DashboardDAO();
        } catch (SQLException e) {
            throw new RuntimeException("Error al inicializar DashboardDAO", e);
        }
    }

    public int obtenerTotalCursos(int idDocente) {
        try {
            return dao.contarCursosAsignadosDocente(idDocente);
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int obtenerTotalEstudiantes(int idDocente) {
        try {
            return dao.contarEstudiantesAsignadosDocente(idDocente);
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int obtenerEvaluacionesPendientes(int idDocente, int idAnioLectivo) {
        return dao.contarEvaluacionesPendientesDocente(idDocente, idAnioLectivo);
    }


    public int obtenerClasesHoy(int idDocente) {
        try {
            return dao.contarClasesHoyDocente(idDocente);
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public List<ClaseDTO> obtenerHorarioHoy(int idDocente) {
        try {
            return dao.obtenerHorarioHoyDocente(idDocente);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<ExamenDTO> obtenerProximosExamenes(int idDocente, int idAnioLectivo) {
        try {
            return dao.obtenerProximosExamenesDocente(idDocente, idAnioLectivo);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<CursoDTO> obtenerMisCursos(int idDocente, int idAnioLectivo) {
        try {
            return dao.obtenerMisCursosDocente(idDocente, idAnioLectivo);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

}
