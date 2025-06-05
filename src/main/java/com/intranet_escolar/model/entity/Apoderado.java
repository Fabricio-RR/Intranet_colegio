
package com.intranet_escolar.model.entity;

import java.util.List;


public class Apoderado {
    private List<Alumno> hijos;

    public Apoderado() {
    }

    public Apoderado(List<Alumno> hijos) {
        this.hijos = hijos;
    }

    public List<Alumno> getHijos() {
        return hijos;
    }

    public void setHijos(List<Alumno> hijos) {
        this.hijos = hijos;
    }  
}
