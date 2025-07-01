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
        .foto-perfil-container {
            position: relative;
            width: 140px;
            height: 140px;
            margin: 0 auto 1rem auto;
            cursor: pointer;
            border-radius: 50%;
            overflow: hidden;
            background: #f3f3f3;
            border: none;
        }
        .foto-perfil {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 50%;
            display: block;
        }
        .foto-overlay-full {
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            width: 100%; height: 100%;
            background: rgba(35, 36, 98, 0.85);
            color: #fff;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            opacity: 0;
            pointer-events: none;
            font-size: 1.1rem;
            transition: opacity 0.2s;
            border-radius: 50%;
            text-align: center;
        }
        .foto-perfil-container:hover .foto-overlay-full,
        .foto-perfil-container:focus .foto-overlay-full {
            opacity: 1;
            pointer-events: all;
        }
        .foto-overlay-full i {
            font-size: 2.2rem;
            margin-bottom: 6px;
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
                <!-- Perfil de usuario card -->
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
                                <img id="previewFoto" 
                                    src="${pageContext.request.contextPath}/uploads/default.png?height=150&width=150" 
                                            alt="Foto de perfil" class="foto-perfil">
                                <!--
                                <img id="fotoHeaderPreview"
                                    src="${pageContext.request.contextPath}/uploads/default.png"
                                    alt="Avatar"
                                    style="width:100%;height:100%;object-fit:cover;opacity:.7;">-->
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
                                    <!-- Foto de perfil uniforme -->
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
                                            <div class="foto-overlay-full">
                                                <i class="fas fa-camera"></i>
                                                <span>Cambiar foto</span>
                                            </div>
                                            <input type="file" id="inputFoto" name="foto_perfil" accept="image/jpeg, image/png" style="display: none;">
                                        </div>
                                        <small class="text-muted d-block mt-2">Máximo 300 KB - JPG, PNG</small>
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
                                               value="${sessionScope.usuario.correo}" required pattern="^[^<>]+$" maxlength="80"
                                               autocomplete="off" oninput="this.value = this.value.replace(/[<>\s]/g,'')">
                                    </div>
                                    <div class="mb-3">
                                        <label for="telefono" class="form-label">Teléfono</label>
                                        <input type="text" class="form-control" id="telefono" name="telefono"
                                               value="${sessionScope.usuario.telefono}" maxlength="9" pattern="[0-9]{9}"
                                               autocomplete="off" oninput="this.value = this.value.replace(/[^0-9]/g,'')">
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
                                <form id="formCambioPassword" autocomplete="off" method="post" action="${pageContext.request.contextPath}/perfil">
                                    <input type="hidden" name="action" value="cambiarPassword">
                                    <div class="mb-3">
                                        <label for="passwordActual" class="form-label">Contraseña Actual</label>
                                        <input type="password" class="form-control" id="passwordActual" name="passwordActual"
                                               required pattern="^[^<>]+$" minlength="8" maxlength="50"
                                               oninput="this.value = this.value.replace(/[<>\s]/g,'')" autocomplete="off">
                                    </div>
                                    <div class="mb-3">
                                        <label for="passwordNueva" class="form-label">Nueva Contraseña</label>
                                        <input type="password" class="form-control" id="passwordNueva" name="passwordNueva"
                                               required pattern="^[^<>]+$" minlength="6" maxlength="50"
                                               oninput="this.value = this.value.replace(/[<>\s]/g,'')" autocomplete="off">
                                        <div class="form-text">La contraseña debe tener al menos 8 caracteres.</div>
                                    </div>
                                    <div class="mb-3">
                                        <label for="passwordConfirmar" class="form-label">Confirmar Contraseña</label>
                                        <input type="password" class="form-control" id="passwordConfirmar" name="passwordConfirmar"
                                               required pattern="^[^<>]+$" minlength="8" maxlength="50"
                                               oninput="this.value = this.value.replace(/[<>\s]/g,'')" autocomplete="off">
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
            if (file.size > 300 * 1024) {
                Swal.fire('Archivo muy grande', 'La foto debe pesar máximo 300 KB.', 'warning');
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

    // Cambio de contraseña: validación y envío con SweetAlert (AJAX opcional, aquí solo frontend)
    document.getElementById('formCambioPassword').addEventListener('submit', function(e) {
        const passActual = document.getElementById('passwordActual').value.trim();
        const passNueva = document.getElementById('passwordNueva').value.trim();
        const passConfirmar = document.getElementById('passwordConfirmar').value.trim();

        if (passNueva.length < 8) {
            Swal.fire('Error', 'La nueva contraseña debe tener al menos 8 caracteres.', 'error');
            e.preventDefault();
            return;
        }
        if (passNueva !== passConfirmar) {
            Swal.fire('Error', 'Las contraseñas no coinciden.', 'error');
            e.preventDefault();
            return;
        }
        // Aquí puedes mostrar "Procesando..." o dejar que el backend gestione el mensaje
    });

    // Actualización de datos personales: feedback con SweetAlert (puedes hacerlo por AJAX si quieres)
    document.getElementById('formInfoPersonal').addEventListener('submit', function(e) {
        const correo = document.getElementById('correo').value;
        if (!/^[^<>]+$/.test(correo)) {
            Swal.fire('Correo inválido', 'El correo no puede contener caracteres especiales como < o >', 'error');
            e.preventDefault();
            return;
        }
        const telefono = document.getElementById('telefono').value;
        if (telefono && !/^[0-9]{9}$/.test(telefono)) {
            Swal.fire('Teléfono inválido', 'El número de teléfono debe tener 9 dígitos numéricos.', 'error');
            e.preventDefault();
            return;
        }
        // Puedes agregar aquí feedback visual después del submit si lo manejas por AJAX
    });
</script>
</body>
</html>
