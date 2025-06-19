package com.intranet_escolar.dao;

import com.intranet_escolar.config.DatabaseConfig;
import com.intranet_escolar.model.entity.Nivel;
import com.intranet_escolar.model.entity.Grado;
import com.intranet_escolar.model.entity.Seccion;
import java.sql.*;
import java.util.*;

public class AcademicoDAO {
    public List<Nivel> listarNiveles() {
        List<Nivel> lista = new ArrayList<>();
        String sql = "SELECT id_nivel, nombre FROM nivel";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Nivel n = new Nivel();
                n.setIdNivel(rs.getInt("id_nivel"));
                n.setNombre(rs.getString("nombre"));
                lista.add(n);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }

    public List<Grado> listarGrados() {
        List<Grado> lista = new ArrayList<>();
        String sql = "SELECT id_grado, nombre, id_nivel FROM grado";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Grado g = new Grado();
                g.setIdGrado(rs.getInt("id_grado"));
                g.setNombre(rs.getString("nombre"));
                g.setIdNivel(rs.getInt("id_nivel"));
                lista.add(g);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }

    public List<Seccion> listarSecciones() {
        List<Seccion> lista = new ArrayList<>();
        String sql = "SELECT id_seccion, nombre FROM seccion";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Seccion s = new Seccion();
                s.setIdSeccion(rs.getInt("id_seccion"));
                s.setNombre(rs.getString("nombre"));
                lista.add(s);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }
}
