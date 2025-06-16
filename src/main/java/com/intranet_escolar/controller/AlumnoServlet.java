
package com.intranet_escolar.controller;

import com.intranet_escolar.model.DTO.ClaseDTO;
import com.intranet_escolar.model.DTO.ExamenDTO;
import com.intranet_escolar.model.DTO.NotaDTO;
import com.intranet_escolar.model.entity.Usuario;
import com.intranet_escolar.service.AlumnoService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;


@WebServlet(name = "AlumnoServlet", urlPatterns = {"/dashboard/alumno"})
public class AlumnoServlet extends HttpServlet {
    private AlumnoService service;

    @Override
    public void init() throws ServletException {
        try {
            this.service = new AlumnoService();
        } catch (SQLException ex) {
            Logger.getLogger(AlumnoServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 1. Obtener usuario de sesión
            Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
            int idAlumno = usuario.getIdUsuario();
            
            // 2. Resumen académico (promedio, asistencia, conducta, etc.)
            var resumen = service.obtenerResumenAcademico(idAlumno);
            request.setAttribute("promedioGeneral", resumen.getPromedioGeneral());
            request.setAttribute("cambioPromedio", resumen.getCambioPromedio()); // Calcula en Java
            request.setAttribute("porcentajeAsistencia", resumen.getPorcentajeAsistencia());
            request.setAttribute("diasAsistidos", resumen.getDiasAsistidos());
            request.setAttribute("puntajeConducta", resumen.getPuntajeConducta());
            request.setAttribute("meritos", resumen.getMeritos());
            request.setAttribute("totalCursos", resumen.getTotalCursos());
            request.setAttribute("cursosAprobados", resumen.getCursosAprobados());
            
            // 3. Gráfico de notas por curso 
            String nombresCursosStr = service.obtenerNombresCursos(idAlumno);
            String notasCursosStr = service.obtenerNotasPorCurso(idAlumno);
            request.setAttribute("nombresCursos", nombresCursosStr);
            request.setAttribute("notasCursos", notasCursosStr);
            
            // 4. Horario de hoy
            List<ClaseDTO> horarioHoy = service.obtenerHorarioHoy(idAlumno);
            request.setAttribute("horarioHoy", horarioHoy);
            
            // 5. Últimas calificaciones
            List<NotaDTO> ultimasCalificaciones = service.obtenerUltimasCalificaciones(idAlumno);
            request.setAttribute("ultimasCalificaciones", ultimasCalificaciones);
            
            // 6. Próximos exámenes
            List<ExamenDTO> proximosExamenes = service.obtenerProximosExamenes(idAlumno);
            request.setAttribute("proximosExamenes", proximosExamenes);
            
            // 7. Fecha actual
            request.setAttribute("now", new Date());
            
           
            System.out.println("DEBUG usuario: " + usuario);
            if (usuario != null && usuario.getAlumno() != null) {
                System.out.println("Grado: " + usuario.getAlumno().getGrado());
                System.out.println("Seccion: " + usuario.getAlumno().getSeccion());
                System.out.println("Nivel: " + usuario.getAlumno().getNivel());
            } else {
    System.out.println("DEBUG Alumno es null o usuario es null");
}

            
            // 8. Forward a la vista
            request.getRequestDispatcher("/views/dashboard/alumno.jsp").forward(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(AlumnoServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
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
