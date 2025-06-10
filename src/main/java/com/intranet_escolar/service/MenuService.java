package com.intranet_escolar.service;

import com.intranet_escolar.model.entity.MenuItem;
import com.intranet_escolar.model.entity.Rol;

import java.util.*;

public class MenuService {

    public static List<MenuItem> generarMenuPorRoles(List<String> nombresRoles) {
        Set<String> permisosGenerales = new HashSet<>();
        for (String nombre : nombresRoles) {
            permisosGenerales.add(nombre.toLowerCase());
        }

        List<MenuItem> menu = new ArrayList<>();

        if (permisosGenerales.contains("administrador")) {
            menu.add(new MenuItem("usuarios", "/usuarios", "fas fa-users"));
            menu.add(new MenuItem("malla curricular", "/views/malla/malla.jsp", "fas fa-chalkboard-teacher"));
            menu.add(new MenuItem("publicaciones", "/views/publicaciones.jsp", "fas fa-bullhorn"));
            menu.add(new MenuItem("reportes", "/views/reportes.jsp", "fas fa-file-alt"));
            menu.add(new MenuItem("configuración", "/views/configuracion.jsp", "fas fa-cogs"));
        }

        if (permisosGenerales.contains("docente")) {
            menu.add(new MenuItem("notas", "/views/notas.jsp", "fas fa-clipboard-check"));
            menu.add(new MenuItem("asistencia", "/views/asistencia.jsp", "fas fa-calendar-check"));
            menu.add(new MenuItem("publicaciones", "/views/publicaciones.jsp", "fas fa-bullhorn"));
            menu.add(new MenuItem("mi horario", "/views/horario.jsp", "fas fa-clock"));
        }

        if (permisosGenerales.contains("estudiante")) {
            menu.add(new MenuItem("mis calificaciones", "/views/notas/mis_notas.jsp", "fas fa-graduation-cap"));
            menu.add(new MenuItem("asistencia", "/views/asistencia/mis_asistencias.jsp", "fas fa-calendar-alt"));
            menu.add(new MenuItem("publicaciones", "/views/publicaciones.jsp", "fas fa-bullhorn"));
            menu.add(new MenuItem("mi horario", "/views/horario/estudiante.jsp", "fas fa-clock"));
        }

        if (permisosGenerales.contains("apoderado")) {
            menu.add(new MenuItem("notas de mi hijo/a", "/views/apoderado/notas.jsp", "fas fa-book"));
            menu.add(new MenuItem("asistencia", "/views/apoderado/asistencia.jsp", "fas fa-calendar-alt"));
            menu.add(new MenuItem("publicaciones", "/views/publicaciones.jsp", "fas fa-bullhorn"));
            menu.add(new MenuItem("mi hijo/a", "/views/apoderado/hijos.jsp", "fas fa-user-graduate"));
        }

        return menu;
    }
}
