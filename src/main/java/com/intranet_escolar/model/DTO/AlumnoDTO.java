/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.intranet_escolar.model.DTO;

import java.util.List;

/**
 *
 * @author Hp
 */
public class AlumnoDTO {
    private double promedioGeneral;
    private double cambioPromedio;
    private double porcentajeAsistencia;
    private int diasAsistidos;
    private double puntajeConducta;
    private int meritos;
    private int totalCursos;
    private int cursosAprobados;

    public AlumnoDTO() {
    }

    public AlumnoDTO(double promedioGeneral, double cambioPromedio, double porcentajeAsistencia, int diasAsistidos, double puntajeConducta, int meritos, int totalCursos, int cursosAprobados) {
        this.promedioGeneral = promedioGeneral;
        this.cambioPromedio = cambioPromedio;
        this.porcentajeAsistencia = porcentajeAsistencia;
        this.diasAsistidos = diasAsistidos;
        this.puntajeConducta = puntajeConducta;
        this.meritos = meritos;
        this.totalCursos = totalCursos;
        this.cursosAprobados = cursosAprobados;
    }

    public double getPromedioGeneral() {
        return promedioGeneral;
    }

    public void setPromedioGeneral(double promedioGeneral) {
        this.promedioGeneral = promedioGeneral;
    }

    public double getCambioPromedio() {
        return cambioPromedio;
    }

    public void setCambioPromedio(double cambioPromedio) {
        this.cambioPromedio = cambioPromedio;
    }

    public double getPorcentajeAsistencia() {
        return porcentajeAsistencia;
    }

    public void setPorcentajeAsistencia(double porcentajeAsistencia) {
        this.porcentajeAsistencia = porcentajeAsistencia;
    }

    public int getDiasAsistidos() {
        return diasAsistidos;
    }

    public void setDiasAsistidos(int diasAsistidos) {
        this.diasAsistidos = diasAsistidos;
    }

    public double getPuntajeConducta() {
        return puntajeConducta;
    }

    public void setPuntajeConducta(double puntajeConducta) {
        this.puntajeConducta = puntajeConducta;
    }

    public int getMeritos() {
        return meritos;
    }

    public void setMeritos(int meritos) {
        this.meritos = meritos;
    }

    public int getTotalCursos() {
        return totalCursos;
    }

    public void setTotalCursos(int totalCursos) {
        this.totalCursos = totalCursos;
    }

    public int getCursosAprobados() {
        return cursosAprobados;
    }

    public void setCursosAprobados(int cursosAprobados) {
        this.cursosAprobados = cursosAprobados;
    }
    
    
}
