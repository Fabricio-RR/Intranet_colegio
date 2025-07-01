<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <jsp:include page="/includes/meta.jsp" />
    <title>Crear Comunicado - Intranet Escolar</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/formularios.css" rel="stylesheet">
</head>
<body class="admin-dashboard" data-context-path="${pageContext.request.contextPath}">

<jsp:include page="/includes/sidebar.jsp" />
<c:set var="tituloPaginaDesktop" value="Crear Comunicado" scope="request" />
<c:set var="tituloPaginaMobile" value="Nuevo Comunicado" scope="request" />
<c:set var="iconoPagina" value="fas fa-bullhorn" scope="request" />
<jsp:include page="/includes/header.jsp" />

<main class="main-content">
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/comunicado">
                    <i class="fas fa-bullhorn"></i> Comunicados
                </a>
            </li>
            <li class="breadcrumb-item active">Crear Comunicado</li>
        </ol>
    </nav>

    <div class="row justify-content-center">
        <div class="col-lg-10">
            <form id="formCrearComunicado" method="post" action="${pageContext.request.contextPath}/comunicado" enctype="multipart/form-data" class="needs-validation" novalidate>
                <input type="hidden" name="action" value="guardar" />
                <input type="hidden" name="idAnioLectivo" value="${idAnioLectivo}" />

                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-file-alt me-2"></i>
                            Detalle del Comunicado
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Título</label>
                            <input type="text" name="titulo" class="form-control" required maxlength="200">
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Contenido</label>
                            <textarea name="contenido" class="form-control" rows="3" required></textarea>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Categoría</label>
                                <input type="text" name="categoria" class="form-control" value="General" readonly>
                            </div>

                            <div class="col-md-6 mb-3">
                                <label class="form-label">Destinatario</label>
                                <select name="destinatario" id="destinatario" class="form-select" required onchange="mostrarOpcionesDestinatario(this.value)">
                                    <option value="todos">Todos</option>
                                    <option value="docentes">Docentes</option>
                                    <option value="estudiantes">Estudiantes</option>
                                    <option value="padres">Padres</option>
                                    <option value="seccion">Sección específica</option>
                                </select>
                            </div>
                        </div>

                        <div class="row" id="grupoSeccion" style="display: none;">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Sección</label>
                                <select name="idAperturaSeccion" class="form-select" id="selectSeccion">
                                    <option value="">-- Seleccione --</option>
                                    <c:forEach items="${seccionesActivas}" var="sec">
                                        <option value="${sec.idAperturaSeccion}">
                                            ${sec.nivel} ${sec.grado} "${sec.seccion}"
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-md-6 mb-3" id="grupoDestinatarioSeccion" style="display: none;">
                                <label class="form-label">Dirigido a</label>
                                <select name="destinatario_seccion" class="form-select" id="selectDestinatarioSeccion">
                                    <option value="">-- Seleccione --</option>
                                    <option value="Padres">Apoderados</option>
                                    <option value="Estudiantes">Alumnos</option>
                                    <option value="ambos">Apoderado y Alumno</option>
                                </select>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold">Fecha de inicio</label>
                                <input type="date" name="fec_inicio" class="form-control" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-semibold">Fecha de fin</label>
                                <input type="date" name="fec_fin" class="form-control" required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Notificar por correo</label><br>
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" name="notificar_correo" value="1">
                                <label class="form-check-label">Enviar notificación</label>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Archivo adjunto (PDF, JPG, PNG – máx. 5MB)</label>
                            <input type="file" name="archivo" id="archivo" class="form-control" accept=".pdf,.jpg,.jpeg,.png">
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-body d-flex justify-content-between">
                        <a href="${pageContext.request.contextPath}/comunicado?idAnioLectivo=${idAnioLectivo}" class="btn btn-outline-danger btn-sm btn-uniform">
                            <i class="fas fa-arrow-left me-1"></i> Cancelar
                        </a>
                        <button type="submit" class="btn btn-admin-primary">
                            <i class="fas fa-save me-1"></i> Guardar Comunicado
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <jsp:include page="/includes/footer.jsp" />
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
<script>
    function mostrarOpcionesDestinatario(valor) {
        const seccionBox = document.getElementById('grupoSeccion');
        const destinatarioSeccionBox = document.getElementById('grupoDestinatarioSeccion');
        const selectSeccion = document.getElementById('selectSeccion');
        const selectDestinatarioSeccion = document.getElementById('selectDestinatarioSeccion');

        if (valor === 'seccion') {
            seccionBox.style.display = 'flex';
            destinatarioSeccionBox.style.display = 'block';
            selectSeccion.setAttribute('required', 'required');
            selectDestinatarioSeccion.setAttribute('required', 'required');
        } else {
            seccionBox.style.display = 'none';
            destinatarioSeccionBox.style.display = 'none';
            selectSeccion.removeAttribute('required');
            selectDestinatarioSeccion.removeAttribute('required');
        }
    }

    document.addEventListener("DOMContentLoaded", () => {
        const valor = document.getElementById("destinatario").value;
        mostrarOpcionesDestinatario(valor);
    });

    document.addEventListener("DOMContentLoaded", () => {
        const form = document.getElementById("formCrearComunicado");
        const archivoInput = document.getElementById("archivo");
        const btnSubmit = form.querySelector("button[type='submit']");

        form.addEventListener("submit", (e) => {
            const titulo = form.titulo.value.trim();
            const contenido = form.contenido.value.trim();
            const fecInicio = new Date(form.fec_inicio.value);
            const fecFin = new Date(form.fec_fin.value);

            if (!titulo || !contenido || !form.fec_inicio.value || !form.fec_fin.value) {
                e.preventDefault();
                Swal.fire({
                    icon: "warning",
                    title: "Campos obligatorios",
                    text: "Por favor complete todos los campos marcados como obligatorios."
                });
                return;
            }

            if (fecInicio > fecFin) {
                e.preventDefault();
                Swal.fire({
                    icon: 'warning',
                    title: 'Fechas inválidas',
                    text: 'La fecha de inicio no puede ser posterior a la fecha de fin.'
                });
                return;
            }

            const archivo = archivoInput.files[0];
            if (archivo) {
                const extensionesPermitidas = ['pdf', 'jpg', 'jpeg', 'png'];
                const extension = archivo.name.split('.').pop().toLowerCase();
                const maxSizeMB = 5;

                if (!extensionesPermitidas.includes(extension)) {
                    e.preventDefault();
                    Swal.fire({
                        icon: 'error',
                        title: 'Archivo no permitido',
                        text: 'Solo se permiten archivos PDF, JPG o PNG.'
                    });
                    return;
                }

                if (archivo.size > maxSizeMB * 1024 * 1024) {
                    e.preventDefault();
                    Swal.fire({
                        icon: 'error',
                        title: 'Archivo demasiado grande',
                        text: 'El archivo no debe superar los 5MB.'
                    });
                    return;
                }
            }

            btnSubmit.disabled = true;
            btnSubmit.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i> Enviando...';
        });
    });

    <c:if test="${not empty errorMsg}">
        Swal.fire({
            icon: "error",
            title: "Error al crear el comunicado",
            text: "${fn:escapeXml(errorMsg)}",
            confirmButtonColor: "#d33"
        });
    </c:if>
</script>
</body>
</html>
