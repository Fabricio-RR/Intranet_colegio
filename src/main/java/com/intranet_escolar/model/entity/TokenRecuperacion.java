
package com.intranet_escolar.model.entity;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;


public class TokenRecuperacion {
    
    private String token;
    private long timestamp; 
    private int intentos;

    public TokenRecuperacion() {
    }

    public TokenRecuperacion(String token, long timestamp, int intentos) {
        this.token = token;
        this.timestamp = timestamp;
        this.intentos = intentos;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public long getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(long timestamp) {
        this.timestamp = timestamp;
    }

    public int getIntentos() {
        return intentos;
    }

    public void setIntentos(int intentos) {
        this.intentos = intentos;
    }
    
    private static final Map<String, TokenRecuperacion> tokens = new ConcurrentHashMap<>();
}
