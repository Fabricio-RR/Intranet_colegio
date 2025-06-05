<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <jsp:include page="/includes/meta.jsp" />
    <title>Seleccionar Acceso</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/login.css" rel="stylesheet">
</head>
<body class="bg-white d-flex flex-column align-items-center justify-content-center min-vh-100">
    <header class="w-100 py-4 custom-header text-white text-center d-flex justify-content-center align-items-center">
        <h1 class="mb-0">COLEGIO PERUANO CHINO DIEZ DE OCTUBRE</h1>
        <img src="${pageContext.request.contextPath}/assets/img/EscudoCDO.png" alt="Escudo CDO" class="ms-3" style="width: 80px; height: 90px;">
    </header>
    <div class="container-fluid d-flex justify-content-center align-items-center flex-grow-1 px-3">
        <div class="selector-container">
            <div class="welcome">
                <div class="logo">
                    <i class="fas fa-school"></i>
                </div>
                <div class="user-name">
                    ${sessionScope.usuario.nombres} ${sessionScope.usuario.apellidos}
                </div>
                <div class="subtitle">Selecciona tu acceso</div>
            </div>
            
            <div class="roles-list">
                <c:forEach var="rol" items="${sessionScope.roles}">
                    <a href="${pageContext.request.contextPath}/selec-rol?rol=${rol.nombre.toLowerCase()}" class="role-card">
                        <div class="d-flex align-items-center">
                            <div class="role-icon" style="background-color:
                                <c:choose>
                                    <c:when test="${rol.nombre eq 'Administrador'}">#0A0A3D</c:when>
                                    <c:when test="${rol.nombre eq 'Docente'}">#007bff</c:when>
                                    <c:when test="${rol.nombre eq 'Estudiante'}">#28a745</c:when>
                                    <c:when test="${rol.nombre eq 'Apoderado'}">#ffc107</c:when>
                                    <c:otherwise>#6c757d</c:otherwise>
                                </c:choose>;">
                                <c:choose>
                                    <c:when test="${rol.nombre eq 'Administrador'}">
                                        <i class="fas fa-user-shield"></i>
                                    </c:when>
                                    <c:when test="${rol.nombre eq 'Docente'}">
                                        <i class="fas fa-chalkboard-teacher"></i>
                                    </c:when>
                                    <c:when test="${rol.nombre eq 'Estudiante'}">
                                        <i class="fas fa-user-graduate"></i>
                                    </c:when>
                                    <c:when test="${rol.nombre eq 'Apoderado'}">
                                        <i class="fas fa-users"></i>
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fas fa-user-tag"></i>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="flex-grow-1 ps-2">
                                <div class="role-title">${rol.nombre}</div>
                                <div class="role-desc">Acceder como ${fn:toLowerCase(rol.nombre)}.</div>
                            </div>
                            <i class="fas fa-arrow-right text-muted"></i>
                        </div>
                    </a>
                </c:forEach>
            </div>
            
            <div class="logout-link">
                <a href="${pageContext.request.contextPath}/controller/auth?action=logout">
                    <i class="fas fa-sign-out-alt me-1"></i>
                    Cerrar Sesión
                </a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Efecto de carga simple
        document.querySelectorAll('.role-card').forEach(card => {
            card.addEventListener('click', function() {
                this.style.opacity = '0.7';
                this.style.pointerEvents = 'none';
            });
        });
    </script>
</body>
</html>