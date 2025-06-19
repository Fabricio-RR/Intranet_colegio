
package com.intranet_escolar.model.entity;

public class Alumno {
    
    private int idAlumno;
    private String codigoMatricula;
    private String grado;
    private String seccion;
    private String nivel;
    private String anio;
    private String nombres;
    private String apellidos;
    private String nombreApoderado;
    private String parentescoApoderado;
    private Usuario usuario;
    
    public Alumno() {
    }

    public Alumno(int idAlumno, String codigoMatricula, String grado, String seccion, String nivel, String anio, String nombres, String apellidos, String nombreApoderado, String parentescoApoderado, Usuario usuario) {
        this.idAlumno = idAlumno;
        this.codigoMatricula = codigoMatricula;
        this.grado = grado;
        this.seccion = seccion;
        this.nivel = nivel;
        this.anio = anio;
        this.nombres = nombres;
        this.apellidos = apellidos;
        this.nombreApoderado = nombreApoderado;
        this.parentescoApoderado = parentescoApoderado;
        this.usuario = usuario;
    }

    public int getIdAlumno() {
        return idAlumno;
    }

    public void setIdAlumno(int idAlumno) {
        this.idAlumno = idAlumno;
    }

    public String getCodigoMatricula() {
        return codigoMatricula;
    }

    public void setCodigoMatricula(String codigoMatricula) {
        this.codigoMatricula = codigoMatricula;
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

    public String getNombres() {
        return nombres;
    }

    public void setNombres(String nombres) {
        this.nombres = nombres;
    }

    public String getApellidos() {
        return apellidos;
    }

    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
    }

    public String getNombreApoderado() {
        return nombreApoderado;
    }

    public void setNombreApoderado(String nombreApoderado) {
        this.nombreApoderado = nombreApoderado;
    }

    public String getParentescoApoderado() {
        return parentescoApoderado;
    }

    public void setParentescoApoderado(String parentescoApoderado) {
        this.parentescoApoderado = parentescoApoderado;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }
    
}
