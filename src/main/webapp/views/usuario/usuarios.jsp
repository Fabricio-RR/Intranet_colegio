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
</head>
<body class="admin-dashboard">
    <!-- Sidebar -->
    <jsp:include page="/includes/sidebar.jsp" />
    <c:set var="tituloPaginaDesktop" value="Gestión de Usuarios" scope="request" />
    <c:set var="tituloPaginaMobile" value="Usuarios" scope="request" />
    <c:set var="iconoPagina" value="fas fa-users" scope="request" />
    <jsp:include page="/includes/header.jsp" />
   
    <!-- Main Content -->
    <main class="main-content">
        
    <!-- Filtros y Acciones -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <div class="d-flex flex-wrap justify-content-end align-items-center gap-2">
                        <button type="button" class="btn btn-outline-success btn-sm btn-uniform " onclick="exportarUsuarios()">
                            <i class="fas fa-file-excel me-1"></i>
                            <span>Exportar</span>
                        </button>
                        <a href="${pageContext.request.contextPath}/views/usuario/crear.jsp" 
                           class="btn btn-admin-primary btn-sm btn-uniform">
                            <i class="fas fa-plus me-1"></i>
                            <span class="d-none d-sm-inline">Nuevo </span>Usuario
                        </a>
                    </div>
                </div>
                <div class="card-body">
                    <!-- Filtros Principales -->
                    <div class="row g-3 mb-3">
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
                                    <label class="form-label">Nivel (Solo Estudiantes)</label>
                                    <select class="form-select" id="filtroNivel" onchange="filtrarUsuarios()">
                                        <option value="">Todos los niveles</option>
                                        <c:forEach var="nivel" items="${nivelesDisponibles}">
                                            <option value="${nivel.id_nivel}">${nivel.nombre}</option>
                                        </c:forEach>
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
                            <table id="tablaUsuarios" class="table table-hover align-middle">
                              <thead>
                                    <tr>
                                        <th></th>
                                        <th>DNI</th>
                                        <th>Nombre</th>
                                        <th>Correo</th>
                                        <th>Teléfono</th>
                                        <th>Roles</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${usuarios}" var="usuario">
                                        <tr>
                                            <td>
                                                <input type="checkbox" class="user-checkbox" value="${usuario.idUsuario}">
                                            </td>
                                            <td>${usuario.dni}</td>
                                            <td>${usuario.nombres} ${usuario.apellidos}</td>
                                            <td>${usuario.correo}</td>
                                            <td>${usuario.telefono}</td>
                                            <td>
                                                <c:forEach var="rol" items="${usuario.roles}">
                                                    <span class="badge bg-primary me-1">${rol.nombre}</span>
                                                </c:forEach>
                                            </td>
                                            <td>
                                                <div class="btn-group" role="group">
                                                    <button class="btn btn-sm btn-outline-primary" onclick="verUsuario(${usuario.idUsuario})" title="Ver">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                    <button class="btn btn-sm btn-outline-warning" onclick="editarUsuario(${usuario.idUsuario})" title="Editar">
                                                        <i class="fas fa-edit"></i>
                                                    </button>
                                                    <div class="btn-group" role="group">
                                                        <button class="btn btn-sm btn-outline-secondary dropdown-toggle" data-bs-toggle="dropdown">
                                                            <i class="fas fa-cog"></i>
                                                        </button>
                                                        <ul class="dropdown-menu">
                                                            <li><a class="dropdown-item" href="#" onclick="resetearPassword(${usuario.idUsuario})">
                                                                <i class="fas fa-key me-2"></i>Resetear Contraseña</a></li>
                                                            <li><a class="dropdown-item" href="#" onclick="cambiarEstado(${usuario.idUsuario}, ${usuario.estado})">
                                                                <i class="fas fa-toggle-on me-2"></i>
                                                                ${usuario.estado ? 'Desactivar' : 'Activar'}</a></li>
                                                            <li><a class="dropdown-item" href="#" onclick="verBitacora(${usuario.idUsuario})">
                                                                <i class="fas fa-history me-2"></i>Ver Bitácora</a></li>
                                                            <li><hr class="dropdown-divider"></li>
                                                            <li><a class="dropdown-item text-danger" href="#" onclick="eliminarUsuario(${usuario.idUsuario})">
                                                                <i class="fas fa-trash me-2"></i>Eliminar</a></li>
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
        </div>
        <!-- Modal Ver Usuario -->
        <div class="modal fade" id="modalVerUsuario" tabindex="-1">
            <div class="modal-dialog modal-xl">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title"><i class="fas fa-user me-2"></i>Detalles del Usuario</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body" id="contenidoUsuario"></div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                        <button type="button" class="btn btn-admin-primary" onclick="editarUsuarioModal()">
                            <i class="fas fa-edit me-1"></i>Editar
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <jsp:include page="/includes/footer.jsp" />
    </main>

    <!-- JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/usuarios.js"></script>

    <script>
        $(document).ready(function () {
            $('#tablaUsuarios').DataTable({
                language: {
                    url: 'https://cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json'
                },
                pageLength: 25,
                lengthMenu: [ [10, 25, 50, 100], [10, 25, 50, 100] ],
                lengthChange: true,
                responsive: true
            });
        });
    </script>
</body>
</html>