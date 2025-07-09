
package com.intranet_escolar.model.DTO;

public class AperturaSeccionDTO {
    private int idAperturaSeccion;
    private int idGrado;
    private int idSeccion;
    private String nivel;
    private String grado;
    private String seccion;
    private String anioLectivo;
    private boolean activo;
  
    public AperturaSeccionDTO() {
    }

    public AperturaSeccionDTO(int idAperturaSeccion, int idGrado, int idSeccion, String nivel, String grado, String seccion, String anioLectivo, boolean activo) {
        this.idAperturaSeccion = idAperturaSeccion;
        this.idGrado = idGrado;
        this.idSeccion = idSeccion;
        this.nivel = nivel;
        this.grado = grado;
        this.seccion = seccion;
        this.anioLectivo = anioLectivo;
        this.activo = activo;
    }

    public int getIdAperturaSeccion() {
        return idAperturaSeccion;
    }

    public void setIdAperturaSeccion(int idAperturaSeccion) {
        this.idAperturaSeccion = idAperturaSeccion;
    }

    public int getIdGrado() {
        return idGrado;
    }

    public void setIdGrado(int idGrado) {
        this.idGrado = idGrado;
    }

    public int getIdSeccion() {
        return idSeccion;
    }

    public void setIdSeccion(int idSeccion) {
        this.idSeccion = idSeccion;
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

    public String getAnioLectivo() {
        return anioLectivo;
    }

    public void setAnioLectivo(String anioLectivo) {
        this.anioLectivo = anioLectivo;
    }

    public boolean isActivo() {
        return activo;
    }

    public void setActivo(boolean activo) {
        this.activo = activo;
    }
    
}
