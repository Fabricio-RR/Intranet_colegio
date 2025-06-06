<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- DataTables CSS -->
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet">


<div class="container-fluid">
    <!-- FOTO -->
    <div class="text-center mb-4">
        <img src="${pageContext.request.contextPath}/uploads/${usuario.fotoPerfil}" alt="Foto de perfil"
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

    <!-- DATOS DE ESTUDIANTE -->
    <c:if test="${usuario.esAlumno}">
        <hr />
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
            <div class="col-md-8">${usuario.apoderado.parentesco}</div>
        </div>
        <div class="row mb-2">
            <div class="col-md-4 fw-bold">Alumno a cargo:</div>
            <div class="col-md-8">${usuario.apoderado.nombreAlumno}</div>
        </div>
    </c:if>

    <!-- DATOS DE DOCENTE -->
    <c:if test="${usuario.esDocente}">
        <hr />
        <div class="mb-2 fw-bold">Cursos Asignados:</div>
        <ul>
            <c:forEach var="curso" items="${usuario.docente.cursos}">
                <li>${curso.nombre} - ${curso.nivel} ${curso.grado} "${curso.seccion}"</li>
            </c:forEach>
        </ul>
    </c:if>
</div>
