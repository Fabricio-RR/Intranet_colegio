<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"    uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<!DOCTYPE html>
<html lang="es">
<head>
    <jsp:include page="/includes/meta.jsp" />
    <title>Dashboard Apoderado - Intranet Escolar</title>
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
<body class="apoderado-dashboard">
    <!-- Sidebar -->
    <jsp:include page="/includes/sidebar.jsp" />

    <!-- Header con título dinámico -->
    <c:set var="tituloPaginaDesktop" value="Portal de Padres" scope="request"/>
    <c:set var="tituloPaginaMobile"  value="Portal Padres" scope="request"/>
    <c:set var="iconoPagina"         value="fas fa-users" scope="request"/>
    <jsp:include page="/includes/header.jsp" />

    <main class="main-content">
        <!-- Mensaje si no hay hijos -->
        <c:if test="${empty hijos}">
            <div class="alert alert-warning text-center mt-4">
                <i class="fas fa-exclamation-triangle me-2"></i>
                No tiene hijos registrados en el sistema.
            </div>
        </c:if>

        <!-- Dashboard solo si hay hijo seleccionado -->
        <c:if test="${not empty hijoSeleccionado}">
            <!-- Bienvenida -->
            <div class="row mb-4 fade-in-up">
                <div class="col-12">
                    <div class="alert alert-info d-flex align-items-center">
                        <i class="fas fa-users me-2"></i>
                        Bienvenido/a, ${sessionScope.usuario.nombres} ${sessionScope.usuario.apellidos}
                        <span class="ms-4">
                            <i class="fas fa-calendar me-1"></i>
                            <fmt:formatDate value="${now}" pattern="EEEE, dd 'de' MMMM 'de' yyyy"/>
                        </span>
                    </div>
                </div>
            </div>

            <!-- Selector de hijo (si aplica) -->
            <c:if test="${hijos.size() > 1}">
                <div class="row mb-4 fade-in-up">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-body">
                                <h6 class="card-title"><i class="fas fa-child me-2"></i>Seleccionar Hijo/a</h6>
                                <div class="btn-group" role="group">
                                    <c:forEach var="hijo" items="${hijos}" varStatus="st">
                                        <input type="radio" class="btn-check"
                                               name="hijoSeleccionado"
                                               id="hijo${hijo.id}"
                                               value="${hijo.id}"
                                               ${hijo.id == hijoSeleccionado.id ? 'checked' : ''}
                                               onchange="cambiarHijo(${hijo.id})">
                                        <label class="btn btn-outline-primary" for="hijo${hijo.id}">
                                            ${hijo.nombres} ${hijo.apellidos}
                                            <small class="d-block">${hijo.grado} "${hijo.seccion}"</small>
                                        </label>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- Información básica del estudiante -->
            <div class="row mb-4 fade-in-up">
                <div class="col-12">
                    <div class="card p-3">
                        <div class="row align-items-center">
                            <div class="col-md-2 text-center">
                                <c:set var="fotoPlaceholder" value="${pageContext.request.contextPath}/uploads/default.png" />
                                <img src="${not empty hijoSeleccionado.foto 
                                    ? pageContext.request.contextPath.concat('/uploads/').concat(hijoSeleccionado.foto) 
                                    : fotoPlaceholder}"
                                     alt="Foto del estudiante"
                                     class="rounded-circle"
                                     width="120" height="120"/>
                            </div>
                            <div class="col-md-10">
                                <h4 class="mb-1">${hijoSeleccionado.nombres} ${hijoSeleccionado.apellidos}</h4>
                                <p class="text-muted mb-2">
                                    <i class="fas fa-graduation-cap me-2"></i>
                                    ${hijoSeleccionado.grado} "${hijoSeleccionado.seccion}" - 
                                    Código: ${hijoSeleccionado.codigo}
                                </p>
                                <div class="row text-center">
                                    <div class="col-md-3">
                                        <small class="text-muted">Prom General</small>
                                        <div class="h5 mb-0 
                                            ${hijoSeleccionado.promedioGeneral >= 14 ? 'text-success' 
                                               : hijoSeleccionado.promedioGeneral >= 11 ? 'text-warning'
                                               : 'text-danger'}">
                                            <c:choose>
                                                <c:when test="${not empty hijoSeleccionado.promedioGeneral}">
                                                    ${hijoSeleccionado.promedioGeneral}
                                                </c:when>
                                                <c:otherwise>—</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <small class="text-muted">Asistencia</small>
                                        <div class="h5 mb-0 text-info">
                                            <c:choose>
                                                <c:when test="${not empty hijoSeleccionado.porcentajeAsistencia}">
                                                    ${hijoSeleccionado.porcentajeAsistencia}%
                                                </c:when>
                                                <c:otherwise>—</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <small class="text-muted">Conducta</small>
                                        <div class="h5 mb-0 text-success">
                                            <c:choose>
                                                <c:when test="${not empty hijoSeleccionado.puntajeConducta}">
                                                    ${hijoSeleccionado.puntajeConducta}
                                                </c:when>
                                                <c:otherwise>—</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <small class="text-muted">Posición</small>
                                        <div class="h5 mb-0 text-primary">
                                            <c:choose>
                                                <c:when test="${not empty hijoSeleccionado.posicion}">
                                                    ${hijoSeleccionado.posicion}°
                                                </c:when>
                                                <c:otherwise>—</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Estadísticas del Estudiante -->
            <div class="row mb-4">
                <!-- Promedio Bimestre -->
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="card stats-card h-100 fade-in-up" style="animation-delay: 0.2s;">
                        <div class="card-body d-flex align-items-center">
                            <div class="stats-icon stats-primary me-3"><i class="fas fa-chart-line"></i></div>
                            <div class="flex-grow-1">
                                <div class="stats-label">Promedio Bimestre</div>
                                <div class="stats-number">
                                    <c:choose>
                                        <c:when test="${not empty promedioBimestre}">
                                            ${promedioBimestre}
                                        </c:when>
                                        <c:otherwise>—</c:otherwise>
                                    </c:choose>
                                </div>
                                <c:set var="cambio" value="${not empty cambioPromedio ? cambioPromedio : 0}" />
                                <c:set var="cambioAbs" value="${cambio >= 0 ? cambio : -cambio}" />
                                <div class="stats-change ${cambio >= 0 ? 'positive' : 'negative'}">
                                    <i class="fas fa-${cambio >= 0 ? 'arrow-up' : 'arrow-down'} me-1"></i>
                                    ${cambioAbs}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Asistencias -->
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="card stats-card h-100 fade-in-up" style="animation-delay: 0.3s;">
                        <div class="card-body d-flex align-items-center">
                            <div class="stats-icon stats-success me-3"><i class="fas fa-user-check"></i></div>
                            <div class="flex-grow-1">
                                <div class="stats-label">Asistencias</div>
                                <div class="stats-number">
                                    <c:choose>
                                        <c:when test="${not empty diasAsistidos}">
                                            ${diasAsistidos}
                                        </c:when>
                                        <c:otherwise>—</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="stats-change">
                                    <i class="fas fa-calendar me-1"></i>
                                    de 
                                    <c:choose>
                                        <c:when test="${not empty totalDias}">
                                            ${totalDias}
                                        </c:when>
                                        <c:otherwise>—</c:otherwise>
                                    </c:choose>
                                    días
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Méritos -->
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="card stats-card h-100 fade-in-up" style="animation-delay: 0.4s;">
                        <div class="card-body d-flex align-items-center">
                            <div class="stats-icon stats-warning me-3"><i class="fas fa-star"></i></div>
                            <div class="flex-grow-1">
                                <div class="stats-label">Méritos</div>
                                <div class="stats-number">
                                    <c:choose>
                                        <c:when test="${not empty totalMeritos}">
                                            ${totalMeritos}
                                        </c:when>
                                        <c:otherwise>—</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="stats-change positive">
                                    <i class="fas fa-medal me-1"></i>
                                    <c:choose>
                                        <c:when test="${not empty meritosRecientes}">
                                            ${meritosRecientes}
                                        </c:when>
                                        <c:otherwise>—</c:otherwise>
                                    </c:choose>
                                    recientes
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Posición -->
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="card stats-card h-100 fade-in-up" style="animation-delay: 0.5s;">
                        <div class="card-body d-flex align-items-center">
                            <div class="stats-icon stats-info me-3"><i class="fas fa-trophy"></i></div>
                            <div class="flex-grow-1">
                                <div class="stats-label">Posición</div>
                                <div class="stats-number">
                                    <c:choose>
                                        <c:when test="${not empty posicionSeccion}">
                                            ${posicionSeccion}°
                                        </c:when>
                                        <c:otherwise>—</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="stats-change">
                                    <i class="fas fa-users me-1"></i>
                                    de 
                                    <c:choose>
                                        <c:when test="${not empty totalEstudiantesSeccion}">
                                            ${totalEstudiantesSeccion}
                                        </c:when>
                                        <c:otherwise>—</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Gráficos de Rendimiento -->
            <c:set var="csvCursos" value="" />
            <c:forEach var="curso" items="${nombresCursos}" varStatus="st">
                <c:set var="csvCursos" value="${csvCursos}${curso}${st.last ? '' : ','}" />
            </c:forEach>
            <c:set var="csvNotas" value="" />
            <c:forEach var="nota" items="${notasCursos}" varStatus="st">
                <c:set var="csvNotas" value="${csvNotas}${nota}${st.last ? '' : ','}" />
            </c:forEach>
            <c:set var="csvPeriodos" value="" />
            <c:forEach var="per" items="${periodos}" varStatus="st">
                <c:set var="csvPeriodos" value="${csvPeriodos}${per}${st.last ? '' : ','}" />
            </c:forEach>
            <c:set var="csvPromedios" value="" />
            <c:forEach var="pr" items="${promediosPeriodos}" varStatus="st">
                <c:set var="csvPromedios" value="${csvPromedios}${pr}${st.last ? '' : ','}" />
            </c:forEach>

            <div class="row mb-4">
                <!-- Rendimiento por Curso -->
                <div class="col-lg-8 mb-4">
                    <c:choose>
                        <c:when test="${empty nombresCursos or empty notasCursos}">
                            <div class="alert alert-info">
                                No hay datos de rendimiento por curso disponibles.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="chart-container fade-in-up" style="animation-delay: 0.6s;">
                                <h5 class="chart-title mb-3"><i class="fas fa-chart-bar me-2"></i>Rendimiento por Curso</h5>
                                <canvas id="rendimientoCursosChart"
                                        data-cursos="${csvCursos}"
                                        data-notas="${csvNotas}"
                                        style="height: 350px;"></canvas>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <!-- Evolución del Promedio -->
                <div class="col-lg-4 mb-4">
                    <c:choose>
                        <c:when test="${empty periodos or empty promediosPeriodos}">
                            <div class="alert alert-info">
                                No hay datos de evolución del promedio disponibles.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="chart-container fade-in-up" style="animation-delay: 0.7s;">
                                <h5 class="chart-title"><i class="fas fa-chart-line me-2"></i>Evolución del Promedio</h5>
                                <canvas id="evolucionPromedioChart"
                                        data-periodos="${csvPeriodos}"
                                        data-promedios="${csvPromedios}"
                                        style="height: 350px;"></canvas>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Acciones Rápidas -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="quick-actions fade-in-up" style="animation-delay: 0.8s;">
                        <h5><i class="fas fa-bolt me-2"></i>Acceso Rápido</h5>
                        <div class="row">
                            <div class="col-lg-3 col-md-6 mb-3">
                                <a href="${pageContext.request.contextPath}/views/calificaciones/hijo.jsp?id=${hijoSeleccionado.id}"
                                   class="quick-action"><i class="fas fa-chart-line"></i><span>Ver Notas</span></a>
                            </div>
                            <div class="col-lg-3 col-md-6 mb-3">
                                <a href="${pageContext.request.contextPath}/views/asistencia/hijo.jsp?id=${hijoSeleccionado.id}"
                                   class="quick-action"><i class="fas fa-user-check"></i><span>Ver Asistencia</span></a>
                            </div>
                            <div class="col-lg-3 col-md-6 mb-3">
                                <a href="${pageContext.request.contextPath}/views/horarios/hijo.jsp?id=${hijoSeleccionado.id}"
                                   class="quick-action"><i class="fas fa-calendar-alt"></i><span>Ver Horario</span></a>
                            </div>
                            <div class="col-lg-3 col-md-6 mb-3">
                                <a href="${pageContext.request.contextPath}/views/reportes/libreta.jsp?id=${hijoSeleccionado.id}"
                                   class="quick-action"><i class="fas fa-file-pdf"></i><span>Descargar Libreta</span></a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Últimas Calificaciones y Comunicados -->
            <div class="row mb-4">
                <!-- Últimas Calificaciones -->
                <div class="col-lg-8 mb-4">
                    <div class="admin-table fade-in-up" style="animation-delay: 0.9s;">
                        <div class="d-flex justify-content-between align-items-center p-3 border-bottom">
                            <h5 class="mb-0"><i class="fas fa-clipboard-list me-2"></i>Últimas Calificaciones</h5>
                            <a href="${pageContext.request.contextPath}/views/calificaciones/hijo.jsp?id=${hijoSeleccionado.id}"
                               class="btn btn-admin-primary btn-sm"><i class="fas fa-eye me-1"></i>Ver Todas</a>
                        </div>
                        <div class="table-responsive">
                            <c:choose>
                                <c:when test="${empty ultimasCalificaciones}">
                                    <div class="alert alert-info m-2">
                                        No hay calificaciones registradas.
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <table class="table table-hover mb-0">
                                        <thead>
                                            <tr>
                                                <th>Curso</th><th>Evaluación</th><th>Nota</th><th>Fecha</th><th>Docente</th>
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
                                                        <c:choose>
                                                            <c:when test="${not empty nota.fecha}">
                                                                <fmt:formatDate value="${nota.fecha}" pattern="dd/MM/yyyy"/>
                                                            </c:when>
                                                            <c:otherwise>—</c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>${nota.docente}</td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
                <!-- Comunicados Recientes -->
                <div class="col-lg-4 mb-4">
                    <div class="chart-container fade-in-up" style="animation-delay: 1s;">
                        <h5 class="chart-title"><i class="fas fa-bullhorn me-2"></i>Comunicados Recientes</h5>
                        <div class="list-group list-group-flush">
                            <c:choose>
                                <c:when test="${empty comunicadosRecientes}">
                                    <div class="alert alert-info m-2">No hay comunicados recientes.</div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${comunicadosRecientes}" var="comunicado">
                                        <div class="list-group-item border-0 px-0">
                                            <div class="d-flex justify-content-between">
                                                <div>
                                                    <h6 class="mb-1">${comunicado.titulo}</h6>
                                                    <p class="mb-1 text-muted small">
                                                        <c:choose>
                                                            <c:when test="${fn:length(comunicado.contenido) > 80}">
                                                                ${fn:substring(comunicado.contenido, 0, 80)}...
                                                            </c:when>
                                                            <c:otherwise>
                                                                ${comunicado.contenido}
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </p>
                                                    <small class="text-muted">
                                                        <i class="fas fa-calendar me-1"></i>
                                                        <fmt:formatDate value="${comunicado.fecha}" pattern="dd/MM/yyyy"/>
                                                    </small>
                                                </div>
                                                <c:if test="${comunicado.importante}">
                                                    <span class="badge bg-danger">Importante</span>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="text-center mt-3">
                            <a href="${pageContext.request.contextPath}/views/comunicados/index.jsp"
                               class="btn btn-outline-primary btn-sm">Ver Todos</a>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Footer -->
        <jsp:include page="/includes/footer.jsp" />
    </main>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>
    <script>
        function cambiarHijo(hijoId) {
            window.location.href = '${pageContext.request.contextPath}/dashboard/apoderado?hijoId=' + hijoId;
        }
    </script>
</body>
</html>
