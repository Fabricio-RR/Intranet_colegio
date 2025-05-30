/*
package com.intranet_escolar.dao;

import com.intranet_escolar.config.DatabaseConfig;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.time.LocalDateTime;

public class RecuperarPasswordDAO {

    // Paso 1: Verificar usuario por DNI y correo, y generar código
    public String generarToken(String dni, String correo) {
        String tokenGenerado = null;
        try (Connection con = DatabaseConfig.getConnection()) {
            CallableStatement cs = con.prepareCall("CALL sp_generar_token(?, ?, ?, ?)");
            cs.setString(1, dni);
            cs.setString(2, correo);
            cs.registerOutParameter(3, Types.VARCHAR); 
            cs.registerOutParameter(4, Types.INTEGER); 
            cs.execute();

            if (cs.getInt(4) == 1) {
                tokenGenerado = cs.getString(3);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tokenGenerado;
    }

    // Paso 2: Validar token ingresado
    public boolean validarToken(String dni, String token) {
        boolean valido = false;
        try (Connection con = DatabaseConfig.getConnection()) {
            CallableStatement cs = con.prepareCall("CALL sp_validar_token(?, ?, ?) ");
            cs.setString(1, dni);
            cs.setString(2, token);
            cs.registerOutParameter(3, Types.BOOLEAN);
            cs.execute();

            valido = cs.getBoolean(3);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return valido;
    }

    // Paso 3: Cambiar la contraseña del usuario
    public boolean actualizarContrasena(String dni, String nuevaClaveHash) {
        boolean exito = false;
        try (Connection con = DatabaseConfig.getConnection()) {
            CallableStatement cs = con.prepareCall("CALL sp_actualizar_clave(?, ?, ?)");
            cs.setString(1, dni);
            cs.setString(2, nuevaClaveHash);
            cs.registerOutParameter(3, Types.INTEGER);
            cs.execute();

            exito = cs.getInt(3) == 1;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return exito;
    }

    // Para registrar intento fallido de validación del token
    public void registrarIntentoFallido(String dni) {
        try (Connection con = DatabaseConfig.getConnection()) {
            CallableStatement cs = con.prepareCall("CALL sp_registrar_intento_fallido(?)");
            cs.setString(1, dni);
            cs.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Para verificar si el usuario está temporalmente bloqueado por fallos
    public boolean estaBloqueado(String dni) {
        boolean bloqueado = false;
        try (Connection con = DatabaseConfig.getConnection()) {
            CallableStatement cs = con.prepareCall("CALL sp_esta_bloqueado(?, ?)");
            cs.setString(1, dni);
            cs.registerOutParameter(2, Types.BOOLEAN);
            cs.execute();

            bloqueado = cs.getBoolean(2);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bloqueado;
    }
}
*/