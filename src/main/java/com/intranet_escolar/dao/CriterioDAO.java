package com.intranet_escolar.dao;

import com.intranet_escolar.config.DatabaseConfig;
import com.intranet_escolar.model.entity.Criterio;
import com.intranet_escolar.model.entity.MallaCriterio;
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
    /*
    public List<MallaCriterio> listarMallaCriteriosPorFiltros(int idCurso, int idSeccion, int idPeriodo, int idAnioLectivo) {
        List<MallaCriterio> lista = new ArrayList<>();
        String sql = "{CALL sp_listar_malla_criterios(?, ?, ?, ?)}";
        try (Connection con = DatabaseConfig.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {
            cs.setInt(1, idCurso);
            cs.setInt(2, idSeccion);
            cs.setInt(3, idPeriodo);
            cs.setInt(4, idAnioLectivo);
            try (ResultSet rs = cs.executeQuery()) {
                while (rs.next()) {
                    MallaCriterio mc = new MallaCriterio();
                    mc.setIdMallaCriterio(rs.getInt("id_malla_criterio"));
                    mc.setIdMallaCurricular(rs.getInt("id_malla_curricular"));
                    mc.setIdPeriodo(rs.getInt("id_periodo"));
                    mc.setIdCriterio(rs.getInt("id_criterio"));
                    mc.setCriterioNombre(rs.getString("criterio_nombre"));
                    mc.setCriterioDescripcion(rs.getString("criterio_descripcion"));
                    mc.setBase(rs.getDouble("base"));
                    mc.setTipo(rs.getString("tipo"));
                    mc.setFormula(rs.getString("formula"));
                    mc.setActivo(rs.getBoolean("activo"));
                    lista.add(mc);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }*/
    public List<MallaCriterio> listarMallaCriteriosPorFiltros(
        int idCurso, int idSeccion, int idPeriodo, int idAnioLectivo) {
        List<MallaCriterio> lista = new ArrayList<>();
        String sql = "SELECT " +
                "mc.id_malla_criterio, mc.id_malla_curricular, mc.id_periodo, mc.id_criterio, " +
                "c.nombre AS criterio_nombre, c.descripcion AS criterio_descripcion, " +
                "c.base, mc.tipo, mc.formula, mc.activo " +
            "FROM malla_criterio mc " +
            "INNER JOIN criterio c ON mc.id_criterio = c.id_criterio " +
            "INNER JOIN malla_curricular mcu ON mc.id_malla_curricular = mcu.id_malla_curricular " +
            "INNER JOIN apertura_seccion aps ON mcu.id_apertura_seccion = aps.id_apertura_seccion " +
            "WHERE mcu.id_curso = ? " +
            "AND aps.id_seccion = ? " +
            "AND mc.id_periodo = ? " +
            "AND aps.id_anio_lectivo = ? " +
            "AND mc.activo = 1";
        try (Connection con = DatabaseConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idCurso);
            ps.setInt(2, idSeccion);
            ps.setInt(3, idPeriodo);
            ps.setInt(4, idAnioLectivo);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MallaCriterio mc = new MallaCriterio();
                    mc.setIdMallaCriterio(rs.getInt("id_malla_criterio"));
                    mc.setIdMallaCurricular(rs.getInt("id_malla_curricular"));
                    mc.setIdPeriodo(rs.getInt("id_periodo"));
                    mc.setIdCriterio(rs.getInt("id_criterio"));
                    mc.setCriterioNombre(rs.getString("criterio_nombre"));
                    mc.setCriterioDescripcion(rs.getString("criterio_descripcion"));
                    mc.setBase(rs.getDouble("base")); // Ahora sí es c.base
                    mc.setTipo(rs.getString("tipo"));
                    mc.setFormula(rs.getString("formula"));
                    mc.setActivo(rs.getBoolean("activo"));
                    lista.add(mc);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }
}
