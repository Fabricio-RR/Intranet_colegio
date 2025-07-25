package com.intranet_escolar.util;

import com.intranet_escolar.model.entity.Comunicado;
import java.util.List;
import org.apache.commons.mail.*;


public class EmailUtil {

    private static final String HOST = "smtp.gmail.com";
    private static final int PORT = 587;
    private static final String FROM_EMAIL = "cdo10.soporte@gmail.com";
    private static final String FROM_NAME = "Intranet Escolar";
    private static final String AUTH_EMAIL = "cdo10.soporte@gmail.com";
    private static final String AUTH_PASSWORD = "tlvc oebh pjzy bgdr";

    public static void enviarCodigo(String destinatario, String codigo, String nombreUsuario) throws EmailException {
        HtmlEmail email = new HtmlEmail();
        email.setHostName(HOST);
        email.setSmtpPort(PORT);
        email.setAuthentication(AUTH_EMAIL, AUTH_PASSWORD);
        email.setStartTLSRequired(true);
        email.setFrom(FROM_EMAIL, FROM_NAME);
        email.setSubject("Código de verificación - Intranet Escolar");
        String htmlMessage =
                
            "<!DOCTYPE html>" +
            "<html lang='es'>" +
            "<head>" +
            "  <meta charset='UTF-8'>" +
            "  <meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
            "  <title>Recuperación de Contraseña</title>" +
            "</head>" +
            "<body style='margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f4f4f4;'>" +
            "  <table align='center' cellpadding='0' cellspacing='0' width='100%' style='padding: 20px; background-color: #f4f4f4;'>" +
            "    <tr>" +
            "      <td align='center'>" +
            "        <table cellpadding='0' cellspacing='0' width='100%' style='max-width: 600px; background-color: #ffffff; padding: 20px; border-radius: 8px;'>" +
            "          <tr>" +
            "            <td style='text-align: center; padding-bottom: 20px;'>" +
            "              <h2 style='color: #0A0A3D; margin-bottom: 5px;'>Intranet Escolar</h2>" +
            "              <p style='color: #555; font-size: 14px;'>Colegio Peruano Chino Diez de Octubre</p>" +
            "            </td>" +
            "          </tr>" +
            "          <tr>" +
            "            <td style='padding: 10px 0; font-size: 16px; color: #333;'>Estimado(a) <strong>" + nombreUsuario + "</strong>,</td>" +
            "          </tr>" +
            "          <tr>" +
            "            <td style='padding: 10px 0; font-size: 16px; color: #333;'>Tu código de verificación es:</td>" +
            "          </tr>" +
            "          <tr>" +
            "            <td style='text-align: center; padding: 20px 0;'>" +
            "              <div style='display: inline-block; background-color: #d93025; color: white; font-size: 24px; padding: 12px 24px; border-radius: 6px; letter-spacing: 2px; font-weight: bold;'>" + codigo + "</div>" +
            "            </td>" +
            "          </tr>" +
            "          <tr>" +
            "            <td style='font-size: 14px; color: #555;'>Este código es válido por <strong>5 minutos</strong>. Si no solicitaste este código, puedes ignorar este mensaje.</td>" +
            "          </tr>" +
            "          <tr>" +
            "            <td style='padding-top: 30px; border-top: 1px solid #ddd; font-size: 12px; color: #999; text-align: center;'>© 2025 Intranet Escolar</td>" +
            "          </tr>" +
            "        </table>" +
            "      </td>" +
            "    </tr>" +
            "  </table>" +
            "</body>" +
            "</html>";

        email.setHtmlMsg(htmlMessage);
        email.setTextMsg("Tu código de verificación es: " + codigo + "\nEste código es válido por 5 minutos.");
        email.addTo(destinatario);
        email.send();
    }
    
    public static void enviarNuevaClave(String destinatario, String nuevaClave, String nombreUsuario) throws EmailException {
        HtmlEmail email = new HtmlEmail();
        email.setHostName(HOST);
        email.setSmtpPort(PORT);
        email.setAuthentication(AUTH_EMAIL, AUTH_PASSWORD);
        email.setStartTLSRequired(true);
        email.setFrom(FROM_EMAIL, FROM_NAME);
        email.setSubject("Nueva Contraseña - Intranet Escolar");

        String htmlMessage =
            "<!DOCTYPE html>" +
            "<html lang='es'>" +
            "<head><meta charset='UTF-8'><title>Nueva Contraseña</title></head>" +
            "<body style='font-family: Arial, sans-serif; background-color: #f4f4f4;'>" +
            "  <table align='center' cellpadding='0' cellspacing='0' width='100%' style='padding: 20px; background-color: #f4f4f4;'>" +
            "    <tr><td align='center'>" +
            "      <table cellpadding='0' cellspacing='0' width='100%' style='max-width: 600px; background-color: #ffffff; padding: 20px; border-radius: 8px;'>" +
            "        <tr><td style='text-align: center; padding-bottom: 20px;'>" +
            "          <h2 style='color: #0A0A3D;'>Intranet Escolar</h2>" +
            "          <p style='color: #555; font-size: 14px;'>Colegio Peruano Chino Diez de Octubre</p>" +
            "        </td></tr>" +
            "        <tr><td style='padding: 10px 0; font-size: 16px; color: #333;'>Estimado(a) <strong>" + nombreUsuario + "</strong>,</td></tr>" +
            "        <tr><td style='padding: 10px 0; font-size: 16px; color: #333;'>Tu nueva contraseña temporal es:</td></tr>" +
            "        <tr><td style='text-align: center; padding: 20px 0;'>" +
            "          <div style='display: inline-block; background-color: #0A0A3D; color: white; font-size: 22px; padding: 12px 24px; border-radius: 6px; letter-spacing: 2px; font-weight: bold;'>" +
                        nuevaClave + "</div></td></tr>" +
            "        <tr><td style='font-size: 14px; color: #555;'>Por seguridad, cambia esta contraseña al iniciar sesión.</td></tr>" +
            "        <tr><td style='padding-top: 30px; border-top: 1px solid #ddd; font-size: 12px; color: #999; text-align: center;'>© 2025 Intranet Escolar</td></tr>" +
            "      </table>" +
            "    </td></tr>" +
            "  </table>" +
            "</body></html>";

        email.setHtmlMsg(htmlMessage);
        email.setTextMsg("Tu nueva contraseña es: " + nuevaClave + "\nPor seguridad, cámbiala al iniciar sesión.");
        email.addTo(destinatario);
        email.send();
    }
    public static void enviarNotificacionComunicadoPersonal(
        String destinatario, // correo individual
        String nombreDestinatario, // nombre individual (o correo si no tienes el nombre)
        Comunicado comunicado,
        String nombreRemitente) throws EmailException {

        HtmlEmail email = new HtmlEmail();
        email.setHostName(HOST);
        email.setSmtpPort(PORT);
        email.setAuthentication(AUTH_EMAIL, AUTH_PASSWORD);
        email.setStartTLSRequired(true);
        email.setFrom(FROM_EMAIL, FROM_NAME);
        email.setSubject("Nuevo Comunicado - Intranet Escolar");

        email.addTo(destinatario);

        String saludo = "Estimado(a), <b>" + nombreDestinatario + "</b>";

        String htmlMessage =
            "<!DOCTYPE html>" +
            "<html lang='es'>" +
            "<head>" +
            "  <meta charset='UTF-8'>" +
            "  <meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
            "  <title>Nuevo Comunicado</title>" +
            "</head>" +
            "<body style='margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f4f4f4;'>" +
            "  <table align='center' cellpadding='0' cellspacing='0' width='100%' style='padding: 20px; background-color: #f4f4f4;'>" +
            "    <tr>" +
            "      <td align='center'>" +
            "        <table cellpadding='0' cellspacing='0' width='100%' style='max-width: 600px; background-color: #ffffff; padding: 20px; border-radius: 8px;'>" +
            "          <tr>" +
            "            <td style='text-align: center; padding-bottom: 20px;'>" +
            "              <h2 style='color: #0A0A3D; margin-bottom: 5px;'>Intranet Escolar</h2>" +
            "              <p style='color: #555; font-size: 14px;'>Colegio Peruano Chino Diez de Octubre</p>" +
            "            </td>" +
            "          </tr>" +
            "          <tr>" +
            "            <td style='padding: 10px 0; font-size: 16px; color: #333;'>" + saludo + "</td>" +
            "          </tr>" +
            "          <tr>" +
            "            <td style='padding: 10px 0; font-size: 17px; color: #0A0A3D;'><strong>" + comunicado.getTitulo() + "</strong></td>" +
            "          </tr>" +
            "          <tr>" +
            "            <td style='font-size: 15px; color: #333;'>" + comunicado.getContenido() + "</td>" +
            "          </tr>" + 
            "          <tr>" +
            "            <td style='font-size: 13px; color: #555; padding-top:10px;'>Revise más detalles en la Intranet Escolar.</td>" +
            "          </tr>" +
            "          <tr>" +
            "            <td style='padding-top: 30px; border-top: 1px solid #ddd; font-size: 12px; color: #999; text-align: center;'>© 2025 Intranet Escolar</td>" +
            "          </tr>" +
            "        </table>" +
            "      </td>" +
            "    </tr>" +
            "  </table>" +
            "</body>" +
            "</html>";

        email.setHtmlMsg(htmlMessage);
        email.setTextMsg("Nuevo Comunicado: " + comunicado.getTitulo() + "\n" + comunicado.getContenido());
        email.send();
    }
}
