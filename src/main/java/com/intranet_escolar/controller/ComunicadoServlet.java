package com.intranet_escolar.controller;

import com.intranet_escolar.dao.AnioLectivoDAO;
import com.intranet_escolar.dao.ComunicadoDAO;
import com.intranet_escolar.model.entity.AnioLectivo;
import com.intranet_escolar.model.entity.Comunicado;
import com.intranet_escolar.model.entity.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.*;


@WebServlet(name = "ComunicadoServlet", urlPatterns = {"/comunicado"})
public class ComunicadoServlet extends HttpServlet {
    private final ComunicadoDAO comunicadoDAO = new ComunicadoDAO();
    private final AnioLectivoDAO anioLectivoDAO = new AnioLectivoDAO();

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
                request.getRequestDispatcher("/views/comunicado/crear_comunicado.jsp").forward(request, response);
            }
            case "editar" -> {
                int id = Integer.parseInt(request.getParameter("id"));
                Comunicado comunicado = comunicadoDAO.obtenerPorId(id);
                request.setAttribute("comunicado", comunicado);
                request.setAttribute("idAnioLectivo", comunicado.getIdAnioLectivo());
                request.getRequestDispatcher("/views/comunicado/editar_comunicado.jsp").forward(request, response);
            }
            case "ver" -> {
                int id = Integer.parseInt(request.getParameter("id"));
                Comunicado comunicado = comunicadoDAO.obtenerPorId(id);
                request.setAttribute("comunicado", comunicado);
                request.getRequestDispatcher("/views/comunicado/ver_comunicado.jsp").forward(request, response);
            }
            case "eliminar" -> {
                int id = Integer.parseInt(request.getParameter("id"));
                comunicadoDAO.eliminar(id);
                response.sendRedirect("comunicado?idAnioLectivo=" + idAnioLectivo + "&success=1&op=delete");
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

        if ("guardar".equals(action)) {
            Comunicado comunicado = new Comunicado();
            comunicado.setIdUsuario(usuario.getIdUsuario());
            comunicado.setTitulo(request.getParameter("titulo"));
            comunicado.setContenido(request.getParameter("contenido"));
            comunicado.setCategoria(request.getParameter("categoria"));
            comunicado.setDestinatario(request.getParameter("destinatario"));
            comunicado.setFecInicio(request.getParameter("fec_inicio"));
            comunicado.setFecFin(request.getParameter("fec_fin"));
            comunicado.setArchivo(request.getParameter("archivo"));
            comunicado.setEstado("programada");
            comunicado.setNotificarCorreo("1".equals(request.getParameter("notificar_correo")));
            comunicado.setIdAnioLectivo(Integer.parseInt(request.getParameter("idAnioLectivo")));

            comunicadoDAO.guardar(comunicado);

            response.sendRedirect("comunicado?idAnioLectivo=" + comunicado.getIdAnioLectivo() + "&success=1&op=add");
        }

        if ("actualizar".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Comunicado comunicado = comunicadoDAO.obtenerPorId(id);

            comunicado.setTitulo(request.getParameter("titulo"));
            comunicado.setContenido(request.getParameter("contenido"));
            comunicado.setCategoria(request.getParameter("categoria"));
            comunicado.setDestinatario(request.getParameter("destinatario"));
            comunicado.setFecInicio(request.getParameter("fec_inicio"));
            comunicado.setFecFin(request.getParameter("fec_fin"));
            comunicado.setArchivo(request.getParameter("archivo"));
            comunicado.setNotificarCorreo("1".equals(request.getParameter("notificar_correo")));

            comunicadoDAO.actualizar(comunicado);
            response.sendRedirect("comunicado?idAnioLectivo=" + comunicado.getIdAnioLectivo() + "&success=1&op=edit");
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}

