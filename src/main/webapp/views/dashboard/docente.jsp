<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <jsp:include page="/includes/meta.jsp" />
    <title>Dashboard Docente - Intranet Escolar</title>
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
    <h1 id="pageTitleDesktop" class="h5 d-none d-md-block mb-0">Dashboard Docente</h1>
    <h1 id="pageTitleMobile" class="h6 d-md-none mb-0">Dashboard</h1>
    <jsp:include page="/includes/header.jsp" />
   
    <!-- Main Content -->
    <main class="main-content">
        <!-- Información de bienvenida -->
        <div class="row mb-4 fade-in-up">
            <div class="col-12">
                <div class="alert alert-info">
                    <i class="fas fa-chalkboard-teacher me-2"></i>
                    Bienvenido/a, Prof. ${sessionScope.usuario.nombres} ${sessionScope.usuario.apellidos}
                    <span class="ms-3">
                        <i class="fas fa-calendar me-1"></i>
                        <fmt:formatDate value="${now}" pattern="EEEE, dd 'de' MMMM 'de' yyyy" />
                    </span>
                </div>
            </div>
        </div>

        <!-- Estadísticas del Docente -->
        <div class="row mb-4">
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="card stats-card h-100 fade-in-up" style="animation-delay: 0.1s;">
                    <div class="card-body">
                        <div class="d-flex align-items-center">
                            <div class="stats-icon stats-primary me-3">
                                <i class="fas fa-book"></i>
                            </div>
                            <div class="flex-grow-1">
                                <div class="stats-label">Cursos Asignados</div>
                                <div class="stats-number">${totalCursos}</div>
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
                                <i class="fas fa-users"></i>
                            </div>
                            <div class="flex-grow-1">
                                <div class="stats-label">Total Estudiantes</div>
                                <div class="stats-number">${totalEstudiantes}</div>
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
                                <i class="fas fa-clipboard-check"></i>
                            </div>
                            <div class="flex-grow-1">
                                <div class="stats-label">Evaluaciones Pendientes</div>
                                <div class="stats-number">${evaluacionesPendientes}</div>
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
                                <i class="fas fa-calendar-alt"></i>
                            </div>
                            <div class="flex-grow-1">
                                <div class="stats-label">Clases Hoy</div>
                                <div class="stats-number">${clasesHoy}</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Horario del Día -->
        <div class="row mb-4">
            <div class="col-lg-8 mb-4">
                <div class="chart-container fade-in-up" style="animation-delay: 0.5s;">
                    <h5 class="chart-title mb-3">
                        <i class="fas fa-clock me-2"></i>
                        Mi Horario de Hoy
                    </h5>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Hora</th>
                                    <th>Curso</th>
                                    <th>Sección</th>
                                    <th>Aula</th>
                                    <th>Estado</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${horarioHoy}" var="clase">
                                    <tr>
                                        <td>
                                            <strong>${clase.horaInicio} - ${clase.horaFin}</strong>
                                        </td>
                                        <td>${clase.nombreCurso}</td>
                                        <td>${clase.seccion}</td>
                                        <td>${clase.aula}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${clase.estado == 'completada'}">
                                                    <span class="badge bg-success">Completada</span>
                                                </c:when>
                                                <c:when test="${clase.estado == 'en_curso'}">
                                                    <span class="badge bg-primary">En Curso</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">Programada</span>
                                                </c:otherwise>
                                            </c:choose>
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
                <div class="chart-container fade-in-up" style="animation-delay: 0.6s;">
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
                                        <p class="mb-1 text-muted small">${examen.seccion}</p>
                                        <small class="text-muted">
                                            <i class="fas fa-calendar me-1"></i>
                                            <fmt:formatDate value="${examen.fecha}" pattern="dd/MM/yyyy" />
                                        </small>
                                    </div>
                                    <span class="badge bg-warning">${examen.tipo}</span>
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
                        Acciones Rápidas
                    </h5>
                    <div class="row">
                        <div class="col-lg-3 col-md-6 mb-3">
                            <a href="${pageContext.request.contextPath}/views/calificaciones/registrar.jsp" 
                               class="quick-action">
                                <i class="fas fa-edit"></i>
                                <span>Registrar Notas</span>
                            </a>
                        </div>
                        <div class="col-lg-3 col-md-6 mb-3">
                            <a href="${pageContext.request.contextPath}/views/asistencia/registrar.jsp" 
                               class="quick-action">
                                <i class="fas fa-user-check"></i>
                                <span>Tomar Asistencia</span>
                            </a>
                        </div>
                        <div class="col-lg-3 col-md-6 mb-3">
                            <a href="${pageContext.request.contextPath}/views/conducta/registrar.jsp" 
                               class="quick-action">
                                <i class="fas fa-star"></i>
                                <span>Registrar Conducta</span>
                            </a>
                        </div>
                        <div class="col-lg-3 col-md-6 mb-3">
                            <a href="${pageContext.request.contextPath}/views/comunicados/crear.jsp" 
                               class="quick-action">
                                <i class="fas fa-bullhorn"></i>
                                <span>Crear Comunicado</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Mis Cursos -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="admin-table fade-in-up" style="animation-delay: 0.8s;">
                    <div class="d-flex justify-content-between align-items-center p-3 border-bottom">
                        <h5 class="mb-0">
                            <i class="fas fa-book-open me-2"></i>
                            Mis Cursos
                        </h5>
                        <a href="${pageContext.request.contextPath}/views/cursos/mis-cursos.jsp" 
                           class="btn btn-admin-primary btn-sm">
                            <i class="fas fa-eye me-1"></i>
                            Ver Todos
                        </a>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>Curso</th>
                                    <th>Sección</th>
                                    <th>Estudiantes</th>
                                    <th>Promedio</th>
                                    <th>Última Evaluación</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${misCursos}" var="curso">
                                    <tr>
                                        <td>
                                            <strong>${curso.nombre}</strong>
                                        </td>
                                        <td>${curso.seccion}</td>
                                        <td>
                                            <span class="badge badge-admin-active">${curso.totalEstudiantes}</span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${curso.promedio >= 14}">
                                                    <span class="text-success fw-bold">${curso.promedio}</span>
                                                </c:when>
                                                <c:when test="${curso.promedio >= 11}">
                                                    <span class="text-warning fw-bold">${curso.promedio}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-danger fw-bold">${curso.promedio}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${curso.ultimaEvaluacion}" pattern="dd/MM/yyyy" />
                                        </td>
                                        <td>
                                            <div class="btn-group" role="group">
                                                <a href="${pageContext.request.contextPath}/views/calificaciones/curso.jsp?id=${curso.id}" 
                                                   class="btn btn-sm btn-outline-primary">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/views/reportes/curso.jsp?id=${curso.id}" 
                                                   class="btn btn-sm btn-outline-success">
                                                    <i class="fas fa-chart-bar"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
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
    <script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>
</body>
</html>
