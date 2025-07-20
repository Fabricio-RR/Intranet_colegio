package com.intranet_escolar.controller;

import com.intranet_escolar.dao.*;
import com.intranet_escolar.model.entity.*;
import com.intranet_escolar.service.ReporteService;
import com.intranet_escolar.model.DTO.ReportePublicadoDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;


@WebServlet("/reportes/*")
public class ReporteServlet extends HttpServlet {

    private final AnioLectivoDAO anioDAO         = new AnioLectivoDAO();
    private final PeriodoDAO     periodoDAO      = new PeriodoDAO();
    private final AcademicoDAO   academicoDAO    = new AcademicoDAO();
    private final AlumnoDAO      alumnoDAO       = new AlumnoDAO();
    private final AperturaSeccionDAO aperturaDAO = new AperturaSeccionDAO();
    private final ReporteService reporteService = new ReporteService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null || path.equals("/") || path.isEmpty()) {
            mostrarVistaPrincipal(req, resp);
            return;
        }

        switch (path) {
            case "/asistencia":
                descargarAsistencia(req, resp);
                break;
            case "/rendimiento":
                descargarRendimiento(req, resp);
                break;
            case "/consolidado":
            case "/consolidado_mensual":
            case "/consolidado_bimestral":
                descargarConsolidado(req, resp);
                break;
            case "/libreta":
            case "/libreta_bimestral":
                descargarLibreta(req, resp);
                break;
            case "/progreso":
                descargarProgreso(req, resp);
                break;
            case "/bloque":
                descargarBloqueZip(req, resp);
                break;
            default:
                mostrarVistaPrincipal(req, resp);
        }
    }

    private void mostrarVistaPrincipal(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1. Años lectivos
        List<AnioLectivo> aniosLectivos = anioDAO.obtenerAniosDisponibles();

        // 2. Obtener filtros de request (sin mes)
        int anioSeleccionado    = getIntParam(req, "anio_lectivo");
        int periodoSeleccionado = getIntParam(req, "periodo");
        int nivelSeleccionado   = getIntParam(req, "nivel");
        int gradoSeleccionado   = getIntParam(req, "grado");
        int seccionSeleccionada = getIntParam(req, "seccion");
        int alumnoSeleccionado  = getIntParam(req, "alumno");

        // Default: primer año activo
        if (anioSeleccionado == 0 && !aniosLectivos.isEmpty()) {
            anioSeleccionado = aniosLectivos.get(0).getIdAnioLectivo();
        }

        // 3. Periodos filtrados por año
        List<Periodo> periodos = periodoDAO.listarPorAnioLectivo(anioSeleccionado);

        // 4. Niveles, grados, secciones filtrados
        List<Nivel> niveles = academicoDAO.listarNivelesPorAnio(anioSeleccionado);
        List<Grado> grados = (nivelSeleccionado > 0)
            ? academicoDAO.listarGradosPorNivelYAnio(nivelSeleccionado, anioSeleccionado)
            : academicoDAO.listarGradosPorAnio(anioSeleccionado);

        List<Seccion> secciones;
        if (gradoSeleccionado > 0) {
            secciones = aperturaDAO.listarSeccionesActivasPorGradoYAnio(gradoSeleccionado, anioSeleccionado);
        } else {
            secciones = aperturaDAO.listarSeccionesActivasPorAnio(anioSeleccionado);
        }

        // 5. Alumnos filtrados (si todo seleccionado)
        List<Alumno> alumnos = new ArrayList<>();
        if (anioSeleccionado > 0 && nivelSeleccionado > 0
         && gradoSeleccionado > 0 && seccionSeleccionada > 0) {
            alumnos = alumnoDAO.listarMatriculadosPorFiltros(
                anioSeleccionado, nivelSeleccionado, gradoSeleccionado, seccionSeleccionada
            );
        }

        // 6. Historial de reportes publicados
        List<ReportePublicadoDTO> reportesPublicados =
            reporteService.listarReportesPublicados(anioSeleccionado);

        // --- Set attributes ---
        req.setAttribute("aniosLectivos",      aniosLectivos);
        req.setAttribute("anioSeleccionado",   anioSeleccionado);
        req.setAttribute("periodos",           periodos);
        req.setAttribute("periodoSeleccionado",periodoSeleccionado);
        req.setAttribute("niveles",            niveles);
        req.setAttribute("nivelSeleccionado",  nivelSeleccionado);
        req.setAttribute("grados",             grados);
        req.setAttribute("gradoSeleccionado",  gradoSeleccionado);
        req.setAttribute("secciones",          secciones);
        req.setAttribute("seccionSeleccionada",seccionSeleccionada);
        req.setAttribute("alumnos",            alumnos);
        req.setAttribute("alumnoSeleccionado", alumnoSeleccionado);
        req.setAttribute("reportesPublicados", reportesPublicados);

        req.getRequestDispatcher("/views/reportes.jsp").forward(req, resp);
    }

    // ========== DESCARGA DE REPORTES ==========

    private void descargarAsistencia(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int idUsuario = getUsuarioIdSession(req);
        int anio      = getIntParam(req, "anio_lectivo");
        int periodo   = getIntParam(req, "periodo");
        int nivel     = getIntParam(req, "nivel");
        int grado     = getIntParam(req, "grado");
        int seccion   = getIntParam(req, "seccion");
        String alumno = getStrParam(req, "alumno");
        String formato= getStrParam(req, "formato");

        byte[] archivo = reporteService.generarAsistencia(
            idUsuario, anio, periodo, nivel, grado, seccion, alumno, formato
        );
        String filename = "asistencia_" + anio + "_P" + periodo + "." + getExt(formato);
        descargarArchivo(resp, archivo, filename, getMime(formato));
    }

    private void descargarRendimiento(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int idUsuario = getUsuarioIdSession(req);
        int anio      = getIntParam(req, "anio_lectivo");
        int periodo   = getIntParam(req, "periodo");
        int nivel     = getIntParam(req, "nivel");
        int grado     = getIntParam(req, "grado");
        int seccion   = getIntParam(req, "seccion");
        String alumno = getStrParam(req, "alumno");
        String formato= getStrParam(req, "formato");

        byte[] archivo = reporteService.generarRendimiento(
            idUsuario, anio, periodo, nivel, grado, seccion, alumno, formato
        );
        String filename = "rendimiento_" + anio + "_P" + periodo + "." + getExt(formato);
        descargarArchivo(resp, archivo, filename, getMime(formato));
    }

    private void descargarConsolidado(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int idUsuario = getUsuarioIdSession(req);
        int anio      = getIntParam(req, "anio_lectivo");
        int periodo   = getIntParam(req, "periodo");
        int nivel     = getIntParam(req, "nivel");
        int grado     = getIntParam(req, "grado");
        int seccion   = getIntParam(req, "seccion");
        String tipo   = getStrParam(req, "tipo");
        String alumno = getStrParam(req, "alumno");
        String formato= getStrParam(req, "formato");

        byte[] archivo = reporteService.generarConsolidado(
            idUsuario, anio, periodo, nivel, grado, seccion, tipo, alumno, formato
        );
        String filename = "consolidado_" + anio + "_P" + periodo + "." + getExt(formato);
        descargarArchivo(resp, archivo, filename, getMime(formato));
    }

    private void descargarLibreta(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int idUsuario = getUsuarioIdSession(req);
        int anio      = getIntParam(req, "anio_lectivo");
        int periodo   = getIntParam(req, "periodo");
        int nivel     = getIntParam(req, "nivel");
        int grado     = getIntParam(req, "grado");
        int seccion   = getIntParam(req, "seccion");
        String tipo   = getStrParam(req, "tipo");
        String alumno = getStrParam(req, "alumno");
        String formato= getStrParam(req, "formato");

        byte[] archivo;
        String filename;
        if (periodo > 0) {
            archivo = reporteService.generarLibretaBimestral(
                idUsuario, anio, periodo, nivel, grado, seccion, tipo, alumno, formato
            );
            filename = "libreta_bimestral_" + anio + "_P" + periodo + "." + getExt(formato);
        } else {
            archivo = reporteService.generarLibretaGeneral(
                idUsuario, anio, nivel, grado, seccion, tipo, alumno, formato
            );
            filename = "libreta_general_" + anio + "." + getExt(formato);
        }
        descargarArchivo(resp, archivo, filename, getMime(formato));
    }

    private void descargarProgreso(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int idUsuario = getUsuarioIdSession(req);
        int anio      = getIntParam(req, "anio_lectivo");
        int periodo   = getIntParam(req, "periodo");
        int nivel     = getIntParam(req, "nivel");
        int grado     = getIntParam(req, "grado");
        int seccion   = getIntParam(req, "seccion");
        String tipo   = getStrParam(req, "tipo");    // "letra" o "numerico"
        String alumno = getStrParam(req, "alumno");  // ID del alumno como String
        String formato= getStrParam(req, "formato"); // "pdf", "excel", "word"

        // Verificación rápida de parámetros en logs
        System.out.printf("DEBUG: anio=%d periodo=%d nivel=%d grado=%d seccion=%d alumno=%s tipo=%s%n",
            anio, periodo, nivel, grado, seccion, alumno, tipo);

        byte[] archivo = reporteService.generarProgreso(
            idUsuario, anio, periodo, nivel, grado, seccion,
            alumno, tipo, formato
        );
        String filename = "progreso_" + anio + "." + getExt(formato);
        descargarArchivo(resp, archivo, filename, getMime(formato));
    }

    private void descargarBloqueZip(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int idUsuario = getUsuarioIdSession(req);
        int anio      = getIntParam(req, "anio_lectivo");
        String periodo = getStrParam(req, "periodo");
        String nivel   = getStrParam(req, "nivel");
        String grado   = getStrParam(req, "grado");
        String seccion = getStrParam(req, "seccion");
        String tipo    = getStrParam(req, "tipo");
        String tipoNota= getStrParam(req, "tipoNota");
        String alumno  = getStrParam(req, "alumno");
        String formato = getStrParam(req, "formato");

        String nivelNombre   = getNombreNivel(nivel);
        String gradoNombre   = getNombreGrado(grado);
        String seccionNombre = getNombreSeccion(seccion);

        try {
            byte[] archivo = reporteService.generarBloqueZip(
                idUsuario, anio, periodo,
                nivelNombre, gradoNombre, seccionNombre,
                tipo, tipoNota, alumno, formato
            );
            String filename = tipo + "_bloque_" + anio + "_" + periodo + ".zip";
            descargarArchivo(resp, archivo, filename, "application/zip");
        } catch (Exception ex) {
            ex.printStackTrace();
            resp.sendError(500, "Error generando bloque ZIP");
        }
    }

    // ========== HELPERS ==========

    private int getIntParam(HttpServletRequest req, String param) {
        String val = req.getParameter(param);
        if (val == null || val.isEmpty()) return 0;
        try { return Integer.parseInt(val); } catch (Exception e) { return 0; }
    }

    private String getStrParam(HttpServletRequest req, String param) {
        String val = req.getParameter(param);
        return val == null ? "" : val.trim();
    }

    private int getUsuarioIdSession(HttpServletRequest req) {
        Object usuarioObj = req.getSession().getAttribute("usuario");
        if (usuarioObj instanceof Usuario) {
            return ((Usuario) usuarioObj).getIdUsuario();
        }
        return 1;
    }

    private void descargarArchivo(HttpServletResponse resp, byte[] archivo,
                                  String filename, String mime) throws IOException {
        resp.setContentType(mime);
        resp.setHeader("Content-Disposition",
            "attachment; filename=\"" +
            URLEncoder.encode(filename, StandardCharsets.UTF_8) + "\"");
        resp.setContentLength(archivo.length);
        try (OutputStream os = resp.getOutputStream()) {
            os.write(archivo);
        }
    }

    private String getExt(String formato) {
        if ("excel".equalsIgnoreCase(formato)) return "xlsx";
        if ("word".equalsIgnoreCase(formato))  return "docx";
        return "pdf";
    }

    private String getMime(String formato) {
        if ("excel".equalsIgnoreCase(formato))
            return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        if ("word".equalsIgnoreCase(formato))
            return "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
        return "application/pdf";
    }

    private String getNombreNivel(String idNivel) {
        return academicoDAO.listarNiveles().stream()
            .filter(n -> String.valueOf(n.getIdNivel()).equals(idNivel))
            .map(Nivel::getNombre)
            .findFirst().orElse("");
    }
    private String getNombreGrado(String idGrado) {
        return academicoDAO.listarGrados().stream()
            .filter(g -> String.valueOf(g.getIdGrado()).equals(idGrado))
            .map(Grado::getNombre)
            .findFirst().orElse("");
    }
    private String getNombreSeccion(String idSeccion) {
        return academicoDAO.listarSecciones().stream()
            .filter(s -> String.valueOf(s.getIdSeccion()).equals(idSeccion))
            .map(Seccion::getNombre)
            .findFirst().orElse("");
    }
}

