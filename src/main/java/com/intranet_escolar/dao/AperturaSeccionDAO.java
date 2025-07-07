
package com.intranet_escolar.dao;

import com.intranet_escolar.config.DatabaseConfig;
import com.intranet_escolar.model.DTO.AperturaSeccionDTO;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AperturaSeccionDAO {
    public List<AperturaSeccionDTO> obtenerAperturasSeccionActivas() {
        List<AperturaSeccionDTO> lista = new ArrayList<>();
        String sql = "SELECT aps.id_apertura_seccion, n.nombre AS nivel, g.nombre AS grado, s.nombre AS seccion, " +
                     "al.nombre AS anio_lectivo, aps.activo " +
                     "FROM apertura_seccion aps " +
                     "INNER JOIN grado g ON aps.id_grado = g.id_grado " +
                     "INNER JOIN nivel n ON g.id_nivel = n.id_nivel " +
                     "INNER JOIN seccion s ON aps.id_seccion = s.id_seccion " +
                     "INNER JOIN anio_lectivo al ON aps.id_anio_lectivo = al.id_anio_lectivo " +
                     "WHERE aps.activo = 1 AND al.estado IN ('activo', 'preparacion') " +
                     "ORDER BY al.nombre DESC, n.nombre, g.nombre, s.nombre";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                AperturaSeccionDTO dto = new AperturaSeccionDTO(
                    rs.getInt("id_apertura_seccion"),
                    rs.getString("nivel"),
                    rs.getString("grado"),
                    rs.getString("seccion"),
                    rs.getString("anio_lectivo"),
                    rs.getBoolean("activo")
                );
                lista.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }
    // Listar todas las aperturas de sección de un año lectivo específico
    public List<AperturaSeccionDTO> obtenerAperturasSeccionPorAnio(int idAnioLectivo) {
        List<AperturaSeccionDTO> lista = new ArrayList<>();
        String sql = "SELECT aps.id_apertura_seccion, n.nombre AS nivel, g.nombre AS grado, s.nombre AS seccion, " +
                     "al.nombre AS anio_lectivo, aps.activo " +
                     "FROM apertura_seccion aps " +
                     "INNER JOIN grado g ON aps.id_grado = g.id_grado " +
                     "INNER JOIN nivel n ON g.id_nivel = n.id_nivel " +
                     "INNER JOIN seccion s ON aps.id_seccion = s.id_seccion " +
                     "INNER JOIN anio_lectivo al ON aps.id_anio_lectivo = al.id_anio_lectivo " +
                     "WHERE al.id_anio_lectivo = ? " +
                     "ORDER BY n.nombre, g.nombre, s.nombre";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idAnioLectivo);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AperturaSeccionDTO dto = new AperturaSeccionDTO(
                        rs.getInt("id_apertura_seccion"),
                        rs.getString("nivel"),
                        rs.getString("grado"),
                        rs.getString("seccion"),
                        rs.getString("anio_lectivo"),
                        rs.getBoolean("activo")
                    );
                    lista.add(dto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    // Crear una nueva apertura de sección
    public boolean crearAperturaSeccion(int idAnioLectivo, int idGrado, int idSeccion) {
        String sql = "INSERT INTO apertura_seccion (id_anio_lectivo, id_grado, id_seccion, activo) VALUES (?, ?, ?, 1)";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idAnioLectivo);
            ps.setInt(2, idGrado);
            ps.setInt(3, idSeccion);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Editar apertura de sección (grado y sección)
    public boolean editarAperturaSeccion(int idApertura, int idGrado, int idSeccion) {
        String sql = "UPDATE apertura_seccion SET id_grado = ?, id_seccion = ? WHERE id_apertura_seccion = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idGrado);
            ps.setInt(2, idSeccion);
            ps.setInt(3, idApertura);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Desactivar apertura de sección (cambia campo activo a 0)
    public boolean desactivarAperturaSeccion(int idApertura) {
        String sql = "UPDATE apertura_seccion SET activo = 0 WHERE id_apertura_seccion = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idApertura);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Verificar si existe una apertura duplicada para el mismo año, grado y sección (activa)
    public boolean existeAperturaSeccion(int idAnioLectivo, int idGrado, int idSeccion) {
        String sql = "SELECT COUNT(*) FROM apertura_seccion "
                   + "WHERE id_anio_lectivo=? AND id_grado=? AND id_seccion=? AND activo=1";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idAnioLectivo);
            ps.setInt(2, idGrado);
            ps.setInt(3, idSeccion);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
