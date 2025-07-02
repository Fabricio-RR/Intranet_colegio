package com.intranet_escolar.model.entity;

import java.sql.Date;

public class Calificacion {
    private int idCalificacion;
    private int idAlumno;
    private int idMallaCriterio;
    private int idAnioLectivo; // + getter y setter
    private Double nota; // decimal (puede ser null)
    private java.sql.Date fecha;
    private String observacion;

    public Calificacion() {
    }

    public Calificacion(int idCalificacion, int idAlumno, int idMallaCriterio, int idAnioLectivo, Double nota, Date fecha, String observacion) {
        this.idCalificacion = idCalificacion;
        this.idAlumno = idAlumno;
        this.idMallaCriterio = idMallaCriterio;
        this.idAnioLectivo = idAnioLectivo;
        this.nota = nota;
        this.fecha = fecha;
        this.observacion = observacion;
    }

    public int getIdCalificacion() {
        return idCalificacion;
    }

    public void setIdCalificacion(int idCalificacion) {
        this.idCalificacion = idCalificacion;
    }

    public int getIdAlumno() {
        return idAlumno;
    }

    public void setIdAlumno(int idAlumno) {
        this.idAlumno = idAlumno;
    }

    public int getIdMallaCriterio() {
        return idMallaCriterio;
    }

    public void setIdMallaCriterio(int idMallaCriterio) {
        this.idMallaCriterio = idMallaCriterio;
    }

    public int getIdAnioLectivo() {
        return idAnioLectivo;
    }

    public void setIdAnioLectivo(int idAnioLectivo) {
        this.idAnioLectivo = idAnioLectivo;
    }

    public Double getNota() {
        return nota;
    }

    public void setNota(Double nota) {
        this.nota = nota;
    }

    public java.sql.Date getFecha() {
        return fecha;
    }

    public void setFecha(java.sql.Date fecha) {
        this.fecha = fecha;
    }

    public String getObservacion() {
        return observacion;
    }

    public void setObservacion(String observacion) {
        this.observacion = observacion;
    }
    
}
