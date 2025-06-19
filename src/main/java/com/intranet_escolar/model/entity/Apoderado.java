
package com.intranet_escolar.model.entity;

import java.util.List;


public class Apoderado {
    private String parentesco;
    private List<Alumno> hijos;
    private Usuario usuario;

    public Apoderado() {
    }

    public Apoderado(String parentesco, List<Alumno> hijos, Usuario usuario) {
        this.parentesco = parentesco;
        this.hijos = hijos;
        this.usuario = usuario;
    }

    public String getParentesco() {
        return parentesco;
    }

    public void setParentesco(String parentesco) {
        this.parentesco = parentesco;
    }

    public List<Alumno> getHijos() {
        return hijos;
    }

    public void setHijos(List<Alumno> hijos) {
        this.hijos = hijos;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }    
}
