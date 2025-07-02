<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <c:set var="paginaActiva" value="Asistencia" scope="request"/>
    <jsp:include page="/includes/meta.jsp" />
    <title>Registro Asistencia - Intranet Escolar</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/styles.css" rel="stylesheet">
    <style>
        .table-asistencia {
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px #e6e6e6;
        }
        .table-asistencia th {
            background: #f3f6fb;
            color: #1a2341;
            font-size: 1.08em;
            font-weight: 600;
            border-bottom: 2px solid #dee2e6 !important;
            text-align: center;
        }
        .table-asistencia td {
            vertical-align: middle !important;
            text-align: center;
            background: #fff;
            border-bottom: 1px solid #eee !important;
        }
        .table-asistencia tbody tr:hover {
            background: #f1f8ff !important;
            transition: background 0.18s;
        }
        .form-observacion {
            max-width: 200px;
            margin: auto;
        }
        .estado-radio {
            width: 1.25em;
            height: 1.25em;
            accent-color: #110D59;
            margin: 0;
            border: 2px solid #0845a3;
        }
        /* Visual feedback for selected radio in a row */
        .table-asistencia input[type="radio"]:checked {
            box-shadow: 0 0 4px #377dff;
            outline: 2px solid #377dff;
            outline-offset: 1px;
        }
        .text-institucional {
            color: #110D59;
        }
    </style>
</head>
<body class="admin-dashboard" data-context-path="${pageContext.request.contextPath}">
    <jsp:include page="/includes/sidebar.jsp" />
    <c:set var="tituloPaginaDesktop" value="Registro de Asitencia" scope="request" />
    <c:set var="tituloPaginaMobile" value="Asistencias" scope="request" />
    <c:set var="iconoPagina" value="fas fa-calendar-check me-2" scope="request" />
    <jsp:include page="/includes/header.jsp" />
    <main class="main-content">
            
                <div class="card shadow rounded-4 p-4">
                    <!-- Selectores de Nivel, Grado, Sección y Curso con Bootstrap Tooltip -->
                    <form id="formSeleccion" method="get" action="${pageContext.request.contextPath}/asistencia" class="mb-4">
                        <input type="hidden" name="action" value="tomar" />
                        <div class="row g-3 mb-2">
                            <div class="col-md-3">
                                <label class="fw-semibold mb-1" for="nivel">Nivel:</label>
                                <select id="nivel" name="id_nivel" class="form-select"
                                        required onchange="this.form.submit()"
                                        data-bs-toggle="tooltip" data-bs-placement="top">
                                    <option value="">Seleccione</option>
                                    <c:forEach var="nivel" items="${niveles}">
                                        <option value="${nivel.idNivel}" ${param.id_nivel == nivel.idNivel ? 'selected' : ''}>${nivel.nombre}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="fw-semibold mb-1" for="grado">Grado:</label>
                                <select id="grado" name="id_grado" class="form-select"
                                        required onchange="this.form.submit()"
                                        data-bs-toggle="tooltip" data-bs-placement="top">
                                    <option value="">Seleccione</option>
                                    <c:forEach var="grado" items="${grados}">
                                        <option value="${grado.idGrado}" ${param.id_grado == grado.idGrado ? 'selected' : ''}>${grado.nombre}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="fw-semibold mb-1" for="seccion">Sección:</label>
                                <select id="seccion" name="id_seccion" class="form-select"
                                        required onchange="this.form.submit()"
                                        data-bs-toggle="tooltip" data-bs-placement="top">
                                    <option value="">Seleccione</option>
                                    <c:forEach var="seccion" items="${secciones}">
                                        <option value="${seccion.idSeccion}" ${param.id_seccion == seccion.idSeccion ? 'selected' : ''}>${seccion.nombre}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="fw-semibold mb-1" for="curso">Curso:</label>
                                <select id="curso" name="id_curso" class="form-select"
                                        required onchange="this.form.submit()"
                                        data-bs-toggle="tooltip" data-bs-placement="top">
                                    <option value="">Seleccione</option>
                                    <c:forEach var="curso" items="${cursos}">
                                        <option value="${curso.idCurso}" ${param.id_curso == curso.idCurso ? 'selected' : ''}>${curso.nombre}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </form>

                    <!-- Formulario para marcar asistencia -->
                    <form id="formAsistencia" method="post" action="${pageContext.request.contextPath}/asistencia" autocomplete="off">
                        <input type="hidden" name="action" value="guardar" />
                        <input type="hidden" name="id_apertura_seccion" value="${aperturaSeccion.idAperturaSeccion}" />
                        <input type="hidden" name="id_curso" value="${cursoSeleccionado.idCurso}" />
                        <input type="hidden" name="id_anio_lectivo" value="${anioLectivo.idAnioLectivo}" />
                        <input type="hidden" name="fecha" value="<fmt:formatDate value='${fechaHoy}' pattern='yyyy-MM-dd'/>"/>
                        <div class="row g-3 align-items-end mb-3">
                            <div class="col-md-4">
                                <label class="fw-semibold mb-1" for="fechaAsistencia">
                                    <i class="fas fa-calendar-day me-1"></i> Fecha:
                                </label>
                                <input type="date" class="form-control"
                                    id="fechaAsistencia"
                                    value="<fmt:formatDate value='${fechaHoy}' pattern='yyyy-MM-dd'/>"
                                    readonly disabled>
                            </div>
                            <div class="col-md-3">
                                <button type="submit" class="btn btn-admin-primary px-4 w-100">
                                    <i class="fas fa-save me-1"></i> Guardar asistencia
                                </button>
                            </div>
                            <div class="col align-self-center">
                                <span id="msgConfirmacion" class="mensaje-confirmacion text-institucional fw-semibold ms-3">
                                    <i class="fas fa-envelope-circle-check me-1"></i>
                                    Se notificará por correo a los apoderados por Faltas/Tardanzas.
                                </span>
                            </div>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-asistencia table-bordered align-middle">
                                <thead class="sticky-header">
                                    <tr class="table-light">
                                        <th>#</th>
                                        <th>Alumno</th>
                                        <th class="text-center" data-bs-toggle="tooltip" data-bs-placement="top" title="Asistió">
                                            A
                                        </th>
                                        <th class="text-center" data-bs-toggle="tooltip" data-bs-placement="top" title="Tardanza">
                                            T
                                        </th>
                                        <th class="text-center" data-bs-toggle="tooltip" data-bs-placement="top" title="Falta">
                                            F
                                        </th>
                                        <th class="text-center" data-bs-toggle="tooltip" data-bs-placement="top" title="Tardanza Justificada">
                                            TJ
                                        </th>
                                        <th class="text-center" data-bs-toggle="tooltip" data-bs-placement="top" title="Falta Justificada">
                                            FJ
                                        </th>
                                        <th class="text-center">Observación</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="al" items="${alumnos}" varStatus="i">
                                    <tr>
                                        <td>${i.index + 1}</td>
                                        <td>${al.usuario.apellidos}, ${al.usuario.nombres}</td>
                                        <td class="text-center">
                                            <input type="radio" name="estado_${al.idAlumno}" value="A"
                                                class="form-check-input estado-radio"
                                                required title="Asistió">
                                        </td>
                                        <td class="text-center">
                                            <input type="radio" name="estado_${al.idAlumno}" value="T"
                                                class="form-check-input estado-radio"
                                                title="Tardanza">
                                        </td>
                                        <td class="text-center">
                                            <input type="radio" name="estado_${al.idAlumno}" value="F"
                                                class="form-check-input estado-radio"
                                                title="Falta">
                                        </td>
                                        <td class="text-center">
                                            <input type="radio" name="estado_${al.idAlumno}" value="TJ"
                                                class="form-check-input estado-radio"
                                                title="Tardanza Justificada">
                                        </td>
                                        <td class="text-center">
                                            <input type="radio" name="estado_${al.idAlumno}" value="FJ"
                                                class="form-check-input estado-radio"
                                                title="Falta Justificada">
                                        </td>
                                        <td>
                                            <input type="text" name="obs_${al.idAlumno}" maxlength="80"
                                                class="form-control form-observacion" placeholder="(opcional)">
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </form>
                </div>
        <jsp:include page="/includes/footer.jsp" />
    </main>

    <!-- Bootstrap Tooltip JS (debe ir después de cargar Bootstrap JS) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
    <script>
        // Activar Bootstrap tooltips
        document.addEventListener('DOMContentLoaded', function () {
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            tooltipTriggerList.forEach(function (tooltipTriggerEl) {
                new bootstrap.Tooltip(tooltipTriggerEl)
            });
        });

        // Confirmación SweetAlert2 antes de enviar el formulario
        document.getElementById('formAsistencia').addEventListener('submit', function(e) {
            e.preventDefault(); // Detiene el envío normal

            Swal.fire({
                title: '¿Está seguro de guardar la asistencia?',
                text: "Verifique que todos los estados estén marcados correctamente.",
                icon: 'question',
                showCancelButton: true,
                confirmButtonText: 'Sí, guardar',
                cancelButtonText: 'Cancelar',
                confirmButtonColor: '#110D59',
                cancelButtonColor: '#FF0000' ,
                reverseButtons: true
            }).then((result) => {
                if (result.isConfirmed) {
                    // Muestra mensaje de notificación (opcional)
                    document.getElementById('msgConfirmacion').style.display = 'inline';
                    // Envía el formulario realmente
                    e.target.submit();
                }
            });
        });
</script>
</body>
</html>
