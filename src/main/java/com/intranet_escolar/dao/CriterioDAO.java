package com.intranet_escolar.dao;

import com.intranet_escolar.config.DatabaseConfig;
import com.intranet_escolar.model.entity.Criterio;
import java.sql.*;
import java.util.*;

public class CriterioDAO {
    // Listar criterios por curso y periodo (usando SP)
    public List<Criterio> listarPorCursoPeriodo(int idCurso, int idPeriodo) {
        List<Criterio> lista = new ArrayList<>();
        String sql = "{CALL sp_listar_criterios_por_curso_periodo(?, ?)}";
        try (Connection con = DatabaseConfig.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {
            cs.setInt(1, idCurso);
            cs.setInt(2, idPeriodo);
            try (ResultSet rs = cs.executeQuery()) {
                while (rs.next()) {
                    Criterio c = new Criterio();
                    c.setIdCriterio(rs.getInt("id_criterio"));
                    c.setNombre(rs.getString("nombre"));
                    c.setDescripcion(rs.getString("descripcion"));
                    c.setActivo(rs.getBoolean("activo"));
                    c.setIdCurso(rs.getInt("id_curso"));
                    c.setIdPeriodo(rs.getInt("id_periodo"));
                    lista.add(c);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return lista;
    }

    // Agregar criterio (usando SP)
    public boolean agregar(Criterio c) {
        String sql = "{CALL sp_agregar_criterio(?,?,?,?)}";
        try (Connection con = DatabaseConfig.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {
            cs.setString(1, c.getNombre());
            cs.setString(2, c.getDescripcion());
            cs.setInt(3, c.getIdCurso());
            cs.setInt(4, c.getIdPeriodo());
            return cs.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    // Editar criterio (usando SP)
    public boolean editar(Criterio c) {
        String sql = "{CALL sp_editar_criterio(?,?,?)}";
        try (Connection con = DatabaseConfig.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {
            cs.setInt(1, c.getIdCriterio());
            cs.setString(2, c.getNombre());
            cs.setString(3, c.getDescripcion());
            return cs.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    // Eliminar criterio (usando SP, soft delete)
    public boolean eliminar(int idCriterio) {
        String sql = "{CALL sp_eliminar_criterio(?)}";
        try (Connection con = DatabaseConfig.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {
            cs.setInt(1, idCriterio);
            return cs.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }
}
