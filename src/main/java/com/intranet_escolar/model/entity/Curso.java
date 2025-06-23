package com.intranet_escolar.model.entity;

public class Curso {
    private int idCurso;
    private String nombreCurso;
    private String grado;
    private String seccion;
    private String nivel;
    private String anio;

    public Curso() {
    }

    public Curso(int idCurso, String nombreCurso, String grado, String seccion, String nivel, String anio) {
        this.idCurso = idCurso;
        this.nombreCurso = nombreCurso;
        this.grado = grado;
        this.seccion = seccion;
        this.nivel = nivel;
        this.anio = anio;
    }

    public int getIdCurso() {
        return idCurso;
    }

    public void setIdCurso(int idCurso) {
        this.idCurso = idCurso;
    }

    public String getNombreCurso() {
        return nombreCurso;
    }

    public void setNombreCurso(String nombreCurso) {
        this.nombreCurso = nombreCurso;
    }

    public String getGrado() {
        return grado;
    }

    public void setGrado(String grado) {
        this.grado = grado;
    }

    public String getSeccion() {
        return seccion;
    }

    public void setSeccion(String seccion) {
        this.seccion = seccion;
    }

    public String getNivel() {
        return nivel;
    }

    public void setNivel(String nivel) {
        this.nivel = nivel;
    }

    public String getAnio() {
        return anio;
    }

    public void setAnio(String anio) {
        this.anio = anio;
    }
    
}
