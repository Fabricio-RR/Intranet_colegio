
package com.intranet_escolar.model.DTO;

import java.util.Date;

public class ExamenDTO {

    private String curso;
    private String seccion;
    private Date fecha;
    private String tipo; // Ejemplo: "Parcial", "Final", "Práctica"
    private int diasRestantes;

    public ExamenDTO() {
    }

    public ExamenDTO(String curso, String seccion, Date fecha, String tipo, int diasRestantes) {
        this.curso = curso;
        this.seccion = seccion;
        this.fecha = fecha;
        this.tipo = tipo;
        this.diasRestantes = diasRestantes;
    }

    public String getCurso() {
        return curso;
    }

    public void setCurso(String curso) {
        this.curso = curso;
    }

    public String getSeccion() {
        return seccion;
    }

    public void setSeccion(String seccion) {
        this.seccion = seccion;
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public int getDiasRestantes() {
        return diasRestantes;
    }

    public void setDiasRestantes(int diasRestantes) {
        this.diasRestantes = diasRestantes;
    }
    
}
