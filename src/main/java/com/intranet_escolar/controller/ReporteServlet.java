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
import java.util.stream.Collectors;

@WebServlet("/reportes/*")
public class ReporteServlet extends HttpServlet {

    private final AnioLectivoDAO anioDAO = new AnioLectivoDAO();
    private final PeriodoDAO periodoDAO = new PeriodoDAO();
    private final AcademicoDAO academicoDAO = new AcademicoDAO();
    private final AlumnoDAO alumnoDAO = new AlumnoDAO();
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
                descargarAsistencia(req, resp);     break;
            case "/rendimiento":
                descargarRendimiento(req, resp);    break;
            case "/consolidado":
            case "/consolidado_mensual":           
            case "/consolidado_bimestral":         
                descargarConsolidado(req, resp);    break;
            case "/libreta":
            case "/libreta_bimestral":             
                descargarLibreta(req, resp);        break;
            case "/progreso":
                descargarProgreso(req, resp);       break;
            case "/bloque":
                descargarBloqueZip(req, resp);      break;
            default:
                mostrarVistaPrincipal(req, resp);
        }
    }

    private void mostrarVistaPrincipal(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // DAOs
        AperturaSeccionDAO aperturaSeccionDAO = new AperturaSeccionDAO();

        // 1. Años lectivos
        List<AnioLectivo> aniosLectivos = anioDAO.obtenerAniosDisponibles();

        // 2. Obtener filtros de request
        int anioSeleccionado      = getIntParam(req, "anio_lectivo");
        int periodoSeleccionado   = getIntParam(req, "periodo");
        String mesSeleccionado    = getStrParam(req, "mes");
        int nivelSeleccionado     = getIntParam(req, "nivel");
        int gradoSeleccionado     = getIntParam(req, "grado");
        int seccionSeleccionada   = getIntParam(req, "seccion");
        int alumnoSeleccionado    = getIntParam(req, "alumno");

        // Defaults: primer año activo
        if (anioSeleccionado == 0 && !aniosLectivos.isEmpty())
            anioSeleccionado = aniosLectivos.get(0).getIdAnioLectivo();

        // 3. Periodos filtrados por año
        List<Periodo> periodos = periodoDAO.listarPorAnioLectivo(anioSeleccionado);

        // 4. Meses filtrados por periodo y año
        List<Map<String, Object>> meses = new ArrayList<>();
        if (periodoSeleccionado > 0)
            meses = periodoDAO.listarMesesPorPeriodo(anioSeleccionado, periodoSeleccionado);

        // 5. Niveles, grados, secciones filtrados por año (y nivel si corresponde)
        List<Nivel> niveles = academicoDAO.listarNivelesPorAnio(anioSeleccionado);
        List<Grado> grados = (nivelSeleccionado > 0)
                ? academicoDAO.listarGradosPorNivelYAnio(nivelSeleccionado, anioSeleccionado)
                : academicoDAO.listarGradosPorAnio(anioSeleccionado);
        /*
        List<Seccion> secciones = (gradoSeleccionado > 0)
                ? academicoDAO.listarSeccionesPorGradoYAnio(gradoSeleccionado, anioSeleccionado)
                : academicoDAO.listarSeccionesPorAnio(anioSeleccionado);
        */
        List<Seccion> secciones = new ArrayList<>();
            if (gradoSeleccionado > 0) {
                secciones = aperturaSeccionDAO.listarSeccionesActivasPorGradoYAnio(gradoSeleccionado, anioSeleccionado);
            } else {
                secciones = aperturaSeccionDAO.listarSeccionesActivasPorAnio(anioSeleccionado);
            }

        /* 6. Alumnos matriculados EN ESA SECCIÓN Y AÑO (solo si todo está filtrado)
        List<Alumno> alumnos = new ArrayList<>();
        if (anioSeleccionado > 0 && nivelSeleccionado > 0 && gradoSeleccionado > 0 && seccionSeleccionada > 0) {
            // 1. Buscar la apertura_seccion (es el modelo real de tu matrícula)
            int idAperturaSeccion = aperturaSeccionDAO.getIdAperturaSeccion(anioSeleccionado, gradoSeleccionado, seccionSeleccionada);
            // 2. Si existe, filtra solo los matriculados en esa apertura_seccion
            if (idAperturaSeccion > 0)
                alumnos = alumnoDAO.obtenerMatriculadosPorAperturaSeccion(idAperturaSeccion);
        }*/
        
        /* 6. Alumnos matriculados EN ESA SECCIÓN Y AÑO (solo si todo está filtrado)
        List<Alumno> alumnos = new ArrayList<>();
        if (anioSeleccionado > 0 && nivelSeleccionado > 0 && gradoSeleccionado > 0 && seccionSeleccionada > 0) {
            int idAperturaSeccion = aperturaSeccionDAO.getIdAperturaSeccion(anioSeleccionado, gradoSeleccionado, seccionSeleccionada);
            if (idAperturaSeccion > 0)
                alumnos = alumnoDAO.obtenerMatriculadosPorAperturaSeccion(idAperturaSeccion);
        }*/
        // 6. Alumnos matriculados EN ESA SECCIÓN Y AÑO
        List<Alumno> alumnos = new ArrayList<>();
        if (anioSeleccionado > 0 && nivelSeleccionado > 0 
            && gradoSeleccionado > 0 && seccionSeleccionada > 0) {
            alumnos = alumnoDAO.listarMatriculadosPorFiltros(
                anioSeleccionado,
                nivelSeleccionado,
                gradoSeleccionado,
                seccionSeleccionada
            );
        }




        // 7. Historial de reportes publicados (tab)
        List<ReportePublicadoDTO> reportesPublicados = reporteService.listarReportesPublicados(anioSeleccionado);

        // --- Set attributes ---
        req.setAttribute("aniosLectivos", aniosLectivos);
        req.setAttribute("anioSeleccionado", anioSeleccionado);
        req.setAttribute("periodos", periodos);
        req.setAttribute("periodoSeleccionado", periodoSeleccionado);
        req.setAttribute("meses", meses);
        req.setAttribute("mesSeleccionado", mesSeleccionado);
        req.setAttribute("niveles", niveles);
        req.setAttribute("nivelSeleccionado", nivelSeleccionado);
        req.setAttribute("grados", grados);
        req.setAttribute("gradoSeleccionado", gradoSeleccionado);
        req.setAttribute("secciones", secciones);
        req.setAttribute("seccionSeleccionada", seccionSeleccionada);
        req.setAttribute("alumnos", alumnos);
        req.setAttribute("alumnoSeleccionado", alumnoSeleccionado);
        req.setAttribute("reportesPublicados", reportesPublicados);

        req.getRequestDispatcher("/views/reportes.jsp").forward(req, resp);
    }

    // ========== DESCARGA DE REPORTES ==========

    private void descargarAsistencia(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int idUsuario = getUsuarioIdSession(req);
        int anio      = getIntParam(req, "anio_lectivo");
        int periodo   = getIntParam(req, "periodo");
        String mes    = getStrParam(req, "mes");
        int nivel     = getIntParam(req, "nivel");
        int grado     = getIntParam(req, "grado");
        int seccion   = getIntParam(req, "seccion");
        String alumno = getStrParam(req, "alumno");
        String formato = getStrParam(req, "formato");

        byte[] archivo = reporteService.generarAsistencia(idUsuario, anio, periodo, mes, nivel, grado, seccion, alumno, formato);
        String filename = "asistencia_" + anio + "_" + mes + "." + getExt(formato);
        descargarArchivo(resp, archivo, filename, getMime(formato));
    }

    private void descargarRendimiento(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int idUsuario = getUsuarioIdSession(req);
        int anio      = getIntParam(req, "anio_lectivo");
        int periodo   = getIntParam(req, "periodo");
        String mes    = getStrParam(req, "mes");
        int nivel     = getIntParam(req, "nivel");
        int grado     = getIntParam(req, "grado");
        int seccion   = getIntParam(req, "seccion");
        String alumno = getStrParam(req, "alumno");
        String formato = getStrParam(req, "formato");
        String tipo    = getStrParam(req, "tipo"); // "letra"/"numerico" (si se aplica)

        byte[] archivo = reporteService.generarRendimiento(idUsuario, anio, periodo, mes, nivel, grado, seccion, alumno, formato);
        String filename = "rendimiento_" + anio + "_" + mes + "." + getExt(formato);
        descargarArchivo(resp, archivo, filename, getMime(formato));
    }

    private void descargarConsolidado(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int idUsuario = getUsuarioIdSession(req);
        int anio      = getIntParam(req, "anio_lectivo");
        int periodo   = getIntParam(req, "periodo");
        String mes    = getStrParam(req, "mes");
        int nivel     = getIntParam(req, "nivel");
        int grado     = getIntParam(req, "grado");
        int seccion   = getIntParam(req, "seccion");
        String tipo   = getStrParam(req, "tipo"); // letra/numerico
        String alumno = getStrParam(req, "alumno");
        String formato = getStrParam(req, "formato");

        byte[] archivo = reporteService.generarConsolidado(idUsuario, anio, periodo, mes, nivel, grado, seccion, tipo, alumno, formato);
        String filename = "consolidado_" + anio + "_" + (mes != null ? mes : periodo) + "." + getExt(formato);
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
        String formato = getStrParam(req, "formato");

        // Si hay periodo = bimestral → Libreta bimestral, si no, general
        byte[] archivo;
        String filename;
        if (periodo > 0) {
            archivo = reporteService.generarLibretaBimestral(idUsuario, anio, periodo, nivel, grado, seccion, tipo, alumno, formato);
            filename = "libreta_bimestral_" + anio + "_P" + periodo + "." + getExt(formato);
        } else {
            archivo = reporteService.generarLibretaGeneral(idUsuario, anio, nivel, grado, seccion, tipo, alumno, formato);
            filename = "libreta_general_" + anio + "." + getExt(formato);
        }
        descargarArchivo(resp, archivo, filename, getMime(formato));
    }

    private void descargarProgreso(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int idUsuario = getUsuarioIdSession(req);
        int anio      = getIntParam(req, "anio_lectivo");
        int nivel     = getIntParam(req, "nivel");
        int grado     = getIntParam(req, "grado");
        int seccion   = getIntParam(req, "seccion");
        String alumno = getStrParam(req, "alumno");
        String formato = getStrParam(req, "formato");

        byte[] archivo = reporteService.generarProgreso(idUsuario, anio, nivel, grado, seccion, alumno, formato);
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
        String tipo    = getStrParam(req, "tipo");      // tipoReporte
        String tipoNota= getStrParam(req, "tipoNota");  // numerico/letra
        String alumno  = getStrParam(req, "alumno");
        String formato = getStrParam(req, "formato");

        // Se pasan los nombres (no IDs)
        String nivelNombre = getNombreNivel(nivel);
        String gradoNombre = getNombreGrado(grado);
        String seccionNombre = getNombreSeccion(seccion);

        try {
            byte[] archivo = reporteService.generarBloqueZip(
                    idUsuario, anio, periodo, nivelNombre, gradoNombre, seccionNombre, tipo, tipoNota, alumno, formato
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
        if (usuarioObj != null && usuarioObj instanceof Usuario)
            return ((Usuario) usuarioObj).getIdUsuario();
        // Fallback demo/testing
        return 1;
    }

    private void descargarArchivo(HttpServletResponse resp, byte[] archivo, String filename, String mime) throws IOException {
        resp.setContentType(mime);
        resp.setHeader("Content-Disposition", "attachment; filename=\"" + URLEncoder.encode(filename, StandardCharsets.UTF_8) + "\"");
        resp.setContentLength(archivo.length);
        try (OutputStream os = resp.getOutputStream()) {
            os.write(archivo);
        }
    }

    private String getExt(String formato) {
        if (formato == null) return "pdf";
        formato = formato.toLowerCase();
        if (formato.equals("excel")) return "xlsx";
        if (formato.equals("word")) return "docx";
        return "pdf";
    }

    private String getMime(String formato) {
        if (formato == null) return "application/pdf";
        formato = formato.toLowerCase();
        switch (formato) {
            case "excel": return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            case "word": return "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
            default: return "application/pdf";
        }
    }

    // Helpers para nombres (para ZIP)
    private String getNombreNivel(String idNivel) {
        if (idNivel == null || idNivel.isEmpty()) return "";
        try { return academicoDAO.listarNiveles().stream()
                .filter(n -> String.valueOf(n.getIdNivel()).equals(idNivel))
                .map(Nivel::getNombre).findFirst().orElse(""); }
        catch (Exception e) { return ""; }
    }
    private String getNombreGrado(String idGrado) {
        if (idGrado == null || idGrado.isEmpty()) return "";
        try { return academicoDAO.listarGrados().stream()
                .filter(g -> String.valueOf(g.getIdGrado()).equals(idGrado))
                .map(Grado::getNombre).findFirst().orElse(""); }
        catch (Exception e) { return ""; }
    }
    private String getNombreSeccion(String idSeccion) {
        if (idSeccion == null || idSeccion.isEmpty()) return "";
        try { return academicoDAO.listarSecciones().stream()
                .filter(s -> String.valueOf(s.getIdSeccion()).equals(idSeccion))
                .map(Seccion::getNombre).findFirst().orElse(""); }
        catch (Exception e) { return ""; }
    }
}
