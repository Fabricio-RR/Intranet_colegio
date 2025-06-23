package com.intranet_escolar.util;

import com.intranet_escolar.config.DatabaseConfig;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class BitacoraUtil {

    public static void registrar(int idUsuario, String modulo, String accion) {
        String sql = "{CALL sp_registrar_bitacora(?, ?, ?)}";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareCall(sql)) {
            ps.setInt(1, idUsuario);
            ps.setString(2, modulo);
            ps.setString(3, accion);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace(); // Si falla, solo lo loguea
        }
    }
}
