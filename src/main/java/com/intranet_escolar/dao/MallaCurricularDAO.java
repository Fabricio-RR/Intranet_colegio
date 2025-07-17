package com.intranet_escolar.dao;

import com.intranet_escolar.config.DatabaseConfig;
import com.intranet_escolar.model.entity.AnioLectivo;
import com.intranet_escolar.model.entity.MallaCurricular;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MallaCurricularDAO {

    // NUEVO: Obtiene el id_anio_lectivo por nombre de año
    public int obtenerIdAnioLectivoPorNombre(int nombreAnio) {
        int id = 0;
        String sql = "SELECT id_anio_lectivo FROM anio_lectivo WHERE nombre = ? AND estado = 'activo' LIMIT 1";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, String.valueOf(nombreAnio));
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    id = rs.getInt("id_anio_lectivo");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return id;
    }

    // Listar el resumen por nivel, RECIBE id_anio_lectivo
    public List<MallaCurricular> listarResumenPorNivel(int idAnioLectivo) {
        List<MallaCurricular> lista = new ArrayList<>();
        String sql = "{CALL sp_resumen_malla_por_nivel(?)}";

        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement stmt = conn.prepareCall(sql)) {

            stmt.setInt(1, idAnioLectivo);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    MallaCurricular r = new MallaCurricular();
                    r.setIdNivel(rs.getInt("id_nivel"));
                    r.setNombreNivel(rs.getString("nombre_nivel"));
                    r.setTotalGrados(rs.getInt("total_grados"));
                    r.setTotalCursos(rs.getInt("total_cursos"));
                    r.setTotalDocentes(rs.getInt("total_docentes"));
                    r.setTotalInactivos(rs.getInt("total_inactivos"));
                    lista.add(r);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    // Listar detalle por nivel, RECIBE idNivel y id_anio_lectivo
    public List<MallaCurricular> listarDetallePorNivel(int idNivel, int idAnioLectivo) {
        List<MallaCurricular> lista = new ArrayList<>();
        String sql = "{CALL sp_detalle_malla_por_nivel(?, ?)}";

        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement stmt = conn.prepareCall(sql)) {

            stmt.setInt(1, idNivel);
            stmt.setInt(2, idAnioLectivo);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    MallaCurricular m = new MallaCurricular();
                    m.setIdMalla(rs.getInt("id_malla_curricular"));
                    m.setIdDocente(rs.getInt("id_docente"));
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

    // Obtiene el NOMBRE del año lectivo activo (ej: "2025")
    /*
    public int obtenerAnioActivo() {
        int anio = 0;
        String sql = "{CALL sp_obtener_anio_activo()}";

        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement stmt = conn.prepareCall(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                anio = rs.getInt("nombre"); // Sigue retornando el NOMBRE
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return anio;
    }

    // Lista nombres de años disponibles (puedes ajustar si quieres IDs)
    
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
    }*/
    public List<AnioLectivo> obtenerAniosDisponibles() {
        List<AnioLectivo> anios = new ArrayList<>();
        String sql = "{CALL sp_listar_anios_disponibles()}";
        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement stmt = conn.prepareCall(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                AnioLectivo anio = new AnioLectivo();
                anio.setIdAnioLectivo(rs.getInt("id_anio_lectivo"));
                anio.setNombre(rs.getString("nombre"));
                anio.setEstado(rs.getString("estado"));
                anios.add(anio);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return anios;
    }

    public int obtenerAnioActivo() {
        int idAnio = 0;
        String sql = "{CALL sp_obtener_anio_activo()}";
        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement stmt = conn.prepareCall(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                idAnio = rs.getInt("id_anio_lectivo");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return idAnio;
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
    public boolean desactivarPorNivel(int idNivel, int idAnioLectivo) {
    // Desactiva cada registro de malla usando el SP sp_desactivar_malla
        List<MallaCurricular> detalle = listarDetallePorNivel(idNivel, idAnioLectivo);
        if (detalle.isEmpty()) {
            return false;
        }
        boolean todosOk = true;
        String sql = "{CALL sp_desactivar_malla(?)}";
        try (Connection conn = DatabaseConfig.getConnection()) {
            for (MallaCurricular m : detalle) {
                try (CallableStatement stmt = conn.prepareCall(sql)) {
                    stmt.setInt(1, m.getIdMalla());
                    int res = stmt.executeUpdate();
                    if (res <= 0) {
                        todosOk = false;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return todosOk;
    }
    public List<MallaCurricular> listarDetallePorNivelInactivas(int idNivel, int idAnioLectivo) {
        List<MallaCurricular> lista = new ArrayList<>();
        String sql = "{CALL sp_detalle_malla_por_nivel_inactivas(?, ?)}";
        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setInt(1, idNivel);
            stmt.setInt(2, idAnioLectivo);
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
    public boolean reactivarPorNivel(int idNivel, int idAnioLectivo) {
        List<MallaCurricular> detalle = listarDetallePorNivel(idNivel, idAnioLectivo);
        if (detalle.isEmpty()) return false;
        boolean todosOk = true;
        String sql = "{CALL sp_activar_malla(?)}";
        try (Connection conn = DatabaseConfig.getConnection()) {
            for (MallaCurricular m : detalle) {
                try (CallableStatement stmt = conn.prepareCall(sql)) {
                    stmt.setInt(1, m.getIdMalla());
                    int res = stmt.executeUpdate();
                    if (res <= 0) todosOk = false;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return todosOk;
    }
    // Obtiene todas las mallas activas con info de grado, sección y curso (para combos)
    public List<MallaCurricular> listarTodosActivos() {
        List<MallaCurricular> lista = new ArrayList<>();
        String sql = "{CALL sp_listar_mallas_curriculares_activas()}";
        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement stmt = conn.prepareCall(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                MallaCurricular m = new MallaCurricular();
                m.setIdMalla(rs.getInt("id_malla_curricular"));
                m.setNombreCurso(rs.getString("nombre_curso"));
                m.setGrado(rs.getString("grado"));
                m.setSeccion(rs.getString("seccion"));
                m.setActivo(rs.getBoolean("activo"));
                lista.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }
    public List<MallaCurricular> listarTodosActivosPorAnio(int idAnioLectivo) {
        List<MallaCurricular> lista = new ArrayList<>();
        String sql = "{CALL sp_listar_mallas_por_anio(?)}";
        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setInt(1, idAnioLectivo);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    MallaCurricular m = new MallaCurricular();
                    m.setIdMalla(rs.getInt("id_malla_curricular"));
                    m.setNombreCurso(rs.getString("nombre_curso"));
                    m.setGrado(rs.getString("grado"));
                    m.setSeccion(rs.getString("seccion"));
                    lista.add(m);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }
    // Obtiene el id_apertura_seccion dado año, grado y sección
    public int obtenerIdAperturaSeccion(int idAnioLectivo, int idGrado, int idSeccion) {
        int id = 0;
        String sql = "SELECT id_apertura_seccion FROM apertura_seccion " +
                     "WHERE id_anio_lectivo=? AND id_grado=? AND id_seccion=? LIMIT 1";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idAnioLectivo);
            stmt.setInt(2, idGrado);
            stmt.setInt(3, idSeccion);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    id = rs.getInt("id_apertura_seccion");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return id;
    }
    public boolean crearMalla(int idDocente, int idAperturaSeccion, int idCurso, int orden, boolean activo) {
        String sql = "{CALL sp_crear_malla(?, ?, ?, ?, ?)}";
        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement stmt = conn.prepareCall(sql)) {
            stmt.setInt(1, idDocente);
            stmt.setInt(2, idAperturaSeccion);
            stmt.setInt(3, idCurso);
            stmt.setInt(4, orden);
            stmt.setBoolean(5, activo);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    public boolean crearMallaMasiva(int idAperturaSeccion, String[] idCursos, String[] idDocentes, String[] ordenes, String[] activos) {
        boolean ok = true;
        String sql = "{CALL sp_crear_malla(?, ?, ?, ?, ?)}";
        try (Connection conn = DatabaseConfig.getConnection()) {
            for (int i = 0; i < idCursos.length; i++) {
                try (CallableStatement stmt = conn.prepareCall(sql)) {
                    stmt.setInt(1, Integer.parseInt(idDocentes[i]));
                    stmt.setInt(2, idAperturaSeccion);
                    stmt.setInt(3, Integer.parseInt(idCursos[i]));
                    stmt.setInt(4, Integer.parseInt(ordenes[i]));
                    stmt.setBoolean(5, "1".equals(activos[i]));
                    int res = stmt.executeUpdate();
                    if (res <= 0) ok = false;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return ok;
    }
    public boolean copiarMalla(int anioOrigen, int anioDestino, int idGrado, int idSeccion) {
        boolean ok = true;
        // Obtener apertura origen y destino
        int idAperturaOrigen = obtenerIdAperturaSeccion(anioOrigen, idGrado, idSeccion);
        int idAperturaDestino = obtenerIdAperturaSeccion(anioDestino, idGrado, idSeccion);

        if (idAperturaOrigen == 0 || idAperturaDestino == 0) return false;

        // Obtener todos los cursos/docentes de la malla origen
        String sqlOrigen = "SELECT id_docente, id_curso, orden, activo FROM malla_curricular WHERE id_apertura_seccion=?";
        String sqlCrear = "{CALL sp_crear_malla(?, ?, ?, ?, ?)}";

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlOrigen)) {
            ps.setInt(1, idAperturaOrigen);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    try (CallableStatement cs = conn.prepareCall(sqlCrear)) {
                        cs.setInt(1, rs.getInt("id_docente"));
                        cs.setInt(2, idAperturaDestino);
                        cs.setInt(3, rs.getInt("id_curso"));
                        cs.setInt(4, rs.getInt("orden"));
                        cs.setBoolean(5, rs.getBoolean("activo"));
                        int res = cs.executeUpdate();
                        if (res <= 0) ok = false;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return ok;
    }
    // Listar NIVELES 
    public List<MallaCurricular> listarNivelesPorAnio(int idAnioLectivo) {
        List<MallaCurricular> lista = new ArrayList<>();
        String sql = "SELECT DISTINCT n.id_nivel, n.nombre " +
                     "FROM apertura_seccion aps " +
                     "INNER JOIN nivel n ON aps.id_nivel = n.id_nivel " +
                     "WHERE aps.id_anio_lectivo = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idAnioLectivo);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                MallaCurricular m = new MallaCurricular();
                m.setIdNivel(rs.getInt("id_nivel"));
                m.setNombreNivel(rs.getString("nombre"));
                lista.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    // Listar CURSOS (devuelve id y nombre)
    public List<MallaCurricular> listarCursos() {
        List<MallaCurricular> lista = new ArrayList<>();
        String sql = "SELECT id_curso, nombre FROM curso WHERE activo = 1";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                MallaCurricular m = new MallaCurricular();
                m.setIdCurso(rs.getInt("id_curso"));
                m.setNombreCurso(rs.getString("nombre"));
                lista.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

}
