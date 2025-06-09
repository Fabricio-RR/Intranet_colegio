
package com.intranet_escolar.dao;

import java.sql.*;
import java.util.*;
import org.mindrot.jbcrypt.BCrypt;
import com.intranet_escolar.config.DatabaseConfig;
import com.intranet_escolar.model.entity.Alumno;
import com.intranet_escolar.model.entity.Apoderado;
import com.intranet_escolar.model.entity.Curso;
import com.intranet_escolar.model.entity.Docente;
import com.intranet_escolar.model.entity.Permiso;
import com.intranet_escolar.model.entity.Rol;
import com.intranet_escolar.model.entity.Usuario;

public class UsuarioDAO {

    public UsuarioDAO() {
    }
    
    public Usuario login(String dni, String claveIngresada) {

    if (dni == null || claveIngresada == null) {
        throw new RuntimeException("DNI o contraseña no enviados.");
    }
    Usuario usuario = null;

    try (Connection con = DatabaseConfig.getConnection();
         CallableStatement cs = con.prepareCall("{ CALL sp_login_usuario(?) }")) {

        cs.setString(1, dni);

        try (ResultSet rs = cs.executeQuery()) {
            String claveHasheadaBD = null;
            Map<Integer, Rol> rolesMap = new HashMap<>();

            if (rs.next()) {
                    usuario = new Usuario();
                    usuario.setIdUsuario(rs.getInt("id_usuario"));
                    usuario.setDni(rs.getString("dni"));
                    usuario.setNombres(rs.getString("nombres"));
                    usuario.setApellidos(rs.getString("apellidos"));
                    usuario.setCorreo(rs.getString("correo"));
                    usuario.setTelefono(rs.getString("telefono"));
                    usuario.setEstado(rs.getBoolean("estado"));
                    usuario.setFotoPerfil(rs.getString("foto_perfil"));
                    claveHasheadaBD = rs.getString("clave");

                int idRol = rs.getInt("id_rol");
                String nombreRol = rs.getString("rol_nombre");
                String descripcionRol = rs.getString("rol_descripcion");

                if (!rolesMap.containsKey(idRol)) {
                    rolesMap.put(idRol, new Rol(idRol, nombreRol, descripcionRol));
                }
            }

            if (usuario != null && claveHasheadaBD != null) {

                if (BCrypt.checkpw(claveIngresada, claveHasheadaBD)) {
                    usuario.setRoles(new ArrayList<>(rolesMap.values()));
                } else {
                    usuario = null;
                }
            } else {
                usuario = null;
            }
        }

    } catch (SQLException e) {
        System.err.println("Error en login: " + e.getMessage());
        usuario = null;
    }

    return usuario;
}
    
    public List<Rol> obtenerRolesPorUsuario(int idUsuario) {
        List<Rol> roles = new ArrayList<>();
        String sql = "CALL sp_obtener_roles_por_usuario(?)";

        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement stmt = conn.prepareCall(sql)) {

            stmt.setInt(1, idUsuario);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Rol rol = new Rol();
                rol.setIdRol(rs.getInt("id_rol"));
                rol.setNombre(rs.getString("nombre"));
                rol.setDescripcion(rs.getString("descripcion")); // Asegúrate que lo devuelve el SP
                roles.add(rol);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return roles;
    }

    public List<Permiso> obtenerPermisos(List<String> roles) {
        List<Permiso> permisos = new ArrayList<>();

        if (roles == null || roles.isEmpty()) return permisos;

        String sql = "CALL sp_obtener_permisos_por_roles(?)";

        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement stmt = conn.prepareCall(sql)) {

            // Convertimos los roles a una cadena separada por comas
            String rolesCSV = String.join(",", roles);
            stmt.setString(1, rolesCSV);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Permiso permiso = new Permiso();
                permiso.setNombre(rs.getString("nombre"));
                permiso.setDescripcion(rs.getString("descripcion"));
                permisos.add(permiso);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return permisos;
    }

    public boolean existeUsuarioPorDniYCorreo(String dni, String correo) {
        boolean existe = false;

        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement cs = conn.prepareCall("{CALL sp_validar_usuario_dni_correo(?, ?, ?)}")) {

            cs.setString(1, dni);
            cs.setString(2, correo);
            cs.registerOutParameter(3, Types.BOOLEAN);
            cs.execute();

            existe = cs.getBoolean(3);

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return existe;
    }
    
    public String obtenerNombreCompletoPorDni(String dni) {
    String nombreCompleto = "";

    try (Connection conn = DatabaseConfig.getConnection();
         CallableStatement cs = conn.prepareCall("{CALL sp_obtener_nombre_por_dni(?, ?)}")) {

        cs.setString(1, dni);
        cs.registerOutParameter(2, Types.VARCHAR);
        cs.execute();

        nombreCompleto = cs.getString(2);

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return nombreCompleto != null ? nombreCompleto : "usuario";
}

    public boolean actualizarClavePorDni(String dni, String nuevaClave) {
        Connection conn = null;
        CallableStatement stmt = null;
        boolean actualizado = false;

        try {
            conn = DatabaseConfig.getConnection();

            String hash = BCrypt.hashpw(nuevaClave, BCrypt.gensalt());

            stmt = conn.prepareCall("{CALL sp_actualizar_clave_usuario(?, ?)}");
            stmt.setString(1, dni);
            stmt.setString(2, hash);

            actualizado = stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error al actualizar contraseña: " + e.getMessage());
        } 
        return actualizado;
    }
    
    public boolean crearUsuarioConRoles(Usuario usuario, List<Integer> idsRoles) throws SQLException {
        Connection conn = null;
        CallableStatement stmtUsuario = null;
        CallableStatement stmtRol = null;
        ResultSet rs = null;
        boolean exito = false;

        try {
            conn = DatabaseConfig.getConnection();
            conn.setAutoCommit(false); // Iniciar transacción

            // 1. Crear usuario usando procedimiento almacenado
            stmtUsuario = conn.prepareCall("{ CALL sp_crear_usuario(?, ?, ?, ?, ?, ?, ?, ?, ?) }");
            stmtUsuario.setString(1, usuario.getDni());
            stmtUsuario.setString(2, usuario.getNombres());
            stmtUsuario.setString(3, usuario.getApellidos());
            stmtUsuario.setString(4, usuario.getCorreo());
            stmtUsuario.setString(5, usuario.getTelefono());
            stmtUsuario.setString(6, usuario.getClave());
            stmtUsuario.setBoolean(7, usuario.isEstado());
            stmtUsuario.setTimestamp(8, new java.sql.Timestamp(usuario.getFecRegistro().getTime()));
            stmtUsuario.setString(9, usuario.getFotoPerfil());
            rs = stmtUsuario.executeQuery();

            int idGenerado = -1;
            if (rs.next()) {
                idGenerado = rs.getInt("id_usuario"); // el SP debe retornar esto
            }

            if (idGenerado > 0 && idsRoles != null && !idsRoles.isEmpty()) {
                for (int idRol : idsRoles) {
                    stmtRol = conn.prepareCall("{ CALL sp_asignar_rol_a_usuario(?, ?) }"); // ✅ solo asignar
                    stmtRol.setInt(1, idGenerado);
                    stmtRol.setInt(2, idRol);
                    stmtRol.execute();
                    stmtRol.close();
                }
            }
            conn.commit();
            exito = true;

        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            e.printStackTrace();
            throw e;
        } finally {
            if (rs != null) rs.close();
            if (stmtUsuario != null) stmtUsuario.close();
            if (stmtRol != null) stmtRol.close();
            if (conn != null) conn.setAutoCommit(true);
            if (conn != null) conn.close();
        }

        return exito;
    }
    
    public boolean existeDni(String dni) throws SQLException {
        String sql = "{CALL sp_validar_dni_unico(?, ?)}";
        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement stmt = conn.prepareCall(sql)) {

            stmt.setString(1, dni);
            stmt.registerOutParameter(2, Types.BOOLEAN);
            stmt.execute();
            return stmt.getBoolean(2);
        }
    }

    public List<Usuario> listarUsuariosCompletos() {
        List<Usuario> lista = new ArrayList<>();
        String sql = "CALL sp_listar_usuarios()";

        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement stmt = conn.prepareCall(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Usuario u = new Usuario();
                u.setIdUsuario(rs.getInt("id_usuario"));
                u.setDni(rs.getString("dni"));
                u.setNombres(rs.getString("nombres"));
                u.setApellidos(rs.getString("apellidos"));
                u.setCorreo(rs.getString("correo"));
                u.setTelefono(rs.getString("telefono"));
                u.setFecRegistro(rs.getTimestamp("fec_registro"));
                u.setEstado(rs.getBoolean("estado"));
                u.setFotoPerfil(rs.getString("foto_perfil"));

                // Procesar roles
                String rolesConcatenados = rs.getString("roles");
                List<Rol> roles = new ArrayList<>();
                if (rolesConcatenados != null && !rolesConcatenados.isEmpty()) {
                    for (String nombreRol : rolesConcatenados.split(",")) {
                        Rol rol = new Rol();
                        rol.setNombre(nombreRol.trim());
                        roles.add(rol);
                    }
                }
                u.setRoles(roles);
                lista.add(u);
            }

        } catch (SQLException e) {
            e.printStackTrace(); // Puedes manejar esto con logs
        }

        return lista;
    }
       
    public Usuario obtenerUsuarioCompletoPorId(int idUsuario) {
        Usuario usuario = null;

        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement stmt = conn.prepareCall("{CALL sp_obtener_usuario_por_id(?)}")) {

            stmt.setInt(1, idUsuario);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    usuario = new Usuario();
                    usuario.setIdUsuario(rs.getInt("id_usuario"));
                    usuario.setDni(rs.getString("dni"));
                    usuario.setNombres(rs.getString("nombres"));
                    usuario.setApellidos(rs.getString("apellidos"));
                    usuario.setCorreo(rs.getString("correo"));
                    usuario.setTelefono(rs.getString("telefono"));
                    usuario.setEstado(rs.getBoolean("estado"));
                    usuario.setFecRegistro(rs.getTimestamp("fec_registro"));
                    usuario.setFotoPerfil(rs.getString("foto_perfil"));

                    // Obtener roles
                    List<Rol> roles = obtenerRolesPorUsuario(idUsuario);
                    usuario.setRoles(roles);

                    // Verificamos por tipo de usuario
                    for (Rol rol : roles) {
                        String rolNombre = rol.getNombre().toLowerCase();

                        switch (rolNombre) {
                            case "alumno":
                                Alumno alumno = obtenerDetalleAlumno(idUsuario);
                                if (alumno != null) {
                                    usuario.setAlumno(alumno);
                                    usuario.setEsAlumno(true);
                                }
                                break;

                            case "docente":
                                Docente docente = obtenerDetalleDocente(idUsuario);
                                if (docente != null) {
                                    usuario.setDocente(docente);
                                    usuario.setEsDocente(true);
                                }
                                break;

                            case "apoderado":
                                Apoderado apoderado = new Apoderado();
                                apoderado.setHijos(obtenerHijosDeApoderado(idUsuario));
                                usuario.setApoderado(apoderado);
                                usuario.setEsApoderado(true);
                                break;
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return usuario;
    }
    
    public Alumno obtenerDetalleAlumno(int idAlumno) {
        Alumno alumno = null;
        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement stmt = conn.prepareCall("{CALL sp_detalle_alumno(?)}")) {

            stmt.setInt(1, idAlumno);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                alumno = new Alumno();
                alumno.setCodigoMatricula(rs.getString("codigo_matricula"));
                alumno.setGrado(rs.getString("grado"));
                alumno.setSeccion(rs.getString("seccion"));
                alumno.setNivel(rs.getString("nivel"));
                alumno.setAnio(rs.getString("anio"));
                alumno.setNombreApoderado(rs.getString("nombre_apoderado"));
                alumno.setParentescoApoderado(rs.getString("parentesco"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return alumno;
    }
    
    public Docente obtenerDetalleDocente(int idDocente) {
        Docente docente = new Docente();
        List<Curso> cursos = new ArrayList<>();

        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement stmt = conn.prepareCall("{CALL sp_detalle_docente(?)}")) {

            stmt.setInt(1, idDocente);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Curso curso = new Curso();
                curso.setNombreCurso(rs.getString("curso"));
                curso.setGrado(rs.getString("grado"));
                curso.setSeccion(rs.getString("seccion"));
                curso.setNivel(rs.getString("nivel"));
                curso.setAnio(rs.getString("anio"));
                cursos.add(curso);
            }

            if (!cursos.isEmpty()) {
                docente.setCursos(cursos);
                docente.setTotalCursos(cursos.size());
                return docente;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<Alumno> obtenerHijosDeApoderado(int idUsuarioApoderado) {
        List<Alumno> hijos = new ArrayList<>();

        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement stmt = conn.prepareCall("{CALL sp_obtener_hijos_por_apoderado(?)}")) {

            stmt.setInt(1, idUsuarioApoderado);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Alumno hijo = new Alumno();
                hijo.setParentescoApoderado(rs.getString("parentesco"));
                hijo.setNombres(rs.getString("nombres"));
                hijo.setApellidos(rs.getString("apellidos"));
                hijo.setCodigoMatricula(rs.getString("codigo_matricula"));
                hijo.setAnio(rs.getString("anio"));
                hijo.setNivel(rs.getString("nivel"));
                hijo.setGrado(rs.getString("grado"));
                hijo.setSeccion(rs.getString("seccion"));
                hijos.add(hijo);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return hijos;
    }
    
    public List<Rol> listarTodosLosRoles() {
        List<Rol> lista = new ArrayList<>();
        String sql = "CALL sp_listar_todos_roles()";

        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement stmt = conn.prepareCall(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Rol rol = new Rol();
                rol.setIdRol(rs.getInt("id_rol"));
                rol.setNombre(rs.getString("nombre"));
                rol.setDescripcion(rs.getString("descripcion"));
                lista.add(rol);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }
    
    public void registrarBitacora(int idUsuario, String modulo, String accion) {
        String sql = "{CALL sp_registrar_bitacora(?, ?, ?)}";

        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement stmt = conn.prepareCall(sql)) {

            stmt.setInt(1, idUsuario);
            stmt.setString(2, modulo);
            stmt.setString(3, accion);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error al registrar en bitácora: " + e.getMessage());
        }
    }

    public List<Map<String, Object>> obtenerBitacoraPorUsuario(int idUsuario) {
        List<Map<String, Object>> registros = new ArrayList<>();
        String sql = "CALL sp_bitacora_por_usuario(?)";

        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement stmt = conn.prepareCall(sql)) {

            stmt.setInt(1, idUsuario);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> registro = new HashMap<>();
                registro.put("modulo", rs.getString("modulo"));
                registro.put("accion", rs.getString("accion"));
                registro.put("fecha", rs.getTimestamp("fecha"));
                registros.add(registro);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return registros;
    }

    public void actualizarUsuario(Usuario usuario, List<Integer> rolesSeleccionados) {
        try (Connection conn = DatabaseConfig.getConnection()) {

            // 1. Actualizar datos personales vía SP
            try (CallableStatement stmt = conn.prepareCall("{CALL sp_actualizar_usuario(?, ?, ?, ?, ?, ?, ?, ?)}")) {
                stmt.setInt(1, usuario.getIdUsuario());
                stmt.setString(2, usuario.getDni());
                stmt.setString(3, usuario.getNombres());
                stmt.setString(4, usuario.getApellidos());
                stmt.setString(5, usuario.getCorreo());
                stmt.setString(6, usuario.getTelefono());
                stmt.setBoolean(7, usuario.isEstado());
                stmt.setString(8, usuario.getFotoPerfil());
                stmt.executeUpdate();
            }

            // 2. Eliminar roles actuales
            try (CallableStatement stmt = conn.prepareCall("{CALL sp_actualizar_roles_usuario(?)}")) {
                stmt.setInt(1, usuario.getIdUsuario());
                stmt.executeUpdate();
            }

            // 3. Insertar nuevos roles directamente (más simple que un SP por lotes)
            try (CallableStatement stmt = conn.prepareCall("{CALL sp_insertar_usuario_rol(?, ?)}")) {
                for (int idRol : rolesSeleccionados) {
                    stmt.setInt(1, usuario.getIdUsuario());
                    stmt.setInt(2, idRol);
                    stmt.addBatch();
                }
                stmt.executeBatch();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public void cambiarEstadoUsuario(int idUsuario, boolean estado) throws SQLException {
        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement stmt = conn.prepareCall("{CALL sp_actualizar_estado_usuario(?, ?)}")) {
            stmt.setInt(1, idUsuario);
            stmt.setBoolean(2, estado);
            stmt.executeUpdate();
        }
    }

    public List<Usuario> listarUsuariosFiltrados(String estado, String rol, String fecha, String nivel, String grado, String seccion) {
        List<Usuario> lista = new ArrayList<>();
        String sql = "CALL sp_listar_usuarios_filtrados(?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement stmt = conn.prepareCall(sql)) {

            // Conversión segura de parámetros
            stmt.setString(1, (estado != null && !estado.isBlank()) ? estado : null);
            stmt.setObject(2, (rol != null && !rol.isBlank()) ? Integer.parseInt(rol) : null);
            stmt.setString(3, (fecha != null && !fecha.isBlank()) ? fecha : null);
            stmt.setObject(4, (nivel != null && !nivel.isBlank()) ? Integer.parseInt(nivel) : null);
            stmt.setObject(5, (grado != null && !grado.isBlank()) ? Integer.parseInt(grado) : null);
            stmt.setObject(6, (seccion != null && !seccion.isBlank()) ? Integer.parseInt(seccion) : null);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Usuario u = new Usuario();
                u.setIdUsuario(rs.getInt("id_usuario"));
                u.setDni(rs.getString("dni"));
                u.setNombres(rs.getString("nombres"));
                u.setApellidos(rs.getString("apellidos"));
                u.setCorreo(rs.getString("correo"));
                u.setTelefono(rs.getString("telefono"));
                u.setEstado(rs.getBoolean("estado"));
                u.setFecRegistro(rs.getTimestamp("fec_registro"));
                u.setFotoPerfil(rs.getString("foto_perfil"));

                String rolesConcatenados = rs.getString("roles");
                List<Rol> rolesList = new ArrayList<>();
                if (rolesConcatenados != null && !rolesConcatenados.isEmpty()) {
                    for (String nombreRol : rolesConcatenados.split(",")) {
                        Rol r = new Rol();
                        r.setNombre(nombreRol.trim());
                        rolesList.add(r);
                    }
                }
                u.setRoles(rolesList);
                lista.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return lista;
    }
}

