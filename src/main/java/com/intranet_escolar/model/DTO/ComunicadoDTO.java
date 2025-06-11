
package com.intranet_escolar.model.DTO;

import java.util.Date;

public class ComunicadoDTO {
    private String titulo;
    private String contenido;
    private Date fecha;
    private boolean importante;

    public ComunicadoDTO() {
    }

    public ComunicadoDTO(String titulo, String contenido, Date fecha, boolean importante) {
        this.titulo = titulo;
        this.contenido = contenido;
        this.fecha = fecha;
        this.importante = importante;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getContenido() {
        return contenido;
    }

    public void setContenido(String contenido) {
        this.contenido = contenido;
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }

    public boolean isImportante() {
        return importante;
    }

    public void setImportante(boolean importante) {
        this.importante = importante;
    }
    
    
}
