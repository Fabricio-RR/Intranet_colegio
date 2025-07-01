package com.intranet_escolar.dao;

import com.intranet_escolar.config.DatabaseConfig;
import com.intranet_escolar.model.entity.Nota;
import java.sql.*;
import java.util.*;

public class NotaDAO {

    // 1. Listar notas de todos los alumnos para los criterios seleccionados
    public List<Nota> listarNotasPorCursoPeriodoAnio(int idCurso, int idAperturaSeccion, int idPeriodo, int idMes, int idAnioLectivo) {
        List<Nota> lista = new ArrayList<>();
        String sql = "{CALL sp_listar_notas_curso_periodo_anio(?, ?, ?, ?, ?)}";
        try (Connection con = DatabaseConfig.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {
            cs.setInt(1, idCurso);
            cs.setInt(2, idAperturaSeccion);
            cs.setInt(3, idPeriodo);
            cs.setInt(4, idMes);
            cs.setInt(5, idAnioLectivo);
            try (ResultSet rs = cs.executeQuery()) {
                while (rs.next()) {
                    Nota n = new Nota();
                    n.setIdNota(rs.getInt("id_nota"));
                    n.setIdAlumno(rs.getInt("id_alumno"));
                    n.setIdCriterio(rs.getInt("id_criterio"));
                    n.setValor(rs.getInt("valor"));
                    // Puedes agregar fecha de registro, usuario, etc. según tu SP
                    lista.add(n);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // 2. Guardar o actualizar la nota de un alumno para un criterio, curso, periodo, mes y año
    public void guardarOActualizarNota(int idAlumno, int idCriterio, int valor, int idCurso, int idPeriodo, int idMes, int idAnioLectivo) {
        String sql = "{CALL sp_guardar_actualizar_nota(?, ?, ?, ?, ?, ?, ?)}";
        try (Connection con = DatabaseConfig.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {
            cs.setInt(1, idAlumno);
            cs.setInt(2, idCriterio);
            cs.setInt(3, valor);
            cs.setInt(4, idCurso);
            cs.setInt(5, idPeriodo);
            cs.setInt(6, idMes);
            cs.setInt(7, idAnioLectivo);
            cs.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // (Opcional) 3. Para obtener la nota de un solo alumno/criterio, si necesitas en algún lugar
    public Nota obtenerNota(int idAlumno, int idCriterio, int idCurso, int idPeriodo, int idMes, int idAnioLectivo) {
        Nota n = null;
        String sql = "{CALL sp_obtener_nota(?, ?, ?, ?, ?, ?)}";
        try (Connection con = DatabaseConfig.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {
            cs.setInt(1, idAlumno);
            cs.setInt(2, idCriterio);
            cs.setInt(3, idCurso);
            cs.setInt(4, idPeriodo);
            cs.setInt(5, idMes);
            cs.setInt(6, idAnioLectivo);
            try (ResultSet rs = cs.executeQuery()) {
                if (rs.next()) {
                    n = new Nota();
                    n.setIdNota(rs.getInt("id_nota"));
                    n.setIdAlumno(rs.getInt("id_alumno"));
                    n.setIdCriterio(rs.getInt("id_criterio"));
                    n.setValor(rs.getInt("valor"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return n;
    }
}

