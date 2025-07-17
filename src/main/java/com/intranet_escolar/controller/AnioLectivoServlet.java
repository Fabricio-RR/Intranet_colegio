package com.intranet_escolar.controller;

import com.intranet_escolar.dao.AnioLectivoDAO;
import com.intranet_escolar.model.entity.AnioLectivo;
import com.google.common.base.Strings;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/anios")
public class AnioLectivoServlet extends HttpServlet {
    private final AnioLectivoDAO anioDAO = new AnioLectivoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<AnioLectivo> lista = anioDAO.obtenerAniosDisponibles();
        req.setAttribute("anios", lista);
        req.getRequestDispatcher("/views/academico/anio.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = Strings.nullToEmpty(req.getParameter("action"));
        String nombre = Strings.nullToEmpty(req.getParameter("nombre")).trim();
        String fecInicio = Strings.nullToEmpty(req.getParameter("fecInicio")).trim();
        String fecFin = Strings.nullToEmpty(req.getParameter("fecFin")).trim();
        String idAnioStr = Strings.nullToEmpty(req.getParameter("idAnioLectivo")).trim();
        String estado = Strings.nullToEmpty(req.getParameter("estado")).trim();
        boolean ok = false;
        String errorMsg = null;
        String op = "";

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        try {
            if ("crear".equals(action)) {
                op = "add";
                // Validar campos obligatorios
                if (Strings.isNullOrEmpty(nombre) || Strings.isNullOrEmpty(fecInicio) || Strings.isNullOrEmpty(fecFin)) {
                    throw new IllegalArgumentException("Todos los campos son obligatorios.");
                }
                // Validar fechas
                Date inicio = sdf.parse(fecInicio);
                Date fin = sdf.parse(fecFin);
                if (!inicio.before(fin)) {
                    throw new IllegalArgumentException("La fecha de inicio debe ser anterior a la fecha de fin.");
                }
                AnioLectivo a = new AnioLectivo();
                a.setNombre(nombre);
                a.setFecInicio(inicio);
                a.setFecFin(fin);
                a.setEstado("preparacion");
                ok = anioDAO.crear(a);

            } else if ("editar".equals(action)) {
                op = "edit";
                if (Strings.isNullOrEmpty(idAnioStr)) throw new IllegalArgumentException("ID requerido.");
                Date inicio = sdf.parse(fecInicio);
                Date fin = sdf.parse(fecFin);
                if (!inicio.before(fin)) {
                    throw new IllegalArgumentException("La fecha de inicio debe ser anterior a la fecha de fin.");
                }
                AnioLectivo a = new AnioLectivo();
                a.setIdAnioLectivo(Integer.parseInt(idAnioStr));
                a.setNombre(nombre);
                a.setFecInicio(inicio);
                a.setFecFin(fin);
                a.setEstado(estado);
                ok = anioDAO.editar(a);

            } else if ("cerrar".equals(action) && !Strings.isNullOrEmpty(idAnioStr)) {
                op = "cerrar";
                ok = anioDAO.cambiarEstado(Integer.parseInt(idAnioStr), "cerrado");

            } else if ("reactivar".equals(action) && !Strings.isNullOrEmpty(idAnioStr)) {
                op = "reactivar";
                ok = anioDAO.cambiarEstado(Integer.parseInt(idAnioStr), "activo");
            }

        } catch (IllegalArgumentException e) {
            errorMsg = e.getMessage();
        } catch (Exception e) {
            errorMsg = "Ocurrió un error inesperado.";
            e.printStackTrace();
        }

        if (ok) {
            resp.sendRedirect(req.getContextPath() + "/anios?success=1&op=" + op);
        } else {
            String url = req.getContextPath() + "/anios?success=0";
            if (op != null && !op.isEmpty()) url += "&op=" + op;
            if (errorMsg != null) url += "&error=" + java.net.URLEncoder.encode(errorMsg, "UTF-8");
            resp.sendRedirect(url);
        }
    }
}
