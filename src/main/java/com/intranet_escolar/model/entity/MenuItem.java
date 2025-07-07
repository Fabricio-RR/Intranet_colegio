package com.intranet_escolar.model.entity;

import java.util.List;

public class MenuItem {
    private String id;
    private String titulo;
    private String url;
    private String icono;
    private List<MenuItem> subMenu;

    public MenuItem() {
    }
    
    public MenuItem(String titulo, String url, String icono) {
        this.id = generarIdDesdeTitulo(titulo);
        this.titulo = titulo;
        this.url = url;
        this.icono = icono;
    }
    
    public MenuItem(String titulo, String url, String icono, List<MenuItem> subMenu) {
        this.id = generarIdDesdeTitulo(titulo);
        this.titulo = titulo;
        this.url = url;
        this.icono = icono;
        this.subMenu = subMenu;
    }

    
    private String generarIdDesdeTitulo(String titulo) {
        return titulo.toLowerCase().replace(" ", "_");
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
        this.id = generarIdDesdeTitulo(titulo);
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getIcono() {
        return icono;
    }

    public void setIcono(String icono) {
        this.icono = icono;
    }

    public List<MenuItem> getSubMenu() {
        return subMenu;
    }

    public void setSubMenu(List<MenuItem> subMenu) {
        this.subMenu = subMenu;
    }
}
