
package com.intranet_escolar.dao;

import com.intranet_escolar.config.DatabaseConfig;
import com.intranet_escolar.model.DTO.AperturaSeccionDTO;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Hp
 */
public class AperturaSeccionDAO {
    public List<AperturaSeccionDTO> obtenerAperturasSeccionActivas() {
    List<AperturaSeccionDTO> lista = new ArrayList<>();
    String sql = "SELECT aps.id_apertura_seccion, n.nombre AS nivel, g.nombre AS grado, s.nombre AS seccion, al.nombre AS anio_lectivo " +
                 "FROM apertura_seccion aps " +
                 "INNER JOIN grado g ON aps.id_grado = g.id_grado " +
                 "INNER JOIN nivel n ON g.id_nivel = n.id_nivel " +
                 "INNER JOIN seccion s ON aps.id_seccion = s.id_seccion " +
                 "INNER JOIN anio_lectivo al ON aps.id_anio_lectivo = al.id_anio_lectivo " +
                 "WHERE al.estado IN ('activo','preparacion') " +
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
                rs.getString("anio_lectivo")
            );
            lista.add(dto);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return lista;
}
    public List<AperturaSeccionDTO> obtenerAperturasSeccionPorAnio(int idAnioLectivo) {
    List<AperturaSeccionDTO> lista = new ArrayList<>();
    String sql = "SELECT aps.id_apertura_seccion, n.nombre AS nivel, g.nombre AS grado, s.nombre AS seccion, al.nombre AS anio_lectivo " +
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
                    rs.getString("anio_lectivo")
                );
                lista.add(dto);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return lista;
}
}
