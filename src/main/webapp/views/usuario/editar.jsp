<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<form id="formEditarUsuario" enctype="multipart/form-data">
    <input type="hidden" name="action" value="guardar" />
    <input type="hidden" name="id" value="${usuario.idUsuario}" />

    <div class="row g-3">
        <!-- Foto -->
        <div class="col-12 text-center">
            <img src="${pageContext.request.contextPath}/uploads/${usuario.fotoPerfil}" 
                 alt="Foto actual" class="rounded-circle shadow-sm" width="100" height="100" />
            <div class="mt-2">
                <label class="form-label">Actualizar foto</label>
                <input type="file" class="form-control" name="fotoPerfil" accept="image/*">
            </div>
        </div>

        <!-- Datos personales -->
        <div class="col-md-6">
            <label class="form-label">DNI</label>
            <input type="text" class="form-control" name="dni" value="${usuario.dni}" required pattern="\\d{8}" title="8 dígitos">
        </div>
        <div class="col-md-6">
            <label class="form-label">Teléfono</label>
            <input type="tel" class="form-control" name="telefono" value="${usuario.telefono}" pattern="\\d{9}" title="9 dígitos">
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
                        <input class="form-check-input" type="checkbox" name="roles" value="${rol.id_rol}"
                               <c:if test="${fn:contains(usuario.rolesAsIds, rol.id_rol)}">checked</c:if>>
                        <label class="form-check-label">${rol.nombre}</label>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Sección extendida solo visible (solo lectura) -->
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
        </c:if>

        <c:if test="${usuario.esApoderado}">
            <hr />
            <div class="col-md-6">
                <label class="form-label">Alumno a cargo</label>
                <input type="text" class="form-control" value="${usuario.apoderado.nombreAlumno}" readonly>
            </div>
            <div class="col-md-6">
                <label class="form-label">Parentesco</label>
                <input type="text" class="form-control" value="${usuario.apoderado.parentesco}" readonly>
            </div>
        </c:if>
    </div>
</form>
