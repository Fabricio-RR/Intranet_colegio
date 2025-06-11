
package com.intranet_escolar.model.DTO;

import java.util.Date;

public class NotaDTO {
    private String curso;
    private String tipoEvaluacion;
    private double calificacion;
    private Date fecha;
    private String docente;

    public NotaDTO() {
    }

    public NotaDTO(String curso, String tipoEvaluacion, double calificacion, Date fecha, String docente) {
        this.curso = curso;
        this.tipoEvaluacion = tipoEvaluacion;
        this.calificacion = calificacion;
        this.fecha = fecha;
        this.docente = docente;
    }

    public String getCurso() {
        return curso;
    }

    public void setCurso(String curso) {
        this.curso = curso;
    }

    public String getTipoEvaluacion() {
        return tipoEvaluacion;
    }

    public void setTipoEvaluacion(String tipoEvaluacion) {
        this.tipoEvaluacion = tipoEvaluacion;
    }

    public double getCalificacion() {
        return calificacion;
    }

    public void setCalificacion(double calificacion) {
        this.calificacion = calificacion;
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }

    public String getDocente() {
        return docente;
    }

    public void setDocente(String docente) {
        this.docente = docente;
    }
    
}
