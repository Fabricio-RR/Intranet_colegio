package com.intranet_escolar.util;

import com.intranet_escolar.model.entity.Usuario;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public class SesionUtil {
    public static Usuario getUsuarioLogueado(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session != null) ? (Usuario) session.getAttribute("usuario") : null;
    }
}
