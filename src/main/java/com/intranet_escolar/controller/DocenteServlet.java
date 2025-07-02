package com.intranet_escolar.controller;

import com.intranet_escolar.dao.AnioLectivoDAO;
import com.intranet_escolar.model.DTO.ClaseDTO;
import com.intranet_escolar.model.DTO.CursoDTO;
import com.intranet_escolar.model.DTO.ExamenDTO;
import com.intranet_escolar.model.entity.Usuario;
import com.intranet_escolar.service.DocenteService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Date;
import java.util.List;


@WebServlet(name = "DocenteServlet", urlPatterns = {"/dashboard/docente"})
public class DocenteServlet extends HttpServlet {
    private DocenteService service;
    AnioLectivoDAO anioLectivoDAO = new AnioLectivoDAO();

    @Override
    public void init() throws ServletException {
        service = new DocenteService();
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Usuario autenticado
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
        int idDocente = usuario.getIdUsuario();
        int idAnioLectivo = anioLectivoDAO.obtenerAnioActivo();

        // 1. Estadísticas
        request.setAttribute("totalCursos",           service.obtenerTotalCursos(idDocente));
        request.setAttribute("totalEstudiantes",      service.obtenerTotalEstudiantes(idDocente));
        request.setAttribute("evaluacionesPendientes",service.obtenerEvaluacionesPendientes(idDocente,idAnioLectivo));
        request.setAttribute("clasesHoy",             service.obtenerClasesHoy(idDocente));

        // 2. Horario de hoy (lista)
        List<ClaseDTO> horarioHoy = service.obtenerHorarioHoy(idDocente);
        request.setAttribute("horarioHoy", horarioHoy);

        // 3. Próximos exámenes (lista)
        List<ExamenDTO> proximosExamenes = service.obtenerProximosExamenes(idDocente, idAnioLectivo);
        request.setAttribute("proximosExamenes", proximosExamenes);

        // 4. Mis cursos (lista)
        List<CursoDTO> misCursos = service.obtenerMisCursos(idDocente, idAnioLectivo);
        request.setAttribute("misCursos", misCursos);

        // 5. Fecha actual para bienvenida
        request.setAttribute("now", new Date());

        // 6. Forward a la vista
        request.getRequestDispatcher("/views/dashboard/docente.jsp")
               .forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
