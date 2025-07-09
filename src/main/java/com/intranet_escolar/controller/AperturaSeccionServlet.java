package com.intranet_escolar.controller;

import com.intranet_escolar.dao.AcademicoDAO;
import com.intranet_escolar.dao.AnioLectivoDAO;
import com.intranet_escolar.dao.AperturaSeccionDAO;
import com.intranet_escolar.model.DTO.AperturaSeccionDTO;
import com.intranet_escolar.model.entity.AnioLectivo;
import com.intranet_escolar.model.entity.Grado;
import com.intranet_escolar.model.entity.Nivel;
import com.intranet_escolar.model.entity.Seccion;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AperturaSeccionServlet", urlPatterns = {"/apertura-seccion"})
public class AperturaSeccionServlet extends HttpServlet {

    private final AperturaSeccionDAO aperturaSeccionDAO = new AperturaSeccionDAO();
    private final AcademicoDAO academicoDAO = new AcademicoDAO();
    private final AnioLectivoDAO anioLectivoDAO = new AnioLectivoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String idAnioLectivoParam = req.getParameter("idAnioLectivo");
        int idAnioLectivo;

        List<AnioLectivo> anios = anioLectivoDAO.obtenerAniosDisponibles();
        int anioActual = anioLectivoDAO.obtenerAnioActivo();
        if (idAnioLectivoParam != null && !idAnioLectivoParam.isEmpty()) {
            idAnioLectivo = Integer.parseInt(idAnioLectivoParam);
        } else {
            idAnioLectivo = anioActual;
        }

        // Desactivar apertura
        if ("desactivar".equals(action)) {
            int idApertura = Integer.parseInt(req.getParameter("id"));
            boolean ok = aperturaSeccionDAO.desactivarAperturaSeccion(idApertura);
            if (ok) {
                resp.sendRedirect("apertura-seccion?success=1&op=deactivate&idAnioLectivo=" + idAnioLectivo);
            } else {
                resp.sendRedirect("apertura-seccion?error=No se pudo desactivar la apertura.&idAnioLectivo=" + idAnioLectivo);
            }
            return;
        }
        // Reactivar apertura
        if ("reactivar".equals(action)) {
            int idApertura = Integer.parseInt(req.getParameter("id"));
            boolean ok = aperturaSeccionDAO.reactivarAperturaSeccion(idApertura);
            if (ok) {
                resp.sendRedirect("apertura-seccion?success=1&op=reactivate&idAnioLectivo=" + idAnioLectivo);
            } else {
                resp.sendRedirect("apertura-seccion?error=No se pudo reactivar la apertura.&idAnioLectivo=" + idAnioLectivo);
            }
            return;
        }

        // Listar aperturas de ese año
        List<AperturaSeccionDTO> aperturas = aperturaSeccionDAO.obtenerAperturasSeccionPorAnio(idAnioLectivo);

        // Para el modal de creación
        List<Nivel> niveles = academicoDAO.listarNiveles();
        List<Grado> grados = academicoDAO.listarGrados();
        List<Seccion> secciones = academicoDAO.listarSecciones();

        req.setAttribute("anios", anios);
        req.setAttribute("anioActual", idAnioLectivo);
        req.setAttribute("aperturas", aperturas);
        req.setAttribute("niveles", niveles);
        req.setAttribute("grados", grados);
        req.setAttribute("secciones", secciones);
        req.setAttribute("idAnioLectivo", idAnioLectivo);

        req.getRequestDispatcher("/views/academico/apertura-seccion.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        String idAnioLectivoParam = req.getParameter("idAnioLectivo");
        int idAnioLectivo = (idAnioLectivoParam != null && !idAnioLectivoParam.isEmpty())
                ? Integer.parseInt(idAnioLectivoParam)
                : 0;

        // Crear apertura
        if ("crear".equals(action)) {
            int idGrado = Integer.parseInt(req.getParameter("idGrado"));
            int idSeccion = Integer.parseInt(req.getParameter("idSeccion"));
            if (aperturaSeccionDAO.existeAperturaSeccion(idAnioLectivo, idGrado, idSeccion)) {
                resp.sendRedirect("apertura-seccion?error=Ya existe una apertura activa para ese año, grado y sección.&idAnioLectivo=" + idAnioLectivo);
                return;
            }
            boolean ok = aperturaSeccionDAO.crearAperturaSeccion(idAnioLectivo, idGrado, idSeccion);
            if (ok) {
                resp.sendRedirect("apertura-seccion?success=1&op=add&idAnioLectivo=" + idAnioLectivo);
            } else {
                resp.sendRedirect("apertura-seccion?error=No se pudo crear la apertura.&idAnioLectivo=" + idAnioLectivo);
            }
            return;
        }

        // Editar apertura
        if ("editar".equals(action)) {
            int idApertura = Integer.parseInt(req.getParameter("idApertura"));
            int idGrado = Integer.parseInt(req.getParameter("idGrado"));
            int idSeccion = Integer.parseInt(req.getParameter("idSeccion"));
            boolean ok = aperturaSeccionDAO.editarAperturaSeccion(idApertura, idGrado, idSeccion);
            if (ok) {
                resp.sendRedirect("apertura-seccion?success=1&op=edit&idAnioLectivo=" + idAnioLectivo);
            } else {
                resp.sendRedirect("apertura-seccion?error=No se pudo editar la apertura.&idAnioLectivo=" + idAnioLectivo);
            }
            return;
        }

        resp.sendRedirect("apertura-seccion?idAnioLectivo=" + idAnioLectivo);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
