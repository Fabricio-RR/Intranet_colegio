<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<header class="navbar navbar-expand-lg navbar-light bg-white border-bottom fixed-top">
    <div class="container-fluid">
        <!-- Botón para móviles -->
        <button class="navbar-toggler d-lg-none" type="button" id="sidebarToggle">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Espaciador -->
        <div class="flex-grow-1"></div>

        <!-- Navegación -->
        <div class="navbar-nav">
            <!-- Usuario -->
            <div class="nav-item dropdown">
                <a class="nav-link dropdown-toggle d-flex align-items-center text-dark" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                    <img src="${pageContext.request.contextPath}/assets/images/avatar-default.png" alt="Avatar" width="32" height="32" class="rounded-circle me-2">
                    <span>${sessionScope.usuario.nombres} ${sessionScope.usuario.apellidos}</span>
                </a>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/views/perfil/index.jsp">
                        <i class="fas fa-user me-2"></i>Mi Perfil
                    </a></li>
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/views/configuracion/index.jsp">
                        <i class="fas fa-cog me-2"></i>Configuración
                    </a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/controller/auth?action=logout">
                        <i class="fas fa-sign-out-alt me-2"></i>Cerrar Sesión
                    </a></li>
                </ul>
            </div>
        </div>
    </div>
</header>

<!-- Overlay para móviles -->
<div class="sidebar-overlay" id="sidebarOverlay"></div>
