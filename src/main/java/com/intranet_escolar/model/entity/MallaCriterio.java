package com.intranet_escolar.model.entity;

public class MallaCriterio {
    private int idMallaCriterio;
    private int idMallaCurricular; 
    private int idPeriodo;
    private int idCriterio;
    private String criterioNombre; 
    private String criterioDescripcion;
    private double base;           
    private String tipo;           
    private String formula;        
    private boolean activo;
        
    public MallaCriterio() {
    }

    public MallaCriterio(int idMallaCriterio, int idMallaCurricular, int idPeriodo, int idCriterio, String criterioNombre, String criterioDescripcion, double base, String tipo, String formula, boolean activo) {
        this.idMallaCriterio = idMallaCriterio;
        this.idMallaCurricular = idMallaCurricular;
        this.idPeriodo = idPeriodo;
        this.idCriterio = idCriterio;
        this.criterioNombre = criterioNombre;
        this.criterioDescripcion = criterioDescripcion;
        this.base = base;
        this.tipo = tipo;
        this.formula = formula;
        this.activo = activo;
    }

    public int getIdMallaCriterio() {
        return idMallaCriterio;
    }

    public void setIdMallaCriterio(int idMallaCriterio) {
        this.idMallaCriterio = idMallaCriterio;
    }

    public int getIdMallaCurricular() {
        return idMallaCurricular;
    }

    public void setIdMallaCurricular(int idMallaCurricular) {
        this.idMallaCurricular = idMallaCurricular;
    }

    public int getIdPeriodo() {
        return idPeriodo;
    }

    public void setIdPeriodo(int idPeriodo) {
        this.idPeriodo = idPeriodo;
    }

    public int getIdCriterio() {
        return idCriterio;
    }

    public void setIdCriterio(int idCriterio) {
        this.idCriterio = idCriterio;
    }

    public String getCriterioNombre() {
        return criterioNombre;
    }

    public void setCriterioNombre(String criterioNombre) {
        this.criterioNombre = criterioNombre;
    }

    public String getCriterioDescripcion() {
        return criterioDescripcion;
    }

    public void setCriterioDescripcion(String criterioDescripcion) {
        this.criterioDescripcion = criterioDescripcion;
    }

    public double getBase() {
        return base;
    }

    public void setBase(double base) {
        this.base = base;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public String getFormula() {
        return formula;
    }

    public void setFormula(String formula) {
        this.formula = formula;
    }

    public boolean isActivo() {
        return activo;
    }

    public void setActivo(boolean activo) {
        this.activo = activo;
    }
    
}
