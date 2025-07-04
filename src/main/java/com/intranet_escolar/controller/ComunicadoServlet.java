package com.intranet_escolar.controller;

import com.intranet_escolar.dao.AnioLectivoDAO;
import com.intranet_escolar.dao.AperturaSeccionDAO;
import com.intranet_escolar.dao.ComunicadoDAO;
import com.intranet_escolar.model.DTO.AperturaSeccionDTO;
import com.intranet_escolar.model.entity.AnioLectivo;
import com.intranet_escolar.model.entity.Comunicado;
import com.intranet_escolar.model.entity.Usuario;
import com.intranet_escolar.util.EmailUtil;
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
    private final AperturaSeccionDAO aperturaSeccionDAO = new AperturaSeccionDAO();
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
                List<AperturaSeccionDTO> seccionesActivas = aperturaSeccionDAO.obtenerAperturasSeccionPorAnio(idAnioLectivo);
                request.setAttribute("idAnioLectivo", idAnioLectivo);
                request.setAttribute("seccionesActivas", seccionesActivas);
                request.getRequestDispatcher("/views/comunicado/crear.jsp").forward(request, response);
            }
            case "editar" -> {
                int id = Integer.parseInt(request.getParameter("id"));
                Comunicado comunicado = comunicadoDAO.obtenerPorId(id);
                List<AperturaSeccionDTO> seccionesActivas = aperturaSeccionDAO.obtenerAperturasSeccionPorAnio(comunicado.getIdAnioLectivo());
                request.setAttribute("comunicado", comunicado);
                request.setAttribute("seccionesActivas", seccionesActivas);
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
                List<Comunicado> comunicados = comunicadoDAO.listarPorAnio(idAnioLectivo, true);
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

            // Sección y destinatario si aplica
            if ("Seccion".equalsIgnoreCase(comunicado.getDestinatario())) {
                comunicado.setDestinatarioSeccion(request.getParameter("destinatario_seccion"));
                String apertura = request.getParameter("idAperturaSeccion");
                if (apertura != null && !apertura.isBlank()) {
                    comunicado.setIdAperturaSeccion(Integer.parseInt(apertura));
                }
            } else {
                comunicado.setDestinatarioSeccion(null);
                comunicado.setIdAperturaSeccion(null);
            }

            // Validación de fechas
            try {
                Date fechaInicio = sdf.parse(request.getParameter("fec_inicio"));
                Date fechaFin = sdf.parse(request.getParameter("fec_fin"));
                if (fechaFin.before(fechaInicio)) {
                    String mensaje = URLEncoder.encode("La fecha de fin no puede ser anterior a la de inicio.", "UTF-8");
                    if (!esEdicion) {
                        request.setAttribute("errorMsg", mensaje);
                        request.setAttribute("comunicado", comunicado);
                        request.setAttribute("idAnioLectivo", request.getParameter("idAnioLectivo"));
                        request.setAttribute("seccionesActivas", aperturaSeccionDAO.obtenerAperturasSeccionPorAnio(
                                Integer.parseInt(request.getParameter("idAnioLectivo"))));
                        request.getRequestDispatcher("/views/comunicado/crear.jsp").forward(request, response);
                    } else {
                        response.sendRedirect("comunicado?idAnioLectivo=" + request.getParameter("idAnioLectivo") + "&error=" + mensaje);
                    }
                    return;
                }
                comunicado.setFecInicio(fechaInicio);
                comunicado.setFecFin(fechaFin);
            } catch (ParseException e) {
                String mensaje = URLEncoder.encode("Formato de fecha inválido", "UTF-8");
                if (!esEdicion) {
                    request.setAttribute("errorMsg", mensaje);
                    request.setAttribute("comunicado", comunicado);
                    request.setAttribute("idAnioLectivo", request.getParameter("idAnioLectivo"));
                    request.setAttribute("seccionesActivas", aperturaSeccionDAO.obtenerAperturasSeccionPorAnio(
                            Integer.parseInt(request.getParameter("idAnioLectivo"))));
                    request.getRequestDispatcher("/views/comunicado/crear.jsp").forward(request, response);
                } else {
                    response.sendRedirect("comunicado?idAnioLectivo=" + request.getParameter("idAnioLectivo") + "&error=" + mensaje);
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
                String tipo = archivoPart.getContentType();
                if (!tipo.equals("application/pdf") && !tipo.equals("image/jpeg") && !tipo.equals("image/png")) {
                    String mensaje = URLEncoder.encode("Formato no permitido. Solo PDF, JPG, PNG.", "UTF-8");
                    if (!esEdicion) {
                        request.setAttribute("errorMsg", mensaje);
                        request.setAttribute("comunicado", comunicado);
                        request.setAttribute("idAnioLectivo", request.getParameter("idAnioLectivo"));
                        request.setAttribute("seccionesActivas", aperturaSeccionDAO.obtenerAperturasSeccionPorAnio(
                                Integer.parseInt(request.getParameter("idAnioLectivo"))));
                        request.getRequestDispatcher("/views/comunicado/crear.jsp").forward(request, response);
                    } else {
                        response.sendRedirect("comunicado?idAnioLectivo=" + request.getParameter("idAnioLectivo") + "&error=" + mensaje);
                    }
                    return;
                }

                if (esEdicion && comunicado.getArchivo() != null) {
                    File anterior = new File(rutaSubida + File.separator + comunicado.getArchivo());
                    if (anterior.exists()) anterior.delete();
                }

                archivoPart.write(rutaSubida + File.separator + nombreArchivo);
                comunicado.setArchivo(nombreArchivo);
            } else if (eliminarArchivo && comunicado.getArchivo() != null) {
                File anterior = new File(rutaSubida + File.separator + comunicado.getArchivo());
                if (anterior.exists()) anterior.delete();
                comunicado.setArchivo(null);
            }

            // Guardar o actualizar
            if (!esEdicion) {
                comunicado.setIdAnioLectivo(Integer.parseInt(request.getParameter("idAnioLectivo")));
                boolean guardado = comunicadoDAO.guardar(comunicado);

                int idComunicado = 0;
                if (guardado) {
                    idComunicado = comunicadoDAO.obtenerIdUltimoComunicadoPorUsuario(comunicado.getIdUsuario());
                }

                if (comunicado.isNotificarCorreo() && idComunicado > 0) {
                    List<String> correos = comunicadoDAO.obtenerCorreosDestinatarios(idComunicado);
                    String nombreRemitente = usuario.getNombres() + " " + usuario.getApellidos();
                    for (String correo : correos) {
                        Usuario usuarioDest = comunicadoDAO.obtenerUsuarioPorCorreo(correo); // implementa este método
                        String nombreDest = (usuarioDest != null)
                            ? usuarioDest.getNombres() + " " + usuarioDest.getApellidos()
                            : correo;
                        try {
                            EmailUtil.enviarNotificacionComunicadoPersonal(
                                correo, nombreDest, comunicado, nombreRemitente
                            );
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                }
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
