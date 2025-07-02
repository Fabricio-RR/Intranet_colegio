package com.intranet_escolar.controller;

import com.intranet_escolar.dao.*;
import com.intranet_escolar.model.entity.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/notas")
public class NotasServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
        String rol = (String) request.getSession().getAttribute("rolActivo");

        // Año lectivo
        AnioLectivoDAO anioLectivoDAO = new AnioLectivoDAO();
        int idAnioLectivo;
        if ("administrador".equalsIgnoreCase(rol)) {
            List<AnioLectivo> aniosLectivos = anioLectivoDAO.obtenerAniosDisponibles();
            String paramAnio = request.getParameter("anioLectivo");
            if (paramAnio != null && !paramAnio.isEmpty()) {
                idAnioLectivo = Integer.parseInt(paramAnio);
            } else {
                idAnioLectivo = anioLectivoDAO.obtenerAnioActivo();
            }
            request.setAttribute("aniosLectivos", aniosLectivos);
            request.setAttribute("selectedAnioLectivo", idAnioLectivo);
        } else {
            idAnioLectivo = anioLectivoDAO.obtenerAnioActivo();
            request.setAttribute("anioLectivo", idAnioLectivo);
        }

        // Filtros seleccionados
        String paramNivel = request.getParameter("nivel");
        String paramGrado = request.getParameter("grado");
        String paramSeccion = request.getParameter("seccion");
        String paramCurso = request.getParameter("curso");
        String paramPeriodo = request.getParameter("periodo");

        int selectedNivel = paramNivel != null ? Integer.parseInt(paramNivel) : 0;
        int selectedGrado = paramGrado != null ? Integer.parseInt(paramGrado) : 0;
        int selectedSeccion = paramSeccion != null ? Integer.parseInt(paramSeccion) : 0;
        int selectedCurso = paramCurso != null ? Integer.parseInt(paramCurso) : 0;
        int selectedPeriodo = paramPeriodo != null ? Integer.parseInt(paramPeriodo) : 0;

        // Combos dependientes
        AcademicoDAO academicoDAO = new AcademicoDAO();
        List<Nivel> niveles = academicoDAO.listarNiveles();
        List<Grado> grados = (selectedNivel > 0 && idAnioLectivo > 0)
                ? academicoDAO.listarGradosPorNivelYAnio(selectedNivel, idAnioLectivo)
                : new ArrayList<>();
        List<Seccion> secciones = (selectedGrado > 0 && idAnioLectivo > 0)
                ? academicoDAO.listarSeccionesPorGradoYAnio(selectedGrado, idAnioLectivo)
                : new ArrayList<>();

        CursoDAO cursoDAO = new CursoDAO();
        PeriodoDAO periodoDAO = new PeriodoDAO();

        List<Curso> cursos = cursoDAO.listarCursosPorUsuarioYAnio(usuario.getIdUsuario(), idAnioLectivo, rol);
        List<Periodo> periodos = periodoDAO.obtenerPorCurso(selectedCurso, idAnioLectivo);

        // Criterios de malla curricular
        CriterioDAO criterioDAO = new CriterioDAO();
        List<MallaCriterio> criterios = criterioDAO.listarMallaCriteriosPorFiltros(
                selectedCurso, selectedSeccion, selectedPeriodo, idAnioLectivo);

        // Alumnos matriculados
        AlumnoDAO alumnoDAO = new AlumnoDAO();
        List<Alumno> alumnos = alumnoDAO.obtenerMatriculadosPorSeccion(selectedSeccion, idAnioLectivo);

        // Calificaciones (mapa para acceso rápido por idAlumno_idMallaCriterio)
        CalificacionDAO calificacionDAO = new CalificacionDAO();
        Map<String, Calificacion> mapaCalificaciones = new HashMap<>();
        if (selectedCurso > 0 && selectedSeccion > 0 && selectedPeriodo > 0) {
            List<Calificacion> calificaciones = calificacionDAO.listarPorFiltros(
                    selectedCurso, selectedSeccion, selectedPeriodo, idAnioLectivo);
            for (Calificacion c : calificaciones) {
                mapaCalificaciones.put(c.getIdAlumno() + "_" + c.getIdMallaCriterio(), c);
            }
        }

        // ¿El periodo está bloqueado?
        boolean periodoBloqueado = periodoDAO.estaBloqueado(selectedPeriodo, idAnioLectivo);

        // Atributos para JSP
        request.setAttribute("niveles", niveles);
        request.setAttribute("grados", grados);
        request.setAttribute("secciones", secciones);
        request.setAttribute("cursos", cursos);
        request.setAttribute("periodos", periodos);

        request.setAttribute("selectedNivel", selectedNivel);
        request.setAttribute("selectedGrado", selectedGrado);
        request.setAttribute("selectedSeccion", selectedSeccion);
        request.setAttribute("selectedCurso", selectedCurso);
        request.setAttribute("selectedPeriodo", selectedPeriodo);

        request.setAttribute("criterios", criterios);
        request.setAttribute("alumnos", alumnos);
        request.setAttribute("mapaCalificaciones", mapaCalificaciones);
        request.setAttribute("periodoBloqueado", periodoBloqueado);

        request.getRequestDispatcher("/views/calificaciones/registrar_notas.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
        String rol = (String) request.getSession().getAttribute("rolActivo");

        int idAnioLectivo = ("administrador".equalsIgnoreCase(rol) && request.getParameter("anioLectivo") != null)
                ? Integer.parseInt(request.getParameter("anioLectivo"))
                : new AnioLectivoDAO().obtenerAnioActivo();

        int idCurso = getIntOrDefault(request.getParameter("idCurso"), 0);
        int idSeccion = getIntOrDefault(request.getParameter("idSeccion"), 0);
        int idPeriodo = getIntOrDefault(request.getParameter("idPeriodo"), 0);

        // Solo procesa si el periodo está habilitado
        if (!new PeriodoDAO().estaBloqueado(idPeriodo, idAnioLectivo)) {
            String[] alumnos = request.getParameterValues("alumnoIds");
            String[] criterios = request.getParameterValues("criterioIds");

            CalificacionDAO calificacionDAO = new CalificacionDAO();

            if (alumnos != null && criterios != null) {
                for (String idAlumnoStr : alumnos) {
                    int idAlumno = Integer.parseInt(idAlumnoStr);
                    for (String idMallaCriterioStr : criterios) {
                        int idMallaCriterio = Integer.parseInt(idMallaCriterioStr);
                        String nombreCampo = "nota_" + idAlumno + "_" + idMallaCriterio;
                        String valorStr = request.getParameter(nombreCampo);
                        if (valorStr != null && !valorStr.trim().isEmpty()) {
                            try {
                                Double valorNota = Double.parseDouble(valorStr);
                                Calificacion c = new Calificacion();
                                c.setIdAlumno(idAlumno);
                                c.setIdMallaCriterio(idMallaCriterio);
                                c.setIdAnioLectivo(idAnioLectivo);
                                c.setNota(valorNota);
                                c.setFecha(new java.sql.Date(System.currentTimeMillis()));
                                c.setObservacion(null);
                                calificacionDAO.guardarOActualizar(c);
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }
                    }
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/notas" +
            "?curso=" + idCurso +
            "&seccion=" + idSeccion +
            "&periodo=" + idPeriodo +
            ("administrador".equalsIgnoreCase(rol) ? "&anioLectivo=" + idAnioLectivo : "")
        );
    }

    private int getIntOrDefault(String param, int defecto) {
        try {
            return (param != null && !param.isEmpty()) ? Integer.parseInt(param) : defecto;
        } catch (Exception e) {
            return defecto;
        }
    }
}
