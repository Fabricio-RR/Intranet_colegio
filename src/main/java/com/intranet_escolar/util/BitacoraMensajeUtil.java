package com.intranet_escolar.util;

import com.intranet_escolar.model.entity.Usuario;
import java.util.List;

public class BitacoraMensajeUtil {

    public static String nombreConDni(Usuario u) {
        return u.getNombres() + " " + u.getApellidos() + " (" + u.getDni() + ")";
    }

    public static String mensajeResetear(Usuario u) {
        return "Se reseteó la contraseña del usuario " + nombreConDni(u);
    }

    public static String mensajeDesactivar(Usuario u) {
        return "Se desactivó al usuario " + nombreConDni(u);
    }

    public static String mensajeEditar(Usuario u) {
        return "Editó los datos del usuario " + nombreConDni(u);
    }

    public static String mensajeCrear(Usuario u, List<Integer> rolesIds) {
        String roles = rolesIds != null && !rolesIds.isEmpty()
                ? " Roles asignados: " + rolesIds.toString()
                : " Sin roles asignados.";
        return String.format("Registró al nuevo usuario [%s - %s %s] con DNI %s.%s",
                u.getCorreo(), u.getNombres(), u.getApellidos(), u.getDni(), roles);
    }
}

