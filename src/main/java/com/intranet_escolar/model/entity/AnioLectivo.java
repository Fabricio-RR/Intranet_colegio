
package com.intranet_escolar.model.entity;

import java.util.Date;

public class AnioLectivo {
    private int idAnioLectivo;
    private String nombre;
    private Date fecInicio;
    private Date fecFin;
    private String estado;

    public AnioLectivo() {
    }

    public AnioLectivo(int idAnioLectivo, String nombre, Date fecInicio, Date fecFin, String estado) {
        this.idAnioLectivo = idAnioLectivo;
        this.nombre = nombre;
        this.fecInicio = fecInicio;
        this.fecFin = fecFin;
        this.estado = estado;
    }

    public int getIdAnioLectivo() {
        return idAnioLectivo;
    }

    public void setIdAnioLectivo(int idAnioLectivo) {
        this.idAnioLectivo = idAnioLectivo;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public Date getFecInicio() {
        return fecInicio;
    }

    public void setFecInicio(Date fecInicio) {
        this.fecInicio = fecInicio;
    }

    public Date getFecFin() {
        return fecFin;
    }

    public void setFecFin(Date fecFin) {
        this.fecFin = fecFin;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
    
}
