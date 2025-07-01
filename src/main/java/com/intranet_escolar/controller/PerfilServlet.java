package com.intranet_escolar.controller;

import com.intranet_escolar.model.entity.Usuario;
import com.intranet_escolar.dao.UsuarioDAO;
import com.intranet_escolar.util.SesionUtil;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.nio.file.Paths;

@WebServlet("/perfil")
@MultipartConfig
public class PerfilServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 1. Obtener usuario logueado desde sesión
        Usuario usuario = SesionUtil.getUsuarioLogueado(request);

        // 2. Determinar foto segura
        String nombreFoto = usuario.getFotoPerfil();
        String fotoPerfilUrl;
        if (nombreFoto == null || nombreFoto.trim().isEmpty() || "default.png".equals(nombreFoto)) {
            fotoPerfilUrl = request.getContextPath() + "/uploads/default.png";
        } else {
            String rutaFisica = getServletContext().getRealPath("/uploads/fotos/" + nombreFoto);
            File file = new File(rutaFisica);
            if (file.exists()) {
                fotoPerfilUrl = request.getContextPath() + "/uploads/fotos/" + nombreFoto;
            } else {
                fotoPerfilUrl = request.getContextPath() + "/uploads/default.png";
            }
        }
        request.setAttribute("fotoPerfilUrl", fotoPerfilUrl);

        // 3. Reenvía a la vista JSP de perfil
        request.getRequestDispatcher("/views/perfil.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Usuario usuario = SesionUtil.getUsuarioLogueado(request);
        UsuarioDAO usuarioDAO = new UsuarioDAO();

        String action = request.getParameter("action");

        if ("actualizarInfo".equals(action)) {
            // Actualizar correo, teléfono, foto
            String correo = request.getParameter("correo");
            String telefono = request.getParameter("telefono");

            Part fotoPart = request.getPart("foto_perfil");
            String nombreFoto = usuario.getFotoPerfil(); // por defecto mantiene la anterior

            // Subida nueva foto si hay
            if (fotoPart != null && fotoPart.getSize() > 0) {
                String nombreOriginal = Paths.get(fotoPart.getSubmittedFileName()).getFileName().toString();
                String extension = nombreOriginal.substring(nombreOriginal.lastIndexOf("."));
                nombreFoto = "foto_" + System.currentTimeMillis() + extension;

                String rutaUpload = getServletContext().getRealPath("/uploads/fotos");
                File carpeta = new File(rutaUpload);
                if (!carpeta.exists()) carpeta.mkdirs();

                fotoPart.write(new File(carpeta, nombreFoto).getAbsolutePath());
            }
            // Actualiza datos del usuario logueado
            usuario.setCorreo(correo);
            usuario.setTelefono(telefono);
            usuario.setFotoPerfil(nombreFoto);

            usuarioDAO.actualizarDatosPerfil(usuario);

            // Actualiza en sesión también
            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuario);

            // Redirecciona con mensaje de éxito (puedes mostrar mensaje con parámetro o flash attribute)
            response.sendRedirect(request.getContextPath() + "/perfil?success=1");
        } else if ("cambiarPassword".equals(action)) {
            // Cambiar contraseña
            String actual = request.getParameter("passwordActual");
            String nueva = request.getParameter("passwordNueva");
            String confirmar = request.getParameter("passwordConfirmar");

            if (!BCrypt.checkpw(actual, usuario.getClave())) {
                request.setAttribute("errorPass", "La contraseña actual es incorrecta.");
                doGet(request, response);
                return;
            }
            if (nueva == null || nueva.length() < 6 || !nueva.equals(confirmar)) {
                request.setAttribute("errorPass", "La nueva contraseña no cumple requisitos o no coincide.");
                doGet(request, response);
                return;
            }
            String hash = BCrypt.hashpw(nueva, BCrypt.gensalt());
            usuario.setClave(hash);
            usuarioDAO.actualizarClavePerfil(usuario.getIdUsuario(), hash);

            // Actualiza en sesión también
            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuario);

            response.sendRedirect(request.getContextPath() + "/perfil?passSuccess=1");
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
