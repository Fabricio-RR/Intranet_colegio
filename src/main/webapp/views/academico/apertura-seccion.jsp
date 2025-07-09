<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <c:set var="paginaActiva" value="Apertura de Sección" scope="request"/>
    <jsp:include page="/includes/meta.jsp" />
    <title>Apertura de Sección - Intranet Escolar</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet">
</head>
<body class="admin-dashboard" data-context-path="${pageContext.request.contextPath}">

<jsp:include page="/includes/sidebar.jsp" />
<c:set var="tituloPaginaDesktop" value="Apertura de Sección" scope="request" />
<c:set var="tituloPaginaMobile" value="Apertura Sección" scope="request" />
<c:set var="iconoPagina" value="fas fa-door-open" scope="request" />
<jsp:include page="/includes/header.jsp" />

<main class="main-content">
    <!-- Encabezado -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card">
                <div class="card-header d-flex flex-wrap justify-content-between align-items-center gap-3">
                    <div class="d-flex align-items-center gap-2 ">
                        <label for="anioLectivo" class="mb-0 fw-semibold" style="white-space: nowrap;">Año Lectivo:</label>
                        <select id="anioLectivo" class="form-select form-select-sm" style="min-width: 120px;"
                                onchange="location.href='${pageContext.request.contextPath}/apertura-seccion?idAnioLectivo='+this.value">
                            <c:forEach var="anio" items="${anios}">
                                <option value="${anio.idAnioLectivo}" ${anio.idAnioLectivo == anioActual ? 'selected' : ''}>${anio.nombre}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="card-header d-flex justify-content-end gap-2">
                        <button type="button"
                                class="btn btn-admin-primary btn-sm btn-uniform"
                                data-bs-toggle="modal"
                                data-bs-target="#modalCrearApertura">
                            <i class="fas fa-plus me-1"></i>
                            <span class="d-none d-sm-inline">Nueva</span> Apertura
                        </button>
                    </div>
                </div> 
            </div>
        </div>
    </div>

    <!-- Tabla de aperturas -->
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body table-responsive">
                    <table id="tablaAperturas" class="table table-hover align-middle nowrap">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>Nivel</th>
                                <th>Grado</th>
                                <th>Sección</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="a" items="${aperturas}" varStatus="s">
                                <tr>
                                    <td>${s.index + 1}</td>
                                    <td>${fn:escapeXml(a.nivel)}</td>
                                    <td>${fn:escapeXml(a.grado)}</td>
                                    <td>${fn:escapeXml(a.seccion)}</td>
                                    <td>
                                        <span class="badge ${a.activo ? 'bg-success' : 'bg-danger'}">
                                            ${a.activo ? 'Activo' : 'Inactivo'}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="btn-group" role="group">
                                            <button class="btn btn-sm btn-outline-warning btn-editar"
                                                    data-id="${a.idAperturaSeccion}"
                                                    data-nivel="${fn:escapeXml(a.nivel)}"
                                                    data-grado="${fn:escapeXml(a.grado)}"
                                                    data-idgrado="${a.idGrado}"
                                                    data-seccion="${fn:escapeXml(a.seccion)}"
                                                    data-idseccion="${a.idSeccion}"
                                                    ${!a.activo ? 'disabled' : ''} 
                                                    title="Editar"
                                                    data-bs-toggle="tooltip" data-bs-placement="top">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-danger btn-desactivar"
                                                    data-id="${a.idAperturaSeccion}" ${!a.activo ? 'disabled' : ''}
                                                    title="Desactivar"
                                                    data-bs-toggle="tooltip" data-bs-placement="top">
                                                <i class="fas fa-ban"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-success btn-reactivar"
                                                    data-id="${a.idAperturaSeccion}" ${a.activo ? 'disabled' : ''}
                                                    title="Reactivar"
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

    <!-- Modal: Crear Apertura -->
    <div class="modal fade" id="modalCrearApertura" tabindex="-1">
        <div class="modal-dialog">
            <form id="formCrearApertura" action="${pageContext.request.contextPath}/apertura-seccion" method="post" class="modal-content">
                <input type="hidden" name="action" value="crear" />
                <input type="hidden" name="idAnioLectivo" id="crearIdAnioLectivo" value="${idAnioLectivo}" />
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-plus"></i> Nueva Apertura de Sección</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="nivelCrear" class="form-label">Nivel</label>
                        <select id="nivelCrear" name="idNivel" class="form-select" required>
                            <option value="">Seleccione</option>
                            <c:forEach var="n" items="${niveles}">
                                <option value="${n.idNivel}">${fn:escapeXml(n.nombre)}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="gradoCrear" class="form-label">Grado</label>
                        <select id="gradoCrear" name="idGrado" class="form-select" required>
                            <option value="">Seleccione</option>
                            <c:forEach var="g" items="${grados}">
                                <option value="${g.idGrado}">${fn:escapeXml(g.nombre)}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="seccionCrear" class="form-label">Sección</label>
                        <select id="seccionCrear" name="idSeccion" class="form-select" required>
                            <option value="">Seleccione</option>
                            <c:forEach var="s" items="${secciones}">
                                <option value="${s.idSeccion}">${fn:escapeXml(s.nombre)}</option>
                            </c:forEach>
                        </select>
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

    <!-- Modal: Editar Apertura -->
    <div class="modal fade" id="modalEditarApertura" tabindex="-1">
        <div class="modal-dialog">
            <form id="formEditarApertura" action="${pageContext.request.contextPath}/apertura-seccion" method="post" class="modal-content">
                <input type="hidden" name="action" value="editar" />
                <input type="hidden" name="idApertura" id="editarIdApertura" />
                <input type="hidden" name="idGrado" id="editarIdGrado" />
                <input type="hidden" name="idAnioLectivo" id="editarIdAnioLectivo" value="${idAnioLectivo}" />
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-edit"></i> Editar Apertura de Sección</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Nivel</label>
                        <input type="text" class="form-control" id="editarNivel" readonly>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Grado</label>
                        <input type="text" class="form-control" id="editarGradoNombre" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="editarSeccion" class="form-label">Sección</label>
                        <select id="editarSeccion" name="idSeccion" class="form-select" required>
                            <option value="">Seleccione</option>
                            <c:forEach var="s" items="${secciones}">
                                <option value="${s.idSeccion}">${fn:escapeXml(s.nombre)}</option>
                            </c:forEach>
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

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
<script>
    $(document).ready(function () {
        $('#tablaAperturas').DataTable({
            ordering: false,
            language: { url: 'https://cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json' },
            pageLength: 25, lengthMenu: [[10, 25, 50, 100], [10, 25, 50, 100]],
            lengthChange: true, responsive: true
        });

        // Modal Editar
        $(document).on('click', '.btn-editar', function () {
            const btn = $(this);
            $('#editarIdApertura').val(btn.data('id'));
            $('#editarIdGrado').val(btn.data('idgrado'));
            $('#editarNivel').val(btn.data('nivel'));
            $('#editarGradoNombre').val(btn.data('grado'));
            $('#editarSeccion').val(btn.data('idseccion'));
            // El año lectivo en editar también se debe actualizar
            $('#editarIdAnioLectivo').val($('#anioLectivo').val());
            $('#modalEditarApertura').modal('show');
        });

        // Desactivar apertura
        $('.btn-desactivar').click(function () {
            const id = $(this).data('id');
            const idAnioLectivo = $('#anioLectivo').val();
            Swal.fire({
                title: '¿Desactivar apertura?',
                text: "La apertura ya no podrá ser utilizada para matrícula o asignación.",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Sí, desactivar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = '${pageContext.request.contextPath}/apertura-seccion?action=desactivar&id=' + id + '&idAnioLectivo=' + idAnioLectivo;
                }
            });
        });

        // Reactivar apertura
        $('.btn-reactivar').click(function () {
            const id = $(this).data('id');
            const idAnioLectivo = $('#anioLectivo').val();
            Swal.fire({
                title: '¿Reactivar apertura?',
                text: "¿Está seguro que desea reactivar esta apertura de sección?",
                icon: 'info',
                showCancelButton: true,
                confirmButtonColor: '#198754',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Sí, reactivar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = '${pageContext.request.contextPath}/apertura-seccion?action=reactivar&id=' + id + '&idAnioLectivo=' + idAnioLectivo;
                }
            });
        });

        // Mensajes SweetAlert2
        <c:if test="${not empty param.success}">
            <c:choose>
                <c:when test="${param.success == '1' && param.op == 'add'}">
                    Swal.fire({
                        icon: 'success',
                        title: 'Apertura creada',
                        text: 'Se registró la apertura correctamente.',
                        timer: 2200,
                        showConfirmButton: false
                    });
                </c:when>
                <c:when test="${param.success == '1' && param.op == 'edit'}">
                    Swal.fire({
                        icon: 'success',
                        title: 'Apertura editada',
                        text: 'Se actualizó la apertura correctamente.',
                        timer: 2200,
                        showConfirmButton: false
                    });
                </c:when>
                <c:when test="${param.success == '1' && param.op == 'deactivate'}">
                    Swal.fire({
                        icon: 'info',
                        title: 'Apertura desactivada',
                        text: 'La apertura fue desactivada correctamente.',
                        timer: 2200,
                        showConfirmButton: false
                    });
                </c:when>
                <c:when test="${param.success == '1' && param.op == 'reactivate'}">
                    Swal.fire({
                        icon: 'success',
                        title: 'Apertura reactivada',
                        text: 'La apertura fue reactivada correctamente.',
                        timer: 2200,
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
