
package com.intranet_escolar.dao;

import java.sql.*;
import java.util.*;
import org.mindrot.jbcrypt.BCrypt;
import com.intranet_escolar.config.DatabaseConfig;
import com.intranet_escolar.model.entity.Alumno;
import com.intranet_escolar.model.entity.Apoderado;
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

            while (rs.next()) {
                if (usuario == null) {
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
                }

                int idRol = rs.getInt("id_rol");
                String nombreRol = rs.getString("rol_nombre");
                String descripcionRol = rs.getString("rol_descripcion");

                if (!rolesMap.containsKey(idRol)) {
                    rolesMap.put(idRol, new Rol(idRol, nombreRol, descripcionRol));
                }
            }

            if (usuario != null && claveHasheadaBD != null) {
                
                System.out.println("Clave ingresada (texto plano): " + claveIngresada);
                System.out.println("Clave hash desde BD: " + claveHasheadaBD);

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

                // Si es estudiante
                String codigoMatricula = rs.getString("codigo_matricula");
                if (codigoMatricula != null) {
                    Alumno alumno = new Alumno();
                    alumno.setCodigo_matricula(codigoMatricula);
                    alumno.setGrado(rs.getString("grado"));
                    alumno.setSeccion(rs.getString("seccion"));
                    u.setAlumno(alumno);
                    u.setEsAlumno(true);
                }

                // Si es docente
                int totalCursos = rs.getInt("total_cursos");
                if (totalCursos > 0) {
                    Docente docente = new Docente();
                    docente.setTotalCursos(totalCursos);
                    u.setDocente(docente);
                    u.setEsDocente(true);
                }

                // Si es apoderado
                int totalHijos = rs.getInt("total_hijos");
                if (totalHijos > 0) {
                    Apoderado apoderado = new Apoderado();
                    apoderado.setHijos(new ArrayList<>(Collections.nCopies(totalHijos, new Alumno())));
                    u.setApoderado(apoderado);
                    u.setEsApoderado(true);
                }

                lista.add(u);
            }

        } catch (SQLException e) {
            e.printStackTrace(); // Puedes manejar esto con logs
        }

        return lista;
    }
}


