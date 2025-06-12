
package com.intranet_escolar.model.DTO;

import java.util.Date;

public class CursoDTO {

    private int id;
    private String nombre;
    private String seccion;
    private int totalEstudiantes;
    private double promedio;
    private Date ultimaEvaluacion;
    private String nivel;
    private String grado;

    public CursoDTO() {
    }

    public CursoDTO(int id, String nombre, String seccion, int totalEstudiantes, double promedio, Date ultimaEvaluacion, String nivel, String grado) {
        this.id = id;
        this.nombre = nombre;
        this.seccion = seccion;
        this.totalEstudiantes = totalEstudiantes;
        this.promedio = promedio;
        this.ultimaEvaluacion = ultimaEvaluacion;
        this.nivel = nivel;
        this.grado = grado;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getSeccion() {
        return seccion;
    }

    public void setSeccion(String seccion) {
        this.seccion = seccion;
    }

    public int getTotalEstudiantes() {
        return totalEstudiantes;
    }

    public void setTotalEstudiantes(int totalEstudiantes) {
        this.totalEstudiantes = totalEstudiantes;
    }

    public double getPromedio() {
        return promedio;
    }

    public void setPromedio(double promedio) {
        this.promedio = promedio;
    }

    public Date getUltimaEvaluacion() {
        return ultimaEvaluacion;
    }

    public void setUltimaEvaluacion(Date ultimaEvaluacion) {
        this.ultimaEvaluacion = ultimaEvaluacion;
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
    
}
