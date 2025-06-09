package com.intranet_escolar.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class LoggerUtil {

    public static void error(Class<?> clazz, String mensaje, Exception e) {
        Logger logger = LoggerFactory.getLogger(clazz);
        logger.error(mensaje, e);
    }

    public static void info(Class<?> clazz, String mensaje) {
        Logger logger = LoggerFactory.getLogger(clazz);
        logger.info(mensaje);
    }

    // Otros niveles si necesitas
    public static void warn(Class<?> clazz, String mensaje) {
        Logger logger = LoggerFactory.getLogger(clazz);
        logger.warn(mensaje);
    }

}
