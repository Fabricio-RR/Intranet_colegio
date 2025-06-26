package com.intranet_escolar.controller;

import com.intranet_escolar.dao.AnioLectivoDAO;
import com.intranet_escolar.dao.CriterioDAO;
import com.intranet_escolar.dao.MallaCriterioDAO;
import com.intranet_escolar.dao.MallaCurricularDAO;
import com.intranet_escolar.dao.PeriodoDAO;
import com.intranet_escolar.model.entity.AnioLectivo;
import com.intranet_escolar.model.entity.Criterio;
import com.intranet_escolar.model.entity.MallaCriterio;
import com.intranet_escolar.model.entity.MallaCurricular;
import com.intranet_escolar.model.entity.Periodo;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet(name = "CriterioServlet", urlPatterns = {"/criterio"})
public class CriterioServlet extends HttpServlet {

    private final AnioLectivoDAO anioLectivoDAO = new AnioLectivoDAO();
    private final CriterioDAO criterioDAO = new CriterioDAO();
    private final MallaCriterioDAO mallaCriterioDAO = new MallaCriterioDAO();
    private final MallaCurricularDAO mallaCurricularDAO = new MallaCurricularDAO();
    private final PeriodoDAO periodoDAO = new PeriodoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if ("desactivarCatalogo".equals(action)) {
            desactivarCatalogo(request, response);
            return;
        } else if ("desactivarMallaCriterio".equals(action)) {
            desactivarMallaCriterio(request, response);
            return;
        }

        // 1. Cargar años lectivos disponibles
        List<AnioLectivo> aniosLectivos = anioLectivoDAO.obtenerAniosDisponibles();
        String idAnioLectivoParam = request.getParameter("idAnioLectivo");
        Integer idAnioLectivo = null;

        // Default: año activo si no hay selección previa
        if (idAnioLectivoParam != null && !idAnioLectivoParam.isEmpty()) {
            idAnioLectivo = Integer.parseInt(idAnioLectivoParam);
        } else if (!aniosLectivos.isEmpty()) {
            idAnioLectivo = anioLectivoDAO.obtenerAnioActivo();
        }

        // 2. Cargar catálogo de criterios
        List<Criterio> criteriosCatalogo = criterioDAO.listarTodos();

        // 3. Cargar mallas curriculares filtradas por año lectivo
        List<MallaCurricular> listaMallas = new ArrayList<>();
        if (idAnioLectivo != null && idAnioLectivo > 0) {
            listaMallas = mallaCurricularDAO.listarTodosActivosPorAnio(idAnioLectivo);
        }
        // Agrupar por grado-sección
        Map<String, List<MallaCurricular>> mallasCurricularesAgrupadas = new LinkedHashMap<>();
        for (MallaCurricular m : listaMallas) {
            String key = m.getGrado() + " - Sección " + m.getSeccion();
            mallasCurricularesAgrupadas.computeIfAbsent(key, k -> new ArrayList<>()).add(m);
        }

        // 4. Periodos **sólo del año seleccionado**
        List<Periodo> periodos = new ArrayList<>();
        if (idAnioLectivo != null && idAnioLectivo > 0) {
            periodos = periodoDAO.listarPorAnioLectivo(idAnioLectivo); // Este método debes tenerlo en tu DAO de Periodo
        }

        // 5. Filtros: malla/periodo seleccionados
        String idMallaCurricular = request.getParameter("idMallaCurricular");
        String idPeriodo = request.getParameter("idPeriodo");
        List<MallaCriterio> mallaCriterios = new ArrayList<>();

        if (idMallaCurricular != null && idPeriodo != null
                && !idMallaCurricular.isEmpty() && !idPeriodo.isEmpty()
                && !idMallaCurricular.equals("null") && !idPeriodo.equals("null")) {
            mallaCriterios = mallaCriterioDAO.listarPorMallaYPeriodo(
                    Integer.parseInt(idMallaCurricular),
                    Integer.parseInt(idPeriodo)
            );
        }

        // Enviar atributos a JSP
        request.setAttribute("aniosLectivos", aniosLectivos);
        request.setAttribute("idAnioLectivo", idAnioLectivo);
        request.setAttribute("criteriosCatalogo", criteriosCatalogo);
        request.setAttribute("mallasCurricularesAgrupadas", mallasCurricularesAgrupadas);
        request.setAttribute("periodos", periodos);
        request.setAttribute("idMallaCurricular", idMallaCurricular);
        request.setAttribute("idPeriodo", idPeriodo);
        request.setAttribute("mallaCriterios", mallaCriterios);

        request.getRequestDispatcher("/views/calificaciones/criterios.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        // Conserva el año lectivo y los filtros en la redirección
        String idAnioLectivo = request.getParameter("idAnioLectivo");
        String idMallaCurricular = request.getParameter("idMallaCurricular");
        String idPeriodo = request.getParameter("idPeriodo");

        try {
            if ("agregarCatalogo".equals(action)) {
                agregarCatalogo(request, response);
            } else if ("editarCatalogo".equals(action)) {
                editarCatalogo(request, response);
            } else if ("desactivarCatalogo".equals(action)) {
                desactivarCatalogo(request, response);
            } else if ("agregarMallaCriterio".equals(action)) {
                agregarMallaCriterio(request, response, idAnioLectivo, idMallaCurricular, idPeriodo);
            } else if ("editarMallaCriterio".equals(action)) {
                editarMallaCriterio(request, response, idAnioLectivo, idMallaCurricular, idPeriodo);
            } else if ("desactivarMallaCriterio".equals(action)) {
                desactivarMallaCriterio(request, response);
            } else {
                response.sendRedirect("criterio");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("criterio?error=1#catalogo");
        }
    }

    // ===== Métodos CRUD de Catálogo =====
    private void agregarCatalogo(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String nombre = request.getParameter("nombre");
            String descripcion = request.getParameter("descripcion");
            double base = Double.parseDouble(request.getParameter("base"));
            boolean activo = "1".equals(request.getParameter("activo"));

            Criterio c = new Criterio();
            c.setNombre(nombre);
            c.setBase(base);
            c.setDescripcion(descripcion);
            c.setActivo(activo);

            criterioDAO.agregar(c);
            response.sendRedirect("criterio?success=1#catalogo");
        } catch (Exception e) {
            response.sendRedirect("criterio?error=1#catalogo");
        }
    }

    private void editarCatalogo(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int idCriterio = Integer.parseInt(request.getParameter("idCriterio"));
            String nombre = request.getParameter("nombre");
            String descripcion = request.getParameter("descripcion");
            double base = Double.parseDouble(request.getParameter("base"));
            boolean activo = "1".equals(request.getParameter("activo"));

            Criterio c = new Criterio();
            c.setIdCriterio(idCriterio);
            c.setNombre(nombre);
            c.setBase(base);
            c.setDescripcion(descripcion);
            c.setActivo(activo);

            criterioDAO.editar(c);
            response.sendRedirect("criterio?success=1#catalogo");
        } catch (Exception e) {
            response.sendRedirect("criterio?error=1#catalogo");
        }
    }

    private void desactivarCatalogo(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int idCriterio = Integer.parseInt(request.getParameter("idCriterio"));
            criterioDAO.desactivar(idCriterio);
            response.sendRedirect("criterio?success=1#catalogo");
        } catch (Exception e) {
            response.sendRedirect("criterio?error=1#catalogo");
        }
    }

    // ===== Métodos CRUD de Malla Criterio (con filtros) =====

    private void agregarMallaCriterio(HttpServletRequest request, HttpServletResponse response,
                                      String idAnioLectivo, String idMallaCurricular, String idPeriodo) throws IOException {
        try {
            int idMalla = Integer.parseInt(idMallaCurricular);
            int idPer = Integer.parseInt(idPeriodo);
            int idCriterio = Integer.parseInt(request.getParameter("idCriterio"));
            String tipo = request.getParameter("tipo");
            String formula = request.getParameter("formula");
            boolean activo = "1".equals(request.getParameter("activo"));

            MallaCriterio m = new MallaCriterio();
            m.setIdMallaCurricular(idMalla);
            m.setIdPeriodo(idPer);
            m.setIdCriterio(idCriterio);
            m.setTipo(tipo);
            m.setFormula(formula);
            m.setActivo(activo);

            mallaCriterioDAO.agregar(m);
            // Mantener filtros y año en la URL tras guardar
            response.sendRedirect("criterio?idAnioLectivo=" + idAnioLectivo + "&idMallaCurricular=" + idMallaCurricular + "&idPeriodo=" + idPeriodo + "&success=1#malla");
        } catch (Exception e) {
            response.sendRedirect("criterio?idAnioLectivo=" + idAnioLectivo + "&idMallaCurricular=" + idMallaCurricular + "&idPeriodo=" + idPeriodo + "&error=1#malla");
        }
    }

    private void editarMallaCriterio(HttpServletRequest request, HttpServletResponse response,
                                     String idAnioLectivo, String idMallaCurricular, String idPeriodo) throws IOException {
        try {
            int idMallaCriterio = Integer.parseInt(request.getParameter("idMallaCriterio"));
            int idCriterio = Integer.parseInt(request.getParameter("idCriterio"));
            String tipo = request.getParameter("tipo");
            String formula = request.getParameter("formula");
            boolean activo = "1".equals(request.getParameter("activo"));
            int idPer = Integer.parseInt(idPeriodo);

            MallaCriterio m = new MallaCriterio();
            m.setIdMallaCriterio(idMallaCriterio);
            m.setIdCriterio(idCriterio);
            m.setTipo(tipo);
            m.setFormula(formula);
            m.setActivo(activo);
            m.setIdPeriodo(idPer);

            mallaCriterioDAO.editar(m);
            response.sendRedirect("criterio?idAnioLectivo=" + idAnioLectivo + "&idMallaCurricular=" + idMallaCurricular + "&idPeriodo=" + idPeriodo + "&success=1#malla");
        } catch (Exception e) {
            response.sendRedirect("criterio?idAnioLectivo=" + idAnioLectivo + "&idMallaCurricular=" + idMallaCurricular + "&idPeriodo=" + idPeriodo + "&error=1#malla");
        }
    }

    private void desactivarMallaCriterio(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idAnioLectivo = request.getParameter("idAnioLectivo");
        String idMallaCurricular = request.getParameter("idMallaCurricular");
        String idPeriodo = request.getParameter("idPeriodo");
        try {
            int idMallaCriterio = Integer.parseInt(request.getParameter("idMallaCriterio"));
            mallaCriterioDAO.desactivar(idMallaCriterio);
            response.sendRedirect("criterio?idAnioLectivo=" + idAnioLectivo + "&idMallaCurricular=" + idMallaCurricular + "&idPeriodo=" + idPeriodo + "&success=1#malla");
        } catch (Exception e) {
            response.sendRedirect("criterio?idAnioLectivo=" + idAnioLectivo + "&idMallaCurricular=" + idMallaCurricular + "&idPeriodo=" + idPeriodo + "&error=1#malla");
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet para gestión de criterios";
    }
}
