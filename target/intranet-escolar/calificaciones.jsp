<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Calificaciones - Intranet Escolar</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/assets/css/styles.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/calificaciones.css" rel="stylesheet">
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <jsp:include page="/includes/sidebar.jsp" />

            <!-- Main Content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <jsp:include page="/includes/header.jsp" />

                <!-- Filtros y Acciones -->
                <div class="row mb-4">
                    <div class="col-md-8">
                        <div class="card">
                            <div class="card-body">
                                <form action="${pageContext.request.contextPath}/calificaciones" method="get" id="filtroForm">
                                    <div class="row">
                                        <div class="col-md-4 mb-3 mb-md-0">
                                            <label for="filtroPeriodo" class="form-label">Periodo</label>
                                            <select class="form-select" id="filtroPeriodo" name="periodo">
                                                <option value="actual" ${param.periodo == 'actual' || param.periodo == null ? 'selected' : ''}>Periodo Actual</option>
                                                <c:forEach items="${periodos}" var="periodo">
                                                    <option value="${periodo.id}" ${param.periodo == periodo.id ? 'selected' : ''}>${periodo.nombre}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-4 mb-3 mb-md-0">
                                            <label for="filtroAsignatura" class="form-label">Asignatura</label>
                                            <select class="form-select" id="filtroAsignatura" name="asignatura">
                                                <option value="todas" ${param.asignatura == 'todas' || param.asignatura == null ? 'selected' : ''}>Todas las asignaturas</option>
                                                <c:forEach items="${asignaturas}" var="asignatura">
                                                    <option value="${asignatura.id}" ${param.asignatura == asignatura.id ? 'selected' : ''}>${asignatura.nombre}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <c:if test="${sessionScope.usuario.rol eq 'PROFESOR' || sessionScope.usuario.rol eq 'ADMIN'}">
                                            <div class="col-md-4">
                                                <label for="filtroEstudiante" class="form-label">Estudiante</label>
                                                <select class="form-select" id="filtroEstudiante" name="estudiante">
                                                    <option value="todos" ${param.estudiante == 'todos' || param.estudiante == null ? 'selected' : ''}>Todos los estudiantes</option>
                                                    <c:forEach items="${estudiantes}" var="estudiante">
                                                        <option value="${estudiante.id}" ${param.estudiante == estudiante.id ? 'selected' : ''}>${estudiante.nombre} ${estudiante.apellido}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </c:if>
                                        <c:if test="${sessionScope.usuario.rol eq 'APODERADO'}">
                                            <div class="col-md-4">
                                                <label for="filtroHijo" class="form-label">Hijo</label>
                                                <select class="form-select" id="filtroHijo" name="hijo">
                                                    <c:forEach items="${hijos}" var="hijo">
                                                        <option value="${hijo.id}" ${param.hijo == hijo.id ? 'selected' : ''}>${hijo.nombre} ${hijo.apellido}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </c:if>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-body">
                                <div class="d-grid gap-2">
                                    <button class="btn btn-primary" type="button" id="btnAplicarFiltros">
                                        <i class="fas fa-filter me-2"></i>Aplicar Filtros
                                    </button>
                                    <div class="btn-group">
                                        <button type="button" class="btn btn-outline-secondary dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
                                            <i class="fas fa-download me-2"></i>Exportar
                                        </button>
                                        <ul class="dropdown-menu w-100">
                                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/calificaciones/exportar?formato=pdf&${pageContext.request.queryString}" id="exportarPDF"><i class="fas fa-file-pdf me-2"></i>Exportar a PDF</a></li>
                                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/calificaciones/exportar?formato=excel&${pageContext.request.queryString}" id="exportarExcel"><i class="fas fa-file-excel me-2"></i>Exportar a Excel</a></li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Resumen de Calificaciones -->
                <div class="row mb-4">
                    <div class="col-md-8">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0">Resumen de Calificaciones</h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6 mb-4">
                                        <div class="calificacion-stat">
                                            <div class="calificacion-stat-icon">
                                                <i class="fas fa-chart-line"></i>
                                            </div>
                                            <div class="calificacion-stat-info">
                                                <h6>Promedio General</h6>
                                                <div class="d-flex align-items-center">
                                                    <span class="calificacion-stat-value">${resumen.promedioGeneral}</span>
                                                    <div class="progress ms-3 flex-grow-1" style="height: 8px;">
                                                        <div class="progress-bar ${resumen.promedioGeneralClase}" role="progressbar" style="width: ${resumen.promedioGeneralPorcentaje}%;" aria-valuenow="${resumen.promedioGeneralPorcentaje}" aria-valuemin="0" aria-valuemax="100"></div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6 mb-4">
                                        <div class="calificacion-stat">
                                            <div class="calificacion-stat-icon">
                                                <i class="fas fa-trophy"></i>
                                            </div>
                                            <div class="calificacion-stat-info">
                                                <h6>Mejor Asignatura</h6>
                                                <div class="d-flex align-items-center">
                                                    <span class="calificacion-stat-value">${resumen.mejorAsignaturaNota}</span>
                                                    <div class="ms-3">
                                                        <span class="badge ${resumen.mejorAsignaturaClase}">${resumen.mejorAsignatura}</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6 mb-4 mb-md-0">
                                        <div class="calificacion-stat">
                                            <div class="calificacion-stat-icon">
                                                <i class="fas fa-exclamation-triangle"></i>
                                            </div>
                                            <div class="calificacion-stat-info">
                                                <h6>Asignatura por Mejorar</h6>
                                                <div class="d-flex align-items-center">
                                                    <span class="calificacion-stat-value">${resumen.peorAsignaturaNota}</span>
                                                    <div class="ms-3">
                                                        <span class="badge ${resumen.peorAsignaturaClase}">${resumen.peorAsignatura}</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="calificacion-stat">
                                            <div class="calificacion-stat-icon">
                                                <i class="fas fa-chart-bar"></i>
                                            </div>
                                            <div class="calificacion-stat-info">
                                                <h6>Tendencia</h6>
                                                <div class="d-flex align-items-center">
                                                    <span class="calificacion-stat-value">
                                                        <i class="${resumen.tendenciaIcono} ${resumen.tendenciaClase}"></i>
                                                    </span>
                                                    <div class="ms-3">
                                                        <span class="${resumen.tendenciaClase}">${resumen.tendenciaTexto}</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card h-100">
                            <div class="card-header">
                                <h5 class="mb-0">Distribución de Calificaciones</h5>
                            </div>
                            <div class="card-body">
                                <canvas id="distribucionChart" height="220"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tabla de Calificaciones -->
                <div class="card mb-4">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Calificaciones Detalladas</h5>
                        <c:if test="${sessionScope.usuario.rol eq 'PROFESOR' || sessionScope.usuario.rol eq 'ADMIN'}">
                            <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#agregarCalificacionModal">
                                <i class="fas fa-plus me-1"></i> Agregar Calificación
                            </button>
                        </c:if>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Asignatura</th>
                                        <th>Tipo</th>
                                        <th>Descripción</th>
                                        <th>Fecha</th>
                                        <th>Calificación</th>
                                        <th>Ponderación</th>
                                        <c:if test="${sessionScope.usuario.rol eq 'PROFESOR' || sessionScope.usuario.rol eq 'ADMIN'}">
                                            <th>Acciones</th>
                                        </c:if>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${calificaciones}" var="calificacion">
                                        <tr>
                                            <td>${calificacion.asignatura}</td>
                                            <td>${calificacion.tipo}</td>
                                            <td>${calificacion.descripcion}</td>
                                            <td>${calificacion.fecha}</td>
                                            <td><span class="badge ${calificacion.notaClase}">${calificacion.nota}</span></td>
                                            <td>${calificacion.ponderacion}%</td>
                                            <c:if test="${sessionScope.usuario.rol eq 'PROFESOR' || sessionScope.usuario.rol eq 'ADMIN'}">
                                                <td>
                                                    <button class="btn btn-sm btn-outline-primary me-1" data-bs-toggle="modal" data-bs-target="#editarCalificacionModal" data-id="${calificacion.id}">
                                                        <i class="fas fa-edit"></i>
                                                    </button>
                                                    <button class="btn btn-sm btn-outline-danger" data-bs-toggle="modal" data-bs-target="#eliminarCalificacionModal" data-id="${calificacion.id}">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </td>
                                            </c:if>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty calificaciones}">
                                        <tr>
                                            <td colspan="${sessionScope.usuario.rol eq 'PROFESOR' || sessionScope.usuario.rol eq 'ADMIN' ? '7' : '6'}" class="text-center py-4">
                                                <p class="text-muted mb-0">No hay calificaciones disponibles para los filtros seleccionados</p>
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Gráfico de Evolución -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="mb-0">Evolución de Calificaciones</h5>
                    </div>
                    <div class="card-body">
                        <canvas id="evolucionChart" height="100"></canvas>
                    </div>
                </div>

                <!-- Comparativa por Asignaturas -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="mb-0">Comparativa por Asignaturas</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-8">
                                <canvas id="asignaturasChart" height="300"></canvas>
                            </div>
                            <div class="col-md-4">
                                <h6 class="mb-3">Promedio por Asignatura</h6>
                                <div class="asignaturas-list">
                                    <c:forEach items="${promediosPorAsignatura}" var="promedio">
                                        <div class="asignatura-item">
                                            <div class="asignatura-info">
                                                <span class="asignatura-nombre">${promedio.asignatura}</span>
                                                <span class="asignatura-nota ${promedio.claseNota}">${promedio.nota}</span>
                                            </div>
                                            <div class="progress" style="height: 5px;">
                                                <div class="progress-bar ${promedio.claseNota}" role="progressbar" style="width: ${promedio.porcentaje}%;" aria-valuenow="${promedio.porcentaje}" aria-valuemin="0" aria-valuemax="100"></div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Comentarios y Observaciones -->
                <div class="card mb-4">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Comentarios y Observaciones</h5>
                        <button class="btn btn-sm btn-outline-secondary" type="button" data-bs-toggle="collapse" data-bs-target="#collapseComentarios" aria-expanded="false" aria-controls="collapseComentarios">
                            <i class="fas fa-chevron-down"></i>
                        </button>
                    </div>
                    <div class="collapse" id="collapseComentarios">
                        <div class="card-body">
                            <div class="comentarios-list">
                                <c:forEach items="${comentarios}" var="comentario">
                                    <div class="comentario-item">
                                        <div class="comentario-header">
                                            <div class="d-flex align-items-center">
                                                <img src="${pageContext.request.contextPath}/assets/img/usuarios/${comentario.autorFoto}" alt="${comentario.autor}" class="comentario-avatar">
                                                <div class="ms-2">
                                                    <h6 class="mb-0">${comentario.autor}</h6>
                                                    <small class="text-muted">${comentario.fecha}</small>
                                                </div>
                                            </div>
                                            <div class="comentario-asignatura">
                                                <span class="badge ${comentario.asignaturaClase}">${comentario.asignatura}</span>
                                            </div>
                                        </div>
                                        <div class="comentario-content">
                                            <p>${comentario.contenido}</p>
                                        </div>
                                        <c:if test="${not empty comentario.respuestas}">
                                            <div class="comentario-respuestas">
                                                <c:forEach items="${comentario.respuestas}" var="respuesta">
                                                    <div class="respuesta-item">
                                                        <div class="d-flex align-items-center mb-1">
                                                            <img src="${pageContext.request.contextPath}/assets/img/usuarios/${respuesta.autorFoto}" alt="${respuesta.autor}" class="respuesta-avatar">
                                                            <div class="ms-2">
                                                                <h6 class="mb-0">${respuesta.autor}</h6>
                                                                <small class="text-muted">${respuesta.fecha}</small>
                                                            </div>
                                                        </div>
                                                        <p class="mb-0">${respuesta.contenido}</p>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </c:if>
                                        <c:if test="${sessionScope.usuario.rol eq 'PROFESOR' || sessionScope.usuario.rol eq 'ADMIN' || sessionScope.usuario.rol eq 'APODERADO'}">
                                            <div class="comentario-footer">
                                                <button class="btn btn-sm btn-link" data-bs-toggle="collapse" data-bs-target="#responderComentario${comentario.id}" aria-expanded="false">
                                                    <i class="fas fa-reply me-1"></i>Responder
                                                </button>
                                                <div class="collapse mt-2" id="responderComentario${comentario.id}">
                                                    <form action="${pageContext.request.contextPath}/calificaciones/responder-comentario" method="post">
                                                        <input type="hidden" name="comentarioId" value="${comentario.id}">
                                                        <div class="mb-2">
                                                            <textarea class="form-control" name="respuesta" rows="2" placeholder="Escribe tu respuesta..." required></textarea>
                                                        </div>
                                                        <div class="text-end">
                                                            <button type="submit" class="btn btn-sm btn-primary">Enviar Respuesta</button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>
                                </c:forEach>
                                <c:if test="${empty comentarios}">
                                    <div class="text-center py-4">
                                        <p class="text-muted mb-0">No hay comentarios disponibles</p>
                                    </div>
                                </c:if>
                            </div>
                            <c:if test="${sessionScope.usuario.rol eq 'PROFESOR' || sessionScope.usuario.rol eq 'ADMIN'}">
                                <hr>
                                <h6 class="mb-3">Agregar Comentario</h6>
                                <form action="${pageContext.request.contextPath}/calificaciones/agregar-comentario" method="post">
                                    <div class="mb-3">
                                        <label for="comentarioAsignatura" class="form-label">Asignatura</label>
                                        <select class="form-select" id="comentarioAsignatura" name="asignaturaId" required>
                                            <option value="">Seleccionar asignatura</option>
                                            <c:forEach items="${asignaturas}" var="asignatura">
                                                <option value="${asignatura.id}">${asignatura.nombre}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label for="comentarioEstudiante" class="form-label">Estudiante</label>
                                        <select class="form-select" id="comentarioEstudiante" name="estudianteId" required>
                                            <option value="">Seleccionar estudiante</option>
                                            <c:forEach items="${estudiantes}" var="estudiante">
                                                <option value="${estudiante.id}">${estudiante.nombre} ${estudiante.apellido}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label for="comentarioContenido" class="form-label">Comentario</label>
                                        <textarea class="form-control" id="comentarioContenido" name="contenido" rows="3" required></textarea>
                                    </div>
                                    <div class="text-end">
                                        <button type="submit" class="btn btn-primary">Agregar Comentario</button>
                                    </div>
                                </form>
                            </c:if>
                        </div>
                    </div>
                </div>
                
                
            </main>
        </div>
    </div>

    <!-- Agregar Calificación Modal -->
    <c:if test="${sessionScope.usuario.rol eq 'PROFESOR' || sessionScope.usuario.rol eq 'ADMIN'}">
        <div class="modal fade" id="agregarCalificacionModal" tabindex="-1" aria-labelledby="agregarCalificacionModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="agregarCalificacionModalLabel">Agregar Calificación</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="${pageContext.request.contextPath}/calificaciones/agregar" method="post" id="agregarCalificacionForm">
                        <div class="modal-body">
                            <div class="mb-3">
                                <label for="agregarAsignatura" class="form-label">Asignatura</label>
                                <select class="form-select" id="agregarAsignatura" name="asignaturaId" required>
                                    <option value="">Seleccionar asignatura</option>
                                    <c:forEach items="${asignaturas}" var="asignatura">
                                        <option value="${asignatura.id}">${asignatura.nombre}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="agregarEstudiante" class="form-label">Estudiante</label>
                                <select class="form-select" id="agregarEstudiante" name="estudianteId" required>
                                    <option value="">Seleccionar estudiante</option>
                                    <c:forEach items="${estudiantes}" var="estudiante">
                                        <option value="${estudiante.id}">${estudiante.nombre} ${estudiante.apellido}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="agregarTipo" class="form-label">Tipo</label>
                                <select class="form-select" id="agregarTipo" name="tipo" required>
                                    <option value="">Seleccionar tipo</option>
                                    <option value="EXAMEN">Examen</option>
                                    <option value="TRABAJO">Trabajo</option>
                                    <option value="PROYECTO">Proyecto</option>
                                    <option value="PARTICIPACION">Participación</option>
                                    <option value="TAREA">Tarea</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="agregarDescripcion" class="form-label">Descripción</label>
                                <input type="text" class="form-control" id="agregarDescripcion" name="descripcion" required>
                            </div>
                            <div class="mb-3">
                                <label for="agregarFecha" class="form-label">Fecha</label>
                                <input type="date" class="form-control" id="agregarFecha" name="fecha" required>
                            </div>
                            <div class="mb-3">
                                <label for="agregarNota" class="form-label">Calificación</label>
                                <input type="number" class="form-control" id="agregarNota" name="nota" min="0" max="10" step="0.1" required>
                            </div>
                            <div class="mb-3">
                                <label for="agregarPonderacion" class="form-label">Ponderación (%)</label>
                                <input type="number" class="form-control" id="agregarPonderacion" name="ponderacion" min="1" max="100" required>
                            </div>
                            <div class="mb-3">
                                <label for="agregarComentario" class="form-label">Comentario (opcional)</label>
                                <textarea class="form-control" id="agregarComentario" name="comentario" rows="2"></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                            <button type="submit" class="btn btn-primary">Guardar</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Editar Calificación Modal -->
        <div class="modal fade" id="editarCalificacionModal" tabindex="-1" aria-labelledby="editarCalificacionModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editarCalificacionModalLabel">Editar Calificación</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="${pageContext.request.contextPath}/calificaciones/editar" method="post" id="editarCalificacionForm">
                        <input type="hidden" id="editarId" name="id">
                        <div class="modal-body">
                            <div class="mb-3">
                                <label for="editarAsignatura" class="form-label">Asignatura</label>
                                <select class="form-select" id="editarAsignatura" name="asignaturaId" required>
                                    <option value="">Seleccionar asignatura</option>
                                    <c:forEach items="${asignaturas}" var="asignatura">
                                        <option value="${asignatura.id}">${asignatura.nombre}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="editarEstudiante" class="form-label">Estudiante</label>
                                <select class="form-select" id="editarEstudiante" name="estudianteId" required>
                                    <option value="">Seleccionar estudiante</option>
                                    <c:forEach items="${estudiantes}" var="estudiante">
                                        <option value="${estudiante.id}">${estudiante.nombre} ${estudiante.apellido}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="editarTipo" class="form-label">Tipo</label>
                                <select class="form-select" id="editarTipo" name="tipo" required>
                                    <option value="">Seleccionar tipo</option>
                                    <option value="EXAMEN">Examen</option>
                                    <option value="TRABAJO">Trabajo</option>
                                    <option value="PROYECTO">Proyecto</option>
                                    <option value="PARTICIPACION">Participación</option>
                                    <option value="TAREA">Tarea</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="editarDescripcion" class="form-label">Descripción</label>
                                <input type="text" class="form-control" id="editarDescripcion" name="descripcion" required>
                            </div>
                            <div class="mb-3">
                                <label for="editarFecha" class="form-label">Fecha</label>
                                <input type="date" class="form-control" id="editarFecha" name="fecha" required>
                            </div>
                            <div class="mb-3">
                                <label for="editarNota" class="form-label">Calificación</label>
                                <input type="number" class="form-control" id="editarNota" name="nota" min="0" max="10" step="0.1" required>
                            </div>
                            <div class="mb-3">
                                <label for="editarPonderacion" class="form-label">Ponderación (%)</label>
                                <input type="number" class="form-control" id="editarPonderacion" name="ponderacion" min="1" max="100" required>
                            </div>
                            <div class="mb-3">
                                <label for="editarComentario" class="form-label">Comentario (opcional)</label>
                                <textarea class="form-control" id="editarComentario" name="comentario" rows="2"></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                            <button type="submit" class="btn btn-primary">Guardar Cambios</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Eliminar Calificación Modal -->
        <div class="modal fade" id="eliminarCalificacionModal" tabindex="-1" aria-labelledby="eliminarCalificacionModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="eliminarCalificacionModalLabel">Confirmar Eliminación</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>¿Está seguro que desea eliminar esta calificación? Esta acción no se puede deshacer.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <form action="${pageContext.request.contextPath}/calificaciones/eliminar" method="post">
                            <input type="hidden" id="eliminarId" name="id">
                            <button type="submit" class="btn btn-danger">Eliminar</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </c:if>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/assets/js/calificaciones.js"></script>
    
    <script>
        // Datos para los gráficos (pasados desde el servidor)
        const distribucionData = ${distribucionJson};
        const evolucionData = ${evolucionJson};
        const asignaturasData = ${asignaturasJson};
        
        document.addEventListener('DOMContentLoaded', function() {
            // Inicializar gráficos
            initCharts(distribucionData, evolucionData, asignaturasData);
            
            // Manejar filtros
            document.getElementById('btnAplicarFiltros').addEventListener('click', function() {
                document.getElementById('filtroForm').submit();
            });
            
            // Manejar modal de editar calificación
            const editarCalificacionModal = document.getElementById('editarCalificacionModal');
            if (editarCalificacionModal) {
                editarCalificacionModal.addEventListener('show.bs.modal', function(event) {
                    const button = event.relatedTarget;
                    const calificacionId = button.getAttribute('data-id');
                    cargarDatosCalificacion(calificacionId);
                });
            }
            
            // Manejar modal de eliminar calificación
            const eliminarCalificacionModal = document.getElementById('eliminarCalificacionModal');
            if (eliminarCalificacionModal) {
                eliminarCalificacionModal.addEventListener('show.bs.modal', function(event) {
                    const button = event.relatedTarget;
                    const calificacionId = button.getAttribute('data-id');
                    document.getElementById('eliminarId').value = calificacionId;
                });
            }
        });
        
        function cargarDatosCalificacion(calificacionId) {
            fetch('${pageContext.request.contextPath}/calificaciones/obtener?id=' + calificacionId)
                .then(response => response.json())
                .then(data => {
                    document.getElementById('editarId').value = data.id;
                    document.getElementById('editarAsignatura').value = data.asignaturaId;
                    document.getElementById('editarEstudiante').value = data.estudianteId;
                    document.getElementById('editarTipo').value = data.tipo;
                    document.getElementById('editarDescripcion').value = data.descripcion;
                    document.getElementById('editarFecha').value = data.fechaISO;
                    document.getElementById('editarNota').value = data.nota;
                    document.getElementById('editarPonderacion').value = data.ponderacion;
                    document.getElementById('editarComentario').value = data.comentario || '';
                })
                .catch(error => {
                    console.error('Error al cargar los datos:', error);
                    alert('Error al cargar los datos de la calificación');
                });
        }
    </script>
</body>
</html>