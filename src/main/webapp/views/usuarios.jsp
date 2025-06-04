<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <jsp:include page="/includes/meta.jsp" />
    <title>Gestión de Usuarios - Intranet Escolar</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- DataTables CSS -->
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <!-- Custom CSS 
    <link href="${pageContext.request.contextPath}/assets/css/styles.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/dashboard.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/usuarios.css" rel="stylesheet">-->
</head>
<body class="admin-dashboard">
    <!-- Sidebar -->
    <jsp:include page="/includes/sidebar.jsp" />
    <h1 id="pageTitleDesktop" class="h5 d-none d-md-block mb-0">Gestión de Usuarios</h1>
    <h1 id="pageTitleMobile" class="h6 d-md-none mb-0">Usuarios</h1>
    <jsp:include page="/includes/header.jsp" />
   
    <!-- Main Content -->
    <main class="main-content">
        
        <!-- Filtros y Acciones -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3">
                        <h5 class="mb-0">
                            <i class="fas fa-users me-2"></i>
                            Usuarios del Sistema
                        </h5>
                        <div class="d-flex flex-column flex-sm-row gap-2">
                            <button type="button" class="btn btn-outline-success" onclick="exportarUsuarios()">
                                <i class="fas fa-file-excel me-1"></i>
                                <span class="d-none d-sm-inline">Exportar</span>
                            </button>
                            <a href="${pageContext.request.contextPath}/views/crear.jsp" 
                               class="btn btn-admin-primary">
                                <i class="fas fa-plus me-1"></i>
                                <span class="d-none d-sm-inline">Nuevo </span>Usuario
                            </a>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <!-- Filtros Principales -->
                    <div class="row g-3 mb-3">
                        <div class="col-12 col-sm-6 col-lg-3">
                            <label class="form-label">Buscar Usuario</label>
                            <div class="input-group">
                                <span class="input-group-text">
                                    <i class="fas fa-search"></i>
                                </span>
                                <input type="text" class="form-control" id="buscarUsuario" 
                                       placeholder="Nombre, DNI, email...">
                                <button class="btn btn-outline-secondary" type="button" onclick="limpiarFiltros()" title="Limpiar">
                                    <i class="fas fa-times"></i>
                                </button>
                            </div>
                        </div>
                        <div class="col-6 col-sm-6 col-lg-2">
                            <label class="form-label">Estado</label>
                            <select class="form-select" id="filtroEstado" onchange="filtrarUsuarios()">
                                <option value="">Todos</option>
                                <option value="1">Activos</option>
                                <option value="0">Inactivos</option>
                            </select>
                        </div>
                        <div class="col-6 col-sm-6 col-lg-3">
                            <label class="form-label">Rol</label>
                            <select class="form-select" id="filtroRol" onchange="filtrarUsuarios()">
                                <option value="">Todos los roles</option>
                                <c:forEach items="${rolesDisponibles}" var="rol">
                                    <option value="${rol.id_rol}">${rol.nombre}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <!-- Filtros Avanzados (Colapsable) -->
                    <div class="collapse" id="filtrosAvanzados">
                        <div class="border-top pt-3">
                            <div class="row g-3">
                                <div class="col-12 col-md-6 col-lg-3">
                                    <label class="form-label">Fecha de Registro</label>
                                    <select class="form-select" id="filtroFecha" onchange="filtrarUsuarios()">
                                        <option value="">Cualquier fecha</option>
                                        <option value="hoy">Hoy</option>
                                        <option value="semana">Esta semana</option>
                                        <option value="mes">Este mes</option>
                                        <option value="año">Este año</option>
                                    </select>
                                </div>
                                <div class="col-12 col-md-6 col-lg-3">
                                    <label class="form-label">Grado (Solo Estudiantes)</label>
                                    <select class="form-select" id="filtroGrado" onchange="filtrarUsuarios()">
                                        <option value="">Todos los grados</option>
                                        <c:forEach items="${gradosDisponibles}" var="grado">
                                            <option value="${grado.id_grado}">${grado.nombre}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-12 col-md-6 col-lg-3">
                                    <label class="form-label">Sección (Solo Estudiantes)</label>
                                    <select class="form-select" id="filtroSeccion" onchange="filtrarUsuarios()">
                                        <option value="">Todas las secciones</option>
                                        <c:forEach items="${seccionesDisponibles}" var="seccion">
                                            <option value="${seccion.id_seccion}">${seccion.nombre}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-12 col-md-6 col-lg-3">
                                    <label class="form-label">Ordenar por</label>
                                    <select class="form-select" id="ordenarPor" onchange="ordenarUsuarios()">
                                        <option value="nombre">Nombre A-Z</option>
                                        <option value="nombre_desc">Nombre Z-A</option>
                                        <option value="fecha_asc">Más antiguos</option>
                                        <option value="fecha_desc">Más recientes</option>
                                        <option value="estado">Por estado</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Botón para mostrar/ocultar filtros avanzados -->
                     <div class="text-center mt-3">
                        <button class="btn btn-link btn-sm" type="button" data-bs-toggle="collapse" 
                                data-bs-target="#filtrosAvanzados" aria-expanded="false">
                            <i class="fas fa-filter me-1"></i>
                            <span class="toggle-text">Mostrar filtros avanzados</span>
                            <i class="fas fa-chevron-down ms-1 toggle-icon"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
        <!-- Tabla de Usuarios -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table id="tablaUsuarios" class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>
                                            <input type="checkbox" id="selectAll" onchange="toggleSelectAll()">
                                        </th>
                                        <th>Usuario</th>
                                        <th>Roles</th>
                                        <th>Estado</th>
                                        <th>Información Adicional</th>
                                        <th>Fecha Registro</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${usuarios}" var="usuario">
                                        <tr data-usuario-id="${usuario.id_usuario}">
                                            <td>
                                                <input type="checkbox" class="user-checkbox" value="${usuario.id_usuario}">
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <img src="${usuario.foto_perfil != null ? usuario.foto_perfil : '/placeholder.svg?height=40&width=40'}" 
                                                         alt="Foto" class="rounded-circle me-3" width="40" height="40">
                                                    <div>
                                                        <div class="fw-bold">${usuario.nombres} ${usuario.apellidos}</div>
                                                        <small class="text-muted">${usuario.correo}</small>
                                                        <br><small class="text-muted">DNI: ${usuario.dni}</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <c:forEach items="${usuario.roles}" var="rol" varStatus="status">
                                                    <span class="badge bg-primary me-1">
                                                        ${rol.nombre}
                                                    </span>
                                                    <c:if test="${!status.last}"><br></c:if>
                                                </c:forEach>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${usuario.estado}">
                                                        <span class="badge bg-success">
                                                            <i class="fas fa-check me-1"></i>Activo
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">
                                                            <i class="fas fa-pause me-1"></i>Inactivo
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <!-- Información específica según el tipo de usuario -->
                                                <c:if test="${usuario.esAlumno}">
                                                    <div class="info-adicional">
                                                        <small class="text-muted d-block">
                                                            <i class="fas fa-id-card me-1"></i>
                                                            Código: ${usuario.alumno.codigo_matricula}
                                                        </small>
                                                        <small class="text-muted d-block">
                                                            <i class="fas fa-layer-group me-1"></i>
                                                            ${usuario.alumno.grado} - ${usuario.alumno.seccion}
                                                        </small>
                                                    </div>
                                                </c:if>
                                                <c:if test="${usuario.esDocente}">
                                                    <div class="info-adicional">
                                                        <small class="text-muted d-block">
                                                            <i class="fas fa-book me-1"></i>
                                                            ${usuario.docente.totalCursos} cursos asignados
                                                        </small>
                                                    </div>
                                                </c:if>
                                                <c:if test="${usuario.esApoderado}">
                                                    <div class="info-adicional">
                                                        <small class="text-muted d-block">
                                                            <i class="fas fa-child me-1"></i>
                                                            ${fn:length(usuario.apoderado.hijos)} hijo(s)
                                                        </small>
                                                    </div>
                                                </c:if>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${usuario.fec_registro}" pattern="dd/MM/yyyy HH:mm" />
                                            </td>
                                            <td>
                                                <div class="btn-group" role="group">
                                                    <button type="button" class="btn btn-sm btn-outline-primary" 
                                                            onclick="verUsuario(${usuario.id_usuario})" title="Ver detalles">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                    <button type="button" class="btn btn-sm btn-outline-warning" 
                                                            onclick="editarUsuario(${usuario.id_usuario})" title="Editar">
                                                        <i class="fas fa-edit"></i>
                                                    </button>
                                                    <div class="btn-group" role="group">
                                                        <button type="button" class="btn btn-sm btn-outline-secondary dropdown-toggle" 
                                                                data-bs-toggle="dropdown">
                                                            <i class="fas fa-cog"></i>
                                                        </button>
                                                        <ul class="dropdown-menu">
                                                            <li>
                                                                <a class="dropdown-item" href="#" onclick="resetearPassword(${usuario.id_usuario})">
                                                                    <i class="fas fa-key me-2"></i>Resetear Contraseña
                                                                </a>
                                                            </li>
                                                            <li>
                                                                <a class="dropdown-item" href="#" onclick="cambiarEstado(${usuario.id_usuario}, ${usuario.estado})">
                                                                    <i class="fas fa-toggle-on me-2"></i>
                                                                    ${usuario.estado ? 'Desactivar' : 'Activar'}
                                                                </a>
                                                            </li>
                                                            <li>
                                                                <a class="dropdown-item" href="#" onclick="verBitacora(${usuario.id_usuario})">
                                                                    <i class="fas fa-history me-2"></i>Ver Bitácora
                                                                </a>
                                                            </li>
                                                            <c:if test="${usuario.esAlumno}">
                                                                <li><hr class="dropdown-divider"></li>
                                                                <li>
                                                                    <a class="dropdown-item" href="#" onclick="verMatricula(${usuario.id_usuario})">
                                                                        <i class="fas fa-graduation-cap me-2"></i>Ver Matrícula
                                                                    </a>
                                                                </li>
                                                                <li>
                                                                    <a class="dropdown-item" href="#" onclick="verCalificaciones(${usuario.id_usuario})">
                                                                        <i class="fas fa-chart-line me-2"></i>Ver Calificaciones
                                                                    </a>
                                                                </li>
                                                            </c:if>
                                                            <c:if test="${usuario.esDocente}">
                                                                <li><hr class="dropdown-divider"></li>
                                                                <li>
                                                                    <a class="dropdown-item" href="#" onclick="verCursosAsignados(${usuario.id_usuario})">
                                                                        <i class="fas fa-chalkboard me-2"></i>Cursos Asignados
                                                                    </a>
                                                                </li>
                                                                <li>
                                                                    <a class="dropdown-item" href="#" onclick="verHorarioDocente(${usuario.id_usuario})">
                                                                        <i class="fas fa-calendar me-2"></i>Ver Horario
                                                                    </a>
                                                                </li>
                                                            </c:if>
                                                            <li><hr class="dropdown-divider"></li>
                                                            <li>
                                                                <a class="dropdown-item text-danger" href="#" onclick="eliminarUsuario(${usuario.id_usuario})">
                                                                    <i class="fas fa-trash me-2"></i>Eliminar
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
                        
                        <!-- Cards móviles (solo visible en dispositivos pequeños) -->
                        <div class="mobile-cards-container d-block d-sm-none">
                            <c:forEach items="${usuarios}" var="usuario">
                                <div class="user-card-mobile" data-usuario-id="${usuario.id_usuario}">
                                    <div class="user-card-header">
                                        <input type="checkbox" class="user-checkbox" value="${usuario.id_usuario}">
                                        <img src="${usuario.foto_perfil != null ? usuario.foto_perfil : '/placeholder.svg?height=50&width=50'}" 
                                             alt="Foto" class="user-card-avatar">
                                        <div class="user-card-info">
                                            <div class="user-card-name">${usuario.nombres} ${usuario.apellidos}</div>
                                            <div class="user-card-email">${usuario.correo}</div>
                                            <div class="user-card-dni">DNI: ${usuario.dni}</div>
                                        </div>
                                    </div>
                                    
                                    <div class="user-card-body">
                                        <div class="user-card-field">
                                            <div class="user-card-label">Roles</div>
                                            <div class="user-card-value">
                                                <c:forEach items="${usuario.roles}" var="rol" varStatus="status">
                                                    <span class="badge bg-primary me-1">${rol.nombre}</span>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        
                                        <div class="user-card-field">
                                            <div class="user-card-label">Estado</div>
                                            <div class="user-card-value">
                                                <c:choose>
                                                    <c:when test="${usuario.estado}">
                                                        <span class="badge bg-success">
                                                            <i class="fas fa-check me-1"></i>Activo
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">
                                                            <i class="fas fa-pause me-1"></i>Inactivo
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        
                                        <c:if test="${usuario.esAlumno}">
                                            <div class="user-card-field">
                                                <div class="user-card-label">Código</div>
                                                <div class="user-card-value">${usuario.alumno.codigo_matricula}</div>
                                            </div>
                                            
                                            <div class="user-card-field">
                                                <div class="user-card-label">Grado - Sección</div>
                                                <div class="user-card-value">${usuario.alumno.grado} - ${usuario.alumno.seccion}</div>
                                            </div>
                                        </c:if>
                                        
                                        <c:if test="${usuario.esDocente}">
                                            <div class="user-card-field">
                                                <div class="user-card-label">Cursos</div>
                                                <div class="user-card-value">${usuario.docente.totalCursos} asignados</div>
                                            </div>
                                        </c:if>
                                        
                                        <c:if test="${usuario.esApoderado}">
                                            <div class="user-card-field">
                                                <div class="user-card-label">Hijos</div>
                                                <div class="user-card-value">${fn:length(usuario.apoderado.hijos)} hijo(s)</div>
                                            </div>
                                        </c:if>
                                        
                                        <div class="user-card-field">
                                            <div class="user-card-label">Registro</div>
                                            <div class="user-card-value">
                                                <fmt:formatDate value="${usuario.fec_registro}" pattern="dd/MM/yyyy" />
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="user-card-actions">
                                        <button type="button" class="btn btn-sm btn-outline-primary" 
                                                onclick="verUsuario(${usuario.id_usuario})">
                                            <i class="fas fa-eye me-1"></i>Ver
                                        </button>
                                        <button type="button" class="btn btn-sm btn-outline-warning" 
                                                onclick="editarUsuario(${usuario.id_usuario})">
                                            <i class="fas fa-edit me-1"></i>Editar
                                        </button>
                                        <div class="dropdown">
                                            <button type="button" class="btn btn-sm btn-outline-secondary dropdown-toggle" 
                                                    data-bs-toggle="dropdown">
                                                <i class="fas fa-cog me-1"></i>Más
                                            </button>
                                            <ul class="dropdown-menu">
                                                <li>
                                                    <a class="dropdown-item" href="#" onclick="resetearPassword(${usuario.id_usuario})">
                                                        <i class="fas fa-key me-2"></i>Resetear Contraseña
                                                    </a>
                                                </li>
                                                <li>
                                                    <a class="dropdown-item" href="#" onclick="cambiarEstado(${usuario.id_usuario}, ${usuario.estado})">
                                                        <i class="fas fa-toggle-on me-2"></i>
                                                        ${usuario.estado ? 'Desactivar' : 'Activar'}
                                                    </a>
                                                </li>
                                                <li>
                                                    <a class="dropdown-item" href="#" onclick="verBitacora(${usuario.id_usuario})">
                                                        <i class="fas fa-history me-2"></i>Ver Bitácora
                                                    </a>
                                                </li>
                                                <c:if test="${usuario.esAlumno}">
                                                    <li><hr class="dropdown-divider"></li>
                                                    <li>
                                                        <a class="dropdown-item" href="#" onclick="verMatricula(${usuario.id_usuario})">
                                                            <i class="fas fa-graduation-cap me-2"></i>Ver Matrícula
                                                        </a>
                                                    </li>
                                                </c:if>
                                                <li><hr class="dropdown-divider"></li>
                                                <li>
                                                    <a class="dropdown-item text-danger" href="#" onclick="eliminarUsuario(${usuario.id_usuario})">
                                                        <i class="fas fa-trash me-2"></i>Eliminar
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Acciones Masivas -->
        <div class="row mt-3" id="accionesMasivas" style="display: none;">
            <div class="col-12">
                <div class="card border-warning">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <strong id="usuariosSeleccionados">0</strong> usuarios seleccionados
                            </div>
                            <div class="btn-group">
                                <button type="button" class="btn btn-warning" onclick="activarSeleccionados()">
                                    <i class="fas fa-check me-1"></i>Activar
                                </button>
                                <button type="button" class="btn btn-secondary" onclick="desactivarSeleccionados()">
                                    <i class="fas fa-pause me-1"></i>Desactivar
                                </button>
                                <button type="button" class="btn btn-info" onclick="exportarSeleccionados()">
                                    <i class="fas fa-download me-1"></i>Exportar
                                </button>
                                <button type="button" class="btn btn-danger" onclick="eliminarSeleccionados()">
                                    <i class="fas fa-trash me-1"></i>Eliminar
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <jsp:include page="/includes/footer.jsp" />
    </main>

    <!-- Modal Ver Usuario -->
    <div class="modal fade" id="modalVerUsuario" tabindex="-1">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-user me-2"></i>
                        Detalles del Usuario
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="contenidoUsuario">
                    <!-- Contenido cargado dinámicamente -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                    <button type="button" class="btn btn-admin-primary" onclick="editarUsuarioModal()">
                        <i class="fas fa-edit me-1"></i>Editar
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- DataTables JS -->
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/usuarios.js"></script>
    <script>
// Manejar filtros rápidos
document.querySelectorAll('input[name="filtroRapido"]').forEach(radio => {
    radio.addEventListener('change', function() {
        filtrarPorTipo(this.value);
    });
});

// Manejar el toggle de filtros avanzados
document.querySelector('[data-bs-toggle="collapse"]').addEventListener('click', function() {
    const icon = this.querySelector('.toggle-icon');
    const text = this.querySelector('.toggle-text');
    
    this.addEventListener('shown.bs.collapse', function() {
        icon.classList.remove('fa-chevron-down');
        icon.classList.add('fa-chevron-up');
        text.textContent = 'Ocultar filtros avanzados';
    });
    
    this.addEventListener('hidden.bs.collapse', function() {
        icon.classList.remove('fa-chevron-up');
        icon.classList.add('fa-chevron-down');
        text.textContent = 'Mostrar filtros avanzados';
    });
});

function filtrarPorTipo(tipo) {
    // Implementar lógica de filtrado por tipo
    console.log('Filtrando por tipo:', tipo);
    filtrarUsuarios();
}
</script>
</body>
</html>
