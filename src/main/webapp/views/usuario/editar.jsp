<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<form id="formEditarUsuario" enctype="multipart/form-data" method="post" action="${pageContext.request.contextPath}/usuarios">
    <input type="hidden" name="action" value="guardar" />
    <input type="hidden" name="id" value="${usuario.idUsuario}" />

    <div class="row g-3">
        <!-- Foto -->
        <div class="col-12 text-center">
            <c:set var="foto" value="${empty usuario.fotoPerfil ? 'default.png' : usuario.fotoPerfil}" />
            <img src="${pageContext.request.contextPath}/uploads/${foto}" 
                 alt="Foto de perfil" class="rounded-circle shadow-sm" width="100" height="100" />

            <div class="mt-2">
                <label class="form-label">Actualizar foto</label>
                <input type="file" class="form-control" name="fotoPerfil" accept="image/*">
                <!-- Foto actual oculta -->
                <input type="hidden" name="fotoActual" value="${foto}" />
            </div>
        </div>

        <!-- Datos personales -->
        <div class="col-md-6">
            <label class="form-label">DNI</label>
            <input type="text" name="dni" class="form-control" value="${usuario.dni}" maxlength="8" pattern="[0-9]{8}" inputmode="numeric" title="Ingrese un DNI de 8 dígitos numéricos" required>
        </div>
        <div class="col-md-6">
            <label class="form-label">Teléfono</label>
            <input type="tel" class="form-control" name="telefono" value="${usuario.telefono}" pattern="[0-9]{9}" title="9 dígitos">
        </div>
        <div class="col-md-6">
            <label class="form-label">Nombres</label>
            <input type="text" class="form-control" name="nombres" value="${usuario.nombres}" required>
        </div>
        <div class="col-md-6">
            <label class="form-label">Apellidos</label>
            <input type="text" class="form-control" name="apellidos" value="${usuario.apellidos}" required>
        </div>
        <div class="col-md-12">
            <label class="form-label">Correo electrónico</label>
            <input type="email" class="form-control" name="correo" value="${usuario.correo}" required>
        </div>
        <div class="col-md-6">
            <label class="form-label">Estado</label>
            <select class="form-select" name="estado" required>
                <option value="1" ${usuario.estado ? 'selected' : ''}>Activo</option>
                <option value="0" ${!usuario.estado ? 'selected' : ''}>Inactivo</option>
            </select>
        </div>

        <!-- Roles -->
        <div class="col-md-12">
            <label class="form-label">Roles asignados</label>
            <div class="d-flex flex-wrap gap-2">
                <c:forEach var="rol" items="${rolesDisponibles}">
                    <div class="form-check me-3">
                        <input class="form-check-input" type="checkbox" name="roles" value="${rol.idRol}"
                               <c:if test="${fn:contains(usuario.rolesAsIds, rol.idRol)}">checked</c:if>>
                        <label class="form-check-label">${rol.nombre}</label>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Sección extendida: ALUMNO -->
        <c:if test="${usuario.esAlumno}">
            <hr />
            <div class="col-md-4">
                <label class="form-label">Código Matrícula</label>
                <input type="text" class="form-control" value="${usuario.alumno.codigoMatricula}" readonly>
            </div>
            <div class="col-md-4">
                <label class="form-label">Grado</label>
                <input type="text" class="form-control" value="${usuario.alumno.grado}" readonly>
            </div>
            <div class="col-md-4">
                <label class="form-label">Sección</label>
                <input type="text" class="form-control" value="${usuario.alumno.seccion}" readonly>
            </div>
            <div class="col-md-4">
                <label class="form-label">Nivel</label>
                <input type="text" class="form-control" value="${usuario.alumno.nivel}" readonly>
            </div>
            <div class="col-md-4">
                <label class="form-label">Año lectivo</label>
                <input type="text" class="form-control" value="${usuario.alumno.anio}" readonly>
            </div>
            <div class="col-md-8">
                <label class="form-label">Apoderado</label>
                <input type="text" class="form-control" value="${usuario.alumno.nombreApoderado} (${usuario.alumno.parentescoApoderado})" readonly>
            </div>
        </c:if>

        <!-- Sección extendida: APODERADO -->
        <c:if test="${usuario.esApoderado}">
            <hr />
            <div class="col-md-12">
                <label class="form-label">Alumnos a cargo</label>
                <div class="form-control" style="height: auto;">
                    <c:forEach var="hijo" items="${usuario.apoderado.hijos}">
                        ${hijo.nombres} ${hijo.apellidos} - ${hijo.nivel} - ${hijo.grado} "${hijo.seccion}" |
                        Matrícula: ${hijo.codigoMatricula} | Año: ${hijo.anio} |
                        Parentesco: ${hijo.parentescoApoderado}<br />
                    </c:forEach>
                </div>
            </div>
        </c:if>
    </div>
</form>
