package com.intranet_escolar.model.entity;

import java.util.Date;

public class Matricula {
    private int idMatricula;
    private int idAlumno;
    private int idAperturaSeccion;
    // Datos del alumno
    private String dni;
    private String nombres;
    private String apellidos;
    private String codigoMatricula;
    // Datos de apoderado
    private String dniApoderado;
    private String nombresApoderado;
    private String apellidosApoderado;
    private String parentesco;
    // Datos académicos
    private int idNivel;
    private String nivel;
    private int idGrado;
    private String grado;
    private int idSeccion;
    private String seccion;
    private String estado; 
    private String observacion;
    private Date fecha;
    // Otras vistas
    private Alumno alumno;
    private Apoderado apoderado;
    
    public Matricula() {
    }    

    public Matricula(int idMatricula, int idAlumno, int idAperturaSeccion, String dni, String nombres, String apellidos, String codigoMatricula, String dniApoderado, String nombresApoderado, String apellidosApoderado, String parentesco, int idNivel, String nivel, int idGrado, String grado, int idSeccion, String seccion, String estado, String observacion, Date fecha, Alumno alumno, Apoderado apoderado) {
        this.idMatricula = idMatricula;
        this.idAlumno = idAlumno;
        this.idAperturaSeccion = idAperturaSeccion;
        this.dni = dni;
        this.nombres = nombres;
        this.apellidos = apellidos;
        this.codigoMatricula = codigoMatricula;
        this.dniApoderado = dniApoderado;
        this.nombresApoderado = nombresApoderado;
        this.apellidosApoderado = apellidosApoderado;
        this.parentesco = parentesco;
        this.idNivel = idNivel;
        this.nivel = nivel;
        this.idGrado = idGrado;
        this.grado = grado;
        this.idSeccion = idSeccion;
        this.seccion = seccion;
        this.estado = estado;
        this.observacion = observacion;
        this.fecha = fecha;
        this.alumno = alumno;
        this.apoderado = apoderado;
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

    public String getDniApoderado() {
        return dniApoderado;
    }

    public void setDniApoderado(String dniApoderado) {
        this.dniApoderado = dniApoderado;
    }

    public String getNombresApoderado() {
        return nombresApoderado;
    }

    public void setNombresApoderado(String nombresApoderado) {
        this.nombresApoderado = nombresApoderado;
    }

    public String getApellidosApoderado() {
        return apellidosApoderado;
    }

    public void setApellidosApoderado(String apellidosApoderado) {
        this.apellidosApoderado = apellidosApoderado;
    }

    public String getParentesco() {
        return parentesco;
    }

    public void setParentesco(String parentesco) {
        this.parentesco = parentesco;
    }

    public int getIdNivel() {
        return idNivel;
    }

    public void setIdNivel(int idNivel) {
        this.idNivel = idNivel;
    }

    public String getNivel() {
        return nivel;
    }

    public void setNivel(String nivel) {
        this.nivel = nivel;
    }

    public int getIdGrado() {
        return idGrado;
    }

    public void setIdGrado(int idGrado) {
        this.idGrado = idGrado;
    }

    public String getGrado() {
        return grado;
    }

    public void setGrado(String grado) {
        this.grado = grado;
    }

    public int getIdSeccion() {
        return idSeccion;
    }

    public void setIdSeccion(int idSeccion) {
        this.idSeccion = idSeccion;
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

    public String getObservacion() {
        return observacion;
    }

    public void setObservacion(String observacion) {
        this.observacion = observacion;
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }

    public Alumno getAlumno() {
        return alumno;
    }

    public void setAlumno(Alumno alumno) {
        this.alumno = alumno;
    }

    public Apoderado getApoderado() {
        return apoderado;
    }

    public void setApoderado(Apoderado apoderado) {
        this.apoderado = apoderado;
    }
    
}
