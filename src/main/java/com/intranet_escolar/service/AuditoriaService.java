package com.intranet_escolar.service;

import com.intranet_escolar.config.DatabaseConfig;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;

public class AuditoriaService {

    /**
     * Registra una acción en la bitácora del sistema.
     *
     * @param idUsuario ID del usuario que realiza la acción
     * @param modulo    Módulo afectado (ej. "Reportes")
     * @param accion    Descripción de la acción (ej. "Descargó consolidado")
     */
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
}
