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
import java.util.ArrayList;
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
            case "detallePorNivelInactivas": 
                verDetallePorNivelInactivas(request, response);
                break;
            case "editar":
                mostrarFormularioEdicion(request, response);
                break;
            case "reactivarPorNivel":    
                reactivarPorNivel(request, response);
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
        } else if ("desactivarPorNivel".equals(action)) {
            desactivarPorNivel(request, response);
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

        // === Aquí separas activos e inactivos ===
        List<MallaCurricular> nivelesActivos = new ArrayList<>();
        List<MallaCurricular> nivelesInactivos = new ArrayList<>();
        for (MallaCurricular nivel : resumen) {
            // Si todos los cursos del nivel están inactivos, va a inactivos
            if (nivel.getTotalCursos() > 0 && nivel.getTotalCursos() == nivel.getTotalInactivos()) {
                nivelesInactivos.add(nivel);
            } else {
                nivelesActivos.add(nivel);
            }
        }

        // === Enviar a la vista ===
        request.setAttribute("anioActual", idAnio);
        request.setAttribute("anios", anios);
        request.setAttribute("nivelesActivos", nivelesActivos);
        request.setAttribute("nivelesInactivos", nivelesInactivos);

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
        boolean exito = true;

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
                exito = exito && mallaDAO.actualizar(m);
            }
        }
        if (exito) {
            response.setContentType("application/json");
            response.getWriter().write("{\"mensaje\":\"La malla curricular fue actualizada correctamente.\"}");
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,"Ocurrió un error al actualizar la malla.");
        }
    }
     
    private void desactivarPorNivel(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int idNivel = Integer.parseInt(request.getParameter("idNivel"));
        int anio = Integer.parseInt(request.getParameter("anio"));
        boolean ok = mallaDAO.desactivarPorNivel(idNivel, anio);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        if (ok) {
            response.getWriter().write("{\"mensaje\":\"Malla curricular desactivada correctamente para el nivel.\"}");
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"mensaje\":\"No se pudo desactivar la malla del nivel.\"}");
        }
    }
    private void verDetallePorNivelInactivas(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        int idNivel = Integer.parseInt(request.getParameter("idNivel"));
        int idAnio = Integer.parseInt(request.getParameter("anio"));
        List<MallaCurricular> detalle = mallaDAO.listarDetallePorNivelInactivas(idNivel, idAnio);
        request.setAttribute("detalleMalla", detalle);
        request.getRequestDispatcher("/views/malla/detalle.jsp").forward(request, response);
    }
    private void reactivarPorNivel(HttpServletRequest request, HttpServletResponse response)
        throws IOException {
    int idNivel = Integer.parseInt(request.getParameter("idNivel"));
    int idAnio = Integer.parseInt(request.getParameter("anio"));
    boolean exito = mallaDAO.reactivarPorNivel(idNivel, idAnio);

    response.setContentType("application/json");
    response.getWriter().write("{\"mensaje\":\""
            + (exito ? "Nivel reactivado correctamente." : "No se pudo reactivar el nivel.")
            + "\"}");
}


    @Override
    public String getServletInfo() {
        return "Servlet para gestión de Malla Curricular";
    }
}
