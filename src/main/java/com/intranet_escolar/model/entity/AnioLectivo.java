
package com.intranet_escolar.model.entity;

public class AnioLectivo {
    private int idAnioLectivo;
    private String nombre;

    public AnioLectivo() {
    }

    public AnioLectivo(int idAnioLectivo, String nombre) {
        this.idAnioLectivo = idAnioLectivo;
        this.nombre = nombre;
    }

    public int getIdAnioLectivo() {
        return idAnioLectivo;
    }

    public void setIdAnioLectivo(int idAnioLectivo) {
        this.idAnioLectivo = idAnioLectivo;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
    
    
    
}
