package com.intranet_escolar.dao;

import com.intranet_escolar.config.DatabaseConfig;
import com.intranet_escolar.model.entity.Periodo;
import java.sql.*;
import java.util.*;

public class PeriodoDAO {
    public List<Periodo> listarTodos() {
        List<Periodo> lista = new ArrayList<>();
        String sql = "SELECT id_periodo, CONCAT('Bimestre ', UPPER(bimestre), ' - Mes ', mes) AS nombre FROM periodo WHERE estado='habilitado' ORDER BY id_periodo";
        try (Connection con = DatabaseConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Periodo p = new Periodo();
                p.setIdPeriodo(rs.getInt("id_periodo"));
                p.setNombre(rs.getString("nombre")); // Asegúrate de que tu modelo Periodo tenga un atributo 'nombre'
                lista.add(p);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return lista;
    }
}
