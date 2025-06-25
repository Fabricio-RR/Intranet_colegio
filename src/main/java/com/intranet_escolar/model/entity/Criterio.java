package com.intranet_escolar.model.entity;

public class Criterio {
    private int idCriterio;
    private String nombre;
    private double base;         
    private String descripcion;
    private boolean activo;

    public Criterio() {
    }

    public Criterio(int idCriterio, String nombre, double base, String descripcion, boolean activo) {
        this.idCriterio = idCriterio;
        this.nombre = nombre;
        this.base = base;
        this.descripcion = descripcion;
        this.activo = activo;
    }

    public int getIdCriterio() {
        return idCriterio;
    }

    public void setIdCriterio(int idCriterio) {
        this.idCriterio = idCriterio;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public double getBase() {
        return base;
    }

    public void setBase(double base) {
        this.base = base;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public boolean isActivo() {
        return activo;
    }

    public void setActivo(boolean activo) {
        this.activo = activo;
    }   
}
