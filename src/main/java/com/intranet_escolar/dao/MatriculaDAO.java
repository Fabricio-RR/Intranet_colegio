package com.intranet_escolar.dao;

import com.intranet_escolar.config.DatabaseConfig;
import com.intranet_escolar.model.entity.Matricula;
import java.sql.CallableStatement;
import java.sql.Connection;
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

    public Matricula obtenerMatriculaPorId(int idMatricula) throws SQLException {
        Matricula m = null;

        try (Connection con = DatabaseConfig.getConnection();
             CallableStatement cs = con.prepareCall("{ CALL sp_detalle_matricula_por_id(?) }")) {

            cs.setInt(1, idMatricula);

            try (ResultSet rs = cs.executeQuery()) {
                if (rs.next()) {
                    m = new Matricula();
                    m.setIdMatricula(rs.getInt("id_matricula"));
                    m.setIdAlumno(rs.getInt("id_alumno"));
                    m.setIdAperturaSeccion(rs.getInt("id_apertura_seccion"));
                    m.setDni(rs.getString("dni"));
                    m.setNombres(rs.getString("nombres"));
                    m.setApellidos(rs.getString("apellidos"));
                    m.setCodigoMatricula(rs.getString("codigo_matricula"));
                    m.setNivel(rs.getString("nivel"));
                    m.setGrado(rs.getString("grado"));
                    m.setSeccion(rs.getString("seccion"));
                    m.setEstado(rs.getString("estado"));
                    m.setFecha(rs.getDate("fecha"));
                }
            }
        }

        return m;
    }

}
