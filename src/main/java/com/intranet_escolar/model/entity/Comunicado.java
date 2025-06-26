package com.intranet_escolar.model.entity;

public class Comunicado {
    private int id;
    private int idUsuario;
    private String titulo;
    private String contenido;
    private String categoria; // 'general' o 'docente'
    private String destinatario; // 'todos', 'docentes', 'estudiantes', 'padres', 'seccion'
    private boolean notificarCorreo;
    private String fecInicio;
    private String fecFin;
    private String archivo; // nombre del archivo o ruta
    private String estado; // 'programada', 'activa', 'expirada', 'archivada'
    private int idAnioLectivo;

    public Comunicado() {
    }

    public Comunicado(int id, int idUsuario, String titulo, String contenido, String categoria, String destinatario, boolean notificarCorreo, String fecInicio, String fecFin, String archivo, String estado, int idAnioLectivo) {
        this.id = id;
        this.idUsuario = idUsuario;
        this.titulo = titulo;
        this.contenido = contenido;
        this.categoria = categoria;
        this.destinatario = destinatario;
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

    public boolean isNotificarCorreo() {
        return notificarCorreo;
    }

    public void setNotificarCorreo(boolean notificarCorreo) {
        this.notificarCorreo = notificarCorreo;
    }

    public String getFecInicio() {
        return fecInicio;
    }

    public void setFecInicio(String fecInicio) {
        this.fecInicio = fecInicio;
    }

    public String getFecFin() {
        return fecFin;
    }

    public void setFecFin(String fecFin) {
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
