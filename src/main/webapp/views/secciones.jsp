<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <jsp:include page="/includes/meta.jsp" />
    <title>Gestión de Secciones - Intranet Escolar</title>
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
    <h1 id="pageTitleDesktop" class="h5 d-none d-md-block mb-0">Gestión de Secciones</h1>
    <h1 id="pageTitleMobile" class="h6 d-md-none mb-0">Secciones</h1>
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
                <li class="breadcrumb-item active">Secciones</li>
            </ol>
        </nav>

        <!-- Filtros y Acciones -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">
                                <i class="fas fa-layer-group me-2"></i>
                                Secciones por Nivel Educativo
                            </h5>
                            <div class="d-flex gap-2">
                                <button type="button" class="btn btn-outline-info" onclick="generarReporte()">
                                    <i class="fas fa-file-pdf me-1"></i>
                                    Reporte
                                </button>
                                <button type="button" class="btn btn-admin-primary" onclick="abrirModalNuevaSeccion()">
                                    <i class="fas fa-plus me-1"></i>
                                    Nueva Sección
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <!-- Filtros -->
                        <div class="row mb-3">
                            <div class="col-md-4">
                                <label class="form-label">Filtrar por Nivel</label>
                                <select class="form-select" id="filtroNivel" onchange="filtrarSecciones()">
                                    <option value="">Todos los niveles</option>
                                    <option value="inicial">Inicial</option>
                                    <option value="primaria">Primaria</option>
                                    <option value="secundaria">Secundaria</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Filtrar por Grado</label>
                                <select class="form-select" id="filtroGrado" onchange="filtrarSecciones()">
                                    <option value="">Todos los grados</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Estado</label>
                                <select class="form-select" id="filtroEstado" onchange="filtrarSecciones()">
                                    <option value="">Todos</option>
                                    <option value="activa">Activas</option>
                                    <option value="inactiva">Inactivas</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Estadísticas por Nivel -->
        <div class="row mb-4">
            <div class="col-lg-4 col-md-6 mb-3">
                <div class="nivel-card inicial">
                    <div class="nivel-header">
                        <div class="nivel-icon">
                            <i class="fas fa-baby"></i>
                        </div>
                        <div class="nivel-info">
                            <h6>Educación Inicial</h6>
                            <span class="nivel-stats">${estadisticas.inicial.secciones} secciones</span>
                        </div>
                    </div>
                    <div class="nivel-body">
                        <div class="row text-center">
                            <div class="col-6">
                                <div class="stat-number">${estadisticas.inicial.estudiantes}</div>
                                <div class="stat-label">Estudiantes</div>
                            </div>
                            <div class="col-6">
                                <div class="stat-number">${estadisticas.inicial.docentes}</div>
                                <div class="stat-label">Docentes</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-4 col-md-6 mb-3">
                <div class="nivel-card primaria">
                    <div class="nivel-header">
                        <div class="nivel-icon">
                            <i class="fas fa-child"></i>
                        </div>
                        <div class="nivel-info">
                            <h6>Educación Primaria</h6>
                            <span class="nivel-stats">${estadisticas.primaria.secciones} secciones</span>
                        </div>
                    </div>
                    <div class="nivel-body">
                        <div class="row text-center">
                            <div class="col-6">
                                <div class="stat-number">${estadisticas.primaria.estudiantes}</div>
                                <div class="stat-label">Estudiantes</div>
                            </div>
                            <div class="col-6">
                                <div class="stat-number">${estadisticas.primaria.docentes}</div>
                                <div class="stat-label">Docentes</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-4 col-md-6 mb-3">
                <div class="nivel-card secundaria">
                    <div class="nivel-header">
                        <div class="nivel-icon">
                            <i class="fas fa-user-graduate"></i>
                        </div>
                        <div class="nivel-info">
                            <h6>Educación Secundaria</h6>
                            <span class="nivel-stats">${estadisticas.secundaria.secciones} secciones</span>
                        </div>
                    </div>
                    <div class="nivel-body">
                        <div class="row text-center">
                            <div class="col-6">
                                <div class="stat-number">${estadisticas.secundaria.estudiantes}</div>
                                <div class="stat-label">Estudiantes</div>
                            </div>
                            <div class="col-6">
                                <div class="stat-number">${estadisticas.secundaria.docentes}</div>
                                <div class="stat-label">Docentes</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Secciones por Nivel -->
        <div class="row">
            <c:forEach items="${niveles}" var="nivel">
                <div class="col-12 mb-4" data-nivel="${nivel.codigo}">
                    <div class="card">
                        <div class="card-header">
                            <div class="d-flex justify-content-between align-items-center">
                                <h6 class="mb-0">
                                    <i class="${nivel.icono} me-2"></i>
                                    ${nivel.nombre}
                                </h6>
                                <button type="button" class="btn btn-sm btn-outline-primary" 
                                        onclick="toggleNivel('${nivel.codigo}')">
                                    <i class="fas fa-chevron-down" id="chevron-${nivel.codigo}"></i>
                                </button>
                            </div>
                        </div>
                        <div class="card-body collapse show" id="nivel-${nivel.codigo}">
                            <div class="row">
                                <c:forEach items="${nivel.grados}" var="grado">
                                    <div class="col-lg-6 col-xl-4 mb-4" data-grado="${grado.id}">
                                        <div class="grado-card">
                                            <div class="grado-header">
                                                <h6 class="mb-0">${grado.nombre}</h6>
                                                <span class="badge bg-secondary">${fn:length(grado.secciones)} secciones</span>
                                            </div>
                                            <div class="secciones-grid">
                                                <c:forEach items="${grado.secciones}" var="seccion">
                                                    <div class="seccion-item ${seccion.estado}" data-seccion-id="${seccion.id}">
                                                        <div class="seccion-header">
                                                            <div class="seccion-nombre">${seccion.nombre}</div>
                                                            <div class="seccion-acciones">
                                                                <button type="button" class="btn-icon" 
                                                                        onclick="verSeccion(${seccion.id})" title="Ver detalles">
                                                                    <i class="fas fa-eye"></i>
                                                                </button>
                                                                <button type="button" class="btn-icon" 
                                                                        onclick="editarSeccion(${seccion.id})" title="Editar">
                                                                    <i class="fas fa-edit"></i>
                                                                </button>
                                                                <div class="dropdown">
                                                                    <button type="button" class="btn-icon" 
                                                                            data-bs-toggle="dropdown" title="Más opciones">
                                                                        <i class="fas fa-ellipsis-v"></i>
                                                                    </button>
                                                                    <ul class="dropdown-menu">
                                                                        <li>
                                                                            <a class="dropdown-item" href="#" 
                                                                               onclick="asignarDocente(${seccion.id})">
                                                                                <i class="fas fa-user-plus me-2"></i>Asignar Docente
                                                                            </a>
                                                                        </li>
                                                                        <li>
                                                                            <a class="dropdown-item" href="#" 
                                                                               onclick="verEstudiantes(${seccion.id})">
                                                                                <i class="fas fa-users me-2"></i>Ver Estudiantes
                                                                            </a>
                                                                        </li>
                                                                        <li>
                                                                            <a class="dropdown-item" href="#" 
                                                                               onclick="verHorario(${seccion.id})">
                                                                                <i class="fas fa-calendar me-2"></i>Ver Horario
                                                                            </a>
                                                                        </li>
                                                                        <li><hr class="dropdown-divider"></li>
                                                                        <li>
                                                                            <a class="dropdown-item" href="#" 
                                                                               onclick="cambiarEstado(${seccion.id}, '${seccion.estado}')">
                                                                                <i class="fas fa-toggle-on me-2"></i>
                                                                                ${seccion.estado == 'activa' ? 'Desactivar' : 'Activar'}
                                                                            </a>
                                                                        </li>
                                                                        <li>
                                                                            <a class="dropdown-item text-danger" href="#" 
                                                                               onclick="eliminarSeccion(${seccion.id})">
                                                                                <i class="fas fa-trash me-2"></i>Eliminar
                                                                            </a>
                                                                        </li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="seccion-info">
                                                            <div class="info-item">
                                                                <i class="fas fa-users"></i>
                                                                <span>${seccion.totalEstudiantes} estudiantes</span>
                                                            </div>
                                                            <div class="info-item">
                                                                <i class="fas fa-chalkboard-teacher"></i>
                                                                <span>${seccion.docenteTutor != null ? seccion.docenteTutor : 'Sin tutor'}</span>
                                                            </div>
                                                            <div class="info-item">
                                                                <i class="fas fa-door-open"></i>
                                                                <span>Aula ${seccion.aula != null ? seccion.aula : 'No asignada'}</span>
                                                            </div>
                                                        </div>
                                                        <div class="seccion-footer">
                                                            <span class="estado-badge ${seccion.estado}">
                                                                <i class="fas fa-${seccion.estado == 'activa' ? 'check' : 'pause'}"></i>
                                                                ${seccion.estado == 'activa' ? 'Activa' : 'Inactiva'}
                                                            </span>
                                                            <span class="capacidad-badge ${seccion.totalEstudiantes >= seccion.capacidadMaxima ? 'completa' : ''}">
                                                                ${seccion.totalEstudiantes}/${seccion.capacidadMaxima}
                                                            </span>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                                
                                                <!-- Botón para agregar nueva sección -->
                                                <div class="seccion-item nueva-seccion" 
                                                     onclick="abrirModalNuevaSeccion('${grado.id}')">
                                                    <div class="nueva-seccion-content">
                                                        <i class="fas fa-plus"></i>
                                                        <span>Nueva Sección</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Footer -->
        <jsp:include page="/includes/footer.jsp" />
    </main>

    <!-- Modal Nueva/Editar Sección -->
    <div class="modal fade" id="modalSeccion" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalSeccionTitle">
                        <i class="fas fa-layer-group me-2"></i>
                        Nueva Sección
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="formSeccion" class="needs-validation" novalidate>
                        <input type="hidden" id="seccionId" name="seccionId">
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="nivelSeccion" class="form-label">
                                    Nivel Educativo <span class="text-danger">*</span>
                                </label>
                                <select class="form-select" id="nivelSeccion" name="nivel" required onchange="cargarGradosModal()">
                                    <option value="">Seleccionar nivel</option>
                                    <option value="inicial">Inicial</option>
                                    <option value="primaria">Primaria</option>
                                    <option value="secundaria">Secundaria</option>
                                </select>
                                <div class="invalid-feedback">
                                    Seleccione un nivel educativo.
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="gradoSeccion" class="form-label">
                                    Grado <span class="text-danger">*</span>
                                </label>
                                <select class="form-select" id="gradoSeccion" name="grado" required>
                                    <option value="">Seleccionar grado</option>
                                </select>
                                <div class="invalid-feedback">
                                    Seleccione un grado.
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="nombreSeccion" class="form-label">
                                    Nombre de la Sección <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control" id="nombreSeccion" name="nombre" 
                                       placeholder="Ej: A, B, C..." required>
                                <div class="invalid-feedback">
                                    Ingrese el nombre de la sección.
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="capacidadMaxima" class="form-label">
                                    Capacidad Máxima <span class="text-danger">*</span>
                                </label>
                                <input type="number" class="form-control" id="capacidadMaxima" name="capacidadMaxima" 
                                       min="1" max="50" value="30" required>
                                <div class="invalid-feedback">
                                    Ingrese la capacidad máxima (1-50).
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="aulaSeccion" class="form-label">Aula Asignada</label>
                                <input type="text" class="form-control" id="aulaSeccion" name="aula" 
                                       placeholder="Ej: 101, A-1, Lab 1...">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="estadoSeccion" class="form-label">Estado</label>
                                <select class="form-select" id="estadoSeccion" name="estado">
                                    <option value="activa">Activa</option>
                                    <option value="inactiva">Inactiva</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="docenteTutor" class="form-label">Docente Tutor</label>
                            <select class="form-select" id="docenteTutor" name="docenteTutor">
                                <option value="">Sin asignar</option>
                                <c:forEach items="${docentes}" var="docente">
                                    <option value="${docente.id}">${docente.nombres} ${docente.apellidos}</option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label for="observaciones" class="form-label">Observaciones</label>
                            <textarea class="form-control" id="observaciones" name="observaciones" 
                                      rows="3" placeholder="Observaciones adicionales..."></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="button" class="btn btn-admin-primary" onclick="guardarSeccion()">
                        <i class="fas fa-save me-1"></i>
                        Guardar Sección
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Ver Sección -->
    <div class="modal fade" id="modalVerSeccion" tabindex="-1">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-eye me-2"></i>
                        Detalles de la Sección
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="contenidoVerSeccion">
                    <!-- Contenido cargado dinámicamente -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                    <button type="button" class="btn btn-admin-primary" onclick="editarSeccionModal()">
                        <i class="fas fa-edit me-1"></i>
                        Editar
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
    <script src="${pageContext.request.contextPath}/assets/js/secciones.js"></script>
</body>
</html>
