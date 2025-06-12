package com.intranet_escolar.controller;

import com.intranet_escolar.service.ApoderadoService;
import com.intranet_escolar.model.DTO.HijoDTO;
import com.intranet_escolar.model.DTO.NotaDTO;
import com.intranet_escolar.model.DTO.ComunicadoDTO;
import com.intranet_escolar.model.entity.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Date;
import java.util.List;

@WebServlet(name = "ApoderadoServlet", urlPatterns = {"/dashboard/apoderado"})
public class ApoderadoServlet extends HttpServlet {

    private ApoderadoService service;

    @Override
    public void init() throws ServletException {
        this.service = new ApoderadoService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Asumo que DashboardServlet ya validó sesión y rol
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
        int idApoderado = usuario.getIdUsuario();

       // 1. Listar hijos
        List<HijoDTO> hijos = service.obtenerHijos(idApoderado);
        request.setAttribute("hijos", hijos);

        // 2. Seleccionar hijo (param o primer hijo)
        int hijoId = request.getParameter("hijoId") != null
            ? Integer.parseInt(request.getParameter("hijoId"))
            : (hijos.isEmpty() ? -1 : hijos.get(0).getId());

        HijoDTO hijoSeleccionado = hijos.stream()
            .filter(h -> h.getId() == hijoId)
            .findFirst()
            .orElse(null);

        if (hijoSeleccionado != null) {
            // Mezclar resumen
            HijoDTO resumen = service.obtenerResumenHijo(hijoId);
            if (resumen != null) {
                hijoSeleccionado.setPromedioGeneral(resumen.getPromedioGeneral());
                hijoSeleccionado.setPorcentajeAsistencia(resumen.getPorcentajeAsistencia());
                hijoSeleccionado.setPuntajeConducta(resumen.getPuntajeConducta());
                hijoSeleccionado.setPosicion(resumen.getPosicion());
            }

            request.setAttribute("hijoSeleccionado", hijoSeleccionado);

            // Demás datos del dashboard
            request.setAttribute("promedioBimestre", service.obtenerPromedioBimestre(hijoId));
            request.setAttribute("cambioPromedio", service.obtenerCambioPromedio(hijoId));
            request.setAttribute("diasAsistidos", service.obtenerAsistencias(hijoId));
            request.setAttribute("totalDias", service.obtenerTotalDias(hijoId));
            request.setAttribute("totalMeritos", service.obtenerMeritos(hijoId));
            request.setAttribute("meritosRecientes", service.obtenerMeritosRecientes(hijoId));
            request.setAttribute("posicionSeccion", service.obtenerPosicion(hijoId));
            request.setAttribute("totalEstudiantesSeccion", service.obtenerTotalEstudiantesSeccion(hijoId));
            request.setAttribute("nombresCursos", service.obtenerCursos(hijoId));
            request.setAttribute("notasCursos", service.obtenerNotasPorCurso(hijoId));
            request.setAttribute("periodos", service.obtenerPeriodos(hijoId));
            request.setAttribute("promediosPeriodos", service.obtenerPromediosPorPeriodo(hijoId));
            request.setAttribute("ultimasCalificaciones", service.obtenerUltimasCalificaciones(hijoId));
            request.setAttribute("comunicadosRecientes", service.obtenerComunicadosRecientes(idApoderado));
        }

        request.setAttribute("now", new Date());
        request.getRequestDispatcher("/views/dashboard/apoderado.jsp")
               .forward(request, response);
    }
}
