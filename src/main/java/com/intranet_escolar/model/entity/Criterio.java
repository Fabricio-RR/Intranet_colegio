package com.intranet_escolar.model.entity;

public class Criterio {
    private int idCriterio;
    private String nombre;
    private String descripcion;
    private boolean activo;
    private int idCurso;
    private int idPeriodo;

    public Criterio() {
    }

    public Criterio(int idCriterio, String nombre, String descripcion, boolean activo, int idCurso, int idPeriodo) {
        this.idCriterio = idCriterio;
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.activo = activo;
        this.idCurso = idCurso;
        this.idPeriodo = idPeriodo;
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

    public int getIdCurso() {
        return idCurso;
    }

    public void setIdCurso(int idCurso) {
        this.idCurso = idCurso;
    }

    public int getIdPeriodo() {
        return idPeriodo;
    }

    public void setIdPeriodo(int idPeriodo) {
        this.idPeriodo = idPeriodo;
    }
}
