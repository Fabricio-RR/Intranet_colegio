package com.intranet_escolar.dao;

import com.intranet_escolar.config.DatabaseConfig;
import com.intranet_escolar.model.entity.MallaCriterio;
import java.sql.*;
import java.util.*;

public class MallaCriterioDAO {

    // Listar criterios asignados a malla y periodo
    public List<MallaCriterio> listarPorMallaYPeriodo(int idMallaCurricular, int idPeriodo) {
        List<MallaCriterio> lista = new ArrayList<>();
        String sql = "{CALL sp_listar_malla_criterios_por_malla_periodo(?, ?)}";
        try (Connection con = DatabaseConfig.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {
            cs.setInt(1, idMallaCurricular);
            cs.setInt(2, idPeriodo);
            try (ResultSet rs = cs.executeQuery()) {
                while (rs.next()) {
                    MallaCriterio mc = new MallaCriterio();
                    mc.setIdMallaCriterio(rs.getInt("id_malla_criterio"));
                    mc.setIdMallaCurricular(rs.getInt("id_malla_curricular"));
                    mc.setIdPeriodo(rs.getInt("id_periodo"));
                    mc.setIdCriterio(rs.getInt("id_criterio"));
                    mc.setCriterioNombre(rs.getString("criterio_nombre"));
                    mc.setBase(rs.getDouble("base"));
                    mc.setTipo(rs.getString("tipo"));
                    mc.setFormula(rs.getString("formula"));
                    mc.setActivo(rs.getBoolean("activo"));
                    lista.add(mc);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public void agregar(MallaCriterio m) {
        String sql = "{CALL sp_agregar_malla_criterio(?, ?, ?, ?, ?, ?)}";
        try (Connection con = DatabaseConfig.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {
            cs.setInt(1, m.getIdMallaCurricular());
            cs.setInt(2, m.getIdPeriodo());
            cs.setInt(3, m.getIdCriterio());
            cs.setString(4, m.getTipo());
            cs.setString(5, m.getFormula());
            cs.setBoolean(6, m.isActivo());
            cs.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void editar(MallaCriterio m) {
        String sql = "{CALL sp_editar_malla_criterio(?, ?, ?, ?, ?, ?)}";
        try (Connection con = DatabaseConfig.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {
            cs.setInt(1, m.getIdMallaCriterio());
            cs.setInt(2, m.getIdCriterio());
            cs.setString(3, m.getTipo());
            cs.setString(4, m.getFormula());
            cs.setBoolean(5, m.isActivo());
            cs.setInt(6, m.getIdPeriodo()); // Si tu SP lo pide, sino elimina este parámetro
            cs.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void desactivar(int idMallaCriterio) {
        String sql = "{CALL sp_desactivar_malla_criterio(?)}";
        try (Connection con = DatabaseConfig.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {
            cs.setInt(1, idMallaCriterio);
            cs.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
