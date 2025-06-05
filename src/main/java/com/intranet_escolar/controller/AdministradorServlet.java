package com.intranet_escolar.controller;

import com.intranet_escolar.dao.DashboardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard/administrador"})
public class AdministradorServlet extends HttpServlet {

    private DashboardDAO dashboardDAO;

    @Override
    public void init() throws ServletException {
        try {
            dashboardDAO = new DashboardDAO();
        } catch (SQLException e) {
            throw new ServletException("Error al inicializar DashboardDAO", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 1. Estadísticas principales
            Map<String, Object> estadisticas = dashboardDAO.obtenerEstadisticas();
            request.setAttribute("totalEstudiantes", estadisticas.getOrDefault("totalEstudiantes", 0));
            request.setAttribute("totalDocentes", estadisticas.getOrDefault("totalDocentes", 0));
            request.setAttribute("totalApoderados", estadisticas.getOrDefault("totalApoderados", 0));
            request.setAttribute("seccionesActivas", estadisticas.getOrDefault("seccionesActivas", 0));

            // 2. Matrícula por nivel
            Map<String, Integer> niveles = dashboardDAO.obtenerMatriculaPorNivel();
            request.setAttribute("matriculaInicial", niveles.getOrDefault("inicial", 0));
            request.setAttribute("matriculaPrimaria", niveles.getOrDefault("primaria", 0));
            request.setAttribute("matriculaSecundaria", niveles.getOrDefault("secundaria", 0));

            // 3. Resumen de roles
            List<Map<String, Object>> resumen = dashboardDAO.obtenerResumenRoles();
            request.setAttribute("resumenRoles", resumen);

            // 4. Métricas generales
            Map<String, Integer> metricas = dashboardDAO.obtenerMetricasSistema();
            request.setAttribute("metricas", metricas);

            // 5. Matrícula por grado
            Map<String, Integer> grados = dashboardDAO.obtenerMatriculaPorGrado();
            request.setAttribute("matriculaPorGrado", grados);

            // 6. Tendencia de matrículas por mes
            Map<String, Integer> tendencia = dashboardDAO.obtenerTendenciaMatricula();
            request.setAttribute("tendenciaMatricula", tendencia);

            // 7. Fecha actual para bienvenida
            request.setAttribute("now", new Date());

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar el dashboard.");
        }

        request.getRequestDispatcher("/views/dashboard/administrador.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet para cargar el dashboard del administrador";
    }
}
