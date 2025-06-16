<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <jsp:include page="/includes/meta.jsp" />
    <title>Mi Portal Estudiantil - Intranet Escolar</title>
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
<body class="estudiante-dashboard">
    <!-- Sidebar -->
    <jsp:include page="/includes/sidebar.jsp" />
    <c:set var="tituloPaginaDesktop" value="Mi Portal Estudiantil" scope="request" />
    <c:set var="tituloPaginaMobile" value="Mi Portal" scope="request" />
    <c:set var="iconoPagina" value="fas fa-graduation-cap" scope="request" />
    <jsp:include page="/includes/header.jsp" />
   
    <!-- Main Content -->
    <main class="main-content">
        <!-- Información de bienvenida -->
        <div class="row mb-4 fade-in-up">
            <div class="col-12">
                <div class="alert alert-info">
                    <i class="fas fa-user-graduate me-2"></i>
                    Hola, ${sessionScope.usuario.nombres} ${sessionScope.usuario.apellidos}
                    <span class="ms-3">
                        <i> | </i>
                        ${sessionScope.usuario.alumno.grado} "${sessionScope.usuario.alumno.seccion}" - ${sessionScope.usuario.alumno.nivel} (${sessionScope.usuario.alumno.anio})
                    </span>
                    <span class="ms-3">
                        <i class="fas fa-calendar me-1"></i>
                        <fmt:formatDate value="${now}" pattern="EEEE, dd 'de' MMMM 'de' yyyy" />
                    </span>
                </div>
            </div>
        </div>

        <!-- Resumen Académico -->
        <div class="row mb-4">
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="card stats-card h-100 fade-in-up" style="animation-delay: 0.1s;">
                    <div class="card-body">
                        <div class="d-flex align-items-center">
                            <div class="stats-icon stats-primary me-3">
                                <i class="fas fa-chart-line"></i>
                            </div>
                            <div class="flex-grow-1">
                                <div class="stats-label">Promedio General</div>
                                <div class="stats-number">${promedioGeneral}</div>
                                <div class="stats-change ${promedioGeneral >= 14 ? 'positive' : 'negative'}">
                                    <i class="fas fa-${promedioGeneral >= 14 ? 'arrow-up' : 'arrow-down'} me-1"></i>
                                    ${cambioPromedio}
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
                                <i class="fas fa-user-check"></i>
                            </div>
                            <div class="flex-grow-1">
                                <div class="stats-label">Asistencia</div>
                                <div class="stats-number">${porcentajeAsistencia}%</div>
                                <div class="stats-change positive">
                                    <i class="fas fa-check me-1"></i>
                                    ${diasAsistidos} días
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
                                <i class="fas fa-star"></i>
                            </div>
                            <div class="flex-grow-1">
                                <div class="stats-label">Conducta</div>
                                <div class="stats-number">${puntajeConducta}</div>
                                <div class="stats-change positive">
                                    <i class="fas fa-medal me-1"></i>
                                    ${meritos} méritos
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
                                <i class="fas fa-book"></i>
                            </div>
                            <div class="flex-grow-1">
                                <div class="stats-label">Cursos</div>
                                <div class="stats-number">${totalCursos}</div>
                                <div class="stats-change">
                                    <i class="fas fa-check-circle me-1"></i>
                                    ${cursosAprobados} aprobados
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Gráfico de Rendimiento y Horario -->
        <div class="row mb-4">
            <!-- Gráfico de Notas por Curso -->
            <div class="col-lg-8 mb-4">
                <div class="chart-container fade-in-up" style="animation-delay: 0.5s;">
                    <h5 class="chart-title mb-3">
                        <i class="fas fa-chart-bar me-2"></i>
                        Mi Rendimiento por Curso
                    </h5>
                    <canvas id="rendimientoCursosChart"
                        data-cursos="${nombresCursos}"
                        data-notas="${notasCursos}"
                        style="height: 350px;"></canvas>
                </div>
            </div>

            <!-- Horario de Hoy -->
            <div class="col-lg-4 mb-4">
                <div class="chart-container fade-in-up" style="animation-delay: 0.6s;">
                    <h5 class="chart-title">
                        <i class="fas fa-clock me-2"></i>
                        Mi Horario de Hoy
                    </h5>
                    <div class="list-group list-group-flush">
                        <c:forEach items="${horarioHoy}" var="clase">
                            <div class="list-group-item border-0 px-0">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <h6 class="mb-1">${clase.curso}</h6>
                                        <p class="mb-1 text-muted small">
                                            <i class="fas fa-clock me-1"></i>
                                            ${clase.horaInicio} - ${clase.horaFin}
                                        </p>
                                        <small class="text-muted">
                                            <i class="fas fa-map-marker-alt me-1"></i>
                                            Aula ${clase.aula}
                                        </small>
                                    </div>
                                    <c:choose>
                                        <c:when test="${clase.estado == 'actual'}">
                                            <span class="badge bg-primary">Ahora</span>
                                        </c:when>
                                        <c:when test="${clase.estado == 'siguiente'}">
                                            <span class="badge bg-warning">Siguiente</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">Programada</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>

        <!-- Acciones Rápidas -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="quick-actions fade-in-up" style="animation-delay: 0.7s;">
                    <h5>
                        <i class="fas fa-bolt me-2"></i>
                        Acceso Rápido
                    </h5>
                    <div class="row">
                        <div class="col-lg-3 col-md-6 mb-3">
                            <a href="${pageContext.request.contextPath}/views/calificaciones/mis-notas.jsp" 
                               class="quick-action">
                                <i class="fas fa-chart-line"></i>
                                <span>Mis Notas</span>
                            </a>
                        </div>
                        <div class="col-lg-3 col-md-6 mb-3">
                            <a href="${pageContext.request.contextPath}/views/horarios/mi-horario.jsp" 
                               class="quick-action">
                                <i class="fas fa-calendar-alt"></i>
                                <span>Mi Horario</span>
                            </a>
                        </div>
                        <div class="col-lg-3 col-md-6 mb-3">
                            <a href="${pageContext.request.contextPath}/views/asistencia/mi-asistencia.jsp" 
                               class="quick-action">
                                <i class="fas fa-user-check"></i>
                                <span>Mi Asistencia</span>
                            </a>
                        </div>
                        <div class="col-lg-3 col-md-6 mb-3">
                            <a href="${pageContext.request.contextPath}/views/comunicados/index.jsp" 
                               class="quick-action">
                                <i class="fas fa-bullhorn"></i>
                                <span>Comunicados</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Últimas Calificaciones -->
        <div class="row mb-4">
            <div class="col-lg-8 mb-4">
                <div class="admin-table fade-in-up" style="animation-delay: 0.8s;">
                    <div class="d-flex justify-content-between align-items-center p-3 border-bottom">
                        <h5 class="mb-0">
                            <i class="fas fa-clipboard-list me-2"></i>
                            Últimas Calificaciones
                        </h5>
                        <a href="${pageContext.request.contextPath}/views/calificaciones/mis-notas.jsp" 
                           class="btn btn-admin-primary btn-sm">
                            <i class="fas fa-eye me-1"></i>
                            Ver Todas
                        </a>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>Curso</th>
                                    <th>Evaluación</th>
                                    <th>Nota</th>
                                    <th>Fecha</th>
                                    <th>Observaciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${ultimasCalificaciones}" var="nota">
                                    <tr>
                                        <td><strong>${nota.curso}</strong></td>
                                        <td>${nota.tipoEvaluacion}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${nota.calificacion >= 14}">
                                                    <span class="badge bg-success">${nota.calificacion}</span>
                                                </c:when>
                                                <c:when test="${nota.calificacion >= 11}">
                                                    <span class="badge bg-warning">${nota.calificacion}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger">${nota.calificacion}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${nota.fecha}" pattern="dd/MM/yyyy" />
                                        </td>
                                        <td>
                                            <c:if test="${not empty nota.observaciones}">
                                                <i class="fas fa-comment text-info" 
                                                   title="${nota.observaciones}"></i>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Próximos Exámenes -->
            <div class="col-lg-4 mb-4">
                <div class="chart-container fade-in-up" style="animation-delay: 0.9s;">
                    <h5 class="chart-title">
                        <i class="fas fa-file-alt me-2"></i>
                        Próximos Exámenes
                    </h5>
                    <div class="list-group list-group-flush">
                        <c:forEach items="${proximosExamenes}" var="examen">
                            <div class="list-group-item border-0 px-0">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <h6 class="mb-1">${examen.curso}</h6>
                                        <p class="mb-1 text-muted small">${examen.tipo}</p>
                                        <small class="text-muted">
                                            <i class="fas fa-calendar me-1"></i>
                                            <fmt:formatDate value="${examen.fecha}" pattern="dd/MM/yyyy" />
                                        </small>
                                    </div>
                                    <c:choose>
                                        <c:when test="${examen.diasRestantes <= 3}">
                                            <span class="badge bg-danger">${examen.diasRestantes} días</span>
                                        </c:when>
                                        <c:when test="${examen.diasRestantes <= 7}">
                                            <span class="badge bg-warning">${examen.diasRestantes} días</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-info">${examen.diasRestantes} días</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
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
    <script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>
</body>
</html>
