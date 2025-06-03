
package com.intranet_escolar.controller;

import com.intranet_escolar.dao.DashboardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;



@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {
     private DashboardDAO dashboardDAO;
    
     @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            DashboardDAO dao = new DashboardDAO();

            // 1. Estadísticas principales
            Map<String, Object> estadisticas = dao.obtenerEstadisticas();
            request.setAttribute("totalEstudiantes", estadisticas.get("totalEstudiantes"));
            request.setAttribute("totalDocentes", estadisticas.get("totalDocentes"));
            request.setAttribute("totalApoderados", estadisticas.get("totalApoderados"));
            request.setAttribute("seccionesActivas", estadisticas.get("seccionesActivas"));

            // 2. Distribución de matrícula por nivel
            Map<String, Integer> niveles = dao.obtenerMatriculaPorNivel();
            request.setAttribute("matriculaInicial", niveles.get("inicial"));
            request.setAttribute("matriculaPrimaria", niveles.get("primaria"));
            request.setAttribute("matriculaSecundaria", niveles.get("secundaria"));


            // 3. Resumen de roles
            List<Map<String, Object>> resumen = dao.obtenerResumenRoles();
            request.setAttribute("resumenRoles", resumen);

            // 4. Métricas del sistema
            Map<String, Integer> metricas = dao.obtenerMetricasSistema();
            request.setAttribute("metricas", metricas);

            // 5. Fecha actual para bienvenida
            request.setAttribute("now", new java.util.Date());

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar el dashboard.");
        }

        request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
    }

    
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
