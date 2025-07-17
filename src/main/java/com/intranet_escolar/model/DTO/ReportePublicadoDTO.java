
package com.intranet_escolar.model.DTO;

import java.util.Date;

public class ReportePublicadoDTO {
    private int idReporte;
    private String tipoReporte;
    private String periodo;
    private String nivel;
    private String grado;
    private String seccion;
    private Date fechaPublicacion;
    private String publicadoPor;
    private String archivo;
    private String anio;

    public ReportePublicadoDTO() {
    }

    public ReportePublicadoDTO(int idReporte, String tipoReporte, String periodo, String nivel, String grado, String seccion, Date fechaPublicacion, String publicadoPor, String archivo, String anio) {
        this.idReporte = idReporte;
        this.tipoReporte = tipoReporte;
        this.periodo = periodo;
        this.nivel = nivel;
        this.grado = grado;
        this.seccion = seccion;
        this.fechaPublicacion = fechaPublicacion;
        this.publicadoPor = publicadoPor;
        this.archivo = archivo;
        this.anio = anio;
    }

    public int getIdReporte() {
        return idReporte;
    }

    public void setIdReporte(int idReporte) {
        this.idReporte = idReporte;
    }

    public String getTipoReporte() {
        return tipoReporte;
    }

    public void setTipoReporte(String tipoReporte) {
        this.tipoReporte = tipoReporte;
    }

    public String getPeriodo() {
        return periodo;
    }

    public void setPeriodo(String periodo) {
        this.periodo = periodo;
    }

    public String getNivel() {
        return nivel;
    }

    public void setNivel(String nivel) {
        this.nivel = nivel;
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

    public Date getFechaPublicacion() {
        return fechaPublicacion;
    }

    public void setFechaPublicacion(Date fechaPublicacion) {
        this.fechaPublicacion = fechaPublicacion;
    }

    public String getPublicadoPor() {
        return publicadoPor;
    }

    public void setPublicadoPor(String publicadoPor) {
        this.publicadoPor = publicadoPor;
    }

    public String getArchivo() {
        return archivo;
    }

    public void setArchivo(String archivo) {
        this.archivo = archivo;
    }

    public String getAnio() {
        return anio;
    }

    public void setAnio(String anio) {
        this.anio = anio;
    }
    
    
}
