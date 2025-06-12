
package com.intranet_escolar.model.DTO;


public class ClaseDTO {
    private String horaInicio;
    private String horaFin;
    private String nombreCurso;
    private String seccion;
    private String nivel;
    private String grado;
    private String estado; 

    public ClaseDTO() {
    }

    public ClaseDTO(String horaInicio, String horaFin, String nombreCurso, String seccion, String nivel, String grado, String estado) {
        this.horaInicio = horaInicio;
        this.horaFin = horaFin;
        this.nombreCurso = nombreCurso;
        this.seccion = seccion;
        this.nivel = nivel;
        this.grado = grado;
        this.estado = estado;
    }

    public String getHoraInicio() {
        return horaInicio;
    }

    public void setHoraInicio(String horaInicio) {
        this.horaInicio = horaInicio;
    }

    public String getHoraFin() {
        return horaFin;
    }

    public void setHoraFin(String horaFin) {
        this.horaFin = horaFin;
    }

    public String getNombreCurso() {
        return nombreCurso;
    }

    public void setNombreCurso(String nombreCurso) {
        this.nombreCurso = nombreCurso;
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

    public String getGrado() {
        return grado;
    }

    public void setGrado(String grado) {
        this.grado = grado;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
    
}
