package com.intranet_escolar.controller;

import com.intranet_escolar.dao.DashboardDAO;
import com.intranet_escolar.model.DTO.HijoDTO;
import com.intranet_escolar.model.entity.Usuario;
import com.intranet_escolar.service.ApoderadoService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "ApoderadoServlet", urlPatterns = {"/dashboard/apoderado"})
public class ApoderadoServlet extends HttpServlet {

    private final ApoderadoService apoderadoService = new ApoderadoService();
    private DashboardDAO dashboardDAO;

    @Override
    public void init() throws ServletException {
        try {
            dashboardDAO = new DashboardDAO();
        } catch (SQLException e) {
            throw new ServletException("Error al inicializar DashboardDAO", e);
        }
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");

        if (usuario == null || !usuario.isEsApoderado()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int idApoderado = usuario.getIdUsuario();

        // Obtener hijos
        List<HijoDTO> hijos = apoderadoService.obtenerHijos(idApoderado);
        request.setAttribute("hijos", hijos);

        // Obtener ID del hijo seleccionado
        int hijoId = Optional.ofNullable(request.getParameter("hijoId"))
                .map(Integer::parseInt)
                .orElse(hijos.isEmpty() ? -1 : hijos.get(0).getId());

        if (hijoId != -1) {
            request.setAttribute("hijoSeleccionado", apoderadoService.obtenerResumenHijo(hijoId));
            request.setAttribute("promedioBimestre", apoderadoService.obtenerPromedioBimestre(hijoId));
            request.setAttribute("cambioPromedio", apoderadoService.obtenerCambioPromedio(hijoId));
            request.setAttribute("diasAsistidos", apoderadoService.obtenerAsistencias(hijoId));
            request.setAttribute("totalDias", apoderadoService.obtenerTotalDias(hijoId));
            request.setAttribute("totalMeritos", apoderadoService.obtenerMeritos(hijoId));
            request.setAttribute("meritosRecientes", apoderadoService.obtenerMeritosRecientes(hijoId));
            request.setAttribute("posicionSeccion", apoderadoService.obtenerPosicion(hijoId));
            request.setAttribute("totalEstudiantesSeccion", apoderadoService.obtenerTotalEstudiantesSeccion(hijoId));
            request.setAttribute("nombresCursos", apoderadoService.obtenerCursos(hijoId));
            request.setAttribute("notasCursos", apoderadoService.obtenerNotasPorCurso(hijoId));
            request.setAttribute("periodos", apoderadoService.obtenerPeriodos(hijoId));
            request.setAttribute("promediosPeriodos", apoderadoService.obtenerPromediosPorPeriodo(hijoId));
            request.setAttribute("ultimasCalificaciones", apoderadoService.obtenerUltimasCalificaciones(hijoId));
            request.setAttribute("comunicadosRecientes", apoderadoService.obtenerComunicadosRecientes(idApoderado));
        }

        request.getRequestDispatcher("/views/dashboard/apoderado.jsp").forward(request, response);
    }
}
