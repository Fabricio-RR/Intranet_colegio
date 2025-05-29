<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <jsp:include page="/includes/meta.jsp" />
    <title>Dashboard - Intranet Escolar</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/assets/css/styles.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/dashboard.css" rel="stylesheet">
</head>
<body class="admin-dashboard">
    <!-- Sidebar -->
    <jsp:include page="/includes/sidebar.jsp" />
    
    <!-- Header fijo -->
    <%
        request.setAttribute("tituloPagina", "Panel de Administración");
    %>
    <jsp:include page="/includes/header.jsp" />
   
    <!-- Main Content con scroll -->
    <main class="main-content">
        <!-- Información adicional -->
        <div class="row mb-4 fade-in-up">
            <div class="col-12">
                <div class="alert alert-info">
                    <i class="fas fa-info-circle me-2"></i>
                    Bienvenido, ${sessionScope.usuario.nombres} ${sessionScope.usuario.apellidos}
                    <span class="ms-3">
                        <i class="fas fa-calendar me-1"></i>
                        <fmt:formatDate value="${now}" pattern="EEEE, dd 'de' MMMM 'de' yyyy" />
                    </span>
                </div>
            </div>
        </div>

        <!-- Estadísticas Principales -->
        <div class="row mb-4">
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="card stats-card h-100 fade-in-up" style="animation-delay: 0.1s;">
                    <div class="card-body">
                        <div class="d-flex align-items-center">
                            <div class="stats-icon stats-primary me-3">
                                <i class="fas fa-user-graduate"></i>
                            </div>
                            <div class="flex-grow-1">
                                <div class="stats-label">Total Estudiantes</div>
                                <div class="stats-number">${totalEstudiantes}</div>
                                <div class="stats-change positive">
                                    <c:if test="${not empty cambioEstudiantes}">
                                        <i class="fas fa-arrow-up me-1"></i>${cambioEstudiantes}
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="card stats-card h-100 fade-in-up" style="animation-delay: 0.2s;">
                    <div class="card-body">
                        <div class="d-flex align-items-center">
                            <div class="stats-icon stats-success me-3">
                                <i class="fas fa-chalkboard-teacher"></i>
                            </div>
                            <div class="flex-grow-1">
                                <div class="stats-label">Total Docentes</div>
                                <div class="stats-number">${totalDocentes}</div>
                                <div class="stats-change positive">
                                    <c:if test="${not empty cambioDocentes}">
                                        <i class="fas fa-arrow-up me-1"></i>${cambioDocentes}
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="card stats-card h-100 fade-in-up" style="animation-delay: 0.3s;">
                    <div class="card-body">
                        <div class="d-flex align-items-center">
                            <div class="stats-icon stats-warning me-3">
                                <i class="fas fa-users"></i>
                            </div>
                            <div class="flex-grow-1">
                                <div class="stats-label">Total Apoderados</div>
                                <div class="stats-number">${totalApoderados}</div>
                                <div class="stats-change positive">
                                    <c:if test="${not empty cambioApoderados}">
                                        <i class="fas fa-arrow-up me-1"></i>${cambioApoderados}
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="card stats-card h-100 fade-in-up" style="animation-delay: 0.4s;">
                    <div class="card-body">
                        <div class="d-flex align-items-center">
                            <div class="stats-icon stats-info me-3">
                                <i class="fas fa-school"></i>
                            </div>
                            <div class="flex-grow-1">
                                <div class="stats-label">Secciones Activas</div>
                                <div class="stats-number">${seccionesActivas}</div>
                                <div class="stats-change">
                                    <c:if test="${not empty cambioSecciones}">
                                        <i class="fas fa-minus me-1"></i>${cambioSecciones}
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Gráficos -->
        <div class="row mb-4">
            <div class="col-lg-8 mb-4">
                <div class="chart-container fade-in-up" style="animation-delay: 0.5s;">
                    <h5 class="chart-title">
                        <i class="fas fa-chart-bar me-2"></i>
                        Matrícula por Nivel Educativo
                    </h5>
                    <canvas id="matriculaPorNivelChart" style="height: 300px;"></canvas>
                </div>
            </div>
            <div class="col-lg-4 mb-4">
                <div class="chart-container fade-in-up" style="animation-delay: 0.6s;">
                    <h5 class="chart-title">
                        <i class="fas fa-chart-pie me-2"></i>
                        Distribución por Género
                    </h5>
                    <canvas id="distribucionGeneroChart" style="height: 300px;"></canvas>
                </div>
            </div>
        </div>

        <!-- Acciones Rápidas Mejoradas -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="quick-actions fade-in-up" style="animation-delay: 0.7s;">
                    <h5>
                        <i class="fas fa-bolt me-2"></i>
                        Acciones Rápidas
                    </h5>
                    <div class="row">
                        <div class="col-lg-3 col-md-6 mb-3">
                            <a href="${pageContext.request.contextPath}/views/usuarios/crear.jsp" 
                               class="quick-action">
                                <i class="fas fa-user-plus"></i>
                                <span>Nuevo Usuario</span>
                            </a>
                        </div>
                        <div class="col-lg-3 col-md-6 mb-3">
                            <a href="${pageContext.request.contextPath}/views/estructura/secciones.jsp" 
                               class="quick-action">
                                <i class="fas fa-plus-circle"></i>
                                <span>Nueva Sección</span>
                            </a>
                        </div>
                        <div class="col-lg-3 col-md-6 mb-3">
                            <a href="${pageContext.request.contextPath}/views/matriculas/nueva.jsp" 
                               class="quick-action">
                                <i class="fas fa-user-graduate"></i>
                                <span>Nueva Matrícula</span>
                            </a>
                        </div>
                        <div class="col-lg-3 col-md-6 mb-3">
                            <a href="${pageContext.request.contextPath}/views/reportes/index.jsp" 
                               class="quick-action">
                                <i class="fas fa-chart-line"></i>
                                <span>Generar Reporte</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Actividad Reciente y Alertas -->
        <div class="row mb-4">
            <div class="col-lg-6 mb-4">
                <div class="chart-container fade-in-up" style="animation-delay: 0.8s;">
                    <h5 class="chart-title">
                        <i class="fas fa-history me-2"></i>
                        Actividad Reciente del Sistema
                    </h5>
                    <div class="activity-list"></div>
                </div>
            </div>
            <div class="col-lg-6 mb-4">
                <div class="system-alerts fade-in-up" style="animation-delay: 0.9s;">
                    <h5 class="chart-title">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        Alertas del Sistema
                    </h5>
                    
                    <!-- Alertas dinámicas -->
                    <c:choose>
                        <c:when test="${not empty alertas}">
                            <c:forEach items="${alertas}" var="alerta">
                                <div class="alert-item alert-${alerta.tipo}">
                                    <div class="alert-icon">
                                        <i class="${alerta.icono}"></i>
                                    </div>
                                    <div class="alert-content">
                                        <h6>${alerta.titulo}</h6>
                                        <p>${alerta.mensaje}</p>
                                        <c:if test="${not empty alerta.accion}">
                                            <a href="${alerta.enlace}" class="btn btn-sm btn-admin-primary mt-2">
                                                ${alerta.accion}
                                            </a>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-4">
                                <i class="fas fa-check-circle fa-3x text-success mb-3 pulse"></i>
                                <p class="text-muted mb-0">No hay alertas pendientes</p>
                                <small class="text-muted">El sistema está funcionando correctamente</small>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- Resumen de Usuarios por Rol -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="admin-table fade-in-up" style="animation-delay: 1s;">
                    <div class="d-flex justify-content-between align-items-center p-3 border-bottom">
                        <h5 class="mb-0">
                            <i class="fas fa-users-cog me-2"></i>
                            Resumen de Usuarios por Rol
                        </h5>
                        <a href="${pageContext.request.contextPath}/views/usuarios/index.jsp" 
                           class="btn btn-admin-primary btn-sm">
                            <i class="fas fa-eye me-1"></i>
                            Ver Todos
                        </a>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>Rol</th>
                                    <th>Total Usuarios</th>
                                    <th>Activos</th>
                                    <th>Inactivos</th>
                                    <th>Último Acceso</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty resumenRoles}">
                                        <c:forEach items="${resumenRoles}" var="rol">
                                            <tr>
                                                <td>
                                                    <i class="${rol.icono} me-2"></i>
                                                    ${rol.nombre}
                                                </td>
                                                <td><span class="badge badge-admin-active">${rol.total}</span></td>
                                                <td><span class="text-success fw-bold">${rol.activos}</span></td>
                                                <td><span class="text-warning fw-bold">${rol.inactivos}</span></td>
                                                <td>${rol.ultimoAcceso}</td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/views/usuarios/index.jsp?rol=${rol.codigo}" 
                                                       class="btn btn-sm btn-outline-primary">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="6" class="text-center text-muted py-4">
                                                No hay datos de usuarios disponibles
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <jsp:include page="/includes/footer.jsp" />
    </main>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
    <script>
document.addEventListener('DOMContentLoaded', function() {
    // Solo inicializar gráficos básicos si Chart.js está disponible
    if (typeof Chart !== "undefined") {
        initCharts();
    }
});

function initCharts() {
    // Gráfico de matrícula por nivel
    const matriculaCtx = document.getElementById('matriculaPorNivelChart');
    if (matriculaCtx) {
        new Chart(matriculaCtx, {
            type: 'bar',
            data: {
                labels: ['Inicial', 'Primaria', 'Secundaria'],
                datasets: [{
                    label: 'Estudiantes',
                    data: [${matriculaInicial}, ${matriculaPrimaria}, ${matriculaSecundaria}],
                    backgroundColor: [
                        'rgba(17, 13, 89, 0.8)',
                        'rgba(40, 167, 69, 0.8)',
                        'rgba(247, 6, 23, 0.8)'
                    ],
                    borderColor: [
                        'rgba(17, 13, 89, 1)',
                        'rgba(40, 167, 69, 1)',
                        'rgba(247, 6, 23, 1)'
                    ],
                    borderWidth: 2,
                    borderRadius: 8
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: 'rgba(0,0,0,0.1)'
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        }
                    }
                }
            }
        });
    }

    // Gráfico de distribución por género
    const generoCtx = document.getElementById('distribucionGeneroChart');
    if (generoCtx) {
        new Chart(generoCtx, {
            type: 'doughnut',
            data: {
                labels: ['Masculino', 'Femenino'],
                datasets: [{
                    data: [${estudiantesMasculino}, ${estudiantesFemenino}],
                    backgroundColor: [
                        'rgba(17, 13, 89, 0.8)',
                        'rgba(247, 6, 23, 0.8)'
                    ],
                    borderColor: [
                        'rgba(17, 13, 89, 1)',
                        'rgba(247, 6, 23, 1)'
                    ],
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            padding: 20,
                            usePointStyle: true
                        }
                    }
                },
                cutout: '60%'
            }
        });
    }
}
</script>
</body>
</html>
