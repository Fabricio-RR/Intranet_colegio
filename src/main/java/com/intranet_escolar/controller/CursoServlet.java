package com.intranet_escolar.controller;

import com.intranet_escolar.dao.CursoDAO;
import com.intranet_escolar.model.entity.Curso;
import com.google.common.base.Strings;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "CursoServlet", urlPatterns = {"/cursos"})
public class CursoServlet extends HttpServlet {
    private final CursoDAO cursoDAO = new CursoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = Strings.nullToEmpty(req.getParameter("action"));
        String idParam = Strings.nullToEmpty(req.getParameter("id"));

        if ("desactivar".equals(action) && !Strings.isNullOrEmpty(idParam)) {
            int id = Integer.parseInt(idParam);
            cursoDAO.cambiarEstado(id, false);
            resp.sendRedirect("cursos?success=1&op=deactivate");
            return;
        }

        if ("reactivar".equals(action) && !Strings.isNullOrEmpty(idParam)) {
            int id = Integer.parseInt(idParam);
            cursoDAO.cambiarEstado(id, true);
            resp.sendRedirect("cursos?success=1&op=reactivate");
            return;
        }

        List<Curso> cursos = cursoDAO.listarCursos();
        req.setAttribute("cursos", cursos);
        req.getRequestDispatcher("/views/academico/curso.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = Strings.nullToEmpty(req.getParameter("action"));
        String idParam = Strings.nullToEmpty(req.getParameter("id"));

        if ("crear".equals(action)) {
            Curso c = new Curso();
            c.setNombreCurso(Strings.nullToEmpty(req.getParameter("nombre")).trim());
            c.setArea(Strings.nullToEmpty(req.getParameter("area")).trim());
            c.setOrden(Integer.parseInt(Strings.nullToEmpty(req.getParameter("orden"))));
            boolean ok = cursoDAO.crearCurso(c);
            if (ok) {
                resp.sendRedirect("cursos?success=1&op=add");
            } else {
                resp.sendRedirect("cursos?error=No se pudo crear el curso.");
            }
            return;
        }

        if ("editar".equals(action)) {
            Curso c = new Curso();
            c.setIdCurso(Integer.parseInt(Strings.nullToEmpty(req.getParameter("idCurso"))));
            c.setNombreCurso(Strings.nullToEmpty(req.getParameter("nombre")).trim());
            c.setArea(Strings.nullToEmpty(req.getParameter("area")).trim());
            c.setOrden(Integer.parseInt(Strings.nullToEmpty(req.getParameter("orden"))));
            boolean ok = cursoDAO.editarCurso(c);
            if (ok) {
                resp.sendRedirect("cursos?success=1&op=edit");
            } else {
                resp.sendRedirect("cursos?error=No se pudo actualizar el curso.");
            }
            return;
        }

        if ("desactivar".equals(action) && !Strings.isNullOrEmpty(idParam)) {
            int idCurso = Integer.parseInt(idParam);
            boolean ok = cursoDAO.cambiarEstado(idCurso, false);
            if (ok) {
                resp.sendRedirect("cursos?success=1&op=deactivate");
            } else {
                resp.sendRedirect("cursos?error=No se pudo desactivar el curso.");
            }
            return;
        }

        if ("reactivar".equals(action) && !Strings.isNullOrEmpty(idParam)) {
            int idCurso = Integer.parseInt(idParam);
            boolean ok = cursoDAO.cambiarEstado(idCurso, true);
            if (ok) {
                resp.sendRedirect("cursos?success=1&op=reactivate");
            } else {
                resp.sendRedirect("cursos?error=No se pudo reactivar el curso.");
            }
            return;
        }

        resp.sendRedirect("cursos");
    }

    @Override
    public String getServletInfo() {
        return "Servlet Curso";
    }
}
