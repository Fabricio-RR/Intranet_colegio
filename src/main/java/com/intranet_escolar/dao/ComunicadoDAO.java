package com.intranet_escolar.dao;

import com.intranet_escolar.config.DatabaseConfig;
import com.intranet_escolar.model.entity.Comunicado;
import com.intranet_escolar.model.entity.Usuario;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComunicadoDAO {

    public List<Comunicado> listarPorAnio(int idAnioLectivo) {
        List<Comunicado> lista = new ArrayList<>();
        String sql = "{CALL sp_listar_comunicados_por_anio(?)}";

        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {

            cs.setInt(1, idAnioLectivo);
            try (ResultSet rs = cs.executeQuery()) {
                while (rs.next()) {
                    Comunicado c = new Comunicado();
                    c.setId(rs.getInt("id_publicacion"));
                    c.setIdUsuario(rs.getInt("id_usuario"));
                    c.setTitulo(rs.getString("titulo"));
                    c.setContenido(rs.getString("contenido"));
                    c.setCategoria(rs.getString("categoria"));
                    c.setDestinatario(rs.getString("destinatario"));
                    c.setDestinatarioSeccion(rs.getString("destinatario_seccion"));
                    c.setIdAperturaSeccion(rs.getObject("id_apertura_seccion") != null ? rs.getInt("id_apertura_seccion") : null);
                    c.setNotificarCorreo(rs.getBoolean("notificar_correo"));
                    c.setFecInicio(rs.getDate("fec_inicio"));
                    c.setFecFin(rs.getDate("fec_fin"));
                    c.setArchivo(rs.getString("archivo"));
                    c.setEstado(rs.getString("estado"));
                    c.setIdAnioLectivo(rs.getInt("id_anio_lectivo"));
                    lista.add(c);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    public Comunicado obtenerPorId(int id) {
        Comunicado c = null;
        String sql = "{CALL sp_obtener_comunicado_por_id(?)}";

        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {

            cs.setInt(1, id);
            try (ResultSet rs = cs.executeQuery()) {
                if (rs.next()) {
                    c = new Comunicado();
                    c.setId(rs.getInt("id_publicacion"));
                    c.setIdUsuario(rs.getInt("id_usuario"));
                    c.setTitulo(rs.getString("titulo"));
                    c.setContenido(rs.getString("contenido"));
                    c.setCategoria(rs.getString("categoria"));
                    c.setDestinatario(rs.getString("destinatario"));
                    c.setDestinatarioSeccion(rs.getString("destinatario_seccion"));
                    c.setIdAperturaSeccion(rs.getObject("id_apertura_seccion") != null ? rs.getInt("id_apertura_seccion") : null);
                    c.setNotificarCorreo(rs.getBoolean("notificar_correo"));
                    c.setFecInicio(rs.getDate("fec_inicio"));
                    c.setFecFin(rs.getDate("fec_fin"));
                    c.setArchivo(rs.getString("archivo"));
                    c.setEstado(rs.getString("estado"));
                    c.setIdAnioLectivo(rs.getInt("id_anio_lectivo"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return c;
    }

    public boolean guardar(Comunicado c) {
        String sql = "{CALL sp_guardar_comunicado(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}";

        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {

            cs.setInt(1, c.getIdUsuario());
            cs.setString(2, c.getTitulo());
            cs.setString(3, c.getContenido());
            cs.setString(4, c.getCategoria());
            cs.setString(5, c.getDestinatario());

            // destinatario_seccion
            if (c.getDestinatarioSeccion() != null) {
                cs.setString(6, c.getDestinatarioSeccion());
            } else {
                cs.setNull(6, Types.VARCHAR);
            }

            // id_apertura_seccion
            if (c.getIdAperturaSeccion() != null) {
                cs.setInt(7, c.getIdAperturaSeccion());
            } else {
                cs.setNull(7, Types.INTEGER);
            }

            cs.setBoolean(8, c.isNotificarCorreo());
            cs.setDate(9, new java.sql.Date(c.getFecInicio().getTime()));
            cs.setDate(10, new java.sql.Date(c.getFecFin().getTime()));
            cs.setString(11, c.getArchivo());
            cs.setInt(12, c.getIdAnioLectivo());

            return cs.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean actualizar(Comunicado c) {
        String sql = "{CALL sp_actualizar_comunicado(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}";

        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {

            cs.setInt(1, c.getId());
            cs.setString(2, c.getTitulo());
            cs.setString(3, c.getContenido());
            cs.setString(4, c.getCategoria());
            cs.setString(5, c.getDestinatario());

            if (c.getDestinatarioSeccion() != null) {
                cs.setString(6, c.getDestinatarioSeccion());
            } else {
                cs.setNull(6, Types.VARCHAR);
            }

            if (c.getIdAperturaSeccion() != null) {
                cs.setInt(7, c.getIdAperturaSeccion());
            } else {
                cs.setNull(7, Types.INTEGER);
            }

            cs.setBoolean(8, c.isNotificarCorreo());
            cs.setDate(9, new java.sql.Date(c.getFecInicio().getTime()));
            cs.setDate(10, new java.sql.Date(c.getFecFin().getTime()));

            // ✅ Enviar NULL si no hay archivo
            if (c.getArchivo() != null) {
                cs.setString(11, c.getArchivo());
            } else {
                cs.setNull(11, Types.VARCHAR);
            }

            cs.setString(12, c.getEstado());

            return cs.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void desactivar(int idPublicacion) {
        String sql = "{CALL sp_desactivar_comunicado(?)}";
        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {
            cs.setInt(1, idPublicacion);
            cs.execute();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ✅ Nuevo método: obtener correos según destinatario
    public List<String> obtenerCorreosDestinatarios(int idPublicacion) {
        List<String> correos = new ArrayList<>();
        String sql = "{CALL sp_obtener_correos_por_comunicado(?)}";

        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {

            cs.setInt(1, idPublicacion);
            try (ResultSet rs = cs.executeQuery()) {
                while (rs.next()) {
                    correos.add(rs.getString("correo"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return correos;
    }
    public int obtenerIdUltimoComunicadoPorUsuario(int idUsuario) {
        int id = 0;
        String sql = "SELECT id_publicacion FROM publicacion WHERE id_usuario = ? ORDER BY id_publicacion DESC LIMIT 1";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    id = rs.getInt("id_publicacion");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return id;
    }
    public Usuario obtenerUsuarioPorCorreo(String correo) {
        Usuario usuario = null;
        String sql = "SELECT nombres, apellidos FROM usuario WHERE correo = ? LIMIT 1";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, correo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    usuario = new Usuario();
                    usuario.setNombres(rs.getString("nombres"));
                    usuario.setApellidos(rs.getString("apellidos"));
                    usuario.setCorreo(correo);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return usuario;
    }
}
