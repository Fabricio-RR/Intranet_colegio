package com.intranet_escolar.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

public class DatabaseConfig {

    private static final String CONFIG_FILE = "/database.properties";
    private static Properties properties;
    private static HikariDataSource dataSource;

    static {
        loadProperties();
        initDataSource();
    }

    private static void loadProperties() {
        properties = new Properties();
        try (InputStream input = DatabaseConfig.class.getResourceAsStream(CONFIG_FILE)) {
            if (input != null) {
                properties.load(input);
            } else {
                setDefaultProperties();
            }
        } catch (IOException e) {
            System.err.println("Error cargando configuración de base de datos: " + e.getMessage());
            setDefaultProperties();
        }
    }

    private static void setDefaultProperties() {
        properties.setProperty("db.driver", "com.mysql.cj.jdbc.Driver");
        properties.setProperty("db.url", "jdbc:mysql://localhost:3306/intranet_escolar");
        properties.setProperty("db.username", "root");
        properties.setProperty("db.password", "12345");
        properties.setProperty("db.pool.minSize", "5");
        properties.setProperty("db.pool.maxSize", "50");
        properties.setProperty("db.pool.timeout", "3000");
    }

    private static void initDataSource() {
        HikariConfig config = new HikariConfig();
        config.setDriverClassName(properties.getProperty("db.driver"));
        config.setJdbcUrl(properties.getProperty("db.url"));
        config.setUsername(properties.getProperty("db.username"));
        config.setPassword(properties.getProperty("db.password"));

        config.setMinimumIdle(Integer.parseInt(properties.getProperty("db.pool.minSize", "5")));
        config.setMaximumPoolSize(Integer.parseInt(properties.getProperty("db.pool.maxSize", "50")));
        config.setConnectionTimeout(Long.parseLong(properties.getProperty("db.pool.timeout", "3000")));

        // Configuraciones adicionales
        config.addDataSourceProperty("cachePrepStmts", "true");
        config.addDataSourceProperty("prepStmtCacheSize", "250");
        config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");
        config.addDataSourceProperty("useServerPrepStmts", "true");
        config.addDataSourceProperty("characterEncoding", "UTF-8");
        config.addDataSourceProperty("useUnicode", "true");

        dataSource = new HikariDataSource(config);
    }

    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                if (!connection.isClosed()) {
                    connection.close(); // Devuelve al pool
                }
            } catch (SQLException e) {
                System.err.println("Error cerrando conexión: " + e.getMessage());
            }
        }
    }

    public static boolean testConnection() {
        try (Connection connection = getConnection()) {
            return connection != null && !connection.isClosed() && connection.isValid(5);
        } catch (SQLException e) {
            System.err.println("Error probando conexión: " + e.getMessage());
            return false;
        }
    }

    public static String getDatabaseInfo() {
        try (Connection connection = getConnection()) {
            var metaData = connection.getMetaData();
            return String.format("Base de datos: %s %s | Driver: %s %s",
                    metaData.getDatabaseProductName(),
                    metaData.getDatabaseProductVersion(),
                    metaData.getDriverName(),
                    metaData.getDriverVersion()
            );
        } catch (SQLException e) {
            return "Error obteniendo información: " + e.getMessage();
        }
    }

    public static String getDriver() {
        return properties.getProperty("db.driver");
    }

    public static String getUrl() {
        return properties.getProperty("db.url");
    }

    public static String getUsername() {
        return properties.getProperty("db.username");
    }

    public static int getMinPoolSize() {
        return Integer.parseInt(properties.getProperty("db.pool.minSize", "5"));
    }

    public static int getMaxPoolSize() {
        return Integer.parseInt(properties.getProperty("db.pool.maxSize", "50"));
    }

    public static int getTimeout() {
        return Integer.parseInt(properties.getProperty("db.pool.timeout", "3000"));
    }
}
