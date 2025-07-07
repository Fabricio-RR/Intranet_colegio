package com.intranet_escolar.controller;

import com.intranet_escolar.dao.CursoDAO;
import com.intranet_escolar.model.entity.Curso;
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
        String action = req.getParameter("action");
        if ("desactivar".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            cursoDAO.desactivarCurso(id);
            resp.sendRedirect("cursos?success=1&op=deactivate");
            return;
        }
        List<Curso> cursos = cursoDAO.listarCursosActivos();
        req.setAttribute("cursos", cursos);
        req.getRequestDispatcher("/views/academico/curso.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("crear".equals(action)) {
            Curso c = new Curso();
            c.setNombreCurso(req.getParameter("nombre"));
            c.setArea(req.getParameter("area"));
            c.setOrden(Integer.parseInt(req.getParameter("orden")));
            boolean ok = new CursoDAO().crearCurso(c);
            if (ok) {
                resp.sendRedirect("cursos?success=1&op=add");
            } else {
                resp.sendRedirect("cursos?error=No se pudo crear el curso.");
            }
            return;
        }

        if ("editar".equals(action)) {
            Curso c = new Curso();
            c.setIdCurso(Integer.parseInt(req.getParameter("idCurso")));
            c.setNombreCurso(req.getParameter("nombre"));
            c.setArea(req.getParameter("area"));
            c.setOrden(Integer.parseInt(req.getParameter("orden")));
            boolean ok = new CursoDAO().editarCurso(c);
            if (ok) {
                resp.sendRedirect("cursos?success=1&op=edit");
            } else {
                resp.sendRedirect("cursos?error=No se pudo actualizar el curso.");
            }
            return;
        }

        if ("desactivar".equals(action)) {
            int idCurso = Integer.parseInt(req.getParameter("id"));
            boolean ok = new CursoDAO().desactivarCurso(idCurso);
            if (ok) {
                resp.sendRedirect("cursos?success=1&op=deactivate");
            } else {
                resp.sendRedirect("cursos?error=No se pudo desactivar el curso.");
            }
            return;
        }

        resp.sendRedirect("cursos");
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
