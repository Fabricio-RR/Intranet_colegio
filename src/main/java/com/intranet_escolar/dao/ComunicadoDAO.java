package com.intranet_escolar.dao;

import com.intranet_escolar.config.DatabaseConfig;
import com.intranet_escolar.model.entity.Comunicado;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
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
                    c.setFecInicio(rs.getString("fec_inicio"));
                    c.setFecFin(rs.getString("fec_fin"));
                    c.setArchivo(rs.getString("archivo"));
                    c.setEstado(rs.getString("estado"));
                    c.setNotificarCorreo(rs.getBoolean("notificar_correo"));
                    c.setIdAnioLectivo(idAnioLectivo);
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
                    c.setFecInicio(rs.getString("fec_inicio"));
                    c.setFecFin(rs.getString("fec_fin"));
                    c.setArchivo(rs.getString("archivo"));
                    c.setEstado(rs.getString("estado"));
                    c.setNotificarCorreo(rs.getBoolean("notificar_correo"));
                    c.setIdAnioLectivo(rs.getInt("id_anio_lectivo"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return c;
    }

    public boolean guardar(Comunicado c) {
        String sql = "{CALL sp_guardar_comunicado(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}";

        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {

            cs.setInt(1, c.getIdUsuario());
            cs.setString(2, c.getTitulo());
            cs.setString(3, c.getContenido());
            cs.setString(4, c.getCategoria());
            cs.setString(5, c.getDestinatario());
            cs.setBoolean(6, c.isNotificarCorreo());
            cs.setString(7, c.getFecInicio());
            cs.setString(8, c.getFecFin());
            cs.setString(9, c.getArchivo());
            cs.setInt(10, c.getIdAnioLectivo());

            return cs.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean actualizar(Comunicado c) {
        String sql = "{CALL sp_actualizar_comunicado(?, ?, ?, ?, ?, ?, ?, ?, ?)}";

        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {

            cs.setInt(1, c.getId());
            cs.setString(2, c.getTitulo());
            cs.setString(3, c.getContenido());
            cs.setString(4, c.getCategoria());
            cs.setString(5, c.getDestinatario());
            cs.setBoolean(6, c.isNotificarCorreo());
            cs.setString(7, c.getFecInicio());
            cs.setString(8, c.getFecFin());
            cs.setString(9, c.getArchivo());

            return cs.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean eliminar(int id) {
        String sql = "{CALL sp_eliminar_comunicado(?)}";

        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {

            cs.setInt(1, id);
            return cs.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
