package com.intranet_escolar.service;

import com.intranet_escolar.model.entity.MenuItem;
import java.util.*;

public class MenuService {

    public static List<MenuItem> generarMenuPorRoles(List<String> nombresRoles) {
        Set<String> permisosGenerales = new HashSet<>();
        for (String nombre : nombresRoles) {
            permisosGenerales.add(nombre.toLowerCase());
        }

        List<MenuItem> menu = new ArrayList<>();

        if (permisosGenerales.contains("administrador")) {

            menu.add(new MenuItem("Usuarios", "/usuarios", "fas fa-users"));
            menu.add(new MenuItem("Matrícula", "/matricula", "fas fa-user-graduate"));
            menu.add(new MenuItem("Malla Curricular", "/malla-curricular", "fas fa-chalkboard-teacher"));
            // Submenú de Configuración Académica
            List<MenuItem> submenuConfigAcademica = Arrays.asList(
                new MenuItem("Cursos", "/cursos", "fas fa-book"),
                new MenuItem("Apertura de Sección", "/apertura-seccion", "fas fa-door-open"),
                new MenuItem("Años Lectivos", "/anios", "fas fa-calendar"),
                new MenuItem("Periodos Académicos", "/periodos", "fas fa-calendar-week"),
                new MenuItem("Criterio", "/criterio", "fas fa-list-check")
            );
            menu.add(new MenuItem("Configuración Académica", null, "fas fa-gears", submenuConfigAcademica));
            menu.add(new MenuItem("Comunicados", "/comunicado", "fas fa-bullhorn"));
            menu.add(new MenuItem("Reportes", "/reportes", "fas fa-file-alt"));
        }

        if (permisosGenerales.contains("docente")) {
            menu.add(new MenuItem("Notas", "/notas", "fas fa-clipboard-list me-2"));
            menu.add(new MenuItem("Asistencia", "/views/asistencia.jsp", "fas fa-calendar-check"));
            menu.add(new MenuItem("Comunicados", "/views/publicaciones.jsp", "fas fa-bullhorn"));
            menu.add(new MenuItem("Mi horario", "/views/horario.jsp", "fas fa-clock"));
        }

        if (permisosGenerales.contains("alumno")) {
            menu.add(new MenuItem("Mis calificaciones", "/views/notas/mis_notas.jsp", "fas fa-graduation-cap"));
            menu.add(new MenuItem("Asistencia", "/views/asistencia/mis_asistencias.jsp", "fas fa-calendar-alt"));
            menu.add(new MenuItem("Publicaciones", "/views/publicaciones.jsp", "fas fa-bullhorn"));
            menu.add(new MenuItem("Mi horario", "/views/horario/estudiante.jsp", "fas fa-clock"));
        }

        if (permisosGenerales.contains("apoderado")) {
            menu.add(new MenuItem("Notas de mi hijo/a", "/views/apoderado/notas.jsp", "fas fa-book"));
            menu.add(new MenuItem("Asistencia", "/views/apoderado/asistencia.jsp", "fas fa-calendar-alt"));
            menu.add(new MenuItem("Publicaciones", "/views/publicaciones.jsp", "fas fa-bullhorn"));
            menu.add(new MenuItem("Mi hijo/a", "/views/apoderado/hijos.jsp", "fas fa-user-graduate"));
        }

        return menu;
    }
}
