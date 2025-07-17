package com.intranet_escolar.dao;

import com.intranet_escolar.config.DatabaseConfig;
import com.intranet_escolar.model.entity.AnioLectivo;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class AnioLectivoDAO {
    public int obtenerIdAnioLectivoPorNombre(int nombreAnio) {
        int id = 0;
        String sql = "SELECT id_anio_lectivo FROM anio_lectivo WHERE nombre = ? AND estado = 'activo' LIMIT 1";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, String.valueOf(nombreAnio));
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    id = rs.getInt("id_anio_lectivo");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return id;
    }
    public List<AnioLectivo> obtenerAniosDisponibles() {
        List<AnioLectivo> anios = new ArrayList<>();
        String sql = "{CALL sp_listar_anios_disponibles()}";
        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement stmt = conn.prepareCall(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                AnioLectivo anio = new AnioLectivo();
                anio.setIdAnioLectivo(rs.getInt("id_anio_lectivo"));
                anio.setNombre(rs.getString("nombre"));
                anio.setFecInicio(rs.getDate("fec_inicio"));
                anio.setFecFin(rs.getDate("fec_fin"));
                anio.setEstado(rs.getString("estado"));
                anios.add(anio);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return anios;
    }

    public int obtenerAnioActivo() {
        int idAnio = 0;
        String sql = "{CALL sp_obtener_anio_activo()}";
        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement stmt = conn.prepareCall(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                idAnio = rs.getInt("id_anio_lectivo");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return idAnio;
    }

    public List<AnioLectivo> listarTodos() {
        List<AnioLectivo> anios = new ArrayList<>();
        String sql = "SELECT id_anio_lectivo, nombre, fec_inicio, fec_fin, estado " +
                     "FROM anio_lectivo " +
                     "WHERE LOWER(estado) IN ('activo', 'preparacion') " +
                     "ORDER BY nombre DESC";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                AnioLectivo anio = new AnioLectivo();
                anio.setIdAnioLectivo(rs.getInt("id_anio_lectivo"));
                anio.setNombre(rs.getString("nombre"));
                anio.setFecInicio(rs.getDate("fec_inicio"));
                anio.setFecFin(rs.getDate("fec_fin"));
                anio.setEstado(rs.getString("estado"));
                anios.add(anio);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return anios;
    }

    public String obtenerNombrePorId(int idAnioLectivo) {
        String nombre = "";
        String sql = "SELECT nombre FROM anio_lectivo WHERE id_anio_lectivo = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idAnioLectivo);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    nombre = rs.getString("nombre");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return nombre;
    }
    public boolean crear(AnioLectivo a) {
        String sql = "INSERT INTO anio_lectivo(nombre, fec_inicio, fec_fin, estado) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, a.getNombre());
            stmt.setDate(2, new java.sql.Date(a.getFecInicio().getTime()));
            stmt.setDate(3, new java.sql.Date(a.getFecFin().getTime()));
            stmt.setString(4, a.getEstado());
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
        
    public boolean editar(AnioLectivo a) {
        String sql = "UPDATE anio_lectivo SET nombre=?, fec_inicio=?, fec_fin=?, estado=? WHERE id_anio_lectivo=?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, a.getNombre());
            stmt.setDate(2, new java.sql.Date(a.getFecInicio().getTime()));
            stmt.setDate(3, new java.sql.Date(a.getFecFin().getTime()));
            stmt.setString(4, a.getEstado());
            stmt.setInt(5, a.getIdAnioLectivo());
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean cambiarEstado(int id, String estado) {
        String sql = "UPDATE anio_lectivo SET estado=? WHERE id_anio_lectivo=?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, estado);
            stmt.setInt(2, id);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }   

}
