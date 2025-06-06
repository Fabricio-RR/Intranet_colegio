package com.intranet_escolar.model.entity;

import java.util.*;

public class Usuario {
    private int idUsuario;
    private String dni;
    private String nombres;
    private String apellidos;
    private String correo;
    private String telefono;
    private String clave;
    private boolean estado;
    private Date fecRegistro;
    private String fotoPerfil;
    private List<Rol> roles;
    private Alumno alumno;
    private Docente docente;
    private Apoderado apoderado;
    private boolean esAlumno;
    private boolean esDocente;
    private boolean esApoderado;

    public Usuario() {
        roles = new ArrayList<>();
    }

    public Usuario(int idUsuario, String dni, String nombres, String apellidos, String correo, String telefono, String clave, boolean estado, Date fecRegistro, String fotoPerfil, List<Rol> roles, Alumno alumno, Docente docente, Apoderado apoderado, boolean esAlumno, boolean esDocente, boolean esApoderado) {
        this.idUsuario = idUsuario;
        this.dni = dni;
        this.nombres = nombres;
        this.apellidos = apellidos;
        this.correo = correo;
        this.telefono = telefono;
        this.clave = clave;
        this.estado = estado;
        this.fecRegistro = fecRegistro;
        this.fotoPerfil = fotoPerfil;
        this.roles = roles;
        this.alumno = alumno;
        this.docente = docente;
        this.apoderado = apoderado;
        this.esAlumno = esAlumno;
        this.esDocente = esDocente;
        this.esApoderado = esApoderado;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
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

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getClave() {
        return clave;
    }

    public void setClave(String clave) {
        this.clave = clave;
    }

    public boolean isEstado() {
        return estado;
    }

    public void setEstado(boolean estado) {
        this.estado = estado;
    }

    public Date getFecRegistro() {
        return fecRegistro;
    }

    public void setFecRegistro(Date fecRegistro) {
        this.fecRegistro = fecRegistro;
    }

    public String getFotoPerfil() {
        return fotoPerfil;
    }

    public void setFotoPerfil(String fotoPerfil) {
        this.fotoPerfil = fotoPerfil;
    }

    public List<Rol> getRoles() {
        return roles;
    }

    public void setRoles(List<Rol> roles) {
        this.roles = roles;
    }

    public Alumno getAlumno() {
        return alumno;
    }

    public void setAlumno(Alumno alumno) {
        this.alumno = alumno;
    }

    public Docente getDocente() {
        return docente;
    }

    public void setDocente(Docente docente) {
        this.docente = docente;
    }

    public Apoderado getApoderado() {
        return apoderado;
    }

    public void setApoderado(Apoderado apoderado) {
        this.apoderado = apoderado;
    }

    public boolean isEsAlumno() {
        return esAlumno;
    }

    public void setEsAlumno(boolean esAlumno) {
        this.esAlumno = esAlumno;
    }

    public boolean isEsDocente() {
        return esDocente;
    }

    public void setEsDocente(boolean esDocente) {
        this.esDocente = esDocente;
    }

    public boolean isEsApoderado() {
        return esApoderado;
    }

    public void setEsApoderado(boolean esApoderado) {
        this.esApoderado = esApoderado;
    }
    
        @Override
    public String toString() {
        return "Usuario{" +
               "idUsuario=" + idUsuario +
               ", dni='" + dni + '\'' +
               ", nombres='" + nombres + '\'' +
               ", apellidos='" + apellidos + '\'' +
               ", correo='" + correo + '\'' +
               ", telefono='" + telefono + '\'' +
               ", clave='********'" + 
               ", estado=" + estado +
               ", fecRegistro=" + fecRegistro +
               ", fotoPerfil='" + fotoPerfil + '\'' +
               '}';
    }
    public List<Integer> getRolesAsIds() {
    List<Integer> ids = new ArrayList<>();
    if (roles != null) {
        for (Rol rol : roles) {
            ids.add(rol.getIdRol());
        }
    }
    return ids;
}

}
