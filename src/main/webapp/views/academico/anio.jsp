<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <c:set var="paginaActiva" value="Años Lectivos" scope="request"/>
    <jsp:include page="/includes/meta.jsp" />
    <title>Gestión de Años Lectivos - Intranet Escolar</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet">
</head>
<body class="admin-dashboard" data-context-path="${pageContext.request.contextPath}">

<jsp:include page="/includes/sidebar.jsp" />
<c:set var="tituloPaginaDesktop" value="Años Lectivos" scope="request" />
<c:set var="tituloPaginaMobile" value="Años Lectivos" scope="request" />
<c:set var="iconoPagina" value="fas fa-calendar" scope="request" />
<jsp:include page="/includes/header.jsp" />

<main class="main-content">
    <div class="row mb-4">
        <div class="col-12">
            <div class="card">
                <div class="card-header d-flex justify-content-end gap-2">
                    <button type="button"
                            class="btn btn-admin-primary btn-sm btn-uniform"
                            data-bs-toggle="modal"
                            data-bs-target="#modalCrearAnio">
                        <i class="fas fa-plus me-1"></i>
                        <span class="d-none d-sm-inline">Nuevo</span> Año Lectivo
                    </button>
                </div>
            </div>
        </div>
    </div>
    <!-- Tabla de años lectivos -->
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body table-responsive">
                    <table id="tablaAnios" class="table table-hover align-middle nowrap">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>Año</th>
                                <th>Inicio</th>
                                <th>Fin</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="a" items="${anios}" varStatus="s">
                                <tr>
                                    <td>${s.index + 1}</td>
                                    <td>${fn:escapeXml(a.nombre)}</td>
                                    <td><fmt:formatDate value="${a.fecInicio}" pattern="dd/MM/yyyy"/></td>
                                    <td><fmt:formatDate value="${a.fecFin}" pattern="dd/MM/yyyy"/></td>
                                    <td>
                                        <span class="badge
                                            ${a.estado == 'activo' ? 'bg-success'
                                            : a.estado == 'preparacion' ? 'bg-warning'
                                            : a.estado == 'cerrado' ? 'bg-danger'
                                            : 'bg-secondary'}">
                                            ${fn:toUpperCase(a.estado)}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="btn-group" role="group">
                                            <button class="btn btn-sm btn-outline-warning btn-editar"
                                                    data-id="${a.idAnioLectivo}"
                                                    data-nombre="${fn:escapeXml(a.nombre)}"
                                                    data-fechainicio="<fmt:formatDate value='${a.fecInicio}' pattern='yyyy-MM-dd'/>"
                                                    data-fechafin="<fmt:formatDate value='${a.fecFin}' pattern='yyyy-MM-dd'/>"
                                                    data-estado="${a.estado}"
                                                    data-bs-toggle="tooltip"
                                                    data-bs-placement="top"
                                                    title="Editar año lectivo">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-danger btn-cerrar"
                                                    data-id="${a.idAnioLectivo}"
                                                    data-nombre="${fn:escapeXml(a.nombre)}"
                                                    ${a.estado == 'cerrado' ? 'disabled' : ''}
                                                    data-bs-toggle="tooltip"
                                                    data-bs-placement="top"
                                                    title="Cerrar año lectivo">
                                                <i class="fas fa-lock"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-success btn-reactivar"
                                                    data-id="${a.idAnioLectivo}"
                                                    data-nombre="${fn:escapeXml(a.nombre)}"
                                                    ${a.estado != 'cerrado' ? 'disabled' : ''}
                                                    data-bs-toggle="tooltip"
                                                    data-bs-placement="top"
                                                    title="Reactivar año lectivo">
                                                <i class="fas fa-undo"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal: Crear Año Lectivo -->
    <div class="modal fade" id="modalCrearAnio" tabindex="-1">
        <div class="modal-dialog">
            <form id="formCrearAnio" action="${pageContext.request.contextPath}/anios" method="post" class="modal-content">
                <input type="hidden" name="action" value="crear" />
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-plus"></i> Nuevo Año Lectivo</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="nombreCrear" class="form-label">Nombre del año</label>
                        <input type="text" class="form-control" id="nombreCrear" name="nombre"
                               maxlength="9" placeholder="Ejemplo: 2026" required pattern="[0-9]{4,9}">
                    </div>
                    <div class="mb-3">
                        <label for="fecInicioCrear" class="form-label">Fecha de Inicio</label>
                        <input type="date" class="form-control" id="fecInicioCrear" name="fecInicio" required>
                    </div>
                    <div class="mb-3">
                        <label for="fecFinCrear" class="form-label">Fecha de Fin</label>
                        <input type="date" class="form-control" id="fecFinCrear" name="fecFin" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-danger btn-sm btn-uniform" data-bs-dismiss="modal">
                        <i class="fas fa-times me-1"></i>Cancelar
                    </button>
                    <button type="submit" class="btn btn-admin-primary btn-uniform">
                        <i class="fas fa-save me-1"></i> Guardar
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Modal: Editar Año Lectivo -->
    <div class="modal fade" id="modalEditarAnio" tabindex="-1">
        <div class="modal-dialog">
            <form id="formEditarAnio" action="${pageContext.request.contextPath}/anios" method="post" class="modal-content">
                <input type="hidden" name="action" value="editar" />
                <input type="hidden" id="idAnioEditar" name="idAnioLectivo" />
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-edit"></i> Editar Año Lectivo</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="nombreEditar" class="form-label">Nombre del año</label>
                        <input type="text" class="form-control" id="nombreEditar" name="nombre"
                               maxlength="9" required pattern="[0-9]{4,9}">
                    </div>
                    <div class="mb-3">
                        <label for="fecInicioEditar" class="form-label">Fecha de Inicio</label>
                        <input type="date" class="form-control" id="fecInicioEditar" name="fecInicio" required>
                    </div>
                    <div class="mb-3">
                        <label for="fecFinEditar" class="form-label">Fecha de Fin</label>
                        <input type="date" class="form-control" id="fecFinEditar" name="fecFin" required>
                    </div>
                    <div class="mb-3">
                        <label for="estadoEditar" class="form-label">Estado</label>
                        <select class="form-select" id="estadoEditar" name="estado" required>
                            <option value="preparacion">Preparación</option>
                            <option value="activo">Activo</option>
                            <option value="cerrado">Cerrado</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-danger btn-sm btn-uniform" data-bs-dismiss="modal">
                        <i class="fas fa-times me-1"></i>Cancelar
                    </button>
                    <button type="submit" class="btn btn-admin-primary btn-uniform">
                        <i class="fas fa-save me-1"></i> Guardar cambios
                    </button>
                </div>
            </form>
        </div>
    </div>

    <jsp:include page="/includes/footer.jsp" />
</main>

<!-- Formulario invisible para cerrar/reactivar año vía POST -->
<form id="formAccionAnio" action="${pageContext.request.contextPath}/anios" method="post" style="display:none;">
    <input type="hidden" name="action" id="formAccionAnio_action" />
    <input type="hidden" name="idAnioLectivo" id="formAccionAnio_id" />
</form>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
<script>
    $(document).ready(function () {
        $('#tablaAnios').DataTable({
            ordering: false,
            language: { url: 'https://cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json' },
            pageLength: 25, lengthMenu: [[10, 25, 50, 100], [10, 25, 50, 100]],
            lengthChange: true, responsive: true
        });

        // Inicializar tooltips Bootstrap 5
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl)
        });

        // Validar fechas antes de crear o editar año lectivo
        $('#formCrearAnio, #formEditarAnio').submit(function (e) {
            const $form = $(this);
            const fecInicio = $form.find('[name="fecInicio"]').val();
            const fecFin = $form.find('[name="fecFin"]').val();
            if (fecInicio && fecFin && fecInicio >= fecFin) {
                e.preventDefault();
                Swal.fire({
                    icon: 'warning',
                    title: 'Fechas no válidas',
                    text: 'La fecha de inicio debe ser anterior a la fecha de fin.',
                    confirmButtonColor: '#d33'
                });
                return false;
            }
        });

        // Modal Editar Año
        $('.btn-editar').click(function () {
            const btn = $(this);
            $('#idAnioEditar').val(btn.data('id'));
            $('#nombreEditar').val(btn.data('nombre'));
            $('#fecInicioEditar').val(btn.data('fechainicio'));
            $('#fecFinEditar').val(btn.data('fechafin'));
            $('#estadoEditar').val(btn.data('estado'));
            $('#modalEditarAnio').modal('show');
        });

        // Cerrar año lectivo (por POST)
        $('.btn-cerrar').click(function () {
            const id = $(this).data('id');
            const nombre = $(this).data('nombre');
            Swal.fire({
                title: '¿Cerrar año lectivo?',
                text: 'Al cerrar el año lectivo "' + nombre + '", no se podrán registrar ni editar datos en él.',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Sí, cerrar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    $('#formAccionAnio_action').val('cerrar');
                    $('#formAccionAnio_id').val(id);
                    $('#formAccionAnio').submit();
                }
            });
        });

        // Reactivar año lectivo (por POST)
        $('.btn-reactivar').click(function () {
            const id = $(this).data('id');
            const nombre = $(this).data('nombre');
            Swal.fire({
                title: '¿Reactivar año lectivo?',
                text: 'El año lectivo "' + nombre + '" volverá a estar disponible para gestión.',
                icon: 'info',
                showCancelButton: true,
                confirmButtonColor: '#198754',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Sí, reactivar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    $('#formAccionAnio_action').val('reactivar');
                    $('#formAccionAnio_id').val(id);
                    $('#formAccionAnio').submit();
                }
            });
        });

        // SweetAlert2 mensajes personalizados por acción (op)
        <c:if test="${not empty param.success}">
            <c:choose>
                <c:when test="${param.success == '1' && param.op == 'add'}">
                    Swal.fire({
                        icon: 'success',
                        title: '¡Año lectivo creado!',
                        text: 'El año lectivo fue registrado exitosamente.',
                        timer: 2000,
                        showConfirmButton: false
                    });
                </c:when>
                <c:when test="${param.success == '1' && param.op == 'edit'}">
                    Swal.fire({
                        icon: 'success',
                        title: '¡Cambios guardados!',
                        text: 'El año lectivo fue actualizado correctamente.',
                        timer: 2000,
                        showConfirmButton: false
                    });
                </c:when>
                <c:when test="${param.success == '1' && param.op == 'cerrar'}">
                    Swal.fire({
                        icon: 'info',
                        title: 'Año lectivo cerrado',
                        text: 'El año lectivo se cerró y ya no se puede modificar ni registrar datos en él.',
                        timer: 2200,
                        showConfirmButton: false
                    });
                </c:when>
                <c:when test="${param.success == '1' && param.op == 'reactivar'}">
                    Swal.fire({
                        icon: 'success',
                        title: 'Año lectivo reactivado',
                        text: 'El año lectivo fue habilitado nuevamente para gestión.',
                        timer: 2000,
                        showConfirmButton: false
                    });
                </c:when>
            </c:choose>
        </c:if>
        <c:if test="${not empty param.error}">
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: '${param.error}',
                timer: 3000,
                showConfirmButton: false
            });
        </c:if>
    });
</script>
</body>
</html>
