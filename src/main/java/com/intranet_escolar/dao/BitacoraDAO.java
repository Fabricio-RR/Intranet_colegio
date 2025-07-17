package com.intranet_escolar.dao;

import com.intranet_escolar.config.DatabaseConfig;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BitacoraDAO {
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

    
}
