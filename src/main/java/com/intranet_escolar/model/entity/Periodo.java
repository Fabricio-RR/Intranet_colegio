package com.intranet_escolar.model.entity;

import java.util.Date;

public class Periodo {
    
    private int idPeriodo;
    private String nombre;
    private int idAnioLectivo;
    private String bimestre; // I, II, III, IV
    private String mes;      // '1' o '2'
    private String tipo;     // 'mensual' o 'bimestral'
    private Date fecInicio;
    private Date fecFin;
    private Date fecCierre;
    private String estado;

    public Periodo() {
    }

    public Periodo(int idPeriodo, String nombre, int idAnioLectivo, String bimestre, String mes, String tipo, Date fecInicio, Date fecFin, Date fecCierre, String estado) {
        this.idPeriodo = idPeriodo;
        this.nombre = nombre;
        this.idAnioLectivo = idAnioLectivo;
        this.bimestre = bimestre;
        this.mes = mes;
        this.tipo = tipo;
        this.fecInicio = fecInicio;
        this.fecFin = fecFin;
        this.fecCierre = fecCierre;
        this.estado = estado;
    }

    public int getIdPeriodo() {
        return idPeriodo;
    }

    public void setIdPeriodo(int idPeriodo) {
        this.idPeriodo = idPeriodo;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public int getIdAnioLectivo() {
        return idAnioLectivo;
    }

    public void setIdAnioLectivo(int idAnioLectivo) {
        this.idAnioLectivo = idAnioLectivo;
    }

    public String getBimestre() {
        return bimestre;
    }

    public void setBimestre(String bimestre) {
        this.bimestre = bimestre;
    }

    public String getMes() {
        return mes;
    }

    public void setMes(String mes) {
        this.mes = mes;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
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

    public Date getFecCierre() {
        return fecCierre;
    }

    public void setFecCierre(Date fecCierre) {
        this.fecCierre = fecCierre;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
    
}
