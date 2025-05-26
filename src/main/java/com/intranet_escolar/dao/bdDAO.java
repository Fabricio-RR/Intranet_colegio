package com.intranet_escolar.dao;

import com.intranet_escolar.config.DatabaseConfig;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * Clase base para todos los DAOs - Jakarta EE 10
 */
public abstract class bdDAO {
    
    private static final Logger logger = Logger.getLogger(bdDAO.class.getName());
    
    /**
     * Obtiene una conexión a la base de datos
     */
    protected Connection getConnection() throws SQLException {
        return DatabaseConfig.getConnection();
    }
    
    /**
     * Cierra recursos de base de datos de forma segura
     */
    protected void closeResources(Connection connection, PreparedStatement statement, ResultSet resultSet) {
        if (resultSet != null) {
            try {
                resultSet.close();
            } catch (SQLException e) {
                logger.log(Level.WARNING, "Error cerrando ResultSet", e);
            }
        }
        
        if (statement != null) {
            try {
                statement.close();
            } catch (SQLException e) {
                logger.log(Level.WARNING, "Error cerrando PreparedStatement", e);
            }
        }
        
        if (connection != null) {
            try {
                if (!connection.isClosed()) {
                    connection.close();
                }
            } catch (SQLException e) {
                logger.log(Level.WARNING, "Error cerrando Connection", e);
            }
        }
    }
    
    /**
     * Cierra recursos sin ResultSet
     */
    protected void closeResources(Connection connection, PreparedStatement statement) {
        closeResources(connection, statement, null);
    }
    
    /**
     * Ejecuta una consulta SELECT y retorna el ResultSet
     * NOTA: El llamador debe cerrar los recursos
     */
    protected ResultSet executeQuery(String sql, Object... parameters) throws SQLException {
        Connection connection = getConnection();
        PreparedStatement statement = connection.prepareStatement(sql);
        
        // Establecer parámetros
        setParameters(statement, parameters);
        
        return statement.executeQuery();
    }
    
    /**
     * Ejecuta una consulta INSERT, UPDATE o DELETE
     */
    protected int executeUpdate(String sql, Object... parameters) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            
            // Establecer parámetros
            setParameters(statement, parameters);
            
            return statement.executeUpdate();
            
        } finally {
            closeResources(connection, statement);
        }
    }
    
    /**
     * Ejecuta un INSERT y retorna el ID generado
     */
    protected Long executeInsertAndGetId(String sql, Object... parameters) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet generatedKeys = null;
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            // Establecer parámetros
            setParameters(statement, parameters);
            
            int affectedRows = statement.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("La inserción falló, no se afectaron filas.");
            }
            
            generatedKeys = statement.getGeneratedKeys();
            if (generatedKeys.next()) {
                return generatedKeys.getLong(1);
            } else {
                throw new SQLException("La inserción falló, no se obtuvo ID.");
            }
            
        } finally {
            closeResources(connection, statement, generatedKeys);
        }
    }
    
    /**
     * Verifica si existe un registro
     */
    protected boolean exists(String sql, Object... parameters) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            
            // Establecer parámetros
            setParameters(statement, parameters);
            
            resultSet = statement.executeQuery();
            return resultSet.next();
            
        } finally {
            closeResources(connection, statement, resultSet);
        }
    }
    
    /**
     * Cuenta registros
     */
    protected int count(String sql, Object... parameters) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            
            // Establecer parámetros
            setParameters(statement, parameters);
            
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
            return 0;
            
        } finally {
            closeResources(connection, statement, resultSet);
        }
    }
    
    /**
     * Ejecuta múltiples operaciones en una transacción
     */
    protected void executeTransaction(TransactionCallback callback) throws SQLException {
        Connection connection = null;
        
        try {
            connection = getConnection();
            connection.setAutoCommit(false);
            
            callback.execute(connection);
            
            connection.commit();
            logger.info("Transacción completada exitosamente");
            
        } catch (SQLException e) {
            if (connection != null) {
                try {
                    connection.rollback();
                    logger.warning("Transacción revertida debido a error: " + e.getMessage());
                } catch (SQLException rollbackEx) {
                    logger.log(Level.SEVERE, "Error en rollback", rollbackEx);
                }
            }
            throw e;
        } finally {
            if (connection != null) {
                try {
                    connection.setAutoCommit(true);
                    connection.close();
                } catch (SQLException e) {
                    logger.log(Level.WARNING, "Error cerrando conexión", e);
                }
            }
        }
    }
    
    /**
     * Establece parámetros en un PreparedStatement
     */
    private void setParameters(PreparedStatement statement, Object... parameters) throws SQLException {
        for (int i = 0; i < parameters.length; i++) {
            Object param = parameters[i];
            if (param == null) {
                statement.setNull(i + 1, Types.NULL);
            } else if (param instanceof String) {
                statement.setString(i + 1, (String) param);
            } else if (param instanceof Integer) {
                statement.setInt(i + 1, (Integer) param);
            } else if (param instanceof Long) {
                statement.setLong(i + 1, (Long) param);
            } else if (param instanceof Double) {
                statement.setDouble(i + 1, (Double) param);
            } else if (param instanceof Boolean) {
                statement.setBoolean(i + 1, (Boolean) param);
            } else if (param instanceof Date) {
                statement.setDate(i + 1, (Date) param);
            } else if (param instanceof Timestamp) {
                statement.setTimestamp(i + 1, (Timestamp) param);
            } else {
                statement.setObject(i + 1, param);
            }
        }
    }
    
    /**
     * Obtiene un valor de forma segura del ResultSet
     */
    protected String getSafeString(ResultSet rs, String columnName) throws SQLException {
        String value = rs.getString(columnName);
        return rs.wasNull() ? null : value;
    }
    
    protected Integer getSafeInt(ResultSet rs, String columnName) throws SQLException {
        int value = rs.getInt(columnName);
        return rs.wasNull() ? null : value;
    }
    
    protected Long getSafeLong(ResultSet rs, String columnName) throws SQLException {
        long value = rs.getLong(columnName);
        return rs.wasNull() ? null : value;
    }
    
    protected Boolean getSafeBoolean(ResultSet rs, String columnName) throws SQLException {
        boolean value = rs.getBoolean(columnName);
        return rs.wasNull() ? null : value;
    }
    
    /**
     * Interface para callbacks de transacciones
     */
    @FunctionalInterface
    public interface TransactionCallback {
        void execute(Connection connection) throws SQLException;
    }
}
