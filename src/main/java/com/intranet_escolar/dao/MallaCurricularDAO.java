
package com.intranet_escolar.dao;

import com.intranet_escolar.config.DatabaseConfig;
import com.intranet_escolar.model.entity.MallaCurricular;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;


    public class MallaCurricularDAO {
        
    public List<MallaCurricular> listarResumenPorNivel(int anio) {
        List<MallaCurricular> lista = new ArrayList<>();
        String sql = "{CALL sp_resumen_malla_por_nivel(?)}";

        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement stmt = conn.prepareCall(sql)) {

            stmt.setInt(1, anio);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    MallaCurricular r = new MallaCurricular();
                    r.setIdNivel(rs.getInt("id_nivel"));
                    r.setNombreNivel(rs.getString("nombre_nivel"));
                    r.setTotalGrados(rs.getInt("total_grados"));
                    r.setTotalCursos(rs.getInt("total_cursos"));
                    r.setTotalDocentes(rs.getInt("total_docentes"));
                    lista.add(r);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }
    
    public List<MallaCurricular> listarDetallePorNivel(int idNivel, int anio) {
        List<MallaCurricular> lista = new ArrayList<>();
        String sql = "{CALL sp_detalle_malla_por_nivel(?, ?)}";

        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement stmt = conn.prepareCall(sql)) {

            stmt.setInt(1, idNivel);
            stmt.setInt(2, anio);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    MallaCurricular m = new MallaCurricular();
                    m.setIdMalla(rs.getInt("id_malla_curricular"));
                    m.setNombreCurso(rs.getString("curso"));
                    m.setNombreDocente(rs.getString("docente"));
                    m.setGrado(rs.getString("grado"));
                    m.setSeccion(rs.getString("seccion"));
                    m.setOrden(rs.getInt("orden"));
                    m.setActivo(rs.getBoolean("activo"));
                    lista.add(m);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    public int obtenerAnioActivo() {
        int anio = 0;
        String sql = "{CALL sp_obtener_anio_activo()}";

        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement stmt = conn.prepareCall(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                anio = rs.getInt("nombre");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return anio;
    }

    public List<Integer> obtenerAniosDisponibles() {
        List<Integer> anios = new ArrayList<>();
        String sql = "{CALL sp_listar_anios_disponibles()}";

        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement stmt = conn.prepareCall(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                anios.add(rs.getInt("nombre"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return anios;
    }

    public MallaCurricular obtenerPorId(int idMalla) {
        MallaCurricular m = null;
        String sql = "{CALL sp_obtener_malla_por_id(?)}";

        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement stmt = conn.prepareCall(sql)) {

            stmt.setInt(1, idMalla);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    m = new MallaCurricular();
                    m.setIdMalla(idMalla);
                    m.setIdDocente(rs.getInt("id_docente"));
                    m.setIdAperturaSeccion(rs.getInt("id_apertura_seccion"));
                    m.setIdCurso(rs.getInt("id_curso"));
                    m.setOrden(rs.getInt("orden"));
                    m.setActivo(rs.getBoolean("activo"));
                    m.setNombreCurso(rs.getString("curso"));
                    m.setNombreDocente(rs.getString("docente"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return m;
    }

    public boolean actualizar(MallaCurricular m) {
        String sql = "{CALL sp_actualizar_malla(?, ?, ?, ?)}";
        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement stmt = conn.prepareCall(sql)) {

            stmt.setInt(1, m.getIdMalla());
            stmt.setInt(2, m.getIdDocente());
            stmt.setInt(3, m.getOrden());
            stmt.setBoolean(4, m.isActivo());

            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean crear(MallaCurricular m) {
        String sql = "{CALL sp_crear_malla(?, ?, ?, ?, ?)}";
        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement stmt = conn.prepareCall(sql)) {

            stmt.setInt(1, m.getIdDocente());
            stmt.setInt(2, m.getIdAperturaSeccion());
            stmt.setInt(3, m.getIdCurso());
            stmt.setInt(4, m.getOrden());
            stmt.setBoolean(5, m.isActivo());

            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean desactivar(int idMalla) {
        String sql = "{CALL sp_desactivar_malla(?)}";
        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement stmt = conn.prepareCall(sql)) {

            stmt.setInt(1, idMalla);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
