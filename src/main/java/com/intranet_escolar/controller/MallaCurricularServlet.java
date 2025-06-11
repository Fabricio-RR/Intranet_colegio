/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.intranet_escolar.controller;

import com.intranet_escolar.dao.MallaCurricularDAO;
import com.intranet_escolar.model.entity.MallaCurricular;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;


@WebServlet(name = "MallaCurricularServlet", urlPatterns = {"/malla"})
public class MallaCurricularServlet extends HttpServlet {
    
    private final MallaCurricularDAO mallaDAO = new MallaCurricularDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         String action = request.getParameter("action");
          if (action == null) action = "ver";

        switch (action) {
            case "ver":
                mostrarResumenPorNivel(request, response);
                break;

            case "detallePorNivel":
                verDetallePorNivel(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/dashboard");
         }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       
    }
    /*
    private void mostrarResumenPorNivel(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int anioActual = mallaDAO.obtenerAnioActivo();
        List<Integer> anios = mallaDAO.obtenerAniosDisponibles();
        List<MallaCurricular> resumen = mallaDAO.listarResumenPorNivel(anioActual);

        request.setAttribute("anioActual", anioActual);
        request.setAttribute("anios", anios);
        request.setAttribute("resumenNiveles", resumen);
        request.getRequestDispatcher("/views/malla/malla.jsp").forward(request, response);
    }*/

    private void verDetallePorNivel(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int idNivel = Integer.parseInt(request.getParameter("idNivel"));
        int anio = Integer.parseInt(request.getParameter("anio"));
        List<MallaCurricular> detalle = mallaDAO.listarDetallePorNivel(idNivel, anio);

        request.setAttribute("detalleMalla", detalle);
        request.getRequestDispatcher("/views/malla/parcial/detalle_por_nivel.jsp").forward(request, response);
    }
    
    private void mostrarResumenPorNivel(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    int anioActual = mallaDAO.obtenerAnioActivo();
    System.out.println("🔍 Año activo detectado: " + anioActual);

    List<Integer> anios = mallaDAO.obtenerAniosDisponibles();
    List<MallaCurricular> resumen = mallaDAO.listarResumenPorNivel(anioActual);

    System.out.println("📦 Resumen niveles cargados: " + resumen.size());

    request.setAttribute("anioActual", anioActual);
    request.setAttribute("anios", anios);
    request.setAttribute("resumenNiveles", resumen);
    request.getRequestDispatcher("/views/malla/malla.jsp").forward(request, response);
}


    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
