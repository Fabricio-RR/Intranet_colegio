
package com.intranet_escolar.model.DTO;

public class AperturaSeccionDTO {
    private int idAperturaSeccion;
    private String nivel;
    private String grado;
    private String seccion;
    private String anioLectivo;

    public AperturaSeccionDTO() {
    }

    public AperturaSeccionDTO(int idAperturaSeccion, String nivel, String grado, String seccion, String anioLectivo) {
        this.idAperturaSeccion = idAperturaSeccion;
        this.nivel = nivel;
        this.grado = grado;
        this.seccion = seccion;
        this.anioLectivo = anioLectivo;
    }

    public int getIdAperturaSeccion() {
        return idAperturaSeccion;
    }

    public void setIdAperturaSeccion(int idAperturaSeccion) {
        this.idAperturaSeccion = idAperturaSeccion;
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
    
    
}
