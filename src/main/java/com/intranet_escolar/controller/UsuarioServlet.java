package com.intranet_escolar.controller;

import com.intranet_escolar.dao.UsuarioDAO;
import com.intranet_escolar.model.entity.Usuario;
import com.intranet_escolar.util.BitacoraMensajeUtil;
import com.intranet_escolar.util.EmailUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.security.SecureRandom;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import org.apache.commons.mail.EmailException;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet(name = "UsuarioServlet", urlPatterns = {"/usuarios"})
@MultipartConfig
public class UsuarioServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        // Validación de DNI (desde AJAX)
        if ("validar_dni".equals(action)) {
            String dni = request.getParameter("dni");
            boolean existe = false;
            try {
                existe = usuarioDAO.existeDni(dni); // usa tu método con SP
            } catch (SQLException e) {
                e.printStackTrace();
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"existe\": " + existe + "}");
            return;
        }
         // Si es para mostrar formulario de creación
        if ("nuevo".equals(action)) {
            request.setAttribute("rolesDisponibles", usuarioDAO.listarTodosLosRoles());
            request.getRequestDispatcher("/views/usuario/crear.jsp").forward(request, response);
            return;
        } 
        // Si es ver, editar o bitácora por ID
        if (action != null && idParam != null) {
            int id = Integer.parseInt(idParam);
            Usuario usuario = usuarioDAO.obtenerUsuarioCompletoPorId(id); // con roles, alumno, docente, apoderado, etc.

            request.setAttribute("usuario", usuario);

            switch (action) {
                case "ver":
                    request.getRequestDispatcher("/views/usuario/ver.jsp").forward(request, response);
                    return;

                case "editar":
                    request.setAttribute("rolesDisponibles", usuarioDAO.listarTodosLosRoles());
                    request.setAttribute("usuario.rolesAsIds", usuario.getRolesAsIds());
                    request.getRequestDispatcher("/views/usuario/editar.jsp").forward(request, response);
                    return;

                case "bitacora":
                    request.setAttribute("registros", usuarioDAO.obtenerBitacoraPorUsuario(id));
                    request.getRequestDispatcher("/views/usuario/bitacora.jsp").forward(request, response);
                    return;

                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Acción no válida");
                    return;
            }
        }
        // Obtener parámetros opcionales
        String filtroEstado = request.getParameter("estado");
        String filtroRol = request.getParameter("rol");
        String filtroFecha = request.getParameter("fecha");
        String filtroNivel = request.getParameter("nivel");
        String filtroGrado = request.getParameter("grado");
        String filtroSeccion = request.getParameter("seccion");

        List<Usuario> listaUsuarios;
        System.out.println("Cantidad de roles: " + usuarioDAO.listarTodosLosRoles().size());


        // Si no hay ningún filtro, usa el método completo
        if (filtroEstado == null && filtroRol == null && filtroFecha == null && filtroNivel == null && filtroGrado == null && filtroSeccion == null) {
            listaUsuarios = usuarioDAO.listarUsuariosCompletos();
        } else {
            listaUsuarios = usuarioDAO.listarUsuariosFiltrados(
                filtroEstado, filtroRol, filtroFecha, filtroNivel, filtroGrado, filtroSeccion
            );
        }

        request.setAttribute("usuarios", listaUsuarios);
        // Pasar filtros para marcarlos como seleccionados en el JSP
        request.setAttribute("rolesDisponibles", usuarioDAO.listarTodosLosRoles());
        /*request.setAttribute("nivelesDisponibles", nivelDAO.listarTodos());   // o lo que uses para obtener niveles
        request.setAttribute("gradosDisponibles", gradoDAO.listarTodos());
        request.setAttribute("seccionesDisponibles", seccionDAO.listarTodos());*/

        request.setAttribute("estadoSeleccionado", filtroEstado);
        request.setAttribute("rolSeleccionado", filtroRol);
        request.setAttribute("fechaSeleccionada", filtroFecha);
        request.setAttribute("nivelSeleccionado", filtroNivel);
        request.setAttribute("gradoSeleccionado", filtroGrado);
        request.setAttribute("seccionSeleccionada", filtroSeccion);

        request.getRequestDispatcher("/views/usuario/usuarios.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if ("validar_dni".equals(action)) {
            String dni = request.getParameter("dni");
            UsuarioDAO dao = new UsuarioDAO();

            try {
                boolean existe = dao.existeDni(dni);
                response.setContentType("application/json");
                response.getWriter().write("{\"existe\": " + existe + "}");
            } catch (SQLException e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"error\": \"Error al validar el DNI.\"}");
            }
            return;
        }else if ("crear".equals(action)) {
            try {
            String dni = request.getParameter("dni");
            UsuarioDAO dao = new UsuarioDAO();
            if (dao.existeDni(dni)) {
                response.setContentType("application/json");
                response.setStatus(HttpServletResponse.SC_CONFLICT); // 409 Conflict
                response.getWriter().write("{\"error\": \"El DNI ya está registrado.\"}");
                return;
            }
            String nombres = request.getParameter("nombres");
            String apellidos = request.getParameter("apellidos");
            String correo = request.getParameter("correo");
            String telefono = request.getParameter("telefono");
            boolean estado = "1".equals(request.getParameter("estado"));
            String clave = request.getParameter("clave");

            // Procesar foto
            Part fotoPart = request.getPart("foto_perfil");
            String nombreFoto = null;
            if (fotoPart != null && fotoPart.getSize() > 0) {
                String nombreOriginal = Paths.get(fotoPart.getSubmittedFileName()).getFileName().toString();
                String extension = nombreOriginal.substring(nombreOriginal.lastIndexOf("."));
                nombreFoto = "foto_" + System.currentTimeMillis() + extension;

                String rutaUpload = getServletContext().getRealPath("/uploads");
                File carpeta = new File(rutaUpload);
                if (!carpeta.exists()) carpeta.mkdirs();

                fotoPart.write(new File(carpeta, nombreFoto).getAbsolutePath());
            } else {
                nombreFoto = "default.png";
            }

            // Roles (opcional)
            String[] rolesForm = request.getParameterValues("roles");
            List<Integer> idsRoles = new ArrayList<>();
            if (rolesForm != null) {
                for (String rolId : rolesForm) {
                    idsRoles.add(Integer.parseInt(rolId));
                }
            }

            // Crear objeto Usuario
            Usuario usuario = new Usuario();
            usuario.setDni(dni);
            usuario.setNombres(nombres);
            usuario.setApellidos(apellidos);
            usuario.setCorreo(correo);
            usuario.setTelefono(telefono);
            usuario.setEstado(estado);
            usuario.setClave(BCrypt.hashpw(clave, BCrypt.gensalt()));
            usuario.setFecRegistro(new Date());
            usuario.setFotoPerfil(nombreFoto);

            boolean exito = dao.crearUsuarioConRoles(usuario, idsRoles);

            HttpSession session = request.getSession(false);
            Usuario usuarioActual = (session != null) ? (Usuario) session.getAttribute("usuario") : null;
            if (usuarioActual != null) {
                String accion = BitacoraMensajeUtil.mensajeCrear(usuario, idsRoles);
                dao.registrarBitacora(usuarioActual.getIdUsuario(), "usuario/crear-usuario", accion);
            }

            if (exito) {
                response.setContentType("application/json");
                response.getWriter().write("{\"mensaje\": \"Usuario creado correctamente.\"}");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "No se pudo crear el usuario.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error en la creación del usuario.");
        }

    } else if ("guardar".equals(action)) {
            int idUsuario = Integer.parseInt(request.getParameter("id"));
            String dni = request.getParameter("dni");
            String nombres = request.getParameter("nombres");
            String apellidos = request.getParameter("apellidos");
            String correo = request.getParameter("correo");
            String telefono = request.getParameter("telefono");
            boolean estado = "1".equals(request.getParameter("estado"));

            // Procesar foto nueva
            Part fotoPart = request.getPart("fotoPerfil");
            String nuevaFoto = null;

            if (fotoPart != null && fotoPart.getSize() > 0) {
                String nombreOriginal = Paths.get(fotoPart.getSubmittedFileName()).getFileName().toString();
                String extension = nombreOriginal.substring(nombreOriginal.lastIndexOf(".")); // e.g. .jpg, .png

                // Generar nombre único para evitar colisiones
                nuevaFoto = "foto_" + System.currentTimeMillis() + extension;

                // Ruta real del directorio /uploads
                String rutaUpload = getServletContext().getRealPath("/uploads");
                File carpetaUpload = new File(rutaUpload);
                if (!carpetaUpload.exists()) carpetaUpload.mkdirs(); // Crear carpeta si no existe

                File destino = new File(carpetaUpload, nuevaFoto);
                fotoPart.write(destino.getAbsolutePath());
            } else {
                // No se subió nueva imagen, mantener la anterior
                 nuevaFoto = request.getParameter("fotoActual");
            }

            // Procesar roles seleccionados
            String[] rolesForm = request.getParameterValues("roles");
            List<Integer> idsRoles = new ArrayList<>();
            if (rolesForm != null) {
                for (String rolId : rolesForm) {
                    idsRoles.add(Integer.parseInt(rolId));
                }
            }

            // Preparar objeto Usuario
            Usuario usuario = new Usuario();
            usuario.setIdUsuario(idUsuario);
            usuario.setDni(dni);
            usuario.setNombres(nombres);
            usuario.setApellidos(apellidos);
            usuario.setCorreo(correo);
            usuario.setTelefono(telefono);
            usuario.setEstado(estado);
            if (nuevaFoto != null) {
                usuario.setFotoPerfil(nuevaFoto);
            }

            // Guardar en BD
            UsuarioDAO dao = new UsuarioDAO();
            dao.actualizarUsuario(usuario, idsRoles);
            // Registrar bitácora
            HttpSession session = request.getSession(false);
            Usuario usuarioActual = (session != null) ? (Usuario) session.getAttribute("usuario") : null;
            if (usuarioActual != null) {
                String accion = BitacoraMensajeUtil.mensajeEditar(usuario);
                usuarioDAO.registrarBitacora(usuarioActual.getIdUsuario(), "Usuarios", accion);
            }
            // Redirigir a lista o mostrar mensaje
            response.sendRedirect(request.getContextPath() + "/usuarios");
        }else if ("resetear".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Usuario usuario = usuarioDAO.obtenerUsuarioCompletoPorId(id);

            if (usuario == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Usuario no encontrado.");
                return;
            }

            String nuevaClave = PasswordUtil.generarPasswordSeguro();
            boolean actualizado = usuarioDAO.actualizarClavePorDni(usuario.getDni(), nuevaClave);

            if (actualizado) {
                try {
                    EmailUtil.enviarNuevaClave(usuario.getCorreo(), nuevaClave, usuario.getNombres());
                    // Obtener el usuario actual desde sesión
                    HttpSession session = request.getSession(false);
                    Usuario usuarioActual = (session != null) ? (Usuario) session.getAttribute("usuario") : null;
                    if (usuarioActual != null) {
                        String accion = BitacoraMensajeUtil.mensajeResetear(usuario);
                        usuarioDAO.registrarBitacora(usuarioActual.getIdUsuario(), "Usuarios", accion);
                    }
                    response.setContentType("application/json");
                    response.getWriter().write("{\"mensaje\": \"Contraseña reseteada y enviada al correo.\"}");
                } catch (EmailException e) {
                    e.printStackTrace();
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Contraseña cambiada, pero no se pudo enviar el correo.");
                }
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "No se pudo resetear la contraseña.");
            }
        }else if ("eliminar".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            try {
                usuarioDAO.cambiarEstadoUsuario(id, false); // false = inactivo (desactivado)
                // Obtener el usuario actual desde sesión
                HttpSession session = request.getSession(false);
                Usuario usuarioActual = (session != null) ? (Usuario) session.getAttribute("usuario") : null;
                Usuario afectado = usuarioDAO.obtenerUsuarioCompletoPorId(id); // obtener usuario desactivado
                if (usuarioActual != null && afectado != null) {
                    String accion = BitacoraMensajeUtil.mensajeDesactivar(afectado);
                    usuarioDAO.registrarBitacora(usuarioActual.getIdUsuario(), "Usuarios", accion);
                }
                response.setContentType("application/json");
                response.getWriter().write("{\"mensaje\": \"Usuario desactivado correctamente.\"}");
            } catch (SQLException e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "No se pudo desactivar el usuario.");
            }
        }
    }
    
    public class PasswordUtil {

        private static final String CARACTERES = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#$%!&*";
        private static final int LONGITUD = 10;

        public static String generarPasswordSeguro() {
            SecureRandom random = new SecureRandom();
            StringBuilder sb = new StringBuilder(LONGITUD);
            for (int i = 0; i < LONGITUD; i++) {
                int index = random.nextInt(CARACTERES.length());
                sb.append(CARACTERES.charAt(index));
            }
            return sb.toString();
        }
    }

    @Override
    public String getServletInfo() {
        return "Controlador de gestión de usuarios";
    }
}
