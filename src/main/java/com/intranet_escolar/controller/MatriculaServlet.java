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
                // Puedes añadir más casos aquí (anular, constancia, etc.)
                default:
                    response.sendRedirect(request.getContextPath() + "/dashboard");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            response.getWriter().write("{\"exito\":false, \"mensaje\":\"Error inesperado en el servidor [Servlet].\"}");
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
        System.out.println("[DEBUG] doPost /matricula entró!!");
        response.setContentType("application/json");
        String action = request.getParameter("action");
        try {
            if ("editarGuardar".equals(action)) {
                guardarEdicionMatricula(request, response);
                return;
            }
            // ... otros casos futuros ...
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"exito\":false, \"mensaje\":\"Acción no válida\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"exito\":false, \"mensaje\":\"Error inesperado en el servidor.\"}");
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

            // LOG datos recibidos
            System.out.println("[DEBUG] Editar matrícula:");
            System.out.println("  idMatricula = " + idMatricula);
            System.out.println("  codigoMatricula = " + codigoMatricula);
            System.out.println("  parentesco = " + parentesco);
            System.out.println("  idNivel = " + idNivel);
            System.out.println("  idGrado = " + idGrado);
            System.out.println("  idSeccion = " + idSeccion);
            System.out.println("  estado = " + estado);

            boolean actualizado = matriculaDAO.actualizarMatricula(
                idMatricula, codigoMatricula, parentesco, idNivel, idGrado, idSeccion, estado
            );

            if (actualizado) {
                response.getWriter().write("{\"exito\":true, \"mensaje\":\"Matrícula actualizada correctamente\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"exito\":false, \"mensaje\":\"Ocurrió un error al actualizar la matrícula\"}");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"exito\":false, \"mensaje\":\"Error inesperado en el servidor\"}");
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet para gestión de Matrículas";
    }
}
