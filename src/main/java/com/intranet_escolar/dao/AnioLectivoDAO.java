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
                anios.add(new AnioLectivo(
                    rs.getInt("id_anio_lectivo"),
                    rs.getString("nombre")
                ));
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

    public List<AnioLectivo> obtenerAniosParaMatricula() {
        List<AnioLectivo> anios = new ArrayList<>();
        String sql = "SELECT id_anio_lectivo, nombre FROM anio_lectivo WHERE estado IN ('activo', 'preparacion') ORDER BY nombre DESC";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                anios.add(new AnioLectivo(
                    rs.getInt("id_anio_lectivo"),
                    rs.getString("nombre")
                ));
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
}
