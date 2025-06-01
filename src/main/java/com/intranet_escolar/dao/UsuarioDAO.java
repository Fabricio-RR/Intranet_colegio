
package com.intranet_escolar.dao;

import java.sql.*;
import java.util.*;
import org.mindrot.jbcrypt.BCrypt;
import com.intranet_escolar.config.DatabaseConfig;
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

    public List<Permiso> obtenerPermisos(List<Rol> roles) {
        List<Permiso> permisos = new ArrayList<>();
        if (roles == null || roles.isEmpty()) return permisos;

        String sql = "SELECT DISTINCT p.id_permiso, p.nombre, p.descripcion " +
                     "FROM permiso p " +
                     "INNER JOIN rol_permiso rp ON p.id_permiso = rp.id_permiso " +
                     "WHERE rp.id_rol IN (%s)";
        String placeholders = String.join(",", Collections.nCopies(roles.size(), "?"));
        sql = String.format(sql, placeholders);

        try (Connection con = DatabaseConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            for (int i = 0; i < roles.size(); i++) {
                ps.setInt(i + 1, roles.get(i).getIdRol());
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Permiso permiso = new Permiso();
                    permiso.setIdPermiso(rs.getInt("id_permiso"));
                    permiso.setNombre(rs.getString("nombre"));
                    permiso.setDescripcion(rs.getString("descripcion"));
                    permisos.add(permiso);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error obteniendo permisos: " + e.getMessage());
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
}


