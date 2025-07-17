package com.intranet_escolar.service;

import com.intranet_escolar.dao.ReporteDAO;
import com.intranet_escolar.dao.BitacoraDAO;
import com.intranet_escolar.model.DTO.ReportePublicadoDTO;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class ReporteService {
    private final ReporteDAO reporteDAO;
    private final BitacoraDAO bitacoraDAO;

    public ReporteService() {
        this.reporteDAO = new ReporteDAO();
        this.bitacoraDAO = new BitacoraDAO();
    }

    // 1. Asistencia (mensual)
    public byte[] generarAsistencia(int idUsuario, int anio, int periodo, String mes,
                                    int nivel, int grado, int seccion,
                                    String alumnoFiltro, String formato) throws IOException {
        try {
            byte[] archivo = reporteDAO.generarAsistencia(anio, periodo, mes, nivel, grado, seccion, alumnoFiltro, formato);
            bitacoraDAO.registrarBitacora(idUsuario, "reporte", "descargar_asistencia");
            return archivo;
        } catch (Exception e) {
            bitacoraDAO.registrarBitacora(idUsuario, "reporte", "error_asistencia");
            throw new RuntimeException("Error generando reporte de asistencia", e);
        }
    }

    // 2. Rendimiento Académico (mensual)
    public byte[] generarRendimiento(int idUsuario, int anio, int periodo, String mes,
                                     int nivel, int grado, int seccion,
                                     String alumnoFiltro, String formato) {
        try {
            byte[] archivo = reporteDAO.generarRendimiento(anio, periodo, mes, nivel, grado, seccion, alumnoFiltro, formato);
            bitacoraDAO.registrarBitacora(idUsuario, "reporte", "descargar_rendimiento");
            return archivo;
        } catch (Exception e) {
            bitacoraDAO.registrarBitacora(idUsuario, "reporte", "error_rendimiento");
            throw new RuntimeException("Error generando reporte de rendimiento", e);
        }
    }

    // 3. Consolidado de Notas
    public byte[] generarConsolidado(int idUsuario, int anio, int periodo, String mes,
                                     int nivel, int grado, int seccion,
                                     String tipoNota, String alumnoFiltro, String formato) {
        try {
            byte[] archivo = reporteDAO.generarConsolidado(anio, periodo, mes, nivel, grado, seccion, tipoNota, alumnoFiltro, formato);
            bitacoraDAO.registrarBitacora(idUsuario, "reporte", "descargar_consolidado");
            return archivo;
        } catch (Exception e) {
            bitacoraDAO.registrarBitacora(idUsuario, "reporte", "error_consolidado");
            throw new RuntimeException("Error generando consolidado", e);
        }
    }

    // 4. Libreta de Notas bimestral
    public byte[] generarLibretaBimestral(int idUsuario, int anio, int bimestre,
                                          int nivel, int grado, int seccion,
                                          String tipoNota, String alumnoFiltro, String formato) {
        try {
            byte[] archivo = reporteDAO.generarLibretaBimestral(anio, bimestre, nivel, grado, seccion, tipoNota, alumnoFiltro, formato);
            bitacoraDAO.registrarBitacora(idUsuario, "reporte", "descargar_libreta_bimestral");
            return archivo;
        } catch (Exception e) {
            bitacoraDAO.registrarBitacora(idUsuario, "reporte", "error_libreta_bimestral");
            throw new RuntimeException("Error generando libreta bimestral", e);
        }
    }

    // 5. Libreta de Notas General (I–IV + Anual)
    public byte[] generarLibretaGeneral(int idUsuario, int anio,
                                        int nivel, int grado, int seccion,
                                        String tipoNota, String alumnoFiltro, String formato) {
        try {
            byte[] archivo = reporteDAO.generarLibretaGeneral(anio, nivel, grado, seccion, tipoNota, alumnoFiltro, formato);
            bitacoraDAO.registrarBitacora(idUsuario, "reporte", "descargar_libreta_general");
            return archivo;
        } catch (Exception e) {
            bitacoraDAO.registrarBitacora(idUsuario, "reporte", "error_libreta_general");
            throw new RuntimeException("Error generando libreta general", e);
        }
    }

    // 6. Progreso del Alumno (mensual)
    public byte[] generarProgreso(int idUsuario, int anio, int nivel, int grado, int seccion,
                                  String alumnoFiltro, String formato) {
        try {
            byte[] archivo = reporteDAO.generarProgreso(anio, nivel, grado, seccion, alumnoFiltro, formato);
            bitacoraDAO.registrarBitacora(idUsuario, "reporte", "descargar_progreso");
            return archivo;
        } catch (Exception e) {
            bitacoraDAO.registrarBitacora(idUsuario, "reporte", "error_progreso");
            throw new RuntimeException("Error generando reporte de progreso", e);
        }
    }

    // 7. Certificado de Desempeño (anual)
    public byte[] generarCertificadoAnual(int idUsuario, int anio, int nivel, int grado, int seccion,
                                          String alumnoFiltro, String formato) {
        try {
            byte[] archivo = reporteDAO.generarCertificadoAnual(anio, nivel, grado, seccion, alumnoFiltro, formato);
            bitacoraDAO.registrarBitacora(idUsuario, "reporte", "descargar_certificado");
            return archivo;
        } catch (Exception e) {
            bitacoraDAO.registrarBitacora(idUsuario, "reporte", "error_certificado");
            throw new RuntimeException("Error generando certificado anual", e);
        }
    }

    // 8. Empaquetar varios informes en ZIP
    public byte[] generarBloqueZip(int idUsuario, int anio, String periodo,
                                   String nivelName, String gradoName, String seccionName,
                                   String tipoReporte, String tipoNota,
                                   String alumnoFiltro, String formato)
            throws IOException, SQLException {
        try {
            byte[] zip = reporteDAO.generarBloqueZip(anio, periodo, nivelName, gradoName, seccionName,
                                                     tipoReporte, tipoNota, alumnoFiltro, formato);
            bitacoraDAO.registrarBitacora(idUsuario, "reporte", "descargar_bloque_zip");
            return zip;
        } catch (Exception e) {
            bitacoraDAO.registrarBitacora(idUsuario, "reporte", "error_bloque_zip");
            throw new RuntimeException("Error generando bloque ZIP de reportes", e);
        }
    }

    // 9. Listar historial de reportes publicados
    public List<ReportePublicadoDTO> listarReportesPublicados(Integer anio) {
        return reporteDAO.listarReportesPublicados(anio);
    }
}
