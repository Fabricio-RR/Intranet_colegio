package com.intranet_escolar.model.entity;

public class Grado {
    private int idGrado;
    private String nombre;
    private int idNivel;

    public Grado() {
    }

    public Grado(int idGrado, String nombre, int idNivel) {
        this.idGrado = idGrado;
        this.nombre = nombre;
        this.idNivel = idNivel;
    }

    public int getIdGrado() {
        return idGrado;
    }

    public void setIdGrado(int idGrado) {
        this.idGrado = idGrado;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public int getIdNivel() {
        return idNivel;
    }

    public void setIdNivel(int idNivel) {
        this.idNivel = idNivel;
    }
    
    
}
