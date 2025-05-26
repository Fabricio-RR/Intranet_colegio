/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.intranet_escolar.util;
import com.intranet_escolar.config.DatabaseConfig;

public class tes {
    public static void main(String[] args) {
        if (DatabaseConfig.testConnection()) {
            System.out.println("✅ Conexión a la BD verificada.");
        
        } else {
            System.out.println("❌ No se pudo conectar a la base de datos.");
        }
    }
}
