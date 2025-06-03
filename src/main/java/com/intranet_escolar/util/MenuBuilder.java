/*package com.intranet_escolar.util;

import com.intranet_escolar.model.entity.MenuItem;
import com.intranet_escolar.model.entity.Rol;

import java.util.*;

public class MenuBuilder {

    public static List<MenuItem> construirMenuPorRol(List<Rol> roles) {
        Set<String> nombresRol = new HashSet<>();
        for (Rol r : roles) {
            nombresRol.add(r.getNombre());
        }

        List<MenuItem> menu = new ArrayList<>();

        //  Administrador
        if (nombresRol.contains("Administrador")) {
            menu.add(new MenuItem("Usuarios", "/views/admin/usuarios.jsp", "fas fa-users-cog"));
            menu.add(new MenuItem("Roles y Permisos", "/views/admin/roles.jsp", "fas fa-user-shield"));
            menu.add(new MenuItem("Cursos", "/views/admin/cursos.jsp", "fas fa-book"));
            menu.add(new MenuItem("Secciones", "/views/admin/secciones.jsp", "fas fa-layer-group"));
            menu.add(new MenuItem("Malla Curricular", "/views/admin/malla.jsp", "fas fa-stream"));
            menu.add(new MenuItem("Periodos", "/views/admin/periodos.jsp", "fas fa-calendar-alt"));
            menu.add(new MenuItem("Publicaciones", "/views/admin/publicaciones.jsp", "fas fa-bullhorn"));
            menu.add(new MenuItem("Horarios", "/views/admin/horarios.jsp", "fas fa-clock"));
            menu.add(new MenuItem("Reportes", "/views/admin/reportes.jsp", "fas fa-file-pdf"));
            menu.add(new MenuItem("Bitácora", "/views/admin/bitacora.jsp", "fas fa-history"));
        }

        //  Docente
        if (nombresRol.contains("Docente")) {
            menu.add(new MenuItem("Mis Cursos", "/views/docente/cursos.jsp", "fas fa-chalkboard-teacher"));
            menu.add(new MenuItem("Notas", "/views/docente/notas.jsp", "fas fa-clipboard-check"));
            menu.add(new MenuItem("Asistencia", "/views/docente/asistencia.jsp", "fas fa-user-check"));
            menu.add(new MenuItem("Conducta", "/views/docente/conducta.jsp", "fas fa-user-edit"));
            menu.add(new MenuItem("Publicaciones", "/views/docente/publicaciones.jsp", "fas fa-bullhorn"));
            menu.add(new MenuItem("Horario", "/views/docente/horario.jsp", "fas fa-clock"));
        }

        //  Alumno
        if (nombresRol.contains("Alumno")) {
            menu.add(new MenuItem("Mis Notas", "/views/alumno/notas.jsp", "fas fa-book-open"));
            menu.add(new MenuItem("Asistencia", "/views/alumno/asistencia.jsp", "fas fa-calendar-check"));
            menu.add(new MenuItem("Conducta", "/views/alumno/conducta.jsp", "fas fa-user-friends"));
            menu.add(new MenuItem("Horario", "/views/alumno/horario.jsp", "fas fa-clock"));
            menu.add(new MenuItem("Publicaciones", "/views/alumno/publicaciones.jsp", "fas fa-bullhorn"));
        }

        //  Apoderado
        if (nombresRol.contains("Apoderado")) {
            menu.add(new MenuItem("Notas de mi hijo/a", "/views/apoderado/notas.jsp", "fas fa-book-reader"));
            menu.add(new MenuItem("Conducta", "/views/apoderado/conducta.jsp", "fas fa-user-shield"));
            menu.add(new MenuItem("Horario", "/views/apoderado/horario.jsp", "fas fa-clock"));
            menu.add(new MenuItem("Publicaciones", "/views/apoderado/publicaciones.jsp", "fas fa-bullhorn"));
        }

        //  Coordinador Académico
        if (nombresRol.contains("Coordinador Académico")) {
            menu.add(new MenuItem("Supervisión", "/views/coordinador/supervision.jsp", "fas fa-user-tie"));
            menu.add(new MenuItem("Avance Notas", "/views/coordinador/avance.jsp", "fas fa-chart-line"));
            menu.add(new MenuItem("Reportes", "/views/coordinador/reportes.jsp", "fas fa-file-pdf"));
            menu.add(new MenuItem("Publicaciones", "/views/coordinador/publicaciones.jsp", "fas fa-bullhorn"));
        }

        return menu;
    }
}**/