<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <c:set var="paginaActiva" value="Comunicados" scope="request"/>
    <jsp:include page="/includes/meta.jsp" />
    <title>Comunicados - Intranet Escolar</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/styles.css" rel="stylesheet">
    <style>
        .table-comunicados th, .table-comunicados td { vertical-align: middle; }
        .table-comunicados th { background: #f3f6fb; }
        .badge-vigente { background: #198754; }
        .badge-expirado { background: #a7a7a7; color: #222; }
        .nav-tabs .nav-link.active { background: #110D59 !important; color: #fff !important; }
        .nav-tabs .nav-link { color: #110D59 !important; }
    </style>
</head>
<body>
<jsp:include page="/includes/sidebar.jsp" />
<c:set var="tituloPaginaDesktop" value="Comunicados" scope="request" />
<c:set var="tituloPaginaMobile" value="Comunicados" scope="request" />
<c:set var="iconoPagina" value="fas fa-bullhorn me-2" scope="request" />
<jsp:include page="/includes/header.jsp" />
<main class="main-content">
    <div class="card shadow rounded-4 p-4">
        <div class="alert alert-info py-1 mb-1" style="background:#eef4fa; color:#15467b; border:none;">
            <i class="fas fa-filter me-1"></i>
            <span class="fw-semibold">Filtros solo aplican para comunicados emitidos. Para comunicados recibidos, se muestra el listado completo.</span>
        </div>
        <div class="d-flex justify-content-between align-items-center mb-1">
            <!-- Filtros visuales modernos -->
            <form id="filtrosComunicados" method="get" action="${pageContext.request.contextPath}/comunicados" class="mb-4">
                <input type="hidden" name="action" value="emitidos" />
                <div class="row g-4">
                    <div class="col-md-3">
                        <label for="nivel" class="form-label fw-semibold">Nivel:</label>
                        <select id="nivel" name="id_nivel" class="form-select" onchange="this.form.submit()">
                            <option value="">Seleccione</option>
                            <c:forEach var="nivel" items="${niveles}">
                                <option value="${nivel.idNivel}" ${param.id_nivel == nivel.idNivel ? 'selected' : ''}>${nivel.nombre}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label for="grado" class="form-label fw-semibold">Grado:</label>
                        <select id="grado" name="id_grado" class="form-select" onchange="this.form.submit()">
                            <option value="">Seleccione</option>
                            <c:forEach var="grado" items="${grados}">
                                <option value="${grado.idGrado}" ${param.id_grado == grado.idGrado ? 'selected' : ''}>${grado.nombre}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label for="seccion" class="form-label fw-semibold">Sección:</label>
                        <select id="seccion" name="id_seccion" class="form-select" onchange="this.form.submit()">
                            <option value="">Seleccione</option>
                            <c:forEach var="seccion" items="${secciones}">
                                <option value="${seccion.idSeccion}" ${param.id_seccion == seccion.idSeccion ? 'selected' : ''}>${seccion.nombre}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label for="curso" class="form-label fw-semibold">Curso:</label>
                        <select id="curso" name="id_curso" class="form-select" onchange="this.form.submit()">
                            <option value="">Seleccione</option>
                            <c:forEach var="curso" items="${cursos}">
                                <option value="${curso.idCurso}" ${param.id_curso == curso.idCurso ? 'selected' : ''}>${curso.nombre}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
            </form>
            <button class="btn btn-admin-primary btn-sm" id="btnNuevoComunicado">
                <i class="fas fa-plus"></i> Nuevo Comunicado
            </button>
        </div>

        <!-- Tabs para Emitidos y Recibidos -->
        <ul class="nav nav-tabs mb-3" id="tabComunicados" role="tablist">
            <li class="nav-item">
                <button class="nav-link active" id="emitidos-tab" data-bs-toggle="tab" data-bs-target="#emitidos" type="button" role="tab">
                    Emitidos
                </button>
            </li>
            <li class="nav-item">
                <button class="nav-link" id="recibidos-tab" data-bs-toggle="tab" data-bs-target="#recibidos" type="button" role="tab">
                    Recibidos
                </button>
            </li>
        </ul>
        <div class="tab-content" id="tabComunicadosContent">
            <!-- TAB EMITIDOS -->
            <div class="tab-pane fade show active" id="emitidos" role="tabpanel">
                <div class="table-responsive">
                    <table class="table table-comunicados table-bordered align-middle">
                        <thead>
                        <tr>
                            <th>#</th>
                            <th>Título</th>
                            <th>Nivel / Grado / Sección</th>
                            <th>Curso</th>
                            <th>Destinatario</th>
                            <th>Estado</th>
                            <th>Acciones</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="com" items="${comunicadosEmitidos}" varStatus="i">
                            <tr>
                                <td>${i.index + 1}</td>
                                <td>${com.titulo}</td>
                                <td>${com.nivel} / ${com.grado} / ${com.seccion}</td>
                                <td>${com.curso}</td>
                                <td>${com.destinatario}</td>
                                <td>
                                    <span class="badge ${com.estado eq 'Vigente' ? 'badge-vigente' : 'badge-expirado'}">${com.estado}</span>
                                </td>
                                <td>
                                    <button class="btn btn-sm btn-outline-primary" title="Ver"
                                            data-bs-toggle="modal"
                                            data-bs-target="#modalVerComunicado"
                                            data-titulo="${com.titulo}"
                                            data-remitente="${com.remitente}"
                                            data-nivelgradoseccion="${com.nivel} / ${com.grado} / ${com.seccion}"
                                            data-curso="${com.curso}"
                                            data-destinatario="${com.destinatario}"
                                            data-estado="${com.estado}"
                                            data-fechainicio="${com.fecInicio}"
                                            data-fechafin="${com.fecFin}"
                                            data-contenido="${com.contenido}"
                                            data-archivo="${com.archivo}">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button class="btn btn-sm btn-outline-secondary" title="Editar"
                                            data-bs-toggle="modal"
                                            data-bs-target="#modalEditarComunicado"
                                            data-id="${com.idPublicacion}"
                                            data-nivelgradoseccion="${com.nivel} / ${com.grado} / ${com.seccion}"
                                            data-curso="${com.curso}"
                                            data-destinatario="${com.destinatario}"
                                            data-titulo="${com.titulo}"
                                            data-contenido="${com.contenido}"
                                            data-fecinicio="${com.fecInicio}"
                                            data-fecfin="${com.fecFin}"
                                            data-archivo="${com.archivo}"
                                            data-notificar="${com.notificarCorreo}">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty comunicadosEmitidos}">
                            <tr>
                                <td colspan="7" class="text-center text-muted">No se encontraron comunicados emitidos.</td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
            <!-- TAB RECIBIDOS -->
            <div class="tab-pane fade" id="recibidos" role="tabpanel">
                <div class="table-responsive">
                    <table class="table table-comunicados table-bordered align-middle">
                        <thead>
                        <tr>
                            <th>#</th>
                            <th>Título</th>
                            <th>Remitente</th>
                            <th>Estado</th>
                            <th>Acciones</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="com" items="${comunicadosRecibidos}" varStatus="i">
                            <tr>
                                <td>${i.index + 1}</td>
                                <td>${com.titulo}</td>
                                <td>${com.remitente}</td>
                                <td>
                                    <span class="badge ${com.estado eq 'Vigente' ? 'badge-vigente' : 'badge-expirado'}">${com.estado}</span>
                                </td>
                                <td>
                                    <button class="btn btn-sm btn-outline-primary"
                                            title="Ver"
                                            data-bs-toggle="modal"
                                            data-bs-target="#modalVerComunicado"
                                            data-titulo="${com.titulo}"
                                            data-remitente="${com.remitente}"
                                            data-estado="${com.estado}"
                                            data-fechainicio="${com.fecInicio}"
                                            data-fechafin="${com.fecFin}"
                                            data-contenido="${com.contenido}"
                                            data-archivo="${com.archivo}">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty comunicadosRecibidos}">
                            <tr>
                                <td colspan="5" class="text-center text-muted">No se encontraron comunicados recibidos.</td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL VER COMUNICADO -->
    <div class="modal fade" id="modalVerComunicado" tabindex="-1" aria-labelledby="modalVerComunicadoLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content rounded-4 overflow-hidden">
                <!-- Header personalizado -->
                <div class="modal-header" style="background: #110D59;">
                    <h5 class="modal-title fw-bold text-white" id="modalVerComunicadoLabel">
                        <i class="fas fa-bullhorn me-2"></i> Detalle de Comunicado
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body px-4 py-4">
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <h6 class="fw-bold mb-1 text-secondary"><i class="fas fa-user-edit me-1"></i> Emisor</h6>
                            <div><span class="fw-semibold">Remitente:</span> <span id="verRemitenteDestinatario"></span></div>
                            <div><span class="fw-semibold">Fecha:</span> <span id="verFechaInicio"></span> al <span id="verFechaFin"></span></div>
                            <div><span class="fw-semibold">Estado:</span> <span id="verEstado"></span></div>
                        </div>
                        <div class="col-md-6" id="verDestinoSection">
                            <h6 class="fw-bold mb-1 text-secondary"><i class="fas fa-users-class me-1"></i> Destino</h6>
                            <div><span class="fw-semibold">Nivel / Grado / Sección:</span> <span id="verNivelGradoSeccion"></span></div>
                            <div><span class="fw-semibold">Curso:</span> <span id="verCurso"></span></div>
                            <div><span class="fw-semibold">Destinatario:</span> <span id="verDestinatario"></span></div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <h6 class="fw-bold mb-1 text-secondary"><i class="fas fa-book-open me-1"></i> Título</h6>
                        <div id="verTitulo" class="fs-5 fw-semibold"></div>
                    </div>
                    <div class="mb-3">
                        <h6 class="fw-bold mb-1 text-secondary"><i class="fas fa-align-left me-1"></i> Contenido</h6>
                        <div class="border rounded-3 p-3 bg-light" id="verContenido" style="min-height: 80px;"></div>
                    </div>
                    <div class="mb-2">
                        <span class="fw-semibold"><i class="fas fa-paperclip me-1"></i> Archivo adjunto:</span>
                        <span id="verArchivo"></span>
                    </div>
                </div>
                <div class="modal-footer border-0 pt-2 pb-4">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-1"></i> Cerrar
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL EDITAR COMUNICADO -->
    <div class="modal fade" id="modalEditarComunicado" tabindex="-1" aria-labelledby="modalEditarComunicadoLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content rounded-4 overflow-hidden">
                <div class="modal-header" style="background: #110D59;">
                    <h5 class="modal-title fw-bold text-white" id="modalEditarComunicadoLabel">
                        <i class="fas fa-edit me-2"></i> Editar Comunicado
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form id="formEditarComunicado" method="post" action="${pageContext.request.contextPath}/comunicados" enctype="multipart/form-data" autocomplete="off">
                    <input type="hidden" name="action" value="editarGuardar"/>
                    <input type="hidden" id="editarIdComunicado" name="id_publicacion" value=""/>
                    <div class="modal-body px-4 py-4">
                        <div class="row mb-4">
                            <div class="col-md-4">
                                <h6 class="fw-bold text-secondary mb-1"><i class="fas fa-users-class me-1"></i> Nivel / Grado / Sección</h6>
                                <input type="text" class="form-control-plaintext ps-0 fw-semibold" id="editarNivelGradoSeccion" readonly>
                            </div>
                            <div class="col-md-4">
                                <h6 class="fw-bold text-secondary mb-1"><i class="fas fa-book me-1"></i> Curso</h6>
                                <input type="text" class="form-control-plaintext ps-0 fw-semibold" id="editarCurso" readonly>
                            </div>
                            <div class="col-md-4">
                                <h6 class="fw-bold text-secondary mb-1"><i class="fas fa-user-friends me-1"></i> Destinatario</h6>
                                <input type="text" class="form-control-plaintext ps-0 fw-semibold" id="editarDestinatario" readonly>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="fw-semibold" for="editarTitulo"><i class="fas fa-heading me-1"></i> Título</label>
                            <input type="text" class="form-control" id="editarTitulo" name="titulo" maxlength="80" required>
                        </div>
                        <div class="mb-3">
                            <label class="fw-semibold" for="editarContenido"><i class="fas fa-align-left me-1"></i> Contenido</label>
                            <textarea class="form-control" id="editarContenido" name="contenido" rows="4" maxlength="500" required></textarea>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="fw-semibold" for="editarFecInicio"><i class="fas fa-calendar-day me-1"></i> Fecha inicio</label>
                                <input type="date" class="form-control" id="editarFecInicio" name="fec_inicio" required>
                            </div>
                            <div class="col-md-6">
                                <label class="fw-semibold" for="editarFecFin"><i class="fas fa-calendar-check me-1"></i> Fecha fin</label>
                                <input type="date" class="form-control" id="editarFecFin" name="fec_fin" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="fw-semibold" for="editarArchivo"><i class="fas fa-paperclip me-1"></i> Archivo adjunto</label>
                            <input type="file" class="form-control" id="editarArchivo" name="archivo" accept=".pdf,.jpg,.jpeg,.png">
                            <div class="form-text">Máx. 5MB. Formatos: PDF, JPG, PNG. Si no adjuntas uno nuevo, se mantiene el archivo actual.</div>
                            <div id="editarArchivoActual" class="mt-2"></div>
                        </div>
                        <div class="mb-3 form-check">
                            <input type="checkbox" class="form-check-input" id="editarNotificar" name="notificar_correo">
                            <label class="form-check-label" for="editarNotificar">Notificar por correo electrónico</label>
                        </div>
                    </div>
                    <div class="modal-footer border-0 pt-2 pb-4">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i> Guardar Cambios
                        </button>
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-1"></i> Cancelar
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <jsp:include page="/includes/footer.jsp" />
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Bootstrap tooltips
    document.addEventListener('DOMContentLoaded', function () {
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        tooltipTriggerList.forEach(function (tooltipTriggerEl) {
            new bootstrap.Tooltip(tooltipTriggerEl)
        });
    });

    // Acción para botón "Nuevo Comunicado"
    document.getElementById('btnNuevoComunicado').addEventListener('click', function() {
        window.location.href = "${pageContext.request.contextPath}/comunicados?action=crear";
    });

    // Lógica para cargar datos en el modal "Ver Comunicado"
    document.querySelectorAll('button[title="Ver"]').forEach(function(btn) {
        btn.addEventListener('click', function () {
            // Datos básicos
            document.getElementById('verTitulo').textContent = btn.dataset.titulo || '';
            document.getElementById('verRemitenteDestinatario').textContent = btn.dataset.remitente || '';
            document.getElementById('verEstado').textContent = btn.dataset.estado || '';
            document.getElementById('verFechaInicio').textContent = btn.dataset.fechainicio || '';
            document.getElementById('verFechaFin').textContent = btn.dataset.fechafin || '';
            document.getElementById('verContenido').textContent = btn.dataset.contenido || '';
            document.getElementById('verArchivo').innerHTML = btn.dataset.archivo
                ? `<a href="${btn.dataset.archivo}" target="_blank">${btn.dataset.archivo}</a>` : "Sin archivo adjunto";
            // Datos destino
            var nivelGradoSeccion = btn.dataset.nivelgradoseccion || '';
            var curso = btn.dataset.curso || '';
            var destinatario = btn.dataset.destinatario || '';
            document.getElementById('verNivelGradoSeccion').textContent = nivelGradoSeccion;
            document.getElementById('verCurso').textContent = curso;
            document.getElementById('verDestinatario').textContent = destinatario;
            // Mostrar u ocultar la sección destino según si hay datos
            var destinoSection = document.getElementById('verDestinoSection');
            if (!nivelGradoSeccion && !curso && !destinatario) {
                destinoSection.style.display = 'none';
            } else {
                destinoSection.style.display = '';
            }
        });
    });

    // Lógica para cargar datos en el modal "Editar Comunicado"
    document.querySelectorAll('button[title="Editar"]').forEach(function(btn) {
        btn.addEventListener('click', function () {
            document.getElementById('editarIdComunicado').value = btn.dataset.id || '';
            document.getElementById('editarNivelGradoSeccion').value = btn.dataset.nivelgradoseccion || '';
            document.getElementById('editarCurso').value = btn.dataset.curso || '';
            document.getElementById('editarDestinatario').value = btn.dataset.destinatario || '';
            document.getElementById('editarTitulo').value = btn.dataset.titulo || '';
            document.getElementById('editarContenido').value = btn.dataset.contenido || '';
            document.getElementById('editarFecInicio').value = btn.dataset.fecinicio || '';
            document.getElementById('editarFecFin').value = btn.dataset.fecfin || '';
            document.getElementById('editarArchivoActual').innerHTML = btn.dataset.archivo
                ? `<a href='${btn.dataset.archivo}' target='_blank'>Archivo actual</a>` : "Sin archivo";
            document.getElementById('editarNotificar').checked = (btn.dataset.notificar === "true");
            // Muestra el modal
            var modal = new bootstrap.Modal(document.getElementById('modalEditarComunicado'));
            modal.show();
        });
    });
</script>
</body>
</html>
