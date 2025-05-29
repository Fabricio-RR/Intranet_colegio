package com.intranet_escolar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.security.SecureRandom;
import java.time.Instant;


@WebServlet(name = "RecuperarPasswordServlet", urlPatterns = {"/recuperar-password"})
public class RecuperarPasswordServlet extends HttpServlet {
    
    private static final int DURACION_CODIGO_MINUTOS = 5;
    private static final int INTENTOS_MAXIMOS = 3;
    private static final int BLOQUEO_MINUTOS = 30;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        String dni = request.getParameter("dni");
        String email = request.getParameter("email");

        // Validación simple (en entorno real, verificar en BD)
        if (dni == null || email == null || dni.length() != 8 || !email.contains("@")) {
            session.setAttribute("error", "Datos inválidos.");
            response.sendRedirect("views/recuperar-password.jsp");
            return;
        }

        // Verificar si está bloqueado
        Long bloqueoHasta = (Long) session.getAttribute("bloqueo_hasta");
        if (bloqueoHasta != null && bloqueoHasta > Instant.now().toEpochMilli()) {
            session.setAttribute("error", "Has superado el número de intentos. Intenta después de 30 minutos.");
            response.sendRedirect("views/recuperar-password.jsp");
            return;
        }

        // Generar código de 6 dígitos
        String codigo = generarCodigo();
        long expiracion = Instant.now().plusSeconds(DURACION_CODIGO_MINUTOS * 60).toEpochMilli();

        // Guardar en sesión
        session.setAttribute("codigo_token", codigo);
        session.setAttribute("codigo_expira", expiracion);
        session.setAttribute("codigo_intentos", 0);
        session.removeAttribute("bloqueo_hasta");

        // Enviar correo
        try {
            enviarCorreo(email, codigo);
            session.setAttribute("mensaje", "Se ha enviado el código a tu correo electrónico.");
        } catch (Exception e) {
            session.setAttribute("error", "No se pudo enviar el correo. Intenta más tarde.");
        }

        response.sendRedirect("views/recuperar-password.jsp");
    }

    private String generarCodigo() {
        SecureRandom random = new SecureRandom();
        int numero = 100000 + random.nextInt(900000); // entre 100000 y 999999
        return String.valueOf(numero);
    }

    private void enviarCorreo(String destino, String codigo) throws EmailException {
        SimpleEmail email = new SimpleEmail();
        email.setHostName("smtp.gmail.com"); 
        email.setSmtpPort(587);
        email.setAuthentication("cdo10.soporte@gmail.com", "tlvc oebh pjzy bgdr");
        email.setStartTLSRequired(true);
        email.setFrom("cdo10.soporte@gmail.com", "Intranet Escolar");
        email.setSubject("Código de verificación");
        email.setMsg("Tu código de verificación es: " + codigo + "\nEste código es válido por 5 minutos.");
        email.addTo(destino);
        email.send();
    }
    
    @Override
    public String getServletInfo() {
        return "Servlet para la recuperación de contraseña";
    }// </editor-fold>

}
