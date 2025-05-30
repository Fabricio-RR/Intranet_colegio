package com.intranet_escolar.controller;

import com.intranet_escolar.dao.UsuarioDAO;
import com.intranet_escolar.util.EmailUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.concurrent.TimeUnit;

import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.SimpleEmail;


@WebServlet(name = "RecuperarPasswordServlet", urlPatterns = {"/recuperar-password"})
public class RecuperarPasswordServlet extends HttpServlet {
    
    private static final int TOKEN_EXPIRATION_MINUTES = 5;
    private static final int MAX_INTENTOS = 3;
    private static final int BLOQUEO_MINUTOS = 30;
        
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String paso = request.getParameter("paso");
        HttpSession session = request.getSession();

        if ("1".equals(paso)) {
            // Paso 1: Enviar código
            String dni = request.getParameter("dni");
            String email = request.getParameter("email");
            String codigo = generarCodigo();

            // Lógica de bloqueo por intentos
            Long bloqueo = (Long) session.getAttribute("bloqueado_hasta");
            if (bloqueo != null && System.currentTimeMillis() < bloqueo) {
                request.setAttribute("error", "Demasiados intentos fallidos. Intenta nuevamente en 30 minutos.");
                request.setAttribute("pasoActual", "1");
                request.getRequestDispatcher("/views/recuperar-password.jsp").forward(request, response);
                return;
            }

            session.setAttribute("codigo_verificacion", codigo);
            session.setAttribute("codigo_expira", System.currentTimeMillis() + TimeUnit.MINUTES.toMillis(TOKEN_EXPIRATION_MINUTES));
            session.setAttribute("intentos_codigo", 0);
            session.setAttribute("dni_validado", dni);
            session.setAttribute("email_validado", email);

            try {
                EmailUtil.enviarCodigo(email, codigo);
                request.setAttribute("mensaje", "Se envió el código a tu correo electrónico.");
            } catch (EmailException e) {
                request.setAttribute("error", "Error al enviar el correo. Inténtalo nuevamente.");
                request.setAttribute("pasoActual", "1");
                request.getRequestDispatcher("/views/recuperar-password.jsp").forward(request, response);
                return;
            }

            request.setAttribute("pasoActual", "2");
            request.getRequestDispatcher("/views/recuperar-password.jsp").forward(request, response);

        } else if ("2".equals(paso)) {
            // Paso 2: Verificar código
            String inputCodigo = request.getParameter("codigo");
            String codigoAlmacenado = (String) session.getAttribute("codigo_verificacion");
            Long expira = (Long) session.getAttribute("codigo_expira");
            Integer intentos = (Integer) session.getAttribute("intentos_codigo");

            if (expira == null || System.currentTimeMillis() > expira) {
                request.setAttribute("error", "El código ha expirado. Solicita uno nuevo.");
                request.setAttribute("pasoActual", "2");
                request.getRequestDispatcher("/views/recuperar-password.jsp").forward(request, response);
                return;
            }

            if (!inputCodigo.equals(codigoAlmacenado)) {
                intentos = (intentos == null ? 0 : intentos) + 1;
                session.setAttribute("intentos_codigo", intentos);

                if (intentos >= MAX_INTENTOS) {
                    session.setAttribute("bloqueado_hasta", System.currentTimeMillis() + TimeUnit.MINUTES.toMillis(BLOQUEO_MINUTOS));
                    request.setAttribute("error", "Demasiados intentos fallidos. Intenta en 30 minutos.");
                } else {
                    request.setAttribute("error", "Código incorrecto. Intento " + intentos + " de 3.");
                }

                request.setAttribute("pasoActual", "2");
                request.getRequestDispatcher("/views/recuperar-password.jsp").forward(request, response);
                return;
            }

            session.setAttribute("verificado", true);
            request.setAttribute("mensaje", "Código verificado correctamente.");
            request.setAttribute("pasoActual", "3");
            request.getRequestDispatcher("/views/recuperar-password.jsp").forward(request, response);

        } else if ("3".equals(paso)) {
            // Paso 3: Guardar nueva contraseña
            Boolean verificado = (Boolean) session.getAttribute("verificado");
            if (verificado == null || !verificado) {
                request.setAttribute("error", "Debes completar la verificación primero.");
                request.setAttribute("pasoActual", "1");
                request.getRequestDispatcher("/views/recuperar-password.jsp").forward(request, response);
                return;
            }

            String nuevaClave = request.getParameter("newPassword");
            String dni = (String) session.getAttribute("dni_validado");

            UsuarioDAO dao = new UsuarioDAO();
            boolean actualizado = dao.actualizarClavePorDni(dni, nuevaClave);

            if (actualizado) {
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/views/login.jsp?mensaje=Contraseña actualizada correctamente");
            } else {
                request.setAttribute("error", "Hubo un error al actualizar la contraseña.");
                request.setAttribute("pasoActual", "3");
                request.getRequestDispatcher("/views/recuperar-password.jsp").forward(request, response);
            }
        }
    }

    private String generarCodigo() {
        SecureRandom random = new SecureRandom();
        int numero = 100000 + random.nextInt(900000); // entre 100000 y 999999
        return String.valueOf(numero);
    }
 
    @Override
    public String getServletInfo() {
        return "Servlet para la recuperación de contraseña";
    }// </editor-fold>

}
