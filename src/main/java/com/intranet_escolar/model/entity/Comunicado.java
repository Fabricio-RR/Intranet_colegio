package com.intranet_escolar.model.entity;

import java.util.Date;

public class Comunicado {
    private int id;
    private int idUsuario;
    private String titulo;
    private String contenido;
    private String categoria; // 'general' o 'docente'
    private String destinatario; // 'todos', 'docentes', 'estudiantes', 'padres', 'seccion'
    private String destinatarioSeccion; // 'Padres', 'Estudiantes' — si aplica
    private Integer idAperturaSeccion; // si aplica
    private boolean notificarCorreo;
    private Date fecInicio;
    private Date fecFin;
    private String archivo; // nombre del archivo o ruta
    private String estado; // 'programada', 'activa', 'expirada', 'archivada'
    private int idAnioLectivo;

    public Comunicado() {
    }

    public Comunicado(int id, int idUsuario, String titulo, String contenido, String categoria, String destinatario, String destinatarioSeccion, Integer idAperturaSeccion, boolean notificarCorreo, Date fecInicio, Date fecFin, String archivo, String estado, int idAnioLectivo) {
        this.id = id;
        this.idUsuario = idUsuario;
        this.titulo = titulo;
        this.contenido = contenido;
        this.categoria = categoria;
        this.destinatario = destinatario;
        this.destinatarioSeccion = destinatarioSeccion;
        this.idAperturaSeccion = idAperturaSeccion;
        this.notificarCorreo = notificarCorreo;
        this.fecInicio = fecInicio;
        this.fecFin = fecFin;
        this.archivo = archivo;
        this.estado = estado;
        this.idAnioLectivo = idAnioLectivo;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
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

    public String getCategoria() {
        return categoria;
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }

    public String getDestinatario() {
        return destinatario;
    }

    public void setDestinatario(String destinatario) {
        this.destinatario = destinatario;
    }

    public String getDestinatarioSeccion() {
        return destinatarioSeccion;
    }

    public void setDestinatarioSeccion(String destinatarioSeccion) {
        this.destinatarioSeccion = destinatarioSeccion;
    }

    public Integer getIdAperturaSeccion() {
        return idAperturaSeccion;
    }

    public void setIdAperturaSeccion(Integer idAperturaSeccion) {
        this.idAperturaSeccion = idAperturaSeccion;
    }

    public boolean isNotificarCorreo() {
        return notificarCorreo;
    }

    public void setNotificarCorreo(boolean notificarCorreo) {
        this.notificarCorreo = notificarCorreo;
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

    public String getArchivo() {
        return archivo;
    }

    public void setArchivo(String archivo) {
        this.archivo = archivo;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public int getIdAnioLectivo() {
        return idAnioLectivo;
    }

    public void setIdAnioLectivo(int idAnioLectivo) {
        this.idAnioLectivo = idAnioLectivo;
    }
    
}
