package com.intranet_escolar.dao;

import com.intranet_escolar.config.DatabaseConfig;
import com.intranet_escolar.model.entity.Usuario;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DocenteDAO {

    public List<Usuario> listarTodos() {
        List<Usuario> docentes = new ArrayList<>();
        String sql = "{CALL sp_listar_docentes_activos()}";

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
                docentes.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return docentes;
    }
}