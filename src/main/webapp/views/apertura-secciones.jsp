<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <jsp:include page="/includes/meta.jsp" />
    <title>Apertura de Secciones - Intranet Escolar</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/assets/css/styles.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/dashboard.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/estructura.css" rel="stylesheet">
</head>
<body class="admin-dashboard">
    <!-- Sidebar -->
    <jsp:include page="/includes/sidebar.jsp" />
    <h1 id="pageTitleDesktop" class="h5 d-none d-md-block mb-0">Apertura de Secciones</h1>
    <h1 id="pageTitleMobile" class="h6 d-md-none mb-0">Apertura Secciones</h1>
    <jsp:include page="/includes/header.jsp" />
   
    <!-- Main Content -->
    <main class="main-content">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/dashboard/admin">
                        <i class="fas fa-home"></i> Dashboard
                    </a>
                </li>
                <li class="breadcrumb-item">Estructura Académica</li>
                <li class="breadcrumb-item active">Apertura de Secciones</li>
            </ol>
        </nav>

        <!-- Selector de Año Lectivo -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">
                                <i class="fas fa-calendar-alt me-2"></i>
                                Gestión de Apertura de Secciones
                            </h5>
                            <div class="d-flex gap-2">
                                <button type="button" class="btn btn-outline-info" onclick="generarReporte()">
                                    <i class="fas fa-file-pdf me-1"></i>
                                    Reporte
                                </button>
                                <button type="button" class="btn btn-admin-primary" onclick="abrirModalNuevaApertura()">
                                    <i class="fas fa-plus me-1"></i>
                                    Nueva Apertura
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Año Lectivo</label>
                                <select class="form-select" id="filtroAnioLectivo" onchange="cargarAperturas()">
                                    <c:forEach items="${aniosLectivos}" var="anio">
                                        <option value="${anio.id_anio_lectivo}" ${anio.estado == 'activo' ? 'selected' : ''}>
                                            ${anio.nombre} - ${anio.estado.toUpperCase()}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-3 mb-3">
                                <label class="form-label">Filtrar por Nivel</label>
                                <select class="form-select" id="filtroNivel" onchange="filtrarAperturas()">
                                    <option value="">Todos los niveles</option>
                                    <c:forEach items="${niveles}" var="nivel">
                                        <option value="${nivel.id_nivel}">${nivel.nombre}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-3 mb-3">
                                <label class="form-label">Buscar</label>
                                <input type="text" class="form-control" id="buscarSeccion" 
                                       placeholder="Grado, sección..." onkeyup="filtrarAperturas()">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Estadísticas del Año Lectivo -->
        <div class="row mb-4">
            <div class="col-lg-3 col-md-6 mb-3">
                <div class="stats-card-small">
                    <div class="stats-icon-small bg-primary">
                        <i class="fas fa-layer-group"></i>
                    </div>
                    <div class="stats-content-small">
                        <div class="stats-number-small">${estadisticas.totalAperturas}</div>
                        <div class="stats-label-small">Secciones Abiertas</div>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-3">
                <div class="stats-card-small">
                    <div class="stats-icon-small bg-success">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stats-content-small">
                        <div class="stats-number-small">${estadisticas.totalMatriculados}</div>
                        <div class="stats-label-small">Estudiantes Matriculados</div>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-3">
                <div class="stats-card-small">
                    <div class="stats-icon-small bg-warning">
                        <i class="fas fa-chalkboard-teacher"></i>
                    </div>
                    <div class="stats-content-small">
                        <div class="stats-number-small">${estadisticas.docentesAsignados}</div>
                        <div class="stats-label-small">Docentes Asignados</div>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-3">
                <div class="stats-card-small">
                    <div class="stats-icon-small bg-info">
                        <i class="fas fa-book"></i>
                    </div>
                    <div class="stats-content-small">
                        <div class="stats-number-small">${estadisticas.cursosAsignados}</div>
                        <div class="stats-label-small">Cursos Asignados</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Aperturas por Nivel -->
        <div class="row">
            <c:forEach items="${nivelesConAperturas}" var="nivel">
                <div class="col-12 mb-4" data-nivel="${nivel.id_nivel}">
                    <div class="card">
                        <div class="card-header">
                            <div class="d-flex justify-content-between align-items-center">
                                <h6 class="mb-0">
                                    <i class="fas fa-layer-group me-2"></i>
                                    ${nivel.nombre}
                                    <span class="badge bg-secondary ms-2">${fn:length(nivel.aperturas)} secciones</span>
                                </h6>
                                <button type="button" class="btn btn-sm btn-outline-primary" 
                                        onclick="toggleNivel('${nivel.id_nivel}')">
                                    <i class="fas fa-chevron-down" id="chevron-${nivel.id_nivel}"></i>
                                </button>
                            </div>
                        </div>
                        <div class="card-body collapse show" id="nivel-${nivel.id_nivel}">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Grado</th>
                                            <th>Sección</th>
                                            <th>Matriculados</th>
                                            <th>Capacidad</th>
                                            <th>Docente Tutor</th>
                                            <th>Cursos Asignados</th>
                                            <th>Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${nivel.aperturas}" var="apertura">
                                            <tr data-apertura-id="${apertura.id_apertura_seccion}">
                                                <td>
                                                    <strong>${apertura.grado.nombre}</strong>
                                                </td>
                                                <td>
                                                    <span class="badge bg-primary">${apertura.seccion.nombre}</span>
                                                </td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <span class="me-2">${apertura.totalMatriculados}</span>
                                                        <div class="progress flex-grow-1" style="height: 6px;">
                                                            <div class="progress-bar ${apertura.porcentajeOcupacion >= 90 ? 'bg-danger' : apertura.porcentajeOcupacion >= 70 ? 'bg-warning' : 'bg-success'}" 
                                                                 style="width: ${apertura.porcentajeOcupacion}%"></div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="text-muted">${apertura.capacidadMaxima}</span>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty apertura.docenteTutor}">
                                                            <div class="d-flex align-items-center">
                                                                <img src="${apertura.docenteTutor.foto_perfil != null ? apertura.docenteTutor.foto_perfil : '/placeholder.svg?height=30&width=30'}" 
                                                                     alt="Foto" class="rounded-circle me-2" width="30" height="30">
                                                                <div>
                                                                    <div class="fw-bold small">${apertura.docenteTutor.nombres} ${apertura.docenteTutor.apellidos}</div>
                                                                </div>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">Sin asignar</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <span class="badge bg-info">${apertura.totalCursos} cursos</span>
                                                </td>
                                                <td>
                                                    <div class="btn-group" role="group">
                                                        <button type="button" class="btn btn-sm btn-outline-primary" 
                                                                onclick="verDetalleApertura(${apertura.id_apertura_seccion})" title="Ver detalles">
                                                            <i class="fas fa-eye"></i>
                                                        </button>
                                                        <button type="button" class="btn btn-sm btn-outline-success" 
                                                                onclick="gestionarMatriculas(${apertura.id_apertura_seccion})" title="Gestionar matrículas">
                                                            <i class="fas fa-users"></i>
                                                        </button>
                                                        <button type="button" class="btn btn-sm btn-outline-info" 
                                                                onclick="gestionarMallaCurricular(${apertura.id_apertura_seccion})" title="Malla curricular">
                                                            <i class="fas fa-book"></i>
                                                        </button>
                                                        <div class="btn-group" role="group">
                                                            <button type="button" class="btn btn-sm btn-outline-secondary dropdown-toggle" 
                                                                    data-bs-toggle="dropdown">
                                                                <i class="fas fa-cog"></i>
                                                            </button>
                                                            <ul class="dropdown-menu">
                                                                <li>
                                                                    <a class="dropdown-item" href="#" onclick="asignarDocenteTutor(${apertura.id_apertura_seccion})">
                                                                        <i class="fas fa-user-plus me-2"></i>Asignar Tutor
                                                                    </a>
                                                                </li>
                                                                <li>
                                                                    <a class="dropdown-item" href="#" onclick="configurarHorario(${apertura.id_apertura_seccion})">
                                                                        <i class="fas fa-calendar me-2"></i>Configurar Horario
                                                                    </a>
                                                                </li>
                                                                <li>
                                                                    <a class="dropdown-item" href="#" onclick="verReporteSeccion(${apertura.id_apertura_seccion})">
                                                                        <i class="fas fa-chart-bar me-2"></i>Reporte de Sección
                                                                    </a>
                                                                </li>
                                                                <li><hr class="dropdown-divider"></li>
                                                                <li>
                                                                    <a class="dropdown-item text-danger" href="#" onclick="cerrarApertura(${apertura.id_apertura_seccion})">
                                                                        <i class="fas fa-times me-2"></i>Cerrar Sección
                                                                    </a>
                                                                </li>
                                                            </ul>
                                                        </div>
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
            </c:forEach>
        </div>

        <!-- Footer -->
        <jsp:include page="/includes/footer.jsp" />
    </main>

    <!-- Modal Nueva Apertura -->
    <div class="modal fade" id="modalNuevaApertura" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-plus me-2"></i>
                        Nueva Apertura de Sección
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="formNuevaApertura" class="needs-validation" novalidate>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="anioLectivoApertura" class="form-label">
                                    Año Lectivo <span class="text-danger">*</span>
                                </label>
                                <select class="form-select" id="anioLectivoApertura" name="id_anio_lectivo" required>
                                    <c:forEach items="${aniosLectivos}" var="anio">
                                        <option value="${anio.id_anio_lectivo}" ${anio.estado == 'activo' ? 'selected' : ''}>
                                            ${anio.nombre}
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="invalid-feedback">
                                    Seleccione un año lectivo.
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="nivelApertura" class="form-label">
                                    Nivel <span class="text-danger">*</span>
                                </label>
                                <select class="form-select" id="nivelApertura" name="id_nivel" required onchange="cargarGradosApertura()">
                                    <option value="">Seleccionar nivel</option>
                                    <c:forEach items="${niveles}" var="nivel">
                                        <option value="${nivel.id_nivel}">${nivel.nombre}</option>
                                    </c:forEach>
                                </select>
                                <div class="invalid-feedback">
                                    Seleccione un nivel.
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="gradoApertura" class="form-label">
                                    Grado <span class="text-danger">*</span>
                                </label>
                                <select class="form-select" id="gradoApertura" name="id_grado" required>
                                    <option value="">Seleccionar grado</option>
                                </select>
                                <div class="invalid-feedback">
                                    Seleccione un grado.
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="seccionApertura" class="form-label">
                                    Sección <span class="text-danger">*</span>
                                </label>
                                <select class="form-select" id="seccionApertura" name="id_seccion" required>
                                    <option value="">Seleccionar sección</option>
                                    <c:forEach items="${secciones}" var="seccion">
                                        <option value="${seccion.id_seccion}">${seccion.nombre}</option>
                                    </c:forEach>
                                </select>
                                <div class="invalid-feedback">
                                    Seleccione una sección.
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="capacidadMaxima" class="form-label">
                                    Capacidad Máxima <span class="text-danger">*</span>
                                </label>
                                <input type="number" class="form-control" id="capacidadMaxima" name="capacidad_maxima" 
                                       min="1" max="50" value="30" required>
                                <div class="invalid-feedback">
                                    Ingrese la capacidad máxima (1-50).
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="docenteTutorApertura" class="form-label">Docente Tutor</label>
                                <select class="form-select" id="docenteTutorApertura" name="id_docente_tutor">
                                    <option value="">Sin asignar</option>
                                    <c:forEach items="${docentesDisponibles}" var="docente">
                                        <option value="${docente.id_usuario}">${docente.nombres} ${docente.apellidos}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="button" class="btn btn-admin-primary" onclick="guardarNuevaApertura()">
                        <i class="fas fa-save me-1"></i>
                        Crear Apertura
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/apertura-secciones.js"></script>
</body>
</html>
