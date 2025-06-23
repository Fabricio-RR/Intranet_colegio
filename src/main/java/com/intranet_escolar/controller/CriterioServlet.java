package com.intranet_escolar.controller;

import com.intranet_escolar.dao.PeriodoDAO;
import com.intranet_escolar.dao.CriterioDAO;
import com.intranet_escolar.dao.CursoDAO;
import com.intranet_escolar.model.entity.Criterio;
import com.intranet_escolar.model.entity.Curso;
import com.intranet_escolar.model.entity.Periodo;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "CriterioServlet", urlPatterns = {"/criterio"})
public class CriterioServlet extends HttpServlet {

    private final CriterioDAO criterioDAO = new CriterioDAO();
    private final CursoDAO cursoDAO = new CursoDAO();
    private final PeriodoDAO periodoDAO = new PeriodoDAO();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Listar combos de cursos y periodos
        List<Curso> cursos = cursoDAO.listarTodos();
        List<Periodo> periodos = periodoDAO.listarTodos();
        req.setAttribute("cursos", cursos);
        req.setAttribute("periodos", periodos);

        // Filtros seleccionados
        String idCursoStr = req.getParameter("idCurso");
        String idPeriodoStr = req.getParameter("idPeriodo");

        int idCurso = 0, idPeriodo = 0;
        List<Criterio> criterios = null;
        if (idCursoStr != null && idPeriodoStr != null && !idCursoStr.isEmpty() && !idPeriodoStr.isEmpty()) {
            idCurso = Integer.parseInt(idCursoStr);
            idPeriodo = Integer.parseInt(idPeriodoStr);
            criterios = criterioDAO.listarPorCursoPeriodo(idCurso, idPeriodo);
        }

        req.setAttribute("idCurso", idCurso);
        req.setAttribute("idPeriodo", idPeriodo);
        req.setAttribute("criterios", criterios);

        // Eliminar
        String action = req.getParameter("action");
        if ("eliminar".equals(action)) {
            int idCriterio = Integer.parseInt(req.getParameter("idCriterio"));
            criterioDAO.eliminar(idCriterio);
            resp.sendRedirect(req.getContextPath() + "/criterios?idCurso=" + idCurso + "&idPeriodo=" + idPeriodo);
            return;
        }

        req.getRequestDispatcher("/views/calificacion/criterios.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        boolean exito = false;
        String idCurso = req.getParameter("idCurso");
        String idPeriodo = req.getParameter("idPeriodo");

        if ("agregar".equals(action)) {
            // Recibir parámetros del modal agregar
            String nombre = req.getParameter("nombre");
            String descripcion = req.getParameter("tipo"); // Si quieres usar el campo 'tipo' como descripción
            int idCursoInt = Integer.parseInt(idCurso);
            int idPeriodoInt = Integer.parseInt(idPeriodo);

            Criterio c = new Criterio();
            c.setNombre(nombre);
            c.setDescripcion(descripcion);
            c.setIdCurso(idCursoInt);
            c.setIdPeriodo(idPeriodoInt);

            exito = criterioDAO.agregar(c);

        } else if ("editar".equals(action)) {
            int idCriterio = Integer.parseInt(req.getParameter("idCriterio"));
            String nombre = req.getParameter("nombre");
            String descripcion = req.getParameter("tipo"); // Si quieres usar el campo 'tipo' como descripción

            Criterio c = new Criterio();
            c.setIdCriterio(idCriterio);
            c.setNombre(nombre);
            c.setDescripcion(descripcion);

            exito = criterioDAO.editar(c);
        }

        // Siempre redirige con los mismos filtros
        resp.sendRedirect(req.getContextPath() + "/criterios?idCurso=" + idCurso + "&idPeriodo=" + idPeriodo);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
