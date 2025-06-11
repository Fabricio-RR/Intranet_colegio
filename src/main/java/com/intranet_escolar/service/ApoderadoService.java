
package com.intranet_escolar.service;

import com.intranet_escolar.dao.DashboardDAO;
import com.intranet_escolar.model.DTO.ComunicadoDTO;
import com.intranet_escolar.model.DTO.HijoDTO;
import com.intranet_escolar.model.DTO.NotaDTO;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ApoderadoService {

    private final DashboardDAO dao;

    public ApoderadoService() {
        try {
            this.dao = new DashboardDAO();
        } catch (SQLException e) {
            throw new RuntimeException("Error al inicializar DashboardDAO", e);
        }
    }

    public List<HijoDTO> obtenerHijos(int idApoderado) {
        try {
            return dao.listarHijos(idApoderado);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public HijoDTO obtenerResumenHijo(int idHijo) {
        try {
            return dao.obtenerResumenHijo(idHijo);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public double obtenerPromedioBimestre(int idHijo) {
        try {
            return dao.obtenerPromedioBimestre(idHijo);
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public double obtenerCambioPromedio(int idHijo) {
        try {
            List<Double> promedios = dao.obtenerPromediosPorPeriodo(idHijo);
            if (promedios.size() >= 2) {
                double actual = promedios.get(promedios.size() - 1);
                double anterior = promedios.get(promedios.size() - 2);
                return actual - anterior;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int obtenerAsistencias(int idHijo) {
        try {
            return dao.contarDiasAsistidos(idHijo);
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int obtenerTotalDias(int idHijo) {
        try {
            return dao.contarTotalDias(idHijo);
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int obtenerMeritos(int idHijo) {
        try {
            return dao.contarMeritosTotales(idHijo);
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int obtenerMeritosRecientes(int idHijo) {
        try {
            return dao.contarMeritosRecientes(idHijo);
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int obtenerPosicion(int idHijo) {
        try {
            return dao.obtenerPosicionActual(idHijo);
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int obtenerTotalEstudiantesSeccion(int idHijo) {
        try {
            return dao.obtenerTotalEstudiantesEnSeccion(idHijo);
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public List<String> obtenerCursos(int idHijo) {
        try {
            return dao.obtenerNombresCursos(idHijo);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<Double> obtenerNotasPorCurso(int idHijo) {
        try {
            return dao.obtenerPromediosCursos(idHijo);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<String> obtenerPeriodos(int idHijo) {
        try {
            return dao.obtenerPeriodos(idHijo);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<Double> obtenerPromediosPorPeriodo(int idHijo) {
        try {
            return dao.obtenerPromediosPorPeriodo(idHijo);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<NotaDTO> obtenerUltimasCalificaciones(int idHijo) {
        try {
            return dao.obtenerUltimasCalificaciones(idHijo);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<ComunicadoDTO> obtenerComunicadosRecientes(int idApoderado) {
        try {
            return dao.obtenerComunicadosParaApoderado();
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
}

