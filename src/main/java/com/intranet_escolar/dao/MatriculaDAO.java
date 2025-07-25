package com.intranet_escolar.dao;

import com.intranet_escolar.config.DatabaseConfig;
import com.intranet_escolar.model.entity.Alumno;
import com.intranet_escolar.model.entity.Apoderado;
import com.intranet_escolar.model.entity.Matricula;
import com.intranet_escolar.model.entity.Usuario;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


public class MatriculaDAO {
    public List<Matricula> listarMatriculasPorAnio(int idAnio) throws SQLException {
        List<Matricula> lista = new ArrayList<>();

        try (Connection con = DatabaseConfig.getConnection();
             CallableStatement cs = con.prepareCall("{ CALL sp_listar_matriculas_por_anio(?) }")) {

            cs.setInt(1, idAnio);

            try (ResultSet rs = cs.executeQuery()) {
                while (rs.next()) {
                    Matricula m = new Matricula();
                    m.setIdMatricula(rs.getInt("id_matricula"));
                    m.setDni(rs.getString("dni"));
                    m.setNombres(rs.getString("nombres"));
                    m.setApellidos(rs.getString("apellidos"));
                    m.setCodigoMatricula(rs.getString("codigo_matricula"));
                    m.setNivel(rs.getString("nivel"));
                    m.setGrado(rs.getString("grado"));
                    m.setSeccion(rs.getString("seccion"));
                    m.setEstado(rs.getString("estado"));
                    m.setFecha(rs.getDate("fecha"));
                    lista.add(m);
                }
            }
        }

        return lista;
    }
    
    public List<Matricula> listarMatriculasParaExportar(int idAnio) throws SQLException {
        List<Matricula> lista = new ArrayList<>();

        String sql = "{CALL sp_listar_matriculas_export_excel(?)}";
        try (Connection con = DatabaseConfig.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {
            cs.setInt(1, idAnio);

            try (ResultSet rs = cs.executeQuery()) {
                while (rs.next()) {
                    Matricula m = new Matricula();
                    m.setIdMatricula(rs.getInt("id_matricula"));
                    m.setIdAlumno(rs.getInt("id_alumno"));
                    m.setCodigoMatricula(rs.getString("codigo_matricula"));
                    m.setDni(rs.getString("dni_alumno"));
                    m.setNombres(rs.getString("nombres_alumno"));
                    m.setApellidos(rs.getString("apellidos_alumno"));
                    m.setEstado(rs.getString("estado"));
                    m.setObservacion(rs.getString("observacion"));
                    m.setFecha(rs.getDate("fecha"));
                    m.setIdNivel(rs.getInt("id_nivel"));
                    m.setNivel(rs.getString("nivel"));
                    m.setIdGrado(rs.getInt("id_grado"));
                    m.setGrado(rs.getString("grado"));
                    m.setIdSeccion(rs.getInt("id_seccion"));
                    m.setSeccion(rs.getString("seccion"));
                    // Extra: campos planos para apoderado (puedes crear setters en Matricula)
                    m.setParentesco(rs.getString("parentesco"));
                    m.setDniApoderado(rs.getString("dni_apoderado"));
                    m.setNombresApoderado(rs.getString("nombres_apoderado"));
                    m.setApellidosApoderado(rs.getString("apellidos_apoderado"));
                    lista.add(m);
                }
            }
        }
        return lista;
    }

    public Matricula obtenerMatriculaPorId(int idMatricula) {
        Matricula matricula = null;

        String sql = "CALL sp_detalle_matricula_por_id(?)";

        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {

            cs.setInt(1, idMatricula);

            try (ResultSet rs = cs.executeQuery()) {
                if (rs.next()) {
                    // Usuario del Alumno
                    Usuario usuarioAlumno = new Usuario();
                    usuarioAlumno.setDni(rs.getString("dni"));
                    usuarioAlumno.setNombres(rs.getString("nombres"));
                    usuarioAlumno.setApellidos(rs.getString("apellidos"));
                    usuarioAlumno.setCorreo(rs.getString("correo"));
                    usuarioAlumno.setTelefono(rs.getString("telefono"));

                    // Alumno
                    Alumno alumno = new Alumno();
                    alumno.setIdAlumno(rs.getInt("id_alumno"));
                    alumno.setCodigoMatricula(rs.getString("codigo_matricula"));
                    alumno.setUsuario(usuarioAlumno);

                    // Usuario del Apoderado (si existe)
                    Apoderado apoderado = null;
                    String dniApo = rs.getString("dni_apoderado");
                    if (dniApo != null && !dniApo.isEmpty()) {
                        Usuario usuarioApo = new Usuario();
                        usuarioApo.setDni(dniApo);
                        usuarioApo.setNombres(rs.getString("nombres_apoderado"));
                        usuarioApo.setApellidos(rs.getString("apellidos_apoderado"));
                        usuarioApo.setTelefono(rs.getString("telefono_apoderado"));
                        usuarioApo.setCorreo(rs.getString("correo_apoderado"));

                        apoderado = new Apoderado();
                        apoderado.setUsuario(usuarioApo);
                        apoderado.setParentesco(rs.getString("parentesco"));
                    }

                    // Matricula
                    matricula = new Matricula();
                    matricula.setIdMatricula(rs.getInt("id_matricula"));
                    matricula.setIdAperturaSeccion(rs.getInt("id_apertura_seccion"));
                    matricula.setAlumno(alumno);
                    matricula.setApoderado(apoderado);
                    matricula.setIdNivel(rs.getInt("id_nivel"));
                    matricula.setNivel(rs.getString("nivel"));
                    matricula.setIdGrado(rs.getInt("id_grado"));
                    matricula.setGrado(rs.getString("grado"));
                    matricula.setIdSeccion(rs.getInt("id_seccion"));
                    matricula.setSeccion(rs.getString("seccion"));
                    matricula.setEstado(rs.getString("estado"));
                    matricula.setObservacion(rs.getString("observacion"));
                    matricula.setFecha(rs.getDate("fecha"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return matricula;
    }
    public boolean actualizarMatricula(int idMatricula, String parentesco, int idNivel, int idGrado, int idSeccion, String estado, String observacion) throws SQLException {
        int idApertura = 0;
        String spLookup = "{CALL sp_obtener_apertura_seccion(?,?,?)}";
        String spActualizar = "{CALL sp_actualizar_matricula(?,?,?,?,?)}";
        try (Connection conn = DatabaseConfig.getConnection()) {
            // 1. Buscar id_apertura_seccion
            try (CallableStatement csLookup = conn.prepareCall(spLookup)) {
                csLookup.setInt(1, idGrado);
                csLookup.setInt(2, idSeccion);
                csLookup.setInt(3, idNivel);
                try (ResultSet rs = csLookup.executeQuery()) {
                    if (rs.next()) {
                        idApertura = rs.getInt("id_apertura_seccion");
                    }
                }
            }
            System.out.println("[DAO] idApertura encontrado: " + idApertura + " para grado=" + idGrado + ", seccion=" + idSeccion + ", nivel=" + idNivel);
            if (idApertura == 0) {
                throw new SQLException("No existe apertura_seccion con esos parámetros");
            }

            // 2. Actualizar matrícula (SP)
            try (CallableStatement cs = conn.prepareCall(spActualizar)) {
                cs.setInt(1, idMatricula);
                cs.setString(2, parentesco);
                cs.setInt(3, idApertura);
                cs.setString(4, estado);
                cs.setString(5, observacion); 
                int filas = cs.executeUpdate();
                System.out.println("[DAO] Filas afectadas al actualizar matrícula: " + filas);
                return filas > 0;
            }
        }
    }
    public boolean cambiarEstadoMatricula(int idMatricula, String nuevoEstado) throws SQLException {
        String sql = "UPDATE matricula SET estado = ? WHERE id_matricula = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nuevoEstado);
            ps.setInt(2, idMatricula);
            return ps.executeUpdate() > 0;
        }
    }
    public boolean crearMatricula(int idAlumno, int idApoderado, String parentesco, int idAperturaSeccion,
        int idAnioLectivo, String estado, String observacion) throws SQLException {
        String sql = "{CALL sp_crear_matricula_completa(?,?,?,?,?,?,?)}";
        try (Connection conn = DatabaseConfig.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {
            cs.setInt(1, idAlumno);
            cs.setInt(2, idApoderado);
            cs.setString(3, parentesco);
            cs.setInt(4, idAperturaSeccion);
            cs.setInt(5, idAnioLectivo);
            cs.setString(6, estado);
            cs.setString(7, observacion);
            int filas = cs.executeUpdate();
            return filas > 0;
        } catch (SQLException e) {
            // Si el SP lanza un SIGNAL, puedes propagar el mensaje para mostrarlo en la vista
            if ("45000".equals(e.getSQLState())) {
                throw new SQLException(e.getMessage(), e.getSQLState());
            } else {
                throw e;
            }
        }
    }
}
