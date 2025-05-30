package com.intranet_escolar.util;

import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.SimpleEmail;

public class EmailUtil {

    private static final String HOST = "smtp.gmail.com";
    private static final int PORT = 587;
    private static final String FROM_EMAIL = "cdo10.soporte@gmail.com";
    private static final String FROM_NAME = "Intranet Escolar";
    private static final String AUTH_EMAIL = "cdo10.soporte@gmail.com";
    private static final String AUTH_PASSWORD = "tlvc oebh pjzy bgdr";

    public static void enviarCodigo(String destinatario, String codigo) throws EmailException {
        SimpleEmail email = new SimpleEmail();
        email.setHostName(HOST);
        email.setSmtpPort(PORT);
        email.setAuthentication(AUTH_EMAIL, AUTH_PASSWORD);
        email.setStartTLSRequired(true);
        email.setFrom(FROM_EMAIL, FROM_NAME);
        email.setSubject("Código de verificación - Intranet Escolar");
        email.setMsg("Tu código de verificación es: " + codigo + "\nEste código es válido por 5 minutos.");
        email.addTo(destinatario);
        email.send();
    }
}
