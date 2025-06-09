
package com.intranet_escolar.model.entity;

import java.util.List;

public class Docente {
    private int totalCursos;
    private List<Curso> cursos;

    public Docente() {
    }

    public Docente(int totalCursos, List<Curso> cursos) {
        this.totalCursos = totalCursos;
        this.cursos = cursos;
    }

    public int getTotalCursos() {
        return totalCursos;
    }

    public void setTotalCursos(int totalCursos) {
        this.totalCursos = totalCursos;
    }

    public List<Curso> getCursos() {
        return cursos;
    }

    public void setCursos(List<Curso> cursos) {
        this.cursos = cursos;
    }
    
}
