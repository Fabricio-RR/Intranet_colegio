<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <jsp:include page="/includes/meta.jsp" />
    <title>Dashboard Coordinador - Intranet Escolar</title>
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
    <h1 id="pageTitleDesktop" class="h5 d-none d-md-block mb-0">Dashboard Coordinador</h1>
    <h1 id="pageTitleMobile" class="h6 d-md-none mb-0">Coordinador</h1>
    <jsp:include page="/includes/header.jsp" />
   
    <!-- Main Content -->
    <main class="main-content">
        <!-- Información de bienvenida -->
        <div class="row mb-4 fade-in-up">
            <div class="col-12">
                <div class="alert alert-info">
                    <i class="fas fa-user-tie me-2"></i>
                    Bienvenido/a, ${sessionScope.usuario.nombres} ${sessionScope.usuario.apellidos}
                    <span class="ms-3">
                        <i class="fas fa-layer-group me-1"></i>
                        Coordinador de ${sessionScope.usuario.nivelAsignado}
                    </span>
                    <span class="ms-3">
                        <i class="fas fa-calendar me-1"></i>
                        <fmt:formatDate value="${now}" pattern="EEEE, dd 'de' MMMM 'de' yyyy" />
                    </span>
                </div>
            </div>
        </div>

        <!-- Estadísticas del Nivel -->
        <div class="row mb-4">
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="card stats-card h-100 fade-in-up" style="animation-delay: 0.1s;">
                    <div class="card-body">
                        <div class="d-flex align-items-center">
                            <div class="stats-icon stats-primary me-3">
                                <i class="fas fa-users"></i>
                            </div>
                            <div class="flex-grow-1">
                                <div class="stats-label">Estudiantes del Nivel</div>
                                <div class="stats-number">${totalEstudiantesNivel}</div>
                                <div class="stats-change positive">
                                    <i class="fas fa-arrow-up me-1"></i>${cambioEstudiantes}
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
                                <div class="stats-label">Docentes Asignados</div>
                                <div class="stats-number">${totalDocentesNivel}</div>
                                <div class="stats-change">
                                    <i class="fas fa-check me-1"></i>Activos
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
                                <i class="fas fa-school"></i>
                            </div>
                            <div class="flex-grow-1">
                                <div class="stats-label">Secciones</div>
                                <div class="stats-number">${totalSeccionesNivel}</div>
                                <div class="stats-change">
                                    <i class="fas fa-layer-group me-1"></i>${gradosNivel} grados
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
                                <i class="fas fa-chart-line"></i>
                            </div>
                            <div class="flex-grow-1">
                                <div class="stats-label">Promedio General</div>
                                <div class="stats-number">${promedioGeneralNivel}</div>
                                <div class="stats-change ${cambioPromedio >= 0 ? 'positive' : 'negative'}">
                                    <i class="fas fa-${cambioPromedio >= 0 ? 'arrow-up' : 'arrow-down'} me-1"></i>${Math.abs(cambioPromedio)}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Gráficos de Análisis -->
        <div class="row mb-4">
            <!-- Rendimiento por Grado -->
            <div class="col-lg-8 mb-4">
                <div class="chart-container fade-in-up" style="animation-delay: 0.5s;">
                    <h5 class="chart-title mb-3">
                        <i class="fas fa-chart-bar me-2"></i>
                        Rendimiento Académico por Grado
                    </h5>
                    <canvas id="rendimientoGradosChart" 
                        data-grados="${fn:join(nombresGrados, ',')}"
                        data-promedios="${fn:join(promediosGrados, ',')}"
                        style="height: 350px;"></canvas>
                </div>
            </div>

            <!-- Asistencia por Sección -->
            <div class="col-lg-4 mb-4">
                <div class="chart-container fade-in-up" style="animation-delay: 0.6s;">
                    <h5 class="chart-title">
                        <i class="fas fa-user-check me-2"></i>
                        Asistencia por Sección
                    </h5>
                    <canvas id="asistenciaSeccionesChart"
                        data-secciones="${fn:join(nombresSecciones, ',')}"
                        data-asistencia="${fn:join(porcentajesAsistencia, ',')}"
                        style="height: 350px;"></canvas>
                </div>
            </div>
        </div>

        <!-- Distribución de Estudiantes y Alertas -->
        <div class="row mb-4">
            <!-- Distribución por Sección -->
            <div class="col-lg-6 mb-4">
                <div class="chart-container fade-in-up" style="animation-delay: 0.7s;">
                    <h5 class="chart-title">
                        <i class="fas fa-pie-chart me-2"></i>
                        Distribución de Estudiantes
                    </h5>
                    <canvas id="distribucionEstudiantesChart"
                        data-secciones="${fn:join(nombresSecciones, ',')}"
                        data-estudiantes="${fn:join(estudiantesPorSeccion, ',')}"
                        style="height: 300px;"></canvas>
                </div>
            </div>

            <!-- Alertas Académicas -->
            <div class="col-lg-6 mb-4">
                <div class="chart-container fade-in-up" style="animation-delay: 0.8s;">
                    <h5 class="chart-title">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        Alertas Académicas
                    </h5>
                    <div class="list-group list-group-flush">
                        <c:forEach items="${alertasAcademicas}" var="alerta">
                            <div class="list-group-item border-0 px-0">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <h6 class="mb-1">
                                            <i class="fas fa-${alerta.tipo == 'critico' ? 'exclamation-circle text-danger' : alerta.tipo == 'advertencia' ? 'exclamation-triangle text-warning' : 'info-circle text-info'} me-2"></i>
                                            ${alerta.titulo}
                                        </h6>
                                        <p class="mb-1 text-muted small">${alerta.descripcion}</p>
                                        <small class="text-muted">
                                            <i class="fas fa-users me-1"></i>
                                            ${alerta.seccion} - ${alerta.cantidadAfectados} estudiantes
                                        </small>
                                    </div>
                                    <span class="badge bg-${alerta.tipo == 'critico' ? 'danger' : alerta.tipo == 'advertencia' ? 'warning' : 'info'}">
                                        ${alerta.prioridad}
                                    </span>
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
                <div class="quick-actions fade-in-up" style="animation-delay: 0.9s;">
                    <h5>
                        <i class="fas fa-bolt me-2"></i>
                        Acciones Rápidas
                    </h5>
                    <div class="row">
                        <div class="col-lg-3 col-md-6 mb-3">
                            <a href="${pageContext.request.contextPath}/views/reportes/nivel.jsp" 
                               class="quick-action">
                                <i class="fas fa-chart-bar"></i>
                                <span>Reportes del Nivel</span>
                            </a>
                        </div>
                        <div class="col-lg-3 col-md-6 mb-3">
                            <a href="${pageContext.request.contextPath}/views/supervision/docentes.jsp" 
                               class="quick-action">
                                <i class="fas fa-eye"></i>
                                <span>Supervisar Docentes</span>
                            </a>
                        </div>
                        <div class="col-lg-3 col-md-6 mb-3">
                            <a href="${pageContext.request.contextPath}/views/comunicados/crear.jsp" 
                               class="quick-action">
                                <i class="fas fa-bullhorn"></i>
                                <span>Comunicado del Nivel</span>
                            </a>
                        </div>
                        <div class="col-lg-3 col-md-6 mb-3">
                            <a href="${pageContext.request.contextPath}/views/horarios/nivel.jsp" 
                               class="quick-action">
                                <i class="fas fa-calendar-alt"></i>
                                <span>Gestionar Horarios</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Supervisión de Docentes -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="admin-table fade-in-up" style="animation-delay: 1s;">
                    <div class="d-flex justify-content-between align-items-center p-3 border-bottom">
                        <h5 class="mb-0">
                            <i class="fas fa-chalkboard-teacher me-2"></i>
                            Supervisión de Docentes
                        </h5>
                        <a href="${pageContext.request.contextPath}/views/supervision/docentes.jsp" 
                           class="btn btn-admin-primary btn-sm">
                            <i class="fas fa-eye me-1"></i>
                            Ver Detalle
                        </a>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>Docente</th>
                                    <th>Cursos</th>
                                    <th>Evaluaciones Pendientes</th>
                                    <th>Última Actividad</th>
                                    <th>Estado</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${docentesNivel}" var="docente">
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <img src="${docente.foto != null ? docente.foto : '/placeholder.svg?height=40&width=40'}" 
                                                     alt="Foto" class="rounded-circle me-2" width="40" height="40">
                                                <div>
                                                    <strong>${docente.nombres} ${docente.apellidos}</strong>
                                                    <br><small class="text-muted">${docente.especialidad}</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="badge badge-admin-active">${docente.totalCursos}</span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${docente.evaluacionesPendientes > 0}">
                                                    <span class="badge bg-warning">${docente.evaluacionesPendientes}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-success">Al día</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${docente.ultimaActividad}" pattern="dd/MM/yyyy HH:mm" />
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${docente.estado == 'activo'}">
                                                    <span class="badge bg-success">Activo</span>
                                                </c:when>
                                                <c:when test="${docente.estado == 'licencia'}">
                                                    <span class="badge bg-warning">Licencia</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">Inactivo</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="btn-group" role="group">
                                                <a href="${pageContext.request.contextPath}/views/supervision/docente.jsp?id=${docente.id}" 
                                                   class="btn btn-sm btn-outline-primary">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/views/reportes/docente.jsp?id=${docente.id}" 
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
