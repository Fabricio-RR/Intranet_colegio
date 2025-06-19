package com.intranet_escolar.controller;

import com.intranet_escolar.dao.AcademicoDAO;
import com.intranet_escolar.dao.AnioLectivoDAO;
import com.intranet_escolar.dao.MatriculaDAO;
import com.intranet_escolar.model.entity.AnioLectivo;
import com.intranet_escolar.model.entity.Grado;
import com.intranet_escolar.model.entity.Matricula;
import com.intranet_escolar.model.entity.Nivel;
import com.intranet_escolar.model.entity.Seccion;
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
        if (action == null) action = "listar";

        try {
            switch (action) {
                case "listar":
                    listarMatriculas(request, response);
                    break;
                case "ver":
                    verDetalleMatricula(request, response);
                    break;
                case "editar":
                    mostrarFormularioEdicion(request, response);
                    break;
                // Puedes añadir más casos aquí, por ejemplo: "anular", "constancia", etc.
                default:
                    response.sendRedirect(request.getContextPath() + "/dashboard");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error/500.jsp");
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error/404.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error/500.jsp");
        }
    }

    private void listarMatriculas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int anioActual = anioLectivoDAO.obtenerAnioActivo();
        String param = request.getParameter("anio");
        int idAnio = (param != null && !param.isEmpty()) ? Integer.parseInt(param) : anioActual;

        List<Matricula> matriculas = matriculaDAO.listarMatriculasPorAnio(idAnio);
        List<AnioLectivo> anios = anioLectivoDAO.obtenerAniosDisponibles();

        request.setAttribute("anioActual", idAnio);
        request.setAttribute("anios", anios);
        request.setAttribute("matriculas", matriculas);
        request.getRequestDispatcher("/views/matricula/matricula.jsp").forward(request, response);
    }

    private void verDetalleMatricula(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        Matricula matricula = matriculaDAO.obtenerMatriculaPorId(id);

        request.setAttribute("matricula", matricula);
        request.getRequestDispatcher("/views/matricula/detalle.jsp").forward(request, response);
    }
    private void mostrarFormularioEdicion(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException, SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        Matricula matricula = matriculaDAO.obtenerMatriculaPorId(id);
        AcademicoDAO academicoDAO = new AcademicoDAO();
        List<Nivel> niveles = academicoDAO.listarNiveles();
        List<Grado> grados = academicoDAO.listarGrados();
        List<Seccion> secciones = academicoDAO.listarSecciones();

        request.setAttribute("matricula", matricula);
        request.setAttribute("niveles", niveles);
        request.setAttribute("grados", grados);
        request.setAttribute("secciones", secciones);

        request.getRequestDispatcher("/views/matricula/editar-matricula.jsp").forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("editarGuardar".equals(action)) {
                guardarEdicionMatricula(request, response);
            }
            // ... otros casos futuros
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/views/error/500.jsp");
        }
    }
    private void guardarEdicionMatricula(HttpServletRequest request, HttpServletResponse response)
        throws IOException {
        try {
            int idMatricula = Integer.parseInt(request.getParameter("idMatricula"));
            String codigoMatricula = request.getParameter("codigoMatricula");
            String parentesco = request.getParameter("parentesco");
            int idNivel = Integer.parseInt(request.getParameter("nivel"));
            int idGrado = Integer.parseInt(request.getParameter("grado"));
            int idSeccion = Integer.parseInt(request.getParameter("seccion"));
            String estado = request.getParameter("estado");

            boolean actualizado = matriculaDAO.actualizarMatricula(
                idMatricula, codigoMatricula, parentesco, idNivel, idGrado, idSeccion, estado
            );

            response.setContentType("application/json");
            if (actualizado) {
                response.getWriter().write("{\"exito\":true, \"mensaje\":\"Matrícula actualizada correctamente\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"exito\":false, \"mensaje\":\"Ocurrió un error al actualizar la matrícula\"}");
            }
        } catch (Exception ex) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            response.getWriter().write("{\"exito\":false, \"mensaje\":\"Error inesperado en el servidor\"}");
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet para gestión de Matrículas";
    }
}
