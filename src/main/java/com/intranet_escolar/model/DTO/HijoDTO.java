
package com.intranet_escolar.model.DTO;

public class HijoDTO {
    private int id;
    private String nombres;
    private String apellidos;
    private String grado;
    private String seccion;
    private String codigo;
    private String foto;
    private double promedioGeneral;
    private double porcentajeAsistencia;
    private double puntajeConducta;
    private int posicion;

    public HijoDTO() {
    }

    public HijoDTO(int id, String nombres, String apellidos, String grado, String seccion, String codigo, String foto, double promedioGeneral, double porcentajeAsistencia, double puntajeConducta, int posicion) {
        this.id = id;
        this.nombres = nombres;
        this.apellidos = apellidos;
        this.grado = grado;
        this.seccion = seccion;
        this.codigo = codigo;
        this.foto = foto;
        this.promedioGeneral = promedioGeneral;
        this.porcentajeAsistencia = porcentajeAsistencia;
        this.puntajeConducta = puntajeConducta;
        this.posicion = posicion;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public String getFoto() {
        return foto;
    }

    public void setFoto(String foto) {
        this.foto = foto;
    }

    public double getPromedioGeneral() {
        return promedioGeneral;
    }

    public void setPromedioGeneral(double promedioGeneral) {
        this.promedioGeneral = promedioGeneral;
    }

    public double getPorcentajeAsistencia() {
        return porcentajeAsistencia;
    }

    public void setPorcentajeAsistencia(double porcentajeAsistencia) {
        this.porcentajeAsistencia = porcentajeAsistencia;
    }

    public double getPuntajeConducta() {
        return puntajeConducta;
    }

    public void setPuntajeConducta(double puntajeConducta) {
        this.puntajeConducta = puntajeConducta;
    }

    public int getPosicion() {
        return posicion;
    }

    public void setPosicion(int posicion) {
        this.posicion = posicion;
    }
    
}





