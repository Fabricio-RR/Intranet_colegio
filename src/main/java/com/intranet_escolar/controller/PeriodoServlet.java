package com.intranet_escolar.controller;

import com.intranet_escolar.dao.PeriodoDAO;
import com.intranet_escolar.dao.AnioLectivoDAO;
import com.intranet_escolar.model.entity.Periodo;
import com.intranet_escolar.model.entity.AnioLectivo;
import com.google.common.base.Strings;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet("/periodos")
public class PeriodoServlet extends HttpServlet {
    private final PeriodoDAO periodoDAO = new PeriodoDAO();
    private final AnioLectivoDAO anioLectivoDAO = new AnioLectivoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = Strings.nullToEmpty(request.getParameter("action")).trim();
        String idAnioLectivoParam = Strings.nullToEmpty(request.getParameter("idAnioLectivo")).trim();
        int idAnioLectivo;
        if (!Strings.isNullOrEmpty(idAnioLectivoParam)) {
            idAnioLectivo = Integer.parseInt(idAnioLectivoParam);
        } else {
            idAnioLectivo = anioLectivoDAO.obtenerAnioActivo();
        }

        // Listar años lectivos para el combo y la tabla
        List<AnioLectivo> anios = anioLectivoDAO.listarTodos();
        request.setAttribute("anios", anios);
        request.setAttribute("anioActual", idAnioLectivo);

        // Listar periodos del año lectivo seleccionado
        List<Periodo> periodos = periodoDAO.listarPorAnioLectivo(idAnioLectivo);
        request.setAttribute("periodos", periodos);

        // Acciones: cerrar o reactivar periodo
        if ("cerrar".equals(action) || "habilitar".equals(action)) {
            String idPeriodoStr = Strings.nullToEmpty(request.getParameter("id")).trim();
            int idPeriodo = 0;
            if (!Strings.isNullOrEmpty(idPeriodoStr)) {
                idPeriodo = Integer.parseInt(idPeriodoStr);
            }
            String nuevoEstado = "cerrar".equals(action) ? "cerrado" : "habilitado";
            boolean ok = periodoDAO.cambiarEstado(idPeriodo, nuevoEstado);
            response.sendRedirect(request.getContextPath() + "/periodos?idAnioLectivo=" + idAnioLectivo +
                    "&success=1&op=" + action + (ok ? "" : "&error=Ocurrió un error"));
            return;
        }

        // Renderizar la vista JSP
        request.getRequestDispatcher("/views/academico/periodos.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = Strings.nullToEmpty(request.getParameter("action")).trim();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        boolean ok = false;

        String idAnioLectivoParam = Strings.nullToEmpty(request.getParameter("idAnioLectivo")).trim();
        int idAnioLectivo = 0;
        if (!Strings.isNullOrEmpty(idAnioLectivoParam)) {
            idAnioLectivo = Integer.parseInt(idAnioLectivoParam);
        }

        try {
            // Crear periodo académico
            if ("crear".equals(action)) {
                Periodo p = new Periodo();
                p.setIdAnioLectivo(idAnioLectivo);
                p.setBimestre(Strings.nullToEmpty(request.getParameter("bimestre")).trim());
                p.setMes(Strings.nullToEmpty(request.getParameter("mes")).trim());
                p.setTipo(Strings.nullToEmpty(request.getParameter("tipo")).trim());
                p.setFecInicio(sdf.parse(Strings.nullToEmpty(request.getParameter("fecInicio")).trim()));
                p.setFecFin(sdf.parse(Strings.nullToEmpty(request.getParameter("fecFin")).trim()));
                p.setFecCierre(sdf.parse(Strings.nullToEmpty(request.getParameter("fecCierre")).trim()));
                p.setEstado("habilitado");
                ok = periodoDAO.crear(p);
                response.sendRedirect(request.getContextPath() + "/periodos?idAnioLectivo=" + idAnioLectivo +
                        "&success=" + (ok ? "1" : "0") + "&op=add");
                return;

            // Editar periodo académico
            } else if ("editar".equals(action)) {
                String idPeriodoStr = Strings.nullToEmpty(request.getParameter("idPeriodo")).trim();
                int idPeriodo = 0;
                if (!Strings.isNullOrEmpty(idPeriodoStr)) {
                    idPeriodo = Integer.parseInt(idPeriodoStr);
                }
                Periodo p = new Periodo();
                p.setIdPeriodo(idPeriodo);
                p.setIdAnioLectivo(idAnioLectivo);
                p.setBimestre(Strings.nullToEmpty(request.getParameter("bimestre")).trim());
                p.setMes(Strings.nullToEmpty(request.getParameter("mes")).trim());
                p.setTipo(Strings.nullToEmpty(request.getParameter("tipo")).trim());
                p.setFecInicio(sdf.parse(Strings.nullToEmpty(request.getParameter("fecInicio")).trim()));
                p.setFecFin(sdf.parse(Strings.nullToEmpty(request.getParameter("fecFin")).trim()));
                p.setFecCierre(sdf.parse(Strings.nullToEmpty(request.getParameter("fecCierre")).trim()));
                p.setEstado("habilitado");
                ok = periodoDAO.editar(p);
                response.sendRedirect(request.getContextPath() + "/periodos?idAnioLectivo=" + idAnioLectivo +
                        "&success=" + (ok ? "1" : "0") + "&op=edit");
                return;
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/periodos?idAnioLectivo=" + idAnioLectivo + "&error=Datos inválidos");
            return;
        }
        // Si no fue ninguna acción válida
        response.sendRedirect(request.getContextPath() + "/periodos?idAnioLectivo=" + idAnioLectivo);
    }
}
