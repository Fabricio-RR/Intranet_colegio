package com.intranet_escolar.controller;

import com.intranet_escolar.dao.DocenteDAO;
import com.intranet_escolar.dao.MallaCurricularDAO;
import com.intranet_escolar.model.entity.AnioLectivo;
import com.intranet_escolar.model.entity.MallaCurricular;
import com.intranet_escolar.model.entity.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "MallaCurricularServlet", urlPatterns = {"/malla-curricular"})
public class MallaCurricularServlet extends HttpServlet {

    private final MallaCurricularDAO mallaDAO = new MallaCurricularDAO();
    private final DocenteDAO docenteDAO = new DocenteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "ver";

        switch (action) {
            case "ver":
                mostrarResumenPorNivel(request, response);
                break;
            case "detallePorNivel":
                verDetallePorNivel(request, response);
                break;
            case "editar":
                mostrarFormularioEdicion(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("actualizarPorNivel".equals(action)) {
            procesarEdicionPorNivel(request, response);
        } else {
            doGet(request, response);
        }
    }

    private void mostrarResumenPorNivel(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String anioParam = request.getParameter("anio");
        int idAnio = (anioParam != null && !anioParam.isEmpty())
                ? Integer.parseInt(anioParam)
                : mallaDAO.obtenerAnioActivo();

        List<AnioLectivo> anios = mallaDAO.obtenerAniosDisponibles();
        List<MallaCurricular> resumen = mallaDAO.listarResumenPorNivel(idAnio);

        request.setAttribute("anioActual", idAnio);
        request.setAttribute("anios", anios);
        request.setAttribute("resumenNiveles", resumen);
        request.getRequestDispatcher("/views/malla/malla.jsp").forward(request, response);
    }

    private void verDetallePorNivel(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int idNivel = Integer.parseInt(request.getParameter("idNivel"));
        int idAnio = Integer.parseInt(request.getParameter("anio"));
        List<MallaCurricular> detalle = mallaDAO.listarDetallePorNivel(idNivel, idAnio);
        request.setAttribute("detalleMalla", detalle);
        request.getRequestDispatcher("/views/malla/detalle.jsp").forward(request, response);
    }

    private void mostrarFormularioEdicion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int idNivel = Integer.parseInt(request.getParameter("idNivel"));
        int idAnio  = Integer.parseInt(request.getParameter("anio"));
        List<MallaCurricular> detalle = mallaDAO.listarDetallePorNivel(idNivel, idAnio);
        List<Usuario> docentes = docenteDAO.listarTodos();

        request.setAttribute("detalleMalla", detalle);
        request.setAttribute("docentes", docentes);
        request.getRequestDispatcher("/views/malla/editar-malla.jsp").forward(request, response);
    }

     private void procesarEdicionPorNivel(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String[] ids = request.getParameterValues("idMalla[]");
        if (ids != null) {
            for (String s : ids) {
                int idM = Integer.parseInt(s);
                String dp = request.getParameter("idDocente_" + idM);
                int idDoc = (dp != null && !dp.isEmpty())
                          ? Integer.parseInt(dp)
                          : 0;
                int orden  = Integer.parseInt(request.getParameter("orden_" + idM));
                boolean act= request.getParameter("activo_" + idM) != null;

                MallaCurricular m = new MallaCurricular();
                m.setIdMalla(idM);
                m.setIdDocente(idDoc);
                m.setOrden(orden);
                m.setActivo(act);
                mallaDAO.actualizar(m);
            }
        }
        // redirigir al mismo año
        String anio = request.getParameter("anio");
        response.sendRedirect(request.getContextPath() 
            + "/malla-curricular?anio=" + anio);
    }
     
    @Override
    public String getServletInfo() {
        return "Servlet para gestión de Malla Curricular";
    }
}
