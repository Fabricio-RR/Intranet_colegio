package com.intranet_escolar.controller;

import com.intranet_escolar.dao.AnioLectivoDAO;
import com.intranet_escolar.dao.MatriculaDAO;
import com.intranet_escolar.model.entity.AnioLectivo;
import com.intranet_escolar.model.entity.Matricula;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "MatriculaServlet", urlPatterns = {"/matricula"})
public class MatriculaServlet extends HttpServlet {

    private final MatriculaDAO matriculaDAO = new MatriculaDAO();
    private final AnioLectivoDAO anioLectivoDAO = new AnioLectivoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if (action == null || action.equals("listar")) {
                listarMatriculas(request, response);
            } else if (action.equals("ver")) {
                verDetalleMatricula(request, response);
            }
            // Espacio para futuras acciones: editar, anular, etc.
            else {
                listarMatriculas(request, response); // fallback
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Ocurrió un error al procesar la solicitud.");
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }

    private void listarMatriculas(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        int anioActual = anioLectivoDAO.obtenerAnioActivo();
        String param = request.getParameter("anio");
        int idAnio = (param != null) ? Integer.parseInt(param) : anioActual;

        List<Matricula> matriculas = matriculaDAO.listarMatriculasPorAnio(idAnio);
        List<AnioLectivo> anios = anioLectivoDAO.obtenerAniosDisponibles();

        request.setAttribute("anioActual", idAnio);
        request.setAttribute("anios", anios);
        request.setAttribute("matriculas", matriculas);
        request.getRequestDispatcher("/views/matricula/matricula.jsp").forward(request, response);
    }

    private void verDetalleMatricula(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Matricula matricula = matriculaDAO.obtenerMatriculaPorId(id);

        request.setAttribute("matricula", matricula);
        request.getRequestDispatcher("/views/matricula/detalle.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Futuro: guardar nueva matrícula o actualizar estado
    }
}
