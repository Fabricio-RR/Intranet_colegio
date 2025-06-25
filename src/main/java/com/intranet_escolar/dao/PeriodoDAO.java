package com.intranet_escolar.dao;

import com.intranet_escolar.config.DatabaseConfig;
import com.intranet_escolar.model.entity.Periodo;
import java.sql.*;
import java.util.*;

public class PeriodoDAO {
    public List<Periodo> listarTodos() {
        List<Periodo> lista = new ArrayList<>();
        String sql = "{CALL sp_listar_periodos()}";
        try (Connection con = DatabaseConfig.getConnection();
             CallableStatement cs = con.prepareCall(sql);
             ResultSet rs = cs.executeQuery()) {
            while (rs.next()) {
                Periodo p = new Periodo();
                p.setIdPeriodo(rs.getInt("id_periodo"));
                p.setNombre(rs.getString("nombre"));
                // ...otros campos
                lista.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
}
