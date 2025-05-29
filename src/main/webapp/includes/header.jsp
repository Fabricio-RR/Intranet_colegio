<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
<!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/assets/css/styles.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/dashboard.css" rel="stylesheet">
<header class="dashboard-header">
    <div class="d-flex justify-content-between align-items-center h-100">
        <!-- Lado izquierdo: Botón toggle y título -->
        <div class="d-flex align-items-center">
            <button class="btn d-lg-none me-3" type="button" id="sidebarToggle" aria-label="Menú">
                <i class="fas fa-bars"></i>
            </button>
            <h1 class="h5 d-none d-md-block mb-0">
                <c:out value="${tituloPagina}" default="" />
            </h1>
            <h1 class="h6 d-md-none mb-0">
                <c:out value="${tituloPagina}" default="" />
            </h1>
        </div>

        <!-- Lado derecho: Botones y menú usuario-->
        <div class="d-flex align-items-center">
            <!-- Menú usuario -->
            <div class="dropdown">
                <button class="btn btn-admin-primary btn-sm me-2 dropdown-toggle" type="button" id="dropdownMenuButton" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="fas fa-user-circle me-1"></i>
                    <span class="d-none d-sm-inline">${sessionScope.usuario.nombres} ${sessionScope.usuario.apellidos}</span>
                </button>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="dropdownMenuButton">
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/views/perfil.jsp"><i class="fas fa-user me-2"></i>Mi Perfil</a></li>
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/views/configuracion/.jsp"><i class="fas fa-cog me-2"></i>Configuración</a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/controller/auth?action=logout"><i class="fas fa-sign-out-alt me-2"></i>Cerrar Sesión</a></li>
                </ul>
            </div>
        </div>
    </div>
</header>

<!-- Overlay para móviles (si sidebar usa uno) -->
<div class="sidebar-overlay" id="sidebarOverlay"></div>
