package com.intranet_escolar.controller;

import com.intranet_escolar.dao.AnioLectivoDAO;
import com.intranet_escolar.dao.ComunicadoDAO;
import com.intranet_escolar.model.entity.AnioLectivo;
import com.intranet_escolar.model.entity.Comunicado;
import com.intranet_escolar.model.entity.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.text.*;
import java.util.*;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,  // 1MB
    maxFileSize = 5 * 1024 * 1024,    // 5MB
    maxRequestSize = 10 * 1024 * 1024 // 10MB
)
@WebServlet(name = "ComunicadoServlet", urlPatterns = {"/comunicado"})
public class ComunicadoServlet extends HttpServlet {
    private final ComunicadoDAO comunicadoDAO = new ComunicadoDAO();
    private final AnioLectivoDAO anioLectivoDAO = new AnioLectivoDAO();
    private final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idAnioParam = request.getParameter("idAnioLectivo");
        Integer idAnioLectivo = (idAnioParam != null && !idAnioParam.isEmpty())
                ? Integer.parseInt(idAnioParam)
                : anioLectivoDAO.obtenerAnioActivo();

        switch (action == null ? "listar" : action) {
            case "crear" -> {
                request.setAttribute("idAnioLectivo", idAnioLectivo);
                request.getRequestDispatcher("/views/comunicado/crear.jsp").forward(request, response);
            }
            case "editar" -> {
                int id = Integer.parseInt(request.getParameter("id"));
                Comunicado comunicado = comunicadoDAO.obtenerPorId(id);
                request.setAttribute("comunicado", comunicado);
                request.getRequestDispatcher("/views/comunicado/editar.jsp").forward(request, response);
            }
            case "ver" -> {
                int id = Integer.parseInt(request.getParameter("id"));
                Comunicado comunicado = comunicadoDAO.obtenerPorId(id);
                request.setAttribute("comunicado", comunicado);
                request.getRequestDispatcher("/views/comunicado/ver.jsp").forward(request, response);
            }
            case "desactivar" -> {
                int id = Integer.parseInt(request.getParameter("id"));
                comunicadoDAO.desactivar(id);
                response.sendRedirect("comunicado?idAnioLectivo=" + idAnioLectivo + "&success=1&op=deactivate");
            }
            default -> {
                List<AnioLectivo> aniosLectivos = anioLectivoDAO.obtenerAniosDisponibles();
                List<Comunicado> comunicados = comunicadoDAO.listarPorAnio(idAnioLectivo);
                request.setAttribute("comunicados", comunicados);
                request.setAttribute("aniosLectivos", aniosLectivos);
                request.setAttribute("idAnioLectivo", idAnioLectivo);
                request.getRequestDispatcher("/views/comunicado/comunicados.jsp").forward(request, response);
            }
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        if ("guardar".equals(action) || "editarGuardar".equals(action)) {
            Comunicado comunicado;
            boolean esEdicion = "editarGuardar".equals(action);

            if (esEdicion) {
                int id = Integer.parseInt(request.getParameter("id"));
                comunicado = comunicadoDAO.obtenerPorId(id);
            } else {
                comunicado = new Comunicado();
                comunicado.setIdUsuario(usuario.getIdUsuario());
                comunicado.setEstado("programada");
            }

            comunicado.setTitulo(request.getParameter("titulo"));
            comunicado.setContenido(request.getParameter("contenido"));
            comunicado.setCategoria(request.getParameter("categoria"));
            comunicado.setDestinatario(request.getParameter("destinatario"));
            comunicado.setNotificarCorreo("1".equals(request.getParameter("notificar_correo")));

            // Validación de fechas
            try {
                Date fechaInicio = sdf.parse(request.getParameter("fec_inicio"));
                Date fechaFin = sdf.parse(request.getParameter("fec_fin"));

                if (fechaFin.before(fechaInicio)) {
                    if (!esEdicion) {
                        request.setAttribute("errorMsg", "La fecha de fin no puede ser anterior a la fecha de inicio.");
                        request.setAttribute("idAnioLectivo", request.getParameter("idAnioLectivo"));
                        request.setAttribute("comunicado", comunicado);
                        request.getRequestDispatcher("/views/comunicado/crear.jsp").forward(request, response);
                    } else {
                        String msg = URLEncoder.encode("La fecha de fin no puede ser anterior a la fecha de inicio.", "UTF-8");
                        response.sendRedirect("comunicado?idAnioLectivo=" + request.getParameter("idAnioLectivo") + "&error=" + msg);
                    }
                    return;
                }

                comunicado.setFecInicio(fechaInicio);
                comunicado.setFecFin(fechaFin);
            } catch (ParseException e) {
                if (!esEdicion) {
                    request.setAttribute("errorMsg", "Formato de fecha inválido.");
                    request.setAttribute("idAnioLectivo", request.getParameter("idAnioLectivo"));
                    request.setAttribute("comunicado", comunicado);
                    request.getRequestDispatcher("/views/comunicado/crear.jsp").forward(request, response);
                } else {
                    String msg = URLEncoder.encode("Formato de fecha inválido", "UTF-8");
                    response.sendRedirect("comunicado?idAnioLectivo=" + request.getParameter("idAnioLectivo") + "&error=" + msg);
                }
                return;
            }

            // Manejo de archivo
            Part archivoPart = request.getPart("archivo");
            String nombreArchivo = archivoPart != null ? archivoPart.getSubmittedFileName() : null;
            boolean eliminarArchivo = "1".equals(request.getParameter("eliminar_archivo"));

            String rutaSubida = System.getProperty("user.home") + File.separator + "uploads";
            File carpeta = new File(rutaSubida);
            if (!carpeta.exists()) carpeta.mkdirs();

            if (nombreArchivo != null && !nombreArchivo.isBlank()) {
                String contentType = archivoPart.getContentType();
                if (!contentType.equals("application/pdf") &&
                    !contentType.equals("image/jpeg") &&
                    !contentType.equals("image/png")) {

                    if (!esEdicion) {
                        request.setAttribute("errorMsg", "Formato de archivo no permitido. Solo PDF, JPG o PNG.");
                        request.setAttribute("idAnioLectivo", request.getParameter("idAnioLectivo"));
                        request.setAttribute("comunicado", comunicado);
                        request.getRequestDispatcher("/views/comunicado/crear.jsp").forward(request, response);
                    } else {
                        String msg = URLEncoder.encode("Formato de archivo no permitido", "UTF-8");
                        response.sendRedirect("comunicado?idAnioLectivo=" + request.getParameter("idAnioLectivo") + "&error=" + msg);
                    }
                    return;
                }

                if (esEdicion && comunicado.getArchivo() != null) {
                    File anterior = new File(rutaSubida + File.separator + comunicado.getArchivo());
                    if (anterior.exists()) anterior.delete();
                }

                archivoPart.write(rutaSubida + File.separator + nombreArchivo);
                comunicado.setArchivo(nombreArchivo);
            } else if (eliminarArchivo) {
                if (comunicado.getArchivo() != null) {
                    File anterior = new File(rutaSubida + File.separator + comunicado.getArchivo());
                    if (anterior.exists()) anterior.delete();
                }
                comunicado.setArchivo(null);
            }

            // Guardar o actualizar en base de datos
            if (!esEdicion) {
                comunicado.setIdAnioLectivo(Integer.parseInt(request.getParameter("idAnioLectivo")));
                comunicadoDAO.guardar(comunicado);
                response.sendRedirect("comunicado?idAnioLectivo=" + comunicado.getIdAnioLectivo() + "&success=1&op=add");
            } else {
                comunicado.setEstado(request.getParameter("estado"));
                comunicadoDAO.actualizar(comunicado);
                response.sendRedirect("comunicado?idAnioLectivo=" + comunicado.getIdAnioLectivo() + "&success=1&op=edit");
            }
        }
    }
    @Override
    public String getServletInfo() {
        return "Gestión de comunicados escolares";
    }
}
