package com.intranet_escolar.dao;

import com.intranet_escolar.config.DatabaseConfig;
import com.intranet_escolar.model.entity.Periodo;
import java.sql.*;
import java.util.*;
import static org.apache.commons.lang3.StringUtils.capitalize;

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
    public List<Periodo> listarPorAnioLectivo(int idAnioLectivo) {
        List<Periodo> lista = new ArrayList<>();
        String sql = "{CALL sp_listar_periodos_por_anio_lectivo(?)}";
        try (Connection con = DatabaseConfig.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {
            cs.setInt(1, idAnioLectivo);
            try (ResultSet rs = cs.executeQuery()) {
                while (rs.next()) {
                    Periodo p = new Periodo();
                    p.setIdPeriodo(rs.getInt("id_periodo"));
                    p.setBimestre(rs.getString("bimestre"));
                    p.setMes(rs.getString("mes"));
                    p.setTipo(rs.getString("tipo"));
                    p.setFecInicio(rs.getDate("fec_inicio"));
                    p.setFecFin(rs.getDate("fec_fin"));
                    p.setFecCierre(rs.getDate("fec_cierre"));
                    p.setEstado(rs.getString("estado"));
                    //nombre Periodo
                    String nombrePeriodo = "Bimestre " + p.getBimestre();
                    if (p.getMes() != null) nombrePeriodo += " - Mes " + p.getMes();
                    p.setNombre(nombrePeriodo);
                    lista.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

}
