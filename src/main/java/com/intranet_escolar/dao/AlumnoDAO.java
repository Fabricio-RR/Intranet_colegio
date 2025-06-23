package com.intranet_escolar.dao;

import com.intranet_escolar.config.DatabaseConfig;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AlumnoDAO {

    // Llama al SP para insertar alumno si no existe
    public String insertarAlumnoSiNoExiste(int idAlumno, int idAperturaSeccion, int anio) {
        String codigoMatricula = null;
        String call = "{CALL sp_insertar_alumno_si_no_existe(?, ?, ?)}";
        String select = "SELECT codigo_matricula FROM alumno WHERE id_alumno = ?";
        try (Connection conn = DatabaseConfig.getConnection()) {
            // Ejecuta el SP
            try (CallableStatement cs = conn.prepareCall(call)) {
                cs.setInt(1, idAlumno);
                cs.setInt(2, idAperturaSeccion);
                cs.setInt(3, anio);
                cs.execute();
            }
            // Consulta el código de matrícula
            try (PreparedStatement ps = conn.prepareStatement(select)) {
                ps.setInt(1, idAlumno);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        codigoMatricula = rs.getString("codigo_matricula");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return codigoMatricula;
    }
}
