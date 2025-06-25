package com.intranet_escolar.dao;

import com.intranet_escolar.config.DatabaseConfig;
import com.intranet_escolar.model.entity.Criterio;
import java.sql.*;
import java.util.*;

public class CriterioDAO {

    // Listar todos los criterios
    public List<Criterio> listarTodos() {
        List<Criterio> lista = new ArrayList<>();
        String sql = "{CALL sp_listar_criterios()}";
        try (Connection con = DatabaseConfig.getConnection();
             CallableStatement cs = con.prepareCall(sql);
             ResultSet rs = cs.executeQuery()) {
            while (rs.next()) {
                Criterio c = new Criterio();
                c.setIdCriterio(rs.getInt("id_criterio"));
                c.setNombre(rs.getString("nombre"));
                c.setBase(rs.getDouble("base"));
                c.setDescripcion(rs.getString("descripcion"));
                c.setActivo(rs.getBoolean("activo"));
                lista.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public void agregar(Criterio c) {
        String sql = "{CALL sp_agregar_criterio(?, ?, ?, ?)}";
        try (Connection con = DatabaseConfig.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {
            cs.setString(1, c.getNombre());
            cs.setDouble(2, c.getBase());
            cs.setString(3, c.getDescripcion());
            cs.setBoolean(4, c.isActivo());
            cs.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void editar(Criterio c) {
        String sql = "{CALL sp_editar_criterio(?, ?, ?, ?, ?)}";
        try (Connection con = DatabaseConfig.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {
            cs.setInt(1, c.getIdCriterio());
            cs.setString(2, c.getNombre());
            cs.setDouble(3, c.getBase());
            cs.setString(4, c.getDescripcion());
            cs.setBoolean(5, c.isActivo());
            cs.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void desactivar(int idCriterio) {
        String sql = "{CALL sp_desactivar_criterio(?)}";
        try (Connection con = DatabaseConfig.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {
            cs.setInt(1, idCriterio);
            cs.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
