
package com.intranet_escolar.model.entity;

public class Alumno {
    
    private String codigo_matricula;
    private String grado;
    private String seccion;

    public Alumno() {
    }

    public Alumno(String codigo_matricula, String grado, String seccion) {
        this.codigo_matricula = codigo_matricula;
        this.grado = grado;
        this.seccion = seccion;
    }

    public String getCodigo_matricula() {
        return codigo_matricula;
    }

    public void setCodigo_matricula(String codigo_matricula) {
        this.codigo_matricula = codigo_matricula;
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
    
    

}
