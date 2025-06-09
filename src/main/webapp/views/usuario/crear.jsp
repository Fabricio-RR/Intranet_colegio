<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <jsp:include page="/includes/meta.jsp" />
    <title>Crear Usuario - Intranet Escolar</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS 
    <link href="${pageContext.request.contextPath}/assets/css/styles.css" rel="stylesheet">-->
    <link href="${pageContext.request.contextPath}/assets/css/formularios.css" rel="stylesheet">
</head>
<body class="admin-dashboard"data-context-path="${pageContext.request.contextPath}">

    <!-- Sidebar -->
    <jsp:include page="/includes/sidebar.jsp" />
    <c:set var="tituloPaginaDesktop" value="Crear Nuevo Usuario" scope="request" />
    <c:set var="tituloPaginaMobile" value="Nuevo Usuario" scope="request" />
    <c:set var="iconoPagina" value="fas fa-user-plus" scope="request" />
    <jsp:include page="/includes/header.jsp" />
   
    <!-- Main Content -->
    <main class="main-content">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/usuarios">
                        <i class="fas fa-users"></i>Usuarios
                    </a>
                </li>
                <li class="breadcrumb-item active">Crear Usuario</li>
            </ol>
        </nav>

        <!-- Formulario de Creación -->
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <form id="formCrearUsuario" class="needs-validation" novalidate>
                    <!-- Información Personal -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <h5 class="mb-0">
                                <i class="fas fa-user me-2"></i>
                                Información Personal
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <!-- Foto de perfil -->
                                <div class="col-md-3 text-center mb-4 d-flex flex-column align-items-center justify-content-center">
                                    <div class="foto-perfil-container">
                                        <img id="previewFoto" src="${pageContext.request.contextPath}/uploads/default.png?height=150&width=150" 
                                             alt="Foto de perfil" class="foto-perfil">
                                        <div class="foto-overlay">
                                            <i class="fas fa-camera"></i>
                                            <span>Cambiar foto</span>
                                        </div>
                                        <input type="file" id="inputFoto" name="foto_perfil" accept="image/*" style="display: none;">
                                    </div>
                                    <small class="text-muted d-block mt-2">Máximo 2MB - JPG, PNG</small>
                                </div>
                                
                                <div class="col-md-9">
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="nombres" class="form-label">
                                                Nombres <span class="text-danger">*</span>
                                            </label>
                                            <input type="text" class="form-control" id="nombres" name="nombres" required>
                                            <div class="invalid-feedback">
                                                Por favor ingrese los nombres.
                                            </div>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="apellidos" class="form-label">
                                                Apellidos <span class="text-danger">*</span>
                                            </label>
                                            <input type="text" class="form-control" id="apellidos" name="apellidos" required>
                                            <div class="invalid-feedback">
                                                Por favor ingrese los apellidos.
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="dni" class="form-label">
                                                DNI <span class="text-danger">*</span>
                                            </label>
                                            <input type="text" class="form-control" id="dni" name="dni" 
                                                   pattern="[0-9]{8}" maxlength="8" required>
                                            <div class="invalid-feedback">
                                                Ingrese un DNI válido (8 dígitos).
                                            </div>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="telefono" class="form-label">Teléfono</label>
                                            <input type="tel" class="form-control" id="telefono" name="telefono">
                                        </div>
                                    </div>
                                    
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="correo" class="form-label">
                                                Email <span class="text-danger">*</span>
                                            </label>
                                            <input type="email" class="form-control" id="correo" name="correo" required>
                                            <div class="invalid-feedback">
                                                Ingrese un email válido.
                                            </div>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="clave" class="form-label">
                                                Contraseña <span class="text-danger">*</span>
                                            </label>
                                            <div class="input-group">
                                                <input type="password" class="form-control" id="clave" name="clave" required>
                                                <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('clave')">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                            </div>
                                            <div class="form-text">
                                                Mínimo 8 caracteres, incluir mayúsculas, minúsculas y números.
                                            </div>
                                            <div class="invalid-feedback">
                                                La contraseña debe tener al menos 8 caracteres.
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="confirmarClave" class="form-label">
                                                Confirmar Contraseña <span class="text-danger">*</span>
                                            </label>
                                            <div class="input-group">
                                                <input type="password" class="form-control" id="confirmarClave" 
                                                       name="confirmarClave" required>
                                                <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('confirmarClave')">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                            </div>
                                            <div class="invalid-feedback">
                                                Las contraseñas no coinciden.
                                            </div>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="estado" class="form-label">Estado</label>
                                            <select class="form-select" id="estado" name="estado">
                                                <option value="1" selected>Activo</option>
                                                <option value="0">Inactivo</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Roles y Permisos -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <h5 class="mb-0">
                                <i class="fas fa-user-tag me-2"></i>
                                Roles del Usuario
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-12 mb-3">
                                    <label class="form-label">
                                        Seleccionar Roles <span class="text-danger">*</span>
                                    </label>
                                    <div class="roles-container">
                                        <c:forEach items="${rolesDisponibles}" var="rol">
                                            <div class="form-check role-check">
                                                <input class="form-check-input" type="checkbox" value="${rol.idRol}" 
                                                    id="rol${rol.idRol}" name="roles">
                                                <label class="form-check-label" for="rol${rol.idRol}">
                                                    <div class="role-card-small">
                                                        <div class="role-icon-small" style="
                                                            <c:choose>
                                                                <c:when test="${rol.nombre eq 'Administrador'}">background-color: #0A0A3D;</c:when>
                                                                <c:when test="${rol.nombre eq 'Docente'}">background-color: #007bff;</c:when>
                                                                <c:when test="${rol.nombre eq 'Alumno'}">background-color: #28a745;</c:when>
                                                                <c:when test="${rol.nombre eq 'Apoderado'}">background-color: #ffc107;</c:when>
                                                                <c:otherwise>background-color: #6c757d;</c:otherwise>
                                                            </c:choose>
                                                        ">
                                                            <c:choose>
                                                                <c:when test="${rol.nombre eq 'Administrador'}">
                                                                    <i class="fas fa-user-shield"></i>
                                                                </c:when>
                                                                <c:when test="${rol.nombre eq 'Docente'}">
                                                                    <i class="fas fa-chalkboard-teacher"></i>
                                                                </c:when>
                                                                <c:when test="${rol.nombre eq 'Alumno'}">
                                                                    <i class="fas fa-user-graduate"></i>
                                                                </c:when>
                                                                <c:when test="${rol.nombre eq 'Apoderado'}">
                                                                    <i class="fas fa-users"></i>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <i class="fas fa-user-tag"></i>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <div class="role-info">
                                                            <strong>${rol.nombre}</strong>
                                                            <small>${rol.descripcion}</small>
                                                        </div>
                                                    </div>
                                                </label>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Botones de Acción -->
                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex justify-content-between">
                                <a href="${pageContext.request.contextPath}/usuarios" 
                                   class="btn btn-outline-danger btn-sm btn-uniform">
                                    <i class="fas fa-arrow-left me-1"></i>
                                    Cancelar
                                </a>
                                <div>
                                    <button type="button" class="btn btn-outline-success btn-sm btn-uniform" onclick="limpiarFormulario()">
                                        <i class="fas fa-eraser me-1"></i>
                                        Limpiar
                                    </button>
                                    <button type="submit" class="btn btn-admin-primary">
                                        <i class="fas fa-save me-1"></i>
                                        Crear Usuario
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Footer -->
        <jsp:include page="/includes/footer.jsp" />
    </main>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/crear-usuario.js"></script>
</body>
</html>
