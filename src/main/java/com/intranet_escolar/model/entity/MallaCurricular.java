
package com.intranet_escolar.model.entity;


public class MallaCurricular {
    // Para resumen por nivel
    private int idNivel;
    private String nombreNivel;
    private int totalGrados;
    private int totalCursos;
    private int totalDocentes;
    
    private int totalInactivos;
    private int totalCursosInactivos;
    private int totalSeccionesInactivas;
    private int totalGradosInactivos;


    // Para detalle por curso
    private int idMalla;
    private int idCurso;
    private String nombreCurso;
    private String docente;
    private String grado;
    private String seccion;
    private int orden;
    private boolean activo;

    // Para edición
    private int idDocente;
    private int idAperturaSeccion;
    private String NombreDocente;

    public MallaCurricular() {
    }

    public MallaCurricular(int idNivel, String nombreNivel, int totalGrados, int totalCursos, int totalDocentes, int totalInactivos, int totalCursosInactivos, int totalSeccionesInactivas, int totalGradosInactivos, int idMalla, int idCurso, String nombreCurso, String docente, String grado, String seccion, int orden, boolean activo, int idDocente, int idAperturaSeccion, String NombreDocente) {
        this.idNivel = idNivel;
        this.nombreNivel = nombreNivel;
        this.totalGrados = totalGrados;
        this.totalCursos = totalCursos;
        this.totalDocentes = totalDocentes;
        this.totalInactivos = totalInactivos;
        this.totalCursosInactivos = totalCursosInactivos;
        this.totalSeccionesInactivas = totalSeccionesInactivas;
        this.totalGradosInactivos = totalGradosInactivos;
        this.idMalla = idMalla;
        this.idCurso = idCurso;
        this.nombreCurso = nombreCurso;
        this.docente = docente;
        this.grado = grado;
        this.seccion = seccion;
        this.orden = orden;
        this.activo = activo;
        this.idDocente = idDocente;
        this.idAperturaSeccion = idAperturaSeccion;
        this.NombreDocente = NombreDocente;
    }

    public String getNombreDocente() {
        return NombreDocente;
    }
     public void setNombreDocente(String docente) {
        this.docente = docente;
    }

    public int getIdNivel() {
        return idNivel;
    }

    public void setIdNivel(int idNivel) {
        this.idNivel = idNivel;
    }

    public String getNombreNivel() {
        return nombreNivel;
    }

    public void setNombreNivel(String nombreNivel) {
        this.nombreNivel = nombreNivel;
    }

    public int getTotalGrados() {
        return totalGrados;
    }

    public void setTotalGrados(int totalGrados) {
        this.totalGrados = totalGrados;
    }

    public int getTotalCursos() {
        return totalCursos;
    }

    public void setTotalCursos(int totalCursos) {
        this.totalCursos = totalCursos;
    }

    public int getTotalDocentes() {
        return totalDocentes;
    }

    public void setTotalDocentes(int totalDocentes) {
        this.totalDocentes = totalDocentes;
    }

    public int getTotalInactivos() {
        return totalInactivos;
    }

    public void setTotalInactivos(int totalInactivos) {
        this.totalInactivos = totalInactivos;
    }

    public int getTotalCursosInactivos() {
        return totalCursosInactivos;
    }

    public void setTotalCursosInactivos(int totalCursosInactivos) {
        this.totalCursosInactivos = totalCursosInactivos;
    }

    public int getTotalSeccionesInactivas() {
        return totalSeccionesInactivas;
    }

    public void setTotalSeccionesInactivas(int totalSeccionesInactivas) {
        this.totalSeccionesInactivas = totalSeccionesInactivas;
    }

    public int getTotalGradosInactivos() {
        return totalGradosInactivos;
    }

    public void setTotalGradosInactivos(int totalGradosInactivos) {
        this.totalGradosInactivos = totalGradosInactivos;
    }

    public int getIdMalla() {
        return idMalla;
    }

    public void setIdMalla(int idMalla) {
        this.idMalla = idMalla;
    }

    public int getIdCurso() {
        return idCurso;
    }

    public void setIdCurso(int idCurso) {
        this.idCurso = idCurso;
    }

    public String getNombreCurso() {
        return nombreCurso;
    }

    public void setNombreCurso(String nombreCurso) {
        this.nombreCurso = nombreCurso;
    }

    public String getDocente() {
        return docente;
    }

    public void setDocente(String docente) {
        this.docente = docente;
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

    public int getOrden() {
        return orden;
    }

    public void setOrden(int orden) {
        this.orden = orden;
    }

    public boolean isActivo() {
        return activo;
    }

    public void setActivo(boolean activo) {
        this.activo = activo;
    }

    public int getIdDocente() {
        return idDocente;
    }

    public void setIdDocente(int idDocente) {
        this.idDocente = idDocente;
    }

    public int getIdAperturaSeccion() {
        return idAperturaSeccion;
    }

    public void setIdAperturaSeccion(int idAperturaSeccion) {
        this.idAperturaSeccion = idAperturaSeccion;
    }
    
}


