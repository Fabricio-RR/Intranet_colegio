<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <c:set var="paginaActiva" value="Mi Perfil" scope="request"/>
    <jsp:include page="/includes/meta.jsp" />
    <title>Mi Perfil - Colegio Peruano Chino Diez de Octubre</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/styles.css" rel="stylesheet">
    <style>
        .profile-header {
            background-color: #0A0A3D;
            color: white;
            border-radius: 1rem;
            margin-bottom: 2rem;
            box-shadow: 0 2px 12px rgba(10,10,61,0.10);
        }
        .profile-avatar {
            width: 120px;
            height: 120px;
            background-color: #fff;
            color: #0A0A3D;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.7rem;
            font-weight: bold;
            margin-right: 2rem;
            overflow: hidden;
            border: 3px solid #e5e7eb;
        }
        .profile-section-title {
            color: #0A0A3D;
            font-weight: bold;
            font-size: 1.2rem;
            margin-bottom: 1.5rem;
        }
        .badge-role {
            background: #0A0A3D;
            color: #fff;
            border-radius: 2rem;
            font-size: 0.9rem;
            padding: 0.4em 1em;
            margin-right: 0.3em;
        }
        .form-label {
            font-weight: 500;
        }
        .form-control:disabled, .form-control[readonly] {
            background-color: #f6f8fa;
        }
        /* --- Foto de perfil input moderno --- */
        .foto-perfil-container {
            position: relative;
            width: 140px;
            height: 140px;
            margin: 0 auto;
            cursor: pointer;
        }
        .foto-perfil {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 50%;
            border: 3px solid #e0e4ea;
            background: #fafbfc;
            display: block;
            transition: box-shadow 0.2s;
        }
        .foto-overlay {
            position: absolute;
            bottom: 0;
            left: 0; right: 0;
            height: 38%;
            background: rgba(10,10,61,0.73);
            color: #fff;
            border-radius: 0 0 50% 50%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            opacity: 0;
            pointer-events: none;
            transition: opacity 0.2s;
            font-size: 1rem;
        }
        .foto-perfil-container:hover .foto-overlay,
        .foto-perfil-container:focus .foto-overlay {
            opacity: 1;
            pointer-events: all;
        }
        .foto-overlay i {
            font-size: 1.3rem;
            margin-bottom: 3px;
        }
        @media (max-width: 767.98px) {
            .profile-header { flex-direction: column !important; text-align:center; }
            .profile-avatar { margin-right: 0; margin-bottom: 1rem; }
        }
    </style>
</head>
<body class="admin-dashboard" data-context-path="${pageContext.request.contextPath}">

<jsp:include page="/includes/sidebar.jsp" />
<c:set var="tituloPaginaDesktop" value="Mi perfil" scope="request" />
<c:set var="tituloPaginaMobile" value="Perfil" scope="request" />
<c:set var="iconoPagina" value="fas fa-user me-2" scope="request" />
<jsp:include page="/includes/header.jsp" />

<main class="main-content">
    <div class="container-fluid">
        <div class="row justify-content-center">
            <div class="col-12 col-lg-10 px-md-4">

                <div class="d-flex justify-content-between align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2 mb-0"><i class="fas fa-user-circle me-2"></i> Mi Perfil</h1>
                </div>

                <!-- Perfil de usuario arriba -->
                <div class="profile-header d-flex flex-column flex-md-row align-items-center p-4">
                    <div class="profile-avatar me-md-4 mb-3 mb-md-0">
                        <c:choose>
                            <c:when test="${not empty sessionScope.usuario.fotoPerfil}">
                                <img id="fotoHeaderPreview"
                                    src="${pageContext.request.contextPath}/uploads/fotos/${sessionScope.usuario.fotoPerfil}"
                                    alt="Foto de perfil"
                                    style="width:100%;height:100%;object-fit:cover;">
                            </c:when>
                            <c:otherwise>
                                <img id="fotoHeaderPreview"
                                    src="${pageContext.request.contextPath}/uploads/default.png"
                                    alt="Avatar"
                                    style="width:80px;height:80px;object-fit:cover;opacity:.7;">
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="profile-info">
                        <h3 class="mb-1">${sessionScope.usuario.nombres} ${sessionScope.usuario.apellidos}</h3>
                        <div class="mb-2">
                            <span class="me-2"><i class="fas fa-address-card me-1"></i>DNI:</span> <strong>${sessionScope.usuario.dni}</strong>
                        </div>
                        <div class="mb-2">
                            <span class="me-2"><i class="fas fa-envelope me-1"></i></span>${sessionScope.usuario.correo}
                        </div>
                        <div>
                            <span class="me-2"><i class="fas fa-phone me-1"></i></span>
                            <c:choose>
                                <c:when test="${not empty sessionScope.usuario.telefono}">
                                    ${sessionScope.usuario.telefono}
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted">Sin registrar</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="mt-3">
                            <c:forEach var="rol" items="${sessionScope.usuario.roles}">
                                <span class="badge badge-role"><i class="fas fa-user-tag me-1"></i>${rol.nombre}</span>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <div class="row g-4">
                    <!-- Información personal con foto editable -->
                    <div class="col-md-6">
                        <div class="card border-0 shadow-sm profile-section">
                            <div class="card-body">
                                <div class="profile-section-title">Información Personal</div>
                                <form id="formInfoPersonal" autocomplete="off" method="post" action="${pageContext.request.contextPath}/perfil" enctype="multipart/form-data">
                                    <input type="hidden" name="action" value="actualizarInfo">
                                    <!-- Foto de perfil moderna -->
                                    <div class="mb-3 text-center">
                                        <label for="inputFoto" class="form-label fw-semibold mb-2">Foto de perfil</label>
                                        <div class="foto-perfil-container" tabindex="0" onclick="document.getElementById('inputFoto').click();">
                                            <img id="previewFoto"
                                                src="<c:choose>
                                                        <c:when test='${not empty sessionScope.usuario.fotoPerfil}'>
                                                            ${pageContext.request.contextPath}/uploads/fotos/${sessionScope.usuario.fotoPerfil}
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${pageContext.request.contextPath}/uploads/default.png
                                                        </c:otherwise>
                                                    </c:choose>"
                                                alt="Foto de perfil" class="foto-perfil">
                                            <div class="foto-overlay">
                                                <i class="fas fa-camera"></i>
                                                <span>Cambiar foto</span>
                                            </div>
                                            <input type="file" id="inputFoto" name="foto_perfil" accept="image/jpeg, image/png" style="display: none;">
                                        </div>
                                        <small class="text-muted d-block mt-2">Máximo 2MB - JPG, PNG</small>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Nombres</label>
                                        <input type="text" class="form-control" value="${sessionScope.usuario.nombres}" readonly>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Apellidos</label>
                                        <input type="text" class="form-control" value="${sessionScope.usuario.apellidos}" readonly>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">DNI</label>
                                        <input type="text" class="form-control" value="${sessionScope.usuario.dni}" readonly>
                                    </div>
                                    <div class="mb-3">
                                        <label for="correo" class="form-label">Correo electrónico</label>
                                        <input type="email" class="form-control" id="correo" name="correo"
                                               value="${sessionScope.usuario.correo}" required pattern="^[^<>]+$">
                                    </div>
                                    <div class="mb-3">
                                        <label for="telefono" class="form-label">Teléfono</label>
                                        <input type="text" class="form-control" id="telefono" name="telefono"
                                               value="${sessionScope.usuario.telefono}" maxlength="9" pattern="[0-9]{9}">
                                    </div>
                                    <button type="submit" class="btn btn-admin-primary btn-sm btn-uniform">
                                        <i class="fas fa-save me-2"></i>Actualizar Información
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                    <!-- Cambiar contraseña -->
                    <div class="col-md-6">
                        <div class="card border-0 shadow-sm profile-section">
                            <div class="card-body">
                                <div class="profile-section-title">Cambiar Contraseña</div>
                                <form id="formCambioPassword" autocomplete="off">
                                    <div class="mb-3">
                                        <label for="passwordActual" class="form-label">Contraseña Actual</label>
                                        <input type="password" class="form-control" id="passwordActual" required pattern="^[^<>]+$">
                                    </div>
                                    <div class="mb-3">
                                        <label for="passwordNueva" class="form-label">Nueva Contraseña</label>
                                        <input type="password" class="form-control" id="passwordNueva" required minlength="6" pattern="^[^<>]+$">
                                        <div class="form-text">La contraseña debe tener al menos 6 caracteres.</div>
                                    </div>
                                    <div class="mb-3">
                                        <label for="passwordConfirmar" class="form-label">Confirmar Contraseña</label>
                                        <input type="password" class="form-control" id="passwordConfirmar" required pattern="^[^<>]+$">
                                    </div>
                                    <button type="submit" class="btn btn-admin-primary btn-sm btn-uniform">
                                        <i class="fas fa-key me-2"></i>Cambiar Contraseña
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
        <jsp:include page="/includes/footer.jsp" />
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    // Vista previa de la foto de perfil
    document.getElementById('inputFoto').addEventListener('change', function(e) {
        const file = e.target.files[0];
        if (file) {
            if (!['image/jpeg', 'image/png'].includes(file.type)) {
                Swal.fire('Formato no permitido', 'Solo se permiten imágenes JPG o PNG.', 'warning');
                e.target.value = '';
                return;
            }
            if (file.size > 2 * 1024 * 1024) {
                Swal.fire('Archivo muy grande', 'La foto debe pesar máximo 2MB.', 'warning');
                e.target.value = '';
                return;
            }
            const reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById('previewFoto').src = e.target.result;
            };
            reader.readAsDataURL(file);
        }
    });

    // Cambiar contraseña
    document.getElementById('formCambioPassword').addEventListener('submit', function(e) {
        e.preventDefault();
        const passActual = document.getElementById('passwordActual').value;
        const passNueva = document.getElementById('passwordNueva').value;
        const passConfirmar = document.getElementById('passwordConfirmar').value;
        if (passNueva.length < 6) {
            Swal.fire('Error', 'La nueva contraseña debe tener al menos 6 caracteres.', 'error');
            return;
        }
        if (passNueva !== passConfirmar) {
            Swal.fire('Error', 'Las contraseñas no coinciden.', 'error');
            return;
        }
        Swal.fire('¡Contraseña actualizada!', 'Su contraseña ha sido cambiada con éxito.', 'success');
        document.getElementById('passwordActual').value = '';
        document.getElementById('passwordNueva').value = '';
        document.getElementById('passwordConfirmar').value = '';
    });
</script>
</body>
</html>
