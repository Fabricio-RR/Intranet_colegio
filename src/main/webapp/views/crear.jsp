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
<body class="admin-dashboard">
    <!-- Sidebar -->
    <jsp:include page="/includes/sidebar.jsp" />
    <h1 id="pageTitleDesktop" class="h5 d-none d-md-block mb-0">Crear Usuario</h1>
    <h1 id="pageTitleMobile" class="h6 d-md-none mb-0">Crear Usuario</h1>
    <jsp:include page="/includes/header.jsp" />
   
    <!-- Main Content -->
    <main class="main-content">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/views/usuarios.jsp">
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
                                <div class="col-md-3 text-center mb-4">
                                    <div class="foto-perfil-container">
                                        <img id="previewFoto" src="/placeholder.svg?height=150&width=150" 
                                             alt="Foto de perfil" class="foto-perfil">
                                        <div class="foto-overlay">
                                            <i class="fas fa-camera"></i>
                                            <span>Cambiar foto</span>
                                        </div>
                                        <input type="file" id="inputFoto" name="foto_perfil" accept="image/*" style="display: none;">
                                    </div>
                                    <small class="text-muted">Máximo 2MB - JPG, PNG</small>
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
                                                <input class="form-check-input" type="checkbox" value="${rol.id_rol}" 
                                                       id="rol${rol.id_rol}" name="roles" onchange="manejarCambioRol(this)">
                                                <label class="form-check-label" for="rol${rol.id_rol}">
                                                    <div class="role-card-small">
                                                        <div class="role-icon-small bg-primary">
                                                            <i class="fas fa-${rol.icono}"></i>
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
                                    <div class="invalid-feedback">
                                        Seleccione al menos un rol.
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Información Específica por Rol -->
                    <div id="infoEspecifica" style="display: none;">
                        <!-- Información de Estudiante -->
                        <div class="card mb-4" id="infoAlumno" style="display: none;">
                            <div class="card-header">
                                <h5 class="mb-0">
                                    <i class="fas fa-graduation-cap me-2"></i>
                                    Información del Estudiante
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <label for="anioLectivo" class="form-label">Año Lectivo</label>
                                        <select class="form-select" id="anioLectivo" name="id_anio_lectivo">
                                            <option value="">Seleccionar año</option>
                                            <c:forEach items="${aniosLectivos}" var="anio">
                                                <option value="${anio.id_anio_lectivo}" ${anio.estado == 'activo' ? 'selected' : ''}>
                                                    ${anio.nombre}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label for="nivel" class="form-label">Nivel</label>
                                        <select class="form-select" id="nivel" name="id_nivel" onchange="cargarGrados()">
                                            <option value="">Seleccionar nivel</option>
                                            <c:forEach items="${niveles}" var="nivel">
                                                <option value="${nivel.id_nivel}">${nivel.nombre}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label for="grado" class="form-label">Grado</label>
                                        <select class="form-select" id="grado" name="id_grado" onchange="cargarSecciones()">
                                            <option value="">Seleccionar grado</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <label for="seccion" class="form-label">Sección</label>
                                        <select class="form-select" id="seccion" name="id_seccion">
                                            <option value="">Seleccionar sección</option>
                                        </select>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label for="codigoMatricula" class="form-label">Código de Matrícula</label>
                                        <input type="text" class="form-control" id="codigoMatricula" name="codigo_matricula">
                                        <div class="form-text">Se generará automáticamente si se deja vacío</div>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label for="estadoMatricula" class="form-label">Estado de Matrícula</label>
                                        <select class="form-select" id="estadoMatricula" name="estado_matricula">
                                            <option value="regular">Regular</option>
                                            <option value="condicional">Condicional</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Información de Apoderado -->
                        <div class="card mb-4" id="infoApoderado" style="display: none;">
                            <div class="card-header">
                                <h5 class="mb-0">
                                    <i class="fas fa-users me-2"></i>
                                    Información del Apoderado
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="alumnoAsignado" class="form-label">Estudiante a cargo</label>
                                        <select class="form-select" id="alumnoAsignado" name="id_alumno">
                                            <option value="">Seleccionar estudiante</option>
                                            <c:forEach items="${estudiantesDisponibles}" var="estudiante">
                                                <option value="${estudiante.id_alumno}">
                                                    ${estudiante.nombres} ${estudiante.apellidos} - ${estudiante.codigo_matricula}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="parentesco" class="form-label">Parentesco</label>
                                        <select class="form-select" id="parentesco" name="parentesco">
                                            <option value="">Seleccionar parentesco</option>
                                            <option value="padre">Padre</option>
                                            <option value="madre">Madre</option>
                                            <option value="tutor">Tutor</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Botones de Acción -->
                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex justify-content-between">
                                <a href="${pageContext.request.contextPath}/views/usuarios.jsp" 
                                   class="btn btn-secondary">
                                    <i class="fas fa-arrow-left me-1"></i>
                                    Cancelar
                                </a>
                                <div>
                                    <button type="button" class="btn btn-outline-primary me-2" onclick="limpiarFormulario()">
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
