package com.intranet_escolar.controller;

import com.google.common.base.Preconditions;
import com.google.common.base.Strings;
import com.intranet_escolar.dao.*;
import com.intranet_escolar.model.DTO.AperturaSeccionDTO;
import com.intranet_escolar.model.entity.*;
import com.intranet_escolar.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;



@WebServlet(name = "MatriculaServlet", urlPatterns = {"/matricula"})
public class MatriculaServlet extends HttpServlet {

    private final MatriculaDAO matriculaDAO = new MatriculaDAO();
    private final AnioLectivoDAO anioLectivoDAO = new AnioLectivoDAO();
    private final AperturaSeccionDAO aperturaSeccionDAO = new AperturaSeccionDAO();

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
                case "anular":
                    anularMatricula(request, response);
                    break;
                case "crear":
                    mostrarFormularioCreacion(request, response);
                break;
                case "exportarExcel":   
                exportarExcel(request, response);
                break;
                default:
                    response.sendRedirect(request.getContextPath() + "/matricula");
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
    private void mostrarFormularioCreacion(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException, SQLException {
        String anioParam = request.getParameter("anio");
        List<AnioLectivo> aniosLectivos = anioLectivoDAO.listarTodos(); // Todos los años en preparacion/activo

        int idAnioLectivoSeleccionado;
        if (anioParam != null && !anioParam.isEmpty()) {
            idAnioLectivoSeleccionado = Integer.parseInt(anioParam);
        } else if (!aniosLectivos.isEmpty()) {
            idAnioLectivoSeleccionado = aniosLectivos.get(0).getIdAnioLectivo(); // El primero
        } else {
            idAnioLectivoSeleccionado = 0; // O maneja error si no hay ninguno
        }

        // FILTRA las aperturas por el año seleccionado
        List<AperturaSeccionDTO> aperturasSeccion = aperturaSeccionDAO.obtenerAperturasSeccionPorAnio(idAnioLectivoSeleccionado);

        request.setAttribute("aniosLectivos", aniosLectivos);
        request.setAttribute("anioLectivoSeleccionado", idAnioLectivoSeleccionado);
        request.setAttribute("aperturasSeccion", aperturasSeccion);
        request.getRequestDispatcher("/views/matricula/crear-matricula.jsp").forward(request, response);
    }



    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        response.setContentType("application/json");
        try {
            if ("editarGuardar".equals(action)) {
                guardarEdicionMatricula(request, response);
            } else if ("anular".equals(action)) {
                anularMatricula(request, response);
            } else if ("crearGuardar".equals(action)) {
                crearMatricula(request, response);
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"exito\":false, \"mensaje\":\"Acción no válida\"}");
            }
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
        String parentesco = request.getParameter("parentesco");
        int idNivel = Integer.parseInt(request.getParameter("nivel"));
        int idGrado = Integer.parseInt(request.getParameter("grado"));
        int idSeccion = Integer.parseInt(request.getParameter("seccion"));
        String estado = request.getParameter("estado");
        String observacion = "";
        if ("condicional".equals(estado)) {
            observacion = request.getParameter("observacion");
        }

        boolean actualizado = matriculaDAO.actualizarMatricula(
            idMatricula, parentesco, idNivel, idGrado, idSeccion, estado, observacion
        );

        if (actualizado) {
            response.sendRedirect(request.getContextPath() + "/matricula?msg=ok");
        } else {
            response.sendRedirect(request.getContextPath() + "/matricula?msg=error");
        }
    } catch (Exception ex) {
        ex.printStackTrace();
        response.sendRedirect(request.getContextPath() + "/matricula?msg=error");
    }
}
    private void anularMatricula(HttpServletRequest request, HttpServletResponse response)
        throws IOException {
    int id = Integer.parseInt(request.getParameter("id"));
    boolean exito;
    try {
        exito = matriculaDAO.cambiarEstadoMatricula(id, "retirado");
        if (exito) {
            response.getWriter().write("{\"exito\":true, \"mensaje\":\"Matrícula anulada correctamente.\"}");
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"exito\":false, \"mensaje\":\"No se pudo anular la matrícula.\"}");
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        response.getWriter().write("{\"exito\":false, \"mensaje\":\"Error en el servidor.\"}");
    }
}
    
   private void crearMatricula(HttpServletRequest request, HttpServletResponse response) throws IOException {
    try {
        int idAlumno = Integer.parseInt(Strings.nullToEmpty(request.getParameter("idAlumno")).trim());
        int idApoderado = Integer.parseInt(Strings.nullToEmpty(request.getParameter("idApoderado")).trim());
        String parentesco = Strings.nullToEmpty(request.getParameter("parentesco")).trim();
        int idAperturaSeccion = Integer.parseInt(Strings.nullToEmpty(request.getParameter("idAperturaSeccion")).trim());
        int idAnioLectivo = Integer.parseInt(Strings.nullToEmpty(request.getParameter("anioLectivo")).trim());
        String estado = Strings.nullToEmpty(request.getParameter("estado")).trim();
        String observacion = Strings.nullToEmpty(request.getParameter("observacion")).trim();

        // Validar argumentos usando Guava 
        Preconditions.checkArgument(idAlumno > 0, "ID de alumno es obligatorio");
        Preconditions.checkArgument(idApoderado > 0, "ID de apoderado es obligatorio");
        Preconditions.checkArgument(!Strings.isNullOrEmpty(parentesco), "Parentesco es obligatorio");
        Preconditions.checkArgument(idAperturaSeccion > 0, "Apertura de sección es obligatoria");
        Preconditions.checkArgument(idAnioLectivo > 0, "Año lectivo es obligatorio");
        Preconditions.checkArgument(!Strings.isNullOrEmpty(estado), "Estado es obligatorio");

        // 2. Crear alumno en tabla alumno (si no existe) y obtener código de matrícula
        AnioLectivoDAO anioLectivoDAO = new AnioLectivoDAO();
        String nombreAnio = anioLectivoDAO.obtenerNombrePorId(idAnioLectivo);
        int anioInt = Integer.parseInt(nombreAnio);

        AlumnoDAO alumnoDAO = new AlumnoDAO();
        String codigoMatricula = alumnoDAO.insertarAlumnoSiNoExiste(idAlumno, idAperturaSeccion, anioInt);

        // 3. Registrar matrícula (usa tu SP/método de matrícula)
        boolean exito = matriculaDAO.crearMatricula(
            idAlumno, idApoderado, parentesco, idAperturaSeccion, idAnioLectivo, estado, observacion
        );

        // 4. Bitácora y respuesta
        if (exito) {
            Usuario usuarioSesion = SesionUtil.getUsuarioLogueado(request);
            int idUsuarioSesion = usuarioSesion.getIdUsuario();
            String mensaje = String.format(
                "Registró matrícula para alumno ID: %d (código: %s), apoderado ID: %d, sección ID: %d, estado: %s",
                idAlumno, codigoMatricula, idApoderado, idAperturaSeccion, estado
            );
            BitacoraUtil.registrar(idUsuarioSesion, "Matrícula", mensaje);
            response.sendRedirect(request.getContextPath() + "/matricula?msg=creado");
        } else {
            response.sendRedirect(request.getContextPath() + "/matricula?msg=error");
        }
    } catch (IllegalArgumentException e) {
        // Captura cualquier validación fallida
        e.printStackTrace();
        response.sendRedirect(request.getContextPath() + "/matricula?msg=error&det=" + e.getMessage());
    } catch (SQLException e) {
        if ("45000".equals(e.getSQLState())) {
            request.getSession().setAttribute("msgErrorMatricula", e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/matricula?action=crear&msg=error");
    }
}
   private void exportarExcel(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        List<AnioLectivo> anios = anioLectivoDAO.obtenerAniosDisponibles();
        Workbook workbook = new XSSFWorkbook();

        // === ESTILO PARA TÍTULO ===
        CellStyle styleTitulo = workbook.createCellStyle();
        XSSFFont fontTitulo = (XSSFFont) workbook.createFont();
        fontTitulo.setFontHeight(22);
        fontTitulo.setBold(true);
        fontTitulo.setFontName("Arial");
        styleTitulo.setFont(fontTitulo);
        styleTitulo.setAlignment(HorizontalAlignment.CENTER);

        //  ESTILO PARA ENCABEZADOS DE TABLA 
        CellStyle headerStyle = workbook.createCellStyle();
        XSSFFont fontHeader = (XSSFFont) workbook.createFont();
        fontHeader.setBold(true);
        fontHeader.setFontName("Arial");
        headerStyle.setFont(fontHeader);
        headerStyle.setAlignment(HorizontalAlignment.CENTER);
        headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        headerStyle.setBorderTop(BorderStyle.THIN);
        headerStyle.setBorderBottom(BorderStyle.THIN);
        headerStyle.setBorderLeft(BorderStyle.THIN);
        headerStyle.setBorderRight(BorderStyle.THIN);

        //  ESTILO PARA CELDAS DE DATOS (CON BORDES) 
        CellStyle cellStyle = workbook.createCellStyle();
        cellStyle.setBorderTop(BorderStyle.THIN);
        cellStyle.setBorderBottom(BorderStyle.THIN);
        cellStyle.setBorderLeft(BorderStyle.THIN);
        cellStyle.setBorderRight(BorderStyle.THIN);

        //  ESTILO PARA FECHA 
        CellStyle fechaCellStyle = workbook.createCellStyle();
        fechaCellStyle.cloneStyleFrom(cellStyle);
        short df = workbook.getCreationHelper().createDataFormat().getFormat("dd/MM/yyyy");
        fechaCellStyle.setDataFormat(df);

        for (AnioLectivo anio : anios) {
            List<Matricula> matriculas = matriculaDAO.listarMatriculasParaExportar(anio.getIdAnioLectivo());
            Sheet sheet = workbook.createSheet(anio.getNombre());

            //  TÍTULO 
            Row rowTitulo = sheet.createRow(0);
            Cell cellTitulo = rowTitulo.createCell(0);
            cellTitulo.setCellValue("COLEGIO PERUANO CHINO DIEZ DE OCTUBRE");
            cellTitulo.setCellStyle(styleTitulo);
            sheet.addMergedRegion(new CellRangeAddress(0, 1, 0, 11)); // De columna A a M

            //  Encabezados 
            int filaEncabezado = 3;
            Row header = sheet.createRow(filaEncabezado);
            String[] cols = {
                "Código Matrícula", "Alumno", "DNI Alumno", "Apoderado", "DNI Apoderado",
                "Parentesco", "Nivel", "Grado", "Sección", "Estado", "Observación", "Fecha"
            };
            for (int i = 0; i < cols.length; i++) {
                Cell c = header.createCell(i);
                c.setCellValue(cols[i]);
                c.setCellStyle(headerStyle);
            }

            //  Datos 
            int rowIdx = filaEncabezado + 1;
            for (Matricula m : matriculas) {
                Row row = sheet.createRow(rowIdx++);
                String nombresApo = m.getNombresApoderado() != null ? m.getNombresApoderado() : "";
                String apellidosApo = m.getApellidosApoderado() != null ? m.getApellidosApoderado() : "";
                for (int i = 0; i < cols.length; i++) {
                    Cell cell = row.createCell(i);
                    switch (i) {
                        case 0: cell.setCellValue(m.getCodigoMatricula()); break;
                        case 1: cell.setCellValue(m.getNombres() + " " + m.getApellidos()); break;
                        case 2: cell.setCellValue(m.getDni()); break;
                        case 3: cell.setCellValue(nombresApo + " " + apellidosApo); break;
                        case 4: cell.setCellValue(m.getDniApoderado()); break;
                        case 5: cell.setCellValue(m.getParentesco()); break;
                        case 6: cell.setCellValue(m.getNivel()); break;
                        case 7: cell.setCellValue(m.getGrado()); break;
                        case 8: cell.setCellValue(m.getSeccion()); break;
                        case 9: cell.setCellValue(m.getEstado()); break;
                        case 10: cell.setCellValue(m.getObservacion() != null ? m.getObservacion() : ""); break;
                        case 11:
                            if (m.getFecha() != null) {
                                cell.setCellValue(m.getFecha());
                                cell.setCellStyle(fechaCellStyle);
                            } else {
                                cell.setCellValue("");
                                cell.setCellStyle(cellStyle);
                            }
                            break;
                    }
                    if (i != 11) cell.setCellStyle(cellStyle); // Todos excepto fecha ya tienen el style
                }
            }

            //  Ajuste de columnas 
            for (int i = 0; i < cols.length; i++) {
                sheet.autoSizeColumn(i);
            }
        }

        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"matriculas.xlsx\"");
        workbook.write(response.getOutputStream());
        workbook.close();
    }

    @Override
    public String getServletInfo() {
        return "Servlet para gestión de Matrículas";
    }
}