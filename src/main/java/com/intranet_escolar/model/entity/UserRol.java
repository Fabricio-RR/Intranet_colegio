package com.intranet_escolar.model.entity;

public class UserRol {
    private int idUsuario;
    private int idRol;

    public UserRol() {
    }

    public UserRol(int idUsuario, int idRol) {
        this.idUsuario = idUsuario;
        this.idRol = idRol;
    }

    public int getIdRol() {
        return idRol;
    }

    public void setIdRol(int idRol) {
        this.idRol = idRol;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }
    
    @Override
    public String toString() {
        return "UserRol{" +
               "idUsuario=" + idUsuario +
               ", idRol=" + idRol +
               '}';
    }
}
