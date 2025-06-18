package com.intranet_escolar.model.entity;

import java.util.Date;

public class Matricula {
    private int idMatricula;
    private int idAlumno;
    private int idAperturaSeccion;
    private String dni;
    private String nombres;
    private String apellidos;
    private String codigoMatricula;
    private String nivel;
    private String grado;
    private String seccion;
    private String estado; 
    private Date fecha;

    public Matricula() {
    }

    public Matricula(int idMatricula, int idAlumno, int idAperturaSeccion, String dni, String nombres, String apellidos, String codigoMatricula, String nivel, String grado, String seccion, String estado, Date fecha) {
        this.idMatricula = idMatricula;
        this.idAlumno = idAlumno;
        this.idAperturaSeccion = idAperturaSeccion;
        this.dni = dni;
        this.nombres = nombres;
        this.apellidos = apellidos;
        this.codigoMatricula = codigoMatricula;
        this.nivel = nivel;
        this.grado = grado;
        this.seccion = seccion;
        this.estado = estado;
        this.fecha = fecha;
    }

    public int getIdMatricula() {
        return idMatricula;
    }

    public void setIdMatricula(int idMatricula) {
        this.idMatricula = idMatricula;
    }

    public int getIdAlumno() {
        return idAlumno;
    }

    public void setIdAlumno(int idAlumno) {
        this.idAlumno = idAlumno;
    }

    public int getIdAperturaSeccion() {
        return idAperturaSeccion;
    }

    public void setIdAperturaSeccion(int idAperturaSeccion) {
        this.idAperturaSeccion = idAperturaSeccion;
    }

    public String getDni() {
        return dni;
    }

    public void setDni(String dni) {
        this.dni = dni;
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

    public String getCodigoMatricula() {
        return codigoMatricula;
    }

    public void setCodigoMatricula(String codigoMatricula) {
        this.codigoMatricula = codigoMatricula;
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

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }
}
