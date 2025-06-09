<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid">
    <!-- FOTO -->
    <div class="text-center mb-4">
    <c:set var="foto" value="${empty usuario.fotoPerfil ? 'default.png' : usuario.fotoPerfil}" />
    <img src="${pageContext.request.contextPath}/uploads/${foto}" alt="Foto de perfil"
         class="rounded-circle shadow-sm" width="120" height="120" />
    </div>

    <!-- DATOS BÁSICOS -->
    <div class="row mb-2">
        <div class="col-md-4 fw-bold">DNI:</div>
        <div class="col-md-8">${usuario.dni}</div>
    </div>
    <div class="row mb-2">
        <div class="col-md-4 fw-bold">Nombre completo:</div>
        <div class="col-md-8">${usuario.nombres} ${usuario.apellidos}</div>
    </div>
    <div class="row mb-2">
        <div class="col-md-4 fw-bold">Correo:</div>
        <div class="col-md-8">${usuario.correo}</div>
    </div>
    <div class="row mb-2">
        <div class="col-md-4 fw-bold">Teléfono:</div>
        <div class="col-md-8">${usuario.telefono}</div>
    </div>
    <div class="row mb-2">
        <div class="col-md-4 fw-bold">Estado:</div>
        <div class="col-md-8">
            <span class="badge ${usuario.estado ? 'bg-success' : 'bg-danger'}">
                ${usuario.estado ? 'Activo' : 'Inactivo'}
            </span>
        </div>
    </div>

    <!-- ROLES -->
    <div class="row mb-2">
        <div class="col-md-4 fw-bold">Roles:</div>
        <div class="col-md-8">
            <c:forEach var="rol" items="${usuario.roles}">
                <span class="badge bg-primary me-1">${rol.nombre}</span>
            </c:forEach>
        </div>
    </div>

    <!-- DATOS DE ALUMNO -->
    <c:if test="${usuario.esAlumno}">
        <hr />
        <div class="row mb-2">
            <div class="col-md-4 fw-bold">Apoderado:</div>
            <div class="col-md-8">${usuario.alumno.nombreApoderado} (${usuario.alumno.parentescoApoderado})</div>
        </div>
        <div class="row mb-2">
            <div class="col-md-4 fw-bold">Código de Matrícula:</div>
            <div class="col-md-8">${usuario.alumno.codigoMatricula}</div>
        </div>
        <div class="row mb-2">
            <div class="col-md-4 fw-bold">Nivel:</div>
            <div class="col-md-8">${usuario.alumno.nivel}</div>
        </div>
        <div class="row mb-2">
            <div class="col-md-4 fw-bold">Grado:</div>
            <div class="col-md-8">${usuario.alumno.grado}</div>
        </div>
        <div class="row mb-2">
            <div class="col-md-4 fw-bold">Sección:</div>
            <div class="col-md-8">${usuario.alumno.seccion}</div>
        </div>
        <div class="row mb-2">
            <div class="col-md-4 fw-bold">Año lectivo:</div>
            <div class="col-md-8">${usuario.alumno.anio}</div>
        </div>
    </c:if>

    <!-- DATOS DE APODERADO -->
    <c:if test="${usuario.esApoderado}">
        <hr />
        <div class="row mb-2">
            <div class="col-md-4 fw-bold">Parentesco:</div>
             <c:forEach var="hijo" items="${usuario.apoderado.hijos}">
            <div class="col-md-8">${hijo.parentescoApoderado}</div>
            </c:forEach>
        </div>
        <div class="row mb-2">
            <div class="col-md-4 fw-bold">Alumnos a cargo:</div>
            <div class="col-md-8">
                <c:forEach var="hijo" items="${usuario.apoderado.hijos}">
                    ${hijo.nombres} ${hijo.apellidos} - ${hijo.nivel} - ${hijo.grado} "${hijo.seccion}" |
                    Matrícula: ${hijo.codigoMatricula} | Año: ${hijo.anio}
                </c:forEach>
            </div>
        </div>
    </c:if>

    <!-- DATOS DE DOCENTE -->
    <c:if test="${usuario.esDocente}">
        <hr />
        <div class="row mb-2">
            <div class="col-md-4 fw-bold">Total de cursos asignados:</div>
            <div class="col-md-8">${usuario.docente.totalCursos}</div>
        </div>
    </c:if>
</div>
