<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <jsp:include page="/includes/meta.jsp" />
    <title>Crear Matrícula - Intranet Escolar</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/formularios.css" rel="stylesheet">
    <style>
    /* === Autocomplete mejoras === */
    .autocomplete-suggestions {
        position: absolute;
        z-index: 99;
        background: #fff;
        border: 1px solid #d5d5d5;
        border-radius: 8px;
        max-height: 200px;
        overflow-y: auto;
        width: 100%;
        box-shadow: 0 2px 8px rgba(0,0,0,.05);
        margin-top: 2px;
    }
    .autocomplete-item {
        padding: 0.5rem 1rem;
        cursor: pointer;
        transition: background .2s;
    }
    .autocomplete-item:hover, .autocomplete-item.active {
        background: #f1f3f4;
    }
    body[data-bs-theme="dark"] .autocomplete-suggestions {
        background: #212529;
        color: #f8f9fa;
        border-color: #444;
    }
    body[data-bs-theme="dark"] .autocomplete-item:hover,
    body[data-bs-theme="dark"] .autocomplete-item.active {
        background: #343a40;
    }
    /* Loader para secciones */
    #loaderSecciones { display: none; }
    </style>
</head>
<body class="admin-dashboard" data-context-path="${pageContext.request.contextPath}">

    <!-- Sidebar -->
    <jsp:include page="/includes/sidebar.jsp" />
    <c:set var="tituloPaginaDesktop" value="Crear Nueva Matrícula" scope="request" />
    <c:set var="tituloPaginaMobile" value="Nueva Matrícula" scope="request" />
    <c:set var="iconoPagina" value="fas fa-user-plus" scope="request" />
    <jsp:include page="/includes/header.jsp" />

    <!-- Main Content -->
    <main class="main-content">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/matricula">
                        <i class="fas fa-list"></i> Matrículas
                    </a>
                </li>
                <li class="breadcrumb-item active">Crear Matrícula</li>
            </ol>
        </nav>

        <div class="row justify-content-center">
            <div class="col-lg-10">
                <c:if test="${not empty sessionScope.msgErrorMatricula}">
                    <div class="alert alert-danger d-flex align-items-center" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <span>${sessionScope.msgErrorMatricula}</span>
                    </div>
                    <c:remove var="msgErrorMatricula" scope="session"/>
                </c:if>

                <form id="formCrearMatricula" class="needs-validation" novalidate method="post" action="${pageContext.request.contextPath}/matricula">
                   <input type="hidden" name="action" value="crearGuardar" />
                    <!-- Bitácora visual -->
                    <br>
                    <!-- Alerta matrícula duplicada (mostrar por JS si detectas) -->
                    <div id="alertaMatriculaRepetida" class="alert alert-warning d-none mt-2">
                        <i class="fas fa-exclamation-triangle"></i>
                        Este alumno ya está matriculado en este año/sección.
                    </div>
                    <div class="card mb-4">
                        <div class="card-header">
                            <h5 class="mb-0">
                                <i class="fas fa-user-plus me-2"></i> Información de Matrícula
                            </h5>
                        </div>
                        <div class="card-body">
                            <!-- SECCION ALUMNO Y APODERADO -->
                            <div class="row">
                                <!-- Alumno con autocomplete -->
                                <div class="col-md-6 col-12 mb-3 position-relative">
                                    <label for="dniAlumno" class="form-label">Alumno <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="dniAlumno" name="dniAlumno" autocomplete="off" required placeholder="Buscar por DNI o nombres">
                                    <input type="hidden" id="idAlumno" name="idAlumno">
                                    <div id="sugerenciasAlumno" class="autocomplete-suggestions"></div>
                                    <div class="form-text text-muted">Debe seleccionar de la lista.</div>
                                    <div class="invalid-feedback">Seleccione un alumno.</div>
                                </div>
                                <!-- Apoderado con autocomplete -->
                                <div class="col-md-6 col-12 mb-3 position-relative">
                                    <label for="dniApoderado" class="form-label">Apoderado <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="dniApoderado" name="dniApoderado" autocomplete="off" required placeholder="Buscar por DNI o nombres">
                                    <input type="hidden" id="idApoderado" name="idApoderado">
                                    <div id="sugerenciasApoderado" class="autocomplete-suggestions"></div>
                                    <small class="text-muted">¿No encuentra alumno o apoderado? 
                                        <a href="${pageContext.request.contextPath}/usuarios?action=nuevo" target="_blank">Registrar nuevo alumno o apoderado</a>
                                    </small>
                                    <div class="invalid-feedback">Seleccione un apoderado.</div>
                                </div>
                            </div>
                            <!-- Parentesco, Año, Sección, Estado -->
                            <div class="row">
                                <!-- Parentesco -->
                                <div class="col-md-4 col-12 mb-3">
                                    <label for="parentesco" class="form-label">Parentesco <span class="text-danger">*</span></label>
                                    <select id="parentesco" name="parentesco" class="form-select" required>
                                        <option value="" disabled selected>Seleccione</option>
                                        <option value="Padre">Padre</option>
                                        <option value="Madre">Madre</option>
                                        <option value="Tutor">Tutor</option>
                                    </select>
                                    <div class="invalid-feedback">Seleccione el parentesco.</div>
                                </div>
                                <!-- Año lectivo -->
                                <div class="col-md-4 col-12 mb-3">
                                    <label for="anioLectivo" class="form-label">Año lectivo <span class="text-danger">*</span></label>
                                    <select id="anioLectivo" name="anioLectivo" class="form-select" required>
                                        <option value="" disabled>Seleccione año</option>
                                        <c:forEach var="anio" items="${aniosLectivos}">
                                            <option value="${anio.idAnioLectivo}" 
                                                ${anio.idAnioLectivo == anioLectivoSeleccionado ? 'selected' : ''}>
                                                ${anio.nombre}
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <div class="invalid-feedback">Seleccione el año lectivo.</div>
                                </div>
                                <!-- Nivel / Grado / Sección -->
                                <div class="col-md-4 col-12 mb-3 position-relative">
                                    <label for="idAperturaSeccion" class="form-label">Nivel / Grado / Sección <span class="text-danger">*</span></label>
                                    <select id="idAperturaSeccion" name="idAperturaSeccion" class="form-select" required>
                                        <option value="" disabled selected>Seleccione sección</option>
                                        <c:forEach var="aps" items="${aperturasSeccion}">
                                            <option value="${aps.idAperturaSeccion}">
                                                ${aps.nivel} - ${aps.grado} "${aps.seccion}" (${aps.anioLectivo})
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <div id="loaderSecciones" class="spinner-border text-primary d-none" role="status" style="width:2rem;height:2rem;">
                                        <span class="visually-hidden">Cargando...</span>
                                    </div>
                                    <div class="invalid-feedback">Seleccione nivel, grado y sección.</div>
                                </div>
                                <!-- Estado -->
                                <div class="col-md-4 col-12 mb-3">
                                    <label for="estado" class="form-label">Estado <span class="text-danger">*</span></label>
                                    <select id="estado" name="estado" class="form-select" required>
                                        <option value="REGULAR" selected>Regular</option>
                                        <option value="CONDICIONAL">Condicional</option>
                                    </select>
                                    <br>
                                    <span id="badgeEstado" class="badge bg-success ms-2">Regular</span>
                                    <div class="invalid-feedback">Seleccione el estado.</div>
                                </div>
                                <!-- Observación (solo si Condicional) -->
                                <div class="col-md-12 mb-3" id="campoObservacion" style="display: none;">
                                    <label for="observacion" class="form-label">
                                        Observación <span class="text-danger">*</span>
                                    </label>
                                    <textarea class="form-control" id="observacion" name="observacion" rows="2"></textarea>
                                    <div class="form-text">Describa la razón de la matrícula condicional.</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Botones de Acción -->
                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex justify-content-between">
                                <a href="${pageContext.request.contextPath}/matricula" 
                                   class="btn btn-outline-danger btn-sm btn-uniform">
                                    <i class="fas fa-arrow-left me-1"></i>
                                    Cancelar
                                </a>
                                <div>
                                    <button type="reset" class="btn btn-outline-success btn-sm btn-uniform me-2">
                                        <i class="fas fa-eraser me-1"></i>
                                        Limpiar
                                    </button>
                                    <button type="submit" class="btn btn-admin-primary">
                                        <i class="fas fa-save me-1"></i>
                                        Crear Matrícula
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
        <jsp:include page="/includes/footer.jsp" />
    </main>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/matricula.js"></script>
    <script>
    // === Observación condicional ===
    document.getElementById('estado').addEventListener('change', function() {
        let obs = document.getElementById('campoObservacion');
        let badge = document.getElementById('badgeEstado');
        if (this.value === 'CONDICIONAL') {
            obs.style.display = 'block';
            document.getElementById('observacion').required = true;
            badge.textContent = 'Condicional';
            badge.className = 'badge bg-warning text-dark ms-2';
        } else {
            obs.style.display = 'none';
            document.getElementById('observacion').required = false;
            badge.textContent = 'Regular';
            badge.className = 'badge bg-success ms-2';
        }
    });

    // === Filtro visual de secciones por año ===
    function filtrarSeccionesPorAnio() {
        let selectAnio = document.getElementById('anioLectivo');
        let idAnio = selectAnio.value;
        let selectSeccion = document.getElementById('idAperturaSeccion');
        let loader = document.getElementById('loaderSecciones');
        // Mostrar loader (solo visual)
        loader.classList.remove('d-none');
        setTimeout(() => {
            // Simula carga AJAX; reemplaza esto con tu fetch real si usas AJAX
            for (let opt of selectSeccion.options) {
                if (!opt.value) continue; // Saltar placeholder
                opt.style.display = (opt.getAttribute('data-anio') === idAnio) ? 'block' : 'none';
            }
            selectSeccion.value = "";
            loader.classList.add('d-none');
        }, 400);
    }

    // === Confirmación previa antes de enviar ===
   document.addEventListener('DOMContentLoaded', function () {
    const form = document.getElementById('formCrearMatricula');
    if (form) {
        form.addEventListener('submit', function(event) {
            // Validación nativa de Bootstrap/HTML5
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
                Swal.fire({
                    icon: 'error',
                    title: 'Datos incompletos',
                    text: 'Por favor, complete todos los campos obligatorios antes de continuar.',
                    confirmButtonColor: '#110d59'
                });
                form.classList.add('was-validated');
                return false;
            }
            // Si pasa la validación, pregunta confirmación
            event.preventDefault();
            Swal.fire({
                title: '¿Desea confirmar la matrícula?',
                icon: 'question',
                showCancelButton: true,
                confirmButtonText: 'Sí, registrar',
                cancelButtonText: 'Cancelar',
                confirmButtonColor: '#110d59'
            }).then((result) => {
                if (result.isConfirmed) {
                    form.submit();
                }
            });
        });
    }
});

    </script>
</body>
</html>
