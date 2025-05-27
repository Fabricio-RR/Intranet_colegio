package com.intranet_escolar.model.entity;

public class RolPermiso {
    private int idRolPermiso;
    private int idRol;
    private int idPermiso;

    public RolPermiso() {
    }

    public RolPermiso(int idRolPermiso, int idRol, int idPermiso) {
        this.idRolPermiso = idRolPermiso;
        this.idRol = idRol;
        this.idPermiso = idPermiso;
    }

    public int getIdPermiso() {
        return idPermiso;
    }

    public void setIdPermiso(int idPermiso) {
        this.idPermiso = idPermiso;
    }

    public int getIdRolPermiso() {
        return idRolPermiso;
    }

    public void setIdRolPermiso(int idRolPermiso) {
        this.idRolPermiso = idRolPermiso;
    }

    public int getIdRol() {
        return idRol;
    }

    public void setIdRol(int idRol) {
        this.idRol = idRol;
    }
    
    @Override
    public String toString() {
        return "RolPermiso{" +
               "idRolPermiso=" + idRolPermiso +
               ", idRol=" + idRol +
               ", idPermiso=" + idPermiso +
               '}';
    }
}
