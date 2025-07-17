package com.intranet_escolar.dao;

import com.intranet_escolar.config.DatabaseConfig;
import com.intranet_escolar.model.entity.Periodo;
import java.sql.*;
import java.util.*;
import static org.apache.commons.lang3.StringUtils.capitalize;

public class PeriodoDAO {
    // Listar todos los periodos (no siempre se usa, solo admin total)
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
                lista.add(p);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    // Listar periodos por año lectivo
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
                    String nombrePeriodo = "Bimestre " + p.getBimestre();
                    if (p.getMes() != null) nombrePeriodo += " - Mes " + p.getMes();
                    p.setNombre(nombrePeriodo);
                    lista.add(p);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }

    // Listar periodos asociados a un curso y año lectivo
    /*public List<Periodo> obtenerPorCurso(int idCurso, int idAnioLectivo) {
        List<Periodo> lista = new ArrayList<>();
        String sql = "{CALL sp_listar_periodos_por_curso(?, ?)}";
        try (Connection con = DatabaseConfig.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {
            cs.setInt(1, idCurso);
            cs.setInt(2, idAnioLectivo);
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
                    String nombrePeriodo = "Bimestre " + p.getBimestre();
                    if (p.getMes() != null) nombrePeriodo += " - Mes " + p.getMes();
                    p.setNombre(nombrePeriodo);
                    lista.add(p);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }*/
    public List<Periodo> obtenerPorCurso(int idCurso, int idAnioLectivo) {
        List<Periodo> lista = new ArrayList<>();
        String sql =
            "SELECT DISTINCT p.id_periodo, p.bimestre, p.mes, p.tipo, p.fec_inicio, p.fec_fin, p.fec_cierre, p.estado " +
            "FROM periodo p " +
            "INNER JOIN malla_criterio mc ON mc.id_periodo = p.id_periodo " +
            "INNER JOIN malla_curricular mcu ON mc.id_malla_curricular = mcu.id_malla_curricular " +
            "WHERE mcu.id_curso = ? " +
            "AND p.id_anio_lectivo = ? " +
            "ORDER BY p.id_periodo";
        try (Connection con = DatabaseConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idCurso);
            ps.setInt(2, idAnioLectivo);
            try (ResultSet rs = ps.executeQuery()) {
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
                    String nombrePeriodo = "Bimestre " + p.getBimestre();
                    if (p.getMes() != null) nombrePeriodo += " - Mes " + p.getMes();
                    p.setNombre(nombrePeriodo);
                    lista.add(p);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }

    // Saber si un periodo está bloqueado (no editable)
    /*
    public boolean estaBloqueado(int idPeriodo, int idAnioLectivo) {
        boolean bloqueado = false;
        String sql = "{CALL sp_periodo_esta_bloqueado(?, ?)}";
        try (Connection con = DatabaseConfig.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {
            cs.setInt(1, idPeriodo);
            cs.setInt(2, idAnioLectivo);
            try (ResultSet rs = cs.executeQuery()) {
                if (rs.next()) {
                    bloqueado = rs.getBoolean("bloqueado");
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return bloqueado;
    }*/
    public boolean estaBloqueado(int idPeriodo, int idAnioLectivo) {
        boolean bloqueado = false;
        String sql = "SELECT estado FROM periodo WHERE id_periodo = ? AND id_anio_lectivo = ?";
        try (Connection con = DatabaseConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idPeriodo);
            ps.setInt(2, idAnioLectivo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String estado = rs.getString("estado");
                    bloqueado = "cerrado".equalsIgnoreCase(estado);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bloqueado;
    }
    public List<Map<String, Object>> listarMesesPorPeriodo(int idAnio, int idPeriodo) {
        List<Map<String, Object>> meses = new ArrayList<>();
        String sql = "SELECT DISTINCT mes FROM periodo WHERE id_anio_lectivo = ? AND id_periodo = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idAnio);
            ps.setInt(2, idPeriodo);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String codMes = rs.getString("mes");
                Map<String, Object> m = new HashMap<>();
                m.put("codigo", codMes);
                m.put("nombre", "Mes " + codMes);
                meses.add(m);
            }
        } catch (Exception ex) { ex.printStackTrace(); }
        return meses;
    }

    // Crear nuevo periodo académico
    public boolean crear(Periodo p) {
        String sql = "{CALL sp_crear_periodo(?,?,?,?,?,?,?,?)}";
        try (Connection con = DatabaseConfig.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {
            cs.setInt(1, p.getIdAnioLectivo());
            cs.setString(2, p.getBimestre());
            cs.setString(3, p.getMes());
            cs.setString(4, p.getTipo());
            cs.setDate(5, new java.sql.Date(p.getFecInicio().getTime()));
            cs.setDate(6, new java.sql.Date(p.getFecFin().getTime()));
            cs.setDate(7, new java.sql.Date(p.getFecCierre().getTime()));
            cs.setString(8, p.getEstado());
            return cs.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Editar periodo académico
    public boolean editar(Periodo p) {
        String sql = "{CALL sp_editar_periodo(?,?,?,?,?,?,?,?,?)}";
        try (Connection con = DatabaseConfig.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {
            cs.setInt(1, p.getIdPeriodo());
            cs.setInt(2, p.getIdAnioLectivo());
            cs.setString(3, p.getBimestre());
            cs.setString(4, p.getMes());
            cs.setString(5, p.getTipo());
            cs.setDate(6, new java.sql.Date(p.getFecInicio().getTime()));
            cs.setDate(7, new java.sql.Date(p.getFecFin().getTime()));
            cs.setDate(8, new java.sql.Date(p.getFecCierre().getTime()));
            cs.setString(9, p.getEstado());
            return cs.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Cambiar estado (cerrar/habilitar/borrador)
    public boolean cambiarEstado(int idPeriodo, String nuevoEstado) {
        String sql = "{CALL sp_cambiar_estado_periodo(?,?)}";
        try (Connection con = DatabaseConfig.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {
            cs.setInt(1, idPeriodo);
            cs.setString(2, nuevoEstado);
            return cs.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
