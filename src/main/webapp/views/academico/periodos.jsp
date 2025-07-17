<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <c:set var="paginaActiva" value="Periodos Académicos" scope="request"/>
    <jsp:include page="/includes/meta.jsp" />
    <title>Periodos Académicos - Intranet Escolar</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet">
</head>
<body class="admin-dashboard" data-context-path="${pageContext.request.contextPath}">

<jsp:include page="/includes/sidebar.jsp" />
<c:set var="tituloPaginaDesktop" value="Periodos Académicos" scope="request" />
<c:set var="tituloPaginaMobile" value="Periodos Académicos" scope="request" />
<c:set var="iconoPagina" value="fas fa-calendar-alt" scope="request" />
<jsp:include page="/includes/header.jsp" />

<main class="main-content">

    <div class="card mb-4">
        <div class="col-12">
            <div class="card">
                <div class="card-header d-flex flex-wrap justify-content-between align-items-center gap-3">
                    <div class="d-flex align-items-center gap-2">
                        <label for="anioLectivo" class="mb-0 fw-semibold" style="white-space: nowrap;">Año Lectivo:</label>
                        <select id="anioLectivo" class="form-select form-select-sm" style="min-width: 120px;"
                                onchange="location.href='${pageContext.request.contextPath}/periodos?idAnioLectivo='+this.value">
                            <c:forEach var="anio" items="${anios}">
                                <option value="${anio.idAnioLectivo}" ${anio.idAnioLectivo == anioActual ? 'selected' : ''}>${anio.nombre}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div>
                        <button type="button"
                                class="btn btn-admin-primary btn-sm btn-uniform"
                                data-bs-toggle="modal"
                                data-bs-target="#modalCrearPeriodo">
                            <i class="fas fa-plus me-1"></i>
                            <span class="d-none d-sm-inline">Nuevo</span> Periodo
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body table-responsive">
                    <table id="tablaPeriodos" class="table table-hover align-middle nowrap">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>Bimestre</th>
                                <th>Mes</th>
                                <th>Tipo</th>
                                <th>Fecha Inicio</th>
                                <th>Fecha Fin</th>
                                <th>Fecha Cierre</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${periodos}" varStatus="s">
                                <tr>
                                    <td>${s.index + 1}</td>
                                    <td>${p.bimestre}</td>
                                    <td>${p.mes}</td>
                                    <td>${p.tipo}</td>
                                    <td><fmt:formatDate value="${p.fecInicio}" pattern="dd/MM/yyyy"/></td>
                                    <td><fmt:formatDate value="${p.fecFin}" pattern="dd/MM/yyyy"/></td>
                                    <td><fmt:formatDate value="${p.fecCierre}" pattern="dd/MM/yyyy"/></td>
                                    <td>
                                        <span class="badge
                                            ${p.estado == 'habilitado' ? 'bg-success'
                                            : p.estado == 'borrador' ? 'bg-warning'
                                            : p.estado == 'cerrado' ? 'bg-danger'
                                            : 'bg-secondary'}">
                                            ${fn:toUpperCase(p.estado)}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="btn-group" role="group">
                                            <button class="btn btn-sm btn-outline-warning btn-editar"
                                                    data-id="${p.idPeriodo}"
                                                    data-bimestre="${p.bimestre}"
                                                    data-mes="${p.mes}"
                                                    data-tipo="${p.tipo}"
                                                    data-fechainicio="<fmt:formatDate value='${p.fecInicio}' pattern='yyyy-MM-dd'/>"
                                                    data-fechafin="<fmt:formatDate value='${p.fecFin}' pattern='yyyy-MM-dd'/>"
                                                    data-fechacierre="<fmt:formatDate value='${p.fecCierre}' pattern='yyyy-MM-dd'/>"
                                                    data-estado="${p.estado}"
                                                    ${p.estado == 'cerrado' ? 'disabled' : ''}
                                                    title="Editar"
                                                    data-bs-toggle="tooltip" data-bs-placement="top">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-danger btn-cerrar"
                                                    data-id="${p.idPeriodo}" ${p.estado == 'cerrado' ? 'disabled' : ''}
                                                    title="Cerrar periodo"
                                                    data-bs-toggle="tooltip" data-bs-placement="top">
                                                <i class="fas fa-lock"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-success btn-habilitar"
                                                    data-id="${p.idPeriodo}" ${p.estado == 'habilitado' ? 'disabled' : ''}
                                                    title="Habilitar periodo"
                                                    data-bs-toggle="tooltip" data-bs-placement="top">
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

            <!-- Modal: Crear Periodo -->
            <div class="modal fade" id="modalCrearPeriodo" tabindex="-1">
                <div class="modal-dialog">
                    <form id="formCrearPeriodo" action="${pageContext.request.contextPath}/periodos" method="post" class="modal-content">
                        <input type="hidden" name="action" value="crear" />
                        <input type="hidden" name="idAnioLectivo" id="crearIdAnioLectivo" value="${anioActual}" />
                        <div class="modal-header">
                            <h5 class="modal-title"><i class="fas fa-plus"></i> Nuevo Periodo Académico</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label for="bimestreCrear" class="form-label">Bimestre</label>
                                <select id="bimestreCrear" name="bimestre" class="form-select" required>
                                    <option value="">Seleccione</option>
                                    <option value="I">I</option>
                                    <option value="II">II</option>
                                    <option value="III">III</option>
                                    <option value="IV">IV</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="mesCrear" class="form-label">Mes</label>
                                <select id="mesCrear" name="mes" class="form-select" required>
                                    <option value="">Seleccione</option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="tipoCrear" class="form-label">Tipo</label>
                                <select id="tipoCrear" name="tipo" class="form-select" required>
                                    <option value="">Seleccione</option>
                                    <option value="bimestral">Bimestral</option>
                                    <option value="mensual">Mensual</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="fecInicioCrear" class="form-label">Fecha Inicio</label>
                                <input type="date" id="fecInicioCrear" name="fecInicio" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label for="fecFinCrear" class="form-label">Fecha Fin</label>
                                <input type="date" id="fecFinCrear" name="fecFin" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label for="fecCierreCrear" class="form-label">Fecha Cierre</label>
                                <input type="date" id="fecCierreCrear" name="fecCierre" class="form-control" required>
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

            <!-- Modal: Editar Periodo -->
            <div class="modal fade" id="modalEditarPeriodo" tabindex="-1">
                <div class="modal-dialog">
                    <form id="formEditarPeriodo" action="${pageContext.request.contextPath}/periodos" method="post" class="modal-content">
                        <input type="hidden" name="action" value="editar" />
                        <input type="hidden" name="idPeriodo" id="editarIdPeriodo" />
                        <input type="hidden" name="idAnioLectivo" id="editarIdAnioLectivo" value="${anioActual}" />
                        <div class="modal-header">
                            <h5 class="modal-title"><i class="fas fa-edit"></i> Editar Periodo Académico</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label for="bimestreEditar" class="form-label">Bimestre</label>
                                <select id="bimestreEditar" name="bimestre" class="form-select" required>
                                    <option value="">Seleccione</option>
                                    <option value="I">I</option>
                                    <option value="II">II</option>
                                    <option value="III">III</option>
                                    <option value="IV">IV</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="mesEditar" class="form-label">Mes</label>
                                <select id="mesEditar" name="mes" class="form-select" required>
                                    <option value="">Seleccione</option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="tipoEditar" class="form-label">Tipo</label>
                                <select id="tipoEditar" name="tipo" class="form-select" required>
                                    <option value="">Seleccione</option>
                                    <option value="bimestral">Bimestral</option>
                                    <option value="mensual">Mensual</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="fecInicioEditar" class="form-label">Fecha Inicio</label>
                                <input type="date" id="fecInicioEditar" name="fecInicio" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label for="fecFinEditar" class="form-label">Fecha Fin</label>
                                <input type="date" id="fecFinEditar" name="fecFin" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label for="fecCierreEditar" class="form-label">Fecha Cierre</label>
                                <input type="date" id="fecCierreEditar" name="fecCierre" class="form-control" required>
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
        </div>
    </div>

    <jsp:include page="/includes/footer.jsp" />
</main>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
<script>
    $(document).ready(function () {
        $('#tablaPeriodos').DataTable({
            ordering: false,
            language: { url: 'https://cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json' },
            pageLength: 25, lengthMenu: [[10, 25, 50, 100], [10, 25, 50, 100]],
            lengthChange: true, responsive: true
        });

        // Modal Editar Periodo
        $(document).on('click', '.btn-editar', function () {
            const btn = $(this);
            $('#editarIdPeriodo').val(btn.data('id'));
            $('#bimestreEditar').val(btn.data('bimestre'));
            $('#mesEditar').val(btn.data('mes'));
            $('#tipoEditar').val(btn.data('tipo'));
            $('#fecInicioEditar').val(btn.data('fechainicio'));
            $('#fecFinEditar').val(btn.data('fechafin'));
            $('#fecCierreEditar').val(btn.data('fechacierre'));
            $('#editarIdAnioLectivo').val($('#anioLectivo').val());
            $('#modalEditarPeriodo').modal('show');
        });

        // Cerrar periodo
        $('.btn-cerrar').click(function () {
            const id = $(this).data('id');
            const idAnioLectivo = $('#anioLectivo').val();
            Swal.fire({
                title: '¿Cerrar periodo?',
                text: "No se podrá editar ni registrar datos en este periodo.",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Sí, cerrar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = '${pageContext.request.contextPath}/periodos?action=cerrar&id=' + id + '&idAnioLectivo=' + idAnioLectivo;
                }
            });
        });

        // Habilitar periodo (reabrir)
        $('.btn-habilitar').click(function () {
            const id = $(this).data('id');
            const idAnioLectivo = $('#anioLectivo').val();
            Swal.fire({
                title: '¿Habilitar periodo?',
                text: "¿Está seguro que desea reabrir este periodo académico?",
                icon: 'info',
                showCancelButton: true,
                confirmButtonColor: '#198754',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Sí, habilitar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = '${pageContext.request.contextPath}/periodos?action=habilitar&id=' + id + '&idAnioLectivo=' + idAnioLectivo;
                }
            });
        });

        // Mensajes SweetAlert2
        <c:if test="${not empty param.success && param.op == 'add'}">
            Swal.fire({
                icon: 'success',
                title: 'Periodo creado',
                text: 'Se registró el periodo correctamente.',
                timer: 2200,
                showConfirmButton: false
            });
        </c:if>
        <c:if test="${not empty param.success && param.op == 'edit'}">
            Swal.fire({
                icon: 'success',
                title: 'Periodo editado',
                text: 'Se actualizó el periodo correctamente.',
                timer: 2200,
                showConfirmButton: false
            });
        </c:if>
        <c:if test="${not empty param.success && param.op == 'cerrar'}">
            Swal.fire({
                icon: 'info',
                title: 'Periodo cerrado',
                text: 'El periodo fue cerrado correctamente.',
                timer: 2200,
                showConfirmButton: false
            });
        </c:if>
        <c:if test="${not empty param.success && param.op == 'habilitar'}">
            Swal.fire({
                icon: 'success',
                title: 'Periodo habilitado',
                text: 'El periodo fue habilitado correctamente.',
                timer: 2200,
                showConfirmButton: false
            });
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
